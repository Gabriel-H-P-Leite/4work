import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
	id: launcher
	WlrLayershell.namespace: "qs-launcher"
	WlrLayershell.layer: WlrLayer.Overlay
	WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
	exclusiveZone: -1
	implicitWidth: 500
	implicitHeight: 500
	color:"transparent"

	function appIcon(entry) {
		const ic = entry?.icon || ""
		if (ic.startsWith("/")) return "file://" + ic
		return Quickshell.iconPath(ic, "application-x-executable")
	}

	function launchSelected() {
		if (root.dmenuMode) {
			// sem nenhum item filtrado, devolve o que foi digitado (igual ao dmenu)
			const choice = list.currentItem ? list.currentItem.modelData : input.text
			if (choice === "") return
			root.dmenuFinish(choice)
			root.toggleLauncher()
			return
		}
		if (list.currentItem && list.currentItem.modelData) {
			list.currentItem.modelData.execute()
			root.toggleLauncher()
		}
	}

	// fechou sem escolher (Esc, atalho de novo...): avisa o script pra ele não ficar esperando
	// fifo do dmenu que ESTE launcher está mostrando. Se o launcher antigo for destruído
	// depois que o próximo dmenu já abriu, ele não pode cancelar o novo.
	property string myFifo: ""
	Component.onCompleted: myFifo = root.dmenuFifo   // valor fixo, não binding
	Connections {
		target: root
		function onDmenuFifoChanged() { if (root.dmenuFifo !== "") launcher.myFifo = root.dmenuFifo }
	}
	Component.onDestruction: if (launcher.myFifo !== "" && root.dmenuFifo === launcher.myFifo) root.dmenuFinish("")

	// se um dmenu chegar com o launcher já aberto, limpa a busca
	Connections {
		target: root
		function onDmenuItemsChanged() { input.text = "" }
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
				// modo dmenu: itens na ordem que o script mandou
				if (root.dmenuMode)
					return q === "" ? root.dmenuItems : root.dmenuItems.filter(i => i.toLowerCase().includes(q))
				const all = [...DesktopEntries.applications.values]
					.sort((a, b) => a.name.localeCompare(b.name))
				if (q === "") return all
				// busca no nome, no nome genérico ("Navegador") e nas palavras-chave
				return all.filter(d =>
					d.name?.toLowerCase().includes(q) ||
					d.genericName?.toLowerCase().includes(q) ||
					d.keywords?.some(k => k.toLowerCase().includes(q)))
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
					placeholderText: root.dmenuMode ? (root.dmenuPrompt || "Escolha…") : "Run…"
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
				model: filtered
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
					height: 40
					MouseArea {
						anchors.fill: parent
						onClicked: list.currentIndex = entry.index
						onDoubleClicked: launcher.launchSelected()
					}
					RowLayout {
						anchors.fill: parent
						anchors.leftMargin: 10
						anchors.rightMargin: 10
						spacing: 10
						IconImage {
							Layout.alignment: Qt.AlignVCenter
							implicitSize: 24
							visible: !root.dmenuMode
							source: root.dmenuMode ? "" : launcher.appIcon(entry.modelData)
							asynchronous: true
							opacity: entry.index === list.currentIndex ? 1 : 0.7
						}
						Text {
							Layout.fillWidth: true
							Layout.alignment: Qt.AlignVCenter
							color: entry.index === list.currentIndex ? "white" : Qt.rgba(1,1,1, 0.5)
							text: root.dmenuMode ? entry.modelData : entry.modelData.name
							font.pointSize: 13
							elide: Text.ElideRight
						}
					}
				}
				Keys.onReturnPressed: launcher.launchSelected()
			}
		}
	}
}
