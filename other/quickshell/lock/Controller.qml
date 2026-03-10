pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import "." as Lock

Singleton {
    Process {
        id: screencopyCmd
        running: false
        command: ["grim", "-s", "0.5", "-t", "jpeg", "/tmp/lock_screencopy.jpeg"]
        onExited: lock.locked = true
    }
    IpcHandler {
        target: "lockscreen"

        function lock(): void {
            screencopyCmd.running = true;
        }
    }

    WlSessionLock {
        id: lock
        locked: false

        WlSessionLockSurface {
            id: lockSurface
            color: "transparent"
            Lock.Surface {
                anchors.fill: parent
                context: lockContext
            }
        }
    }

    Lock.Context {
        id: lockContext
        onUnlocked: lock.locked = false
    }

    // Empty function to define first reference to singleton
    function init() {
    }
}
