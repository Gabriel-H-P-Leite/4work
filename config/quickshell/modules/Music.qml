import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Rectangle {
	id: musicModule
	property color textColor: "white"
	property var fontFamily: "mono"
	property int fontSize: 15
	property int barH: 33
	property int iconSize: 10

	property var player: {
		for (let p of Mpris.players.values) {
			if (p.dbusName.includes("mpd")) return p
		}
		return Mpris.players.values[0] || null
	}
	property bool hasTrack: !!(player && player.trackTitle)
	property bool playing: player ? player.playbackState === MprisPlaybackState.Playing : false

	height: barH
	width: hasTrack ? row.implicitWidth : 0
	visible: hasTrack
	color: "transparent"

	// Botão de controle reaproveitável
	component CtrlButton: Text {
		id: btn
		padding: 4
		property bool enabledBtn: true
		signal clicked()
		anchors.verticalCenter: parent.verticalCenter
		color: musicModule.textColor
		font.family: musicModule.fontFamily
		font.pixelSize: musicModule.iconSize
		opacity: enabledBtn ? (btnHover.hovered ? 1 : 0.8) : 0.3
		HoverHandler { id: btnHover }
		MouseArea {
			anchors.fill: parent
			enabled: btn.enabledBtn
			onClicked: btn.clicked()
		}
	}

	// Clique no texto continua fazendo play/pause (fica embaixo dos botões)
	MouseArea {
		anchors.fill: parent
		onClicked: if (musicModule.player) musicModule.player.togglePlaying()
	}

	Row {
		id: row
		anchors.centerIn: parent
		spacing: 0

		// Controles: fechados até passar o mouse
		Row {
			id: controls
			anchors.verticalCenter: parent.verticalCenter
			spacing: 4
			clip: true
			width: hover.hovered ? implicitWidth + 6 : 0
			opacity: hover.hovered ? 1 : 0
			Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
			Behavior on opacity { NumberAnimation { duration: 150 } }

			CtrlButton {
				text: musicModule.playing ? "󰏤" : "󰐊"
				onClicked: musicModule.player.togglePlaying()
			}
			CtrlButton {
				text: "󰒮"
				enabledBtn: musicModule.player ? musicModule.player.canGoPrevious : false
				onClicked: musicModule.player.previous()
			}
			CtrlButton {
				text: "󰒭"
				enabledBtn: musicModule.player ? musicModule.player.canGoNext : false
				onClicked: musicModule.player.next()
			}
		}
		Text {
			id: txt
			anchors.verticalCenter: parent.verticalCenter
			color: musicModule.textColor
			font.family: musicModule.fontFamily
			font.pixelSize: musicModule.fontSize
			text: musicModule.hasTrack
				? musicModule.player.trackTitle + "\n" + musicModule.player.trackArtist
				: ""
		}
	}
	HoverHandler {
		id: hover
		cursorShape: Qt.PointingHandCursor
	}
}
