import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import "../launcher" as Launcher

MouseArea {
    id: root

    implicitWidth: 26
    implicitHeight: 26

    acceptedButtons: Qt.LeftButton

    Image {
        id: img
        anchors.fill: parent
        source: "../assets/chi-ro.png"
        smooth: false
        scale: Launcher.Controller.isOpen ? 0.8 : 1
        Behavior on scale {
            NumberAnimation {
                duration: 70
            }
        }
    }
    MultiEffect {
        source: img
        anchors.fill: img
        blur: 1.0
        brightness: 0.3
        blurEnabled: true
    }

    onPressed: () => {
        Launcher.Controller.isOpen = true;
    }
}
