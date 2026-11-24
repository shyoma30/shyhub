-- number keypad 1-0 (mobile)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local parent = (gethui and gethui()) or game:GetService("CoreGui")
pcall(function()
    if parent:FindFirstChild("NumPad") then
        parent.NumPad:Destroy()
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "NumPad"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = parent

local keys = {
    {"1", Enum.KeyCode.One},   {"2", Enum.KeyCode.Two},
    {"3", Enum.KeyCode.Three}, {"4", Enum.KeyCode.Four},
    {"5", Enum.KeyCode.Five},  {"6", Enum.KeyCode.Six},
    {"7", Enum.KeyCode.Seven}, {"8", Enum.KeyCode.Eight},
    {"9", Enum.KeyCode.Nine},  {"0", Enum.KeyCode.Zero},
}

local SIZE, PAD, COLS = 46, 6, 5
local W = COLS * SIZE + (COLS + 1) * PAD
local H = 2 * SIZE + 3 * PAD

local frame = Instance.new("Frame")
frame.Name = "Background"
frame.Size = UDim2.fromOffset(W, H)
frame.Position = UDim2.new(0.5, -W / 2, 1, -H - 20)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
frame.BackgroundTransparency = 0.99
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- drag
local dragging, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then
        local delta = input.Position - dragStart

        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

local function press(keyCode)
    VIM:SendKeyEvent(true, keyCode, false, game)
    task.wait(0.03)
    VIM:SendKeyEvent(false, keyCode, false, game)
end

for index, key in ipairs(keys) do
    local col = (index - 1) % COLS
    local row = math.floor((index - 1) / COLS)

    local button = Instance.new("TextButton")
    button.Name = key[1]
    button.Size = UDim2.fromOffset(SIZE, SIZE)
    button.Position = UDim2.fromOffset(
        PAD + col * (SIZE + PAD),
        PAD + row * (SIZE + PAD)
    )
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    button.BackgroundTransparency = 0.99
    button.BorderSizePixel = 0
    button.Text = key[1]
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 22
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = true
    button.Parent = frame

    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

    button.MouseButton1Click:Connect(function()
        task.spawn(press, key[2])
    end)
end
