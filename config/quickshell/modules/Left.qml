import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import "."

PanelWindow {
	WlrLayershell.namespace: "qs-modulesleft"
	exclusiveZone: -1
	height: root.barH
	width: row.implicitWidth + 10
	color: "transparent"
	anchors {
		top: true
		left: true
	}
	Rectangle {
		id: background
		color: root.back
		anchors.fill: parent
		border.color: root.border
		border.width: 1
		bottomRightRadius: 20
		anchors.topMargin: -1
		anchors.leftMargin: -1
		Row {
			id: row
			anchors.centerIn: parent
			spacing: 2
			Menu {
				textColor: root.text
				fontSize: 20
				barH: root.barH
			}
			Music {
				textColor: root.text
				fontSize: 10
				barH: root.barH
			}
		}
	}
}

