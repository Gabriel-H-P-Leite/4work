import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Rectangle {
	id: musicModule
	property color textColor: "white"
	property var fontFamily: "mono"
	property int fontSize: 10
	property int barH: 33

	height: barH
	width: txt.text !== "" ? txt.implicitWidth : 0
	visible: txt.text !== ""
	color: "transparent"
	property var player: {
		for (let p of Mpris.players.values) {
			if (p.dbusName.includes("mpd")) return p
		}
		return Mpris.players.values[0] || null
	}
	Text {
		id: txt
		anchors.centerIn: parent
		color: musicModule.textColor
		font.family: musicModule.fontFamily
		font.pixelSize: musicModule.fontSize
		text: {
			if (!musicModule.player || !musicModule.player.trackTitle) return ""
			let ico = musicModule.player.playbackState === MprisPlaybackState.Playing ? "󰏤" : "󰐊"
			return musicModule.player.trackTitle + "\n" + musicModule.player.trackArtist
		}
		MouseArea {
			anchors.fill: parent
			onClicked: {
				if (musicModule.player) musicModule.player.togglePlaying()
			}
		}
	}
}
