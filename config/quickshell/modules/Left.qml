import QtQuick
import Quickshell
import Quickshell.Wayland
import "."

PanelWindow {
	id: left
	WlrLayershell.namespace: "qs-modulesleft"
	exclusiveZone: -1
	height: root.barH
	width: 800
	color: "transparent"
	mask: Region { item: background }
	anchors {
		top: true
		left: true
	}

	Rectangle {
		clip: true
		Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
		id: background
		color: root.back
		border.color: root.border
		border.width: 1
		bottomRightRadius: 20
		anchors {
			top: parent.top
			bottom: parent.bottom
			left: parent.left
			topMargin: -1
			leftMargin: -1
		}
		width: Math.round(row.implicitWidth + 10)

		Row {
			id: row
			anchors.left: parent.left
			anchors.leftMargin: 6
			anchors.verticalCenter: parent.verticalCenter
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
