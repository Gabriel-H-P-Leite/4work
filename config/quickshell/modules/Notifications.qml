import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications

Scope {
	id: notifs
	property color textColor: "white"
	property string fontFamily: root.iconFont
	property int fontSize: 18

	property int popupTimeout: 5000   // ms, quando o app não define tempo
	property int cardWidth: 380
	property var arrivals: ({})       // ids que ainda devem aparecer como popup

	// ---------- Servidor (substitui o swaync) ----------
	NotificationServer {
		id: server
		keepOnReload: true
		actionsSupported: true
		bodyMarkupSupported: true
		bodyHyperlinksSupported: true
		imageSupported: true
		persistenceSupported: true
		onNotification: n => {
			// no modo não perturbe só os críticos viram popup; o resto vai direto pro histórico
			if (!root.notifDnd || n.urgency === NotificationUrgency.Critical)
				notifs.arrivals[n.id] = true
			n.tracked = true
		}
	}
	// Mais novas primeiro (ScriptModel reaproveita os delegates, então timers não reiniciam)
	ScriptModel {
		id: newestFirst
		values: [...server.trackedNotifications.values].reverse()
	}

	function iconSource(n) {
		if (!n) return ""
		if (n.image) return n.image
		const ic = n.appIcon
		if (!ic) return ""
		if (ic.startsWith("/")) return "file://" + ic
		if (ic.startsWith("file://")) return ic
		return Quickshell.iconPath(ic, true)
	}

	function clearAll() {
		for (const n of [...server.trackedNotifications.values]) n.dismiss()
	}

	// ---------- IPC: quickshell ipc call notifications <função> ----------
	IpcHandler {
		target: "notifications"
		function toggle(): string { root.notifCenterOpen = !root.notifCenterOpen; return "" }
		function clear(): string { notifs.clearAll(); return "" }
		function toggleDnd(): string { root.notifDnd = !root.notifDnd; return "" }
	}

	// Número de notificações no histórico, pro botão da barra
	Binding {
		target: root
		property: "notifCount"
		value: server.trackedNotifications.values.length
	}

	// ---------- Cartão de notificação (usado no popup e na central) ----------
	component NotifCard: Rectangle {
		id: card
		property var notif
		property bool compact: true
		property bool critical: notif ? notif.urgency === NotificationUrgency.Critical : false
		property alias hovered: cardHover.hovered
		property var buttons: {
			let r = []
			if (!notif) return r
			const a = notif.actions
			for (let i = 0; i < a.length; i++)
				if (a[i].identifier !== "default") r.push(a[i])
			return r
		}
		signal clickedNoAction()

		function defaultAction() {
			const a = notif.actions
			for (let i = 0; i < a.length; i++)
				if (a[i].identifier === "default") return a[i]
			return null
		}

		width: notifs.cardWidth
		height: content.implicitHeight + 24
		radius: 20
		color: root.back
		border.width: 1
		border.color: critical ? "#e06c75" : root.border

		HoverHandler { id: cardHover }

		// esquerdo: ação padrão do app (ou fecha o popup) | direito: descarta
		MouseArea {
			anchors.fill: parent
			acceptedButtons: Qt.LeftButton | Qt.RightButton
			onClicked: mouse => {
				if (mouse.button === Qt.RightButton) { card.notif.dismiss(); return }
				const def = card.defaultAction()
				if (def) def.invoke()
				else card.clickedNoAction()
			}
		}

		RowLayout {
			id: content
			anchors { left: parent.left; right: parent.right; top: parent.top; margins: 12 }
			spacing: 10

			Image {
				id: icon
				Layout.alignment: Qt.AlignTop
				Layout.preferredWidth: 40
				Layout.preferredHeight: 40
				visible: status === Image.Ready
				source: notifs.iconSource(card.notif)
				sourceSize: Qt.size(80, 80)
				fillMode: Image.PreserveAspectFit
				asynchronous: true
			}

			ColumnLayout {
				Layout.fillWidth: true
				spacing: 2

				RowLayout {
					Layout.fillWidth: true
					Text {
						Layout.fillWidth: true
						text: card.notif ? card.notif.appName : ""
						color: Qt.rgba(1, 1, 1, 0.6)
						font.family: root.fontFamily
						font.pixelSize: 11
						elide: Text.ElideRight
					}
					Text {
						text: ""
						color: closeHover.hovered ? root.text : Qt.rgba(1, 1, 1, 0.6)
						font.pixelSize: 14
						padding: 2
						HoverHandler { id: closeHover; cursorShape: Qt.PointingHandCursor }
						MouseArea { anchors.fill: parent; onClicked: card.notif.dismiss() }
					}
				}

				Text {
					Layout.fillWidth: true
					text: card.notif ? card.notif.summary : ""
					color: root.text
					font.family: root.fontFamily
					font.pixelSize: 14
					font.bold: true
					wrapMode: Text.Wrap
					maximumLineCount: card.compact ? 2 : 10
					elide: Text.ElideRight
				}

				Text {
					Layout.fillWidth: true
					visible: text !== ""
					text: card.notif ? card.notif.body : ""
					textFormat: Text.StyledText
					color: Qt.rgba(1, 1, 1, 0.85)
					linkColor: "#8ab4f8"
					font.pixelSize: notifs.iconSize
					font.family: notifs.iconFont						
					wrapMode: Text.Wrap
					maximumLineCount: card.compact ? 4 : 50
					elide: Text.ElideRight
					onLinkActivated: link => Qt.openUrlExternally(link)
				}

				Flow {
					Layout.fillWidth: true
					Layout.topMargin: 4
					visible: card.buttons.length > 0
					spacing: 6
					Repeater {
						model: card.buttons
						Rectangle {
							required property var modelData
							width: label.implicitWidth + 20
							height: 26
							radius: 13
							color: btnHover.hovered ? Qt.rgba(1, 1, 1, 0.15) : Qt.rgba(1, 1, 1, 0.05)
							border.width: 1
							border.color: root.border
							Text {
								id: label
								anchors.centerIn: parent
								text: modelData.text
								color: root.text
								font.family: root.fontFamily
								font.pixelSize: 12
							}
							HoverHandler { id: btnHover; cursorShape: Qt.PointingHandCursor }
							MouseArea { anchors.fill: parent; onClicked: modelData.invoke() }
						}
					}
				}
			}
		}
	}

	// ---------- Popups (canto superior direito) ----------
	PanelWindow {
		id: popupWin
		WlrLayershell.namespace: "qs-notifications"
		WlrLayershell.layer: WlrLayer.Overlay
		exclusiveZone: -1
		color: "transparent"
		visible: !center.visible
		anchors { top: true; right: true; bottom: true }
		margins { top: root.barH + 5 ; right: 5 }
		implicitWidth: notifs.cardWidth
		mask: Region { item: popupColumn }

		Column {
			id: popupColumn
			width: parent.width
			spacing: 8
			move: Transition { NumberAnimation { properties: "y"; duration: 180; easing.type: Easing.OutCubic } }
			add: Transition { NumberAnimation { properties: "opacity"; from: 0; to: 1; duration: 180 } }

			Repeater {
				model: newestFirst
				NotifCard {
					id: pop
					required property var modelData
					notif: modelData
					property bool showing: notifs.arrivals[modelData.id] === true
					visible: showing

					function hide() {
						showing = false
						delete notifs.arrivals[modelData.id]
						// notificações "transient" não devem ficar no histórico
						if (modelData.transient) modelData.expire()
					}
					onClickedNoAction: hide()

					// some sozinho; pausa com o mouse em cima; críticas ficam até fechar
					Timer {
						running: pop.visible && !pop.critical && !pop.hovered
						interval: pop.modelData.expireTimeout > 0 ? pop.modelData.expireTimeout * 1000 : notifs.popupTimeout
						onTriggered: pop.hide()
					}
				}
			}
		}
	}

	// ---------- Central de notificações (histórico) ----------
	PanelWindow {
		id: center
		visible: root.notifCenterOpen
		WlrLayershell.namespace: "qs-notifcenter"
		WlrLayershell.layer: WlrLayer.Overlay
		exclusiveZone: -1
		color: "transparent"
		anchors { top: true; right: true; bottom: true }
		margins { top: root.barH + 5 ; right: 5 ; bottom: 5 }
		implicitWidth: notifs.cardWidth + 20

		Rectangle {
			anchors.fill: parent
			color: root.back
			radius: 20
			border.width: 1
			border.color: root.border

			ColumnLayout {
				anchors.fill: parent
				anchors.margins: 10
				spacing: 10

				RowLayout {
					Layout.fillWidth: true
					Text {
						Layout.fillWidth: true
						leftPadding: 6
						text: "Notificações"
						color: root.text
						font.family: root.fontFamily
						font.pixelSize: 16
						font.bold: true
					}
					Text {
						text: root.notifDnd ? "󰂛" : "󰂚"
						color: dndHover.hovered ? root.text : Qt.rgba(1, 1, 1, 0.7)
						font.pixelSize: notifs.iconSize
						font.family: notifs.iconFont						
						padding: 4
						HoverHandler { id: dndHover; cursorShape: Qt.PointingHandCursor }
						MouseArea { anchors.fill: parent; onClicked: root.notifDnd = !root.notifDnd }
					}
					Text {
						text: "󰩺"
						color: clearHover.hovered ? root.text : Qt.rgba(1, 1, 1, 0.7)
						font.pixelSize: notifs.iconSize
						font.family: notifs.iconFont						
						padding: 4
						HoverHandler { id: clearHover; cursorShape: Qt.PointingHandCursor }
						MouseArea { anchors.fill: parent; onClicked: notifs.clearAll() }
					}
				}

				ListView {
					id: list
					Layout.fillWidth: true
					Layout.fillHeight: true
					clip: true
					spacing: 8
					model: newestFirst
					delegate: NotifCard {
						required property var modelData
						notif: modelData
						compact: false
						width: ListView.view.width
					}
					add: Transition { NumberAnimation { properties: "opacity"; from: 0; to: 1; duration: 180 } }
					displaced: Transition { NumberAnimation { properties: "y"; duration: 180; easing.type: Easing.OutCubic } }

					Text {
						anchors.centerIn: parent
						visible: list.count === 0
						text: "Sem notificações"
						color: Qt.rgba(1, 1, 1, 0.5)
						font.family: root.fontFamily
						font.pixelSize: 13
					}
				}
			}
		}
	}
}
