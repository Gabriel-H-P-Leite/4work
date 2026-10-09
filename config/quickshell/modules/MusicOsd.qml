import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
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
	property string artUrl: ""
	
	property real progresso: 0
	Process {
		id: mpcProc
		command: ["mpc", "status", "%percenttime%"]
		stdout: StdioCollector { onStreamFinished: osd.progresso = (parseInt(this.text) || 0) / 100 }
	}
	Timer {
		interval: 1000
		running: osd.shown && !!osd.player && osd.player.dbusName.includes("mpd")
		repeat: true
		triggeredOnStart: true
		onTriggered: mpcProc.running = true
	}

	// limpa e recoloca o endereço: força a Image a ler o arquivo de novo
	// mesmo quando o player repete o mesmo caminho pra músicas diferentes
	function refreshArt() {
		osd.artUrl = ""
		Qt.callLater(() => osd.artUrl = osd.player ? osd.player.trackArtUrl : "")
	}
	function trigger() {
		if (!osd.armed || !osd.hasTrack) return
		osd.shown = true
		hideTimer.restart()
		if (osd.player) osd.player.positionChanged()
	}
	// aparece quando troca a música, o play/pause ou o volume do player muda
	Connections {
		target: osd.player
		function onTrackTitleChanged() { osd.trigger() }
		function onPlaybackStateChanged() { osd.trigger() }
		function onVolumeChanged() { osd.trigger() }
		function onTrackArtUrlChanged() { osd.refreshArt() }
		function onUniqueIdChanged() {
			osd.refreshArt()
			osd.progresso = 0
			mpcProc.running = true
		}
	}

	// evita o OSD piscar quando o shell sobe ou o player aparece/troca
	onPlayerChanged: {
		osd.armed = false
		armTimer.restart()
		osd.refreshArt()
		osd.progresso = 0
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

			// animação
			opacity: osd.shown ? 1 : 0
			y: osd.shown ? 0 : 18
			scale: osd.shown ? 1 : 0.95
			Behavior on opacity { NumberAnimation { duration: 180 } }
			Behavior on y { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
			Behavior on scale { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

			//Progresso mpd
			ClippingRectangle {
				id: progressBar
				anchors.fill: parent
				radius: parent.radius
				color: "transparent"
				Rectangle {
					height: parent.height
					radius: parent.radius
					width: parent.width * osd.progresso
					color: Qt.rgba(1, 1, 1, 0.1)
					Behavior on width { NumberAnimation { duration: 1000; easing.type: Easing.Linear } }
				}
			}
			// capa do álbum com o play/pause por cima
			ClippingRectangle {
				id: cover
				anchors.left: parent.left
				anchors.leftMargin: 10
				anchors.verticalCenter: parent.verticalCenter
				width: 50
				height: 50
				radius: 12
				color: Qt.rgba(1, 1, 1, 0.1) 
				Image {
					id: art
					anchors.fill: parent
					source: osd.artUrl
					sourceSize: Qt.size(100, 100)
					fillMode: Image.PreserveAspectCrop
					asynchronous: true
					// alguns players reaproveitam o mesmo arquivo pra capas diferentes
					cache: false
					opacity: status === Image.Ready ? 1 : 0
					Behavior on opacity { NumberAnimation { duration: 200 } }
				}
				Text {
					id: icon
					anchors.centerIn: parent
					text: osd.playing ? "󰐊" : "󰏤"
					color: "white"
					opacity: art.status === Image.Ready ? 0.3 : 0.3
					font.family: root.iconFont
					style: Text.Outline
					styleColor: Qt.rgba(0, 0, 0, 0.3)
					font.pixelSize: 22
				}
			}
			Column {
				anchors.left: cover.right
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
						text: "󰕾"
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
