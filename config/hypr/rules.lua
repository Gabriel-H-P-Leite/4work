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
    rounding = 0,
	no_shadow = true,
	no_blur = true,
	float = true
})
--WORKSPACE
local workspace_programs = {
	["special:audio"]  = { "pavucontrol" },
	["special:musica"] = { "kitty rmpc" },
}

hl.on("workspace.created", function(ws)
	local program = workspace_programs[ws.name]
	if not program then return end

	local cmd = program[1]
	-- regras extras opcionais na segunda posição, ex: { "pavucontrol", { float = true } }
	local rules = {}
	for k, v in pairs(program[2] or {}) do rules[k] = v end
	rules.workspace = ws.name .. " silent"

	hl.dispatch(hl.dsp.exec_cmd(cmd, rules))
end)
