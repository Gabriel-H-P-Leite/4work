import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

Rectangle {
	id: trayModule
	property int iconSize: 18
	property int barH: 33

	height: barH
	width: row.implicitWidth > 0 ? row.implicitWidth + 8 : 0
	visible: SystemTray.items.values.length > 0
	color: "transparent"

	Row {
		id: row
		anchors.centerIn: parent
		spacing: 6

		Repeater {
			model: SystemTray.items

			Item {
				id: trayItem
				required property var modelData
				width: trayModule.iconSize
				height: trayModule.iconSize
				anchors.verticalCenter: parent.verticalCenter

				// Alguns apps (Steam, Electron) mandam o ícone como "nome?path=/pasta"
				function iconSource() {
					let icon = modelData.icon
					if (icon.includes("?path=")) {
						const [name, path] = icon.split("?path=")
						icon = "file://" + path + "/" + name.slice(name.lastIndexOf("/") + 1)
					}
					return icon
				}

				function openMenu() {
					if (!modelData.hasMenu) return
					// abre o menu logo abaixo do ícone
					const pos = trayItem.mapToItem(null, 0, trayItem.height + 6)
					modelData.display(QsWindow.window, pos.x, pos.y)
				}

				IconImage {
					anchors.fill: parent
					source: trayItem.iconSource()
					opacity: hover.hovered ? 1 : 0.85
				}

				HoverHandler { id: hover; cursorShape: Qt.PointingHandCursor }

				// esquerdo: abre o app | meio: ação secundária | direito: menu
				MouseArea {
					anchors.fill: parent
					acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
					onClicked: mouse => {
						if (mouse.button === Qt.RightButton) trayItem.openMenu()
						else if (mouse.button === Qt.MiddleButton) trayItem.modelData.secondaryActivate()
						else if (trayItem.modelData.onlyMenu) trayItem.openMenu()
						else trayItem.modelData.activate()
					}
					onWheel: wheel => trayItem.modelData.scroll(wheel.angleDelta.y / 120, false)
				}
			}
		}
	}
}
