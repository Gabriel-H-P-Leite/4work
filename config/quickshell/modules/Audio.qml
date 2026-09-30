import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Rectangle {
	id: audioModule

	property color textColor: "white"
	property string fontFamily: "monospace"
	property int fontSize: 15
	property int barH: 33
	height: barH
	width: volRow.implicitWidth + 12
	color: "transparent"

	PwObjectTracker {
		objects: [Pipewire.defaultAudioSink]
	}

	property var sink: Pipewire.defaultAudioSink
	property real volume: (sink && sink.ready && sink.audio && !isNaN(sink.audio.volume)) ? sink.audio.volume : 0
	property bool muted: sink && sink.ready && sink.audio ? sink.audio.muted : false

	function volumeIcon() {
		let v = volume * 100
		if (muted) return ""
		if (v < 33) return ""
		if (v < 66) return ""
		return ""
	}

	    
	Process {
		id: pavucontrolProc
		command: ["pavucontrol"]
	}

	Row {
		id: volRow
		anchors.centerIn: parent
		spacing: 4

		Text {
			text: audioModule.volumeIcon()
			color: audioModule.textColor
			font.family: audioModule.fontFamily
			font.pixelSize: audioModule.fontSize
		}
		Text {
			text: Math.round(audioModule.volume * 100) + "%"
			color: audioModule.textColor
			font.family: audioModule.fontFamily
			font.pixelSize: audioModule.fontSize
		}
	}

	MouseArea {
		anchors.fill: parent
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		hoverEnabled: true
		onClicked: (mouse) => {
			if (mouse.button === Qt.LeftButton) {
				pavucontrolProc.running = true
			} else if (mouse.button === Qt.RightButton) {
				if (audioModule.sink) {
					audioModule.sink.audio.muted = !audioModule.sink.audio.muted
				}
			}
		}
		onWheel: (wheel) => {
			if (!audioModule.sink) return
			let step = 0.05
			let newVol = audioModule.sink.audio.volume
			if (wheel.angleDelta.y > 0) {
				newVol = Math.min(1.0, newVol + step)
			} else {
				newVol = Math.max(0.0, newVol - step)
			}
			audioModule.sink.audio.volume = newVol
		}
	}
}
