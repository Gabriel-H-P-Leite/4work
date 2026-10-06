import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

// Estado único (lista, índice, timer, IPC); cada monitor só desenha o wallpaperPath
Scope {
	id: bg
	property string wallpaperDir: Quickshell.env("HOME") + "/Imagens/Wallpapers/"
	property var wallpaperList: []
	property int currentIndex: 0
	property int timerS: 5 * 60
	property int fadeMs: 800
	property string wallpaperPath: ""

	Process {
		id: listProc
		command: ["bash", "-c", "ls " + bg.wallpaperDir + "*.{jpg,jpeg,png} 2>/dev/null"]
		running: true
		stdout: StdioCollector {
			onStreamFinished: {
				let files = text.trim().split("\n").filter(f => f.length > 0)
				if (files.length > 0) {
					bg.wallpaperList = files
					if (bg.wallpaperPath === "") bg.wallpaperPath = files[0]
				}
			}
		}
	}

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
			const i = bg.wallpaperList.indexOf(path)
			if (i >= 0) bg.currentIndex = i
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

	// Uma janela por monitor
	Variants {
		model: Quickshell.screens

		delegate: PanelWindow {
			id: win
			required property var modelData
			screen: modelData

			WlrLayershell.namespace: "qs-wallpaper"
			WlrLayershell.layer: WlrLayer.Background
			exclusiveZone: -1
			anchors {
				top: true
				bottom: true
				left: true
				right: true
			}
			color: "black"

			property var front: imgA

			// quando o caminho muda, carrega na imagem que está escondida
			Connections {
				target: bg
				function onWallpaperPathChanged() { win.load() }
			}
			// monitor conectado depois (ou ao recarregar): já carrega o atual
			Component.onCompleted: load()

			function load() {
				const target = win.front === imgA ? imgB : imgA
				target.source = bg.wallpaperPath !== "" ? "file://" + bg.wallpaperPath : ""
			}

			// coloca a imagem nova por cima e faz ela aparecer
			function crossfade(img) {
				const old = win.front
				img.opacity = 0
				img.z = 1
				old.z = 0
				win.front = img
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
				onFinished: (win.front === imgA ? imgB : imgA).source = ""
			}

			Image {
				id: imgA
				anchors.fill: parent
				sourceSize.width: win.screen.width
				sourceSize.height: win.screen.height
				fillMode: Image.PreserveAspectCrop
				asynchronous: true
				cache: false
				onStatusChanged: if (status === Image.Ready && imgA !== win.front) win.crossfade(imgA)
			}
			Image {
				id: imgB
				anchors.fill: parent
				sourceSize.width: win.screen.width
				sourceSize.height: win.screen.height
				fillMode: Image.PreserveAspectCrop
				asynchronous: true
				cache: false
				onStatusChanged: if (status === Image.Ready && imgB !== win.front) win.crossfade(imgB)
			}
		}
	}
}
