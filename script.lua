--// Kloud Hub 3D Menu (Copy of source)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local GuiParent = (gethui and gethui()) or game:GetService("CoreGui")

pcall(function() 
    local old = GuiParent:FindFirstChild("3D_Menu_GUI") 
    if old then old:Destroy() end 
end)

local gui = Instance.new("ScreenGui")
gui.Name = "3D_Menu_GUI"
gui.ResetOnSpawn = false
gui.Parent = GuiParent

local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
end

local function stroke(obj)
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(0, 140, 255)
    s.Thickness = 1.5
    s.Parent = obj
end

-- Main
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 700, 0, 420)
main.Position = UDim2.new(.5, -350, .5, -210)
main.BackgroundColor3 = Color3.fromRGB(12, 15, 20)
main.Active = true
main.Draggable = true
main.Parent = gui

corner(main, 16)
stroke(main)

-- Top buttons
local tabs = {"Name", "Play", "Settings", "Credits", "Store"}

for i, v in ipairs(tabs) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 110, 0, 35)
    b.Position = UDim2.new(0, (i-1)*120+20, 0, 15)
    b.Text = v
    b.TextColor3 = Color3.fromRGB(220, 230, 255)
    b.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.BorderSizePixel = 0
    b.Parent = main
    corner(b, 8)
end

-- Left panel
local left = Instance.new("Frame")
left.Size = UDim2.new(0, 180, 0, 300)
left.Position = UDim2.new(0, 20, 0, 70)
left.BackgroundColor3 = Color3.fromRGB(18, 22, 30)
left.BorderSizePixel = 0
left.Parent = main
corner(left, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "Update Log"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = left

local items = {"Visuals", "Camera", "Effects", "Misc"}

for i, v in ipairs(items) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(.85, 0, 0, 40)
    b.Position = UDim2.new(.075, 0, 0, i*50)
    b.Text = v
    b.TextColor3 = Color3.fromRGB(220, 230, 255)
    b.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.BorderSizePixel = 0
    b.Parent = left
    corner(b, 8)
end

-- Right panel
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 450, 0, 300)
panel.Position = UDim2.new(0, 230, 0, 70)
panel.BackgroundColor3 = Color3.fromRGB(18, 22, 30)
panel.BorderSizePixel = 0
panel.Parent = main
corner(panel, 12)

local head = Instance.new("TextLabel")
head.Size = UDim2.new(1, 0, 0, 45)
head.Text = "Visuals"
head.TextColor3 = Color3.fromRGB(255, 255, 255)
head.BackgroundTransparency = 1
head.Font = Enum.Font.GothamBold
head.TextSize = 22
head.Parent = panel

-- Fake toggles
local options = {"Bloom", "Color Correction", "Depth Of Field", "Motion Blur", "Camera Smooth"}

for i, v in ipairs(options) do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(.9, 0, 0, 40)
    row.Position = UDim2.new(.05, 0, 0, i*45+20)
    row.BackgroundColor3 = Color3.fromRGB(25, 30, 40)
    row.BorderSizePixel = 0
    row.Parent = panel
    corner(row, 8)
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(.7, 0, 1, 0)
    txt.Position = UDim2.new(0, 15, 0, 0)
    txt.Text = v
    txt.TextColor3 = Color3.fromRGB(230, 240, 255)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.Gotham
    txt.TextSize = 14
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.Parent = row
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 45, 0, 22)
    toggle.Position = UDim2.new(.82, 0, .2, 0)
    toggle.Text = ""
    toggle.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    toggle.BorderSizePixel = 0
    toggle.Parent = row
    corner(toggle, 20)
end

-- Close
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 35, 0, 35)
close.Position = UDim2.new(1, -45, 0, 10)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(100, 30, 40)
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.BorderSizePixel = 0
close.Parent = main
corner(close, 8)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
