
--BLUR
hl.layer_rule({match={namespace="wofi"},blur=true,ignore_alpha= 0,})
hl.layer_rule({match={namespace="waybar"},blur=true,ignore_alpha= 0,})
hl.layer_rule({match={namespace="swaync-control-center"},blur=true,ignore_alpha= 0,})
hl.layer_rule({match={namespace="swaync-notification-window"},blur=true,ignore_alpha= 0,})
--WORKSPACE
hl.workspace_rule({ workspace = "special:audio", on_created_empty = "pavucontrol" })
hl.workspace_rule({ workspace = "special:musica", on_created_empty = "kitty rmpc " })
hl.workspace_rule({ workspace = "5", on_created_empty = "obsidian" })

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
