local vars = require("vars")
--BLUR
hl.layer_rule({match={namespace="^qs-.*$"},blur=true,ignore_alpha= 0.1,})
--WORKSPACE
hl.workspace_rule({ workspace = "special:audio", on_created_empty = "pavucontrol" })
hl.workspace_rule({ workspace = "special:musica", on_created_empty = "kitty rmpc " })
--DISPLAYS
for i = 1, 5 do
	hl.workspace_rule({ workspace = tostring(i), monitor = vars.monitor1, default = (i == 1) })
end
for i = 6, 10 do
	hl.workspace_rule({ workspace = tostring(i), monitor = vars.monitor2, default = (i == 6) })
end

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
