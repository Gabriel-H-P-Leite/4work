import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "./modules/"

ShellRoot {
	id: root
	property color text: "#ffffff"
	property color back: Qt.rgba(0, 0, 0, 0.3)
	property color border: Qt.rgba(1, 1, 1, 0.3)
	property string fontFamily: "Noto Sans"
	property string iconFont: "Symbols Nerd Font Mono"
	property int fontSize: 15
	property int barH: 33

	// estado das notificações, compartilhado entre Notifications e NotifButton
	property bool notifDnd: false
	property bool notifCenterOpen: false
	property int notifCount: 0

	IpcHandler {
		target: "toggleLauncher"
		function onTriggered(): string {
			root.toggleLauncher()
			return ""
		}
	}
	LazyLoader { active: true; component: Left {} }
	LazyLoader { active: true; component: Center {} }
	LazyLoader { active: true; component: Right {} }
	LazyLoader { active: true; component: Notifications {} }
	LazyLoader { active: true; component: Wallpaper {} }
	LazyLoader { id: launcherLoader; active: false; component: Launcher {} }
	function toggleLauncher() { launcherLoader.active = !launcherLoader.active }
	LazyLoader { active: true; component: VolumeOsd {} }
	LazyLoader { active: true; component: MusicOsd {} }
	LazyLoader { active: true; component: Splash {} }
}
