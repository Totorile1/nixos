pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "." as Notifs

Singleton {
    id: root

    PanelWindow {
        id: window
        visible: false
        implicitWidth: notificationCenter.width
        implicitHeight: notificationCenter.height
        anchors.right: notificationCenter.right
        anchors.top: notificationCenter.top

        Notifs.NotificationCenterView {
            id: notificationCenter
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            //width: 500
            //anchors.verticalCenter: parent.verticalCenter
        }
    }

    IpcHandler {
        target: "notifications"

        function toggle() {
            window.visible = !window.visible
            if (window.visible)
                notificationCenter.reload()
        }
    }
}
