local mainMod = "SUPER"
local menu = "/bin/menus"
local terminal = "kitty"
local explorer = "Thunar"
local browser = "zen-browser"

----------
--MUSIC--
----------

hl.bind("CTRL + ALT + Space", hl.dsp.exec_cmd("sh ~/.config/dotConfig/scripts/musica play-pause ;  sh ~/.config/dotConfig/scripts/musica notificacao"))
hl.bind("CTRL + SHIFT + E", hl.dsp.exec_cmd("sh ~/.config/dotConfig/scripts/musica player"))
hl.bind("CTRL + ALT + E", hl.dsp.workspace.toggle_special("musica"))
hl.bind("CTRL + ALT + A", hl.dsp.exec_cmd("sh ~/.config/dotConfig/scripts/musica previous"))
hl.bind("CTRL + ALT + D", hl.dsp.exec_cmd("sh ~/.config/dotConfig/scripts/musica next"))
hl.bind("CTRL + ALT + W", hl.dsp.exec_cmd("sh ~/.config/dotConfig/scripts/musica volume 0.1+ ;  sh ~/.config/dotConfig/scripts/musica notificacao"))
hl.bind("CTRL + ALT + S", hl.dsp.exec_cmd("sh ~/.config/dotConfig/scripts/musica volume 0.1- ;  sh ~/.config/dotConfig/scripts/musica notificacao"))

---------
--MENUS--
---------

hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("pkill wofi || wofi -S drun"), { release = true })
--all
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(menu))
--logout
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd(menu .." 3"))
--lock
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("grim '/tmp/fundo.png' ; hyprlock"))
--themes
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(menu .." 4"))
--clipboard
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(menu .." 6"))
--focus
hl.bind("ALT + F", hl.dsp.exec_cmd(menu .." 7"))
--pin
hl.bind("ALT + T", hl.dsp.exec_cmd(menu .." 8"))
--wallpaper
hl.bind( mainMod .." + W", hl.dsp.exec_cmd(menu .." 9 $wallpaper"))
--ocr
hl.bind( mainMod .." + SHIFT + R", hl.dsp.exec_cmd(menu .." 10"))
hl.bind( mainMod .." + SHIFT + M", hl.dsp.exec_cmd("$menu 11"))

-----------
--UTILITY--
-----------
--notification
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
--screenshot
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("slurp | grim -g - ~/Imagens/$(date +'ArchLinux_%Y-%m-%d_%H:%M:%S.png')"))
--filter
hl.bind(mainMod .." + SHIFT + F", hl.dsp.exec_cmd("sh ~/.config/dotConfig/scripts/video filtro"))
--------
--APPS--
--------
hl.bind( mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind( mainMod .. " + E", hl.dsp.exec_cmd(explorer))
hl.bind( mainMod .. " + B", hl.dsp.exec_cmd(browser))
-----------
--SPECIAL--
-----------
hl.bind( mainMod .. " + Space", hl.dsp.workspace.toggle_special("terminal"))
hl.bind( mainMod .. " + SHIFT + Space", hl.dsp.window.move({ workspace = "special:terminal", follow = true }))
hl.bind( mainMod .. " + A", hl.dsp.workspace.toggle_special("audio"))
---------
--BASIC--
---------
hl.bind( mainMod .. " + mouse:272",hl.dsp.window.drag(),{mouse = true})
hl.bind( mainMod .. " + mouse:274", hl.dsp.window.float({ action = "toggle" }))
hl.bind( mainMod .. " + mouse:273",hl.dsp.window.resize(),{mouse = true})
hl.bind( mainMod .. " + C", hl.dsp.window.close())
hl.bind( mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind( mainMod .. " + Z", hl.dsp.window.pseudo({ action = "toggle" }))
--------------
--WORKSPACES--
--------------
hl.bind( mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind( mainMod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind( mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind( mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind( mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind( mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind( mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind( mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind( mainMod .. " + 1", hl.dsp.focus({ workspace = "1" }))
hl.bind( mainMod .. " + 2", hl.dsp.focus({ workspace = "2" }))
hl.bind( mainMod .. " + 3", hl.dsp.focus({ workspace = "3" }))
hl.bind( mainMod .. " + 4", hl.dsp.focus({ workspace = "4" }))
hl.bind( mainMod .. " + 5", hl.dsp.focus({ workspace = "5" }))
hl.bind( mainMod .. " + 6", hl.dsp.focus({ workspace = "6" }))
hl.bind( mainMod .. " + 7", hl.dsp.focus({ workspace = "7" }))
hl.bind( mainMod .. " + 8", hl.dsp.focus({ workspace = "8" }))
hl.bind( mainMod .. " + 9", hl.dsp.focus({ workspace = "9" }))
hl.bind( mainMod .. " + 0", hl.dsp.focus({ workspace = "10" }))
hl.bind( mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = "1", follow = true }))
hl.bind( mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = "2", follow = true }))
hl.bind( mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = "3", follow = true }))
hl.bind( mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = "4", follow = true }))
hl.bind( mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = "5", follow = true }))
hl.bind( mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = "6", follow = true }))
hl.bind( mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = "7", follow = true }))
hl.bind( mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = "8", follow = true }))
hl.bind( mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = "9", follow = true }))
hl.bind( mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = "10", follow = true }))
