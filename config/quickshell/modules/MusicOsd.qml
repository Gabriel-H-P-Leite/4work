import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris

Scope {
	id: osd
	property int hideMs: 2500
	property bool shown: false
	property bool armed: false

	// mesmo critério do Music.qml: prefere o mpd, senão o primeiro player
	property var player: {
		for (let p of Mpris.players.values) {
			if (p.dbusName.includes("mpd")) return p
		}
		return Mpris.players.values[0] || null
	}
	property bool playing: player ? player.playbackState === MprisPlaybackState.Playing : false
	property bool hasTrack: !!(player && player.trackTitle)
	property bool volumeOk: player ? player.volumeSupported : false
	property real volume: (player && player.volumeSupported && !isNaN(player.volume)) ? player.volume : 0

	function trigger() {
		if (!osd.armed || !osd.hasTrack) return
		osd.shown = true
		hideTimer.restart()
	}

	// aparece quando troca a música, o play/pause ou o volume do player muda
	Connections {
		target: osd.player
		function onTrackTitleChanged() { osd.trigger() }
		function onPlaybackStateChanged() { osd.trigger() }
		function onVolumeChanged() { osd.trigger() }
	}

	// evita o OSD piscar quando o shell sobe ou o player aparece/troca
	onPlayerChanged: {
		osd.armed = false
		armTimer.restart()
	}
	Timer { id: armTimer; interval: 1500; running: true; onTriggered: osd.armed = true }
	Timer { id: hideTimer; interval: osd.hideMs; onTriggered: osd.shown = false }

	PanelWindow {
		id: win
		WlrLayershell.namespace: "qs-music-osd"
		WlrLayershell.layer: WlrLayer.Overlay
		exclusiveZone: -1
		color: "transparent"
		anchors.left: true
		margins.left: 5
		anchors.top: true
		margins.top: root.barH + 5
		implicitWidth: 300
		implicitHeight: 90
		visible: card.opacity > 0
		mask: Region {}

		Rectangle {
			id: card
			width: parent.width
			height: 70
			radius: 20
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

			Text {
				id: icon
				anchors.left: parent.left
				anchors.leftMargin: 16
				anchors.verticalCenter: parent.verticalCenter
				width: 24
				horizontalAlignment: Text.AlignHCenter
				text: osd.playing ? "󰐊" : "󰏤"
				color: root.text
				font.family: root.iconFont
				font.pixelSize: 20
			}

			Column {
				anchors.left: icon.right
				anchors.leftMargin: 12
				anchors.right: parent.right
				anchors.rightMargin: 16
				anchors.verticalCenter: parent.verticalCenter
				spacing: 1

				Text {
					width: parent.width
					elide: Text.ElideRight
					text: osd.hasTrack ? osd.player.trackTitle : ""
					color: root.text
					font.family: root.fontFamily
					font.pixelSize: 14
				}
				Text {
					width: parent.width
					elide: Text.ElideRight
					text: osd.hasTrack ? osd.player.trackArtist : ""
					color: Qt.rgba(1, 1, 1, 0.65)
					font.family: root.fontFamily
					font.pixelSize: 12
				}

				// barra de volume do player
				Row {
					width: parent.width
					height: 14
					spacing: 8
					visible: osd.volumeOk

					Text {
						anchors.verticalCenter: parent.verticalCenter
						width: 10
						horizontalAlignment: Text.AlignLeft
						text: "󰝚"
						color: root.text
						font.family: root.fontFamily
						font.pixelSize: 11
					}
					Rectangle {
						anchors.verticalCenter: parent.verticalCenter
						width: parent.width - 36 - parent.spacing
						height: 6
						radius: 3
						color: Qt.rgba(1, 1, 1, 0.15)

						Rectangle {
							height: parent.height
							radius: parent.radius
							width: parent.width * Math.min(1, osd.volume)
							color: root.text
							Behavior on width { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
						}
					}
					Text {
						anchors.verticalCenter: parent.verticalCenter
						// largura fixa pro "5%" e o "100%" não mexerem na barra
						width: 25
						horizontalAlignment: Text.AlignRight
						text: Math.round(osd.volume * 100) + "%"
						color: root.text
						font.family: root.fontFamily
						font.pixelSize: 11
					}
				}
			}
		}
	}
}
