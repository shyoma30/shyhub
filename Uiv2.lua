--------------------------------------------------------------------------------
-- S Hub core  ·  v2
--------------------------------------------------------------------------------
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

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

--------------------------------------------------------------------------------
-- themes
--------------------------------------------------------------------------------
local c = Color3.fromRGB
local WHITE = c(255, 255, 255)
local function theme(bg, surface, element, hover, stroke, accent, text, sub, accent2)
	return { Background = bg, Surface = surface, Element = element, Hover = hover, Stroke = stroke, Accent = accent, Text = text, SubText = sub, Accent2 = accent2 }
end

local Themes = {
	Eclipse   = theme(c(14,14,17), c(21,21,26), c(30,30,37), c(40,40,49), c(56,56,68), c(255,166,52), c(240,240,244), c(150,150,162), c(255,96,64)),
	Celestial = theme(c(11,17,34), c(17,25,48), c(25,36,66), c(34,48,86), c(46,66,112), c(88,150,255), c(234,240,255), c(135,150,185), c(150,110,255)),
	Crimson   = theme(c(22,9,11), c(33,14,17), c(47,20,24), c(62,27,32), c(88,36,44), c(232,60,78), c(248,236,238), c(180,140,146), c(255,124,92)),
	Aurora    = theme(c(9,26,22), c(14,38,32), c(20,54,44), c(27,70,58), c(30,92,72), c(24,190,132), c(236,246,241), c(138,176,160), c(40,196,232)),
	Nebula    = theme(c(19,11,31), c(28,17,46), c(40,25,64), c(53,34,84), c(76,48,118), c(182,102,255), c(242,236,252), c(160,140,185), c(255,100,200)),
	Solar     = theme(c(27,19,9), c(38,28,13), c(52,39,17), c(67,50,22), c(96,72,30), c(255,198,48), c(252,246,232), c(184,166,130), c(255,128,40)),
	Starlight = theme(c(17,19,27), c(25,28,39), c(35,39,53), c(46,51,68), c(62,68,92), c(200,212,255), c(244,246,255), c(148,154,176), c(160,140,255)),
	Cyberpunk = theme(c(12,7,22), c(20,11,36), c(30,17,52), c(41,23,70), c(72,40,112), c(255,46,151), c(250,236,250), c(170,140,180), c(0,230,255)),
	Abyss     = theme(c(6,10,14), c(10,16,22), c(14,24,32), c(20,34,45), c(28,48,63), c(38,172,204), c(228,240,246), c(125,150,162), c(60,110,255)),
	Midnight  = theme(c(10,10,14), c(16,16,22), c(24,24,32), c(32,32,43), c(46,46,62), c(124,108,255), c(238,238,248), c(146,146,170), c(80,170,255)),
	Sakura    = theme(c(28,16,22), c(40,23,32), c(55,32,44), c(70,41,56), c(98,58,78), c(255,138,184), c(253,240,246), c(190,150,168), c(255,190,150)),
	Ocean     = theme(c(7,18,28), c(11,27,41), c(16,38,57), c(22,50,74), c(30,68,100), c(56,200,255), c(232,246,255), c(130,165,185), c(60,120,255)),
	Matcha    = theme(c(16,20,14), c(23,29,20), c(32,40,28), c(42,52,36), c(58,72,50), c(160,214,110), c(240,246,234), c(155,170,140), c(220,230,120)),
	Dracula   = theme(c(24,25,33), c(33,34,44), c(44,46,58), c(56,58,73), c(78,80,100), c(189,147,249), c(248,248,242), c(160,165,190), c(255,121,198)),
	Sunset    = theme(c(26,12,18), c(38,18,26), c(52,24,34), c(68,32,44), c(96,44,58), c(255,112,80), c(255,240,234), c(190,150,150), c(255,60,140)),
	Vaporwave = theme(c(18,10,30), c(27,15,44), c(38,22,60), c(50,30,78), c(74,46,110), c(0,229,255), c(245,238,255), c(170,150,200), c(255,90,220)),
	BloodMoon = theme(c(14,6,6), c(22,9,9), c(32,13,13), c(44,18,18), c(66,26,26), c(255,48,48), c(250,232,232), c(175,130,130), c(255,140,40)),
	Mono      = theme(c(12,12,12), c(19,19,19), c(28,28,28), c(38,38,38), c(54,54,54), c(235,235,235), c(245,245,245), c(150,150,150), c(150,150,150)),
	Snow      = theme(c(236,239,245), c(246,248,252), c(255,255,255), c(232,236,244), c(208,214,226), c(70,110,255), c(24,28,40), c(110,118,138), c(130,90,255)),
}
local ThemeNames = {
	"Eclipse", "Celestial", "Crimson", "Aurora", "Nebula", "Solar", "Starlight", "Cyberpunk", "Abyss",
	"Midnight", "Sakura", "Ocean", "Matcha", "Dracula", "Sunset", "Vaporwave", "BloodMoon", "Mono", "Snow",
}
local StyleNames = {} -- filled by the FX module below

--------------------------------------------------------------------------------
-- core state + helpers
--------------------------------------------------------------------------------
local Lib = { Themes = Themes, ThemeNames = ThemeNames, StyleNames = StyleNames, IsMobile = IsMobile, Version = "2.0" }
local State = { Theme = "Aurora", Accent = nil, BaseAccent = nil, Rounding = 1, Opacity = 1, Scale = 1, Listening = false }

-- shared settings (FX engine, stats bar, keybind panel, look) + feature registry
Lib.UI = {
	fx = {
		on = false, menuOnly = true, style = "Spooky Halloween", tint = "Style",
		opacity = 0.8, density = 1, speed = 1, deco = true, lightning = true,
		vignette = true, vignetteStrength = 0.6, fade = 1, trail = false, burst = true,
	},
	stats = {
		on = true, logo = true, name = true, ping = true, fps = true, players = true, time = false,
		quality = true, scale = 1, opacity = 1, preset = "Top Center",
	},
	keys = {
		on = not IsMobile, showUnbound = true, maxRows = 8, scale = 1, opacity = 1,
		collapsed = false, menu = "",
	},
	look = {
		theme = "", accent = "", customAccent = false, rainbow = false, rainbowSpeed = 1,
		border = true, glow = true, blur = false, ripple = true,
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

-- config persistence (only when the environment exposes file functions)
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

local FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local SLOW = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local BACK = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local SMOOTH = TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
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
		if State.Accent then return shiftHue(State.Accent, 0.09) end
		return t.Accent2 or shiftHue(t.Accent or Themes.Eclipse.Accent, 0.09)
	end
	return t[role] or Themes.Eclipse[role] or WHITE
end

local function onAccent()
	local a = C("Accent")
	local lum = 0.299 * a.R + 0.587 * a.G + 0.114 * a.B
	return lum > 0.6 and c(18,18,22) or c(255,255,255)
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
	for _, fn in ipairs(refreshers) do pcall(fn, info) end
end

local function round(inst, r)
	local corner = make("UICorner", { CornerRadius = UDim.new(0, math.floor(r * State.Rounding + 0.5)), Parent = inst })
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

-- accent -> accent2 gradient (use on WHITE backgrounds; children are not affected)
local function accentGradient(parent, rot)
	local g = make("UIGradient", { Rotation = rot or 0, Parent = parent })
	reg(function()
		if g.Parent then g.Color = ColorSequence.new(C("Accent"), C("Accent2")) end
	end)
	return g
end

-- animated accent stroke (rotates; falls back to a plain stroke when "border" look is off)
local function spinStroke(inst, thick, always)
	local s = make("UIStroke", { Thickness = thick or 1.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = inst })
	local g = make("UIGradient", { Transparency = NumberSequence.new({ kp(0, 0), kp(0.5, 0.6), kp(1, 0) }), Parent = s })
	table.insert(spinners, { s = s, g = g, ofs = math.random(0, 360) })
	reg(function()
		if not s.Parent then return end
		local on = always or UI.look.border
		g.Enabled = on
		g.Color = ColorSequence.new({ ckp(0, C("Accent")), ckp(0.5, C("Accent2")), ckp(1, C("Accent")) })
		s.Color = on and WHITE or C("Stroke")
		s.Thickness = on and (thick or 1.2) or 1
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
		TextSize = o.Size or 13,
		TextXAlignment = o.AlignX or Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextWrapped = o.Wrap or false,
		Size = o.Box or UDim2.new(1, 0, 1, 0),
		Position = o.Pos or UDim2.new(),
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
	local f = make("Frame", { Size = UDim2.new(1, 0, 0, h), BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = nextOrder(parent), Parent = parent })
	bind(f, "BackgroundColor3", "Element")
	f.BackgroundTransparency = 1 - State.Opacity
	table.insert(glassList, f)
	round(f, 8)
	local s = outline(f, "Stroke")
	s.Transparency = 0.55
	cardStroke[f] = s
	return f
end

local function hover(hit, f)
	local s = cardStroke[f]
	hit.MouseEnter:Connect(function()
		tween(f, { BackgroundColor3 = C("Hover") })
		if s then tween(s, { Color = C("Accent"), Transparency = 0.35 }) end
	end)
	hit.MouseLeave:Connect(function()
		tween(f, { BackgroundColor3 = C("Element") })
		if s then tween(s, { Color = C("Stroke"), Transparency = 0.55 }) end
	end)
end

local function isPress(i)
	return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
end

-- material ripple from the cursor position (parent should clip descendants)
local function ripple(f)
	if not UI.look.ripple or not f or not f.Parent then return end
	local abs, size = f.AbsolutePosition, f.AbsoluteSize
	if size.X < 1 or size.Y < 1 then return end
	local m = UserInputService:GetMouseLocation()
	local rx = math.clamp((m.X - abs.X) / size.X, 0, 1)
	local ry = math.clamp((m.Y - abs.Y) / size.Y, 0, 1)
	local d = math.max(size.X, size.Y) * 2.2
	local r = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(rx, ry), Size = UDim2.fromScale(0, 0),
		BackgroundColor3 = C("Accent"), BackgroundTransparency = 0.65, BorderSizePixel = 0, ZIndex = 0, Parent = f,
	})
	pill(r)
	tween(r, { Size = UDim2.fromScale(d / size.X, d / size.Y), BackgroundTransparency = 1 }, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
	task.delay(0.65, function() r:Destroy() end)
end

-- drag helper: returns { moved = fn } so Activated handlers can ignore drags
local function makeDraggable(handle, target)
	local dragging, moved, active, startPos, startUDim = false, false, nil, nil, nil
	local dragInfo = TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	handle.InputBegan:Connect(function(i)
		if isPress(i) then
			dragging, moved, active = true, false, i
			startPos, startUDim = i.Position, target.Position
		end
	end)
	connect(UserInputService.InputChanged, function(i)
		if not dragging then return end
		if i == active or i.UserInputType == Enum.UserInputType.MouseMovement then
			local d = i.Position - startPos
			if d.Magnitude > 6 then moved = true end
			if moved then
				TweenService:Create(target, dragInfo, {
					Position = UDim2.new(startUDim.X.Scale, startUDim.X.Offset + d.X, startUDim.Y.Scale, startUDim.Y.Offset + d.Y),
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
	return math.clamp(math.min((vp.X - 24) / w, (vp.Y - 24) / h), 0.4, 1)
end

-- logo image overlay: full-bleed square. Once the image paints, the slot's own
-- background (and launcher ring) drops out, so a transparent png stays transparent.
-- Falls back to the letter if the image never loads.
local function logoImage(parent, image, textObj, radius)
	if image == nil or image == "" then return end

	local function show(asset)
		if not parent.Parent then return end
		local img = make("ImageLabel", {
			Name = "LogoImage",
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0, 0),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Image = asset,
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = parent.ZIndex + 1,
			Parent = parent,
		})

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
	end

	if typeof(image) == "number" or (typeof(image) == "string" and image:match("^%d+$")) then
		return task.spawn(show, "rbxassetid://" .. image)
	end
	if typeof(image) ~= "string" then return end
	if image:match("^rbxasset") then return task.spawn(show, image) end

	task.spawn(function()
		local req = (syn and syn.request) or http_request or request
		if not req or typeof(writefile) ~= "function" or not (getcustomasset or getsynasset) then
			return warn("[SHub] executor missing request/writefile/getcustomasset")
		end

		local ok, res = pcall(req, { Url = image, Method = "GET" })
		if not ok or not res or not res.Body or #res.Body == 0 then
			return warn("[SHub] logo fetch failed:", ok and res and res.StatusCode or res)
		end
		local data = res.Body

		local isPng = data:sub(1, 4) == "\137PNG"
		local isJpg = data:sub(1, 3) == "\255\216\255"
		if not (isPng or isJpg) then
			return warn("[SHub] logo not png/jpg, size", #data, "head:", data:sub(1, 40))
		end

		local file = "SHub_logo" .. (isPng and ".png" or ".jpg")
		local wok, werr = pcall(writefile, file, data)
		if not wok then return warn("[SHub] writefile failed:", werr) end
		local aok, asset = pcall(getcustomasset or getsynasset, file)
		if not aok then return warn("[SHub] getcustomasset failed:", asset) end
		show(asset)
	end)
end

-- gradient logo tile with a letter
local function logoTile(parent, size, radius, letter, image, pos, textSize)
	local logo = make("Frame", { Size = UDim2.fromOffset(size, size), Position = pos or UDim2.new(), BorderSizePixel = 0, BackgroundColor3 = WHITE, Parent = parent })
	accentGradient(logo, 45)
	round(logo, radius)
	local t = label(logo, letter, { Font = Enum.Font.GothamBlack, Size = textSize or math.floor(size * 0.58), AlignX = Enum.TextXAlignment.Center, Role = false })
	reg(function(tt) tween(t, { TextColor3 = onAccent() }, tt) end)
	logoImage(logo, image, t, radius)
	return logo, t
end

--------------------------------------------------------------------------------
-- section elements
--------------------------------------------------------------------------------
local Section = {}
Section.__index = Section

-- search index (top-bar search filters items of the open tab)
local function indexItem(sec, f, name)
	if sec and sec.Tab then
		table.insert(sec.Tab.items, { f = f, name = string.lower(tostring(name or "")), sec = sec })
	end
end

function Section:AddLabel(text)
	local l = label(self.Frame, text, { Size = 12, Role = "SubText", Box = UDim2.new(1, 0, 0, 18) })
	l.LayoutOrder = nextOrder(self.Frame)
	l.TextWrapped = true
	l.AutomaticSize = Enum.AutomaticSize.Y
	indexItem(self, l, text)
	return l
end

function Section:AddCard(o)
	o = o or {}
	local f = make("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BorderSizePixel = 0, LayoutOrder = nextOrder(self.Frame), Parent = self.Frame })
	bind(f, "BackgroundColor3", "Element")
	f.BackgroundTransparency = 1 - State.Opacity
	table.insert(glassList, f)
	round(f, 8)
	local st = outline(f, "Stroke")
	st.Transparency = 0.55
	local bar = make("Frame", { Size = UDim2.new(0, 3, 1, -16), Position = UDim2.fromOffset(8, 8), BorderSizePixel = 0, BackgroundColor3 = WHITE, Parent = f })
	pill(bar)
	if o.Color then bar.BackgroundColor3 = o.Color else accentGradient(bar, 90) end
	local inner = make("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = f })
	make("UIPadding", { PaddingTop = UDim.new(0, 9), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 22), PaddingRight = UDim.new(0, 10), Parent = inner })
	make("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = inner })
	local title = label(inner, o.Title or "", { Font = BOLD, Size = 15, Box = UDim2.new(1, 0, 0, 20) })
	title.LayoutOrder = 1
	local body = label(inner, o.Body or o.Content or "", { Size = 12, Role = "SubText", Wrap = true, Box = UDim2.new(1, 0, 0, 0), Auto = Enum.AutomaticSize.Y })
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

function Section:AddDivider(text)
	local f = make("Frame", { Size = UDim2.new(1, 0, 0, text and 18 or 9), BackgroundTransparency = 1, LayoutOrder = nextOrder(self.Frame), Parent = self.Frame })
	local function line(size, pos)
		local l = make("Frame", { Size = size, Position = pos, AnchorPoint = Vector2.new(0, 0.5), BorderSizePixel = 0, Parent = f })
		bind(l, "BackgroundColor3", "Stroke")
		return l
	end
	if text then
		label(f, string.upper(text), { Font = BOLD, Size = 10, Role = "SubText", AlignX = Enum.TextXAlignment.Center })
		line(UDim2.new(0.26, 0, 0, 1), UDim2.new(0, 0, 0.5, 0))
		line(UDim2.new(0.26, 0, 0, 1), UDim2.new(0.74, 0, 0.5, 0))
	else
		line(UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 0.5, 0))
	end
	indexItem(self, f, text)
	return f
end

function Section:AddButton(o)
	local f = card(self.Frame, o.Desc and 48 or 36)
	label(f, o.Name, { Box = UDim2.new(1, -44, 0, 18), Pos = UDim2.fromOffset(12, o.Desc and 7 or 9) })
	if o.Desc then label(f, o.Desc, { Box = UDim2.new(1, -44, 0, 14), Pos = UDim2.fromOffset(12, 26), Size = 11, Role = "SubText" }) end
	local arrow = label(f, ">", { Font = BOLD, Size = 13, Role = "SubText", AlignX = Enum.TextXAlignment.Center, Box = UDim2.fromOffset(20, 20), Pos = UDim2.new(1, -30, 0.5, -10) })
	local hit = make("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 3, Parent = f })
	hover(hit, f)
	hit.MouseEnter:Connect(function() tween(arrow, { Position = UDim2.new(1, -26, 0.5, -10), TextColor3 = C("Accent") }) end)
	hit.MouseLeave:Connect(function() tween(arrow, { Position = UDim2.new(1, -30, 0.5, -10), TextColor3 = C("SubText") }) end)
	hit.MouseButton1Click:Connect(function()
		ripple(f)
		if o.Callback then task.spawn(o.Callback) end
	end)
	indexItem(self, f, (o.Name or "") .. " " .. (o.Desc or ""))
	return { Fire = function() if o.Callback then task.spawn(o.Callback) end end }
end

function Section:AddToggle(o)
	local state = o.Default == true
	local f = card(self.Frame, o.Desc and 48 or 36)
	label(f, o.Name, { Box = UDim2.new(1, -66, 0, 18), Pos = UDim2.fromOffset(12, o.Desc and 7 or 9) })
	if o.Desc then label(f, o.Desc, { Box = UDim2.new(1, -66, 0, 14), Pos = UDim2.fromOffset(12, 26), Size = 11, Role = "SubText" }) end
	local trackF = make("Frame", { Size = UDim2.fromOffset(40, 20), Position = UDim2.new(1, -52, 0.5, -10), BorderSizePixel = 0, Parent = f })
	pill(trackF)
	local tg = accentGradient(trackF, 0)
	local knob = make("Frame", {
		Size = UDim2.fromOffset(16, 16), AnchorPoint = Vector2.new(0, 0.5), BorderSizePixel = 0, BackgroundColor3 = c(250, 250, 252),
		Position = state and UDim2.new(0, 22, 0.5, 0) or UDim2.new(0, 2, 0.5, 0), ZIndex = 2, Parent = trackF,
	})
	pill(knob)
	make("UIStroke", { Color = c(0, 0, 0), Transparency = 0.8, Thickness = 1, Parent = knob })
	local function paint(t)
		tg.Enabled = state
		tween(trackF, { BackgroundColor3 = state and WHITE or C("Stroke") }, t)
	end
	reg(paint)

	local obj = {}
	function obj.Set(v, silent)
		state = v and true or false
		paint()
		tween(knob, { Size = UDim2.fromOffset(16, 16), Position = state and UDim2.new(0, 22, 0.5, 0) or UDim2.new(0, 2, 0.5, 0) }, BACK)
		if not silent and o.Callback then task.spawn(o.Callback, state) end
	end
	function obj.Get() return state end

	local hit = make("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 3, Parent = f })
	hover(hit, f)
	hit.MouseButton1Down:Connect(function()
		tween(knob, { Size = UDim2.fromOffset(20, 16), Position = state and UDim2.new(0, 18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0) }, FAST)
	end)
	hit.MouseLeave:Connect(function()
		tween(knob, { Size = UDim2.fromOffset(16, 16), Position = state and UDim2.new(0, 22, 0.5, 0) or UDim2.new(0, 2, 0.5, 0) }, FAST)
	end)
	hit.MouseButton1Click:Connect(function()
		ripple(f)
		obj.Set(not state)
	end)
	indexItem(self, f, (o.Name or "") .. " " .. (o.Desc or ""))
	return obj
end

function Section:AddSlider(o)
	local min, max, step = o.Min or 0, o.Max or 100, o.Step or 1
	if max <= min then max = min + 1 end
	local value = math.clamp(o.Default or min, min, max)
	local f = card(self.Frame, 54)
	f.ClipsDescendants = false
	label(f, o.Name, { Box = UDim2.new(1, -92, 0, 20), Pos = UDim2.fromOffset(12, 6) })
	local val = make("TextBox", {
		Size = UDim2.fromOffset(58, 20), Position = UDim2.new(1, -70, 0, 6), Text = "", Font = BOLD, TextSize = 12,
		ClearTextOnFocus = false, BorderSizePixel = 0, Parent = f,
	})
	bind(val, "BackgroundColor3", "Background")
	bind(val, "TextColor3", "Accent")
	round(val, 5)
	local vs = outline(val, "Stroke")
	vs.Transparency = 0.5
	local tr = make("Frame", { Size = UDim2.new(1, -24, 0, 6), Position = UDim2.fromOffset(12, 38), BorderSizePixel = 0, Parent = f })
	pill(tr)
	bind(tr, "BackgroundColor3", "Stroke")
	local fill = make("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, BackgroundColor3 = WHITE, Parent = tr })
	pill(fill)
	accentGradient(fill, 0)
	local knob = make("Frame", { Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(1, 0.5), BorderSizePixel = 0, BackgroundColor3 = WHITE, ZIndex = 2, Parent = fill })
	pill(knob)
	outline(knob, "Accent", 2)
	local knobScale = make("UIScale", { Parent = knob })

	local obj = {}
	local function render()
		fill.Size = UDim2.fromScale((value - min) / (max - min), 1)
		if not val:IsFocused() then val.Text = string.format("%g", value) .. (o.Suffix or "") end
	end
	function obj.Set(v, silent)
		v = math.clamp(math.floor((v - min) / step + 0.5) * step + min, min, max)
		value = tonumber(string.format("%.4f", v))
		render()
		if not silent and o.Callback then o.Callback(value) end
	end
	function obj.Get() return value end
	render()

	val.Focused:Connect(function()
		tween(vs, { Color = C("Accent"), Transparency = 0 })
		val.Text = string.format("%g", value)
	end)
	val.FocusLost:Connect(function()
		tween(vs, { Color = C("Stroke"), Transparency = 0.5 })
		local n = tonumber((val.Text:match("%-?[%d%.]+")))
		if n then obj.Set(n) end
		val.Text = string.format("%g", value) .. (o.Suffix or "")
	end)

	local dragging = false
	local function fromX(x)
		local a = math.clamp((x - tr.AbsolutePosition.X) / math.max(1, tr.AbsoluteSize.X), 0, 1)
		obj.Set(min + (max - min) * a)
	end
	local hit = make("TextButton", { Size = UDim2.new(1, 0, 0, 28), Position = UDim2.fromOffset(0, 26), BackgroundTransparency = 1, Text = "", ZIndex = 3, Parent = f })
	hover(hit, f)
	hit.InputBegan:Connect(function(i)
		if isPress(i) then
			dragging = true
			tween(knobScale, { Scale = 1.45 }, BACK)
			fromX(i.Position.X)
		end
	end)
	connect(UserInputService.InputChanged, function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then fromX(i.Position.X) end
	end)
	connect(UserInputService.InputEnded, function(i)
		if isPress(i) and dragging then
			dragging = false
			tween(knobScale, { Scale = 1 }, BACK)
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

	local container = make("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = nextOrder(self.Frame), Parent = self.Frame })
	make("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = container })

	local head = card(container, 36)
	head.LayoutOrder = 1
	if o.Name then label(head, o.Name, { Box = UDim2.new(0.5, -12, 1, 0), Pos = UDim2.fromOffset(12, 0) }) end
	local valLabel = label(head, "", {
		Box = o.Name and UDim2.new(0.5, -38, 1, 0) or UDim2.new(1, -52, 1, 0),
		Pos = o.Name and UDim2.new(0.5, 0, 0, 0) or UDim2.fromOffset(12, 0),
		AlignX = o.Name and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left, Role = "Accent", Size = 12,
	})
	valLabel.TextTruncate = Enum.TextTruncate.AtEnd
	local chev = label(head, ">", { Box = UDim2.fromOffset(20, 36), Pos = UDim2.new(1, -30, 0, 0), AlignX = Enum.TextXAlignment.Center, Font = BOLD, Role = "SubText", Size = 13 })
	chev.Rotation = 90
	local hit = make("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 3, Parent = head })
	hover(hit, head)

	local searchable = o.Search == true
	local panel = make("Frame", { Size = UDim2.new(1, 0, 0, 0), Visible = false, BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = 2, Parent = container })
	bind(panel, "BackgroundColor3", "Surface")
	outline(panel)
	round(panel, 8)

	local box
	if searchable then
		box = make("TextBox", {
			Size = UDim2.new(1, -16, 0, 26), Position = UDim2.fromOffset(8, 7), Text = "", PlaceholderText = "Search...",
			ClearTextOnFocus = false, Font = FONT, TextSize = 12, BorderSizePixel = 0, TextXAlignment = Enum.TextXAlignment.Left, Parent = panel,
		})
		make("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = box })
		bind(box, "BackgroundColor3", "Background")
		bind(box, "TextColor3", "Text")
		bind(box, "PlaceholderColor3", "SubText")
		round(box, 6)
		local bs = outline(box, "Stroke")
		box.Focused:Connect(function() tween(bs, { Color = C("Accent") }) end)
		box.FocusLost:Connect(function() tween(bs, { Color = C("Stroke") }) end)
	end

	local list = make("ScrollingFrame", {
		Size = UDim2.new(1, -16, 0, 0), Position = UDim2.fromOffset(8, 6), BackgroundTransparency = 1, BorderSizePixel = 0,
		ScrollBarThickness = 2, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = panel,
	})
	bind(list, "ScrollBarImageColor3", "Accent")
	make("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list })

	local function dims()
		local listH = math.min(math.max(#options, 1) * 28 + 4, 150)
		local top = searchable and 40 or 6
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
		tween(r.b, { BackgroundTransparency = sel and 0.85 or (r.hov and 0.5 or 1), BackgroundColor3 = sel and C("Accent") or C("Hover") }, t)
		tween(r.l, { TextColor3 = sel and C("Accent") or (r.hov and C("Text") or C("SubText")) }, t)
		tween(r.bar, { BackgroundTransparency = sel and 0 or 1 }, t)
	end

	local setOpen
	local function render()
		for _, r in ipairs(rowsD) do r.b:Destroy() end
		table.clear(rowsD)
		local q = box and box.Text:lower() or ""
		for i, opt in ipairs(options) do
			local s = tostring(opt)
			if q == "" or s:lower():find(q, 1, true) then
				local b = make("TextButton", { Size = UDim2.new(1, 0, 0, 26), Text = "", AutoButtonColor = false, BorderSizePixel = 0, BackgroundTransparency = 1, LayoutOrder = i, Parent = list })
				make("UICorner", { CornerRadius = UDim.new(0, 6), Parent = b })
				local bar = make("Frame", { Size = UDim2.fromOffset(3, 14), Position = UDim2.new(0, 4, 0.5, -7), BorderSizePixel = 0, BackgroundTransparency = 1, Parent = b })
				pill(bar)
				local l = make("TextLabel", {
					Size = UDim2.new(1, -20, 1, 0), Position = UDim2.fromOffset(14, 0), BackgroundTransparency = 1, Text = s,
					Font = FONT, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = b,
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
		tween(chev, { Rotation = v and -90 or 90 }, BACK)
		local listH, top, fullH = dims()
		list.Size = UDim2.new(1, -16, 0, listH)
		list.Position = UDim2.fromOffset(8, top)
		if v then
			render()
			panel.Visible = true
			panel.Size = UDim2.new(1, 0, 0, 0)
			tween(panel, { Size = UDim2.new(1, 0, 0, fullH) }, SMOOTH)
		else
			tween(panel, { Size = UDim2.new(1, 0, 0, 0) }, FAST)
			task.delay(0.16, function() if not open then panel.Visible = false end end)
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
			list.Size = UDim2.new(1, -16, 0, listH)
			list.Position = UDim2.fromOffset(8, top)
			tween(panel, { Size = UDim2.new(1, 0, 0, fullH) }, SLOW)
		end
	end
	obj._changed(true)

	if box then box:GetPropertyChangedSignal("Text"):Connect(function() if open then render() end end) end
	reg(function(t) if open then for _, r in ipairs(rowsD) do pcall(paintRow, r, t) end end end)
	hit.MouseButton1Click:Connect(function() setOpen(not open) end)
	indexItem(self, container, o.Name)
	return obj
end

function Section:AddColorPicker(o)
	local h, s, v = (o.Default or c(255, 255, 255)):ToHSV()
	local open = false
	local obj = {}
	local PH = 166

	local container = make("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = nextOrder(self.Frame), Parent = self.Frame })
	make("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = container })

	local head = card(container, 36)
	head.LayoutOrder = 1
	label(head, o.Name, { Box = UDim2.new(1, -60, 1, 0), Pos = UDim2.fromOffset(12, 0) })
	local swatch = make("Frame", { Size = UDim2.fromOffset(28, 18), Position = UDim2.new(1, -40, 0.5, -9), BorderSizePixel = 0, BackgroundColor3 = Color3.fromHSV(h, s, v), Parent = head })
	round(swatch, 5)
	outline(swatch, "Stroke")
	local hit = make("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 3, Parent = head })
	hover(hit, head)

	local panel = make("Frame", { Size = UDim2.new(1, 0, 0, PH), Visible = false, BorderSizePixel = 0, ClipsDescendants = true, LayoutOrder = 2, Parent = container })
	bind(panel, "BackgroundColor3", "Surface")
	outline(panel)
	round(panel, 8)

	local sv = make("Frame", { Size = UDim2.new(1, -44, 0, 114), Position = UDim2.fromOffset(10, 10), BorderSizePixel = 0, BackgroundColor3 = Color3.fromHSV(h, 1, 1), Parent = panel })
	make("UICorner", { CornerRadius = UDim.new(0, 6), Parent = sv })
	make("Frame", {
		Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, BackgroundColor3 = c(255, 255, 255), Parent = sv,
	}, { make("UICorner", { CornerRadius = UDim.new(0, 6) }), make("UIGradient", { Transparency = NumberSequence.new(0, 1) }) })
	make("Frame", {
		Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, BackgroundColor3 = c(0, 0, 0), Parent = sv,
	}, { make("UICorner", { CornerRadius = UDim.new(0, 6) }), make("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0) }) })
	local svCursor = make("Frame", { Size = UDim2.fromOffset(12, 12), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, ZIndex = 3, Parent = sv })
	pill(svCursor)
	make("UIStroke", { Color = c(255, 255, 255), Thickness = 2, Parent = svCursor })

	local hue = make("Frame", { Size = UDim2.fromOffset(18, 114), Position = UDim2.new(1, -28, 0, 10), BorderSizePixel = 0, BackgroundColor3 = c(255, 255, 255), Parent = panel })
	make("UICorner", { CornerRadius = UDim.new(0, 6), Parent = hue })
	make("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new({
			ckp(0, c(255, 0, 0)), ckp(0.17, c(255, 255, 0)), ckp(0.33, c(0, 255, 0)), ckp(0.5, c(0, 255, 255)),
			ckp(0.67, c(0, 0, 255)), ckp(0.83, c(255, 0, 255)), ckp(1, c(255, 0, 0)),
		}),
		Parent = hue,
	})
	local hueCursor = make("Frame", { Size = UDim2.new(1, 6, 0, 4), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = c(255, 255, 255), BorderSizePixel = 0, ZIndex = 3, Parent = hue })
	make("UICorner", { CornerRadius = UDim.new(0, 2), Parent = hueCursor })
	make("UIStroke", { Color = c(0, 0, 0), Thickness = 1, Transparency = 0.4, Parent = hueCursor })

	local hex = make("TextBox", {
		Size = UDim2.new(1, -20, 0, 24), Position = UDim2.fromOffset(10, 132), Text = "", PlaceholderText = "#FFFFFF",
		ClearTextOnFocus = false, Font = BOLD, TextSize = 12, BorderSizePixel = 0, Parent = panel,
	})
	bind(hex, "BackgroundColor3", "Background")
	bind(hex, "TextColor3", "Text")
	bind(hex, "PlaceholderColor3", "SubText")
	round(hex, 6)
	local hs = outline(hex, "Stroke")

	local function apply(silent)
		local col = Color3.fromHSV(h, s, v)
		swatch.BackgroundColor3 = col
		sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
		svCursor.Position = UDim2.fromScale(s, 1 - v)
		hueCursor.Position = UDim2.fromScale(0.5, h)
		if not hex:IsFocused() then hex.Text = "#" .. string.upper(col:ToHex()) end
		if not silent and o.Callback then o.Callback(col) end
	end
	apply(true)

	hex.Focused:Connect(function() tween(hs, { Color = C("Accent") }) end)
	hex.FocusLost:Connect(function()
		tween(hs, { Color = C("Stroke") })
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
		s = math.clamp((pos.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
		v = 1 - math.clamp((pos.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
		apply()
	end
	local function updH(pos)
		h = math.clamp((pos.Y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 0.999)
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
		open = not open
		if open then
			panel.Visible = true
			panel.Size = UDim2.new(1, 0, 0, 0)
			tween(panel, { Size = UDim2.new(1, 0, 0, PH) }, SMOOTH)
		else
			tween(panel, { Size = UDim2.new(1, 0, 0, 0) }, FAST)
			task.delay(0.16, function() if not open then panel.Visible = false end end)
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
	local f = card(self.Frame, 36)
	label(f, o.Name, { Box = UDim2.new(0.5, -12, 1, 0), Pos = UDim2.fromOffset(12, 0) })
	local box = make("TextBox", {
		Size = UDim2.new(0.5, -18, 0, 24), Position = UDim2.new(0.5, 6, 0.5, -12), Text = o.Default or "", PlaceholderText = o.Placeholder or "",
		ClearTextOnFocus = false, Font = FONT, TextSize = 12, BorderSizePixel = 0, ClipsDescendants = true, Parent = f,
	})
	bind(box, "BackgroundColor3", "Background")
	bind(box, "TextColor3", "Text")
	bind(box, "PlaceholderColor3", "SubText")
	round(box, 6)
	local bs = outline(box, "Stroke")
	box.Focused:Connect(function() tween(bs, { Color = C("Accent") }) end)
	if o.MaxLength then
		box:GetPropertyChangedSignal("Text"):Connect(function()
			if #box.Text > o.MaxLength then box.Text = box.Text:sub(1, o.MaxLength) end
		end)
	end
	box.FocusLost:Connect(function()
		tween(bs, { Color = C("Stroke") })
		if o.Callback then o.Callback(box.Text) end
	end)
	indexItem(self, f, o.Name)
	return { Set = function(t) box.Text = t end, Get = function() return box.Text end }
end

function Section:AddKeybind(o)
	local key = o.Default or Enum.KeyCode.RightShift
	local f = card(self.Frame, 36)
	label(f, o.Name, { Box = UDim2.new(1, -110, 1, 0), Pos = UDim2.fromOffset(12, 0) })
	local b = make("TextButton", {
		Size = UDim2.fromOffset(86, 24), Position = UDim2.new(1, -98, 0.5, -12), Text = key.Name, Font = BOLD, TextSize = 12,
		AutoButtonColor = false, BorderSizePixel = 0, Parent = f,
	})
	bind(b, "BackgroundColor3", "Background")
	bind(b, "TextColor3", "Accent")
	round(b, 6)
	local bs = outline(b, "Stroke")
	local listening = false
	b.MouseButton1Click:Connect(function()
		listening = true
		State.Listening = true
		b.Text = "press a key"
		tween(bs, { Color = C("Accent") })
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
		tween(bs, { Color = C("Stroke") })
	end)
	indexItem(self, f, o.Name)
	return {
		Set = function(k) key = k; b.Text = k.Name end,
		Get = function() return key end,
	}
end

function Section:AddProgress(o)
	o = o or {}
	local max = o.Max or 100
	local value = math.clamp(o.Default or 0, 0, max)
	local f = card(self.Frame, 46)
	label(f, o.Name or "Progress", { Box = UDim2.new(1, -80, 0, 20), Pos = UDim2.fromOffset(12, 5) })
	local val = label(f, "", { Box = UDim2.fromOffset(60, 20), Pos = UDim2.new(1, -72, 0, 5), AlignX = Enum.TextXAlignment.Right, Role = "SubText", Size = 12 })
	local tr = make("Frame", { Size = UDim2.new(1, -24, 0, 6), Position = UDim2.fromOffset(12, 30), BorderSizePixel = 0, Parent = f })
	pill(tr)
	bind(tr, "BackgroundColor3", "Stroke")
	local fill = make("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, BackgroundColor3 = WHITE, Parent = tr })
	pill(fill)
	accentGradient(fill, 0)
	local obj = {}
	function obj.Set(x)
		value = math.clamp(tonumber(x) or 0, 0, max)
		tween(fill, { Size = UDim2.fromScale(value / max, 1) }, SMOOTH)
		val.Text = (o.Percent ~= false) and (math.floor(value / max * 100 + 0.5) .. "%") or string.format("%g / %g", value, max)
	end
	function obj.Get() return value end
	obj.Set(value)
	indexItem(self, f, o.Name)
	return obj
end

function Section:AddThemeGallery(o)
	o = o or {}
	local wrap = make("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = nextOrder(self.Frame), Parent = self.Frame })
	make("UIGridLayout", { CellSize = UDim2.new(1 / 3, -4, 0, 44), CellPadding = UDim2.fromOffset(6, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = wrap })
	local tiles = {}
	for i, name in ipairs(ThemeNames) do
		local th = Themes[name]
		if th then
			local t = make("TextButton", { Text = "", AutoButtonColor = false, BackgroundColor3 = th.Background or c(20, 20, 24), BorderSizePixel = 0, LayoutOrder = i, Parent = wrap })
			make("UICorner", { CornerRadius = UDim.new(0, 7), Parent = t })
			local st = make("UIStroke", { Thickness = 1, Color = th.Stroke or c(60, 60, 70), ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = t })
			local strip = make("Frame", { Size = UDim2.new(1, -12, 0, 5), Position = UDim2.fromOffset(6, 7), BorderSizePixel = 0, BackgroundColor3 = WHITE, Parent = t })
			pill(strip)
			local a = th.Accent or c(255, 255, 255)
			make("UIGradient", { Color = ColorSequence.new(a, th.Accent2 or shiftHue(a, 0.09)), Parent = strip })
			make("TextLabel", {
				Size = UDim2.new(1, -10, 0, 16), Position = UDim2.fromOffset(6, 20), BackgroundTransparency = 1, Text = name,
				Font = BOLD, TextSize = 11, TextColor3 = th.Text or WHITE, TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd, Parent = t,
			})
			local sc = make("UIScale", { Parent = t })
			t.MouseEnter:Connect(function() tween(sc, { Scale = 1.06 }, BACK) end)
			t.MouseLeave:Connect(function() tween(sc, { Scale = 1 }, BACK) end)
			t.MouseButton1Click:Connect(function()
				sc.Scale = 0.92
				tween(sc, { Scale = 1.06 }, BACK)
				if o.Callback then o.Callback(name) end
			end)
			tiles[name] = { st = st, base = th.Stroke or c(60, 60, 70) }
		end
	end
	reg(function()
		for name, e in pairs(tiles) do
			local sel = name == State.Theme
			e.st.Thickness = sel and 2 or 1
			e.st.Color = sel and C("Accent") or e.base
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

local KindColor = { Success = c(70, 220, 140), Warning = c(255, 200, 70), Error = c(255, 90, 90) }
local KindGlyph = { Info = "i", Success = "✓", Warning = "!", Error = "×" }

function Lib:CreateWindow(cfg)
	cfg = cfg or {}
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

	-- saved look
	local L = UI.look
	if L.theme ~= "" and Themes[L.theme] then State.Theme = L.theme
	elseif cfg.Theme and Themes[cfg.Theme] then State.Theme = cfg.Theme end
	State.Opacity = math.clamp(L.opacity, 0.2, 1)
	State.Rounding = math.clamp(L.rounding, 0, 2)
	State.Scale = math.clamp(L.scale, 0.4, 2)
	if L.customAccent and L.accent ~= "" then
		local ok, col = pcall(Color3.fromHex, L.accent)
		if ok and col then State.BaseAccent = col; State.Accent = col end
	else
		State.BaseAccent, State.Accent = nil, nil
	end

	local key = cfg.Key or Enum.KeyCode.RightShift
	local letter = cfg.Letter or "S"
	local title = cfg.Title or "S Hub"
	local W, H = IsMobile and 600 or 760, IsMobile and 360 or 480
	local visible, alive = true, true
	local Window = {}
	local themeHooks = {}

	local function baseScale() return State.Scale * fit(W, H) end

	local gui = make("ScreenGui", { Name = "SHub", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 100, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = PlayerGui })
	Window.Gui = gui

	local blur = make("BlurEffect", { Name = "SHubBlur", Size = 0, Enabled = true, Parent = Lighting })
	table.insert(Registry.extra, blur)

	----------------------------------------------------------------- frame
	local holder = make("Frame", { Name = "Holder", Size = UDim2.fromOffset(W, H), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 1, ZIndex = 2, Parent = gui })
	local scaler = make("UIScale", { Scale = baseScale() * 0.9, Parent = holder })

	local glowImg = make("ImageLabel", {
		Name = "Glow", Image = "rbxassetid://6015897843", ImageTransparency = 1, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450),
		Size = UDim2.new(1, 120, 1, 120), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 1, ZIndex = 0, Parent = holder,
	})
	bind(glowImg, "ImageColor3", "Accent")
	local shadow = make("ImageLabel", {
		Name = "Shadow", Image = "rbxassetid://6015897843", ImageColor3 = c(0, 0, 0), ImageTransparency = 1, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450),
		Size = UDim2.new(1, 64, 1, 64), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 6), BackgroundTransparency = 1, ZIndex = 0, Parent = holder,
	})

	local body = make("CanvasGroup", { Name = "Body", Size = UDim2.fromScale(1, 1), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BorderSizePixel = 0, GroupTransparency = 1, ZIndex = 1, Parent = holder })
	bind(body, "BackgroundColor3", "Background")
	table.insert(glassList, body)
	round(body, 14)

	local border = make("Frame", { Name = "Border", Size = UDim2.fromScale(1, 1), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 1, ZIndex = 3, Parent = holder })
	round(border, 14)
	local borderStroke = spinStroke(border, 1.6)
	borderStroke.Transparency = 1

	-- ambient gradient wash inside the window
	local wash = make("Frame", { Name = "Wash", Size = UDim2.fromScale(1, 1), BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 0, Parent = body })
	round(wash, 14)
	local washGrad = accentGradient(wash, 35)
	washGrad.Transparency = NumberSequence.new({ kp(0, 0.84), kp(0.45, 0.97), kp(1, 1) })
	wash.Visible = UI.look.glow

	local function extras(show, info)
		tween(shadow, { ImageTransparency = show and 0.4 or 1 }, info)
		tween(glowImg, { ImageTransparency = (show and UI.look.glow) and 0.82 or 1 }, info)
		tween(borderStroke, { Transparency = show and 0 or 1 }, info)
		tween(blur, { Size = (show and UI.look.blur) and 14 or 0 }, info)
	end

	local launcher, launchScale
	local function setVisible(v)
		visible = v
		if v then
			holder.Visible = true
			launcher.Visible = false
			scaler.Scale = baseScale() * 0.9
			tween(scaler, { Scale = baseScale() }, BACK)
			tween(body, { GroupTransparency = 0 }, SLOW)
			extras(true, SLOW)
		else
			tween(scaler, { Scale = baseScale() * 0.9 }, FAST)
			tween(body, { GroupTransparency = 1 }, FAST)
			extras(false, FAST)
			task.delay(0.17, function()
				if alive and not visible then
					holder.Visible = false
					launcher.Visible = true
					launchScale.Scale = 0.3
					tween(launchScale, { Scale = 1 }, BACK)
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
	local top = make("Frame", { Size = UDim2.new(1, 0, 0, 56), BackgroundTransparency = 1, Parent = body })
	local logo, logoText = logoTile(top, 34, 10, letter, cfg.Image, UDim2.fromOffset(14, 11), 19)
	local titleL = label(top, title, { Font = BOLD, Size = 16, Box = UDim2.fromOffset(220, 20), Pos = UDim2.fromOffset(58, 10) })
	titleL.TextTruncate = Enum.TextTruncate.AtEnd
	local subL = label(top, cfg.Subtitle or "Universal", { Size = 11, Role = "SubText", Box = UDim2.fromOffset(220, 14), Pos = UDim2.fromOffset(58, 31) })
	subL.TextTruncate = Enum.TextTruncate.AtEnd

	local topLine = make("Frame", { Size = UDim2.new(1, -28, 0, 1), Position = UDim2.fromOffset(14, 56), BorderSizePixel = 0, BackgroundColor3 = WHITE, Parent = body })
	local tlg = accentGradient(topLine, 0)
	tlg.Transparency = NumberSequence.new({ kp(0, 1), kp(0.25, 0.35), kp(0.75, 0.35), kp(1, 1) })

	-- search box
	local searchW = IsMobile and 150 or 190
	local search = make("Frame", { Size = UDim2.fromOffset(searchW, 30), Position = UDim2.new(1, -(searchW + 126), 0, 13), BorderSizePixel = 0, Parent = top })
	bind(search, "BackgroundColor3", "Element")
	round(search, 8)
	local searchStroke = outline(search, "Stroke")
	searchStroke.Transparency = 0.4
	local glass = make("Frame", { Size = UDim2.fromOffset(9, 9), Position = UDim2.fromOffset(10, 9), BackgroundTransparency = 1, Parent = search })
	pill(glass)
	outline(glass, "SubText", 1.5)
	local handle = make("Frame", { Size = UDim2.fromOffset(2, 5), Position = UDim2.fromOffset(19, 17), Rotation = -45, BorderSizePixel = 0, Parent = search })
	bind(handle, "BackgroundColor3", "SubText")
	local sBox = make("TextBox", {
		Size = UDim2.new(1, -36, 1, 0), Position = UDim2.fromOffset(30, 0), BackgroundTransparency = 1, Text = "", PlaceholderText = "Search...",
		ClearTextOnFocus = false, Font = FONT, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ClipsDescendants = true, Parent = search,
	})
	bind(sBox, "TextColor3", "Text")
	bind(sBox, "PlaceholderColor3", "SubText")
	sBox.Focused:Connect(function() tween(searchStroke, { Color = C("Accent"), Transparency = 0 }) end)
	sBox.FocusLost:Connect(function() tween(searchStroke, { Color = C("Stroke"), Transparency = 0.4 }) end)

	local function winBtn(x, draw, cb, danger)
		local b = make("TextButton", { Size = UDim2.fromOffset(30, 30), Position = UDim2.new(1, x, 0, 13), Text = "", AutoButtonColor = false, BorderSizePixel = 0, Parent = top })
		bind(b, "BackgroundColor3", "Element")
		round(b, 8)
		local st = outline(b, "Stroke")
		st.Transparency = 0.4
		local icons = draw(b)
		local sc = make("UIScale", { Parent = b })
		b.MouseEnter:Connect(function()
			tween(b, { BackgroundColor3 = danger and c(220, 64, 80) or C("Hover") })
			tween(sc, { Scale = 1.1 }, BACK)
			if danger then for _, ic in ipairs(icons) do tween(ic, { BackgroundColor3 = WHITE }) end end
		end)
		b.MouseLeave:Connect(function()
			tween(b, { BackgroundColor3 = C("Element") })
			tween(sc, { Scale = 1 }, BACK)
			for _, ic in ipairs(icons) do tween(ic, { BackgroundColor3 = C("Text") }) end
		end)
		b.MouseButton1Down:Connect(function() tween(sc, { Scale = 0.9 }, FAST) end)
		b.MouseButton1Up:Connect(function() tween(sc, { Scale = 1.1 }, BACK) end)
		b.MouseButton1Click:Connect(cb)
		return b
	end
	local function bar(parent, w, rot)
		local f = make("Frame", { Size = UDim2.fromOffset(w, 2), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Rotation = rot or 0, BorderSizePixel = 0, Parent = parent })
		pill(f)
		bind(f, "BackgroundColor3", "Text")
		return f
	end

	----------------------------------------------------------------- dialog
	function Window:Dialog(o)
		o = o or {}
		local overlay = make("TextButton", { Name = "Dialog", Text = "", AutoButtonColor = false, Size = UDim2.fromScale(1, 1), BackgroundColor3 = c(0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 50, Parent = body })
		round(overlay, 14)
		local box = make("CanvasGroup", { Size = UDim2.fromOffset(330, 0), AutomaticSize = Enum.AutomaticSize.Y, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BorderSizePixel = 0, GroupTransparency = 1, ZIndex = 51, Parent = overlay })
		bind(box, "BackgroundColor3", "Surface")
		round(box, 12)
		outline(box, "Stroke")
		local bs = make("UIScale", { Scale = 0.9, Parent = box })
		local inner = make("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = box })
		make("UIPadding", { PaddingTop = UDim.new(0, 16), PaddingBottom = UDim.new(0, 16), PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18), Parent = inner })
		make("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = inner })
		local tl = label(inner, o.Title or "Are you sure?", { Font = BOLD, Size = 16, Box = UDim2.new(1, 0, 0, 22) })
		tl.LayoutOrder = 1
		local cl = label(inner, o.Content or "", { Size = 12, Role = "SubText", Wrap = true, Box = UDim2.new(1, 0, 0, 0), Auto = Enum.AutomaticSize.Y })
		cl.LayoutOrder = 2
		local row = make("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, LayoutOrder = 3, Parent = inner })
		make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = row })

		local closed = false
		local function close()
			if closed then return end
			closed = true
			tween(overlay, { BackgroundTransparency = 1 })
			tween(box, { GroupTransparency = 1 })
			tween(bs, { Scale = 0.9 })
			task.delay(0.2, function() overlay:Destroy() end)
		end
		for i, b in ipairs(o.Buttons or { { Title = "OK" } }) do
			local btn = make("TextButton", { Size = UDim2.fromOffset(92, 32), Text = "", AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = i, Parent = row })
			round(btn, 8)
			local bl = label(btn, b.Title or "OK", { Font = BOLD, Size = 13, AlignX = Enum.TextXAlignment.Center, Role = b.Primary and false or "Text", Z = 2 })
			if b.Primary then
				btn.BackgroundColor3 = WHITE
				accentGradient(btn, 0)
				reg(function(t) tween(bl, { TextColor3 = onAccent() }, t) end)
			else
				bind(btn, "BackgroundColor3", "Element")
				outline(btn, "Stroke")
			end
			local sc = make("UIScale", { Parent = btn })
			btn.MouseEnter:Connect(function() tween(sc, { Scale = 1.05 }, BACK) end)
			btn.MouseLeave:Connect(function() tween(sc, { Scale = 1 }, BACK) end)
			btn.MouseButton1Click:Connect(function()
				close()
				if b.Callback then task.spawn(b.Callback) end
			end)
		end
		tween(overlay, { BackgroundTransparency = 0.45 })
		tween(box, { GroupTransparency = 0 }, SLOW)
		tween(bs, { Scale = 1 }, BACK)
		return { Close = close }
	end

	local function askClose()
		if cfg.ConfirmClose == false then return destroy() end
		Window:Dialog({
			Title = "Close " .. title .. "?",
			Content = "This unloads the hub and turns off every active feature.",
			Buttons = { { Title = "Cancel" }, { Title = "Close", Primary = true, Callback = destroy } },
		})
	end

	winBtn(-42, function(b) return { bar(b, 14, 45), bar(b, 14, -45) } end, askClose, true)
	winBtn(-78, function(b) return { bar(b, 12, 0) } end, function() setVisible(false) end)
	winBtn(-114, function(b)
		local ring = make("Frame", { Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 1, Parent = b })
		pill(ring)
		outline(ring, "Text", 1.5)
		local dot = make("Frame", { Size = UDim2.fromOffset(7, 7), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BackgroundColor3 = WHITE, BorderSizePixel = 0, Parent = b })
		pill(dot)
		accentGradient(dot, 45)
		return {}
	end, function()
		local idx = table.find(ThemeNames, State.Theme) or 0
		Window:SetTheme(ThemeNames[idx % #ThemeNames + 1])
	end)
	makeDraggable(top, holder)

	----------------------------------------------------------------- sidebar
	local side = make("Frame", { Size = UDim2.new(0, 156, 1, -74), Position = UDim2.fromOffset(10, 64), BorderSizePixel = 0, Parent = body })
	bind(side, "BackgroundColor3", "Surface")
	side.BackgroundTransparency = 0.25
	round(side, 10)
	local sideStroke = outline(side, "Stroke")
	sideStroke.Transparency = 0.5

	local tabsFrame = make("ScrollingFrame", {
		Size = UDim2.new(1, -12, 1, -78), Position = UDim2.fromOffset(6, 6), BackgroundTransparency = 1, BorderSizePixel = 0,
		ScrollBarThickness = 2, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y, ElasticBehavior = Enum.ElasticBehavior.Never, Parent = side,
	})
	bind(tabsFrame, "ScrollBarImageColor3", "Accent")
	make("UIPadding", { PaddingRight = UDim.new(0, 4), Parent = tabsFrame })
	make("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = tabsFrame })

	local pcard = make("Frame", { Size = UDim2.new(1, -12, 0, 56), Position = UDim2.new(0, 6, 1, -62), BorderSizePixel = 0, Parent = side })
	bind(pcard, "BackgroundColor3", "Element")
	round(pcard, 9)
	local pst = outline(pcard, "Stroke")
	pst.Transparency = 0.5
	local avatar = make("ImageLabel", { Size = UDim2.fromOffset(36, 36), Position = UDim2.fromOffset(9, 10), BorderSizePixel = 0, Parent = pcard })
	bind(avatar, "BackgroundColor3", "Stroke")
	pill(avatar)
	spinStroke(avatar, 2, true)
	local online = make("Frame", { Size = UDim2.fromOffset(10, 10), Position = UDim2.fromOffset(37, 37), BackgroundColor3 = c(70, 220, 140), BorderSizePixel = 0, ZIndex = 2, Parent = pcard })
	pill(online)
	outline(online, "Element", 2)
	local dn = label(pcard, LocalPlayer.DisplayName, { Font = BOLD, Size = 12, Box = UDim2.new(1, -58, 0, 16), Pos = UDim2.fromOffset(52, 11) })
	dn.TextTruncate = Enum.TextTruncate.AtEnd
	local un = label(pcard, "@" .. LocalPlayer.Name, { Size = 10, Role = "SubText", Box = UDim2.new(1, -58, 0, 14), Pos = UDim2.fromOffset(52, 28) })
	un.TextTruncate = Enum.TextTruncate.AtEnd
	task.spawn(function()
		local ok, img = pcall(Players.GetUserThumbnailAsync, Players, LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		if ok and avatar.Parent then avatar.Image = img end
	end)

	local pages = make("Frame", { Size = UDim2.new(1, -186, 1, -72), Position = UDim2.fromOffset(176, 64), BackgroundTransparency = 1, ClipsDescendants = true, Parent = body })

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
		local btn = make("TextButton", { Size = UDim2.new(1, 0, 0, 36), Text = "", AutoButtonColor = false, BorderSizePixel = 0, BackgroundTransparency = 1, LayoutOrder = #tabs + 1, ClipsDescendants = true, Parent = tabsFrame })
		bind(btn, "BackgroundColor3", "Element")
		round(btn, 8)
		local sel = make("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = WHITE, BackgroundTransparency = 1, BorderSizePixel = 0, Parent = btn })
		round(sel, 8)
		accentGradient(sel, 0)
		local ind = make("Frame", { Size = UDim2.fromOffset(3, 0), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 5, 0.5, 0), BorderSizePixel = 0, ZIndex = 3, Parent = btn })
		pill(ind)

		local x = 16
		local iconObj, iconIsImg
		if icon ~= nil and icon ~= "" then
			local si = tostring(icon)
			iconIsImg = typeof(icon) == "number" or si:match("^rbxasset") ~= nil or si:match("^%d+$") ~= nil
			if iconIsImg then
				iconObj = make("ImageLabel", { Size = UDim2.fromOffset(16, 16), Position = UDim2.new(0, 14, 0.5, -8), BackgroundTransparency = 1, Image = si:match("^%d+$") and ("rbxassetid://" .. si) or si, ZIndex = 2, Parent = btn })
			else
				iconObj = make("TextLabel", { Size = UDim2.fromOffset(18, 18), Position = UDim2.new(0, 13, 0.5, -9), BackgroundTransparency = 1, Text = si, Font = BOLD, TextSize = 14, ZIndex = 2, Parent = btn })
			end
			x = 38
		end
		local lbl = make("TextLabel", { Size = UDim2.new(1, -(x + 8), 1, 0), Position = UDim2.fromOffset(x, 0), BackgroundTransparency = 1, Text = name, Font = FONT, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 2, Parent = btn })

		local function paint(t)
			local s = tab.selected
			local txt = s and onAccent() or (tab.hov and C("Text") or C("SubText"))
			tween(sel, { BackgroundTransparency = s and 0 or 1 }, t)
			tween(btn, { BackgroundTransparency = s and 1 or (tab.hov and 0.35 or 1) }, t)
			tween(lbl, { TextColor3 = txt }, t)
			tween(ind, { Size = UDim2.fromOffset(3, s and 16 or 0), BackgroundColor3 = onAccent() }, t)
			if iconObj then
				if iconIsImg then tween(iconObj, { ImageColor3 = s and onAccent() or WHITE }, t) else tween(iconObj, { TextColor3 = txt }, t) end
			end
		end
		reg(paint)
		tab.paint = paint

		local page = make("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
			CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y,
			Visible = false, Parent = pages,
		})
		bind(page, "ScrollBarImageColor3", "Accent")
		make("UIPadding", { PaddingRight = UDim.new(0, 8), PaddingLeft = UDim.new(0, 1), PaddingTop = UDim.new(0, 1), PaddingBottom = UDim.new(0, 10), Parent = page })
		local cols = make("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = page })
		make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 10), VerticalAlignment = Enum.VerticalAlignment.Top, SortOrder = Enum.SortOrder.LayoutOrder, Parent = cols })
		local function column(order)
			local col = make("Frame", { Size = UDim2.new(0.5, -5, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = order, Parent = cols })
			make("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = col })
			return col
		end
		local left, right = column(1), column(2)
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
			page.Position = UDim2.fromOffset(0, 16)
			page.Visible = true
			tween(page, { Position = UDim2.fromOffset(0, 0) }, SMOOTH)
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
			tween(lbl, { Position = UDim2.fromOffset(x + 5, 0) })
		end)
		btn.MouseLeave:Connect(function()
			tab.hov = false
			paint()
			tween(lbl, { Position = UDim2.fromOffset(x, 0) })
		end)
		if #tabs == 1 then choose() end

		function tab:AddSection(stitle, sideName)
			local parent = (sideName == "Right") and right or left
			local frame = make("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BorderSizePixel = 0, LayoutOrder = nextOrder(parent), Parent = parent })
			bind(frame, "BackgroundColor3", "Surface")
			frame.BackgroundTransparency = 1 - State.Opacity
			table.insert(glassList, frame)
			round(frame, 10)
			local fs = outline(frame, "Stroke")
			fs.Transparency = 0.35
			make("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = frame })
			make("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = frame })
			local secObj = setmetatable({ Frame = frame, Tab = tab, title = string.lower(stitle or "") }, Section)
			if stitle then
				local hd = make("Frame", { Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, LayoutOrder = nextOrder(frame), Parent = frame })
				local dot = make("Frame", { Size = UDim2.fromOffset(4, 14), Position = UDim2.fromOffset(0, 4), BorderSizePixel = 0, BackgroundColor3 = WHITE, Parent = hd })
				pill(dot)
				accentGradient(dot, 90)
				label(hd, stitle, { Font = BOLD, Size = 14, Box = UDim2.new(1, -12, 1, 0), Pos = UDim2.fromOffset(12, 0) })
				local ln = make("Frame", { Size = UDim2.new(1, 0, 0, 1), BorderSizePixel = 0, BackgroundColor3 = WHITE, LayoutOrder = nextOrder(frame), Parent = frame })
				local lg = accentGradient(ln, 0)
				lg.Transparency = NumberSequence.new({ kp(0, 0.2), kp(1, 1) })
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
	local lSize = IsMobile and 60 or 52
	launcher = make("TextButton", {
		Name = "Launcher", Size = UDim2.fromOffset(lSize, lSize), Position = UDim2.new(0, 24, 0, 80), Text = letter, Font = Enum.Font.GothamBlack,
		TextSize = math.floor(lSize * 0.48), AutoButtonColor = false, BorderSizePixel = 0, Visible = false, ZIndex = 5, Parent = gui,
	})
	bind(launcher, "BackgroundColor3", "Background")
	bind(launcher, "TextColor3", "Accent")
	round(launcher, 15)
	local lStroke = spinStroke(launcher, 2.5, true)
	logoImage(launcher, cfg.Image, launcher, 15)
	lStroke.Transparency = 0
	TweenService:Create(lStroke, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Transparency = 0.6 }):Play()
	launchScale = make("UIScale", { Parent = launcher })
	local lDrag = makeDraggable(launcher, launcher)
	launcher.MouseEnter:Connect(function() tween(launchScale, { Scale = 1.15 }, BACK) end)
	launcher.MouseLeave:Connect(function() tween(launchScale, { Scale = 1 }, BACK) end)
	launcher.InputBegan:Connect(function(i) if isPress(i) then tween(launchScale, { Scale = 0.9 }, FAST) end end)
	launcher.InputEnded:Connect(function(i)
		if isPress(i) then tween(launchScale, { Scale = i.UserInputType == Enum.UserInputType.Touch and 1 or 1.15 }, BACK) end
	end)
	launcher.Activated:Connect(function()
		if not lDrag.moved() and not visible then setVisible(true) end
	end)

	----------------------------------------------------------------- mobile buttons removed (stubs)
	function Window:AddMobileButton() return { Set = function() end, Get = function() return false end } end
	function Window:SetMobileButtons() end
	function Window:SetMobileSize() end

	----------------------------------------------------------------- toasts + stats
	local toasts = make("Frame", { Size = UDim2.new(0, 290, 1, -32), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -16, 0, 16), BackgroundTransparency = 1, ZIndex = 10, Parent = gui })
	make("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right, Parent = toasts })

	function Window:Notify(ntitle, msg, dur, kind)
		if type(ntitle) == "table" then
			local t = ntitle
			ntitle, msg, dur, kind = t.Title, t.Content or t.Text, t.Duration, t.Type
		end
		ntitle = tostring(ntitle or "Notification")
		dur = tonumber(dur) or 3
		kind = (kind and KindGlyph[kind]) and kind or "Info"
		local function col() return KindColor[kind] or C("Accent") end

		local slot = make("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ClipsDescendants = false, LayoutOrder = nextOrder(toasts), Parent = toasts })
		local t = make("CanvasGroup", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.fromOffset(320, 0), BorderSizePixel = 0, GroupTransparency = 1, Parent = slot })
		bind(t, "BackgroundColor3", "Surface")
		round(t, 10)
		outline(t, "Stroke")
		local strip = make("Frame", { Size = UDim2.new(0, 3, 1, 0), BorderSizePixel = 0, BackgroundColor3 = col(), Parent = t })
		local icon = make("Frame", { Size = UDim2.fromOffset(26, 26), Position = UDim2.fromOffset(13, 11), BorderSizePixel = 0, BackgroundColor3 = col(), BackgroundTransparency = 0.8, Parent = t })
		pill(icon)
		make("TextLabel", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = KindGlyph[kind], Font = BOLD, TextSize = 14, TextColor3 = col(), Parent = icon })
		local inner = make("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = t })
		make("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 14), PaddingLeft = UDim.new(0, 48), PaddingRight = UDim.new(0, 12), Parent = inner })
		make("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = inner })
		local tl = label(inner, ntitle, { Font = BOLD, Size = 13, Box = UDim2.new(1, 0, 0, 18) })
		tl.LayoutOrder = 1
		local ml = label(inner, msg or "", { Size = 12, Role = "SubText", Wrap = true, Box = UDim2.new(1, 0, 0, 0), Auto = Enum.AutomaticSize.Y })
		ml.LayoutOrder = 2
		local prog = make("Frame", { Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2), BorderSizePixel = 0, BackgroundColor3 = col(), Parent = t })
		local hitN = make("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 5, Parent = t })
		local _ = strip

		local gone = false
		local function dismiss()
			if gone or not slot.Parent then return end
			gone = true
			tween(t, { Position = UDim2.fromOffset(320, 0), GroupTransparency = 1 }, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In))
			task.delay(0.3, function()
				if not slot.Parent then return end
				local hgt = slot.AbsoluteSize.Y
				slot.AutomaticSize = Enum.AutomaticSize.None
				slot.ClipsDescendants = true
				slot.Size = UDim2.new(1, 0, 0, hgt)
				tween(slot, { Size = UDim2.new(1, 0, 0, 0) }, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out))
				task.wait(0.24)
				slot:Destroy()
			end)
		end
		hitN.MouseButton1Click:Connect(dismiss)
		tween(t, { Position = UDim2.fromOffset(0, 0), GroupTransparency = 0 }, SMOOTH)
		tween(prog, { Size = UDim2.new(0, 0, 0, 2) }, TweenInfo.new(dur, Enum.EasingStyle.Linear))
		task.delay(dur, dismiss)
		return { Dismiss = dismiss }
	end

	local statLabel = make("TextLabel", { Size = UDim2.fromOffset(170, 22), Position = UDim2.new(1, -180, 0, 8), BackgroundTransparency = 1, Text = "", Font = BOLD, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, Visible = false, ZIndex = 6, Parent = gui })
	bind(statLabel, "TextColor3", "Accent")
	local acc, frames, pingText = 0, 0, ""
	connect(RunService.Heartbeat, function(dt)
		if not statLabel.Visible then return end
		acc += dt
		frames += 1
		if acc >= 0.5 then
			local ok, p = pcall(function() return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue() end)
			pingText = ok and ("  |  " .. math.floor(p) .. " ms") or ""
			statLabel.Text = math.floor(frames / acc + 0.5) .. " FPS" .. pingText
			acc, frames = 0, 0
		end
	end)

	----------------------------------------------------------------- animator (spinning strokes, wash, rainbow)
	local clock, rbAcc = 0, 0
	connect(RunService.Heartbeat, function(dt)
		clock += dt
		local rot = clock * 70
		for _, e in ipairs(spinners) do
			if e.g.Parent then e.g.Rotation = (rot + e.ofs) % 360 end
		end
		if wash.Visible and visible then
			washGrad.Rotation = 35 + math.sin(clock * 0.35) * 25
			washGrad.Offset = Vector2.new(math.sin(clock * 0.27) * 0.12, math.cos(clock * 0.21) * 0.12)
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
		for _, f in ipairs(glassList) do
			if f.Parent then f.BackgroundTransparency = 1 - x end
		end
		saveSoon()
	end
	function Window:SetRounding(x)
		State.Rounding = x
		UI.look.rounding = x
		for _, e in ipairs(corners) do
			if e.c.Parent then e.c.CornerRadius = UDim.new(0, math.floor(e.r * x + 0.5)) end
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
		tween(glowImg, { ImageTransparency = (visible and UI.look.glow) and 0.82 or 1 }, SLOW)
		saveSoon()
	end
	function Window:SetBlur(on)
		UI.look.blur = on and true or false
		tween(blur, { Size = (visible and UI.look.blur) and 14 or 0 }, SLOW)
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
			launcher.Size = UDim2.fromOffset(size, size)
			launcher.TextSize = math.floor(size * 0.48)
		end
	end
	function Window:SetFPSCounter(on) statLabel.Visible = on end
	-- SetAmbienceEnabled / SetAmbienceStyle / SetAmbienceOpacity are installed by FX.Build

	----------------------------------------------------------------- intro + open animation
	local function openAnim()
		if not alive or not visible then return end
		scaler.Scale = baseScale() * 0.9
		tween(scaler, { Scale = baseScale() }, BACK)
		tween(body, { GroupTransparency = 0 }, SLOW)
		extras(true, SLOW)
	end

	local function intro(done)
		if cfg.Intro == false then return done() end
		local sp = make("CanvasGroup", { Size = UDim2.fromOffset(260, 124), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), BorderSizePixel = 0, GroupTransparency = 1, ZIndex = 20, Parent = gui })
		bind(sp, "BackgroundColor3", "Background")
		round(sp, 14)
		outline(sp, "Stroke")
		local ss = make("UIScale", { Scale = 0.85, Parent = sp })
		local spWash = make("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = WHITE, BorderSizePixel = 0, Parent = sp })
		local swg = accentGradient(spWash, 90)
		swg.Transparency = NumberSequence.new({ kp(0, 0.85), kp(1, 1) })
		local sl = logoTile(sp, 46, 12, letter, cfg.Image, UDim2.new(0.5, -23, 0, 16), 24)
		local _ = sl
		label(sp, title, { Font = BOLD, Size = 15, AlignX = Enum.TextXAlignment.Center, Box = UDim2.new(1, 0, 0, 20), Pos = UDim2.fromOffset(0, 68) })
		local trk = make("Frame", { Size = UDim2.new(1, -60, 0, 4), Position = UDim2.fromOffset(30, 100), BorderSizePixel = 0, Parent = sp })
		pill(trk)
		bind(trk, "BackgroundColor3", "Stroke")
		local fl = make("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, BackgroundColor3 = WHITE, Parent = trk })
		pill(fl)
		accentGradient(fl, 0)
		tween(sp, { GroupTransparency = 0 }, SLOW)
		tween(ss, { Scale = 1 }, BACK)
		tween(fl, { Size = UDim2.fromScale(1, 1) }, TweenInfo.new(0.9, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut))
		task.delay(1.05, function()
			if not sp.Parent then return end
			tween(sp, { GroupTransparency = 1 }, FAST)
			tween(ss, { Scale = 1.08 }, FAST)
			task.delay(0.16, function() sp:Destroy() end)
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
--   colors/glyphs, size, vx/vy (screen fraction per sec), sway, glow, twinkle,
--   wander, spin, stretch, hollow, textColors, font, norot, flicker, deco, vig
--------------------------------------------------------------------------------
local FXStyles = {
	["Spooky Halloween"] = { colors = { c(255,140,30), c(255,90,20), c(170,90,255), c(255,205,90) }, size = {3,7}, vx = {-0.012,0.012}, vy = {-0.07,-0.025}, sway = 0.02, glow = true, count = 50, vig = c(46,10,64), deco = "halloween" },
	["Celestial Stardust"] = { colors = { c(255,255,255), c(170,200,255), c(255,225,150) }, size = {2,5}, vx = {-0.004,0.004}, vy = {-0.012,-0.004}, sway = 0.006, glow = true, twinkle = true, count = 70, vig = c(8,12,44), shooting = true },
	["Cyber Grid Sparks"] = { colors = { c(0,240,255), c(255,46,151) }, size = {1,3}, stretch = 10, vx = {0,0}, vy = {0.18,0.4}, sway = 0, count = 45, vig = c(44,0,56), deco = "cyber" },
	["Autumn Breeze"] = { glyphs = { "🍂", "🍁" }, size = {14,24}, vx = {0.04,0.09}, vy = {0.03,0.07}, sway = 0.03, spin = 60, count = 26, vig = c(54,24,6) },
	["Frost Snowfall"] = { colors = { c(255,255,255), c(190,225,255) }, size = {2,6}, vx = {-0.012,0.012}, vy = {0.035,0.09}, sway = 0.015, glow = true, count = 80, vig = c(20,42,76) },
	["Fireflies"] = { colors = { c(190,255,110), c(255,240,130) }, size = {3,6}, vx = {-0.01,0.01}, vy = {-0.01,0.01}, sway = 0.035, glow = true, twinkle = true, wander = true, count = 34, vig = c(6,30,16) },
	["Sakura Petals"] = { glyphs = { "🌸" }, size = {12,20}, vx = {0.03,0.07}, vy = {0.03,0.06}, sway = 0.03, spin = 45, count = 24, vig = c(64,22,40) },
	-- new
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
	local root = make("Frame", { Name = "Root", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClipsDescendants = true, Visible = false, Parent = gui })
	local partLayer = make("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 2, Parent = root })
	local decoLayer = make("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 3, Parent = root })
	local topLayer = make("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = topGui })
	local holder = window.Gui:FindFirstChild("Holder")

	local function vp()
		local cam = workspace.CurrentCamera
		return cam and cam.ViewportSize or Vector2.new(1280, 720)
	end

	---------------------------------------------------------------- vignette
	local edges = {}
	for _, d in ipairs({
		{ UDim2.new(1, 0, 0.34, 0), UDim2.new(0, 0, 0, 0), Vector2.new(0, 0), 90 },
		{ UDim2.new(1, 0, 0.34, 0), UDim2.new(0, 0, 1, 0), Vector2.new(0, 1), 270 },
		{ UDim2.new(0.24, 0, 1, 0), UDim2.new(0, 0, 0, 0), Vector2.new(0, 0), 0 },
		{ UDim2.new(0.24, 0, 1, 0), UDim2.new(1, 0, 0, 0), Vector2.new(1, 0), 180 },
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

	---------------------------------------------------------------- deco
	local Deco = {}

	local function D(inst, prop, base)
		local it = { inst = inst, prop = prop, base = base }
		table.insert(FX.decoItems, it)
		return it
	end
	local function disc(parent, d, pos, col, z)
		local f = make("Frame", { Size = UDim2.fromOffset(d, d), AnchorPoint = Vector2.new(0.5, 0.5), Position = pos, BackgroundColor3 = col, BorderSizePixel = 0, ZIndex = z or 3, Parent = parent })
		make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = f })
		return f
	end
	local function glyph(layer, txt, size, z)
		size = math.floor(size)
		return make("TextLabel", { BackgroundTransparency = 1, Text = txt, TextSize = size, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(size * 2, size * 2), ZIndex = z or 4, Parent = layer })
	end
	local function lightning(layer, tint)
		local flash = make("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = tint or c(225, 220, 255), BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 6, Parent = layer })
		local nextStrike = 6 + math.random() * 8
		table.insert(FX.decoTicks, function(dt)
			if not fx.lightning then return end
			nextStrike -= dt
			if nextStrike > 0 then return end
			nextStrike = 7 + math.random() * 12
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

	function Deco.halloween(layer)
		local ticks = FX.decoTicks
		local V = vp()
		local u = math.clamp(V.Y / 720, 0.55, 1.25)

		local mpos = UDim2.fromScale(0.86, 0.17)
		local halos = {}
		for i, d in ipairs({ 330, 240, 175 }) do
			halos[i] = D(disc(layer, d * u, mpos, c(255, 226, 160), 3), "BackgroundTransparency", 0.95)
		end
		local moon = disc(layer, 118 * u, mpos, c(255, 240, 205), 3)
		D(moon, "BackgroundTransparency", 0.03)
		for _, cr in ipairs({ { 0.3, 0.36, 0.22 }, { 0.62, 0.58, 0.16 }, { 0.4, 0.74, 0.11 }, { 0.7, 0.28, 0.09 } }) do
			local f = make("Frame", { Size = UDim2.fromScale(cr[3], cr[3]), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(cr[1], cr[2]), BackgroundColor3 = c(226, 204, 150), BorderSizePixel = 0, ZIndex = 3, Parent = moon })
			make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = f })
			D(f, "BackgroundTransparency", 0.55)
		end
		table.insert(ticks, function(_, t)
			for i, it in ipairs(halos) do it.base = 0.925 + 0.012 * i + 0.03 * (0.5 + 0.5 * math.sin(t * 0.8 + i)) end
		end)
		for i = 1, 3 do
			local cl = make("Frame", { Size = UDim2.fromOffset((200 + i * 60) * u, 30 * u), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = c(24, 16, 44), BorderSizePixel = 0, ZIndex = 4, Parent = layer })
			make("UICorner", { CornerRadius = UDim.new(1, 0), Parent = cl })
			D(cl, "BackgroundTransparency", 0.45 + i * 0.05)
			local x, y, sp = i * 0.4 - 0.2, 0.09 + i * 0.05, 0.006 + i * 0.002
			table.insert(ticks, function(dt)
				x += sp * dt * fx.speed
				if x > 1.3 then x = -0.3 end
				cl.Position = UDim2.fromScale(x, y)
			end)
		end

		for i = 1, 3 do
			local band = make("Frame", { Size = UDim2.new(1.5, 0, 0, math.floor((110 + i * 30) * u)), AnchorPoint = Vector2.new(0.5, 1), BackgroundColor3 = i == 2 and c(170, 150, 215) or c(205, 190, 235), BorderSizePixel = 0, ZIndex = 3, Parent = layer })
			make("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ kp(0, 1), kp(0.55, 0.2), kp(1, 0) }), Parent = band })
			D(band, "BackgroundTransparency", 0.84 + i * 0.03)
			local y = 1 - (i - 1) * 0.05
			table.insert(ticks, function(_, t)
				band.Position = UDim2.fromScale(0.5 + 0.07 * math.sin(t * 0.12 * fx.speed + i * 2), y)
			end)
		end

		for _ = 1, 6 do
			local ts = math.floor((20 + math.random() * 16) * u)
			local l = glyph(layer, "🦇", ts, 4)
			D(l, "TextTransparency", 0.08)
			local b = { x = math.random() * 1.4 - 0.2, y = 0.1 + math.random() * 0.35, sp = 0.05 + math.random() * 0.07, ph = math.random() * 6.28, amp = 0.03 + math.random() * 0.04, fq = 1 + math.random() * 1.2 }
			table.insert(ticks, function(dt, t)
				b.x += b.sp * dt * fx.speed
				if b.x > 1.15 then b.x = -0.15; b.y = 0.1 + math.random() * 0.35 end
				l.Position = UDim2.fromScale(b.x, b.y + math.sin(t * b.fq * 0.7 + b.ph) * b.amp)
				l.Rotation = math.sin(t * b.fq * 6 + b.ph) * 14
				l.TextSize = math.floor(ts * (0.82 + 0.22 * math.abs(math.sin(t * b.fq * 14 + b.ph))))
			end)
		end

		for _ = 1, 3 do
			local l = glyph(layer, "👻", (38 + math.random() * 22) * u, 4)
			local it = D(l, "TextTransparency", 0.6)
			local g = { x = math.random(), y = 0.35 + math.random() * 0.4, vx = 0.008 + math.random() * 0.012, ph = math.random() * 6.28 }
			table.insert(ticks, function(dt, t)
				g.x += g.vx * dt * fx.speed
				if g.x > 1.1 then g.x = -0.1; g.y = 0.35 + math.random() * 0.4 end
				l.Position = UDim2.fromScale(g.x, g.y + math.sin(t * 0.6 + g.ph) * 0.03)
				l.Rotation = math.sin(t * 0.8 + g.ph) * 6
				it.base = 0.45 + 0.4 * (0.5 + 0.5 * math.sin(t * 0.5 + g.ph))
			end)
		end

		for i, px in ipairs({ 0.045, 0.12, 0.885, 0.955 }) do
			local s = (48 + (i % 2) * 14) * u
			local py = UDim2.new(px, 0, 1, -math.floor(s * 0.5))
			local gi = D(disc(layer, s * 2.6, py, c(255, 120, 20), 3), "BackgroundTransparency", 0.86)
			local p = glyph(layer, "🎃", s, 4)
			p.Position = py
			D(p, "TextTransparency", 0.04)
			table.insert(ticks, function(_, t)
				gi.base = 0.84 + 0.05 * math.sin(t * 7 + i) + 0.03 * math.sin(t * 13.3 + i * 2)
			end)
		end

		local w1 = glyph(layer, "🕸", 120 * u, 4)
		w1.Position = UDim2.fromOffset(math.floor(60 * u), math.floor(60 * u))
		D(w1, "TextTransparency", 0.55)
		local w2 = glyph(layer, "🕸", 120 * u, 4)
		w2.Position = UDim2.new(1, -math.floor(60 * u), 0, math.floor(60 * u))
		w2.Rotation = 90
		D(w2, "TextTransparency", 0.55)
		for i, sx in ipairs({ 0.08, 0.93 }) do
			local thread = make("Frame", { Size = UDim2.fromOffset(1, 40), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromScale(sx, 0), BackgroundColor3 = c(225, 225, 235), BorderSizePixel = 0, ZIndex = 4, Parent = layer })
			D(thread, "BackgroundTransparency", 0.55)
			local sp = glyph(layer, "🕷", 22 * u, 4)
			D(sp, "TextTransparency", 0.05)
			table.insert(ticks, function(_, t)
				local len = math.floor(50 + (0.5 + 0.5 * math.sin(t * 0.5 + i * 2)) * 0.2 * V.Y)
				thread.Size = UDim2.fromOffset(1, len)
				sp.Position = UDim2.new(sx, 0, 0, len + 8)
			end)
		end

		lightning(layer)
	end

	function Deco.cyber(layer)
		for i = 1, 13 do
			local l = make("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.fromScale(0, i / 14), BackgroundColor3 = c(0, 240, 255), BorderSizePixel = 0, ZIndex = 3, Parent = layer })
			D(l, "BackgroundTransparency", 0.93)
		end
		for i = 1, 22 do
			local l = make("Frame", { Size = UDim2.new(0, 1, 1, 0), Position = UDim2.fromScale(i / 23, 0), BackgroundColor3 = c(255, 46, 151), BorderSizePixel = 0, ZIndex = 3, Parent = layer })
			D(l, "BackgroundTransparency", 0.96)
		end
		local scan = make("Frame", { Size = UDim2.new(1, 0, 0, 3), BackgroundColor3 = c(0, 240, 255), BorderSizePixel = 0, ZIndex = 3, Parent = layer })
		make("UIGradient", { Transparency = NumberSequence.new({ kp(0, 1), kp(0.5, 0.2), kp(1, 1) }), Parent = scan })
		D(scan, "BackgroundTransparency", 0.45)
		table.insert(FX.decoTicks, function(_, t)
			scan.Position = UDim2.fromScale(0, (t * 0.1 * fx.speed) % 1.1 - 0.05)
		end)
	end

	function Deco.aurora(layer)
		local cols = { { c(60,255,170), c(80,180,255) }, { c(170,90,255), c(60,255,200) }, { c(80,200,255), c(255,90,200) } }
		for i = 1, 3 do
			local band = make("Frame", { Size = UDim2.new(1.6, 0, 0.3, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 3, Parent = layer })
			local g = make("UIGradient", { Color = ColorSequence.new(cols[i][1], cols[i][2]), Transparency = NumberSequence.new({ kp(0, 1), kp(0.5, 0.3), kp(1, 1) }), Rotation = 90, Parent = band })
			local it = D(band, "BackgroundTransparency", 0.8)
			table.insert(FX.decoTicks, function(_, t)
				band.Position = UDim2.fromScale(0.5 + 0.12 * math.sin(t * 0.07 * fx.speed + i * 2), 0.14 + i * 0.06 + 0.03 * math.sin(t * 0.2 * fx.speed + i))
				band.Rotation = -8 + 6 * math.sin(t * 0.1 * fx.speed + i)
				it.base = 0.7 + 0.14 * (0.5 + 0.5 * math.sin(t * 0.4 + i * 1.7))
				g.Offset = Vector2.new(0, 0.12 * math.sin(t * 0.15 + i))
			end)
		end
	end

	function Deco.ocean(layer)
		for i = 1, 6 do
			local ray = make("Frame", { Size = UDim2.new(0, 60 + i * 14, 1.3, 0), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromScale(i / 7, -0.1), Rotation = 18, BackgroundColor3 = c(190, 235, 255), BorderSizePixel = 0, ZIndex = 3, Parent = layer })
			make("UIGradient", { Rotation = 90, Transparency = NumberSequence.new({ kp(0, 0.2), kp(0.7, 0.85), kp(1, 1) }), Parent = ray })
			local it = D(ray, "BackgroundTransparency", 0.88)
			table.insert(FX.decoTicks, function(_, t)
				ray.Position = UDim2.fromScale(i / 7 + 0.03 * math.sin(t * 0.3 * fx.speed + i), -0.1)
				it.base = 0.86 + 0.08 * (0.5 + 0.5 * math.sin(t * 0.6 + i * 1.3))
			end)
		end
		local floor = make("Frame", { Size = UDim2.new(1, 0, 0.3, 0), AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), BackgroundColor3 = c(0, 60, 110), BorderSizePixel = 0, ZIndex = 3, Parent = layer })
		make("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0), Parent = floor })
		D(floor, "BackgroundTransparency", 0.6)
	end

	function Deco.storm(layer)
		local fog = make("Frame", { Size = UDim2.new(1, 0, 0.4, 0), BackgroundColor3 = c(30, 40, 90), BorderSizePixel = 0, ZIndex = 3, Parent = layer })
		make("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(0, 1), Parent = fog })
		D(fog, "BackgroundTransparency", 0.55)
		lightning(layer, c(200, 220, 255))
	end

	---------------------------------------------------------------- particles
	local function spawn(p, initial)
		local st = FX.style
		local z = 0.4 + math.random() * 0.6
		p.z = z
		local vxm, vym = (st.vx[1] + st.vx[2]) / 2, (st.vy[1] + st.vy[2]) / 2
		p.x, p.y = math.random(), math.random()
		if not initial and not st.wander then
			if math.abs(vxm) > math.abs(vym) then p.x = vxm > 0 and -0.06 or 1.06
			else p.y = vym > 0 and -0.06 or 1.06 end
		end
		p.vx = mix(st.vx[1], st.vx[2], math.random())
		p.vy = mix(st.vy[1], st.vy[2], math.random())
		p.ph = math.random() * 6.283
		p.fq = 0.6 + math.random() * 1.6
		local sz = mix(st.size[1], st.size[2], math.random()) * (0.55 + 0.6 * z)
		if st.glyphs then
			p.f.TextSize = math.floor(sz)
			p.f.Size = UDim2.fromOffset(math.floor(sz * 2), math.floor(sz * 2))
			p.f.Rotation = st.norot and 0 or math.random(0, 360)
			if st.textColors then
				p.f.TextColor3 = fx.tint == "Theme" and ((math.random() < 0.6) and C("Accent") or C("Accent2")) or st.textColors[math.random(#st.textColors)]
			end
		else
			p.f.Size = UDim2.fromOffset(math.max(1, math.floor(sz + 0.5)), math.max(1, math.floor(sz * (st.stretch or 1) + 0.5)))
			local col
			if fx.tint == "Theme" then col = (math.random() < 0.6) and C("Accent") or C("Text")
			else col = st.colors[math.random(#st.colors)] end
			p.f.BackgroundColor3 = col
			if p.g then p.g.Color = col end
		end
	end

	local function rebuild()
		for _, p in ipairs(FX.parts) do p.f:Destroy() end
		FX.parts = {}
		decoLayer:ClearAllChildren()
		FX.decoItems, FX.decoTicks = {}, {}
		local st = FXStyles[fx.style]
		FX.style = st
		FX.RefreshVignette()
		if not st then return end
		for _ = 1, math.floor((st.count or 45) * fx.density + 0.5) do
			local f
			if st.glyphs then
				f = make("TextLabel", { BackgroundTransparency = 1, Text = st.glyphs[math.random(#st.glyphs)], AnchorPoint = Vector2.new(0.5, 0.5), ZIndex = 2, Parent = partLayer })
				if st.font then f.Font = st.font end
			else
				f = make("Frame", { BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), ZIndex = 2, Parent = partLayer })
				make("UICorner", { CornerRadius = UDim.new(st.stretch and 0 or 1, 0), Parent = f })
			end
			local p = { f = f }
			if (st.glow or st.hollow) and not st.glyphs then
				p.g = make("UIStroke", { Thickness = st.hollow and 1.2 or 3, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = f })
			end
			table.insert(FX.parts, p)
			spawn(p, true)
		end
		if fx.deco and st.deco and Deco[st.deco] then Deco[st.deco](decoLayer) end
	end
	FX.Rebuild = rebuild

	local function shoot(A)
		local x0, y0 = 0.05 + math.random() * 0.6, math.random() * 0.35
		local s = make("Frame", {
			Size = UDim2.fromOffset(math.random(70, 130), 2), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.fromScale(x0, y0),
			Rotation = 28, BorderSizePixel = 0, BackgroundColor3 = c(255, 255, 255), BackgroundTransparency = 1 - 0.9 * fx.opacity * A, ZIndex = 2, Parent = partLayer,
		})
		make("UIGradient", { Transparency = NumberSequence.new(1, 0), Parent = s })
		tween(s, { Position = UDim2.fromScale(x0 + 0.3, y0 + 0.16), BackgroundTransparency = 1 }, TweenInfo.new(0.85, Enum.EasingStyle.Quad, Enum.EasingDirection.In))
		task.delay(0.9, function() s:Destroy() end)
	end

	---------------------------------------------------------------- cursor trail + click burst
	local function dot(pos, size, col, life, to)
		local d = make("Frame", { Size = UDim2.fromOffset(size, size), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(pos.X, pos.Y), BackgroundColor3 = col, BackgroundTransparency = 0.15, BorderSizePixel = 0, Parent = topLayer })
		pill(d)
		tween(d, { Position = to and UDim2.fromOffset(to.X, to.Y) or d.Position, Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1 }, TweenInfo.new(life, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
		task.delay(life + 0.05, function() d:Destroy() end)
	end
	local function burst(pos)
		for i = 1, 10 do
			local ang = (i / 10) * math.pi * 2 + math.random() * 0.5
			local dist = 24 + math.random() * 26
			dot(pos, math.random(4, 7), (i % 2 == 0) and C("Accent") or C("Accent2"), 0.5, pos + Vector2.new(math.cos(ang) * dist, math.sin(ang) * dist))
		end
		local ring = make("Frame", { Size = UDim2.fromOffset(4, 4), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(pos.X, pos.Y), BackgroundTransparency = 1, Parent = topLayer })
		pill(ring)
		local rs = make("UIStroke", { Color = C("Accent"), Thickness = 2, Parent = ring })
		tween(ring, { Size = UDim2.fromOffset(52, 52) }, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
		tween(rs, { Transparency = 1 }, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
		task.delay(0.5, function() ring:Destroy() end)
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

	---------------------------------------------------------------- loop
	local clock, A, nextShoot = 0, 0, 2
	local lastM, trailAcc, trailFlip = nil, 0, false
	connect(RunService.Heartbeat, function(dt)
		clock += dt

		-- cursor trail (independent of the ambience layer)
		if fx.trail and holder and holder.Visible then
			trailAcc += dt
			local m = UserInputService:GetMouseLocation()
			if trailAcc >= 0.016 and (not lastM or (m - lastM).Magnitude > 3) then
				trailAcc = 0
				lastM = m
				trailFlip = not trailFlip
				dot(m, 8, trailFlip and C("Accent") or C("Accent2"), 0.45)
			end
		end

		local open = holder and holder.Visible
		local want = fx.on and (open or not fx.menuOnly) and FX.style ~= nil
		A += ((want and 1 or 0) - A) * math.min(1, dt / math.max(0.03, fx.fade * 0.35))
		FX.alpha = A
		root.Visible = A > 0.01
		if not root.Visible then return end
		local st = FX.style
		if not st then return end

		local va = fx.vignette and fx.vignetteStrength * A or 0
		for _, e in ipairs(edges) do e.BackgroundTransparency = 1 - va end

		for _, p in ipairs(FX.parts) do
			local z = p.z
			local sway = math.sin(clock * p.fq + p.ph) * st.sway
			p.x += (p.vx * z + sway) * dt * fx.speed
			p.y += (p.vy * z + (st.wander and math.cos(clock * p.fq * 0.8 + p.ph) * st.sway or 0)) * dt * fx.speed
			if p.x > 1.08 or p.x < -0.08 or p.y > 1.08 or p.y < -0.08 then spawn(p, false) end
			p.f.Position = UDim2.fromScale(p.x, p.y)
			if st.spin then p.f.Rotation += st.spin * dt * fx.speed * z end
			local tw = st.twinkle and (0.3 + 0.7 * math.abs(math.sin(clock * p.fq + p.ph))) or 1
			local a = fx.opacity * A * tw * (0.4 + 0.6 * z)
			if st.glyphs then
				p.f.TextTransparency = 1 - a
				if st.flicker and math.random() < 0.03 then p.f.Text = st.glyphs[math.random(#st.glyphs)] end
			elseif st.hollow then
				p.f.BackgroundTransparency = 1 - a * 0.15
				if p.g then p.g.Transparency = 1 - a * 0.9 end
			else
				p.f.BackgroundTransparency = 1 - a
				if p.g then p.g.Transparency = 1 - a * 0.55 end
			end
		end

		if st.shooting then
			nextShoot -= dt
			if nextShoot <= 0 then nextShoot = 2.5 + math.random() * 4; shoot(A) end
		end

		for _, f in ipairs(FX.decoTicks) do f(dt, clock) end
		local dA = A * fx.opacity
		for _, it in ipairs(FX.decoItems) do
			if it.inst.Parent then it.inst[it.prop] = 1 - (1 - it.base) * dA end
		end
	end)

	reg(function() FX.RefreshVignette() end)
	rebuild()

	-- window API now drives the FX engine
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
	["Top Center"] = { Vector2.new(0.5, 0), UDim2.new(0.5, 0, 0, 12) },
	["Top Left"] = { Vector2.new(0, 0), UDim2.new(0, 12, 0, 12) },
	["Top Right"] = { Vector2.new(1, 0), UDim2.new(1, -12, 0, 12) },
	["Bottom Center"] = { Vector2.new(0.5, 1), UDim2.new(0.5, 0, 1, -12) },
}
Lib.StatsPresets = { "Top Center", "Top Left", "Top Right", "Bottom Center" }

function Hud.Build(window, cfg)
	cfg = cfg or {}
	local S, K = UI.stats, UI.keys
	local gui = make("ScreenGui", { Name = "SHubHUD", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 95, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = PlayerGui })
	table.insert(Registry.extra, gui)
	local GOOD, WARN, BAD = c(70, 220, 140), c(255, 200, 70), c(255, 90, 90)

	------------------------------------------------------------------ stats bar
	local bar = make("Frame", { Name = "Stats", AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 34), AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 12), BorderSizePixel = 0, ZIndex = 2, Parent = gui })
	bind(bar, "BackgroundColor3", "Surface")
	pill(bar)
	spinStroke(bar, 1.4)
	local barScale = make("UIScale", { Parent = bar })
	make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = bar })
	make("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 14), Parent = bar })

	local segs = {}
	local function seg(id, order)
		local f = make("Frame", { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 34), BackgroundTransparency = 1, LayoutOrder = order, Parent = bar })
		make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = f })
		local sep = make("Frame", { Size = UDim2.fromOffset(1, 16), BorderSizePixel = 0, LayoutOrder = 0, Parent = f })
		bind(sep, "BackgroundColor3", "Stroke")
		segs[id] = { f = f, sep = sep }
		return f
	end
	local function txt(parent, text, order, bold, role)
		local l = make("TextLabel", { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 18), BackgroundTransparency = 1, Text = text, Font = bold and BOLD or FONT, TextSize = 13, LayoutOrder = order, Parent = parent })
		bind(l, "TextColor3", role)
		return l
	end
	local function iconBox(parent)
		return make("Frame", { Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1, LayoutOrder = 1, Parent = parent })
	end
	local function acc(inst)
		bind(inst, "BackgroundColor3", "Accent")
		return inst
	end

	-- identity
	local sId = seg("id", 1)
	segs.id.sep.Visible = false
	local logo = logoTile(sId, 24, 8, cfg.Letter or "S", cfg.Image, nil, 13)
	logo.LayoutOrder = 1
	local nameL = txt(sId, LocalPlayer.DisplayName, 2, true, "Text")

	-- ping (signal bars)
	local sPing = seg("ping", 2)
	local pi = iconBox(sPing)
	local pingBars = {}
	for i, h in ipairs({ 5, 9, 13 }) do
		local b = acc(make("Frame", { Size = UDim2.fromOffset(3, h), Position = UDim2.fromOffset((i - 1) * 5, 16 - h), BorderSizePixel = 0, Parent = pi }))
		make("UICorner", { CornerRadius = UDim.new(0, 1), Parent = b })
		pingBars[i] = b
	end
	local pingV = txt(sPing, "--", 2, true, "Text")
	txt(sPing, "ms", 3, false, "SubText")

	-- fps (gauge)
	local sFps = seg("fps", 3)
	local fi = iconBox(sFps)
	local ring = make("Frame", { Size = UDim2.fromOffset(15, 15), Position = UDim2.fromOffset(0, 1), BackgroundTransparency = 1, Parent = fi })
	pill(ring)
	outline(ring, "Accent", 1.8)
	local needle = acc(make("Frame", { Size = UDim2.fromOffset(2, 6), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.fromScale(0.5, 0.55), Rotation = 40, BorderSizePixel = 0, Parent = ring }))
	local fpsV = txt(sFps, "--", 2, true, "Text")
	txt(sFps, "fps", 3, false, "SubText")

	-- players
	local sPl = seg("players", 4)
	local pli = iconBox(sPl)
	pill(acc(make("Frame", { Size = UDim2.fromOffset(6, 6), Position = UDim2.fromOffset(5, 0), BorderSizePixel = 0, Parent = pli })))
	local body = acc(make("Frame", { Size = UDim2.fromOffset(12, 7), Position = UDim2.fromOffset(2, 8), BorderSizePixel = 0, Parent = pli }))
	make("UICorner", { CornerRadius = UDim.new(0, 5), Parent = body })
	local plV = txt(sPl, "--", 2, true, "Text")
	txt(sPl, "players", 3, false, "SubText")

	-- clock
	local sTime = seg("time", 5)
	local tiBox = iconBox(sTime)
	local clockRing = make("Frame", { Size = UDim2.fromOffset(15, 15), Position = UDim2.fromOffset(0, 1), BackgroundTransparency = 1, Parent = tiBox })
	pill(clockRing)
	outline(clockRing, "Accent", 1.8)
	local hand = acc(make("Frame", { Size = UDim2.fromOffset(2, 5), AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.fromScale(0.5, 0.55), BorderSizePixel = 0, Parent = clockRing }))
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
		bar.AnchorPoint, bar.Position = p[1], p[2]
	end
	makeDraggable(bar, bar)

	local acct, frames = 0, 0
	connect(RunService.Heartbeat, function(dt)
		acct += dt
		frames += 1
		if acct < 0.4 then return end
		local f = math.floor(frames / acct + 0.5)
		acct, frames = 0, 0
		local ok, p = pcall(function() return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue() end)
		local ping = ok and math.floor(p) or 0
		pingV.Text = ok and tostring(ping) or "--"
		fpsV.Text = tostring(f)
		plV.Text = tostring(#Players:GetPlayers())
		timeV.Text = os.date("%H:%M")
		local now = os.date("*t")
		hand.Rotation = (now.min / 60) * 360
		tween(needle, { Rotation = -120 + math.clamp(f / 120, 0, 1) * 240 }, SLOW)
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
	local panel = make("Frame", { Name = "Keybinds", Size = UDim2.fromOffset(240, 200), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 16, 0.5, 0), BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 2, Parent = gui })
	bind(panel, "BackgroundColor3", "Surface")
	round(panel, 12)
	spinStroke(panel, 1.4)
	local panelScale = make("UIScale", { Parent = panel })

	local header = make("Frame", { Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1, Parent = panel })
	logoTile(header, 22, 7, cfg.Letter or "S", cfg.Image, UDim2.fromOffset(10, 8), 12)
	label(header, "Active Keybinds", { Font = BOLD, Size = 13, Box = UDim2.new(1, -90, 1, 0), Pos = UDim2.fromOffset(40, 0) })
	local badge = make("TextButton", { Size = UDim2.fromOffset(30, 20), Position = UDim2.new(1, -40, 0, 9), Text = "0", Font = BOLD, TextSize = 11, AutoButtonColor = false, BorderSizePixel = 0, Parent = header })
	bind(badge, "BackgroundColor3", "Background")
	bind(badge, "TextColor3", "Accent")
	pill(badge)
	outline(badge, "Accent", 1.2)
	local divider = make("Frame", { Size = UDim2.new(1, -12, 0, 1), Position = UDim2.fromOffset(6, 38), BorderSizePixel = 0, BackgroundColor3 = WHITE, Parent = panel })
	local dg = accentGradient(divider, 0)
	dg.Transparency = NumberSequence.new({ kp(0, 1), kp(0.5, 0.2), kp(1, 1) })
	makeDraggable(header, panel)

	local list = make("ScrollingFrame", { Size = UDim2.new(1, -12, 0, 100), Position = UDim2.fromOffset(6, 44), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = panel })
	bind(list, "ScrollBarImageColor3", "Accent")
	make("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list })

	local rows = {}
	local function relayout()
		local shown = 0
		for _, r in ipairs(rows) do
			local vis = r.kind == "ui" or K.showUnbound or (r.h and r.h.key ~= nil)
			r.f.Visible = vis
			if vis then shown += 1 end
		end
		badge.Text = tostring(#rows)
		local h = math.min(shown, K.maxRows) * 32
		list.Visible = not K.collapsed
		divider.Visible = not K.collapsed
		list.Size = UDim2.new(1, -12, 0, h)
		tween(panel, { Size = UDim2.fromOffset(240, K.collapsed and 38 or (50 + h)) }, SLOW)
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
		local f = make("Frame", { Size = UDim2.new(1, 0, 0, 28), BorderSizePixel = 0, LayoutOrder = #rows + 1, Parent = list })
		bind(f, "BackgroundColor3", "Element")
		round(f, 7)
		local lb = label(f, o.name, { Size = 12, Box = UDim2.new(1, -100, 1, 0), Pos = UDim2.fromOffset(10, 0) })
		lb.TextTruncate = Enum.TextTruncate.AtEnd
		local ctrl = make("Frame", { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 22), AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -5, 0.5, 0), BackgroundTransparency = 1, Parent = f })
		make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = ctrl })

		local function chip(text, order, accent)
			local b = make("TextButton", { AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 22), Text = text, Font = BOLD, TextSize = 11, AutoButtonColor = false, BorderSizePixel = 0, LayoutOrder = order, Parent = ctrl })
			bind(b, "BackgroundColor3", "Background")
			bind(b, "TextColor3", "Accent")
			round(b, 5)
			outline(b, accent and "Accent" or "Stroke", accent and 1.2 or 1)
			make("UIPadding", { PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7), Parent = b })
			make("UISizeConstraint", { MinSize = Vector2.new(26, 22), Parent = b })
			b.MouseEnter:Connect(function() tween(b, { BackgroundColor3 = C("Hover") }) end)
			b.MouseLeave:Connect(function() tween(b, { BackgroundColor3 = C("Background") }) end)
			return b
		end

		local row = { f = f, kind = o.kind, h = o.h }
		local setOn
		if o.kind == "toggle" then
			local tr = make("Frame", { Size = UDim2.fromOffset(32, 16), BorderSizePixel = 0, LayoutOrder = 1, Parent = ctrl })
			pill(tr)
			local tg = accentGradient(tr, 0)
			local kn = make("Frame", { Size = UDim2.fromOffset(12, 12), Position = UDim2.fromOffset(2, 2), BackgroundColor3 = c(245, 245, 250), BorderSizePixel = 0, Parent = tr })
			pill(kn)
			local on = false
			local function paintT(t)
				tg.Enabled = on
				tween(tr, { BackgroundColor3 = on and WHITE or C("Stroke") }, t)
			end
			reg(paintT)
			function setOn(v)
				on = v and true or false
				paintT()
				tween(kn, { Position = on and UDim2.fromOffset(18, 2) or UDim2.fromOffset(2, 2) }, BACK)
			end
			make("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", Parent = tr }).MouseButton1Click:Connect(function()
				if o.h and o.h.Set then o.h.Set(not o.h.state) end
			end)
		end
		local kb = chip(keyText(o.getKey()), 2)
		kb.MouseButton1Click:Connect(function() listenKey(kb, o) end)
		if o.kind ~= "toggle" then
			chip("RUN", 3, true).MouseButton1Click:Connect(o.run)
		end
		row.refresh = function() kb.Text = keyText(o.getKey()) end
		row.setOn = setOn
		table.insert(rows, row)
		return row
	end

	-- menu key row
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

	-- feature rows (called by Registry.add as features build)
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

	-- key presses drive features
	connect(UserInputService.InputBegan, function(i, processed)
		if processed or State.Listening or i.UserInputType ~= Enum.UserInputType.Keyboard then return end
		for _, h in pairs(Registry.built) do
			if h.key and h.key == i.KeyCode then
				if h.Run then h.Run() elseif h.Set then h.Set(not h.state) end
			end
		end
	end)

	-- setters used by the Appearance tab
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
	function Hud.ResetKeys() panel.Position = UDim2.new(0, 16, 0.5, 0) end

	applyStats()
	placeStats()
	relayout()
end

--------------------------------------------------------------------------------
-- APPEARANCE TAB (call it LAST in the loader)
--------------------------------------------------------------------------------
function Lib:BuildAppearance()
	local Window = Registry.window
	local look = Window:AddTab("Appearance")
	local F, S, K, L = UI.fx, UI.stats, UI.keys, UI.look
	local function pct(x) return math.floor(x * 100 + 0.5) end

	-- left column
	local colors = look:AddSection("Theme & Colors", "Left")
	local themeDD = colors:AddDropdown({ Name = "Theme", Options = Lib.ThemeNames, Default = State.Theme, Search = true, Callback = function(n) Window:SetTheme(n) end })
	colors:AddThemeGallery({ Callback = function(n) Window:SetTheme(n) end })
	Window:OnThemeChanged(function(n) themeDD.Set(n, true) end)
	local useCustom = State.BaseAccent ~= nil
	local customColor = State.BaseAccent or Color3.fromRGB(180, 90, 255)
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
	local menuKey = Enum.KeyCode.RightShift
	if K.menu ~= "" then
		local ok, k = pcall(function() return Enum.KeyCode[K.menu] end)
		if ok and k then menuKey = k end
	end
	winSec:AddKeybind({ Name = "Toggle menu", Default = menuKey, Callback = function(k) Window:SetKey(k) end })

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

	local keySec = look:AddSection("Keybind Panel", "Left")
	keySec:AddToggle({ Name = "Show keybind panel", Desc = "Click or press keys to run features", Default = K.on, Callback = function(v) Hud.SetKeys("on", v) end })
	keySec:AddToggle({ Name = "Show unbound features", Default = K.showUnbound, Callback = function(v) Hud.SetKeys("showUnbound", v) end })
	keySec:AddSlider({ Name = "Visible rows", Min = 4, Max = 16, Default = K.maxRows, Callback = function(v) Hud.SetKeys("maxRows", v) end })
	keySec:AddSlider({ Name = "Scale", Min = 60, Max = 150, Default = pct(K.scale), Step = 5, Suffix = "%", Callback = function(v) Hud.SetKeys("scale", v / 100) end })
	keySec:AddSlider({ Name = "Opacity", Min = 20, Max = 100, Default = pct(K.opacity), Step = 5, Suffix = "%", Callback = function(v) Hud.SetKeys("opacity", v / 100) end })
	keySec:AddButton({ Name = "Reset position", Callback = function() Hud.ResetKeys() end })

	-- right column
	local fxSec = look:AddSection("Screen Effects", "Right")
	fxSec:AddToggle({ Name = "Enable effects", Default = F.on, Callback = function(v) FX.Set("on", v) end })
	fxSec:AddToggle({ Name = "Only while menu is open", Desc = "Fades out when the hub is minimized", Default = F.menuOnly, Callback = function(v) FX.Set("menuOnly", v) end })
	fxSec:AddDropdown({ Name = "Style", Options = Lib.StyleNames, Default = F.style, Search = true, Callback = function(n) FX.Set("style", n) end })
	fxSec:AddDropdown({ Name = "Colors", Options = { "Style", "Theme" }, Default = F.tint, Callback = function(n) FX.Set("tint", n) end })
	fxSec:AddSlider({ Name = "Opacity", Min = 0, Max = 100, Default = pct(F.opacity), Suffix = "%", Callback = function(v) FX.Set("opacity", v / 100) end })
	fxSec:AddSlider({ Name = "Density", Min = 20, Max = 300, Default = pct(F.density), Step = 10, Suffix = "%", Callback = function(v) FX.Set("density", v / 100) end })
	fxSec:AddSlider({ Name = "Speed", Min = 20, Max = 300, Default = pct(F.speed), Step = 10, Suffix = "%", Callback = function(v) FX.Set("speed", v / 100) end })
	fxSec:AddToggle({ Name = "Decorations", Desc = "Moon, bats, aurora, light rays, grid...", Default = F.deco, Callback = function(v) FX.Set("deco", v) end })
	fxSec:AddToggle({ Name = "Lightning", Desc = "Storm flashes (Halloween / Neon Rain)", Default = F.lightning, Callback = function(v) FX.Set("lightning", v) end })
	fxSec:AddToggle({ Name = "Vignette", Default = F.vignette, Callback = function(v) FX.Set("vignette", v) end })
	fxSec:AddSlider({ Name = "Vignette strength", Min = 0, Max = 100, Default = pct(F.vignetteStrength), Suffix = "%", Callback = function(v) FX.Set("vignetteStrength", v / 100) end })
	fxSec:AddSlider({ Name = "Fade time", Min = 10, Max = 150, Default = pct(F.fade), Step = 5, Suffix = "%", Callback = function(v) FX.Set("fade", v / 100) end })

	local cursorSec = look:AddSection("Cursor Effects", "Right")
	cursorSec:AddToggle({ Name = "Cursor trail", Desc = "Glowing accent trail while the menu is open", Default = F.trail, Callback = function(v) FX.Set("trail", v) end })
	cursorSec:AddToggle({ Name = "Click burst", Desc = "Particle pop on every click", Default = F.burst, Callback = function(v) FX.Set("burst", v) end })

	local launcherSec = look:AddSection("Launcher", "Right")
	local lLetter, lSize = "S", Lib.IsMobile and 60 or 52
	launcherSec:AddTextbox({ Name = "Letter", Default = "S", Placeholder = "S", MaxLength = 2, Callback = function(t)
		if t ~= "" then lLetter = t; Window:SetLauncher(lLetter, lSize) end
	end })
	launcherSec:AddSlider({ Name = "Size", Min = 36, Max = 84, Default = lSize, Suffix = "px", Callback = function(v)
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
end

--------------------------------------------------------------------------------
-- FEATURE REGISTRY (extends the core Registry)
--   Registry.built = keybind-panel handles keyed by Name (core)
--   Registry.feats = registered features keyed by Id (this block)
-- Features queue up before Mount; after Mount they build instantly.
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

	-- settings: sliders / dropdowns / toggles / textboxes, values land in h.values[Key]
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

	Registry.add(h) -- keybind panel row + saved bind
	if h.Set and saved.on then h.Set(true) end
end

-- def = { Id, Name, Apply(on, values, handle), Tab, TabIcon, Section, Side, Desc, Icon,
--         Kind = "toggle" | "button", Settings = { {Type, Key, ...} } }
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

-- drive a feature from code / admin commands
function Lib:SetFeature(id, on)
	local h = Registry.feats[id]
	if not h then return false end
	if h.Run then h.Run() elseif h.Set then h.Set(on) end
	return true
end

-- window + FX + HUD + queued features
function Lib:Mount(cfg)
	cfg = cfg or {}
	Lib:LoadConfig()
	table.clear(Registry.tabs); table.clear(Registry.sections); table.clear(Registry.feats)
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
	return w
end

return Lib -- must be the last line of the core file
