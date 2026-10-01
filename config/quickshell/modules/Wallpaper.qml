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
	property string wallpaperDir: Quickshell.env("HOME") + "/Imagens/Wallpapers/"
	property var wallpaperList: []
	property int currentIndex: 0
	property int timerS: 5 * 60
	property string wallpaperPath: ""
	Process {
		id: listProc
		command: ["bash", "-c", "ls " + bg.wallpaperDir + "*.{jpg,jpeg,png} 2>/dev/null"]
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
	function next() {
		if (bg.wallpaperList.length === 0) return
		bg.currentIndex = (bg.currentIndex + 1) % bg.wallpaperList.length
		bg.wallpaperPath = bg.wallpaperList[bg.currentIndex]
		changeTimer.restart()
	}
	function previous() {
		if (bg.wallpaperList.length === 0) return
		bg.currentIndex = (bg.currentIndex - 1 + bg.wallpaperList.length) % bg.wallpaperList.length
		bg.wallpaperPath = bg.wallpaperList[bg.currentIndex]
		changeTimer.restart()
	}
	function random() {
		if (bg.wallpaperList.length < 2) return
		let i
		do { i = Math.floor(Math.random() * bg.wallpaperList.length) } while (i === bg.currentIndex)
		bg.currentIndex = i
		bg.wallpaperPath = bg.wallpaperList[i]
		changeTimer.restart()
	}
	IpcHandler {
		target: "wallpaper"
		function next(): string { bg.next(); return "" }
		function previous(): string { bg.previous(); return "" }
		function random(): string { bg.random(); return "" }
		function set(path: string): string {
			bg.wallpaperPath = path
			changeTimer.restart()
			return ""
		}
	}
	Timer {
		id: changeTimer
		interval: bg.timerS * 1000
		running: true
		repeat: true
		onTriggered: bg.next()
	}
	color: "black"
	property int fadeMs: 800
	property var front: imgA
	// quando o caminho muda, carrega na imagem que está escondida
	onWallpaperPathChanged: {
		const target = bg.front === imgA ? imgB : imgA
		target.source = bg.wallpaperPath !== "" ? "file://" + bg.wallpaperPath : ""
	}
	// coloca a imagem nova por cima e faz ela aparecer
	function crossfade(img) {
		const old = bg.front
		img.opacity = 0
		img.z = 1
		old.z = 0
		bg.front = img
		fade.target = img
		fade.restart()
	}
	NumberAnimation {
		id: fade
		property: "opacity"
		from: 0
		to: 1
		duration: bg.fadeMs
		easing.type: Easing.InOutQuad
		// depois do fade, libera a imagem antiga da memória
		onFinished: (bg.front === imgA ? imgB : imgA).source = ""
	}
	component WallImage: Image {
		anchors.fill: parent
		sourceSize.width: bg.screen.width
		sourceSize.height: bg.screen.height
		fillMode: Image.PreserveAspectCrop
		asynchronous: true
		cache: false
		onStatusChanged: if (status === Image.Ready && this !== bg.front) bg.crossfade(this)
	}
	WallImage { id: imgA }
	WallImage { id: imgB }
}

