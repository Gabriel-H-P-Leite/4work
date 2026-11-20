import QtQuick
import QtQuick.Effects
import QtQuick.Controls.Fusion
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam
import Quickshell.Services.Mpris

// Tela de bloqueio com o logo de DVD quicando (adaptada do astroland_dots).
// Travar: qsh ipc lockscreen lock   (SUPER + CTRL + L no binds.lua)
// Usa o ext-session-lock do Wayland: fica acima de todas as janelas e camadas,
// em todos os monitores, e só solta com a senha certa (PAM, igual ao login).
Scope {
	id: root

	// estado compartilhado: o que se digita num monitor aparece em todos
	property string senha: ""
	property bool verificando: false
	property bool errou: false
	property var pausados: []

	function tentar() {
		if (senha === "" || verificando) return
		verificando = true
		pam.start()
	}

	IpcHandler {
		target: "lockscreen"
		function lock(): void {
			if (!sessionLock.locked && !captura.running) captura.running = true
		}
	}

	// print de cada monitor antes de travar, para o efeito de TV desligando
	Process {
		id: captura
		command: ["sh", "-c", 'for o in "$@"; do grim -s 0.5 -t jpeg -o "$o" "/tmp/lock_$o.jpeg"; done', "sh"]
			.concat(Quickshell.screens.map(s => s.name))
		onExited: {
			// pausa o que estiver tocando e, ao destravar, retoma só isso
			root.pausados = Mpris.players.values.filter(p => p.playbackState === MprisPlaybackState.Playing && p.canPause)
			root.pausados.forEach(p => p.pause())
			sessionLock.locked = true
		}
	}

	PamContext {
		id: pam
		// sem config própria: usa o /etc/pam.d/login, como o hyprlock
		onPamMessage: if (pam.responseRequired) pam.respond(root.senha)
		onCompleted: result => {
			root.senha = ""
			root.verificando = false
			if (result === PamResult.Success) {
				sessionLock.locked = false
				root.pausados.forEach(p => p.play())
				root.pausados = []
			} else {
				root.errou = true
			}
		}
	}

	WlSessionLock {
		id: sessionLock
		WlSessionLockSurface {
			id: superficie
			color: "black"
			Tela {
				anchors.fill: parent
				tranca: root
				nomeTela: superficie.screen ? superficie.screen.name : ""
			}
		}
	}

	// o que aparece em cada monitor
	component Tela: Rectangle {
		id: tela
		required property var tranca
		property string nomeTela: ""
		property bool iniciou: false
		color: "black"

		// a animação só começa quando a superfície já tem tamanho
		function comecar() {
			if (iniciou || width <= 0) return
			iniciou = true
			printFx.width = width
			printFx.height = height
			tvOff.start()
		}
		onWidthChanged: comecar()
		Component.onCompleted: comecar()

		// ---------- fundo: print da tela com blur, 50% sobre o preto ----------
		// o compositor não desenha nada por trás do lock, então o "transparente" é o print
		MultiEffect {
			anchors.fill: parent
			source: printImg
			blurEnabled: true
			blur: 1
			blurMax: 64
			opacity: 0.5
			visible: caixa.visible
		}

		// ---------- DVD quicando ----------
		Item {
			id: dvdArea
			anchors.fill: parent
			visible: false

			// qualquer imagem (animada ou não): largura = 10% do monitor, altura pela proporção
			AnimatedImage {
				id: dvd
				source: Qt.resolvedUrl("../assets/dvd.webp")
				width: dvdArea.width * 0.10
				height: implicitWidth > 0 ? width * implicitHeight / implicitWidth : 0
				fillMode: Image.PreserveAspectFit
				visible: false
			}
			MultiEffect {
				id: dvdCor
				source: dvd
				anchors.fill: dvd
				colorization: 0.5
				colorizationColor: "blue"
			}
			FrameAnimation {
				property int dx: 1
				property int dy: 1
				running: dvdArea.visible
				onTriggered: {
					dvd.x += 300 * frameTime * dx
					dvd.y += 300 * frameTime * dy
					let bateu = true
					if (dvd.x + dvd.width >= dvdArea.width) dx = -1
					else if (dvd.x <= 0) dx = 1
					else if (dvd.y + dvd.height >= dvdArea.height) dy = -1
					else if (dvd.y <= 0) dy = 1
					else bateu = false
					if (bateu) {
						const cores = ["red", "orange", "yellow", "green", "blue", "purple", "violet"]
						dvdCor.colorizationColor = cores[Math.floor(Math.random() * cores.length)]
					}
				}
			}
		}

		// ---------- relógio ----------
		SystemClock {
			id: relogio
			precision: SystemClock.Minutes
		}
		Text {
			anchors { top: parent.top; left: parent.left; margins: 70 }
			visible: caixa.visible
			text: Qt.formatDateTime(relogio.date, "hh:mm")
			color: "white"
			opacity: 0.7
			font { family: "monospace"; pointSize: 64; bold: true; italic: true }
		}

		// ---------- senha ----------
		Item {
			id: caixa
			anchors.fill: parent
			visible: false

			Column {
				anchors { horizontalCenter: parent.horizontalCenter; top: parent.verticalCenter }
				spacing: 10

				Row {
					Text {
						anchors.verticalCenter: parent.verticalCenter
						text: "password:"
						color: "white"
						font { family: "monospace"; pointSize: 32; bold: true }
					}
					TextField {
						id: campo
						implicitWidth: 400
						padding: 10
						font { family: "monospace"; pointSize: 32; bold: true }
						color: "white"
						enabled: !tela.tranca.verificando
						echoMode: TextInput.Password
						passwordCharacter: "*"
						inputMethodHints: Qt.ImhSensitiveData
						background: Item {}

						onTextChanged: {
							tela.tranca.senha = text
							tela.tranca.errou = false
						}
						onAccepted: tela.tranca.tentar()

						// mantém o mesmo texto em todos os monitores
						Connections {
							target: tela.tranca
							function onSenhaChanged() { campo.text = tela.tranca.senha }
						}

						cursorDelegate: Rectangle {
							id: cursor
							width: 20
							color: "white"
							SequentialAnimation on visible {
								loops: Animation.Infinite
								PropertyAction { value: true }
								PauseAnimation { duration: 500 }
								PropertyAction { value: false }
								PauseAnimation { duration: 500 }
							}
						}
					}
				}
				Text {
					visible: tela.tranca.errou
					text: "wrong password"
					color: "#ff5555"
					font { family: "monospace"; pointSize: 20; bold: true }
				}
			}
		}

		// ---------- efeito de TV desligando, em cima do print ----------
		Image {
			id: printImg
			anchors.fill: parent
			source: tela.nomeTela ? "file:///tmp/lock_" + tela.nomeTela + ".jpeg" : ""
			cache: false   // senão o próximo bloqueio mostra o print antigo
			visible: false
		}
		MultiEffect {
			id: printFx
			anchors.centerIn: parent
			source: printImg
			brightness: 0
		}

		SequentialAnimation {
			id: tvOff
			ParallelAnimation {
				NumberAnimation { target: printFx; property: "brightness"; to: 1; duration: 1000; easing.type: Easing.OutExpo }
				NumberAnimation { target: printFx; property: "height"; to: 10; duration: 500; easing.type: Easing.OutExpo }
				SequentialAnimation {
					PauseAnimation { duration: 300 }
					NumberAnimation { target: printFx; property: "width"; to: 0; duration: 300; easing.type: Easing.OutExpo }
					PropertyAction { target: printFx; property: "visible"; value: false }
				}
			}
			// a tela "acende" piscando
			PauseAnimation { duration: 200 }
			PropertyAction { target: caixa; property: "visible"; value: true }
			PauseAnimation { duration: 100 }
			PropertyAction { target: caixa; property: "visible"; value: false }
			PauseAnimation { duration: 200 }
			PropertyAction { target: caixa; property: "visible"; value: true }
			PropertyAction { target: dvdArea; property: "visible"; value: true }
			ScriptAction { script: campo.forceActiveFocus() }
		}
	}
}
