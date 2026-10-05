import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Rectangle {
	id: menuModule
	property color textColor: "white"
	property string fontFamily: root.iconFont
	property int fontSize: 15
	property int barH: 33

	height: barH
	width: volRow.implicitWidth
	color: "transparent"
	MouseArea {
		anchors.fill: parent
		onClicked: root.toggleLauncher()
		cursorShape: Qt.PointingHandCursor
	}
	Row {
		id: volRow
		anchors.centerIn: parent
		spacing: 4
		rightPadding: 7
		Text {
			text: ""
			color: menuModule.textColor
			font.family: menuModule.fontFamily
			font.pixelSize: menuModule.fontSize
		}
	}
}
