import QtQuick
import Quickshell
import Quickshell.Io

Rectangle {
	id: networkModule
	property color textColor: "white"
	property int fontSize: 15
	property int barH: 33
	property string connectionName: ""
	property string connectionType: ""
	height: barH
	width: txt.implicitWidth + 12
	color: "transparent"

	function networkIcon() {
		if (connectionType.includes("ethernet")) return ""
		if (connectionType.includes("wireless") || connectionType.includes("wifi")) return "󰖩"
		return ""
	}
	// Consulta a conexão ativa (roda uma vez no início e depois só quando algo muda)
	Process {
		id: netProc
		command: ["nmcli", "-t", "-f", "TYPE,NAME", "connection", "show", "--active"]
		running: true
		stdout: StdioCollector {
			onStreamFinished: {
				let lines = text.trim().split("\n")
				for (let line of lines) {
					let parts = line.split(":")
					// ignora interfaces virtuais (loopback, bridges do docker etc.)
					if (parts.length >= 2 && !["loopback", "bridge", "tun"].includes(parts[0])) {
						networkModule.connectionType = parts[0].toLowerCase()
						networkModule.connectionName = parts[1]
						return
					}
				}
				networkModule.connectionType = ""
				networkModule.connectionName = ""
			}
		}
	}
	// Fica escutando o NetworkManager e avisa quando qualquer coisa muda
	Process {
		id: monitorProc
		command: ["nmcli", "monitor"]
		running: true
		stdout: SplitParser {
			onRead: data => debounce.restart()
		}
		// se o nmcli monitor morrer (ex: NetworkManager reiniciou), sobe de novo
		onExited: restartTimer.start()
	}
	// nmcli monitor solta várias linhas por mudança; espera acalmar e consulta uma vez só
	Timer {
		id: debounce
		interval: 500
		onTriggered: netProc.running = true
	}
	Timer {
		id: restartTimer
		interval: 3000
		onTriggered: monitorProc.running = true
	}
	Text {
		id: txt
		anchors.centerIn: parent
		color: networkModule.textColor
		font.pixelSize: networkModule.fontSize
		text: networkModule.networkIcon()
		font.family: root.iconFont
	}
}
