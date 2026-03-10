pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.Fusion
import Quickshell.Wayland
import Quickshell
import "." as Lock

Rectangle {
    id: root
    required property Lock.Context context

    color: "black"

    Image {
        id: chest
        anchors.centerIn: parent
        source: "../assets/chest.png"
        sourceClipRect: Qt.rect(32, 0, 32, 32)
        smooth: false
        height: width

        // Rectangles
        RowLayout {
            visible: passwordBox.enabled
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 31
            spacing: 31
            Repeater {
                model: 6
                delegate: Rectangle {
                    id: r
                    required property var modelData
                    color: root.context.showFailure ? "#D6568F" : "#6BCBF3"
                    implicitWidth: 31
                    implicitHeight: 31
                    MultiEffect {
                        id: glow
                        source: parent
                        anchors.fill: parent
                        brightness: passwordBox.length > r.modelData ? 0.7 : 0
                        blur: passwordBox.length > r.modelData ? 2.0 : 0
                        blurEnabled: true
                    }
                }
            }
        }

        Image {
            id: screencopy
            anchors.centerIn: parent
            source: "/tmp/lock_screencopy.jpeg"
            height: width * (9 / 16) // Width is animated below
        }

        Image {
            id: chestInFront
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: parent.width / 2
            source: "../assets/chest.png"
            sourceClipRect: Qt.rect(32, 16, 32, 16)
            smooth: false
            visible: false
            z: 9999
        }
    }

    // Enter anim
    // ------------

    // Screencopy anim
    NumberAnimation {
        target: screencopy
        property: "width"
        from: 1920
        to: 250
        duration: 700
        easing.type: Easing.OutBack
        easing.overshoot: 0.9
        running: true
    }
    SequentialAnimation {
        id: screencopyAnim
        running: true
        NumberAnimation {
            target: screencopy
            property: "anchors.verticalCenterOffset"
            to: -150
            duration: 500
            easing.type: Easing.OutBack
        }
        PauseAnimation {
            duration: 200
        }
        PropertyAction {
            target: chestInFront
            property: "visible"
            value: true
        }
        NumberAnimation {
            target: screencopy
            property: "anchors.verticalCenterOffset"
            to: 100
            duration: 300
            easing.type: Easing.Linear
        }
    }

    // Chest anim
    SequentialAnimation {
        id: chestAnim
        running: true
        NumberAnimation {
            target: chest
            property: "width"
            from: 2000
            to: 500
            duration: 500
            easing.type: Easing.OutBack
            running: true
        }
        PauseAnimation {
            duration: 500
        }
        PropertyAction {
            target: chest
            property: "sourceClipRect.x"
            value: 0
        }
        PropertyAction {
            target: chestInFront
            property: "visible"
            value: false
        }
        PropertyAction {
            target: screencopy
            property: "visible"
            value: false
        }
        NumberAnimation {
            onStarted: screencopy.visible = false
            target: chest
            property: "anchors.verticalCenterOffset"
            to: 50
            duration: 100
            easing.type: Easing.OutBack
        }
        NumberAnimation {
            target: chest
            property: "anchors.verticalCenterOffset"
            to: 0
            duration: 100
            easing.type: Easing.OutBack
        }
    }

    // Exit anim
    // ------------

    // Screencopy anim
    SequentialAnimation {
        id: screencopyAnimExit
        running: false
        PropertyAction {
            target: chestInFront
            property: "visible"
            value: true
        }
        NumberAnimation {
            target: screencopy
            property: "anchors.verticalCenterOffset"
            to: -150
            duration: 200
            easing.type: Easing.OutBack
        }
        PropertyAction {
            target: chestInFront
            property: "visible"
            value: false
        }
        NumberAnimation {
            target: screencopy
            property: "anchors.verticalCenterOffset"
            to: 0
            duration: 400
            easing.type: Easing.OutBack
        }
        NumberAnimation {
            target: screencopy
            property: "width"
            to: 1920
            duration: 400
            easing.type: Easing.OutBack
            running: true
        }
        onFinished: () => root.context.unlocked()
    }

    // Chest anim
    SequentialAnimation {
        id: chestAnimExit
        running: false
        PropertyAction {
            target: chest
            property: "sourceClipRect.x"
            value: 32
        }
        PropertyAction {
            target: screencopy
            property: "visible"
            value: true
        }
        NumberAnimation {
            target: chest
            property: "anchors.verticalCenterOffset"
            to: -50
            duration: 100
            easing.type: Easing.OutBack
        }
        NumberAnimation {
            target: chest
            property: "anchors.verticalCenterOffset"
            to: 0
            duration: 200
            easing.type: Easing.OutBack
        }
    }

    TextField {
        id: passwordBox

        implicitWidth: 400
        font.pointSize: 50
        color: "transparent"
        cursorVisible: false
        background: Rectangle {
            color: "transparent"
        }

        focus: true
        enabled: !screencopyAnim.running && !chestAnim.running && !screencopyAnimExit.running && !chestAnimExit.running && !root.context.unlockInProgress
        opacity: 0
        echoMode: TextInput.Password
        inputMethodHints: Qt.ImhSensitiveData

        onTextChanged: () => {
            if (text != "") {
                root.context.showFailure = false;
            }
        }

        onAccepted: () => {
            root.context.currentText = text;
            root.context.tryUnlock();
        }

        Connections {
            target: root.context

            function onUnlockInProgressChanged() {
                if (root.context.unlockInProgress == false) {
                    passwordBox.text = "";
                }
            }

            function onPamSuccess() {
                screencopyAnimExit.running = true;
                chestAnimExit.running = true;
            }
        }
    }

    // Button {
    //     text: "Its not working, let me out"
    //     onClicked: root.context.unlocked()
    // }
}
