import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
	id: splash
	WlrLayershell.namespace: "qs-splash"
	WlrLayershell.layer: WlrLayer.Bottom
	exclusiveZone: -1
	color: "transparent"
	anchors.bottom: true
	margins.bottom: 5
	implicitWidth: 800
	implicitHeight: label.implicitHeight + 20
	visible: current !== ""
	mask: Region { item: label }

	property int fontSize: 17
	property int rotateMs: 60 * 1000
	property var phrases: []
	property int index: -1
	readonly property string current: (index >= 0 && index < phrases.length) ? phrases[index] : ""

	function next() {
		const n = phrases.length
		if (n === 0) return
		if (n === 1) { index = 0; return }
		let i
		do { i = Math.floor(Math.random() * n) } while (i === index)
		index = i
	}
	FileView {
		path: Quickshell.shellPath("splash.txt")
		watchChanges: true
		onFileChanged: reload()
		onLoaded: {
			splash.phrases = text().split("\n")
				.map(l => l.trim())
				.filter(l => l !== "" && !l.startsWith("#"))
			splash.next()
		}
	}
	Timer {
		interval: splash.rotateMs
		running: splash.phrases.length > 1
		repeat: true
		onTriggered: splash.next()
	}
	onCurrentChanged: fade.restart()
	NumberAnimation { id: fade; target: label; property: "opacity"; from: 0; to: 1; duration: 400 }
	Text {
		id: label
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 10
		width: 720
		horizontalAlignment: Text.AlignHCenter
		wrapMode: Text.WordWrap
		text: splash.current
		color: Qt.rgba(1, 1, 1, 1)
		style: Text.Outline
		styleColor: Qt.rgba(0, 0, 0, 1)
		font.family: root.fontFamily
		font.pixelSize: splash.fontSize
		font.italic: true
		MouseArea {
			anchors.fill: parent
			cursorShape: Qt.PointingHandCursor
			onClicked: splash.next()
		}
	}
}
