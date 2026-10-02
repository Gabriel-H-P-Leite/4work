import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire

Scope {
	id: osd
	property int hideMs: 1500
	property bool shown: false
	property bool armed: false

	PwObjectTracker { objects: [Pipewire.defaultAudioSink] }

	property var sink: Pipewire.defaultAudioSink
	property real volume: (sink && sink.ready && sink.audio && !isNaN(sink.audio.volume)) ? sink.audio.volume : 0
	property bool muted: sink && sink.ready && sink.audio ? sink.audio.muted : false

	function volumeIcon() {
		let v = osd.volume * 100
		if (osd.muted) return ""
		if (v < 10) return ""
		if (v < 51) return ""
		return ""
	}
	function trigger() {
		if (!osd.armed) return
		osd.shown = true
		hideTimer.restart()
	}
	// qualquer mudança de volume/mudo aparece: teclas, scroll na barra, pavucontrol...
	Connections {
		target: osd.sink ? osd.sink.audio : null
		function onVolumeChanged() { osd.trigger() }
		function onMutedChanged() { osd.trigger() }
	}

	onSinkChanged: {
		osd.armed = false
		armTimer.restart()
	}
	Timer { id: armTimer; interval: 1500; running: true; onTriggered: osd.armed = true }
	Timer { id: hideTimer; interval: osd.hideMs; onTriggered: osd.shown = false }

	PanelWindow {
		id: win
		WlrLayershell.namespace: "qs-osd"
		WlrLayershell.layer: WlrLayer.Overlay
		exclusiveZone: -1
		color: "transparent"
		anchors.right: true
		margins.right: 4
		anchors.top: true
		margins.top: root.barH + 4 
		implicitWidth: 300
		implicitHeight: 70
		visible: card.opacity > 0
		mask: Region {}

		Rectangle {
			id: card
			width: parent.width
			height: 52
			radius: height / 2
			color: root.back
			border.width: 1
			border.color: root.border
			anchors.horizontalCenter: parent.horizontalCenter

			// entra subindo e com fade, sai descendo
			opacity: osd.shown ? 1 : 0
			y: osd.shown ? 0 : 18
			scale: osd.shown ? 1 : 0.95
			Behavior on opacity { NumberAnimation { duration: 180 } }
			Behavior on y { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
			Behavior on scale { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

			Row {
				anchors.centerIn: parent
				spacing: 14

				Text {
					anchors.verticalCenter: parent.verticalCenter
					width: 24
					horizontalAlignment: Text.AlignHCenter
					text: osd.volumeIcon()
					color: root.text
					font.family: root.iconFont
					font.pixelSize: 20
				}

				// barra de volume
				Rectangle {
					anchors.verticalCenter: parent.verticalCenter
					width: 170
					height: 8
					radius: 4
					color: Qt.rgba(1, 1, 1, 0.15)

					Rectangle {
						height: parent.height
						radius: parent.radius
						width: parent.width * Math.min(1, osd.volume)
						color: osd.muted ? Qt.rgba(1, 1, 1, 0.35) : root.text
						Behavior on width { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
						Behavior on color { ColorAnimation { duration: 150 } }
					}
				}

				Text {
					anchors.verticalCenter: parent.verticalCenter
					// largura fixa pro "5%" e o "100%" não mexerem na barra
					width: 40
					horizontalAlignment: Text.AlignRight
					text: Math.round(osd.volume * 100) + "%"
					color: osd.muted ? Qt.rgba(1, 1, 1, 0.5) : root.text
					font.family: root.fontFamily
					font.pixelSize: 14
				}
			}
		}
	}
}
