import QtQuick
import Quickshell
import QtQuick.Layouts
import "../"

MouseArea {
    id: root

    implicitWidth: 26
    implicitHeight: 26

    hoverEnabled: true
    acceptedButtons: Qt.LeftButton

    Image {
        anchors.fill: parent
        source: `../assets/${Globals.isDarkTheme ? "sun" : "moon"}.png`
        smooth: false

        scale: root.containsMouse ? 0.9 : 1
        Behavior on scale {
            NumberAnimation {
                duration: 70
            }
        }
    }

    onPressed: () => {
        Globals.isDarkTheme = !Globals.isDarkTheme;
    }
}
