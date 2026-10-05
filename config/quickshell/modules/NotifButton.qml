import QtQuick
import Quickshell

Rectangle {
	id: notifButton
	property color textColor: "white"
	property string fontFamily: root.iconFamily
	property int fontSize: 15
	property int barH: 33

	height: barH
	width: row.implicitWidth + 12
	radius: height / 2
	// fica levemente destacado com a central aberta ou com o mouse em cima
	color: root.notifCenterOpen ? Qt.rgba(1, 1, 1, 0.15)
		: hover.hovered ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
	Behavior on color { ColorAnimation { duration: 120 } }

	Row {
		id: row
		anchors.centerIn: parent
		spacing: 4

		Text {
			anchors.verticalCenter: parent.verticalCenter
			text: root.notifDnd ? "󰂛" : (root.notifCount > 0 ? "󱅫" : "󰂚")
			color: notifButton.textColor
			opacity: root.notifDnd ? 0.6 : 1
			font.pixelSize: notifButton.fontSize
		}

		// contador: some quando não tem nada
		Text {
			anchors.verticalCenter: parent.verticalCenter
			visible: root.notifCount > 0
			text: root.notifCount > 99 ? "99+" : root.notifCount
			color: notifButton.textColor
			opacity: root.notifDnd ? 0.6 : 1
			font.family: notifButton.fontFamily
			font.pixelSize: notifButton.fontSize * 0.75
		}
	}

	HoverHandler { id: hover; cursorShape: Qt.PointingHandCursor }

	// esquerdo: abre/fecha a central | direito: não perturbe
	MouseArea {
		anchors.fill: parent
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		onClicked: mouse => {
			if (mouse.button === Qt.RightButton) root.notifDnd = !root.notifDnd
			else root.notifCenterOpen = !root.notifCenterOpen
		}
	}
}
