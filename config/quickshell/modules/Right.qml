import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pipewire
import "."

PanelWindow {
	WlrLayershell.namespace: "qs-modulesright"
	exclusiveZone: -1
	height: root.barH
	width: row.implicitWidth + 12
	color: "transparent"
	anchors {
		top: true
		right: true
	}
	Rectangle {
		id: background
		color: root.back
		anchors.fill: parent
		border.color: root.border
		border.width: 1
		bottomLeftRadius: 20
		anchors.topMargin: -1
		anchors.rightMargin: -1
		Row {
			id: row
			anchors.centerIn: parent
			spacing: 2
			Network {
				textColor: root.text
				fontSize: root.fontSize
				barH: root.barH
			}
			Audio {
				textColor: root.text
				fontFamily: root.fontFamily
				fontSize: root.fontSize
				barH: root.barH
			}
			Clock {
				textColor: root.text
				fontFamily: root.fontFamily
				fontSize: root.fontSize
				barH: root.barH
			}
		}
	}
}
