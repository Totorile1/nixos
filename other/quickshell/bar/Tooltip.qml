pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import "root:/"

Scope {
    id: root
    required property var bar

    property TooltipItem activeTooltip: null
    property TooltipItem activeMenu: null

    readonly property TooltipItem activeItem: activeMenu ?? activeTooltip
    property TooltipItem lastActiveItem: null
    readonly property TooltipItem shownItem: activeItem ?? lastActiveItem
    property real hangTime: lastActiveItem?.hangTime ?? 0

    property Item tooltipItem: null

    onActiveItemChanged: {
        if (activeItem != null) {
            hangTimer.stop();
            activeItem.targetVisible = true;

            if (tooltipItem) {
                activeItem.parent = tooltipItem;
            }
        }

        if (lastActiveItem != null && lastActiveItem != activeItem) {
            if (activeItem != null)
                lastActiveItem.targetVisible = false;
            else if (root.hangTime == 0)
                doLastHide();
            else
                hangTimer.start();
        }

        if (activeItem != null)
            lastActiveItem = activeItem;
    }

    function setItem(item: TooltipItem) {
        if (item.isMenu) {
            activeMenu = item;
        } else {
            activeTooltip = item;
        }
    }

    function removeItem(item: TooltipItem) {
        if (item.isMenu && activeMenu == item) {
            activeMenu = null;
        } else if (!item.isMenu && activeTooltip == item) {
            activeTooltip = null;
        }
    }

    function doLastHide() {
        lastActiveItem.targetVisible = false;
    }

    function onHidden(item: TooltipItem) {
        if (item == lastActiveItem) {
            lastActiveItem = null;
        }
    }

    Timer {
        id: hangTimer
        interval: root.hangTime
        onTriggered: root.doLastHide()
    }

    property real scaleMul: lastActiveItem && lastActiveItem.targetVisible ? 1 : 0
    Behavior on scaleMul {
        SmoothedAnimation {
            velocity: 5
        }
    }

    LazyLoader {
        id: popupLoader
        activeAsync: root.shownItem != null

        PopupWindow {
            id: popup

            anchor {
                window: root.bar
                rect.y: root.bar.tooltipYOffset
                adjustment: PopupAdjustment.None
            }

            HyprlandWindow.opacity: root.scaleMul

            HyprlandWindow.visibleMask: Region {
                id: visibleMask
                item: tooltipItem
            }

            Connections {
                target: root

                function onScaleMulChanged() {
                    visibleMask.changed();
                }
            }

            //height: bar.height
            //implicitWidth: Math.max(700, tooltipItem.largestAnimWidth) // max due to qtwayland glitches
            //implicitHeight: Math.max(700, tooltipItem.largestAnimHeight) // max due to qtwayland glitches
            visible: true
            color: "transparent"
            //color: "#20ff0000"

            mask: Region {
                item: (shownItem?.hoverable ?? false) ? tooltipItem : null
            }

            HyprlandFocusGrab {
                active: activeItem?.isMenu ?? false
                windows: [popup, bar, ...(activeItem?.grabWindows ?? [])]
                onActiveChanged: {
                    if (!active && activeItem?.isMenu) {
                        activeMenu.close();
                    }
                }
            }

            Item {
                id: tooltipItem
                Component.onCompleted: {
                    root.tooltipItem = this;
                    if (root.shownItem) {
                        root.shownItem.parent = this;
                    }

                    //highestAnimY = targetY - targetHeight / 2;
                    //lowestAnimY = targetY + targetHeight / 2;
                }

                transform: Scale {
                    origin.x: 0
                    origin.y: tooltipItem.height / 2
                    xScale: 0.9 + scaleMul * 0.1
                    yScale: xScale
                }

                clip: width != targetWidth || height != targetHeight

                // bkg
                Rectangle {
                    anchors.fill: parent
                    color: "#3B253F"
                }

                readonly property var targetWidth: shownItem?.implicitWidth ?? 0
                readonly property var targetHeight: shownItem?.implicitHeight ?? 0

                readonly property real targetY: {
                    if (shownItem == null)
                        return 0;
                    const target = bar.contentItem.mapFromItem(shownItem.owner, 0, shownItem.targetRelativeY).y;
                    return bar.boundedY(target, shownItem.implicitHeight / 2);
                }
                readonly property real targetX: {
                    if (root.shownItem == null)
                        return 0;
                    const target = root.bar.contentItem.mapFromItem(root.shownItem.owner, 0, root.shownItem.targetRelativeX).x;
                    return root.bar.boundedX(target, root.shownItem.implicitWidth / 2);
                }

                property var w: -1
                implicitWidth: Math.max(1, w)

                property var y1: -1
                property var y2: -1

                y: y1 - popup.anchor.rect.y
                height: y2 - y1

                readonly property bool anyAnimsRunning: y1Anim.running || y2Anim.running || widthAnim.running

                onAnyAnimsRunningChanged: {
                    if (!anyAnimsRunning) {
                        largestAnimWidth = targetWidth;
                        //highestAnimY = y1;
                        //lowestAnimY = y2;
                    }
                }

                SmoothedAnimation on y1 {
                    id: y1Anim
                    to: tooltipItem.targetY - tooltipItem.targetHeight / 2
                    onToChanged: {
                        if (tooltipItem.y1 == -1 || !(shownItem?.animateSize ?? true)) {
                            stop();
                            tooltipItem.y1 = to;
                        } else {
                            velocity = (Math.max(tooltipItem.y1, to) - Math.min(tooltipItem.y1, to)) * 5;
                            restart();
                        }
                    }
                }

                SmoothedAnimation on y2 {
                    id: y2Anim
                    to: tooltipItem.targetY + tooltipItem.targetHeight / 2
                    onToChanged: {
                        if (tooltipItem.y2 == -1 || !(shownItem?.animateSize ?? true)) {
                            stop();
                            tooltipItem.y2 = to;
                        } else {
                            velocity = (Math.max(tooltipItem.y2, to) - Math.min(tooltipItem.y2, to)) * 5;
                            restart();
                        }
                    }
                }

                SmoothedAnimation on w {
                    id: widthAnim
                    to: tooltipItem.targetWidth
                    onToChanged: {
                        if (tooltipItem.w == -1 || !(shownItem?.animateSize ?? true)) {
                            stop();
                            tooltipItem.w = to;
                        } else {
                            velocity = (Math.max(tooltipItem.width, to) - Math.min(tooltipItem.width, to)) * 5;
                            restart();
                        }
                    }
                }
            }
        }
    }
}
