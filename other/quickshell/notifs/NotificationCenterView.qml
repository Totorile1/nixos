import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../theme" as Theme

Rectangle {
    id: root
    width: 500
    height: 1000
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    color: Theme.Colors.notificationCenterColor1
    visible: false

    ListModel {
        id: notificationsModel
    }

    function toggleNotificationCenter() {
        root.visible = !root.visible
        if (root.visible)
            reload()
    }

    FileView {
        id: historyFile
        path: Quickshell.env("HOME") + "/.cache/notify_history"
        blockLoading: true
    }

    function reload() {
        notificationsModel.clear()

        var text = historyFile.text()
        if (!text || text.length === 0)
            return

        var lines = text.split("\n")
        var i = 1

        while (i < lines.length) {

            var app = lines[i++] || ""
            var title = lines[i++] || ""
            var bodyLines = []

            while (i < lines.length && !/^\d{2}:\d{2}:\d{2}$/.test(lines[i])) {
                bodyLines.push(lines[i++])
            }

            if (i >= lines.length)
                break

            var time = lines[i++] || ""
            var urgency = lines[i++] || "normal"
            var body = bodyLines.join("\n")

            notificationsModel.append({
                app: app,
                title: title,
                body: body,
                time: time,
                urgency: urgency
            })
        }
    }

    Component.onCompleted: reload()
    ListView {
    id: listView
    anchors.fill: parent
    model: notificationsModel
    spacing: 10
    clip: true

    Component.onCompleted: {
        console.log("DISPLAY DEBUG: ListView created")
        console.log("DISPLAY DEBUG: Model count =", notificationsModel.count)
        console.log("DISPLAY DEBUG: View width =", width, "height =", height)
    }

    onCountChanged: {
        console.log("DISPLAY DEBUG: ListView count changed ->", count)
    }

    delegate: Rectangle {
        width: ListView.view.width
        color: "transparent"
        border.color: "transparent"
        border.width: 1
        radius: 4

        Component.onCompleted: {
            console.log("DISPLAY DEBUG: Delegate created")
            console.log("DISPLAY DEBUG: app =", app)
            console.log("DISPLAY DEBUG: title =", title)
            console.log("DISPLAY DEBUG: body =", body)
            console.log("DISPLAY DEBUG: delegate width =", width)
            console.log("DISPLAY DEBUG: delegate height=", height)
        }

        Column {
            id: columnContent
            //anchors.fill: parent
            anchors.margins: 8
            spacing: 4

            Text {
                text: time + " | " + app
                color: "black"
                width: ListView.view.width - 16 
                Component.onCompleted: {
                    console.log("DISPLAY DEBUG: time/app text created:", text)
                }
            }

            Text {
                text: title
                color: "black"
                font.bold: true
                wrapMode: Text.Wrap
                width: ListView.view.width - 16 
                Component.onCompleted: {
                    console.log("DISPLAY DEBUG: title text created:", text)
                }
            }

            Text {
                text: body
                color: "black"
                wrapMode: Text.Wrap
                width: ListView.view.width - 16 
                Component.onCompleted: {
                    console.log("DISPLAY DEBUG: body text created:", text)
                }
            }
          }
      height: 100 + columnContent.implicitHeight // necessary gives the height for the delegate
    }
  }
}
