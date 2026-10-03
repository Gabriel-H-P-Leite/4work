
--BLUR
hl.layer_rule({match={namespace="^qs-.*$"},blur=true,ignore_alpha= 0.1,})
hl.layer_rule({match={namespace="wofi"},blur=true,ignore_alpha= 0.1,})
--WORKSPACE
hl.workspace_rule({ workspace = "special:audio", on_created_empty = "pavucontrol" })
hl.workspace_rule({ workspace = "special:musica", on_created_empty = "kitty rmpc " })

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
	name  = "fix-Chatgpt",
	match = {class = "Chatgpt"},
	no_focus = true,
	float      = true,
	border_size = 0,
	no_blur     = true,
	no_shadow   = true,
	decorate    = false
})
