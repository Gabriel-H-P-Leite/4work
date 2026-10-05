local vars = require("vars")
--BLUR
hl.layer_rule({match={namespace="^qs-.*$"},blur=true,ignore_alpha= 0.1,})
hl.layer_rule({match={namespace="wofi"},blur=true,ignore_alpha= 0.1,})
--WORKSPACE
hl.workspace_rule({ workspace = "special:audio", on_created_empty = "pavucontrol" })
hl.workspace_rule({ workspace = "special:musica", on_created_empty = "kitty rmpc " })
--DISPLAYS
hl.workspace_rule({ workspace = "r[1-5]", monitor = vars.monitor1, default = true })
hl.workspace_rule({ workspace = "r[6-10]", monitor = vars.monitor2, default = true })

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
