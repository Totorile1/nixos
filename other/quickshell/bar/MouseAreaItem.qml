import QtQuick

Item {
    id: root

    property alias mouseArea: mouseArea
    property alias hoverEnabled: mouseArea.hoverEnabled
    property alias acceptedButtons: mouseArea.acceptedButtons
    property alias pressedButtons: mouseArea.pressedButtons
    property alias containsMouse: mouseArea.containsMouse
    property alias isPressed: mouseArea.pressed

    signal clicked(event: MouseEvent)
    signal entered
    signal exited
    signal pressed(event: MouseEvent)
    signal released(event: MouseEvent)
    signal wheel(event: WheelEvent)

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        Component.onCompleted: {
            this.clicked.connect(root.clicked);
            //this.entered.connect(root.entered);
            //this.exited.connect(root.exited);
            //this.pressed.connect(root.pressed);
            this.released.connect(root.released);
            //this.wheel.connect(root.wheel);
        }

        // For some reason MouseArea.pressed is both a prop and signal so connect doesn't work
        onPressed: event => root.pressed(event)

        // Connecting to onwheel seems to implicitly accept it. undo that.
        onWheel: event => {
            event.accepted = false;
            root.wheel(event);
        }
    }
}
