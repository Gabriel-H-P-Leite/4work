import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Wayland._WlrLayerShell

PanelWindow {
	id: launcher
	WlrLayershell.namespace: "qs-launcher"
	WlrLayershell.layer: WlrLayer.Overlay
	WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
	exclusiveZone: -1
	implicitWidth: 500
	implicitHeight: 500
	color:"transparent"

	function launchSelected() {
		if (list.currentItem && list.currentItem.modelData) {
			list.currentItem.modelData.execute()
			root.toggleLauncher()
		}
	}
	Rectangle{
		color: root.back
		width: parent.width
		height: parent.height
		border.color: root.border
		border.width: 1
		radius: 20

		ScriptModel {
			id: filtered
			values: {
				const q = input.text.trim().toLowerCase()
				const all = [...DesktopEntries.applications.values]
				return q === "" ? all : all.filter(d => d.name?.toLowerCase().includes(q))
			}
		}
		ColumnLayout {
			anchors.fill: parent
			spacing: 8

			RowLayout {
				Layout.fillWidth: true
				Layout.margins: 5
				TextField {
					id: input
					color: root.text
					Layout.fillWidth: true
					placeholderText: "Run…"
					placeholderTextColor: Qt.rgba(1,1,1, 0.5)
					font.pixelSize: 18
					focus: true
					padding: 7
					background: Rectangle {
						color: root.back
						border.width: 1
						border.color: root.border
						radius: 20
					}
					onTextChanged: {
						list.currentIndex = filtered.values.length > 0 ? 0 : -1
					}
					Keys.onEscapePressed: root.toggleLauncher()
					Keys.onPressed: event => {
						const ctrl = event.modifiers & Qt.ControlModifier
						if (event.key === Qt.Key_Up || (event.key === Qt.Key_P && ctrl)) {
							event.accepted = true
							if (list.currentIndex > 0) list.currentIndex--
						} else if (event.key === Qt.Key_Down || (event.key === Qt.Key_N && ctrl)) {
							event.accepted = true
							if (list.currentIndex < list.count - 1) list.currentIndex++
						} else if ([Qt.Key_Return, Qt.Key_Enter].includes(event.key)) {
							event.accepted = true
							launcher.launchSelected()
						}
					}
				}
			}


			ListView {
				id: list
				Layout.fillWidth: true
				Layout.fillHeight: true
				Layout.margins: 5
				clip: true
				model: filtered.values
				currentIndex: filtered.values.length > 0 ? 0 : -1
				keyNavigationWraps: true
				highlightMoveDuration: 80
				highlight: Rectangle {
					color: root.back
					border.width: 1
					border.color: root.border
					radius: 20
				}
				delegate: Item {
					id: entry
					required property var modelData
					required property int index
					width: ListView.view.width
					height: 36
					MouseArea {
						anchors.fill: parent
						onClicked: list.currentIndex = entry.index
						onDoubleClicked: launcher.launchSelected()
					}
					Row {
						anchors.fill: parent
						anchors.margins: 8
						spacing: 10
						Text {
							color: entry.index === list.currentIndex ? "white" : Qt.rgba(1,1,1, 0.5)
							text: entry.modelData.name
							font.pointSize: 13
							elide: Text.ElideRight
							verticalAlignment: Text.AlignVCenter
						}
					}
				}
				Keys.onReturnPressed: launcher.launchSelected()
			}
		}
	}
}
