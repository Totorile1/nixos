import QtQuick

BarButton {
    id: root
    property alias image: img.source
    property alias mirror: img.mirror
    implicitWidth: 24
    implicitHeight: 24
    Image {
        id: img
        anchors.fill: parent
        smooth: false
        scale: root.containsMouse ? 0.9 : 1
        Behavior on scale {
            NumberAnimation {
                duration: 70
            }
        }
    }
}
