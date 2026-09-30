import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

PanelWindow {
	id: center
	WlrLayershell.namespace: "qs-modulescenter"
	height: root.barH
	color: "transparent"
	anchors {
		top: true
	}
	width: cback.width
	Rectangle {
		id: cback
		color: root.back
		height: center.height
		border.color: root.border
		border.width: 1
		bottomLeftRadius: 20
		bottomRightRadius: 20
		y: -1
		width: works.implicitWidth + 20
		Row {
			id: works
			anchors.centerIn: parent
			spacing: 3
			// Workspaces normais (ids negativos são special workspaces), ordenados por id
			property var workspaces: Hyprland.workspaces.values
				.filter(w => w.id > 0)
				.sort((a, b) => a.id - b.id)
			Repeater {
				model: works.workspaces
				Rectangle {
					required property var modelData
					property bool isFocused: Hyprland.focusedWorkspace?.id === modelData.id
					width: 24
					height: 24
					radius: 20
					color: isFocused ? Qt.rgba(0, 0, 0, 0.1) : "transparent"
					Text {
						anchors.centerIn: parent
						text: modelData.id
						color: parent.isFocused ? "white" : Qt.rgba(1, 1, 1, 0.5)
					}
					MouseArea {
						anchors.fill: parent
						onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + modelData.id + " })")
					}
				}
			}
		}
	}
}
