local vars = require("vars")

----------
--MUSIC--
----------

hl.bind("CTRL + ALT + E", hl.dsp.workspace.toggle_special("musica"))
hl.bind("CTRL + ALT + Space", hl.dsp.exec_cmd("quickshell ipc call music playPause"))
hl.bind("CTRL + ALT + A", hl.dsp.exec_cmd("quickshell ipc call music previous"))
hl.bind("CTRL + ALT + D", hl.dsp.exec_cmd("quickshell ipc call music next"))
hl.bind("CTRL + ALT + W", hl.dsp.exec_cmd("quickshell ipc call music volumeUp"))
hl.bind("CTRL + ALT + S", hl.dsp.exec_cmd("quickshell ipc call music volumeDown"))

---------
--MENUS--
---------

hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("quickshell ipc call toggleLauncher onTriggered"), { release = true })
--toggle quickshell
hl.bind(vars.mainMod .. " + T", hl.dsp.exec_cmd("pkill quickshell || quickshell"), { release = true })
--clipboard
hl.bind(vars.mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | qsmenu 'Área de transferência' | cliphist decode | wl-copy"))
--focus
hl.bind("ALT + F", hl.dsp.exec_cmd(vars.menu .." 3"))
--pin
hl.bind("ALT + T", hl.dsp.exec_cmd(vars.menu .." 4"))
--menus
hl.bind(vars.mainMod .. " + X", hl.dsp.exec_cmd(vars.menu))
--wallpaper
hl.bind(vars.mainMod .. " + W", hl.dsp.exec_cmd("quickshell ipc call wallpaper next"))
hl.bind(vars.mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("quickshell ipc call wallpaper random"))
--ocr
hl.bind(vars.mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("foto='OCR' ; slurp | grim -g - /tmp/$foto.png ; tesseract /tmp/$foto.png /tmp/$foto txt ; cat /tmp/$foto.txt | wl-copy"))

-----------
--UTILITY--
-----------
--notification
hl.bind(vars.mainMod .. " + N", hl.dsp.exec_cmd("quickshell ipc call notifications toggle"))
--screenshot
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("slurp | grim -g - ~/Imagens/$(date +'ArchLinux_%Y-%m-%d_%H:%M:%S.png')"))
--filter
hl.bind(vars.mainMod .. " + SHIFT + F", function()
	local p = io.popen("hyprctl hyprsunset temperature")
	local saida = p and p:read("*a") or ""
	if p then p:close() end

	local atual = tonumber(saida:match("%d+")) or 6000
	local nova = atual <= 3000 and 6000 or 3000
	hl.exec_cmd("hyprctl hyprsunset temperature " .. nova)
end)
--------
--APPS--
--------
hl.bind( vars.mainMod .. " + Return", hl.dsp.exec_cmd(vars.terminal))
hl.bind( vars.mainMod .. " + E", hl.dsp.exec_cmd(vars.explorer))
hl.bind( vars.mainMod .. " + B", hl.dsp.exec_cmd(vars.browser))
-----------
--SPECIAL--
-----------
hl.bind( vars.mainMod .. " + Space", hl.dsp.workspace.toggle_special("vars.terminal"))
hl.bind( vars.mainMod .. " + SHIFT + Space", hl.dsp.window.move({ workspace = "special:vars.terminal", follow = true }))
hl.bind( vars.mainMod .. " + A", hl.dsp.workspace.toggle_special("audio"))
---------
--BASIC--
---------
hl.bind( vars.mainMod .. " + mouse:272",hl.dsp.window.drag(),{mouse = true})
hl.bind( vars.mainMod .. " + mouse:274", hl.dsp.window.float({ action = "toggle" }))
hl.bind( vars.mainMod .. " + mouse:273",hl.dsp.window.resize(),{mouse = true})
hl.bind( vars.mainMod .. " + C", hl.dsp.window.close())
hl.bind( vars.mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind( vars.mainMod .. " + Z", hl.dsp.window.pseudo({ action = "toggle" }))
--------------
--WORKSPACES--
--------------
hl.bind( vars.mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind( vars.mainMod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind( vars.mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind( vars.mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind( vars.mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind( vars.mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind( vars.mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind( vars.mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind( vars.mainMod .. " + 1", hl.dsp.focus({ workspace = "1" }))
hl.bind( vars.mainMod .. " + 2", hl.dsp.focus({ workspace = "2" }))
hl.bind( vars.mainMod .. " + 3", hl.dsp.focus({ workspace = "3" }))
hl.bind( vars.mainMod .. " + 4", hl.dsp.focus({ workspace = "4" }))
hl.bind( vars.mainMod .. " + 5", hl.dsp.focus({ workspace = "5" }))
hl.bind( vars.mainMod .. " + 6", hl.dsp.focus({ workspace = "6" }))
hl.bind( vars.mainMod .. " + 7", hl.dsp.focus({ workspace = "7" }))
hl.bind( vars.mainMod .. " + 8", hl.dsp.focus({ workspace = "8" }))
hl.bind( vars.mainMod .. " + 9", hl.dsp.focus({ workspace = "9" }))
hl.bind( vars.mainMod .. " + 0", hl.dsp.focus({ workspace = "10" }))
hl.bind( vars.mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = "1", follow = true }))
hl.bind( vars.mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = "2", follow = true }))
hl.bind( vars.mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = "3", follow = true }))
hl.bind( vars.mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = "4", follow = true }))
hl.bind( vars.mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = "5", follow = true }))
hl.bind( vars.mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = "6", follow = true }))
hl.bind( vars.mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = "7", follow = true }))
hl.bind( vars.mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = "8", follow = true }))
hl.bind( vars.mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = "9", follow = true }))
hl.bind( vars.mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = "10", follow = true }))
