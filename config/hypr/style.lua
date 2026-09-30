hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 5,
		border_size = 1,
		col = {
			active_border = "rgba(afafaf66)",
			inactive_border = "rgba(00000066)",
		},
		allow_tearing = false,
		layout = "dwindle",
	},
	decoration = {
		blur = {
			enabled = true,
			size = 10,
			passes = 2,
			vibrancy = 0,
		},
		shadow = {
			enabled = true,
			range = 100,
			render_power = 2,
			color = "rgba(010101c3)",
			offset = "0 0",
			scale = 0.9,
		},
		rounding = 20,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
	}
})
