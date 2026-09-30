import QtQuick
import Quickshell
import Quickshell.Wayland
import "."

PanelWindow {
	id: left
	WlrLayershell.namespace: "qs-modulesleft"
	exclusiveZone: -1
	height: root.barH
	// Janela com largura fixa e folgada: quem muda de tamanho é só o fundo lá dentro.
	// Redimensionar a janela a cada frame da animação é o que causa o jitter.
	width: 800
	color: "transparent"
	anchors {
		top: true
		left: true
	}

	// Só a área do fundo recebe mouse; o resto da janela transparente deixa o clique passar
	mask: Region { item: background }

	Rectangle {
		id: background
		color: root.back
		border.color: root.border
		border.width: 1
		bottomRightRadius: 20
		anchors {
			top: parent.top
			bottom: parent.bottom
			left: parent.left
			topMargin: -1
			leftMargin: -1
		}
		width: Math.round(row.implicitWidth + 10)

		Row {
			id: row
			anchors.left: parent.left
			anchors.leftMargin: 6
			anchors.verticalCenter: parent.verticalCenter
			spacing: 2
			Menu {
				textColor: root.text
				fontSize: 20
				barH: root.barH
			}
			Music {
				textColor: root.text
				fontSize: 10
				barH: root.barH
			}
		}
	}
}
