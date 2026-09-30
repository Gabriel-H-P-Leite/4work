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
		if (connectionType.includes("ethernet")) return " "
		if (connectionType.includes("wifi")) return " "
		return ""
	}
	Process {
		id: netProc
		command: ["nmcli", "-t", "-f", "TYPE,NAME,STATE", "connection", "show", "--active"]
		stdout: StdioCollector {
			onStreamFinished: {
				let lines = text.trim().split("\n")
				for (let line of lines) {
					let parts = line.split(":")
					if (parts.length >= 2) {
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

	Timer {
		interval: 5000
		running: true
		repeat: true
		triggeredOnStart: true
		onTriggered: netProc.running = true
	}
	Text {
		id: txt
		anchors.centerIn: parent
		color: networkModule.textColor
		font.pixelSize: networkModule.fontSize
		text: networkModule.networkIcon()
	}
}
