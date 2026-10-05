import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import Quickshell.Services.SystemTray

Rectangle {
	id: trayModule
	property int iconSize: 18
	property int barH: 33
	property int menuWidth: 220

	height: barH
	width: row.implicitWidth > 0 ? row.implicitWidth + 8 : 0
	visible: SystemTray.items.values.length > 0
	color: "transparent"

	// Linha do menu (item normal, voltar de submenu...)
	component MenuRow: Item {
		id: mr
		property string label: ""
		property string iconName: ""
		property string mark: ""
		property bool arrow: false
		property bool active: true
		signal clicked()

		height: 30
		opacity: active ? 1 : 0.4

		Rectangle {
			anchors.fill: parent
			radius: 8
			color: (ma.containsMouse && mr.active) ? Qt.rgba(1, 1, 1, 0.12) : "transparent"
		}
		// ✓ / ● de itens marcáveis
		Text {
			x: 10
			anchors.verticalCenter: parent.verticalCenter
			width: 14
			text: mr.mark
			color: root.text
			font.family: root.fontFamily
			font.pixelSize: 13
		}
		IconImage {
			x: 28
			anchors.verticalCenter: parent.verticalCenter
			width: 16
			height: 16
			visible: mr.iconName !== ""
			source: mr.iconName
		}
		Text {
			anchors.left: parent.left
			anchors.leftMargin: mr.iconName !== "" ? 50 : 30
			anchors.right: parent.right
			anchors.rightMargin: 24
			anchors.verticalCenter: parent.verticalCenter
			elide: Text.ElideRight
			text: mr.label
			color: root.text
			font.family: root.fontFamily
			font.pixelSize: 14
		}
		Text {
			anchors.right: parent.right
			anchors.rightMargin: 10
			anchors.verticalCenter: parent.verticalCenter
			text: mr.arrow ? "›" : ""
			color: root.text
			font.family: root.fontFamily
			font.pixelSize: 16
		}
		MouseArea {
			id: ma
			anchors.fill: parent
			hoverEnabled: true
			enabled: mr.active
			onClicked: mr.clicked()
		}
	}

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
					if (menuWin.visible) { menuWin.visible = false; return }
					menuWin.stack = []
					// borda direita do menu alinhada com a do ícone (a barra fica colada na direita)
					const p = trayItem.mapToItem(null, 0, 0)
					const x = Math.max(0, p.x + trayItem.width - trayModule.menuWidth)
					menuWin.anchor.rect = Qt.rect(x, p.y + trayItem.height + 6, 1, 1)
					menuWin.visible = true
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

				// Menu em QML puro: não depende do tema de plataforma do Qt (qt6ct não tem menu nativo)
				PopupWindow {
					id: menuWin
					// pilha de submenus abertos; vazia = menu principal
					property var stack: []

					anchor.window: trayItem.QsWindow.window
					anchor.edges: Edges.Top | Edges.Left
					anchor.gravity: Edges.Bottom | Edges.Right
					implicitWidth: trayModule.menuWidth
					implicitHeight: menuCol.implicitHeight + 12
					color: "transparent"
					visible: false
					onVisibleChanged: if (!visible) stack = []

					// fecha ao clicar fora
					HyprlandFocusGrab {
						windows: [menuWin]
						active: menuWin.visible
						onCleared: menuWin.visible = false
					}

					QsMenuOpener {
						id: opener
						menu: menuWin.stack.length > 0
							? menuWin.stack[menuWin.stack.length - 1]
							: trayItem.modelData.menu
					}

					Rectangle {
						anchors.fill: parent
						radius: 14
						color: Qt.rgba(0.07, 0.07, 0.07, 0.92)
						border.width: 1
						border.color: root.border

						Column {
							id: menuCol
							anchors.top: parent.top
							anchors.left: parent.left
							anchors.right: parent.right
							anchors.margins: 6
							spacing: 1

							MenuRow {
								width: menuCol.width
								visible: menuWin.stack.length > 0
								label: "Voltar"
								mark: "‹"
								onClicked: menuWin.stack = menuWin.stack.slice(0, -1)
							}

							Repeater {
								model: opener.children

								Item {
									id: entry
									required property var modelData
									width: menuCol.width
									height: modelData.isSeparator ? 9 : 30

									Rectangle {
										visible: entry.modelData.isSeparator
										anchors.left: parent.left
										anchors.right: parent.right
										anchors.leftMargin: 8
										anchors.rightMargin: 8
										anchors.verticalCenter: parent.verticalCenter
										height: 1
										color: root.border
									}

									MenuRow {
										anchors.fill: parent
										visible: !entry.modelData.isSeparator
										label: entry.modelData.text
										iconName: entry.modelData.icon
										active: entry.modelData.enabled
										arrow: entry.modelData.hasChildren
										mark: entry.modelData.buttonType === QsMenuButtonType.CheckBox
											? (entry.modelData.checkState === Qt.Checked ? "✓" : "")
											: entry.modelData.buttonType === QsMenuButtonType.RadioButton
												? (entry.modelData.checkState === Qt.Checked ? "●" : "○")
												: ""
										onClicked: {
											if (entry.modelData.hasChildren) {
												menuWin.stack = menuWin.stack.concat([entry.modelData])
											} else {
												entry.modelData.triggered()
												menuWin.visible = false
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
}
