import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Hyprland

PanelWindow {
	id: center
	WlrLayershell.namespace: "qs-modulescenter"
	height: root.barH
	color: "transparent"
	anchors {
		top: true
	}
	width: 800
	mask: Region { item: cback }

	function appIcon(toplevel) {
		const id = toplevel.wayland?.appId || toplevel.lastIpcObject?.class || ""
		const entry = DesktopEntries.heuristicLookup(id)
		return Quickshell.iconPath(entry?.icon || id, "application-x-executable")
	}

	Rectangle {
		id: cback
		color: root.back
		height: center.height
		border.color: root.border
		border.width: 1
		bottomLeftRadius: 20
		bottomRightRadius: 20
		y: -1
		anchors.horizontalCenter: parent.horizontalCenter
		width: Math.round(works.implicitWidth + 20)

		clip: true
		Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
		Row {
			id: works
			anchors.centerIn: parent
			spacing: 3
			property var workspaces: Hyprland.workspaces.values
				.filter(w => w.id > 0)
				.sort((a, b) => a.id - b.id)
			move: Transition {
				NumberAnimation { property: "x"; duration: 200; easing.type: Easing.OutCubic }
			}
			Repeater {
				model: works.workspaces

				Rectangle {
					id: ws
					required property var modelData
					property bool isFocused: modelData.focused
					property bool hasWindows: modelData.toplevels.values.length > 0

					height: 20
					width: hasWindows ? icons.implicitWidth + 18 : 24
					radius: 10
					color: isFocused ? Qt.rgba(0, 0, 0, 0.15)
						: wsHover.hovered ? Qt.rgba(1, 1, 1, 0.06) : "transparent"
					border.width: modelData.urgent ? 1 : 0
					border.color: "#e06c75"
					Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

					// Número: pequeno no canto superior esquerdo quando tem janelas,
					// normal e centralizado quando a workspace está vazia
					Text {
						text: ws.modelData.id
						color: ws.isFocused ? "white" : Qt.rgba(1, 1, 1, 0.5)
						font.pixelSize: ws.hasWindows ? 8 : 12
						font.bold: ws.hasWindows
						x: ws.hasWindows ? 5 : (ws.width - width) / 2
						y: ws.hasWindows ? 1 : (ws.height - height) / 2
					}

					Row {
						id: icons
						anchors.verticalCenter: parent.verticalCenter
						anchors.verticalCenterOffset: 1
						anchors.left: parent.left
						anchors.leftMargin: 12
						spacing: 3
						visible: ws.hasWindows

						Repeater {
							model: ws.modelData.toplevels
							IconImage {
								required property var modelData
								implicitSize: 15
								source: center.appIcon(modelData)
								// janela focada mais forte que as outras
								opacity: modelData.activated ? 1 : (ws.isFocused ? 0.75 : 0.5)
							}
						}
					}

					HoverHandler { id: wsHover; cursorShape: Qt.PointingHandCursor }
					MouseArea {
						anchors.fill: parent
						onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + ws.modelData.id + " })")
					}
				}
			}
		}
	}
}
