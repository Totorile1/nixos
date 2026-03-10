import QtQuick
import QtQuick.Effects
import Quickshell.Services.UPower
import Qt5Compat.GraphicalEffects

Item {
    id: root

    required property var bar

    readonly property var chargeState: UPower.displayDevice.state
    readonly property bool isCharging: chargeState == UPowerDeviceState.Charging
    readonly property bool isPluggedIn: isCharging || chargeState == UPowerDeviceState.PendingCharge
    readonly property real percentage: UPower.displayDevice.percentage
    readonly property bool isLow: percentage <= 0.20
    readonly property bool isLaptop: UPowerDevice.isLaptopBattery
    width: 32
    height: 32

    Image {
        id: mask
        source: "../assets/battery-mask.png"
        smooth: false
        anchors.fill: parent
        visible: false
    }

    Rectangle {
        id: progressBar
        anchors.fill: parent
        color: "black"
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: root.isLaptop ? root.percentage * parent.height : parent.height
            color: root.isLaptop ? (root.isLow ? "red" : "#EEA939") : "#EEA939"
        }
        visible: false
    }
    OpacityMask {
        id: pBarMask
        anchors.fill: progressBar
        source: progressBar
        maskSource: mask
    }
    MultiEffect {
        source: pBarMask
        anchors.fill: pBarMask
        brightness: root.isCharging ? 0.3 : 0
        blur: 1.0
        blurEnabled: root.isCharging
    }
}
