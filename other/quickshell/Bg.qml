import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Effects
import "./"

PanelWindow {
    property var modelData
    screen: modelData

    exclusionMode: ExclusionMode.Ignore
    aboveWindows: false
    color: "transparent"
    anchors {
        top: true
        left: true
        bottom: true
        right: true
    }
    Image {
        id: bg
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: `./assets/${Globals.isDarkTheme ? "darkbg" : "bg"}.png`
        smooth: false
    }
    MultiEffect {
        source: bg
        anchors.fill: bg
        blurEnabled: false
        blurMax: 24
        blur: 1.0
    }

    Text {
        id: timetxt
        x: 900
        y: 150
        font.family: "BigBlueTermPlusNerdFont"
        font.pointSize: 100
        font.bold: true
        color: Globals.isDarkTheme ? "#9292B6" : "#3B2640"

        Process {
            id: dateProc
            command: ["date", "+%H %M"]
            running: true
            stdout: SplitParser {
                onRead: data => timetxt.text = data
            }
        }
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: dateProc.running = true
        }
    }
}
