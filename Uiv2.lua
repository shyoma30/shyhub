--------------------------------------------------------------------------------
-- S Hub core  ·  v2.2
--------------------------------------------------------------------------------
local LOGO_URL = "https://i.imgur.com/CVA09x9.png"
local DISCORD_CODE = "dteHcrmBk"
local DISCORD_URL = "https://discord.gg/" .. DISCORD_CODE

local CREDITS_DATA = {
	Founder   = { Name = "shyoma30", Role = "Founder & Lead Developer", Badge = "FOUNDER", Color = Color3.fromRGB(255, 185, 55) },
	CoFounder = { Name = "jamal9eats", Role = "Co-Founder & Core Developer", Badge = "CO-FOUNDER", Color = Color3.fromRGB(88, 165, 255) },
	Testers   = {
		{ Name = "itzzzzjosh098", Role = "Official Quality Tester", Badge = "TESTER", Color = Color3.fromRGB(72, 214, 138) },
		{ Name = "chaosburger66yt", Role = "Official Quality Tester", Badge = "TESTER", Color = Color3.fromRGB(72, 214, 138) },
	},
}

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local StatsService = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function detectMobile()
	local cam = workspace.CurrentCamera
	local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
	if UserInputService.TouchEnabled and (not UserInputService.KeyboardEnabled or vp.X < 920 or vp.Y < 560) then
		return true
	end
	if GuiService:IsTenFootInterface() then return false end
	return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end
local IsMobile = detectMobile()

local sin, cos, abs, floor, clamp, max, min, rad, random =
	math.sin, math.cos, math.abs, math.floor, math.clamp, math.max, math.min, math.rad, math.random
local udim2FromScale, udim2FromOffset, udim2New = UDim2.fromScale, UDim2.fromOffset, UDim2.new

--------------------------------------------------------------------------------
-- themes
--------------------------------------------------------------------------------
local c = Color3.fromRGB
local WHITE = c(255, 255, 255)
local function theme(bg, surface, element, hover, stroke, accent, text, sub, accent2)
	return { Background = bg, Surface = surface, Element = element, Hover = hover, Stroke = stroke, Accent = accent, Text = text, SubText = sub, Accent2 = accent2 }
end

local Themes = {
	Eclipse        = theme(c(14,14,17), c(21,21,26), c(30,30,37), c(40,40,49), c(56,56,68), c(255,166,52), c(240,240,244), c(150,150,162), c(255,96,64)),
	Celestial      = theme(c(11,17,34), c(17,25,48), c(25,36,66), c(34,48,86), c(46,66,112), c(88,150,255), c(234,240,255), c(135,150,185), c(150,110,255)),
	Crimson        = theme(c(22,9,11), c(33,14,17), c(47,20,24), c(62,27,32), c(88,36,44), c(232,60,78), c(248,236,238), c(180,140,146), c(255,124,92)),
	Aurora         = theme(c(9,26,22), c(14,38,32), c(20,54,44), c(27,70,58), c(30,92,72), c(24,190,132), c(236,246,241), c(138,176,160), c(40,196,232)),
	Nebula         = theme(c(19,11,31), c(28,17,46), c(40,25,64), c(53,34,84), c(76,48,118), c(182,102,255), c(242,236,252), c(160,140,185), c(255,100,200)),
	Solar          = theme(c(27,19,9), c(38,28,13), c(52,39,17), c(67,50,22), c(96,72,30), c(255,198,48), c(252,246,232), c(184,166,130), c(255,128,40)),
	Starlight      = theme(c(17,19,27), c(25,28,39), c(35,39,53), c(46,51,68), c(62,68,92), c(200,212,255), c(244,246,255), c(148,154,176), c(160,140,255)),
	Cyberpunk      = theme(c(12,7,22), c(20,11,36), c(30,17,52), c(41,23,70), c(72,40,112), c(255,46,151), c(250,236,250), c(170,140,180), c(0,230,255)),
	Abyss          = theme(c(6,10,14), c(10,16,22), c(14,24,32), c(20,34,45), c(28,48,63), c(38,172,204), c(228,240,246), c(125,150,162), c(60,110,255)),
	Midnight       = theme(c(10,10,14), c(16,16,22), c(24,24,32), c(32,32,43), c(46,46,62), c(124,108,255), c(238,238,248), c(146,146,170), c(80,170,255)),
	Sakura         = theme(c(28,16,22), c(40,23,32), c(55,32,44), c(70,41,56), c(98,58,78), c(255,138,184), c(253,240,246), c(190,150,168), c(255,190,150)),
	Ocean          = theme(c(7,18,28), c(11,27,41), c(16,38,57), c(22,50,74), c(30,68,100), c(56,200,255), c(232,246,255), c(130,165,185), c(60,120,255)),
	Matcha         = theme(c(16,20,14), c(23,29,20), c(32,40,28), c(42,52,36), c(58,72,50), c(160,214,110), c(240,246,234), c(155,170,140), c(220,230,120)),
	Dracula        = theme(c(24,25,33), c(33,34,44), c(44,46,58), c(56,58,73), c(78,80,100), c(189,147,249), c(248,248,242), c(160,165,190), c(255,121,198)),
	Sunset         = theme(c(26,12,18), c(38,18,26), c(52,24,34), c(68,32,44), c(96,44,58), c(255,112,80), c(255,240,234), c(190,150,150), c(255,60,140)),
	Vaporwave      = theme(c(18,10,30), c(27,15,44), c(38,22,60), c(50,30,78), c(74,46,110), c(0,229,255), c(245,238,255), c(170,150,200), c(255,90,220)),
	BloodMoon      = theme(c(14,6,6), c(22,9,9), c(32,13,13), c(44,18,18), c(66,26,26), c(255,48,48), c(250,232,232), c(175,130,130), c(255,140,40)),
	Mono           = theme(c(12,12,12), c(19,19,19), c(28,28,28), c(38,38,38), c(54,54,54), c(235,235,235), c(245,245,245), c(150,150,150), c(150,150,150)),
	Snow           = theme(c(236,239,245), c(246,248,252), c(255,255,255), c(232,236,244), c(208,214,226), c(70,110,255), c(24,28,40), c(110,118,138), c(130,90,255)),
	Nord           = theme(c(36,41,51), c(46,52,64), c(59,66,82), c(67,76,94), c(76,86,106), c(136,192,208), c(236,239,244), c(165,176,194), c(129,161,193)),
	Catppuccin     = theme(c(24,24,37), c(30,30,46), c(49,50,68), c(69,71,90), c(88,91,112), c(203,166,247), c(205,214,244), c(166,173,200), c(245,194,231)),
	Gruvbox        = theme(c(29,32,33), c(40,40,40), c(60,56,54), c(80,73,69), c(102,92,84), c(254,128,25), c(235,219,178), c(168,153,132), c(250,189,47)),
	TokyoNight     = theme(c(22,22,30), c(26,27,38), c(36,40,59), c(47,53,77), c(65,72,104), c(122,162,247), c(192,202,245), c(130,140,184), c(187,154,247)),
	Synthwave      = theme(c(20,11,36), c(31,17,53), c(43,25,74), c(58,34,98), c(88,52,144), c(255,122,217), c(254,242,255), c(192,155,216), c(54,244,255)),
	Emerald        = theme(c(8,19,14), c(13,29,22), c(19,42,32), c(26,56,43), c(38,82,62), c(46,214,138), c(234,250,242), c(136,178,156), c(132,245,188)),
	Amethyst       = theme(c(16,11,24), c(24,17,36), c(35,25,52), c(46,33,68), c(68,48,100), c(164,108,255), c(242,236,255), c(158,142,186), c(224,142,255)),
	RoseGold       = theme(c(24,17,18), c(35,25,27), c(48,35,38), c(62,45,49), c(88,64,70), c(238,162,158), c(252,242,242), c(186,156,156), c(255,204,182)),
	Obsidian       = theme(c(7,7,9), c(12,12,16), c(19,19,25), c(26,26,34), c(40,40,52), c(148,162,255), c(238,240,248), c(134,138,156), c(92,224,232)),
	Christmas      = theme(c(11,19,14), c(16,28,21), c(22,38,29), c(29,50,38), c(42,70,54), c(218,48,56), c(242,248,244), c(144,174,154), c(46,194,106)),
	Yuletide       = theme(c(20,12,13), c(29,18,19), c(41,25,27), c(54,34,36), c(78,48,52), c(228,184,82), c(248,242,238), c(178,150,148), c(214,56,64)),
	Frostbite      = theme(c(10,16,24), c(15,23,35), c(21,33,49), c(28,44,64), c(42,64,92), c(125,212,255), c(238,246,255), c(138,164,192), c(195,238,255)),
	["Candy Cane"] = theme(c(22,12,15), c(32,18,22), c(45,26,32), c(58,34,42), c(84,48,60), c(255,74,98), c(254,246,248), c(188,154,164), c(255,220,228)),
	Gingerbread    = theme(c(22,15,10), c(32,22,15), c(45,31,21), c(58,41,28), c(82,58,40), c(218,138,68), c(250,242,234), c(178,154,132), c(236,78,70)),
	Polar          = theme(c(12,20,28), c(18,30,42), c(26,42,58), c(35,55,75), c(52,80,108), c(150,235,255), c(240,250,255), c(148,182,204), c(100,180,255)),
	Krampus        = theme(c(16,8,10), c(25,12,15), c(36,18,22), c(48,24,30), c(72,34,42), c(215,38,56), c(246,232,236), c(168,132,140), c(150,175,210)),
	Mistletoe      = theme(c(10,22,16), c(16,33,24), c(23,46,34), c(31,60,45), c(46,86,65), c(92,220,140), c(238,250,242), c(146,184,160), c(238,68,84)),
}
local ThemeNames = {
	"Eclipse", "Celestial", "Crimson", "Aurora", "Nebula", "Solar", "Starlight", "Cyberpunk", "Abyss",
	"Midnight", "Sakura", "Ocean", "Matcha", "Dracula", "Sunset", "Vaporwave", "BloodMoon", "Mono", "Snow",
	"Nord", "Catppuccin", "Gruvbox", "TokyoNight", "Synthwave", "Emerald", "Amethyst", "RoseGold", "Obsidian",
	"Christmas", "Yuletide", "Frostbite", "Candy Cane", "Gingerbread", "Polar", "Krampus", "Mistletoe",
}
local StyleNames = {}

--------------------------------------------------------------------------------
-- core state + helpers
--------------------------------------------------------------------------------
local Lib = { Themes = Themes, ThemeNames = ThemeNames, StyleNames = StyleNames, IsMobile = IsMobile, Logo = LOGO_URL, Version = "2.2" }
local State = { Theme = "Christmas", Accent = nil, BaseAccent = nil, Rounding = 1, Opacity = 1, Scale = 1, Listening = false }

Lib.UI = {
	fx = {
		on = true, menuOnly = true, style = "Christmas Eve", tint = "Style",
		opacity = 0.8, density = IsMobile and 0.65 or 1, speed = 1, deco = true, lightning = true,
		vignette = true, vignetteStrength = 0.5, fade = 1, trail = false, burst = false,
	},
	stats = {
		on = true, logo = true, name = not IsMobile, ping = true, fps = true, players = not IsMobile, time = false,
		quality = true, scale = IsMobile and 0.88 or 1, opacity = 1, preset = "Top Center",
	},
	keys = {
		on = not IsMobile, showUnbound = true, maxRows = 7, scale = 1, opacity = 1,
		collapsed = false, menu = "",
	},
	look = {
		theme = "", accent = "", customAccent = false, rainbow = false, rainbowSpeed = 1,
		border = false, glow = false, blur = false, ripple = true,
		opacity = 1, rounding = 1, scale = 1,
	},
}
Lib.Registry = { extra = {}, built = {}, window = nil }
Lib.AutoSave = true
Lib.SavedBinds = {}

local UI, Registry = Lib.UI, Lib.Registry
Registry.list, Registry.byId, Registry.feats = {}, {}, {}
Registry.tabs, Registry.sections, Registry.config = {}, {}, {}

function Registry.add(h)
	Registry.built[h.Def.Name] = h
	local saved = Lib.SavedBinds and Lib.SavedBinds[h.Def.Name]
	if saved then
		local ok, k = pcall(function() return Enum.KeyCode[saved] end)
		if ok and k then h.key = k end
	end
	if Lib.Hud and Lib.Hud.addFeature then Lib.Hud.addFeature(h) end
end

local CONFIG_FILE = "SHub_config.json"
local CONFIG_GROUPS = { "fx", "stats", "keys", "look" }
local function canFile()
	return typeof(writefile) == "function" and typeof(readfile) == "function" and typeof(isfile) == "function"
end

function Lib:SaveConfig()
	if not canFile() then return end
	local binds, feats = {}, {}
	for name, h in pairs(Registry.built) do
		if h.key then binds[name] = h.key.Name end
	end
	for id, h in pairs(Registry.feats) do
		feats[id] = { on = h.state, values = h.values }
	end
	pcall(function()
		writefile(CONFIG_FILE, HttpService:JSONEncode({ fx = UI.fx, stats = UI.stats, keys = UI.keys, look = UI.look, binds = binds, features = feats }))
	end)
end

function Lib:LoadConfig()
	if not canFile() then return end
	pcall(function()
		if not isfile(CONFIG_FILE) then return end
		local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
		for _, group in ipairs(CONFIG_GROUPS) do
			for k, v in pairs(data[group] or {}) do
				local cur = UI[group][k]
				if cur ~= nil and typeof(v) == typeof(cur) then UI[group][k] = v end
			end
		end
		if IsMobile then UI.keys.on = false end
		Lib.SavedBinds = data.binds or {}
		Registry.config = type(data.features) == "table" and data.features or {}
	end)
end

local saving = false
local function saveSoon()
	if not Lib.AutoSave or saving then return end
	saving = true
	task.delay(1, function() saving = false; Lib:SaveConfig() end)
end

local refreshers, corners, glassList, conns, spinners = {}, {}, {}, {}, {}
local orders = setmetatable({}, { __mode = "k" })
local cardStroke = setmetatable({}, { __mode = "k" })

local FAST = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local SLOW = TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local BACK = TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local SMOOTH = TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local SPRING = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local MICRO = TweenInfo.new(0.09, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local FONT = Enum.Font.GothamMedium
local BOLD = Enum.Font.GothamBold

local function kp(t, v) return NumberSequenceKeypoint.new(t, v) end
local function ckp(t, v) return ColorSequenceKeypoint.new(t, v) end

local function shiftHue(col, d)
	local h, s, v = col:ToHSV()
	return Color3.fromHSV((h + d) % 1, s, v)
end

local function C(role)
	local t = Themes[State.Theme] or Themes.Eclipse
	if role == "Accent" then
		return State.Accent or t.Accent or Themes.Eclipse.Accent
	elseif role == "Accent2" then
		if State.Accent then return shiftHue(State.Accent, 0.05) end
		return t.Accent2 or shiftHue(t.Accent or Themes.Eclipse.Accent, 0.05)
	end
	return t[role] or Themes.Eclipse[role] or WHITE
end

local function onAccent()
	local a = C("Accent")
	local lum = 0.299 * a.R + 0.587 * a.G + 0.114 * a.B
	return lum > 0.62 and c(16, 16, 20) or c(255, 255, 255)
end

local function tween(obj, props, info)
	if info == false then
		for k, v in pairs(props) do obj[k] = v end
		return
	end
	TweenService:Create(obj, info or FAST, props):Play()
end

local function make(class, props, children)
	local inst = Instance.new(class)
	local parent
	for k, v in pairs(props or {}) do
		if k == "Parent" then parent = v else inst[k] = v end
	end
	for _, ch in ipairs(children or {}) do ch.Parent = inst end
	inst.Parent = parent
	return inst
end

local function connect(signal, fn)
	local con = signal:Connect(fn)
	table.insert(conns, con)
	return con
end

local function bind(inst, prop, role)
	inst[prop] = C(role)
	table.insert(refreshers, function(t)
		if inst.Parent then tween(inst, { [prop] = C(role) }, t) end
	end)
end

local function reg(fn)
	table.insert(refreshers, fn)
	fn(false)
end

local function refreshAll(info)
	local n = #refreshers
	for i = n, 1, -1 do
		local ok = pcall(refreshers[i], info)
		if not ok then table.remove(refreshers, i) end
	end
end

local function round(inst, r)
	local corner = make("UICorner", { CornerRadius = UDim.new(0, floor(r * State.Rounding + 0.5)), Parent = inst })
	table.insert(corners, { c = corner, r = r })
	return corner
end

local function pill(inst)
	return make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = inst })
end

local function outline(inst, role, thickness)
	local s = make("UIStroke", { Thickness = thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = inst })
	bind(s, "Color", role or "Stroke")
	return s
end

local function accentGradient(parent, rot)
	local g = make("UIGradient", { Rotation = rot or 0, Parent = parent })
	reg(function()
		if g.Parent then
			local a1 = C("Accent")
			local a2 = a1:Lerp(C("Accent2"), 0.28)
			g.Color = ColorSequence.new(a1, a2)
		end
	end)
	return g
end

local function spinStroke(inst, thick, always)
	local s = make("UIStroke", { Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = inst })
	local g = make("UIGradient", { Transparency = NumberSequence.new({ kp(0, 0), kp(0.5, 0.55), kp(1, 0) }), Parent = s })
	table.insert(spinners, { s = s, g = g, ofs = random(0, 360) })
	reg(function()
		if not s.Parent then return end
		local on = (always and UI.look.border) or UI.look.border
		g.Enabled = on
		g.Color = ColorSequence.new({ ckp(0, C("Accent")), ckp(0.5, C("Accent2")), ckp(1, C("Accent")) })
		s.Color = on and WHITE or C("Stroke")
		s.Thickness = on and (thick or 1.2) or 1
		s.Transparency = on and 0.15 or 0.35
	end)
	return s, g
end

local function label(parent, txt, o)
	o = o or {}
	local l = make("TextLabel", {
		Parent = parent,
		BackgroundTransparency = 1,
		Text = txt,
		Font = o.Font or FONT,
		TextSize = o.Size or (IsMobile and 12 or 12),
		TextXAlignment = o.AlignX or Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextWrapped = o.Wrap or false,
		Size = o.Box or udim2New(1, 0, 1, 0),
		Position = o.Pos or udim2New(),
		AutomaticSize = o.Auto or Enum.AutomaticSize.None,
		ZIndex = o.Z or 1,
	})
	if o.Role ~= false then bind(l, "TextColor3", o.Role or "Text") end
	return l
end

local function nextOrder(p)
	orders[p] = (orders[p] or 0) + 1
	return orders[p]
end

local function card(parent, h)
	local f = make("Frame", { Size = udim2New(1, 0, 0, h), BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = nextOrder(parent), Parent = parent })
	bind(f, "BackgroundColor3", "Element")
	f.BackgroundTransparency = 1 - State.Opacity
	table.insert(glassList, f)
	round(f, 5)
	local s = outline(f, "Stroke")
	s.Transparency = 0.65
	cardStroke[f] = s
	return f
end

local function hover(hit, f)
	local s = cardStroke[f]
	local sc = f:FindFirstChildOfClass("UIScale") or make("UIScale", { Scale = 1, Parent = f })
	hit.MouseEnter:Connect(function()
		tween(f, { BackgroundColor3 = C("Hover") })
		if s then tween(s, { Color = C("Accent"), Transparency = 0.35 }) end
	end)
	hit.MouseLeave:Connect(function()
		tween(f, { BackgroundColor3 = C("Element") })
		tween(sc, { Scale = 1 }, FAST)
		if s then tween(s, { Color = C("Stroke"), Transparency = 0.65 }) end
	end)
	hit.MouseButton1Down:Connect(function()
		tween(sc, { Scale = 0.985 }, MICRO)
	end)
	hit.MouseButton1Up:Connect(function()
		tween(sc, { Scale = 1 }, SPRING)
	end)
end

local function isPress(i)
	return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end

local function ripple(f)
	if not UI.look.ripple or not f or not f.Parent then return end
	local absPos, size = f.AbsolutePosition, f.AbsoluteSize
	if size.X < 1 or size.Y < 1 then return end
	local m = UserInputService:GetMouseLocation()
	local rx = clamp((m.X - absPos.X) / size.X, 0, 1)
	local ry = clamp((m.Y - absPos.Y) / size.Y, 0, 1)
	local d = max(size.X, size.Y) * 2.15
	local r = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = udim2FromScale(rx, ry), Size = udim2FromScale(0, 0),
		BackgroundColor3 = C("Accent"), BackgroundTransparency = 0.78, BorderSizePixel = 0, ZIndex = 0, Parent = f,
	})
	pill(r)
	tween(r, { Size = udim2FromScale(d / size.X, d / size.Y), BackgroundTransparency = 1 }, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
	task.delay(0.48, function() if r.Parent then r:Destroy() end end)
end

local function makeDraggable(handle, target)
	local dragging, moved, active, startPos, startUDim = false, false, nil, nil, nil
	local dragInfo = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	handle.InputBegan:Connect(function(i)
		if isPress(i) then
			dragging, moved, active = true, false, i
			startPos, startUDim = i.Position, target.Position
		end
	end)
	connect(UserInputService.InputChanged, function(i)
		if not dragging then return end
		if i == active or i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
			local d = i.Position - startPos
			if d.Magnitude > 5 then moved = true end
			if moved then
				TweenService:Create(target, dragInfo, {
					Position = udim2New(startUDim.X.Scale, startUDim.X.Offset + d.X, startUDim.Y.Scale, startUDim.Y.Offset + d.Y),
				}):Play()
			end
		end
	end)
	connect(UserInputService.InputEnded, function(i)
		if dragging and (i == active or (isPress(i) and active and active.UserInputType == i.UserInputType)) then
			dragging = false
		end
	end)
	return { moved = function() return moved end }
end

local function fit(w, h)
	local cam = workspace.CurrentCamera
	if not cam then return 1 end
	local vp = cam.ViewportSize
	local pad = IsMobile and 14 or 24
	return clamp(min((vp.X - pad) / w, (vp.Y - pad) / h), 0.38, 1)
end

local cachedLogoAsset = nil
local logoFetching = false
local logoCallbacks = {}

local function resolveLogo(image, cb)
	image = (image ~= nil and image ~= "") and image or LOGO_URL
	if image == nil or image == "" then return end

	if typeof(image) == "number" or (typeof(image) == "string" and image:match("^%d+$")) then
		return task.spawn(cb, "rbxassetid://" .. image)
	end
	if typeof(image) ~= "string" then return end
	if image:match("^rbxasset") then return task.spawn(cb, image) end

	if image == LOGO_URL and cachedLogoAsset then
		return task.spawn(cb, cachedLogoAsset)
	end
	table.insert(logoCallbacks, cb)
	if logoFetching then return end
	logoFetching = true

	task.spawn(function()
		local req = (syn and syn.request) or http_request or request
		local assetUrl = nil
		if req and typeof(writefile) == "function" and (getcustomasset or getsynasset) then
			local ok, res = pcall(req, { Url = image, Method = "GET" })
			if ok and res and res.Body and #res.Body > 0 then
				local data = res.Body
				local isPng = data:sub(1, 4) == "\137PNG"
				local isJpg = data:sub(1, 3) == "\255\216\255"
				if isPng or isJpg then
					local file = "SHub_logo" .. (isPng and ".png" or ".jpg")
					if pcall(writefile, file, data) then
						local aok, asset = pcall(getcustomasset or getsynasset, file)
						if aok and asset then assetUrl = asset end
					end
				end
			end
		end
		cachedLogoAsset = assetUrl
		logoFetching = false
		if assetUrl then
			for _, fn in ipairs(logoCallbacks) do task.spawn(fn, assetUrl) end
		end
		table.clear(logoCallbacks)
	end)
end

local function logoImage(parent, image, textObj, radius)
	resolveLogo(image, function(asset)
		if not parent.Parent then return end
		local img = make("ImageLabel", {
			Name = "LogoImage",
			Size = udim2FromScale(1, 1),
			Position = udim2FromScale(0, 0),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = asset,
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = parent.ZIndex + 1,
			Parent = parent,
		})
		round(img, radius or 6)

		local t0 = os.clock()
		while img.Parent and not img.IsLoaded and os.clock() - t0 < 3 do task.wait() end
		if not img.Parent then return end
		if not img.IsLoaded then img:Destroy() return end

		parent.BackgroundTransparency = 1
		local ring = parent:FindFirstChildOfClass("UIStroke")
		if ring then ring.Enabled = false end
		local grad = parent:FindFirstChildOfClass("UIGradient")
		if grad then grad.Enabled = false end
		if textObj then textObj.TextTransparency = 1 end
	end)
end

local function logoTile(parent, size, radius, letter, image, pos, textSize)
	local logo = make("Frame", { Size = udim2FromOffset(size, size), Position = pos or udim2New(), BorderSizePixel = 0, Parent = parent })
	bind(logo, "BackgroundColor3", "Accent")
	round(logo, min(radius, 6))
	local t = label(logo, letter, { Font = BOLD, Size = textSize or floor(size * 0.54), AlignX = Enum.TextXAlignment.Center, Role = false })
	reg(function(tt) tween(t, { TextColor3 = onAccent() }, tt) end)
	logoImage(logo, image, t, radius)
	return logo, t
end

--------------------------------------------------------------------------------
-- section elements
--------------------------------------------------------------------------------
local Section = {}
Section.__index = Section

local ROW_H = IsMobile and 32 or 30
local ROW_DESC_H = IsMobile and 42 or 40

local function indexItem(sec, f, name)
	if sec and sec.Tab then
		table.insert(sec.Tab.items, { f = f, name = string.lower(tostring(name or "")), sec = sec })
	end
end

function Section:AddLabel(text)
	local l = label(self.Frame, text, { Size = 11, Role = "SubText", Box = udim2New(1, 0, 0, 16) })
	l.LayoutOrder = nextOrder(self.Frame)
	l.TextWrapped = true
	l.AutomaticSize = Enum.AutomaticSize.Y
	indexItem(self, l, text)
	return l
end

function Section:AddCard(o)
	o = o or {}
	local f = make("Frame", { Size = udim2New(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BorderSizePixel = 0, LayoutOrder = nextOrder(self.Frame), Parent = self.Frame })
	bind(f, "BackgroundColor3", "Element")
	f.BackgroundTransparency = 1 - State.Opacity
	table.insert(glassList, f)
	round(f, 5)
	local st = outline(f, "Stroke")
	st.Transparency = 0.65
	local bar = make("Frame", { Size = udim2New(0, 2, 1, -14), Position = udim2FromOffset(7, 7), BorderSizePixel = 0, Parent = f })
	pill(bar)
	if o.Color then bar.BackgroundColor3 = o.Color else bind(bar, "BackgroundColor3", "Accent") end
	local inner = make("Frame", { Size = udim2New(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = f })
	make("UIPadding", { PaddingTop = UDim.new(0, 7), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 9), Parent = inner })
	make("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = inner })
	local title = label(inner, o.Title or "", { Font = BOLD, Size = 12, Box = udim2New(1, 0, 0, 16) })
	title.LayoutOrder = 1
	local body = label(inner, o.Body or o.Content or "", { Size = 11, Role = "SubText", Wrap = true, Box = udim2New(1, 0, 0, 0), Auto = Enum.AutomaticSize.Y })
	body.LayoutOrder = 2
	indexItem(self, f, (o.Title or "") .. " " .. (o.Body or o.Content or ""))
	return {
		SetBody = function(t) body.Text = t end,
		SetTitle = function(t) title.Text = t end,
	}
end

function Section:AddParagraph(o)
	o = o or {}
	return self:AddCard({ Title = o.Title, Body = o.Content or o.Body, Color = o.Color })
end

function Section:AddProfile(o)
	o = o or {}
	local username = o.Username or "Roblox"
	local roleText = o.Role or "Contributor"
	local badgeText = o.Badge or "TEAM"
	local col = o.Color

	local f = card(self.Frame, 52)
	local bar = make("Frame", { Size = udim2New(0, 2.5, 1, -14), Position = udim2FromOffset(6, 7), BorderSizePixel = 0, Parent = f })
	pill(bar)
	if col then bar.BackgroundColor3 = col else bind(bar, "BackgroundColor3", "Accent") end

	local av = make("ImageLabel", { Size = udim2FromOffset(36, 36), Position = udim2FromOffset(14, 8), BorderSizePixel = 0, Parent = f })
	bind(av, "BackgroundColor3", "Surface")
	pill(av)
	local avSt = outline(av, "Stroke", 1.2)
	if col then avSt.Color = col end

	local nameL = label(f, "@" .. username, { Font = BOLD, Size = 12, Box = udim2New(1, -135, 0, 16), Pos = udim2FromOffset(58, 9) })
	nameL.TextTruncate = Enum.TextTruncate.AtEnd
	local roleL = label(f, roleText, { Size = 11, Role = "SubText", Box = udim2New(1, -66, 0, 14), Pos = udim2FromOffset(58, 26) })
	roleL.TextTruncate = Enum.TextTruncate.AtEnd

	local badge = make("Frame", { AutomaticSize = Enum.AutomaticSize.X, Size = udim2FromOffset(0, 18), AnchorPoint = Vector2.new(1, 0), Position = udim2New(1, -10, 0, 8), BorderSizePixel = 0, BackgroundTransparency = 0.84, Parent = f })
	if col then badge.BackgroundColor3 = col else bind(badge, "BackgroundColor3", "Accent") end
	round(badge, 4)
	make("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), Parent = badge })
	local bl = label(badge, badgeText, { Font = BOLD, Size = 9, AlignX = Enum.TextXAlignment.Center, Box = udim2FromOffset(0, 18), Auto = Enum.AutomaticSize.X, Role = col and false or "Accent" })
	if col then bl.TextColor3 = col end

	local hit = make("TextButton", { Size = udim2FromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 3, Parent = f })
	hover(hit, f)
	hit.MouseButton1Click:Connect(function()
		ripple(f)
		local copy = setclipboard or toclipboard or (Clipboard and Clipboard.set)
		if typeof(copy) == "function" then
			pcall(copy, username)
			if Registry.window then Registry.window:Notify("Copied", "Copied @" .. username .. " to clipboard", 2.5, "Success") end
		end
	end)

	task.spawn(function()
		local ok, uid = pcall(Players.GetUserIdFromNameAsync, Players, username)
		if ok and uid then
			local tok, img = pcall(Players.GetUserThumbnailAsync, Players, uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
			if tok and av.Parent then av.Image = img end
		end
	end)

	indexItem(self, f, username .. " " .. roleText .. " " .. badgeText)
	return f
end

function Section:AddDivider(text)
	local f = make("Frame", { Size = udim2New(1, 0, 0, text and 16 or 6), BackgroundTransparency = 1, LayoutOrder = nextOrder(self.Frame), Parent = self.Frame })
	local function line(size, pos)
		local l = make("Frame", { Size = size, Position = pos, AnchorPoint = Vector2.new(0, 0.5), BorderSizePixel = 0, BackgroundTransparency = 0.4, Parent = f })
		bind(l, "BackgroundColor3", "Stroke")
		return l
	end
	if text then
		label(f, string.upper(text), { Font = BOLD, Size = 10, Role = "SubText", AlignX = Enum.TextXAlignment.Center })
		line(udim2New(0.28, 0, 0, 1), udim2New(0, 0, 0.5, 0))
		line(udim2New(0.28, 0, 0, 1), udim2New(0.72, 0, 0.5, 0))
	else
		line(udim2New(1, 0, 0, 1), udim2New(0, 0, 0.5, 0))
	end
	indexItem(self, f, text)
	return f
end

function Section:AddButton(o)
	local f = card(self.Frame, o.Desc and ROW_DESC_H or ROW_H)
	label(f, o.Name, { Box = udim2New(1, -40, 0, 16), Pos = udim2FromOffset(10, o.Desc and 5 or floor((ROW_H - 16) / 2)) })
	if o.Desc then label(f, o.Desc, { Box = udim2New(1, -40, 0, 13), Pos = udim2FromOffset(10, 22), Size = 10, Role = "SubText" }) end
	local arrow = label(f, "›", { Font = BOLD, Size = 15, Role = "SubText", AlignX = Enum.TextXAlignment.Center, Box = udim2FromOffset(18, 18), Pos = udim2New(1, -25, 0.5, -9) })
	local hit = make("TextButton", { Size = udim2FromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 3, Parent = f })
	hover(hit, f)
	hit.MouseEnter:Connect(function()
		tween(arrow, { TextColor3 = C("Accent"), Position = udim2New(1, -22, 0.5, -9) }, FAST)
	end)
	hit.MouseLeave:Connect(function()
		tween(arrow, { TextColor3 = C("SubText"), Position = udim2New(1, -25, 0.5, -9) }, FAST)
	end)
	hit.MouseButton1Click:Connect(function()
		ripple(f)
		tween(arrow, { Position = udim2New(1, -19, 0.5, -9) }, MICRO)
		task.delay(0.09, function()
			if arrow.Parent then tween(arrow, { Position = udim2New(1, -22, 0.5, -9) }, SPRING) end
		end)
		if o.Callback then task.spawn(o.Callback) end
	end)
	indexItem(self, f, (o.Name or "") .. " " .. (o.Desc or ""))
	return { Fire = function() if o.Callback then task.spawn(o.Callback) end end }
end

function Section:AddToggle(o)
	local state = o.Default == true
	local f = card(self.Frame, o.Desc and ROW_DESC_H or ROW_H)
	label(f, o.Name, { Box = udim2New(1, -58, 0, 16), Pos = udim2FromOffset(10, o.Desc and 5 or floor((ROW_H - 16) / 2)) })
	if o.Desc then label(f, o.Desc, { Box = udim2New(1, -58, 0, 13), Pos = udim2FromOffset(10, 22), Size = 10, Role = "SubText" }) end
	local trackF = make("Frame", { Size = udim2FromOffset(34, 17), Position = udim2New(1, -44, 0.5, -8.5), BorderSizePixel = 0, Parent = f })
	pill(trackF)
	local knob = make("Frame", {
		Size = udim2FromOffset(13, 13), AnchorPoint = Vector2.new(0, 0.5), BorderSizePixel = 0, BackgroundColor3 = c(250, 250, 252),
		Position = state and udim2New(0, 19, 0.5, 0) or udim2New(0, 2, 0.5, 0), ZIndex = 2, Parent = trackF,
	})
	pill(knob)
	local function paint(t)
		tween(trackF, { BackgroundColor3 = state and C("Accent") or C("Stroke") }, t)
		tween(knob, { BackgroundColor3 = state and onAccent() or c(220, 220, 228) }, t)
	end
	reg(paint)

	local obj = {}
	function obj.Set(v, silent)
		state = v and true or false
		paint()
		tween(knob, { Size = udim2FromOffset(16, 12), Position = state and udim2New(0, 16, 0.5, 0) or udim2New(0, 2, 0.5, 0) }, MICRO)
		task.delay(0.08, function()
			if knob.Parent then
				tween(knob, { Size = udim2FromOffset(13, 13), Position = state and udim2New(0, 19, 0.5, 0) or udim2New(0, 2, 0.5, 0) }, SPRING)
			end
		end)
		if not silent and o.Callback then task.spawn(o.Callback, state) end
	end
	function obj.Get() return state end

	local hit = make("TextButton", { Size = udim2FromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 3, Parent = f })
	hover(hit, f)
	hit.MouseButton1Click:Connect(function()
		ripple(f)
		obj.Set(not state)
	end)
	indexItem(self, f, (o.Name or "") .. " " .. (o.Desc or ""))
	return obj
end

function Section:AddSlider(o)
	local minV, maxV, step = o.Min or 0, o.Max or 100, o.Step or 1
	if maxV <= minV then maxV = minV + 1 end
	local value = clamp(o.Default or minV, minV, maxV)
	local f = card(self.Frame, IsMobile and 46 or 44)
	f.ClipsDescendants = false
	label(f, o.Name, { Box = udim2New(1, -80, 0, 16), Pos = udim2FromOffset(10, 5) })
	local val = make("TextBox", {
		Size = udim2FromOffset(50, 16), Position = udim2New(1, -60, 0, 5), Text = "", Font = FONT, TextSize = 11,
		ClearTextOnFocus = false, BorderSizePixel = 0, Parent = f,
	})
	bind(val, "BackgroundColor3", "Background")
	bind(val, "TextColor3", "SubText")
	round(val, 4)
	local vs = outline(val, "Stroke")
	vs.Transparency = 0.6
	local tr = make("Frame", { Size = udim2New(1, -20, 0, IsMobile and 5 or 4), Position = udim2FromOffset(10, 31), BorderSizePixel = 0, Parent = f })
	pill(tr)
	bind(tr, "BackgroundColor3", "Stroke")
	local fill = make("Frame", { Size = udim2FromScale(0, 1), BorderSizePixel = 0, Parent = tr })
	pill(fill)
	bind(fill, "BackgroundColor3", "Accent")
	local kSz = IsMobile and 14 or 11
	local knob = make("Frame", { Size = udim2FromOffset(kSz, kSz), AnchorPoint = Vector2.new(0.5, 0.5), Position = udim2FromScale(1, 0.5), BorderSizePixel = 0, BackgroundColor3 = WHITE, ZIndex = 2, Parent = fill })
	pill(knob)
	outline(knob, "Accent", 1.5)
	local knobScale = make("UIScale", { Scale = 1, Parent = knob })

	local obj = {}
	local function render(instant)
		local pct = (value - minV) / (maxV - minV)
		if instant then
			fill.Size = udim2FromScale(pct, 1)
		else
			tween(fill, { Size = udim2FromScale(pct, 1) }, MICRO)
		end
		if not val:IsFocused() then val.Text = string.format("%g", value) .. (o.Suffix or "") end
	end
	function obj.Set(v, silent)
		v = clamp(floor((v - minV) / step + 0.5) * step + minV, minV, maxV)
		value = tonumber(string.format("%.4f", v))
		render(false)
		if not silent and o.Callback then o.Callback(value) end
	end
	function obj.Get() return value end
	render(true)

	val.Focused:Connect(function()
		tween(vs, { Color = C("Accent"), Transparency = 0.1 })
		tween(val, { TextColor3 = C("Text") })
		val.Text = string.format("%g", value)
	end)
	val.FocusLost:Connect(function()
		tween(vs, { Color = C("Stroke"), Transparency = 0.6 })
		tween(val, { TextColor3 = C("SubText") })
		local n = tonumber((val.Text:match("%-?[%d%.]+")))
		if n then obj.Set(n) end
		val.Text = string.format("%g", value) .. (o.Suffix or "")
	end)

	local dragging = false
	local function fromX(x)
		local a = clamp((x - tr.AbsolutePosition.X) / max(1, tr.AbsoluteSize.X), 0, 1)
		obj.Set(minV + (maxV - minV) * a)
	end
	local hit = make("TextButton", { Size = udim2New(1, 0, 0, 24), Position = udim2FromOffset(0, 21), BackgroundTransparency = 1, Text = "", ZIndex = 3, Parent = f })
	hover(hit, f)
	hit.MouseEnter:Connect(function() tween(knobScale, { Scale = 1.18 }, FAST) end)
	hit.MouseLeave:Connect(function() if not dragging then tween(knobScale, { Scale = 1 }, FAST) end end)
	hit.InputBegan:Connect(function(i)
		if isPress(i) then
			dragging = true
			tween(knobScale, { Scale = 1.3 }, SPRING)
			fromX(i.Position.X)
		end
	end)
	connect(UserInputService.InputChanged, function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then fromX(i.Position.X) end
	end)
	connect(UserInputService.InputEnded, function(i)
		if isPress(i) and dragging then
			dragging = false
			tween(knobScale, { Scale = 1 }, SPRING)
		end
	end)
	indexItem(self, f, o.Name)
	return obj
end

function Section:AddDropdown(o)
	local options = o.Options or {}
	local multi = o.Multi == true
	local current
	if multi then
		current = {}
		if type(o.Default) == "table" then for _, v in ipairs(o.Default) do current[v] = true end end
	else
		current = o.Default
		if current == nil then current = options[1] end
	end
	local open = false
	local obj = {}

	local container = make("Frame", { Size = udim2New(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = nextOrder(self.Frame), Parent = self.Frame })
	make("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = container })

	local head = card(container, ROW_H)
	head.LayoutOrder = 1
	if o.Name then label(head, o.Name, { Box = udim2New(0.5, -10, 1, 0), Pos = udim2FromOffset(10, 0) }) end
	local valLabel = label(head, "", {
		Box = o.Name and udim2New(0.5, -32, 1, 0) or udim2New(1, -44, 1, 0),
		Pos = o.Name and udim2New(0.5, 0, 0, 0) or udim2FromOffset(10, 0),
		AlignX = o.Name and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left, Role = "SubText", Size = 11,
	})
	valLabel.TextTruncate = Enum.TextTruncate.AtEnd
	local chev = label(head, "›", { Box = udim2FromOffset(18, ROW_H), Pos = udim2New(1, -24, 0, 0), AlignX = Enum.TextXAlignment.Center, Font = BOLD, Role = "SubText", Size = 14 })
	chev.Rotation = 90
	local hit = make("TextButton", { Size = udim2FromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 3, Parent = head })
	hover(hit, head)

	local searchable = o.Search == true
	local panel = make("Frame", { Size = udim2New(1, 0, 0, 0), Visible = false, BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = 2, Parent = container })
	bind(panel, "BackgroundColor3", "Surface")
	local ps = outline(panel, "Stroke")
	ps.Transparency = 0.45
	round(panel, 5)

	local box
	if searchable then
		box = make("TextBox", {
			Size = udim2New(1, -12, 0, 24), Position = udim2FromOffset(6, 6), Text = "", PlaceholderText = "Filter...",
			ClearTextOnFocus = false, Font = FONT, TextSize = 11, BorderSizePixel = 0, TextXAlignment = Enum.TextXAlignment.Left, Parent = panel,
		})
		make("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = box })
		bind(box, "BackgroundColor3", "Background")
		bind(box, "TextColor3", "Text")
		bind(box, "PlaceholderColor3", "SubText")
		round(box, 4)
		local bs = outline(box, "Stroke")
		bs.Transparency = 0.5
		box.Focused:Connect(function() tween(bs, { Color = C("Accent"), Transparency = 0.1 }) end)
		box.FocusLost:Connect(function() tween(bs, { Color = C("Stroke"), Transparency = 0.5 }) end)
	end

	local list = make("ScrollingFrame", {
		Size = udim2New(1, -12, 0, 0), Position = udim2FromOffset(6, 6), BackgroundTransparency = 1, BorderSizePixel = 0,
		ScrollBarThickness = 2, CanvasSize = udim2New(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = panel,
	})
	bind(list, "ScrollBarImageColor3", "Stroke")
	make("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list })

	local function dims()
		local listH = min(max(#options, 1) * 24 + 4, 138)
		local top = searchable and 35 or 6
		return listH, top, top + listH + 6
	end
	local function isSel(opt)
		if multi then return current[opt] == true end
		return opt == current
	end
	local function listOut()
		if not multi then return current end
		local t = {}
		for _, opt in ipairs(options) do if current[opt] then table.insert(t, opt) end end
		return t
	end
	local function display()
		if multi then
			local t = listOut()
			for i, v in ipairs(t) do t[i] = tostring(v) end
			return #t > 0 and table.concat(t, ", ") or "None"
		end
		return current ~= nil and tostring(current) or "None"
	end

	local rowsD = {}
	local function paintRow(r, t)
		local sel = isSel(r.opt)
		r.bar.BackgroundColor3 = C("Accent")
		tween(r.b, { BackgroundTransparency = sel and 0.88 or (r.hov and 0.45 or 1), BackgroundColor3 = sel and C("Accent") or C("Hover") }, t)
		tween(r.l, { TextColor3 = sel and C("Text") or (r.hov and C("Text") or C("SubText")), Position = udim2FromOffset((sel or r.hov) and 13 or 10, 0) }, t)
		tween(r.bar, { BackgroundTransparency = sel and 0 or 1, Size = udim2FromOffset(2, sel and 12 or 0) }, t)
	end

	local setOpen
	local function render()
		for _, r in ipairs(rowsD) do r.b:Destroy() end
		table.clear(rowsD)
		local q = box and box.Text:lower() or ""
		for i, opt in ipairs(options) do
			local s = tostring(opt)
			if q == "" or s:lower():find(q, 1, true) then
				local b = make("TextButton", { Size = udim2New(1, 0, 0, 22), Text = "", AutoButtonColor = false, BorderSizePixel = 0, BackgroundTransparency = 1, LayoutOrder = i, Parent = list })
				make("UICorner", { CornerRadius = UDim.new(0, 4), Parent = b })
				local bar = make("Frame", { Size = udim2FromOffset(2, 0), AnchorPoint = Vector2.new(0, 0.5), Position = udim2New(0, 4, 0.5, 0), BorderSizePixel = 0, BackgroundTransparency = 1, Parent = b })
				pill(bar)
				local l = make("TextLabel", {
					Size = udim2New(1, -16, 1, 0), Position = udim2FromOffset(10, 0), BackgroundTransparency = 1, Text = s,
					Font = FONT, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = b,
				})
				local r = { b = b, l = l, bar = bar, opt = opt, hov = false }
				table.insert(rowsD, r)
				paintRow(r, false)
				b.MouseEnter:Connect(function() r.hov = true; paintRow(r) end)
				b.MouseLeave:Connect(function() r.hov = false; paintRow(r) end)
				b.MouseButton1Click:Connect(function()
					if multi then
						current[opt] = (not current[opt]) or nil
						obj._changed()
						for _, rr in ipairs(rowsD) do paintRow(rr) end
					else
						obj.Set(opt)
						setOpen(false)
					end
				end)
			end
		end
	end

	function setOpen(v)
		open = v
		tween(chev, { Rotation = v and -90 or 90, TextColor3 = v and C("Accent") or C("SubText") }, SPRING)
		local listH, top, fullH = dims()
		list.Size = udim2New(1, -12, 0, listH)
		list.Position = udim2FromOffset(6, top)
		if v then
			render()
			panel.Visible = true
			panel.Size = udim2New(1, 0, 0, 0)
			tween(panel, { Size = udim2New(1, 0, 0, fullH) }, SMOOTH)
		else
			tween(panel, { Size = udim2New(1, 0, 0, 0) }, FAST)
			task.delay(0.15, function() if not open then panel.Visible = false end end)
		end
	end

	function obj._changed(silent)
		valLabel.Text = display()
		if not silent and o.Callback then task.spawn(o.Callback, listOut()) end
	end
	function obj.Set(v, silent)
		if multi then
			current = {}
			if type(v) == "table" then for _, x in ipairs(v) do current[x] = true end end
		else
			current = v
		end
		if open then for _, r in ipairs(rowsD) do paintRow(r) end end
		obj._changed(silent)
	end
	function obj.Get() return listOut() end
	function obj.Refresh(newOpts, keep)
		options = newOpts or {}
		if not keep then
			if multi then current = {} else current = options[1] end
		end
		obj._changed(true)
		if open then
			render()
			local listH, top, fullH = dims()
			list.Size = udim2New(1, -12, 0, listH)
			list.Position = udim2FromOffset(6, top)
			tween(panel, { Size = udim2New(1, 0, 0, fullH) }, SLOW)
		end
	end
	obj._changed(true)

	if box then box:GetPropertyChangedSignal("Text"):Connect(function() if open then render() end end) end
	reg(function(t) if open then for _, r in ipairs(rowsD) do pcall(paintRow, r, t) end end end)
	hit.MouseButton1Click:Connect(function()
		ripple(head)
		setOpen(not open)
	end)
	indexItem(self, container, o.Name)
	return obj
end

function Section:AddColorPicker(o)
	local h, s, v = (o.Default or c(255, 255, 255)):ToHSV()
	local open = false
	local obj = {}
	local PH = 148

	local container = make("Frame", { Size = udim2New(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = nextOrder(self.Frame), Parent = self.Frame })
	make("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = container })

	local head = card(container, ROW_H)
	head.LayoutOrder = 1
	label(head, o.Name, { Box = udim2New(1, -56, 1, 0), Pos = udim2FromOffset(10, 0) })
	local swatch = make("Frame", { Size = udim2FromOffset(24, 15), Position = udim2New(1, -34, 0.5, -7.5), BorderSizePixel = 0, BackgroundColor3 = Color3.fromHSV(h, s, v), Parent = head })
	round(swatch, 4)
	outline(swatch, "Stroke")
	local hit = make("TextButton", { Size = udim2FromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 3, Parent = head })
	hover(hit, head)

	local panel = make("Frame", { Size = udim2New(1, 0, 0, PH), Visible = false, BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = 2, Parent = container })
	bind(panel, "BackgroundColor3", "Surface")
	local ps = outline(panel, "Stroke")
	ps.Transparency = 0.45
	round(panel, 5)

	local sv = make("Frame", { Size = udim2New(1, -40, 0, 102), Position = udim2FromOffset(7, 7), BorderSizePixel = 0, BackgroundColor3 = Color3.fromHSV(h, 1, 1), Parent = panel })
	make("UICorner", { CornerRadius = UDim.new(0, 4), Parent = sv })
	make("Frame", {
		Size = udim2FromScale(1, 1), BorderSizePixel = 0, BackgroundColor3 = c(255, 255, 255), Parent = sv,
	}, { make("UICorner", { CornerRadius = UDim.new(0, 4) }), make("UIGradient", { Transparency = NumberSequence.new(0, 1) }) })
	make("Frame", {
		Size = udim2FromScale(1, 1), BorderSizePixel = 0, BackgroundColor3 = c(0, 0, 0), Parent = sv,
	}, { make("UICorner", { CornerRadius = UDim.new(0, 4) }), make("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0) }) })
	local svCursor = make("Frame", { Size = udim2FromOffset(10, 10), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ZIndex = 3, Parent = sv })
	pill(svCursor)
	make("UIStroke", { Color = c(255, 255, 255), Thickness = 1.5, Parent = svCursor })

	local hue = make("Frame", { Size = udim2FromOffset(16, 102), Position = udim2New(1, -23, 0, 7), BorderSizePixel = 0, BackgroundColor3 = c(255, 255, 255), Parent = panel })
	make("UICorner", { CornerRadius = UDim.new(0, 4), Parent = hue })
	make("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new({
			ckp(0, c(255, 0, 0)), ckp(0.17, c(255, 255, 0)), ckp(0.33, c(0, 255, 0)), ckp(0.5, c(0, 255, 255)),
			ckp(0.67, c(0, 0, 255)), ckp(0.83, c(255, 0, 255)), ckp(1, c(255, 0, 0)),
		}),
		Parent = hue,
	})
	local hueCursor = make("Frame", { Size = udim2New(1, 4, 0, 3), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = c(255, 255, 255), BorderSizePixel = 0, ZIndex = 3, Parent = hue })
	make("UICorner", { CornerRadius = UDim.new(0, 2), Parent = hueCursor })
	make("UIStroke", { Color = c(0, 0, 0), Thickness = 1, Transparency = 0.4, Parent = hueCursor })

	local hex = make("TextBox", {
		Size = udim2New(1, -14, 0, 22), Position = udim2FromOffset(7, 117), Text = "", PlaceholderText = "#FFFFFF",
		ClearTextOnFocus = false, Font = FONT, TextSize = 11, BorderSizePixel = 0, Parent = panel,
	})
	bind(hex, "BackgroundColor3", "Background")
	bind(hex, "TextColor3", "Text")
	bind(hex, "PlaceholderColor3", "SubText")
	round(hex, 4)
	local hs = outline(hex, "Stroke")
	hs.Transparency = 0.5

	local function apply(silent)
		local col = Color3.fromHSV(h, s, v)
		swatch.BackgroundColor3 = col
		sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
		svCursor.Position = udim2FromScale(s, 1 - v)
		hueCursor.Position = udim2FromScale(0.5, h)
		if not hex:IsFocused() then hex.Text = "#" .. string.upper(col:ToHex()) end
		if not silent and o.Callback then o.Callback(col) end
	end
	apply(true)

	hex.Focused:Connect(function() tween(hs, { Color = C("Accent"), Transparency = 0.1 }) end)
	hex.FocusLost:Connect(function()
		tween(hs, { Color = C("Stroke"), Transparency = 0.5 })
		local txt = hex.Text:gsub("#", ""):gsub("%s", "")
		local ok, col = pcall(Color3.fromHex, txt)
		if ok and col and #txt == 6 then
			h, s, v = col:ToHSV()
			apply()
		else
			apply(true)
		end
	end)

	local dragSV, dragH = false, false
	local function updSV(pos)
		s = clamp((pos.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
		v = 1 - clamp((pos.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
		apply()
	end
	local function updH(pos)
		h = clamp((pos.Y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 0.999)
		apply()
	end
	sv.InputBegan:Connect(function(i) if isPress(i) then dragSV = true; updSV(i.Position) end end)
	hue.InputBegan:Connect(function(i) if isPress(i) then dragH = true; updH(i.Position) end end)
	connect(UserInputService.InputChanged, function(i)
		if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
		if dragSV then updSV(i.Position) elseif dragH then updH(i.Position) end
	end)
	connect(UserInputService.InputEnded, function(i)
		if isPress(i) then dragSV, dragH = false, false end
	end)

	hit.MouseButton1Click:Connect(function()
		ripple(head)
		open = not open
		if open then
			panel.Visible = true
			panel.Size = udim2New(1, 0, 0, 0)
			tween(panel, { Size = udim2New(1, 0, 0, PH) }, SMOOTH)
		else
			tween(panel, { Size = udim2New(1, 0, 0, 0) }, FAST)
			task.delay(0.15, function() if not open then panel.Visible = false end end)
		end
	end)

	function obj.Set(col, silent)
		h, s, v = col:ToHSV()
		apply(silent)
	end
	function obj.Get() return Color3.fromHSV(h, s, v) end
	indexItem(self, container, o.Name)
	return obj
end

function Section:AddTextbox(o)
	local f = card(self.Frame, ROW_H)
	label(f, o.Name, { Box = udim2New(0.5, -10, 1, 0), Pos = udim2FromOffset(10, 0) })
	local box = make("TextBox", {
		Size = udim2New(0.5, -15, 0, 20), Position = udim2New(0.5, 5, 0.5, -10), Text = o.Default or "", PlaceholderText = o.Placeholder or "",
		ClearTextOnFocus = false, Font = FONT, TextSize = 11, BorderSizePixel = 0, ClipsDescendants = true, Parent = f,
	})
	bind(box, "BackgroundColor3", "Background")
	bind(box, "TextColor3", "Text")
	bind(box, "PlaceholderColor3", "SubText")
	round(box, 4)
	local bs = outline(box, "Stroke")
	bs.Transparency = 0.55
	box.Focused:Connect(function() tween(bs, { Color = C("Accent"), Transparency = 0.1 }) end)
	if o.MaxLength then
		box:GetPropertyChangedSignal("Text"):Connect(function()
			if #box.Text > o.MaxLength then box.Text = box.Text:sub(1, o.MaxLength) end
		end)
	end
	box.FocusLost:Connect(function()
		tween(bs, { Color = C("Stroke"), Transparency = 0.55 })
		if o.Callback then o.Callback(box.Text) end
	end)
	indexItem(self, f, o.Name)
	return { Set = function(t) box.Text = t end, Get = function() return box.Text end }
end

function Section:AddKeybind(o)
	local key = o.Default or Enum.KeyCode.RightShift
	local f = card(self.Frame, ROW_H)
	label(f, o.Name, { Box = udim2New(1, -98, 1, 0), Pos = udim2FromOffset(10, 0) })
	local b = make("TextButton", {
		Size = udim2FromOffset(78, 20), Position = udim2New(1, -88, 0.5, -10), Text = key.Name, Font = FONT, TextSize = 11,
		AutoButtonColor = false, BorderSizePixel = 0, Parent = f,
	})
	bind(b, "BackgroundColor3", "Background")
	bind(b, "TextColor3", "SubText")
	round(b, 4)
	local bs = outline(b, "Stroke")
	bs.Transparency = 0.55
	local listening = false
	b.MouseButton1Click:Connect(function()
		listening = true
		State.Listening = true
		b.Text = "..."
		tween(bs, { Color = C("Accent"), Transparency = 0.1 })
		tween(b, { TextColor3 = C("Text") })
	end)
	connect(UserInputService.InputBegan, function(i)
		if not listening or i.UserInputType ~= Enum.UserInputType.Keyboard then return end
		listening = false
		task.defer(function() State.Listening = false end)
		if i.KeyCode ~= Enum.KeyCode.Escape then
			key = i.KeyCode
			if o.Callback then o.Callback(key) end
		end
		b.Text = key.Name
		tween(bs, { Color = C("Stroke"), Transparency = 0.55 })
		tween(b, { TextColor3 = C("SubText") })
	end)
	indexItem(self, f, o.Name)
	return {
		Set = function(k) key = k; b.Text = k.Name end,
		Get = function() return key end,
	}
end

function Section:AddProgress(o)
	o = o or {}
	local maxV = o.Max or 100
	local value = clamp(o.Default or 0, 0, maxV)
	local f = card(self.Frame, 40)
	label(f, o.Name or "Progress", { Box = udim2New(1, -72, 0, 16), Pos = udim2FromOffset(10, 4) })
	local val = label(f, "", { Box = udim2FromOffset(58, 16), Pos = udim2New(1, -68, 0, 4), AlignX = Enum.TextXAlignment.Right, Role = "SubText", Size = 11 })
	local tr = make("Frame", { Size = udim2New(1, -20, 0, 4), Position = udim2FromOffset(10, 26), BorderSizePixel = 0, Parent = f })
	pill(tr)
	bind(tr, "BackgroundColor3", "Stroke")
	local fill = make("Frame", { Size = udim2FromScale(0, 1), BorderSizePixel = 0, Parent = tr })
	pill(fill)
	bind(fill, "BackgroundColor3", "Accent")
	local obj = {}
	function obj.Set(x)
		value = clamp(tonumber(x) or 0, 0, maxV)
		tween(fill, { Size = udim2FromScale(value / maxV, 1) }, SMOOTH)
		val.Text = (o.Percent ~= false) and (floor(value / maxV * 100 + 0.5) .. "%") or string.format("%g / %g", value, maxV)
	end
	function obj.Get() return value end
	obj.Set(value)
	indexItem(self, f, o.Name)
	return obj
end

function Section:AddThemeGallery(o)
	o = o or {}
	local wrap = make("Frame", { Size = udim2New(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = nextOrder(self.Frame), Parent = self.Frame })
	local cols = IsMobile and 2 or 3
	make("UIGridLayout", { CellSize = udim2New(1 / cols, -4, 0, 32), CellPadding = udim2FromOffset(5, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = wrap })
	local tiles = {}
	for i, name in ipairs(ThemeNames) do
		local th = Themes[name]
		if th then
			local t = make("TextButton", { Text = "", AutoButtonColor = false, BackgroundColor3 = th.Surface or c(20, 20, 24), BorderSizePixel = 0, LayoutOrder = i, Parent = wrap })
			make("UICorner", { CornerRadius = UDim.new(0, 5), Parent = t })
			local ts = make("UIScale", { Scale = 1, Parent = t })
			local st = make("UIStroke", { Thickness = 1, Color = th.Stroke or c(60, 60, 70), ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = t })
			local dot = make("Frame", { Size = udim2FromOffset(7, 7), Position = udim2New(0, 7, 0.5, -3.5), BorderSizePixel = 0, BackgroundColor3 = th.Accent or WHITE, Parent = t })
			pill(dot)
			local dot2 = make("Frame", { Size = udim2FromOffset(4, 4), Position = udim2New(0, 12, 0.5, 0), BorderSizePixel = 0, BackgroundColor3 = th.Accent2 or th.Accent or WHITE, Parent = t })
			pill(dot2)
			make("TextLabel", {
				Size = udim2New(1, -22, 1, 0), Position = udim2FromOffset(20, 0), BackgroundTransparency = 1, Text = name,
				Font = FONT, TextSize = 10, TextColor3 = th.Text or WHITE, TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd, Parent = t,
			})
			t.MouseEnter:Connect(function()
				tween(t, { BackgroundColor3 = th.Hover or th.Element })
				tween(ts, { Scale = 1.03 }, FAST)
			end)
			t.MouseLeave:Connect(function()
				tween(t, { BackgroundColor3 = th.Surface })
				tween(ts, { Scale = 1 }, FAST)
			end)
			t.MouseButton1Down:Connect(function() tween(ts, { Scale = 0.96 }, MICRO) end)
			t.MouseButton1Up:Connect(function() tween(ts, { Scale = 1.03 }, SPRING) end)
			t.MouseButton1Click:Connect(function()
				if o.Callback then o.Callback(name) end
			end)
			tiles[name] = { st = st, base = th.Stroke or c(60, 60, 70) }
		end
	end
	reg(function()
		for name, e in pairs(tiles) do
			local sel = name == State.Theme
			e.st.Thickness = sel and 1.6 or 1
			e.st.Color = sel and C("Accent") or e.base
			e.st.Transparency = sel and 0 or 0.45
		end
	end)
	indexItem(self, wrap, "theme gallery " .. table.concat(ThemeNames, " "))
	return wrap
end

--------------------------------------------------------------------------------
-- window
--------------------------------------------------------------------------------
function Lib:AddTheme(name, colors)
	if not Themes[name] then table.insert(ThemeNames, name) end
	Themes[name] = colors
end

local KindColor = { Success = c(64, 196, 124), Warning = c(235, 178, 58), Error = c(228, 76, 76) }
local KindGlyph = { Info = "i", Success = "✓", Warning = "!", Error = "×" }

function Lib:CreateWindow(cfg)
	cfg = cfg or {}
	if cfg.Image == nil or cfg.Image == "" then cfg.Image = LOGO_URL end

	for _, con in ipairs(conns) do con:Disconnect() end
	table.clear(conns); table.clear(refreshers); table.clear(corners); table.clear(glassList); table.clear(spinners)
	for _, g in ipairs(Registry.extra) do pcall(function() g:Destroy() end) end
	table.clear(Registry.extra)
	table.clear(Registry.built)
	for _, name in ipairs({ "SHub", "SHubFX", "SHubFXTop", "SHubHUD" }) do
		local existing = PlayerGui:FindFirstChild(name)
		if existing then existing:Destroy() end
	end
	local oldBlur = Lighting:FindFirstChild("SHubBlur")
	if oldBlur then oldBlur:Destroy() end

	local L = UI.look
	if L.theme ~= "" and Themes[L.theme] then State.Theme = L.theme
	elseif cfg.Theme and Themes[cfg.Theme] then State.Theme = cfg.Theme end
	State.Opacity = clamp(L.opacity, 0.2, 1)
	State.Rounding = clamp(L.rounding, 0, 2)
	State.Scale = clamp(L.scale, 0.4, 2)
	if L.customAccent and L.accent ~= "" then
		local ok, col = pcall(Color3.fromHex, L.accent)
		if ok and col then State.BaseAccent = col; State.Accent = col end
	else
		State.BaseAccent, State.Accent = nil, nil
	end

	local key = cfg.Key or Enum.KeyCode.RightShift
	local letter = cfg.Letter or "S"
	local title = cfg.Title or "S Hub"
	-- Compact footprint for both mobile and desktop
	local W, H = IsMobile and 530 or 720, IsMobile and 315 or 430
	local TOP_H = IsMobile and 40 or 42
	local visible, alive = true, true
	local Window = {}
	local themeHooks = {}

	local function baseScale() return State.Scale * fit(W, H) end

	local gui = make("ScreenGui", { Name = "SHub", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 100, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = PlayerGui })
	Window.Gui = gui

	local blur = make("BlurEffect", { Name = "SHubBlur", Size = 0, Enabled = true, Parent = Lighting })
	table.insert(Registry.extra, blur)

	----------------------------------------------------------------- frame
	local holder = make("Frame", { Name = "Holder", Size = udim2FromOffset(W, H), AnchorPoint = Vector2.new(0.5, 0.5), Position = udim2FromScale(0.5, 0.5), BackgroundTransparency = 1, ZIndex = 2, Parent = gui })
	local scaler = make("UIScale", { Scale = baseScale() * 0.94, Parent = holder })

	local glowImg = make("ImageLabel", {
		Name = "Glow", Image = "rbxassetid://6015897843", ImageTransparency = 1, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450),
		Size = udim2New(1, 76, 1, 76), AnchorPoint = Vector2.new(0.5, 0.5), Position = udim2FromScale(0.5, 0.5), BackgroundTransparency = 1, ZIndex = 0, Parent = holder,
	})
	bind(glowImg, "ImageColor3", "Accent")
	local shadow = make("ImageLabel", {
		Name = "Shadow", Image = "rbxassetid://6015897843", ImageColor3 = c(0, 0, 0), ImageTransparency = 1, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450),
		Size = udim2New(1, 42, 1, 42), AnchorPoint = Vector2.new(0.5, 0.5), Position = udim2New(0.5, 0, 0.5, 4), BackgroundTransparency = 1, ZIndex = 0, Parent = holder,
	})

	local body = make("CanvasGroup", { Name = "Body", Size = udim2FromScale(1, 1), AnchorPoint = Vector2.new(0.5, 0.5), Position = udim2FromScale(0.5, 0.5), BorderSizePixel = 0, GroupTransparency = 1, ZIndex = 1, Parent = holder })
	bind(body, "BackgroundColor3", "Background")
	table.insert(glassList, body)
	round(body, 7)

	local border = make("Frame", { Name = "Border", Size = udim2FromScale(1, 1), AnchorPoint = Vector2.new(0.5, 0.5), Position = udim2FromScale(0.5, 0.5), BackgroundTransparency = 1, ZIndex = 3, Parent = holder })
	round(border, 7)
	local borderStroke = spinStroke(border, 1.2)
	borderStroke.Transparency = 1

	local wash = make("Frame", { Name = "Wash", Size = udim2FromScale(1, 1), BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 0, Parent = body })
	round(wash, 7)
	local washGrad = accentGradient(wash, 35)
	washGrad.Transparency = NumberSequence.new({ kp(0, 0.92), kp(0.45, 0.98), kp(1, 1) })
	wash.Visible = UI.look.glow

	local function extras(show, info)
		tween(shadow, { ImageTransparency = show and 0.45 or 1 }, info)
		tween(glowImg, { ImageTransparency = (show and UI.look.glow) and 0.88 or 1 }, info)
		tween(borderStroke, { Transparency = show and (UI.look.border and 0.15 or 0.35) or 1 }, info)
		tween(blur, { Size = (show and UI.look.blur) and 12 or 0 }, info)
	end

	local launcher, launchScale
	local function setVisible(v)
		visible = v
		if v then
			holder.Visible = true
			launcher.Visible = false
			scaler.Scale = baseScale() * 0.94
			tween(scaler, { Scale = baseScale() }, SPRING)
			tween(body, { GroupTransparency = 0 }, SLOW)
			extras(true, SLOW)
		else
			tween(scaler, { Scale = baseScale() * 0.94 }, FAST)
			tween(body, { GroupTransparency = 1 }, FAST)
			extras(false, FAST)
			task.delay(0.15, function()
				if alive and not visible then
					holder.Visible = false
					launcher.Visible = true
					launchScale.Scale = 0.75
					tween(launchScale, { Scale = 1 }, SPRING)
				end
			end)
		end
	end

	local function destroy()
		if not alive then return end
		alive = false
		for _, con in ipairs(conns) do con:Disconnect() end
		table.clear(conns)
		for _, g in ipairs(Registry.extra) do pcall(function() g:Destroy() end) end
		table.clear(Registry.extra)
		gui:Destroy()
	end

	local cam = workspace.CurrentCamera
	if cam then
		connect(cam:GetPropertyChangedSignal("ViewportSize"), function()
			if visible then scaler.Scale = baseScale() end
		end)
	end

	----------------------------------------------------------------- top bar
	local top = make("Frame", { Size = udim2New(1, 0, 0, TOP_H), BackgroundTransparency = 1, Parent = body })
	local logo, logoText = logoTile(top, 22, 5, letter, cfg.Image, udim2FromOffset(11, floor((TOP_H - 22) / 2)), 12)
	local titleW = IsMobile and 130 or 200
	local titleL = label(top, title, { Font = BOLD, Size = 13, Box = udim2FromOffset(titleW, 16), Pos = udim2FromOffset(40, 6) })
	titleL.TextTruncate = Enum.TextTruncate.AtEnd
	local subL = label(top, cfg.Subtitle or (IsMobile and "Mobile" or "Universal"), { Size = 10, Role = "SubText", Box = udim2FromOffset(titleW, 13), Pos = udim2FromOffset(40, 21) })
	subL.TextTruncate = Enum.TextTruncate.AtEnd

	local topLine = make("Frame", { Size = udim2New(1, 0, 0, 1), Position = udim2FromOffset(0, TOP_H), BorderSizePixel = 0, BackgroundTransparency = 0.45, Parent = body })
	bind(topLine, "BackgroundColor3", "Stroke")

	-- search box
	local searchW = IsMobile and 125 or 175
	local search = make("Frame", { Size = udim2FromOffset(searchW, 24), Position = udim2New(1, -(searchW + 100), 0, floor((TOP_H - 24) / 2)), BorderSizePixel = 0, Parent = top })
	bind(search, "BackgroundColor3", "Surface")
	round(search, 5)
	local searchStroke = outline(search, "Stroke")
	searchStroke.Transparency = 0.45
	local glass = make("Frame", { Size = udim2FromOffset(7, 7), Position = udim2FromOffset(9, 7), BackgroundTransparency = 1, Parent = search })
	pill(glass)
	outline(glass, "SubText", 1.3)
	local handle = make("Frame", { Size = udim2FromOffset(2, 4), Position = udim2FromOffset(16, 13), Rotation = -45, BorderSizePixel = 0, Parent = search })
	bind(handle, "BackgroundColor3", "SubText")
	local sBox = make("TextBox", {
		Size = udim2New(1, -28, 1, 0), Position = udim2FromOffset(24, 0), BackgroundTransparency = 1, Text = "", PlaceholderText = "Search...",
		ClearTextOnFocus = false, Font = FONT, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ClipsDescendants = true, Parent = search,
	})
	bind(sBox, "TextColor3", "Text")
	bind(sBox, "PlaceholderColor3", "SubText")
	sBox.Focused:Connect(function()
		tween(searchStroke, { Color = C("Accent"), Transparency = 0.1 })
		tween(search, { Size = udim2FromOffset(searchW + 14, 24), Position = udim2New(1, -(searchW + 114), 0, floor((TOP_H - 24) / 2)) }, SPRING)
	end)
	sBox.FocusLost:Connect(function()
		tween(searchStroke, { Color = C("Stroke"), Transparency = 0.45 })
		tween(search, { Size = udim2FromOffset(searchW, 24), Position = udim2New(1, -(searchW + 100), 0, floor((TOP_H - 24) / 2)) }, FAST)
	end)

	local function winBtn(x, draw, cb, danger)
		local b = make("TextButton", { Size = udim2FromOffset(24, 24), Position = udim2New(1, x, 0, floor((TOP_H - 24) / 2)), Text = "", AutoButtonColor = false, BorderSizePixel = 0, Parent = top })
		bind(b, "BackgroundColor3", "Surface")
		round(b, 5)
		local bsc = make("UIScale", { Scale = 1, Parent = b })
		local st = outline(b, "Stroke")
		st.Transparency = 0.45
		local icons = draw(b)
		b.MouseEnter:Connect(function()
			tween(b, { BackgroundColor3 = danger and c(205, 58, 70) or C("Hover") })
			tween(bsc, { Scale = 1.07 }, FAST)
			if danger then for _, ic in ipairs(icons) do tween(ic, { BackgroundColor3 = WHITE }) end end
		end)
		b.MouseLeave:Connect(function()
			tween(b, { BackgroundColor3 = C("Surface") })
			tween(bsc, { Scale = 1 }, FAST)
			for _, ic in ipairs(icons) do tween(ic, { BackgroundColor3 = C("SubText") }) end
		end)
		b.MouseButton1Down:Connect(function() tween(bsc, { Scale = 0.92 }, MICRO) end)
		b.MouseButton1Up:Connect(function() tween(bsc, { Scale = 1.07 }, SPRING) end)
		b.MouseButton1Click:Connect(cb)
		return b
	end
	local function bar(parent, w, rot)
		local f = make("Frame", { Size = udim2FromOffset(w, 1.5), AnchorPoint = Vector2.new(0.5, 0.5), Position = udim2FromScale(0.5, 0.5), Rotation = rot or 0, BorderSizePixel = 0, Parent = parent })
		pill(f)
		bind(f, "BackgroundColor3", "SubText")
		return f
	end

	----------------------------------------------------------------- dialog
	function Window:Dialog(o)
		o = o or {}
		local overlay = make("TextButton", { Name = "Dialog", Text = "", AutoButtonColor = false, Size = udim2FromScale(1, 1), BackgroundColor3 = c(0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 50, Parent = body })
		round(overlay, 7)
		local box = make("CanvasGroup", { Size = udim2FromOffset(min(300, W - 40), 0), AutomaticSize = Enum.AutomaticSize.Y, AnchorPoint = Vector2.new(0.5, 0.5), Position = udim2FromScale(0.5, 0.5), BorderSizePixel = 0, GroupTransparency = 1, ZIndex = 51, Parent = overlay })
		bind(box, "BackgroundColor3", "Surface")
		round(box, 6)
		outline(box, "Stroke")
		local bs = make("UIScale", { Scale = 0.92, Parent = box })
		local inner = make("Frame", { Size = udim2New(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = box })
		make("UIPadding", { PaddingTop = UDim.new(0, 14), PaddingBottom = UDim.new(0, 14), PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16), Parent = inner })
		make("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = inner })
		local tl = label(inner, o.Title or "Confirm", { Font = BOLD, Size = 14, Box = udim2New(1, 0, 0, 18) })
		tl.LayoutOrder = 1
		local cl = label(inner, o.Content or "", { Size = 11, Role = "SubText", Wrap = true, Box = udim2New(1, 0, 0, 0), Auto = Enum.AutomaticSize.Y })
		cl.LayoutOrder = 2
		local row = make("Frame", { Size = udim2New(1, 0, 0, 32), BackgroundTransparency = 1, LayoutOrder = 3, Parent = inner })
		make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = row })

		local closed = false
		local function close()
			if closed then return end
			closed = true
			tween(overlay, { BackgroundTransparency = 1 })
			tween(box, { GroupTransparency = 1 })
			tween(bs, { Scale = 0.94 })
			task.delay(0.18, function() overlay:Destroy() end)
		end
		for i, b in ipairs(o.Buttons or { { Title = "OK" } }) do
			local btn = make("TextButton", { Size = udim2FromOffset(80, 26), Text = "", AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = i, Parent = row })
			round(btn, 5)
			local bl = label(btn, b.Title or "OK", { Font = BOLD, Size = 11, AlignX = Enum.TextXAlignment.Center, Role = b.Primary and false or "Text", Z = 2 })
			if b.Primary then
				bind(btn, "BackgroundColor3", "Accent")
				reg(function(t) tween(bl, { TextColor3 = onAccent() }, t) end)
			else
				bind(btn, "BackgroundColor3", "Element")
				outline(btn, "Stroke")
			end
			btn.MouseButton1Click:Connect(function()
				close()
				if b.Callback then task.spawn(b.Callback) end
			end)
		end
		tween(overlay, { BackgroundTransparency = 0.5 })
		tween(box, { GroupTransparency = 0 }, SLOW)
		tween(bs, { Scale = 1 }, SPRING)
		return { Close = close }
	end

	local function askClose()
		if cfg.ConfirmClose == false then return destroy() end
		Window:Dialog({
			Title = "Close " .. title .. "?",
			Content = "This unloads the interface and disables active features.",
			Buttons = { { Title = "Cancel" }, { Title = "Close", Primary = true, Callback = destroy } },
		})
	end

	winBtn(-34, function(b) return { bar(b, 10, 45), bar(b, 10, -45) } end, askClose, true)
	winBtn(-62, function(b) return { bar(b, 10, 0) } end, function() setVisible(false) end)
	winBtn(-90, function(b)
		local dot = make("Frame", { Size = udim2FromOffset(9, 9), AnchorPoint = Vector2.new(0.5, 0.5), Position = udim2FromScale(0.5, 0.5), BorderSizePixel = 0, Parent = b })
		pill(dot)
		bind(dot, "BackgroundColor3", "Accent")
		return {}
	end, function()
		local idx = table.find(ThemeNames, State.Theme) or 0
		Window:SetTheme(ThemeNames[idx % #ThemeNames + 1])
	end)
	makeDraggable(top, holder)

	----------------------------------------------------------------- sidebar
	local sideW = IsMobile and 120 or 148
	local side = make("Frame", { Size = udim2New(0, sideW, 1, -(TOP_H + 1)), Position = udim2FromOffset(0, TOP_H + 1), BorderSizePixel = 0, Parent = body })
	bind(side, "BackgroundColor3", "Surface")
	side.BackgroundTransparency = 0.15

	local sideBorder = make("Frame", { Size = udim2New(0, 1, 1, -(TOP_H + 1)), Position = udim2FromOffset(sideW, TOP_H + 1), BorderSizePixel = 0, BackgroundTransparency = 0.45, Parent = body })
	bind(sideBorder, "BackgroundColor3", "Stroke")

	local pcardH = IsMobile and 38 or 42
	local tabsFrame = make("ScrollingFrame", {
		Size = udim2New(1, -12, 1, -(pcardH + 18)), Position = udim2FromOffset(6, 7), BackgroundTransparency = 1, BorderSizePixel = 0,
		ScrollBarThickness = 2, CanvasSize = udim2New(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y, ElasticBehavior = Enum.ElasticBehavior.Never, Parent = side,
	})
	bind(tabsFrame, "ScrollBarImageColor3", "Stroke")
	make("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = tabsFrame })

	local pcard = make("Frame", { Size = udim2New(1, -12, 0, pcardH), Position = udim2New(0, 6, 1, -(pcardH + 6)), BorderSizePixel = 0, Parent = side })
	bind(pcard, "BackgroundColor3", "Element")
	round(pcard, 5)
	local pst = outline(pcard, "Stroke")
	pst.Transparency = 0.6
	local avSz = IsMobile and 24 or 26
	local avatar = make("ImageLabel", { Size = udim2FromOffset(avSz, avSz), Position = udim2FromOffset(7, floor((pcardH - avSz) / 2)), BorderSizePixel = 0, Parent = pcard })
	bind(avatar, "BackgroundColor3", "Stroke")
	pill(avatar)
	outline(avatar, "Stroke", 1)
	local online = make("Frame", { Size = udim2FromOffset(7, 7), Position = udim2FromOffset(7 + avSz - 6, floor((pcardH + avSz) / 2) - 6), BackgroundColor3 = c(64, 196, 124), BorderSizePixel = 0, ZIndex = 2, Parent = pcard })
	pill(online)
	outline(online, "Element", 1.4)
	local dn = label(pcard, LocalPlayer.DisplayName, { Font = BOLD, Size = 11, Box = udim2New(1, -(avSz + 16), 0, 14), Pos = udim2FromOffset(avSz + 13, 6) })
	dn.TextTruncate = Enum.TextTruncate.AtEnd
	local un = label(pcard, "@" .. LocalPlayer.Name, { Size = 9, Role = "SubText", Box = udim2New(1, -(avSz + 16), 0, 12), Pos = udim2FromOffset(avSz + 13, 20) })
	un.TextTruncate = Enum.TextTruncate.AtEnd
	task.spawn(function()
		local ok, img = pcall(Players.GetUserThumbnailAsync, Players, LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		if ok and avatar.Parent then avatar.Image = img end
	end)

	local pages = make("Frame", { Size = udim2New(1, -(sideW + 18), 1, -(TOP_H + 14)), Position = udim2FromOffset(sideW + 10, TOP_H + 8), BackgroundTransparency = 1, ClipsDescendants = true, Parent = body })

	----------------------------------------------------------------- search filter
	local query = ""
	local currentTab
	local function applyFilter(tab)
		if not tab then return end
		for _, it in ipairs(tab.items) do
			if it.f.Parent then
				it.f.Visible = query == "" or it.name:find(query, 1, true) ~= nil or it.sec.title:find(query, 1, true) ~= nil
			end
		end
		for _, s in ipairs(tab.sections) do
			if query == "" then
				s.Frame.Visible = true
			else
				local any = s.title:find(query, 1, true) ~= nil
				if not any then
					for _, it in ipairs(tab.items) do
						if it.sec == s and it.f.Visible then any = true break end
					end
				end
				s.Frame.Visible = any
			end
		end
	end
	sBox:GetPropertyChangedSignal("Text"):Connect(function()
		query = string.lower(sBox.Text)
		applyFilter(currentTab)
	end)

	----------------------------------------------------------------- tabs
	local tabs = {}
	function Window:AddTab(name, icon)
		local tab = { selected = false, hov = false, items = {}, sections = {}, name = name }
		local tabH = IsMobile and 30 or 28
		local btn = make("TextButton", { Size = udim2New(1, 0, 0, tabH), Text = "", AutoButtonColor = false, BorderSizePixel = 0, BackgroundTransparency = 1, LayoutOrder = #tabs + 1, ClipsDescendants = true, Parent = tabsFrame })
		bind(btn, "BackgroundColor3", "Element")
		round(btn, 5)
		local ind = make("Frame", { Size = udim2FromOffset(2, 0), AnchorPoint = Vector2.new(0, 0.5), Position = udim2New(0, 4, 0.5, 0), BorderSizePixel = 0, ZIndex = 3, Parent = btn })
		pill(ind)
		bind(ind, "BackgroundColor3", "Accent")

		local x = 11
		local iconObj, iconIsImg, iconScale
		if icon ~= nil and icon ~= "" then
			local si = tostring(icon)
			iconIsImg = typeof(icon) == "number" or si:match("^rbxasset") ~= nil or si:match("^%d+$") ~= nil
			if iconIsImg then
				iconObj = make("ImageLabel", { Size = udim2FromOffset(14, 14), Position = udim2New(0, 10, 0.5, -7), BackgroundTransparency = 1, Image = si:match("^%d+$") and ("rbxassetid://" .. si) or si, ZIndex = 2, Parent = btn })
			else
				iconObj = make("TextLabel", { Size = udim2FromOffset(15, 15), Position = udim2New(0, 9, 0.5, -7.5), BackgroundTransparency = 1, Text = si, Font = BOLD, TextSize = 12, ZIndex = 2, Parent = btn })
			end
			iconScale = make("UIScale", { Scale = 1, Parent = iconObj })
			x = 28
		end
		local lbl = make("TextLabel", { Size = udim2New(1, -(x + 6), 1, 0), Position = udim2FromOffset(x, 0), BackgroundTransparency = 1, Text = name, Font = FONT, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 2, Parent = btn })

		local function paint(t)
			local s = tab.selected
			local txt = s and C("Text") or (tab.hov and C("Text") or C("SubText"))
			lbl.Font = s and BOLD or FONT
			tween(btn, { BackgroundTransparency = s and 0.1 or (tab.hov and 0.5 or 1) }, t)
			tween(lbl, { TextColor3 = txt, Position = udim2FromOffset(x + ((s or tab.hov) and 2 or 0), 0) }, t)
			tween(ind, { Size = udim2FromOffset(2, s and 14 or (tab.hov and 6 or 0)) }, t == false and false or SPRING)
			if iconObj then
				if iconIsImg then tween(iconObj, { ImageColor3 = s and C("Accent") or C("SubText") }, t) else tween(iconObj, { TextColor3 = s and C("Accent") or txt }, t) end
				if iconScale then tween(iconScale, { Scale = s and 1.12 or (tab.hov and 1.05 or 1) }, t == false and false or SPRING) end
			end
		end
		reg(paint)
		tab.paint = paint

		local page = make("ScrollingFrame", {
			Size = udim2FromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
			CanvasSize = udim2New(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y,
			Visible = false, Parent = pages,
		})
		bind(page, "ScrollBarImageColor3", "Stroke")
		make("UIPadding", { PaddingRight = UDim.new(0, 5), PaddingLeft = UDim.new(0, 1), PaddingTop = UDim.new(0, 1), PaddingBottom = UDim.new(0, 8), Parent = page })

		local left, right
		if IsMobile then
			local stack = make("Frame", { Size = udim2New(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = page })
			make("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = stack })
			left, right = stack, stack
		else
			local cols = make("Frame", { Size = udim2New(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = page })
			make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 10), VerticalAlignment = Enum.VerticalAlignment.Top, SortOrder = Enum.SortOrder.LayoutOrder, Parent = cols })
			local function column(order)
				local col = make("Frame", { Size = udim2New(0.5, -5, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = order, Parent = cols })
				make("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = col })
				return col
			end
			left, right = column(1), column(2)
		end

		tab.page = page
		table.insert(tabs, tab)

		local function choose()
			for _, t in ipairs(tabs) do
				if t ~= tab then
					t.selected = false
					t.page.Visible = false
					t.paint(FAST)
				end
			end
			tab.selected = true
			currentTab = tab
			page.Position = udim2FromOffset(0, 8)
			page.Visible = true
			tween(page, { Position = udim2FromOffset(0, 0) }, BACK)
			for idx, sec in ipairs(tab.sections) do
				local sc = sec.Scale
				if sc then
					sc.Scale = 0.97
					task.delay((idx - 1) * 0.02, function()
						if sc.Parent then tween(sc, { Scale = 1 }, BACK) end
					end)
				end
			end
			paint(FAST)
			applyFilter(tab)
		end
		tab.choose = choose
		btn.MouseButton1Click:Connect(function()
			ripple(btn)
			choose()
		end)
		btn.MouseEnter:Connect(function()
			tab.hov = true
			paint()
		end)
		btn.MouseLeave:Connect(function()
			tab.hov = false
			paint()
		end)
		if #tabs == 1 then choose() end

		function tab:AddSection(stitle, sideName)
			local parent = (sideName == "Right") and right or left
			local frame = make("Frame", { Size = udim2New(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BorderSizePixel = 0, LayoutOrder = nextOrder(parent), Parent = parent })
			bind(frame, "BackgroundColor3", "Surface")
			frame.BackgroundTransparency = 1 - State.Opacity
			table.insert(glassList, frame)
			round(frame, 6)
			local secScale = make("UIScale", { Scale = 1, Parent = frame })
			local fs = outline(frame, "Stroke")
			fs.Transparency = 0.45
			make("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = frame })
			make("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame })
			local secObj = setmetatable({ Frame = frame, Scale = secScale, Tab = tab, title = string.lower(stitle or "") }, Section)
			if stitle then
				local hd = make("Frame", { Size = udim2New(1, 0, 0, 16), BackgroundTransparency = 1, LayoutOrder = nextOrder(frame), Parent = frame })
				local accentDot = make("Frame", { Size = udim2FromOffset(4, 4), Position = udim2New(0, 0, 0.5, -2), BorderSizePixel = 0, Parent = hd })
				pill(accentDot)
				bind(accentDot, "BackgroundColor3", "Accent")
				label(hd, string.upper(stitle), { Font = BOLD, Size = 10, Role = "SubText", Box = udim2New(1, -10, 1, 0), Pos = udim2FromOffset(8, 0) })
				local ln = make("Frame", { Size = udim2New(1, 0, 0, 1), BorderSizePixel = 0, BackgroundTransparency = 0.55, LayoutOrder = nextOrder(frame), Parent = frame })
				bind(ln, "BackgroundColor3", "Stroke")
			end
			table.insert(tab.sections, secObj)
			return secObj
		end
		return tab
	end

	function Window:SelectTab(name)
		for _, t in ipairs(tabs) do
			if t.name == name then t.choose() return true end
		end
		return false
	end

	----------------------------------------------------------------- launcher ("S")
	local lSize = IsMobile and 48 or 42
	launcher = make("TextButton", {
		Name = "Launcher", Size = udim2FromOffset(lSize, lSize), Position = udim2New(0, 18, 0, 72), Text = letter, Font = BOLD,
		TextSize = floor(lSize * 0.44), AutoButtonColor = false, BorderSizePixel = 0, Visible = false, ZIndex = 5, Parent = gui,
	})
	bind(launcher, "BackgroundColor3", "Surface")
	bind(launcher, "TextColor3", "Text")
	round(launcher, 8)
	spinStroke(launcher, 1.3)
	logoImage(launcher, cfg.Image, launcher, 8)
	launchScale = make("UIScale", { Parent = launcher })
	local lDrag = makeDraggable(launcher, launcher)
	launcher.MouseEnter:Connect(function()
		tween(launcher, { BackgroundColor3 = C("Hover") })
		tween(launchScale, { Scale = 1.08 }, SPRING)
	end)
	launcher.MouseLeave:Connect(function()
		tween(launcher, { BackgroundColor3 = C("Surface") })
		tween(launchScale, { Scale = 1 }, FAST)
	end)
	launcher.Activated:Connect(function()
		if not lDrag.moved() and not visible then setVisible(true) end
	end)

	function Window:AddMobileButton() return { Set = function() end, Get = function() return false end } end
	function Window:SetMobileButtons() end
	function Window:SetMobileSize() end

	----------------------------------------------------------------- toasts + stats
	local toastW = IsMobile and 235 or 270
	local toasts = make("Frame", { Size = udim2New(0, toastW, 1, -28), AnchorPoint = Vector2.new(1, 0), Position = udim2New(1, -14, 0, 14), BackgroundTransparency = 1, ZIndex = 10, Parent = gui })
	make("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right, Parent = toasts })

	function Window:Notify(ntitle, msg, dur, kind)
		if type(ntitle) == "table" then
			local t = ntitle
			ntitle, msg, dur, kind = t.Title, t.Content or t.Text, t.Duration, t.Type
		end
		ntitle = tostring(ntitle or "Notification")
		dur = tonumber(dur) or 3
		kind = (kind and KindGlyph[kind]) and kind or "Info"
		local function col() return KindColor[kind] or C("Accent") end

		local slot = make("Frame", { Size = udim2New(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ClipsDescendants = false, LayoutOrder = nextOrder(toasts), Parent = toasts })
		local t = make("CanvasGroup", { Size = udim2New(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = udim2FromOffset(toastW + 20, 0), BorderSizePixel = 0, GroupTransparency = 1, Parent = slot })
		bind(t, "BackgroundColor3", "Surface")
		round(t, 6)
		local tst = outline(t, "Stroke")
		tst.Transparency = 0.35
		make("Frame", { Size = udim2New(0, 2, 1, 0), BorderSizePixel = 0, BackgroundColor3 = col(), Parent = t })
		local inner = make("Frame", { Size = udim2New(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = t })
		make("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 10), Parent = inner })
		make("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = inner })
		local tl = label(inner, ntitle, { Font = BOLD, Size = 12, Box = udim2New(1, 0, 0, 15) })
		tl.LayoutOrder = 1
		local ml = label(inner, msg or "", { Size = 11, Role = "SubText", Wrap = true, Box = udim2New(1, 0, 0, 0), Auto = Enum.AutomaticSize.Y })
		ml.LayoutOrder = 2
		local prog = make("Frame", { Size = udim2New(1, 0, 0, 1), Position = udim2New(0, 0, 1, -1), BorderSizePixel = 0, BackgroundColor3 = col(), BackgroundTransparency = 0.3, Parent = t })
		local hitN = make("TextButton", { Size = udim2FromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = t })

		local gone = false
		local function dismiss()
			if gone or not slot.Parent then return end
			gone = true
			tween(t, { Position = udim2FromOffset(toastW + 20, 0), GroupTransparency = 1 }, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In))
			task.delay(0.22, function()
				if not slot.Parent then return end
				local hgt = slot.AbsoluteSize.Y
				slot.AutomaticSize = Enum.AutomaticSize.None
				slot.ClipsDescendants = true
				slot.Size = udim2New(1, 0, 0, hgt)
				tween(slot, { Size = udim2New(1, 0, 0, 0) }, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
				task.wait(0.2)
				slot:Destroy()
			end)
		end
		hitN.MouseButton1Click:Connect(dismiss)
		tween(t, { Position = udim2FromOffset(0, 0), GroupTransparency = 0 }, SPRING)
		tween(prog, { Size = udim2New(0, 0, 0, 1) }, TweenInfo.new(dur, Enum.EasingStyle.Linear))
		task.delay(dur, dismiss)
		return { Dismiss = dismiss }
	end

	local statLabel = make("TextLabel", { Size = udim2FromOffset(170, 22), Position = udim2New(1, -180, 0, 8), BackgroundTransparency = 1, Text = "", Font = BOLD, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right, Visible = false, ZIndex = 6, Parent = gui })
	bind(statLabel, "TextColor3", "SubText")
	local acc, frames, pingText = 0, 0, ""
	connect(RunService.Heartbeat, function(dt)
		if not statLabel.Visible then return end
		acc += dt
		frames += 1
		if acc >= 0.5 then
			local ok, p = pcall(function() return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue() end)
			pingText = ok and ("  |  " .. floor(p) .. " ms") or ""
			statLabel.Text = floor(frames / acc + 0.5) .. " FPS" .. pingText
			acc, frames = 0, 0
		end
	end)

	----------------------------------------------------------------- animator
	local clock, rbAcc = 0, 0
	connect(RunService.Heartbeat, function(dt)
		clock += dt
		if UI.look.border then
			local rot = clock * 55
			for i = #spinners, 1, -1 do
				local e = spinners[i]
				if e.g.Parent then e.g.Rotation = (rot + e.ofs) % 360 else table.remove(spinners, i) end
			end
		end
		if wash.Visible and visible then
			washGrad.Rotation = 35 + sin(clock * 0.25) * 18
		end
		if UI.look.rainbow then
			rbAcc += dt
			if rbAcc >= 0.08 then
				rbAcc = 0
				State.Accent = Color3.fromHSV((clock * 0.08 * UI.look.rainbowSpeed) % 1, 0.62, 1)
				refreshAll(false)
			end
		end
	end)

	----------------------------------------------------------------- toggle key
	connect(UserInputService.InputBegan, function(i, processed)
		if processed or State.Listening then return end
		if i.KeyCode == key then setVisible(not visible) end
	end)

	----------------------------------------------------------------- window api
	function Window:SetVisible(v) setVisible(v) end
	function Window:Toggle() setVisible(not visible) end
	function Window:IsVisible() return visible end
	function Window:Destroy() destroy() end
	function Window:SetKey(k) key = k end
	function Window:OnThemeChanged(fn) table.insert(themeHooks, fn) end
	function Window:SetTheme(name)
		if Themes[name] then
			State.Theme = name
			UI.look.theme = name
			refreshAll(SLOW)
			for _, fn in ipairs(themeHooks) do pcall(fn, name) end
			saveSoon()
		end
	end
	function Window:SetAccent(col)
		State.BaseAccent = col
		if not UI.look.rainbow then State.Accent = col end
		UI.look.customAccent = col ~= nil
		if col then UI.look.accent = col:ToHex() end
		refreshAll(false)
		saveSoon()
	end
	function Window:SetRainbow(on)
		UI.look.rainbow = on and true or false
		if not on then
			State.Accent = State.BaseAccent
			refreshAll(SLOW)
		end
		saveSoon()
	end
	function Window:SetOpacity(x)
		State.Opacity = x
		UI.look.opacity = x
		for i = #glassList, 1, -1 do
			local f = glassList[i]
			if f.Parent then f.BackgroundTransparency = 1 - x else table.remove(glassList, i) end
		end
		saveSoon()
	end
	function Window:SetRounding(x)
		State.Rounding = x
		UI.look.rounding = x
		for i = #corners, 1, -1 do
			local e = corners[i]
			if e.c.Parent then e.c.CornerRadius = UDim.new(0, floor(e.r * x + 0.5)) else table.remove(corners, i) end
		end
		saveSoon()
	end
	function Window:SetScale(x)
		State.Scale = x
		UI.look.scale = x
		if visible then scaler.Scale = baseScale() end
		saveSoon()
	end
	function Window:SetBorder(on)
		UI.look.border = on and true or false
		refreshAll(false)
		saveSoon()
	end
	function Window:SetGlow(on)
		UI.look.glow = on and true or false
		wash.Visible = UI.look.glow
		tween(glowImg, { ImageTransparency = (visible and UI.look.glow) and 0.88 or 1 }, SLOW)
		saveSoon()
	end
	function Window:SetBlur(on)
		UI.look.blur = on and true or false
		tween(blur, { Size = (visible and UI.look.blur) and 12 or 0 }, SLOW)
		saveSoon()
	end
	function Window:SetRipple(on)
		UI.look.ripple = on and true or false
		saveSoon()
	end
	function Window:SetLauncher(text, size)
		if text and text ~= "" then
			launcher.Text = text
			logoText.Text = text
		end
		if size then
			launcher.Size = udim2FromOffset(size, size)
			launcher.TextSize = floor(size * 0.44)
		end
	end
	function Window:SetFPSCounter(on) statLabel.Visible = on end

	----------------------------------------------------------------- intro + open animation
	local function openAnim()
		if not alive or not visible then return end
		scaler.Scale = baseScale() * 0.94
		tween(scaler, { Scale = baseScale() }, SPRING)
		tween(body, { GroupTransparency = 0 }, SLOW)
		extras(true, SLOW)
	end

	local function intro(done)
		if cfg.Intro == false then return done() end
		local sp = make("CanvasGroup", { Size = udim2FromOffset(210, 98), AnchorPoint = Vector2.new(0.5, 0.5), Position = udim2FromScale(0.5, 0.5), BorderSizePixel = 0, GroupTransparency = 1, ZIndex = 20, Parent = gui })
		bind(sp, "BackgroundColor3", "Background")
		round(sp, 7)
		outline(sp, "Stroke")
		local ss = make("UIScale", { Scale = 0.9, Parent = sp })
		logoTile(sp, 32, 6, letter, cfg.Image, udim2New(0.5, -16, 0, 14), 16)
		label(sp, title, { Font = BOLD, Size = 13, AlignX = Enum.TextXAlignment.Center, Box = udim2New(1, 0, 0, 16), Pos = udim2FromOffset(0, 50) })
		local trk = make("Frame", { Size = udim2New(1, -56, 0, 2), Position = udim2FromOffset(28, 78), BorderSizePixel = 0, Parent = sp })
		pill(trk)
		bind(trk, "BackgroundColor3", "Stroke")
		local fl = make("Frame", { Size = udim2FromScale(0, 1), BorderSizePixel = 0, Parent = trk })
		pill(fl)
		bind(fl, "BackgroundColor3", "Accent")
		tween(sp, { GroupTransparency = 0 }, SLOW)
		tween(ss, { Scale = 1 }, SPRING)
		tween(fl, { Size = udim2FromScale(1, 1) }, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut))
		task.delay(0.7, function()
			if not sp.Parent then return end
			tween(sp, { GroupTransparency = 1 }, FAST)
			tween(ss, { Scale = 1.04 }, FAST)
			task.delay(0.15, function() sp:Destroy() end)
			done()
		end)
	end

	task.defer(function()
		if not alive then return end
		intro(openAnim)
	end)

	return Window
end

--------------------------------------------------------------------------------
-- FX + HUD module
--------------------------------------------------------------------------------
local fx = UI.fx
local FX = { parts = {}, decoItems = {}, decoTicks = {}, alpha = 0 }
local Hud = {}
Lib.FX, Lib.Hud = FX, Hud

local function mix(a, b, t) return a + (b - a) * t end

--------------------------------------------------------------------------------
-- FX styles
--------------------------------------------------------------------------------
local FXStyles = {
	["Christmas Eve"] = {
		colors = { c(255,255,255), c(215,240,255), c(255,232,175), c(255,195,195) },
		glyphs = { "❄", "❅", "❆", "✦", "•" },
		textColors = { c(255,255,255), c(215,242,255), c(255,236,180), c(255,140,150), c(140,245,185) },
		size = { 10, 20 }, vx = { -0.016, 0.016 }, vy = { 0.032, 0.082 },
		sway = 0.02, spin = 30, twinkle = true, shooting = true, count = 78, vig = c(10, 28, 20), deco = "christmas",
	},
	["Holiday Blizzard"] = { colors = { c(255,255,255), c(205,235,255), c(240,248,255) }, size = {2,7}, vx = {0.055,0.135}, vy = {0.08,0.17}, sway = 0.025, glow = true, count = 110, vig = c(14,32,52), deco = "christmas" },
	["Festive Garland"] = { glyphs = { "❄", "❅", "❆", "✦", "🎄", "🎁" }, textColors = { c(255,255,255), c(235,72,82), c(64,212,120), c(245,204,96) }, size = {11,18}, vx = {-0.012,0.012}, vy = {0.028,0.065}, sway = 0.016, spin = 32, twinkle = true, count = 52, vig = c(24,10,14), deco = "christmas" },
	["North Pole Aurora"] = { colors = { c(110,255,195), c(120,210,255), c(255,235,165), c(255,120,160) }, size = {2,5}, vx = {-0.01,0.01}, vy = {0.018,0.05}, sway = 0.018, glow = true, twinkle = true, shooting = true, count = 75, vig = c(8,32,28), deco = "christmas" },
	["Candy Cane Swirl"] = { glyphs = { "🍬", "🍭", "❄", "✦" }, textColors = { c(255,75,95), c(255,245,248), c(255,180,195), c(120,240,175) }, size = {12,20}, vx = {-0.02,0.02}, vy = {0.035,0.075}, sway = 0.028, spin = 55, twinkle = true, count = 46, vig = c(38,10,18), deco = "christmas" },
	["Frost Snowfall"] = { colors = { c(255,255,255), c(190,225,255) }, size = {2,6}, vx = {-0.012,0.012}, vy = {0.035,0.09}, sway = 0.015, glow = true, count = 80, vig = c(20,42,76) },
	["Spooky Halloween"] = { colors = { c(255,140,30), c(255,90,20), c(170,90,255), c(255,205,90) }, size = {3,7}, vx = {-0.012,0.012}, vy = {-0.07,-0.025}, sway = 0.02, glow = true, count = 50, vig = c(46,10,64), deco = "halloween" },
	["Celestial Stardust"] = { colors = { c(255,255,255), c(170,200,255), c(255,225,150) }, size = {2,5}, vx = {-0.004,0.004}, vy = {-0.012,-0.004}, sway = 0.006, glow = true, twinkle = true, count = 70, vig = c(8,12,44), shooting = true },
	["Deep Space Nebula"] = { colors = { c(185,120,255), c(95,175,255), c(255,115,210), c(255,255,255) }, size = {2,6}, vx = {-0.005,0.005}, vy = {-0.008,0.008}, sway = 0.008, wander = true, glow = true, twinkle = true, shooting = true, count = 78, vig = c(18,8,38), deco = "space" },
	["Golden Sparkles"] = { glyphs = { "✦", "✧", "⋆", "•" }, textColors = { c(255,218,98), c(255,244,195), c(255,176,60) }, size = {10,19}, vx = {-0.008,0.008}, vy = {-0.04,-0.012}, sway = 0.018, spin = 25, twinkle = true, count = 54, vig = c(38,26,6) },
	["Mystic Runes"] = { glyphs = { "ᚠ", "ᚢ", "ᚦ", "ᚨ", "ᚱ", "ᚲ", "ᚷ", "ᚹ", "ᛉ", "ᛞ", "✦" }, textColors = { c(175,125,255), c(110,220,255), c(235,195,255) }, size = {12,20}, vx = {-0.006,0.006}, vy = {-0.05,-0.018}, sway = 0.014, spin = 18, twinkle = true, flicker = true, count = 44, vig = c(24,10,46), deco = "runes" },
	["Cyber Grid Sparks"] = { colors = { c(0,240,255), c(255,46,151) }, size = {1,3}, stretch = 10, vx = {0,0}, vy = {0.18,0.4}, sway = 0, count = 45, vig = c(44,0,56), deco = "cyber" },
	["Glitch Matrix"] = { glyphs = { "0", "1", "▒", "▓", "█", "Ξ", "Δ", "Ø", "7", "9" }, textColors = { c(255,46,136), c(0,240,255), c(190,255,255) }, font = Enum.Font.Code, norot = true, flicker = true, size = {10,18}, vx = {0,0}, vy = {0.18,0.42}, sway = 0, count = 68, vig = c(28,4,36), deco = "cyber" },
	["Toxic Fallout"] = { colors = { c(130,255,70), c(60,220,90), c(220,255,110) }, size = {2,7}, vx = {-0.01,0.01}, vy = {-0.065,-0.02}, sway = 0.022, glow = true, twinkle = true, count = 58, vig = c(8,36,12) },
	["Autumn Breeze"] = { glyphs = { "🍂", "🍁" }, size = {14,24}, vx = {0.04,0.09}, vy = {0.03,0.07}, sway = 0.03, spin = 60, count = 26, vig = c(54,24,6) },
	["Fireflies"] = { colors = { c(190,255,110), c(255,240,130) }, size = {3,6}, vx = {-0.01,0.01}, vy = {-0.01,0.01}, sway = 0.035, glow = true, twinkle = true, wander = true, count = 34, vig = c(6,30,16) },
	["Sakura Petals"] = { glyphs = { "🌸" }, size = {12,20}, vx = {0.03,0.07}, vy = {0.03,0.06}, sway = 0.03, spin = 45, count = 24, vig = c(64,22,40) },
	["Cherry Blossom Storm"] = { glyphs = { "🌸", "💮", "❀" }, textColors = { c(255,175,205), c(255,220,235), c(255,130,175) }, size = {11,20}, vx = {0.07,0.15}, vy = {0.05,0.11}, sway = 0.038, spin = 95, twinkle = true, count = 46, vig = c(58,18,36) },
	["Rising Embers"] = { colors = { c(255,120,30), c(255,70,20), c(255,190,80) }, size = {2,5}, vx = {-0.01,0.01}, vy = {-0.11,-0.04}, sway = 0.025, glow = true, twinkle = true, count = 60, vig = c(60,14,0) },
	["Neon Rain"] = { colors = { c(80,180,255), c(150,120,255), c(0,240,255) }, size = {1,2}, stretch = 16, vx = {0.01,0.02}, vy = {0.55,0.9}, sway = 0, count = 75, vig = c(6,10,44), deco = "storm" },
	["Ocean Bubbles"] = { colors = { c(170,230,255), c(120,200,255), c(200,250,255) }, size = {4,13}, vx = {-0.004,0.004}, vy = {-0.07,-0.02}, sway = 0.02, hollow = true, count = 40, vig = c(0,30,60), deco = "ocean" },
	["Matrix Code"] = { glyphs = { "0", "1", "ア", "カ", "サ", "タ", "ナ", "ハ", "マ", "ラ", "Z", "7" }, textColors = { c(0,255,120), c(120,255,170), c(0,190,90) }, font = Enum.Font.Code, norot = true, flicker = true, size = {10,18}, vx = {0,0}, vy = {0.12,0.32}, sway = 0, count = 70, vig = c(0,30,10) },
	["Confetti Party"] = { colors = { c(255,80,120), c(255,200,60), c(80,220,140), c(80,160,255), c(190,110,255) }, size = {4,8}, stretch = 1.8, vx = {-0.02,0.02}, vy = {0.06,0.13}, sway = 0.03, spin = 220, count = 60 },
	["Love Hearts"] = { glyphs = { "💖", "💕", "💗" }, size = {12,22}, vx = {-0.01,0.01}, vy = {-0.06,-0.025}, sway = 0.025, count = 22, vig = c(60,10,30) },
	["Aurora Sky"] = { colors = { c(255,255,255), c(180,255,230), c(200,180,255) }, size = {1,3}, vx = {-0.002,0.002}, vy = {-0.004,0.004}, sway = 0.004, twinkle = true, glow = true, count = 60, vig = c(4,24,30), deco = "aurora" },
}
table.clear(StyleNames)
for name in pairs(FXStyles) do table.insert(StyleNames, name) end
table.sort(StyleNames)
table.insert(StyleNames, "None")
Lib.FXStyles = FXStyles

function FX.Set(k, v)
	fx[k] = v
	if k == "style" or k == "density" or k == "tint" or k == "deco" then
		if FX.Rebuild then FX.Rebuild() end
	elseif k == "vignette" and FX.RefreshVignette then
		FX.RefreshVignette()
	end
	saveSoon()
end

function FX.Build(window)
	local gui = make("ScreenGui", { Name = "SHubFX", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 90, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = PlayerGui })
	table.insert(Registry.extra, gui)
	local topGui = make("ScreenGui", { Name = "SHubFXTop", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 110, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = PlayerGui })
	table.insert(Registry.extra, topGui)
	local root = make("Frame", { Name = "Root", Size = udim2FromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = true, Visible = false, Parent = gui })
	local partLayer = make("Frame", { Size = udim2FromScale(1, 1), BackgroundTransparency = 1, ZIndex = 2, Parent = root })
	local decoLayer = make("Frame", { Size = udim2FromScale(1, 1), BackgroundTransparency = 1, ZIndex = 3, Parent = root })
	local topLayer = make("Frame", { Size = udim2FromScale(1, 1), BackgroundTransparency = 1, Parent = topGui })
	local holder = window.Gui:FindFirstChild("Holder")

	local function vp()
		local cam = workspace.CurrentCamera
		return cam and cam.ViewportSize or Vector2.new(1280, 720)
	end

	local edges = {}
	for _, d in ipairs({
		{ udim2New(1, 0, 0.34, 0), udim2New(0, 0, 0, 0), Vector2.new(0, 0), 90 },
		{ udim2New(1, 0, 0.34, 0), udim2New(0, 0, 1, 0), Vector2.new(0, 1), 270 },
		{ udim2New(0.24, 0, 1, 0), udim2New(0, 0, 0, 0), Vector2.new(0, 0), 0 },
		{ udim2New(0.24, 0, 1, 0), udim2New(1, 0, 0, 0), Vector2.new(1, 0), 180 },
	}) do
		local f = make("Frame", { Size = d[1], Position = d[2], AnchorPoint = d[3], BorderSizePixel = 0, BackgroundTransparency = 1, ZIndex = 1, Parent = root })
		make("UIGradient", { Rotation = d[4], Transparency = NumberSequence.new(0, 1), Parent = f })
		table.insert(edges, f)
	end
	function FX.RefreshVignette()
		local col
		if fx.tint == "Theme" or not (FX.style and FX.style.vig) then
			local a = C("Accent")
			col = Color3.new(a.R * 0.25, a.G * 0.25, a.B * 0.25)
		else
			col = FX.style.vig
		end
		for _, e in ipairs(edges) do e.BackgroundColor3 = col end
	end

	local Deco = {}

	local function D(inst, prop, base)
		local it = { inst = inst, prop = prop, base = base }
		table.insert(FX.decoItems, it)
		return it
	end
	local function disc(parent, d, pos, col, z)
		local f = make("Frame", { Size = udim2FromOffset(d, d), AnchorPoint = Vector2.new(0.5, 0.5), Position = pos, BackgroundColor3 = col, BorderSizePixel = 0, ZIndex = z or 3, Parent = parent })
		make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = f })
		return f
	end
	local function glyph(layer, txt, size, z)
		size = floor(size)
		return make("TextLabel", { BackgroundTransparency = 1, Text = txt, TextSize = size, AnchorPoint = Vector2.new(0.5, 0.5), Size = udim2FromOffset(size * 2, size * 2), ZIndex = z or 4, Parent = layer })
	end
	local function lightning(layer, tint)
		local flash = make("Frame", { Size = udim2FromScale(1, 1), BackgroundColor3 = tint or c(225, 220, 255), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 6, Parent = layer })
		local nextStrike = 6 + random() * 8
		table.insert(FX.decoTicks, function(dt)
			if not fx.lightning then return end
			nextStrike -= dt
			if nextStrike > 0 then return end
			nextStrike = 7 + random() * 12
			local a = FX.alpha * fx.opacity
			if a < 0.1 then return end
			flash.BackgroundTransparency = 1 - 0.3 * a
			tween(flash, { BackgroundTransparency = 1 }, TweenInfo.new(0.35))
			task.delay(0.16, function()
				if flash.Parent then
					flash.BackgroundTransparency = 1 - 0.22 * a
					tween(flash, { BackgroundTransparency = 1 }, TweenInfo.new(0.55))
				end
			end)
		end)
	end

	function Deco.christmas(layer)
		local ticks = FX.decoTicks
		local V = vp()
		local u = clamp(V.Y / 720, 0.55, 1.25)

		local aCols = {
			{ c(35, 210, 130), c(70, 175, 245) },
			{ c(228, 60, 82), c(245, 195, 85) },
			{ c(115, 225, 195), c(165, 120, 250) },
		}
		for i = 1, 3 do
			local band = make("Frame", { Size = udim2New(1.55, 0, 0.22, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 3, Parent = layer })
			make("UIGradient", { Color = ColorSequence.new(aCols[i][1], aCols[i][2]), Transparency = NumberSequence.new({ kp(0, 1), kp(0.5, 0.36), kp(1, 1) }), Rotation = 90, Parent = band })
			local it = D(band, "BackgroundTransparency", 0.85)
			table.insert(ticks, function(_, t)
				band.Position = udim2FromScale(0.5 + 0.1 * sin(t * 0.08 * fx.speed + i * 2), 0.11 + i * 0.055)
				band.Rotation = -5 + 4 * sin(t * 0.1 * fx.speed + i)
				it.base = 0.82 + 0.08 * (0.5 + 0.5 * sin(t * 0.35 + i))
			end)
		end

		local mpos = udim2FromScale(0.87, 0.18)
		local moonHalos = {}
		for i, d in ipairs({ 290, 210, 150 }) do
			moonHalos[i] = D(disc(layer, d * u, mpos, c(225, 240, 255), 3), "BackgroundTransparency", 0.94)
		end
		local moon = disc(layer, 102 * u, mpos, c(245, 250, 255), 3)
		D(moon, "BackgroundTransparency", 0.04)
		for _, cr in ipairs({ { 0.32, 0.35, 0.2 }, { 0.62, 0.58, 0.15 }, { 0.42, 0.72, 0.11 } }) do
			local crater = make("Frame", { Size = udim2FromScale(cr[3], cr[3]), AnchorPoint = Vector2.new(0.5, 0.5), Position = udim2FromScale(cr[1], cr[2]), BackgroundColor3 = c(208, 224, 242), BorderSizePixel = 0, ZIndex = 3, Parent = moon })
			pill(crater)
			D(crater, "BackgroundTransparency", 0.58)
		end
		table.insert(ticks, function(_, t)
			for i, it in ipairs(moonHalos) do
				it.base = 0.915 + 0.015 * i + 0.025 * (0.5 + 0.5 * sin(t * 0.9 + i))
			end
		end)

		for i = 1, 3 do
			local cl = make("Frame", { Size = udim2FromOffset((180 + i * 55) * u, 26 * u), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = c(195, 218, 240), BorderSizePixel = 0, ZIndex = 3, Parent = layer })
			pill(cl)
			D(cl, "BackgroundTransparency", 0.8 + i * 0.03)
			local x, y, sp = (i * 0.37) % 1.2 - 0.1, 0.11 + i * 0.045, 0.005 + i * 0.0018
			table.insert(ticks, function(dt)
				x += sp * dt * fx.speed
				if x > 1.25 then x = -0.25 end
				cl.Position = udim2FromScale(x, y)
			end)
		end

		local sleigh = make("TextLabel", {
			BackgroundTransparency = 1, Text = "🦌🦌🛷", TextSize = floor(22 * u),
			Size = udim2FromOffset(floor(110 * u), floor(34 * u)), AnchorPoint = Vector2.new(0.5, 0.5), ZIndex = 4, Parent = layer,
		})
		D(sleigh, "TextTransparency", 0.12)
		local sleighGlow = D(disc(layer, 76 * u, udim2FromScale(-0.2, 0.2), c(255, 220, 125), 3), "BackgroundTransparency", 0.9)
		local sx, sy = -0.18, 0.19
		table.insert(ticks, function(dt, t)
			sx += 0.022 * dt * fx.speed
			if sx > 1.22 then
				sx = -0.22
				sy = 0.14 + random() * 0.14
			end
			local bob = sin(t * 2.1) * 0.014
			local pos = udim2FromScale(sx, sy + bob)
			sleigh.Position = pos
			sleigh.Rotation = cos(t * 2.1) * 5
			sleighGlow.inst.Position = pos
		end)

		local wire = make("Frame", { Size = udim2New(1, 0, 0, 1), Position = udim2FromOffset(0, floor(14 * u)), BackgroundColor3 = c(32, 44, 36), BorderSizePixel = 0, ZIndex = 4, Parent = layer })
		D(wire, "BackgroundTransparency", 0.35)

		local bulbPalette = { c(245, 68, 76), c(56, 214, 124), c(255, 206, 84), c(88, 178, 255), c(215, 115, 255) }
		local bulbCount = IsMobile and 16 or 24
		for i = 1, bulbCount do
			local bx = (i - 0.5) / bulbCount
			local sag = sin((i - 1) / (bulbCount - 1) * math.pi) * 10 * u
			local by = floor(14 * u + sag)
			local col = bulbPalette[(i - 1) % #bulbPalette + 1]

			local cord = make("Frame", { Size = udim2FromOffset(1, max(2, floor(sag))), AnchorPoint = Vector2.new(0.5, 0), Position = udim2New(bx, 0, 0, floor(14 * u)), BackgroundColor3 = c(40, 52, 44), BorderSizePixel = 0, ZIndex = 4, Parent = layer })
			D(cord, "BackgroundTransparency", 0.45)

			local halo = disc(layer, 22 * u, udim2New(bx, 0, 0, by + floor(3 * u)), col, 3)
			local haloIt = D(halo, "BackgroundTransparency", 0.85)
			local bulb = disc(layer, 7 * u, udim2New(bx, 0, 0, by + floor(3 * u)), col, 4)
			local bulbIt = D(bulb, "BackgroundTransparency", 0.08)

			local phase = i * 0.85
			table.insert(ticks, function(_, t)
				local pulse = 0.5 + 0.5 * sin(t * 2.5 + phase)
				haloIt.base = 0.75 + 0.17 * (1 - pulse)
				bulbIt.base = 0.04 + 0.28 * (1 - pulse)
			end)
		end

		local baubleSpecs = {
			{ x = 0.07, len = 46, col = c(235, 58, 70), r = 14 },
			{ x = 0.16, len = 68, col = c(245, 196, 78), r = 16 },
			{ x = 0.28, len = 52, col = c(56, 200, 125), r = 13 },
			{ x = 0.72, len = 54, col = c(88, 178, 255), r = 13 },
			{ x = 0.84, len = 70, col = c(235, 58, 70), r = 16 },
			{ x = 0.93, len = 44, col = c(245, 196, 78), r = 14 },
		}
		for i, b in ipairs(baubleSpecs) do
			local lenPx = floor(b.len * u)
			local rPx = floor(b.r * u)
			local str = make("Frame", {
				Size = udim2FromOffset(1, lenPx), AnchorPoint = Vector2.new(0.5, 0),
				Position = udim2New(b.x, 0, 0, floor(14 * u)), BackgroundColor3 = c(210, 190, 140), BorderSizePixel = 0, ZIndex = 3, Parent = layer,
			})
			D(str, "BackgroundTransparency", 0.45)
			local bHalo = disc(layer, rPx * 2.4, udim2New(b.x, 0, 0, floor(14 * u) + lenPx), b.col, 3)
			D(bHalo, "BackgroundTransparency", 0.86)
			local ball = disc(layer, rPx, udim2New(b.x, 0, 0, floor(14 * u) + lenPx), b.col, 4)
			D(ball, "BackgroundTransparency", 0.06)
			local shine = disc(ball, max(3, floor(rPx * 0.3)), udim2FromScale(0.32, 0.32), WHITE, 5)
			D(shine, "BackgroundTransparency", 0.35)

			table.insert(ticks, function(_, t)
				local swayPx = floor(sin(t * 1.4 + i * 1.1) * 5 * u)
				local yPos = floor(14 * u) + lenPx
				ball.Position = udim2New(b.x, swayPx, 0, yPos)
				bHalo.Position = udim2New(b.x, swayPx, 0, yPos)
			end)
		end

		local frostMist = make("Frame", {
			Size = udim2New(1.2, 0, 0, floor(95 * u)), AnchorPoint = Vector2.new(0.5, 1),
			Position = udim2New(0.5, 0, 1, 0), BackgroundColor3 = c(215, 235, 255), BorderSizePixel = 0, ZIndex = 3, Parent = layer,
		})
		make("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ kp(0, 1), kp(0.55, 0.35), kp(1, 0) }), Parent = frostMist })
		D(frostMist, "BackgroundTransparency", 0.84)

		for i, bank in ipairs({
			{ x = 0.20, w = 0.68, h = 44 },
			{ x = 0.80, w = 0.68, h = 48 },
			{ x = 0.50, w = 1.12, h = 32 },
		}) do
			local sb = make("Frame", {
				Size = udim2New(bank.w, 0, 0, floor(bank.h * u)),
				AnchorPoint = Vector2.new(0.5, 1),
				Position = udim2New(bank.x, 0, 1, floor(12 * u)),
				BackgroundColor3 = c(234, 244, 254),
				BorderSizePixel = 0,
				ZIndex = 3,
				Parent = layer,
			})
			pill(sb)
			make("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ kp(0, 0.22), kp(1, 0.04) }), Parent = sb })
			D(sb, "BackgroundTransparency", 0.70 + i * 0.04)
		end

		for i, td in ipairs({
			{ x = 0.035, s = 48 }, { x = 0.085, s = 36 }, { x = 0.13, s = 28 },
			{ x = 0.87, s = 28 },  { x = 0.915, s = 36 }, { x = 0.965, s = 48 },
		}) do
			local sz = td.s * u
			local pos = udim2New(td.x, 0, 1, -floor(sz * 0.55))
			local glow = D(disc(layer, sz * 2.15, pos, c(255, 204, 98), 3), "BackgroundTransparency", 0.9)
			local tr = glyph(layer, "🎄", sz, 4)
			tr.Position = pos
			D(tr, "TextTransparency", 0.06)
			table.insert(ticks, function(_, t)
				glow.base = 0.86 + 0.055 * sin(t * 3.1 + i)
			end)
		end

		local props = {
			{ g = "🎁", x = 0.062, s = 22, sway = false, col = c(255, 90, 90) },
			{ g = "🎁", x = 0.108, s = 20, sway = false, col = c(90, 220, 135) },
			{ g = "⛄", x = 0.175, s = 34, sway = true,  col = c(185, 230, 255) },
			{ g = "🍬", x = 0.825, s = 24, sway = true,  col = c(255, 110, 135) },
			{ g = "🎁", x = 0.892, s = 21, sway = false, col = c(255, 205, 85) },
			{ g = "🦌", x = 0.940, s = 30, sway = true,  col = c(255, 195, 110) },
		}
		for i, pr in ipairs(props) do
			local sz = pr.s * u
			local pos = udim2New(pr.x, 0, 1, -floor(sz * 0.52))
			D(disc(layer, sz * 1.9, pos, pr.col, 3), "BackgroundTransparency", 0.9)
			local item = glyph(layer, pr.g, sz, 4)
			item.Position = pos
			D(item, "TextTransparency", 0.06)
			if pr.sway then
				table.insert(ticks, function(_, t)
					item.Rotation = sin(t * 1.8 + i * 1.5) * 6
				end)
			end
		end

		local wreathPos = udim2New(0.5, 0, 1, -floor(18 * u))
		local hearthGlow = D(disc(layer, 110 * u, wreathPos, c(255, 185, 85), 3), "BackgroundTransparency", 0.88)
		local wreath = glyph(layer, "🎀", 24 * u, 4)
		wreath.Position = wreathPos
		D(wreath, "TextTransparency", 0.12)
		table.insert(ticks, function(_, t)
			hearthGlow.base = 0.85 + 0.05 * sin(t * 4.2)
		end)
	end

	function Deco.halloween(layer)
		local ticks = FX.decoTicks
		local V = vp()
		local u = clamp(V.Y / 720, 0.55, 1.25)

		local mpos = udim2FromScale(0.86, 0.17)
		local halos = {}
		for i, d in ipairs({ 330, 240, 175 }) do
			halos[i] = D(disc(layer, d * u, mpos, c(255, 226, 160), 3), "BackgroundTransparency", 0.95)
		end
		local moon = disc(layer, 118 * u, mpos, c(255, 240, 205), 3)
		D(moon, "BackgroundTransparency", 0.03)
		for _, cr in ipairs({ { 0.3, 0.36, 0.22 }, { 0.62, 0.58, 0.16 }, { 0.4, 0.74, 0.11 }, { 0.7, 0.28, 0.09 } }) do
			local f = make("Frame", { Size = udim2FromScale(cr[3], cr[3]), AnchorPoint = Vector2.new(0.5, 0.5), Position = udim2FromScale(cr[1], cr[2]), BackgroundColor3 = c(226, 204, 150), BorderSizePixel = 0, ZIndex = 3, Parent = moon })
			make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = f })
			D(f, "BackgroundTransparency", 0.55)
		end
		table.insert(ticks, function(_, t)
			for i, it in ipairs(halos) do it.base = 0.925 + 0.012 * i + 0.03 * (0.5 + 0.5 * sin(t * 0.8 + i)) end
		end)
		for i = 1, 3 do
			local cl = make("Frame", { Size = udim2FromOffset((200 + i * 60) * u, 30 * u), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = c(24, 16, 44), BorderSizePixel = 0, ZIndex = 4, Parent = layer })
			make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = cl })
			D(cl, "BackgroundTransparency", 0.45 + i * 0.05)
			local x, y, sp = i * 0.4 - 0.2, 0.09 + i * 0.05, 0.006 + i * 0.002
			table.insert(ticks, function(dt)
				x += sp * dt * fx.speed
				if x > 1.3 then x = -0.3 end
				cl.Position = udim2FromScale(x, y)
			end)
		end

		for i = 1, 3 do
			local band = make("Frame", { Size = udim2New(1.5, 0, 0, floor((110 + i * 30) * u)), AnchorPoint = Vector2.new(0.5, 1), BackgroundColor3 = i == 2 and c(170, 150, 215) or c(205, 190, 235), BorderSizePixel = 0, ZIndex = 3, Parent = layer })
			make("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ kp(0, 1), kp(0.55, 0.2), kp(1, 0) }), Parent = band })
			D(band, "BackgroundTransparency", 0.84 + i * 0.03)
			local y = 1 - (i - 1) * 0.05
			table.insert(ticks, function(_, t)
				band.Position = udim2FromScale(0.5 + 0.07 * sin(t * 0.12 * fx.speed + i * 2), y)
			end)
		end

		for _ = 1, 6 do
			local ts = floor((20 + random() * 16) * u)
			local l = glyph(layer, "🦇", ts, 4)
			D(l, "TextTransparency", 0.08)
			local b = { x = random() * 1.4 - 0.2, y = 0.1 + random() * 0.35, sp = 0.05 + random() * 0.07, ph = random() * 6.28, amp = 0.03 + random() * 0.04, fq = 1 + random() * 1.2 }
			table.insert(ticks, function(dt, t)
				b.x += b.sp * dt * fx.speed
				if b.x > 1.15 then b.x = -0.15; b.y = 0.1 + random() * 0.35 end
				l.Position = udim2FromScale(b.x, b.y + sin(t * b.fq * 0.7 + b.ph) * b.amp)
				l.Rotation = sin(t * b.fq * 6 + b.ph) * 14
				l.TextSize = floor(ts * (0.82 + 0.22 * abs(sin(t * b.fq * 14 + b.ph))))
			end)
		end

		for _ = 1, 3 do
			local l = glyph(layer, "👻", (38 + random() * 22) * u, 4)
			local it = D(l, "TextTransparency", 0.6)
			local g = { x = random(), y = 0.35 + random() * 0.4, vx = 0.008 + random() * 0.012, ph = random() * 6.28 }
			table.insert(ticks, function(dt, t)
				g.x += g.vx * dt * fx.speed
				if g.x > 1.1 then g.x = -0.1; g.y = 0.35 + random() * 0.4 end
				l.Position = udim2FromScale(g.x, g.y + sin(t * 0.6 + g.ph) * 0.03)
				l.Rotation = sin(t * 0.8 + g.ph) * 6
				it.base = 0.45 + 0.4 * (0.5 + 0.5 * sin(t * 0.5 + g.ph))
			end)
		end

		for i, px in ipairs({ 0.045, 0.12, 0.885, 0.955 }) do
			local s = (48 + (i % 2) * 14) * u
			local py = udim2New(px, 0, 1, -floor(s * 0.5))
			local gi = D(disc(layer, s * 2.6, py, c(255, 120, 20), 3), "BackgroundTransparency", 0.86)
			local p = glyph(layer, "🎃", s, 4)
			p.Position = py
			D(p, "TextTransparency", 0.04)
			table.insert(ticks, function(_, t)
				gi.base = 0.84 + 0.05 * sin(t * 7 + i) + 0.03 * sin(t * 13.3 + i * 2)
			end)
		end

		local w1 = glyph(layer, "🕸", 120 * u, 4)
		w1.Position = udim2FromOffset(floor(60 * u), floor(60 * u))
		D(w1, "TextTransparency", 0.55)
		local w2 = glyph(layer, "🕸", 120 * u, 4)
		w2.Position = udim2New(1, -floor(60 * u), 0, floor(60 * u))
		w2.Rotation = 90
		D(w2, "TextTransparency", 0.55)
		for i, sx in ipairs({ 0.08, 0.93 }) do
			local thread = make("Frame", { Size = udim2FromOffset(1, 40), AnchorPoint = Vector2.new(0.5, 0), Position = udim2FromScale(sx, 0), BackgroundColor3 = c(225, 225, 235), BorderSizePixel = 0, ZIndex = 4, Parent = layer })
			D(thread, "BackgroundTransparency", 0.55)
			local sp = glyph(layer, "🕷", 22 * u, 4)
			D(sp, "TextTransparency", 0.05)
			table.insert(ticks, function(_, t)
				local len = floor(50 + (0.5 + 0.5 * sin(t * 0.5 + i * 2)) * 0.2 * V.Y)
				thread.Size = udim2FromOffset(1, len)
				sp.Position = udim2New(sx, 0, 0, len + 8)
			end)
		end

		lightning(layer)
	end

	function Deco.cyber(layer)
		for i = 1, 13 do
			local l = make("Frame", { Size = udim2New(1, 0, 0, 1), Position = udim2FromScale(0, i / 14), BackgroundColor3 = c(0, 240, 255), BorderSizePixel = 0, ZIndex = 3, Parent = layer })
			D(l, "BackgroundTransparency", 0.93)
		end
		for i = 1, 22 do
			local l = make("Frame", { Size = udim2New(0, 1, 1, 0), Position = udim2FromScale(i / 23, 0), BackgroundColor3 = c(255, 46, 151), BorderSizePixel = 0, ZIndex = 3, Parent = layer })
			D(l, "BackgroundTransparency", 0.96)
		end
		local scan = make("Frame", { Size = udim2New(1, 0, 0, 3), BackgroundColor3 = c(0, 240, 255), BorderSizePixel = 0, ZIndex = 3, Parent = layer })
		make("UIGradient", { Transparency = NumberSequence.new({ kp(0, 1), kp(0.5, 0.2), kp(1, 1) }), Parent = scan })
		D(scan, "BackgroundTransparency", 0.45)
		table.insert(FX.decoTicks, function(_, t)
			scan.Position = udim2FromScale(0, (t * 0.1 * fx.speed) % 1.1 - 0.05)
		end)
	end

	function Deco.aurora(layer)
		local cols = { { c(60,255,170), c(80,180,255) }, { c(170,90,255), c(60,255,200) }, { c(80,200,255), c(255,90,200) } }
		for i = 1, 3 do
			local band = make("Frame", { Size = udim2New(1.6, 0, 0.3, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 3, Parent = layer })
			local g = make("UIGradient", { Color = ColorSequence.new(cols[i][1], cols[i][2]), Transparency = NumberSequence.new({ kp(0, 1), kp(0.5, 0.3), kp(1, 1) }), Rotation = 90, Parent = band })
			local it = D(band, "BackgroundTransparency", 0.8)
			table.insert(FX.decoTicks, function(_, t)
				band.Position = udim2FromScale(0.5 + 0.12 * sin(t * 0.07 * fx.speed + i * 2), 0.14 + i * 0.06 + 0.03 * sin(t * 0.2 * fx.speed + i))
				band.Rotation = -8 + 6 * sin(t * 0.1 * fx.speed + i)
				it.base = 0.7 + 0.14 * (0.5 + 0.5 * sin(t * 0.4 + i * 1.7))
				g.Offset = Vector2.new(0, 0.12 * sin(t * 0.15 + i))
			end)
		end
	end

	function Deco.ocean(layer)
		for i = 1, 6 do
			local ray = make("Frame", { Size = udim2New(0, 60 + i * 14, 1.3, 0), AnchorPoint = Vector2.new(0.5, 0), Position = udim2FromScale(i / 7, -0.1), Rotation = 18, BackgroundColor3 = c(190, 235, 255), BorderSizePixel = 0, ZIndex = 3, Parent = layer })
			make("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ kp(0, 0.2), kp(0.7, 0.85), kp(1, 1) }), Parent = ray })
			local it = D(ray, "BackgroundTransparency", 0.88)
			table.insert(FX.decoTicks, function(_, t)
				ray.Position = udim2FromScale(i / 7 + 0.03 * sin(t * 0.3 * fx.speed + i), -0.1)
				it.base = 0.86 + 0.08 * (0.5 + 0.5 * sin(t * 0.6 + i * 1.3))
			end)
		end
		local floorF = make("Frame", { Size = udim2New(1, 0, 0.3, 0), AnchorPoint = Vector2.new(0, 1), Position = udim2FromScale(0, 1), BackgroundColor3 = c(0, 60, 110), BorderSizePixel = 0, ZIndex = 3, Parent = layer })
		make("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0), Parent = floorF })
		D(floorF, "BackgroundTransparency", 0.6)
	end

	function Deco.storm(layer)
		local fog = make("Frame", { Size = udim2New(1, 0, 0.4, 0), BackgroundColor3 = c(30, 40, 90), BorderSizePixel = 0, ZIndex = 3, Parent = layer })
		make("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(0, 1), Parent = fog })
		D(fog, "BackgroundTransparency", 0.55)
		lightning(layer, c(200, 220, 255))
	end

	function Deco.space(layer)
		local V = vp()
		local u = clamp(V.Y / 720, 0.55, 1.25)
		local nebCols = {
			{ c(165, 85, 255), udim2FromScale(0.22, 0.28), 380 },
			{ c(65, 165, 255), udim2FromScale(0.78, 0.68), 420 },
			{ c(255, 85, 190), udim2FromScale(0.62, 0.22), 310 },
		}
		for i, n in ipairs(nebCols) do
			local cloud = disc(layer, n[3] * u, n[2], n[1], 3)
			local it = D(cloud, "BackgroundTransparency", 0.92)
			table.insert(FX.decoTicks, function(_, t)
				it.base = 0.90 + 0.04 * sin(t * 0.45 + i * 1.8)
			end)
		end
	end

	function Deco.runes(layer)
		local V = vp()
		local u = clamp(V.Y / 720, 0.55, 1.25)
		for i, r in ipairs({ 220, 160 }) do
			local ring = make("Frame", {
				Size = udim2FromOffset(r * u, r * u), AnchorPoint = Vector2.new(0.5, 0.5),
				Position = udim2FromScale(0.5, 0.5), BackgroundTransparency = 1, ZIndex = 3, Parent = layer,
			})
			pill(ring)
			local st = make("UIStroke", { Thickness = 1.2, Color = i == 1 and c(175, 120, 255) or c(100, 220, 255), Parent = ring })
			local it = D(st, "Transparency", 0.84)
			table.insert(FX.decoTicks, function(_, t)
				it.base = 0.80 + 0.08 * sin(t * 0.9 + i)
			end)
		end
	end

	local function spawn(p, initial)
		local st = FX.style
		local z = 0.4 + random() * 0.6
		p.z = z
		local vxm, vym = (st.vx[1] + st.vx[2]) * 0.5, (st.vy[1] + st.vy[2]) * 0.5
		p.x, p.y = random(), random()
		if not initial and not st.wander then
			if abs(vxm) > abs(vym) then p.x = vxm > 0 and -0.06 or 1.06
			else p.y = vym > 0 and -0.06 or 1.06 end
		end
		p.vx = mix(st.vx[1], st.vx[2], random())
		p.vy = mix(st.vy[1], st.vy[2], random())
		p.ph = random() * 6.283
		p.fq = 0.6 + random() * 1.6
		local sz = mix(st.size[1], st.size[2], random()) * (0.55 + 0.6 * z)
		if p.isGlyph then
			p.f.TextSize = floor(sz)
			p.f.Size = udim2FromOffset(floor(sz * 2), floor(sz * 2))
			p.f.Rotation = st.norot and 0 or random(0, 360)
			if st.textColors then
				p.f.TextColor3 = fx.tint == "Theme" and ((random() < 0.6) and C("Accent") or C("Accent2")) or st.textColors[random(#st.textColors)]
			end
		else
			p.f.Size = udim2FromOffset(max(1, floor(sz + 0.5)), max(1, floor(sz * (st.stretch or 1) + 0.5)))
			local col
			if fx.tint == "Theme" then col = (random() < 0.6) and C("Accent") or C("Text")
			else col = st.colors[random(#st.colors)] end
			p.f.BackgroundColor3 = col
			if p.g then p.g.Color = col end
		end
	end

	local function rebuild()
		for _, p in ipairs(FX.parts) do p.f:Destroy() end
		table.clear(FX.parts)
		decoLayer:ClearAllChildren()
		table.clear(FX.decoItems)
		table.clear(FX.decoTicks)
		local st = FXStyles[fx.style]
		FX.style = st
		FX.RefreshVignette()
		if not st then return end
		local count = floor((st.count or 45) * fx.density + 0.5)
		local hasGlyphs = st.glyphs ~= nil
		local hasColors = st.colors ~= nil
		for i = 1, count do
			local useGlyph = hasGlyphs and (not hasColors or (i % 3 == 0))
			local f
			if useGlyph then
				f = make("TextLabel", { BackgroundTransparency = 1, Text = st.glyphs[random(#st.glyphs)], AnchorPoint = Vector2.new(0.5, 0.5), ZIndex = 2, Parent = partLayer })
				if st.font then f.Font = st.font end
			else
				f = make("Frame", { BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), ZIndex = 2, Parent = partLayer })
				make("UICorner", { CornerRadius = UDim.new(st.stretch and 0 or 1, 0), Parent = f })
			end
			local p = { f = f, isGlyph = useGlyph }
			if (st.glow or st.hollow) and not useGlyph then
				p.g = make("UIStroke", { Thickness = st.hollow and 1.2 or 3, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = f })
			end
			FX.parts[i] = p
			spawn(p, true)
		end
		if fx.deco and st.deco and Deco[st.deco] then Deco[st.deco](decoLayer) end
	end
	FX.Rebuild = rebuild

	local function shoot(A)
		local x0, y0 = 0.05 + random() * 0.6, random() * 0.35
		local s = make("Frame", {
			Size = udim2FromOffset(random(70, 130), 2), AnchorPoint = Vector2.new(1, 0.5), Position = udim2FromScale(x0, y0),
			Rotation = 28, BorderSizePixel = 0, BackgroundColor3 = c(255, 255, 255), BackgroundTransparency = 1 - 0.9 * fx.opacity * A, ZIndex = 2, Parent = partLayer,
		})
		make("UIGradient", { Transparency = NumberSequence.new(1, 0), Parent = s })
		tween(s, { Position = udim2FromScale(x0 + 0.3, y0 + 0.16), BackgroundTransparency = 1 }, TweenInfo.new(0.85, Enum.EasingStyle.Quad, Enum.EasingDirection.In))
		task.delay(0.9, function() s:Destroy() end)
	end

	local function dot(pos, size, col, life, to)
		local d = make("Frame", { Size = udim2FromOffset(size, size), AnchorPoint = Vector2.new(0.5, 0.5), Position = udim2FromOffset(pos.X, pos.Y), BackgroundColor3 = col, BackgroundTransparency = 0.15, BorderSizePixel = 0, Parent = topLayer })
		pill(d)
		tween(d, { Position = to and udim2FromOffset(to.X, to.Y) or d.Position, Size = udim2FromOffset(0, 0), BackgroundTransparency = 1 }, TweenInfo.new(life, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
		task.delay(life + 0.05, function() d:Destroy() end)
	end
	local function burst(pos)
		for i = 1, 8 do
			local ang = (i / 8) * math.pi * 2 + random() * 0.5
			local dist = 20 + random() * 20
			dot(pos, random(3, 5), (i % 2 == 0) and C("Accent") or C("Accent2"), 0.4, pos + Vector2.new(cos(ang) * dist, sin(ang) * dist))
		end
	end
	connect(UserInputService.InputBegan, function(i)
		if not fx.burst or not (holder and holder.Visible) or not isPress(i) then return end
		local pos
		if i.UserInputType == Enum.UserInputType.Touch then
			local inset = GuiService:GetGuiInset()
			pos = Vector2.new(i.Position.X, i.Position.Y) + inset
		else
			pos = UserInputService:GetMouseLocation()
		end
		burst(pos)
	end)

	local clock, A, nextShoot = 0, 0, 2
	local lastM, trailAcc, trailFlip = nil, 0, false
	connect(RunService.Heartbeat, function(dt)
		clock += dt
		local open = holder and holder.Visible

		if fx.trail and open then
			trailAcc += dt
			if trailAcc >= 0.016 then
				local m = UserInputService:GetMouseLocation()
				if not lastM or (m - lastM).Magnitude > 3 then
					trailAcc = 0
					lastM = m
					trailFlip = not trailFlip
					dot(m, 6, trailFlip and C("Accent") or C("Accent2"), 0.4)
				end
			end
		end

		local want = fx.on and (open or not fx.menuOnly) and FX.style ~= nil
		local targetA = want and 1 or 0
		if A == 0 and targetA == 0 then return end

		A += (targetA - A) * min(1, dt / max(0.03, fx.fade * 0.35))
		if A < 0.005 and targetA == 0 then
			A = 0
			FX.alpha = 0
			root.Visible = false
			return
		end
		FX.alpha = A
		root.Visible = true

		local st = FX.style
		if not st then return end

		local va = fx.vignette and fx.vignetteStrength * A or 0
		local vTrans = 1 - va
		for i = 1, 4 do edges[i].BackgroundTransparency = vTrans end

		local spd = fx.speed
		local dtSpd = dt * spd
		local baseAlpha = fx.opacity * A
		local stSway = st.sway
		local stSpin = st.spin
		local stTwinkle = st.twinkle
		local stWander = st.wander
		local stFlicker = st.flicker
		local stHollow = st.hollow
		local glyphs = st.glyphs
		local parts = FX.parts

		for i = 1, #parts do
			local p = parts[i]
			local z = p.z
			local phase = clock * p.fq + p.ph
			local sPhase = sin(phase)
			local sway = sPhase * stSway
			local x = p.x + (p.vx * z + sway) * dtSpd
			local y = p.y + (p.vy * z + (stWander and cos(phase * 0.8) * stSway or 0)) * dtSpd
			if x > 1.08 or x < -0.08 or y > 1.08 or y < -0.08 then
				spawn(p, false)
			else
				p.x, p.y = x, y
				p.f.Position = udim2FromScale(x, y)
			end
			if stSpin then p.f.Rotation += stSpin * dtSpd * z end
			local tw = stTwinkle and (0.3 + 0.7 * abs(sPhase)) or 1
			local a = baseAlpha * tw * (0.4 + 0.6 * z)
			if p.isGlyph then
				p.f.TextTransparency = 1 - a
				if stFlicker and random() < 0.025 then p.f.Text = glyphs[random(#glyphs)] end
			elseif stHollow then
				p.f.BackgroundTransparency = 1 - a * 0.15
				if p.g then p.g.Transparency = 1 - a * 0.9 end
			else
				p.f.BackgroundTransparency = 1 - a
				if p.g then p.g.Transparency = 1 - a * 0.55 end
			end
		end

		if st.shooting then
			nextShoot -= dt
			if nextShoot <= 0 then nextShoot = 2.5 + random() * 4; shoot(A) end
		end

		local ticks = FX.decoTicks
		for i = 1, #ticks do ticks[i](dt, clock) end
		local decoItems = FX.decoItems
		for i = 1, #decoItems do
			local it = decoItems[i]
			if it.inst.Parent then it.inst[it.prop] = 1 - (1 - it.base) * baseAlpha end
		end
	end)

	reg(function() FX.RefreshVignette() end)
	rebuild()

	window.SetAmbienceEnabled = function(_, on) FX.Set("on", on) end
	window.SetAmbienceStyle = function(_, n) FX.Set("style", n) end
	window.SetAmbienceOpacity = function(_, x) FX.Set("opacity", x) end
end

--------------------------------------------------------------------------------
-- HUD: stats bar + keybind panel
--------------------------------------------------------------------------------
local KeyShort = {
	LeftShift = "LShift", RightShift = "RShift", LeftControl = "LCtrl", RightControl = "RCtrl", LeftAlt = "LAlt", RightAlt = "RAlt",
	Backspace = "Bksp", Return = "Enter", CapsLock = "Caps", One = "1", Two = "2", Three = "3", Four = "4", Five = "5", Six = "6",
	Seven = "7", Eight = "8", Nine = "9", Zero = "0", Backquote = "`", Minus = "-", Equals = "=", LeftBracket = "[", RightBracket = "]",
	Semicolon = ";", Quote = "'", Comma = ",", Period = ".", Slash = "/", BackSlash = "\\",
}
local function keyText(k) return k and (KeyShort[k.Name] or k.Name) or "-" end

local Presets = {
	["Top Center"] = { Vector2.new(0.5, 0), udim2New(0.5, 0, 0, 10) },
	["Top Left"] = { Vector2.new(0, 0), udim2New(0, 10, 0, 10) },
	["Top Right"] = { Vector2.new(1, 0), udim2New(1, -10, 0, 10) },
	["Bottom Center"] = { Vector2.new(0.5, 1), udim2New(0.5, 0, 1, -10) },
}
Lib.StatsPresets = { "Top Center", "Top Left", "Top Right", "Bottom Center" }

function Hud.Build(window, cfg)
	cfg = cfg or {}
	if cfg.Image == nil or cfg.Image == "" then cfg.Image = LOGO_URL end
	local S, K = UI.stats, UI.keys
	local gui = make("ScreenGui", { Name = "SHubHUD", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 95, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = PlayerGui })
	table.insert(Registry.extra, gui)
	local GOOD, WARN, BAD = c(64, 196, 124), c(235, 178, 58), c(228, 76, 76)

	local bar = make("Frame", { Name = "Stats", AutomaticSize = Enum.AutomaticSize.X, Size = udim2FromOffset(0, 28), AnchorPoint = Vector2.new(0.5, 0), Position = udim2New(0.5, 0, 0, 10), BorderSizePixel = 0, ZIndex = 2, Parent = gui })
	bind(bar, "BackgroundColor3", "Surface")
	round(bar, 6)
	spinStroke(bar, 1.2)
	local barScale = make("UIScale", { Parent = bar })
	make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = bar })
	make("UIPadding", { PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 10), Parent = bar })

	local segs = {}
	local function seg(id, order)
		local f = make("Frame", { AutomaticSize = Enum.AutomaticSize.X, Size = udim2FromOffset(0, 28), BackgroundTransparency = 1, LayoutOrder = order, Parent = bar })
		make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = f })
		local sep = make("Frame", { Size = udim2FromOffset(1, 12), BorderSizePixel = 0, BackgroundTransparency = 0.35, LayoutOrder = 0, Parent = f })
		bind(sep, "BackgroundColor3", "Stroke")
		segs[id] = { f = f, sep = sep }
		return f
	end
	local function txt(parent, text, order, bold, role)
		local l = make("TextLabel", { AutomaticSize = Enum.AutomaticSize.X, Size = udim2FromOffset(0, 15), BackgroundTransparency = 1, Text = text, Font = bold and BOLD or FONT, TextSize = 11, LayoutOrder = order, Parent = parent })
		bind(l, "TextColor3", role)
		return l
	end
	local function iconBox(parent)
		return make("Frame", { Size = udim2FromOffset(13, 13), BackgroundTransparency = 1, LayoutOrder = 1, Parent = parent })
	end
	local function acc(inst)
		bind(inst, "BackgroundColor3", "Accent")
		return inst
	end

	local sId = seg("id", 1)
	segs.id.sep.Visible = false
	local logo = logoTile(sId, 18, 4, cfg.Letter or "S", cfg.Image, nil, 10)
	logo.LayoutOrder = 1
	local nameL = txt(sId, LocalPlayer.DisplayName, 2, true, "Text")

	local sPing = seg("ping", 2)
	local pi = iconBox(sPing)
	local pingBars = {}
	for i, h in ipairs({ 4, 7, 11 }) do
		local b = acc(make("Frame", { Size = udim2FromOffset(2, h), Position = udim2FromOffset((i - 1) * 4 + 1, 13 - h), BorderSizePixel = 0, Parent = pi }))
		make("UICorner", { CornerRadius = UDim.new(0, 1), Parent = b })
		pingBars[i] = b
	end
	local pingV = txt(sPing, "--", 2, true, "Text")
	txt(sPing, "ms", 3, false, "SubText")

	local sFps = seg("fps", 3)
	local fi = iconBox(sFps)
	local ring = make("Frame", { Size = udim2FromOffset(12, 12), Position = udim2FromOffset(0, 1), BackgroundTransparency = 1, Parent = fi })
	pill(ring)
	outline(ring, "Accent", 1.4)
	local needle = acc(make("Frame", { Size = udim2FromOffset(1.5, 4), AnchorPoint = Vector2.new(0.5, 1), Position = udim2FromScale(0.5, 0.55), Rotation = 40, BorderSizePixel = 0, Parent = ring }))
	local fpsV = txt(sFps, "--", 2, true, "Text")
	txt(sFps, "fps", 3, false, "SubText")

	local sPl = seg("players", 4)
	local pli = iconBox(sPl)
	pill(acc(make("Frame", { Size = udim2FromOffset(5, 5), Position = udim2FromOffset(4, 1), BorderSizePixel = 0, Parent = pli })))
	local body = acc(make("Frame", { Size = udim2FromOffset(9, 5), Position = udim2FromOffset(2, 7), BorderSizePixel = 0, Parent = pli }))
	make("UICorner", { CornerRadius = UDim.new(0, 4), Parent = body })
	local plV = txt(sPl, "--", 2, true, "Text")
	txt(sPl, "players", 3, false, "SubText")

	local sTime = seg("time", 5)
	local tiBox = iconBox(sTime)
	local clockRing = make("Frame", { Size = udim2FromOffset(12, 12), Position = udim2FromOffset(0, 1), BackgroundTransparency = 1, Parent = tiBox })
	pill(clockRing)
	outline(clockRing, "Accent", 1.4)
	local hand = acc(make("Frame", { Size = udim2FromOffset(1.5, 4), AnchorPoint = Vector2.new(0.5, 1), Position = udim2FromScale(0.5, 0.55), BorderSizePixel = 0, Parent = clockRing }))
	local timeV = txt(sTime, "--:--", 2, true, "Text")

	local ORDER = { "id", "ping", "fps", "players", "time" }
	local function applyStats()
		logo.Visible, nameL.Visible = S.logo, S.name
		local vis = { id = S.logo or S.name, ping = S.ping, fps = S.fps, players = S.players, time = S.time }
		local first = true
		for _, id in ipairs(ORDER) do
			local sg = segs[id]
			sg.f.Visible = vis[id]
			if id ~= "id" then sg.sep.Visible = vis[id] and not first end
			if vis[id] then first = false end
		end
		bar.Visible = S.on
		bar.BackgroundTransparency = 1 - S.opacity
		barScale.Scale = S.scale
	end
	local function placeStats()
		local p = Presets[S.preset] or Presets["Top Center"]
		bar.AnchorPoint = p[1]
		tween(bar, { Position = p[2] }, BACK)
	end
	makeDraggable(bar, bar)

	local acct, frames = 0, 0
	connect(RunService.Heartbeat, function(dt)
		if not bar.Visible then return end
		acct += dt
		frames += 1
		if acct < 0.4 then return end
		local f = floor(frames / acct + 0.5)
		acct, frames = 0, 0
		local ok, p = pcall(function() return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue() end)
		local ping = ok and floor(p) or 0
		pingV.Text = ok and tostring(ping) or "--"
		fpsV.Text = tostring(f)
		plV.Text = tostring(#Players:GetPlayers())
		timeV.Text = os.date("%H:%M")
		local now = os.date("*t")
		hand.Rotation = (now.min / 60) * 360
		tween(needle, { Rotation = -120 + clamp(f / 120, 0, 1) * 240 }, SLOW)
		local level = ping <= 100 and 3 or (ping <= 200 and 2 or 1)
		for i, b in ipairs(pingBars) do b.BackgroundTransparency = (ok and i > level) and 0.7 or 0 end
		if S.quality then
			pingV.TextColor3 = ping <= 100 and GOOD or (ping <= 200 and WARN or BAD)
			fpsV.TextColor3 = f >= 55 and GOOD or (f >= 30 and WARN or BAD)
		else
			pingV.TextColor3, fpsV.TextColor3 = C("Text"), C("Text")
		end
	end)

	------------------------------------------------------------------ keybind panel
	local panel = make("Frame", { Name = "Keybinds", Size = udim2FromOffset(210, 160), AnchorPoint = Vector2.new(0, 0.5), Position = udim2New(0, 14, 0.5, 0), BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 2, Parent = gui })
	bind(panel, "BackgroundColor3", "Surface")
	round(panel, 6)
	spinStroke(panel, 1.2)
	local panelScale = make("UIScale", { Parent = panel })

	local header = make("Frame", { Size = udim2New(1, 0, 0, 30), BackgroundTransparency = 1, Parent = panel })
	label(header, "KEYBINDS", { Font = BOLD, Size = 10, Role = "SubText", Box = udim2New(1, -54, 1, 0), Pos = udim2FromOffset(10, 0) })
	local badge = make("TextButton", { Size = udim2FromOffset(24, 16), Position = udim2New(1, -32, 0, 7), Text = "0", Font = FONT, TextSize = 10, AutoButtonColor = false, BorderSizePixel = 0, Parent = header })
	bind(badge, "BackgroundColor3", "Element")
	bind(badge, "TextColor3", "SubText")
	round(badge, 4)
	local bst = outline(badge, "Stroke")
	bst.Transparency = 0.5
	local divider = make("Frame", { Size = udim2New(1, 0, 0, 1), Position = udim2FromOffset(0, 30), BorderSizePixel = 0, BackgroundTransparency = 0.45, Parent = panel })
	bind(divider, "BackgroundColor3", "Stroke")
	makeDraggable(header, panel)

	local list = make("ScrollingFrame", { Size = udim2New(1, -10, 0, 90), Position = udim2FromOffset(5, 35), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, CanvasSize = udim2New(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = panel })
	bind(list, "ScrollBarImageColor3", "Stroke")
	make("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list })

	local rows = {}
	local function relayout()
		local shown = 0
		for _, r in ipairs(rows) do
			local vis = r.kind == "ui" or K.showUnbound or (r.h and r.h.key ~= nil)
			r.f.Visible = vis
			if vis then shown += 1 end
		end
		badge.Text = tostring(#rows)
		local h = min(shown, K.maxRows) * 27
		list.Visible = not K.collapsed
		divider.Visible = not K.collapsed
		list.Size = udim2New(1, -10, 0, h)
		tween(panel, { Size = udim2FromOffset(210, K.collapsed and 30 or (40 + h)) }, BACK)
		panel.Visible = K.on
		panel.BackgroundTransparency = 1 - K.opacity
		panelScale.Scale = K.scale
	end
	badge.MouseButton1Click:Connect(function()
		K.collapsed = not K.collapsed
		relayout()
		saveSoon()
	end)

	local function listenKey(b, o)
		if State.Listening then return end
		State.Listening = true
		b.Text = "..."
		local con
		local function stop()
			if con.Connected then con:Disconnect() end
			task.defer(function() State.Listening = false end)
			b.Text = keyText(o.getKey())
		end
		con = UserInputService.InputBegan:Connect(function(i)
			if i.UserInputType ~= Enum.UserInputType.Keyboard then return end
			if i.KeyCode == Enum.KeyCode.Escape then return stop() end
			if i.KeyCode == Enum.KeyCode.Backspace or i.KeyCode == Enum.KeyCode.Delete then
				if o.kind ~= "ui" then o.setKey(nil) end
				return stop()
			end
			o.setKey(i.KeyCode)
			stop()
		end)
		task.delay(8, function() if con.Connected then stop() end end)
	end

	local function addRow(o)
		local f = make("Frame", { Size = udim2New(1, 0, 0, 24), BorderSizePixel = 0, LayoutOrder = #rows + 1, Parent = list })
		bind(f, "BackgroundColor3", "Element")
		round(f, 4)
		local lb = label(f, o.name, { Size = 11, Box = udim2New(1, -90, 1, 0), Pos = udim2FromOffset(7, 0) })
		lb.TextTruncate = Enum.TextTruncate.AtEnd
		local ctrl = make("Frame", { AutomaticSize = Enum.AutomaticSize.X, Size = udim2FromOffset(0, 18), AnchorPoint = Vector2.new(1, 0.5), Position = udim2New(1, -4, 0.5, 0), BackgroundTransparency = 1, Parent = f })
		make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = ctrl })

		local function chip(text, order, accent)
			local b = make("TextButton", { AutomaticSize = Enum.AutomaticSize.X, Size = udim2FromOffset(0, 18), Text = text, Font = FONT, TextSize = 10, AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = order, Parent = ctrl })
			bind(b, "BackgroundColor3", "Background")
			bind(b, "TextColor3", accent and "Accent" or "SubText")
			round(b, 4)
			local cst = outline(b, "Stroke", 1)
			cst.Transparency = 0.55
			make("UIPadding", { PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5), Parent = b })
			make("UISizeConstraint", { MinSize = Vector2.new(22, 18), Parent = b })
			b.MouseEnter:Connect(function() tween(b, { BackgroundColor3 = C("Hover") }) end)
			b.MouseLeave:Connect(function() tween(b, { BackgroundColor3 = C("Background") }) end)
			return b
		end

		local row = { f = f, kind = o.kind, h = o.h }
		local setOn
		if o.kind == "toggle" then
			local tr = make("Frame", { Size = udim2FromOffset(26, 13), BorderSizePixel = 0, LayoutOrder = 1, Parent = ctrl })
			pill(tr)
			local kn = make("Frame", { Size = udim2FromOffset(9, 9), Position = udim2FromOffset(2, 2), BackgroundColor3 = c(245, 245, 250), BorderSizePixel = 0, Parent = tr })
			pill(kn)
			local on = false
			local function paintT(t)
				tween(tr, { BackgroundColor3 = on and C("Accent") or C("Stroke") }, t)
			end
			reg(paintT)
			function setOn(v)
				on = v and true or false
				paintT()
				tween(kn, { Position = on and udim2FromOffset(15, 2) or udim2FromOffset(2, 2) }, SPRING)
			end
			make("TextButton", { Size = udim2FromScale(1, 1), BackgroundTransparency = 1, Text = "", Parent = tr }).MouseButton1Click:Connect(function()
				if o.h and o.h.Set then o.h.Set(not o.h.state) end
			end)
		end
		local kb = chip(keyText(o.getKey()), 2)
		kb.MouseButton1Click:Connect(function() listenKey(kb, o) end)
		if o.kind ~= "toggle" then
			chip("Run", 3, true).MouseButton1Click:Connect(o.run)
		end
		row.refresh = function() kb.Text = keyText(o.getKey()) end
		row.setOn = setOn
		table.insert(rows, row)
		return row
	end

	local winKey = cfg.Key or Enum.KeyCode.RightShift
	if K.menu ~= "" then
		local ok, k = pcall(function() return Enum.KeyCode[K.menu] end)
		if ok and k then winKey = k; window:SetKey(k) end
	end
	local uiRow
	local origSetKey = window.SetKey
	local function setMenuKey(k)
		winKey = k
		origSetKey(window, k)
		K.menu = k.Name
		if uiRow then uiRow.refresh() end
		saveSoon()
	end
	window.SetKey = function(_, k) setMenuKey(k) end
	uiRow = addRow({ name = "Toggle UI Key", kind = "ui", getKey = function() return winKey end, setKey = setMenuKey, run = function() window:Toggle() end })

	function Hud.addFeature(h)
		local def = h.Def
		local isBtn = def.Kind == "button"
		local row
		row = addRow({
			name = def.Name, kind = isBtn and "button" or "toggle", h = h,
			getKey = function() return h.key end,
			setKey = function(k)
				if k then
					for _, r in ipairs(rows) do
						if r.h and r.h ~= h and r.h.key == k then r.h.key = nil; r.refresh() end
					end
				end
				h.key = k
				row.refresh()
				relayout()
				saveSoon()
			end,
			run = function() if h.Run then h.Run() end end,
		})
		if row.setOn then
			row.setOn(h.state)
			table.insert(h.sync, row.setOn)
		end
		relayout()
	end

	connect(UserInputService.InputBegan, function(i, processed)
		if processed or State.Listening or i.UserInputType ~= Enum.UserInputType.Keyboard then return end
		for _, h in pairs(Registry.built) do
			if h.key and h.key == i.KeyCode then
				if h.Run then h.Run() elseif h.Set then h.Set(not h.state) end
			end
		end
	end)

	function Hud.SetStat(k, v)
		S[k] = v
		if k == "preset" then placeStats() end
		applyStats()
		saveSoon()
	end
	function Hud.SetKeys(k, v)
		K[k] = v
		relayout()
		saveSoon()
	end
	function Hud.ResetStats() placeStats() end
	function Hud.ResetKeys() tween(panel, { Position = udim2New(0, 14, 0.5, 0) }, BACK) end

	applyStats()
	placeStats()
	relayout()
end

--------------------------------------------------------------------------------
-- DISCORD & CREDITS TAB (built into core)
--------------------------------------------------------------------------------
local function joinDiscord(Window)
	local req = (syn and syn.request) or http_request or request
	if not IsMobile and req then
		pcall(req, {
			Url = "http://127.0.0.1:6463/rpc?v=1",
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
				["Origin"] = "https://discord.com",
			},
			Body = HttpService:JSONEncode({
				cmd = "INVITE_BROWSER",
				args = { code = DISCORD_CODE },
				nonce = HttpService:GenerateGUID(false),
			}),
		})
	end
	local copy = setclipboard or toclipboard or (Clipboard and Clipboard.set)
	if typeof(copy) == "function" then
		pcall(copy, DISCORD_URL)
		if Window then Window:Notify("Discord", "Invite link copied: " .. DISCORD_URL, 4, "Success") end
	else
		if Window then Window:Notify("Discord", "Join us at: " .. DISCORD_URL, 5, "Info") end
	end
end

function Lib:BuildDiscord()
	local Window = Registry.window
	if not Window or Registry._discordBuilt then return end
	Registry._discordBuilt = true

	local tab = Window:AddTab("Credits", "★")

	-- Left column: Discord Community Banner + Leadership
	local discSec = tab:AddSection("Discord Server", "Left")

	local banner = make("Frame", { Size = udim2New(1, 0, 0, 96), BorderSizePixel = 0, LayoutOrder = nextOrder(discSec.Frame), Parent = discSec.Frame })
	bind(banner, "BackgroundColor3", "Element")
	round(banner, 6)
	local bst = outline(banner, "Stroke")
	bst.Transparency = 0.45
	local bGrad = make("UIGradient", {
		Rotation = 25,
		Color = ColorSequence.new(c(88, 101, 242), c(255, 255, 255)),
		Transparency = NumberSequence.new({ kp(0, 0.72), kp(1, 0.94) }),
		Parent = banner,
	})
	logoTile(banner, 36, 7, "S", LOGO_URL, udim2FromOffset(12, 10), 18)
	label(banner, "S Hub Official Discord", { Font = BOLD, Size = 13, Box = udim2New(1, -60, 0, 17), Pos = udim2FromOffset(56, 10) })
	label(banner, "Updates • Scripts • Support • Giveaways", { Size = 10, Role = "SubText", Box = udim2New(1, -60, 0, 14), Pos = udim2FromOffset(56, 27) })

	local joinBtn = make("TextButton", {
		Size = udim2New(1, -24, 0, 30), Position = udim2FromOffset(12, 56),
		BackgroundColor3 = c(88, 101, 242), Text = "Join Discord Server  ·  discord.gg/" .. DISCORD_CODE,
		Font = BOLD, TextSize = 11, TextColor3 = WHITE, AutoButtonColor = false, BorderSizePixel = 0, Parent = banner,
	})
	round(joinBtn, 5)
	local jScale = make("UIScale", { Scale = 1, Parent = joinBtn })
	joinBtn.MouseEnter:Connect(function()
		tween(joinBtn, { BackgroundColor3 = c(105, 118, 255) })
		tween(jScale, { Scale = 1.015 }, FAST)
	end)
	joinBtn.MouseLeave:Connect(function()
		tween(joinBtn, { BackgroundColor3 = c(88, 101, 242) })
		tween(jScale, { Scale = 1 }, FAST)
	end)
	joinBtn.MouseButton1Down:Connect(function() tween(jScale, { Scale = 0.97 }, MICRO) end)
	joinBtn.MouseButton1Up:Connect(function() tween(jScale, { Scale = 1 }, SPRING) end)
	joinBtn.MouseButton1Click:Connect(function()
		ripple(banner)
		joinDiscord(Window)
	end)
	indexItem(discSec, banner, "discord server join " .. DISCORD_URL)

	discSec:AddButton({
		Name = "Copy Invite Link",
		Desc = DISCORD_URL,
		Callback = function() joinDiscord(Window) end,
	})

	local leadSec = tab:AddSection("Leadership", "Left")
	leadSec:AddProfile({
		Username = CREDITS_DATA.Founder.Name,
		Role = CREDITS_DATA.Founder.Role,
		Badge = CREDITS_DATA.Founder.Badge,
		Color = CREDITS_DATA.Founder.Color,
	})
	leadSec:AddProfile({
		Username = CREDITS_DATA.CoFounder.Name,
		Role = CREDITS_DATA.CoFounder.Role,
		Badge = CREDITS_DATA.CoFounder.Badge,
		Color = CREDITS_DATA.CoFounder.Color,
	})

	-- Right column: Testers + Hub Info
	local testSec = tab:AddSection("Quality Assurance & Testers", "Right")
	for _, tester in ipairs(CREDITS_DATA.Testers) do
		testSec:AddProfile({
			Username = tester.Name,
			Role = tester.Role,
			Badge = tester.Badge,
			Color = tester.Color,
		})
	end

	local infoSec = tab:AddSection("About S Hub", "Right")
	infoSec:AddCard({
		Title = "S Hub  ·  v" .. Lib.Version,
		Body = ("Device Mode: %s\nClick any team profile card to copy their username."):format(IsMobile and "Mobile (Touch Optimized)" or "Desktop (Keyboard & Mouse)"),
	})
end

--------------------------------------------------------------------------------
-- APPEARANCE TAB (call it LAST in the loader)
--------------------------------------------------------------------------------
function Lib:BuildAppearance()
	local Window = Registry.window
	local look = Window:AddTab("Appearance", "⚙")
	local F, S, K, L = UI.fx, UI.stats, UI.keys, UI.look
	local function pct(x) return floor(x * 100 + 0.5) end

	local colors = look:AddSection("Theme & Colors", "Left")
	local themeDD = colors:AddDropdown({ Name = "Theme", Options = Lib.ThemeNames, Default = State.Theme, Search = true, Callback = function(n) Window:SetTheme(n) end })
	colors:AddThemeGallery({ Callback = function(n) Window:SetTheme(n) end })
	Window:OnThemeChanged(function(n) themeDD.Set(n, true) end)
	local useCustom = State.BaseAccent ~= nil
	local customColor = State.BaseAccent or Color3.fromRGB(218, 48, 56)
	colors:AddToggle({ Name = "Custom accent color", Desc = "Override the theme accent", Default = useCustom, Callback = function(on)
		useCustom = on
		Window:SetAccent(on and customColor or nil)
	end })
	colors:AddColorPicker({ Name = "Accent color", Default = customColor, Callback = function(col)
		customColor = col
		if useCustom then Window:SetAccent(col) end
	end })
	colors:AddToggle({ Name = "Rainbow accent", Desc = "Cycles the accent through every hue", Default = L.rainbow, Callback = function(v) Window:SetRainbow(v) end })
	colors:AddSlider({ Name = "Rainbow speed", Min = 10, Max = 300, Default = pct(L.rainbowSpeed), Step = 10, Suffix = "%", Callback = function(v) L.rainbowSpeed = v / 100; saveSoon() end })

	local winSec = look:AddSection("Window", "Left")
	winSec:AddSlider({ Name = "Window opacity", Min = 35, Max = 100, Default = pct(L.opacity), Suffix = "%", Callback = function(v) Window:SetOpacity(v / 100) end })
	winSec:AddSlider({ Name = "Roundness", Min = 0, Max = 150, Default = pct(L.rounding), Step = 5, Suffix = "%", Callback = function(v) Window:SetRounding(v / 100) end })
	winSec:AddSlider({ Name = "UI scale", Min = 60, Max = 150, Default = pct(L.scale), Step = 5, Suffix = "%", Callback = function(v) Window:SetScale(v / 100) end })
	winSec:AddToggle({ Name = "Animated border", Desc = "Spinning accent outline", Default = L.border, Callback = function(v) Window:SetBorder(v) end })
	winSec:AddToggle({ Name = "Ambient glow", Desc = "Soft accent glow around the hub", Default = L.glow, Callback = function(v) Window:SetGlow(v) end })
	winSec:AddToggle({ Name = "Background blur", Desc = "Blurs the game while the menu is open", Default = L.blur, Callback = function(v) Window:SetBlur(v) end })
	winSec:AddToggle({ Name = "Click ripples", Default = L.ripple, Callback = function(v) Window:SetRipple(v) end })
	if not IsMobile then
		local menuKey = Enum.KeyCode.RightShift
		if K.menu ~= "" then
			local ok, k = pcall(function() return Enum.KeyCode[K.menu] end)
			if ok and k then menuKey = k end
		end
		winSec:AddKeybind({ Name = "Toggle menu", Default = menuKey, Callback = function(k) Window:SetKey(k) end })
	end

	local statSec = look:AddSection("Stats Bar", "Left")
	statSec:AddToggle({ Name = "Show stats bar", Desc = "Always on, drag it anywhere", Default = S.on, Callback = function(v) Hud.SetStat("on", v) end })
	statSec:AddToggle({ Name = "Logo", Default = S.logo, Callback = function(v) Hud.SetStat("logo", v) end })
	statSec:AddToggle({ Name = "Username", Default = S.name, Callback = function(v) Hud.SetStat("name", v) end })
	statSec:AddToggle({ Name = "Ping", Default = S.ping, Callback = function(v) Hud.SetStat("ping", v) end })
	statSec:AddToggle({ Name = "FPS", Default = S.fps, Callback = function(v) Hud.SetStat("fps", v) end })
	statSec:AddToggle({ Name = "Player count", Default = S.players, Callback = function(v) Hud.SetStat("players", v) end })
	statSec:AddToggle({ Name = "Clock", Default = S.time, Callback = function(v) Hud.SetStat("time", v) end })
	statSec:AddToggle({ Name = "Color by quality", Desc = "Green / yellow / red values", Default = S.quality, Callback = function(v) Hud.SetStat("quality", v) end })
	statSec:AddSlider({ Name = "Scale", Min = 60, Max = 160, Default = pct(S.scale), Step = 5, Suffix = "%", Callback = function(v) Hud.SetStat("scale", v / 100) end })
	statSec:AddSlider({ Name = "Opacity", Min = 20, Max = 100, Default = pct(S.opacity), Step = 5, Suffix = "%", Callback = function(v) Hud.SetStat("opacity", v / 100) end })
	statSec:AddDropdown({ Name = "Position", Options = Lib.StatsPresets, Default = S.preset, Callback = function(n) Hud.SetStat("preset", n) end })
	statSec:AddButton({ Name = "Reset position", Callback = function() Hud.ResetStats() end })

	if not IsMobile then
		local keySec = look:AddSection("Keybind Panel", "Left")
		keySec:AddToggle({ Name = "Show keybind panel", Desc = "Click or press keys to run features", Default = K.on, Callback = function(v) Hud.SetKeys("on", v) end })
		keySec:AddToggle({ Name = "Show unbound features", Default = K.showUnbound, Callback = function(v) Hud.SetKeys("showUnbound", v) end })
		keySec:AddSlider({ Name = "Visible rows", Min = 4, Max = 16, Default = K.maxRows, Callback = function(v) Hud.SetKeys("maxRows", v) end })
		keySec:AddSlider({ Name = "Scale", Min = 60, Max = 150, Default = pct(K.scale), Step = 5, Suffix = "%", Callback = function(v) Hud.SetKeys("scale", v / 100) end })
		keySec:AddSlider({ Name = "Opacity", Min = 20, Max = 100, Default = pct(K.opacity), Step = 5, Suffix = "%", Callback = function(v) Hud.SetKeys("opacity", v / 100) end })
		keySec:AddButton({ Name = "Reset position", Callback = function() Hud.ResetKeys() end })
	end

	local fxSec = look:AddSection("Screen Effects", "Right")
	fxSec:AddToggle({ Name = "Enable effects", Default = F.on, Callback = function(v) FX.Set("on", v) end })
	fxSec:AddToggle({ Name = "Only while menu is open", Desc = "Fades out when the hub is minimized", Default = F.menuOnly, Callback = function(v) FX.Set("menuOnly", v) end })
	fxSec:AddDropdown({ Name = "Style", Options = Lib.StyleNames, Default = F.style, Search = true, Callback = function(n) FX.Set("style", n) end })
	fxSec:AddDropdown({ Name = "Colors", Options = { "Style", "Theme" }, Default = F.tint, Callback = function(n) FX.Set("tint", n) end })
	fxSec:AddSlider({ Name = "Opacity", Min = 0, Max = 100, Default = pct(F.opacity), Suffix = "%", Callback = function(v) FX.Set("opacity", v / 100) end })
	fxSec:AddSlider({ Name = "Density", Min = 20, Max = 300, Default = pct(F.density), Step = 10, Suffix = "%", Callback = function(v) FX.Set("density", v / 100) end })
	fxSec:AddSlider({ Name = "Speed", Min = 20, Max = 300, Default = pct(F.speed), Step = 10, Suffix = "%", Callback = function(v) FX.Set("speed", v / 100) end })
	fxSec:AddToggle({ Name = "Decorations", Desc = "Santa sleigh, ornaments, lights, snowmen, moon...", Default = F.deco, Callback = function(v) FX.Set("deco", v) end })
	fxSec:AddToggle({ Name = "Lightning", Desc = "Storm flashes (Halloween / Neon Rain)", Default = F.lightning, Callback = function(v) FX.Set("lightning", v) end })
	fxSec:AddToggle({ Name = "Vignette", Default = F.vignette, Callback = function(v) FX.Set("vignette", v) end })
	fxSec:AddSlider({ Name = "Vignette strength", Min = 0, Max = 100, Default = pct(F.vignetteStrength), Suffix = "%", Callback = function(v) FX.Set("vignetteStrength", v / 100) end })
	fxSec:AddSlider({ Name = "Fade time", Min = 10, Max = 150, Default = pct(F.fade), Step = 5, Suffix = "%", Callback = function(v) FX.Set("fade", v / 100) end })

	local cursorSec = look:AddSection("Touch & Cursor Effects", "Right")
	if not IsMobile then
		cursorSec:AddToggle({ Name = "Cursor trail", Desc = "Glowing accent trail while the menu is open", Default = F.trail, Callback = function(v) FX.Set("trail", v) end })
	end
	cursorSec:AddToggle({ Name = "Tap / click burst", Desc = "Particle pop on every tap or click", Default = F.burst, Callback = function(v) FX.Set("burst", v) end })

	local launcherSec = look:AddSection("Launcher", "Right")
	local lLetter, lSize = "S", Lib.IsMobile and 48 or 42
	launcherSec:AddTextbox({ Name = "Letter", Default = "S", Placeholder = "S", MaxLength = 2, Callback = function(t)
		if t ~= "" then lLetter = t; Window:SetLauncher(lLetter, lSize) end
	end })
	launcherSec:AddSlider({ Name = "Size", Min = 34, Max = 80, Default = lSize, Suffix = "px", Callback = function(v)
		lSize = v
		Window:SetLauncher(lLetter, lSize)
	end })
	launcherSec:AddButton({ Name = "Minimize to launcher", Desc = "Collapse the hub into the draggable launcher", Callback = function() Window:SetVisible(false) end })

	local cfgSec = look:AddSection("Config", "Right")
	cfgSec:AddToggle({ Name = "Auto save", Desc = "Writes settings to " .. CONFIG_FILE, Default = Lib.AutoSave, Callback = function(v) Lib.AutoSave = v end })
	cfgSec:AddButton({ Name = "Save now", Callback = function()
		Lib:SaveConfig()
		if canFile() then Window:Notify("Config", "Settings saved.", 3, "Success")
		else Window:Notify("Config", "This executor has no file access.", 3, "Warning") end
	end })
	cfgSec:AddButton({ Name = "Test notifications", Desc = "Preview every toast style", Callback = function()
		Window:Notify("Info", "Something worth knowing.", 3, "Info")
		task.wait(0.25)
		Window:Notify("Success", "Everything worked.", 3, "Success")
		task.wait(0.25)
		Window:Notify("Warning", "Careful with that.", 3, "Warning")
		task.wait(0.25)
		Window:Notify("Error", "Something went wrong.", 3, "Error")
	end })

	self:BuildDiscord()
end

--------------------------------------------------------------------------------
-- FEATURE REGISTRY
--------------------------------------------------------------------------------
function Lib:Notify(title, msg, dur, kind)
	if Registry.window then return Registry.window:Notify(title, msg, dur, kind) end
end

local function sectionFor(def)
	local tab = Registry.tabs[def.Tab]
	if not tab then
		tab = Registry.window:AddTab(def.Tab, def.TabIcon)
		Registry.tabs[def.Tab] = tab
	end
	local key = def.Tab .. "|" .. def.Section
	local sec = Registry.sections[key]
	if not sec then
		sec = tab:AddSection(def.Section, def.Side or "Left")
		Registry.sections[key] = sec
	end
	return sec
end

local SettingDefaults = {
	Slider   = function(o) return o.Min or 0 end,
	Dropdown = function(o) if o.Multi then return {} end return o.Options and o.Options[1] end,
	Toggle   = function() return false end,
	Textbox  = function() return "" end,
}

local function build(def)
	if Registry.feats[def.Id] then return end
	local sec = sectionFor(def)
	local saved = Registry.config[def.Id] or {}
	local h = { Def = def, state = false, values = {}, sync = {} }
	Registry.feats[def.Id] = h

	local function run(on)
		h.state = on
		local ok, err = pcall(def.Apply, on, h.values, h)
		if not ok then warn(("[SHub] %s: %s"):format(def.Id, tostring(err))) end
		saveSoon()
	end

	if def.Kind == "button" then
		h.Run = function() run(true) end
		sec:AddButton({ Name = def.Name, Desc = def.Desc, Callback = h.Run })
	else
		local tog
		local function set(v, from)
			v = v and true or false
			run(v)
			if from ~= "ui" and tog then tog.Set(v, true) end
			for _, fn in ipairs(h.sync) do fn(v) end
		end
		tog = sec:AddToggle({ Name = def.Name, Desc = def.Desc, Callback = function(v) set(v, "ui") end })
		h.Set = function(v) set(v, "api") end
	end

	for _, s in ipairs(def.Settings or {}) do
		local o = table.clone(s)
		local kind = o.Type or "Slider"
		o.Type = nil
		local key = o.Key or o.Name
		local d = saved.values and saved.values[key]
		if d == nil then d = o.Default end
		if d == nil and SettingDefaults[kind] then d = SettingDefaults[kind](o) end
		o.Default = d
		h.values[key] = d
		local cb = o.Callback
		o.Callback = function(v)
			h.values[key] = v
			if cb then cb(v, h) end
			saveSoon()
		end
		local adder = sec["Add" .. kind]
		if adder then adder(sec, o) else warn("[SHub] unknown setting type: " .. tostring(kind)) end
	end

	Registry.add(h)
	if h.Set and saved.on then h.Set(true) end
end

function Lib:Register(def)
	assert(def and def.Id and def.Name and def.Apply, "Register needs Id, Name, Apply")
	if Registry.byId[def.Id] then return Registry.feats[def.Id] end
	def.Tab = def.Tab or "Main"
	def.Section = def.Section or "Features"
	Registry.byId[def.Id] = def
	table.insert(Registry.list, def)
	if Registry.window then build(def) end
	return def
end

function Lib:Get(id) return Registry.feats[id] end
function Lib:Features() return Registry.list end

function Lib:SetFeature(id, on)
	local h = Registry.feats[id]
	if not h then return false end
	if h.Run then h.Run() elseif h.Set then h.Set(on) end
	return true
end

function Lib:Mount(cfg)
	cfg = cfg or {}
	if cfg.Image == nil or cfg.Image == "" then cfg.Image = LOGO_URL end
	Lib:LoadConfig()
	table.clear(Registry.tabs); table.clear(Registry.sections); table.clear(Registry.feats)
	Registry._discordBuilt = false
	local w = self:CreateWindow(cfg)
	Registry.window = w
	FX.Build(w)
	Hud.Build(w, cfg)
	w.Gui.Destroying:Connect(function()
		for _, h in pairs(Registry.feats) do
			if h.state and h.Def.Kind ~= "button" then pcall(h.Def.Apply, false, h.values, h) end
		end
	end)
	for _, def in ipairs(Registry.list) do build(def) end
	self:BuildDiscord()
	return w
end

return Lib -- must be the last line of the core file
