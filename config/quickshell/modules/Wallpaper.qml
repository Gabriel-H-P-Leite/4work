import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io


PanelWindow {
	id: bg
	WlrLayershell.namespace: "qs-wallpaper"
	WlrLayershell.layer: WlrLayer.Background
	exclusiveZone: -1
	anchors {
		top: true
		bottom: true
		left: true
		right: true
	}
	property string wallpaperDir: "/home/noite/Imagens/Wallpapers"
	property var wallpaperList: []
	property int currentIndex: 0
	property int timerS: 5 * 60
	property string wallpaperPath: ""
	Process {
		id: listProc
		command: ["bash", "-c", "ls " + bg.wallpaperDir + "*/*/*.{jpg,jpeg,png} 2>/dev/null"]
		stdout: StdioCollector {
			onStreamFinished: {
				let files = text.trim().split("\n").filter(f => f.length > 0)
				if (files.length > 0) {
					bg.wallpaperList = files
					if (bg.wallpaperPath === "") {
						bg.wallpaperPath = files[0]
					}
				}
			}
		}
	}
	Component.onCompleted: listProc.running = true
	Timer {
		interval: bg.timerS * 1000 
		running: true
		repeat: true
		onTriggered: {
			if (bg.wallpaperList.length === 0) return
			// Sequencial:
			//bg.currentIndex = (bg.currentIndex + 1) % bg.wallpaperList.length
			//bg.wallpaperPath = bg.wallpaperList[bg.currentIndex]

			// Aleatório 
			bg.currentIndex = Math.floor(Math.random() * bg.wallpaperList.length)
			bg.wallpaperPath = bg.wallpaperList[bg.currentIndex]
		}
	}
	Image {
		anchors.fill: parent
		source: bg.wallpaperPath !== "" ? "file://" + bg.wallpaperPath : ""
		fillMode: Image.PreserveAspectCrop
		cache: false
	}
}

