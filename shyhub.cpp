local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ============ CONFIG ============
local CONFIG = {
    FOV = 500,
    Smoothness = 0.2,
    LockPart = "Head",
    AutoFire = false,
    AutoEquip = true,
    FireDelay = 0.08,
    FastShot = false,
    FastBurst = 3,
    InmateHostileOnly = true,
    RangeThreshold = 60,
    AutoCuff = true,            -- Guards: auto-cuff after tasing
    TaserHoldTime = 1.2,        -- seconds to hold taser before switching to cuffs
    CuffAttempts = 8,           -- number of cuff activate attempts
    CuffAttemptDelay = 0.15,
    
    -- PC SPECIFIC CONFIG --
    ToggleKey = Enum.KeyCode.T,         -- Key to toggle Aimlock
    HideUIKey = Enum.KeyCode.RightShift -- Key to hide/show UI
}

local WEAPON_RANK = {
    ["remington"] = 100,
    ["ak47"] = 90, ["ak-47"] = 90,
    ["mp5"] = 80,
    ["m9"] = 70,
    ["pistol"] = 50,
    ["taser"] = 45,
    ["cuff"] = 10,
    ["gun"] = 40,
}

local AimEnabled = false
local TargetMode = "Inmates"
local CurrentTarget = nil
local Highlight = nil
local CurrentEquipped = nil
local LastFireTime = 0

-- Cuff state
local CuffPhase = false           -- true while in cuff sequence
local CuffTargetPlayer = nil
local CuffStartTime = 0

-- ============ EXECUTOR FLAG ============
local EXEC_FLAGS = {}
local LAST_POS = {}
task.spawn(function()
    while true do
        task.wait(1)
        for _, plr in pairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local hum = char:FindFirstChildOfClass("Humanoid")
                local last = LAST_POS[plr]
                if hum and hum.WalkSpeed > 40 then EXEC_FLAGS[plr] = true end
                if last and (root.Position - last).Magnitude > 60 then EXEC_FLAGS[plr] = true end
                LAST_POS[plr] = root.Position
            end
        end
    end
end)
Players.PlayerRemoving:Connect(function(plr) EXEC_FLAGS[plr]=nil LAST_POS[plr]=nil end)
local function isFlagged(plr) return EXEC_FLAGS[plr] == true end

-- ============ HOSTILE ============
local function isHostile(plr)
    local char = plr.Character
    if not char then return false end
    for _, t in pairs(char:GetChildren()) do
        if t:IsA("Tool") and not t.Name:lower():find("cuff") then
            return true
        end
    end
    return false
end

-- ============ TEAM ============
local function getTeamName(plr)
    if not plr.Team then return "Neutral" end
    return plr.Team.Name
end
local function isGuard(plr) return getTeamName(plr) == "Guards" end

local function matchesMode(plr)
    if plr == LocalPlayer then return false end
    local myTeam = getTeamName(LocalPlayer)
    local theirTeam = getTeamName(plr)
    if myTeam == theirTeam then return false end
    if theirTeam == "Neutral" then return false end
    if TargetMode == "Inmates" then
        if theirTeam ~= "Inmates" then return false end
        if CONFIG.InmateHostileOnly and not isHostile(plr) then return false end
        return true
    elseif TargetMode == "Criminals" then
        return theirTeam == "Criminals"
    elseif TargetMode == "Guards" then
        return theirTeam == "Guards"
    end
    return false
end

-- ============ HELPERS ============
local function isAlive(plr)
    local char = plr.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end
local function getLockPart(plr)
    local char = plr.Character
    if not char then return nil end
    return char:FindFirstChild(CONFIG.LockPart) or char:FindFirstChild("HumanoidRootPart")
end
local function getWeaponRank(name)
    local n = name:lower()
    for k, r in pairs(WEAPON_RANK) do
        if n:find(k) then return r end
    end
    return 0
end

local function findToolByKeyword(keyword)
    local char = LocalPlayer.Character
    if char then
        for _, t in pairs(char:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find(keyword) then return t end
        end
    end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, t in pairs(bp:GetChildren()) do
            if t:IsA("Tool") and t.Name:lower():find(keyword) then return t end
        end
    end
    return nil
end

local function findBestGun()
    local order = {"remington","ak47","ak-47","mp5","m9","pistol","gun"}
    for _, kw in ipairs(order) do
        local t = findToolByKeyword(kw)
        if t then return t end
    end
    return nil
end

local function equipTool(tool)
    if not tool then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if tool.Parent == char then return end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if not bp then return end
    for _, t in pairs(char:GetChildren()) do
        if t:IsA("Tool") then t.Parent = bp end
    end
    tool.Parent = char
    pcall(function() hum:EquipTool(tool) end)
    CurrentEquipped = tool
end

local function pickWeaponForDistance(dist)
    if dist > CONFIG.RangeThreshold then
        return findToolByKeyword("mp5")
            or findToolByKeyword("m9")
            or findToolByKeyword("ak47")
            or findToolByKeyword("ak-47")
            or findBestGun()
    else
        if isGuard(LocalPlayer) then
            local taser = findToolByKeyword("taser")
            if taser then return taser end
            local rem = findToolByKeyword("remington")
            if rem then return rem end
            local m9 = findToolByKeyword("m9")
            if m9 then return m9 end
            return findBestGun()
        else
            local rem = findToolByKeyword("remington")
            if rem then return rem end
            local m9 = findToolByKeyword("m9")
            if m9 then return m9 end
            return findBestGun()
        end
    end
end

local function getEquippedGun()
    local char = LocalPlayer.Character
    if not char then return nil end
    local best, bestRank = nil, 0
    for _, t in pairs(char:GetChildren()) do
        if t:IsA("Tool") then
            local r = getWeaponRank(t.Name)
            if r > bestRank then bestRank = r; best = t end
        end
    end
    return best
end

local function getNearestEnemy()
    local closest, shortest = nil, CONFIG.FOV
    for _, plr in pairs(Players:GetPlayers()) do
        if matchesMode(plr) and isAlive(plr) then
            local part = getLockPart(plr)
            if part then
                local d = (Camera.CFrame.Position - part.Position).Magnitude
                if d < shortest then shortest = d; closest = plr end
            end
        end
    end
    return closest, shortest
end

-- ============ HIGHLIGHT ============
local function clearHighlight()
    if Highlight then Highlight:Destroy() Highlight = nil end
end
local function applyHighlight(plr)
    clearHighlight()
    if not plr or not plr.Character then return end
    local h = Instance.new("Highlight")
    h.Name = "AimHL"
    h.FillColor = isFlagged(plr) and Color3.fromRGB(255, 200, 0) or Color3.fromRGB(255, 60, 60)
    h.OutlineColor = Color3.fromRGB(255, 255, 255)
    h.FillTransparency = 0.5
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee = plr.Character
    h.Parent = plr.Character
    Highlight = h
end

-- ============ AIM ============
local function aimAt(part)
    local c = Camera.CFrame
    local d = CFrame.new(c.Position, part.Position)
    Camera.CFrame = c:Lerp(d, 1 - CONFIG.Smoothness)
end

-- ============ SHOOT ============
local function autoShot()
    if CONFIG.AutoFire ~= true then return end
    if AimEnabled ~= true then return end
    local gun = getEquippedGun()
    if not gun then return end
    if CONFIG.FastShot == true then
        for i = 1, CONFIG.FastBurst do
            pcall(function() gun:Activate() end)
        end
    else
        local now = tick()
        if now - LastFireTime < CONFIG.FireDelay then return end
        LastFireTime = now
        pcall(function() gun:Activate() end)
    end
end

-- ============ AUTO CUFF SEQUENCE (Guards only) ============
local function startCuffSequence(targetPlr)
    if not CONFIG.AutoCuff then return end
    if not isGuard(LocalPlayer) then return end
    local team = getTeamName(targetPlr)
    if team ~= "Inmates" and team ~= "Criminals" then return end
    -- Only if we actually have handcuffs
    local cuffs = findToolByKeyword("cuff")
    if not cuffs then return end
    CuffPhase = true
    CuffTargetPlayer = targetPlr
    CuffStartTime = tick()
end

local function updateCuffSequence()
    if not CuffPhase then return end
    if not CuffTargetPlayer or not isAlive(CuffTargetPlayer) then
        CuffPhase = false; CuffTargetPlayer = nil; return
    end
    if tick() - CuffStartTime < CONFIG.TaserHoldTime then return end

    -- Ensure cuffs equipped
    local cuffs = findToolByKeyword("cuff")
    if not cuffs then CuffPhase = false; CuffTargetPlayer = nil; return end

    if cuffs.Parent ~= LocalPlayer.Character then
        equipTool(cuffs)
    end

    -- Attempt to activate cuffs on target (spam a few times)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- Aim at target head/root and activate
    local part = getLockPart(CuffTargetPlayer)
    if part then
        local c = Camera.CFrame
        Camera.CFrame = CFrame.new(c.Position, part.Position)
    end

    task.spawn(function()
        for i = 1, CONFIG.CuffAttempts do
            if not CuffPhase then break end
            pcall(function() cuffs:Activate() end)
            task.wait(CONFIG.CuffAttemptDelay)
        end
        CuffPhase = false
        CuffTargetPlayer = nil
    end)
end

-- ============ MAIN LOOP ============
RunService.RenderStepped:Connect(function()
    if not AimEnabled or not isAlive(LocalPlayer) then
        clearHighlight(); CurrentTarget = nil; return
    end

    -- If cuffing, keep aiming and skip normal weapon logic
    if CuffPhase then
        updateCuffSequence()
        if CuffTargetPlayer then
            local part = getLockPart(CuffTargetPlayer)
            if part then aimAt(part) end
        end
        return
    end

    local t, dist = getNearestEnemy()
    if t then
        local part = getLockPart(t)
        if part then
            aimAt(part)
            if CurrentTarget ~= t then
                CurrentTarget = t
                applyHighlight(t)
            end
            local want = pickWeaponForDistance(dist)
            if want then equipTool(want) end
            autoShot()

            -- Taser check for Guards
            if isGuard(LocalPlayer) then
                local equipped = getEquippedGun()
                if equipped and equipped.Name:lower():find("taser") then
                    startCuffSequence(t)
                end
            end
        end
    else
        clearHighlight(); CurrentTarget = nil
    end
end)

-- ============ UI ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimlockDelta"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 240, 0, 344)
Main.Position = UDim2.new(0.5, -120, 0.5, -172)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui
local MC = Instance.new("UICorner")
MC.CornerRadius = UDim.new(0, 14)
MC.Parent = Main

local MStroke = Instance.new("UIStroke")
MStroke.Color = Color3.fromRGB(255, 70, 70)
MStroke.Thickness = 1.5
MStroke.Transparency = 0.3
MStroke.Parent = Main

local Glow = Instance.new("Frame")
Glow.Size = UDim2.new(1, 16, 1, 16)
Glow.Position = UDim2.new(0, -8, 0, -8)
Glow.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
Glow.BackgroundTransparency = 0.85
Glow.BorderSizePixel = 0
Glow.ZIndex = -1
Glow.Parent = Main
local GC = Instance.new("UICorner")
GC.CornerRadius = UDim.new(0, 18)
GC.Parent = Glow

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
Header.BorderSizePixel = 0
Header.Parent = Main
local HC = Instance.new("UICorner")
HC.CornerRadius = UDim.new(0, 14)
HC.Parent = Header
local HCover = Instance.new("Frame")
HCover.Size = UDim2.new(1, 0, 0, 16)
HCover.Position = UDim2.new(0, 0, 1, -16)
HCover.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
HCover.BorderSizePixel = 0
HCover.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -16, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Aimlock - DELTA - ..."
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Dot = Instance.new("Frame")
Dot.Size = UDim2.new(0, 10, 0, 10)
Dot.Position = UDim2.new(1, -22, 0.5, -5)
Dot.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
Dot.BorderSizePixel = 0
Dot.Parent = Header
local DC = Instance.new("UICorner")
DC.CornerRadius = UDim.new(1, 0)
DC.Parent = Dot

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -24, 0, 18)
Status.Position = UDim2.new(0, 12, 0, 46)
Status.BackgroundTransparency = 1
Status.Text = "Inactive (Press "..CONFIG.ToggleKey.Name..")"
Status.TextColor3 = Color3.fromRGB(160, 160, 175)
Status.TextSize = 11
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Main

local ModeLabel = Instance.new("TextLabel")
ModeLabel.Size = UDim2.new(1, -24, 0, 16)
ModeLabel.Position = UDim2.new(0, 12, 0, 68)
ModeLabel.BackgroundTransparency = 1
ModeLabel.Text = "TARGET"
ModeLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
ModeLabel.TextSize = 10
ModeLabel.Font = Enum.Font.GothamBold
ModeLabel.TextXAlignment = Enum.TextXAlignment.Left
ModeLabel.Parent = Main

local modes = {"Inmates", "Criminals", "Guards"}
local modeButtons = {}
local grid = Instance.new("Frame")
grid.Size = UDim2.new(1, -24, 0, 30)
grid.Position = UDim2.new(0, 12, 0, 86)
grid.BackgroundTransparency = 1
grid.Parent = Main
local gl = Instance.new("UIGridLayout")
gl.CellSize = UDim2.new(0.333, -4, 0, 26)
gl.CellPadding = UDim2.new(0, 6, 0, 6)
gl.SortOrder = Enum.SortOrder.LayoutOrder
gl.Parent = grid

for _, name in ipairs(modes) do
    local b = Instance.new("TextButton")
    b.BackgroundColor3 = Color3.fromRGB(34, 34, 42)
    b.BorderSizePixel = 0
    b.Text = name
    b.TextColor3 = Color3.fromRGB(200, 200, 215)
    b.TextSize = 11
    b.Font = Enum.Font.GothamMedium
    b.Parent = grid
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = b
    modeButtons[name] = b
    b.MouseButton1Click:Connect(function()
        TargetMode = name
        for n, btn in pairs(modeButtons) do
            local active = (n == name)
            btn.BackgroundColor3 = active and Color3.fromRGB(255, 70, 70) or Color3.fromRGB(34, 34, 42)
            btn.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 215)
        end
        if AimEnabled then Status.Text = "Active — locking " .. TargetMode end
    end)
end
modeButtons["Inmates"].BackgroundColor3 = Color3.fromRGB(255, 70, 70)
modeButtons["Inmates"].TextColor3 = Color3.fromRGB(255, 255, 255)

local HostileToggle = Instance.new("TextButton")
HostileToggle.Size = UDim2.new(1, -24, 0, 26)
HostileToggle.Position = UDim2.new(0, 12, 0, 124)
HostileToggle.BackgroundColor3 = CONFIG.InmateHostileOnly and Color3.fromRGB(60, 200, 120) or Color3.fromRGB(45, 48, 54)
HostileToggle.BorderSizePixel = 0
HostileToggle.Text = "Inmate 💢 Hostile Only: " .. (CONFIG.InmateHostileOnly and "ON" or "OFF")
HostileToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
HostileToggle.TextSize = 11
HostileToggle.Font = Enum.Font.GothamMedium
HostileToggle.Parent = Main
local HTC = Instance.new("UICorner")
HTC.CornerRadius = UDim.new(0, 6)
HTC.Parent = HostileToggle
HostileToggle.MouseButton1Click:Connect(function()
    CONFIG.InmateHostileOnly = not CONFIG.InmateHostileOnly
    HostileToggle.Text = "Inmate 💢 Hostile Only: " .. (CONFIG.InmateHostileOnly and "ON" or "OFF")
    HostileToggle.BackgroundColor3 = CONFIG.InmateHostileOnly and Color3.fromRGB(60, 200, 120) or Color3.fromRGB(45, 48, 54)
end)

local AutoShotToggle = Instance.new("TextButton")
AutoShotToggle.Size = UDim2.new(1, -24, 0, 26)
AutoShotToggle.Position = UDim2.new(0, 12, 0, 156)
AutoShotToggle.BackgroundColor3 = CONFIG.AutoFire and Color3.fromRGB(60, 200, 120) or Color3.fromRGB(45, 48, 54)
AutoShotToggle.BorderSizePixel = 0
AutoShotToggle.Text = "Auto Shot: " .. (CONFIG.AutoFire and "ON" or "OFF")
AutoShotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoShotToggle.TextSize = 11
AutoShotToggle.Font = Enum.Font.GothamMedium
AutoShotToggle.Parent = Main
local ASTC = Instance.new("UICorner")
ASTC.CornerRadius = UDim.new(0, 6)
ASTC.Parent = AutoShotToggle
AutoShotToggle.MouseButton1Click:Connect(function()
    CONFIG.AutoFire = not CONFIG.AutoFire
    AutoShotToggle.Text = "Auto Shot: " .. (CONFIG.AutoFire and "ON" or "OFF")
    AutoShotToggle.BackgroundColor3 = CONFIG.AutoFire and Color3.fromRGB(60, 200, 120) or Color3.fromRGB(45, 48, 54)
end)

local FastToggle = Instance.new("TextButton")
FastToggle.Size = UDim2.new(1, -24, 0, 26)
FastToggle.Position = UDim2.new(0, 12, 0, 188)
FastToggle.BackgroundColor3 = CONFIG.FastShot and Color3.fromRGB(255, 160, 60) or Color3.fromRGB(45, 48, 54)
FastToggle.BorderSizePixel = 0
FastToggle.Text = "Fast Shot: " .. (CONFIG.FastShot and "ON" or "OFF")
FastToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FastToggle.TextSize = 11
FastToggle.Font = Enum.Font.GothamBold
FastToggle.Parent = Main
local FTC = Instance.new("UICorner")
FTC.CornerRadius = UDim.new(0, 6)
FTC.Parent = FastToggle
FastToggle.MouseButton1Click:Connect(function()
    CONFIG.FastShot = not CONFIG.FastShot
    FastToggle.Text = "Fast Shot: " .. (CONFIG.FastShot and "ON" or "OFF")
    FastToggle.BackgroundColor3 = CONFIG.FastShot and Color3.fromRGB(255, 160, 60) or Color3.fromRGB(45, 48, 54)
end)

local CuffToggle = Instance.new("TextButton")
CuffToggle.Size = UDim2.new(1, -24, 0, 26)
CuffToggle.Position = UDim2.new(0, 12, 0, 220)
CuffToggle.BackgroundColor3 = CONFIG.AutoCuff and Color3.fromRGB(60, 200, 120) or Color3.fromRGB(45, 48, 54)
CuffToggle.BorderSizePixel = 0
CuffToggle.Text = "Auto Cuff (Guards): " .. (CONFIG.AutoCuff and "ON" or "OFF")
CuffToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
CuffToggle.TextSize = 11
CuffToggle.Font = Enum.Font.GothamMedium
CuffToggle.Parent = Main
local CTC = Instance.new("UICorner")
CTC.CornerRadius = UDim.new(0, 6)
CTC.Parent = CuffToggle
CuffToggle.MouseButton1Click:Connect(function()
    CONFIG.AutoCuff = not CONFIG.AutoCuff
    CuffToggle.Text = "Auto Cuff (Guards): " .. (CONFIG.AutoCuff and "ON" or "OFF")
    CuffToggle.BackgroundColor3 = CONFIG.AutoCuff and Color3.fromRGB(60, 200, 120) or Color3.fromRGB(45, 48, 54)
end)

local BigBtn = Instance.new("TextButton")
BigBtn.Size = UDim2.new(1, -24, 0, 52)
BigBtn.Position = UDim2.new(0, 12, 0, 258)
BigBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
BigBtn.BorderSizePixel = 0
BigBtn.Text = "AIMLOCK: OFF ["..CONFIG.ToggleKey.Name.."]"
BigBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BigBtn.TextSize = 16
BigBtn.Font = Enum.Font.GothamBold
BigBtn.Parent = Main
local BC = Instance.new("UICorner")
BC.CornerRadius = UDim.new(0, 10)
BC.Parent = BigBtn

local BG = Instance.new("UIGradient")
BG.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 30, 60))
}
BG.Rotation = 90
BG.Parent = BigBtn

-- ============ TOGGLE LOGIC ============
local function ToggleAimlock()
    AimEnabled = not AimEnabled
    if AimEnabled then
        BigBtn.Text = "AIMLOCK: ON ["..CONFIG.ToggleKey.Name.."]"
        Status.Text = "Active — locking " .. TargetMode
        Status.TextColor3 = Color3.fromRGB(80, 240, 140)
        BG.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 240, 140)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 160, 90))
        }
        TweenService:Create(BigBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 220, 130)}):Play()
    else
        BigBtn.Text = "AIMLOCK: OFF ["..CONFIG.ToggleKey.Name.."]"
        Status.Text = "Inactive (Press "..CONFIG.ToggleKey.Name..")"
        Status.TextColor3 = Color3.fromRGB(160, 160, 175)
        BG.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 30, 60))
        }
        TweenService:Create(BigBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}):Play()
        clearHighlight()
        CuffPhase = false
        CuffTargetPlayer = nil
    end
end

BigBtn.MouseButton1Click:Connect(ToggleAimlock)

-- ============ PC KEYBINDS ============
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    -- Don't trigger if typing in chat
    if gameProcessed then return end 
    
    if input.KeyCode == CONFIG.ToggleKey then
        ToggleAimlock()
    elseif input.KeyCode == CONFIG.HideUIKey then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- ============ INFO LABELS ============
local WeaponInfo = Instance.new("TextLabel")
WeaponInfo.Size = UDim2.new(1, -24, 0, 14)
WeaponInfo.Position = UDim2.new(0, 12, 0, 316)
WeaponInfo.BackgroundTransparency = 1
WeaponInfo.Text = "Weapon: —"
WeaponInfo.TextColor3 = Color3.fromRGB(140, 140, 160)
WeaponInfo.TextSize = 10
WeaponInfo.Font = Enum.Font.Gotham
WeaponInfo.TextXAlignment = Enum.TextXAlignment.Left
WeaponInfo.Parent = Main

local TargetInfo = Instance.new("TextLabel")
TargetInfo.Size = UDim2.new(1, -24, 0, 14)
TargetInfo.Position = UDim2.new(0, 12, 0, 330)
TargetInfo.BackgroundTransparency = 1
TargetInfo.Text = "Target: —"
TargetInfo.TextColor3 = Color3.fromRGB(140, 140, 160)
TargetInfo.TextSize = 10
TargetInfo.Font = Enum.Font.Gotham
TargetInfo.TextXAlignment = Enum.TextXAlignment.Left
TargetInfo.Parent = Main

task.spawn(function()
    while true do
        task.wait(0.4)
        local role = getTeamName(LocalPlayer)
        Title.Text = "Aimlock - DELTA - " .. role
        if AimEnabled then
            local gun = getEquippedGun()
            local _, d = getNearestEnemy()
            local tag = ""
            if d then tag = d > CONFIG.RangeThreshold and " [LONG]" or " [CLOSE]" end
            if CuffPhase then
                WeaponInfo.Text = "Weapon: HANDCUFFS [CUFFING]"
            else
                WeaponInfo.Text = "Weapon: " .. (gun and gun.Name or "none") .. (CONFIG.FastShot and " [FAST]" or "") .. tag
            end
            if CurrentTarget then
                local flag = isFlagged(CurrentTarget) and " [EXEC]" or ""
                local hostile = isHostile(CurrentTarget) and " 💢" or ""
                TargetInfo.Text = "Target: " .. CurrentTarget.Name .. hostile .. flag
            else
                TargetInfo.Text = "Target: —"
            end
        else
            WeaponInfo.Text = "Weapon: —"
            TargetInfo.Text = "Target: —"
        end
    end
end)

-- ============ DRAG LOGIC (PC Optimized) ============
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then 
                dragging = false 
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X, 
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
