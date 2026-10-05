--IMPORT
require("rules")
require("style")
require("binds")
require("display")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
--ON START
hl.on("hyprland.start", function()
	--clipboard
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	--auth
	hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
	--others
	hl.exec_cmd("mpd ; sleep 20 ; mpd-mpris")
	hl.exec_cmd("sleep 20 ; mpc repeat on && mpc random on && mpc consume on")
	hl.exec_cmd("hyprsunset")
	hl.exec_cmd("quickshell")
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
