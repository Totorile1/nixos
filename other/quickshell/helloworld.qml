import Quickshell
import QtQuick

FloatingWindow {
  visible: true
  width: 200
  height: 100

  Text {
    anchors.centerIn: parent
    // centers it within parent
    text: "Hello world!"
    color: "#0db9d7"
    font.pixelSize: 18
  }
}
