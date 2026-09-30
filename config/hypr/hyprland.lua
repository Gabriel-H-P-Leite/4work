--IMPORT
require("rules")
require("style")
require("binds")
require("display")
--ON START
hl.on("hyprland.start", function()
	hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1 & waybar & wpaperd -d & swaync & wl-paste --type text --watch cliphist store & wl-paste --type image --watch cliphist store")
	hl.exec_cmd("hyprctl setcursor Manopla 24 & hyprsunset")
	hl.exec_cmd("sleep 20 ; mpd-mpris")
	hl.exec_cmd("mpc repeat on && mpc random on && mpc consume on")
	hl.exec_cmd("cp /home/gabriel/Imagens/Wallpapers/ARCH7.jpg /tmp/fundo.png ; hyprlock")
	hl.exec_cmd("export QT_STYLE_OVERRIDE=kvantum")
end)
--CURSOR
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
--CONFIG
hl.config({
	input = {
		touchpad = {
			natural_scroll = false,
		},
		kb_layout = "br",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		numlock_by_default = true,
		follow_mouse = 1,
		sensitivity = 1,
		accel_profile = "flat",
	},
	xwayland = {
		force_zero_scaling = true,
	},
	misc = {
		enable_anr_dialog = false,
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
	},
})
