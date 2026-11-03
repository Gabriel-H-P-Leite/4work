local vars = require("vars")
--BLUR
hl.layer_rule({match={namespace="^qs-.*$"},blur=true,ignore_alpha= 0.1,})
--DISPLAYS
for i = 1, 5 do
	hl.workspace_rule({ workspace = tostring(i), monitor = vars.monitor1, default = true })
end
for i = 6, 10 do
	hl.workspace_rule({ workspace = tostring(i), monitor = vars.monitor3, default = true })
end
for i = 1, 5 do
	hl.workspace_rule({ workspace = tostring(i), monitor = vars.monitor2, default = true })
end
--WINDOWS
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
    name  = "Audacious",
    match = { class = "^(Audacious)$" },
    border_size = 0,
    rounding    = 0,
})
hl.window_rule({
    name  = "python",
    match = { class = "^(python)$" },
    border_size = 1,
	border_color = "rgba(ffffffff)",
    rounding = 100,
	no_shadow = true,
	no_blur = true,
	float = true,
	pin = true
})
--WORKSPACE
local workspace_programs = {
    ["special:audio"] = {"pavucontrol"},
    ["special:musica"] = {"kitty rmpc"}
}
hl.on("workspace.created", function(ws)
    if ws.is_empty then return end

    local program = workspace_programs[ws.name]
    if program == nil then return end

    local cmd, rules = table.unpack(program)
    -- shallow-copy the rules table so we can add the workspace to it
    local rules2 = {}
    for k, v in rules do rules2[k] = v end
    rules2.workspace = ws.name .. " silent"
    -- run it!
    hl.exec_cmd(cmd, rules2)
end)
