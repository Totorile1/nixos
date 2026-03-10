pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import "." as Launcher

Singleton {
    id: root
    property bool isOpen: false
    property var lastUsedTimes: ({})

    IpcHandler {
        target: "launcher"

        function open() {
            root.isOpen = true;
        }

        function close() {
            root.isOpen = false;
        }

        function toggle() {
            root.isOpen = !root.isOpen;
        }
    }

    LazyLoader {
        active: root.isOpen
        Launcher.Overlay {
            controller: root
        }
    }

    // Empty function to define first reference to singleton
    function init() {
    }
}
