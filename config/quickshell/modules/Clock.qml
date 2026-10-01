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

	height: barH
	width: time.implicitWidth + 12
	color: "transparent"

	SystemClock {
		id: clock
		precision: SystemClock.Minutes
	}
	Text {
		id: time
		text: Qt.formatDateTime(clock.date,"󰥔 hh:mm")
		color: clockModule.textColor
		font.family: clockModule.fontFamily
		font.pixelSize: clockModule.fontSize
		anchors.centerIn: parent
	}
}
