import QtQuick
import Quickshell
import Quickshell.Wayland
import "."

PanelWindow {
	id: right
	WlrLayershell.namespace: "qs-modulesright"
	exclusiveZone: -1
	height: root.barH
	width: 800
	mask: Region { item: background }
	color: "transparent"
	anchors {
		top: true
		right: true
	}
	Rectangle {
		id: background
		color: root.back
		border.color: root.border
		border.width: 1
		bottomLeftRadius: 20
		anchors {
			top: parent.top
			bottom: parent.bottom
			right: parent.right
			topMargin: -1
			rightMargin: -1
		}
		width: Math.round(row.implicitWidth + 20)
		clip: true
		Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
		Row {
			id: row
			anchors.right: parent.right
			anchors.rightMargin: 10
			anchors.verticalCenter: parent.verticalCenter
			spacing: 2
			Tray {
				textColor: root.text
				iconSize: 15
				barH: root.barH
			}
			NotifButton {
				textColor: root.text
				fontSize: 15
				barH: root.barH
			}
			Network {
				textColor: root.text
				fontSize: 15
				barH: root.barH
			}
			Audio {
				textColor: root.text
				fontSize: 15
				barH: root.barH
			}
			Clock {
				textColor: root.text
				fontSize: 15
				barH: root.barH
			}
		}
	}
}

