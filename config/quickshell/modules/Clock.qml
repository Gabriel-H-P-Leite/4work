import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Rectangle {
	id: clockModule
	property color textColor: "white"
	property string fontFamily: root.fontFamily
	property int fontSize: 15
	property int barH: 33
	property bool showDate: false

	height: barH
	width: time.implicitWidth + 4
	color: "transparent"

	SystemClock {
		id: clock
		precision: SystemClock.Minutes
	}
	Text {
		id: time
		text: clockModule.showDate
			? Qt.formatDateTime(clock.date, "󰃭 dd/MM/yyyy")
			: Qt.formatDateTime(clock.date, "󰥔 hh:mm")
		color: clockModule.textColor
		font.family: clockModule.fontFamily
		font.pixelSize: clockModule.fontSize
		anchors.centerIn: parent
	}
	MouseArea {
		anchors.fill: parent
		cursorShape: Qt.PointingHandCursor
		onClicked: clockModule.showDate = !clockModule.showDate
	}
}
