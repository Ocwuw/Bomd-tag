local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local GuiParent = (gethui and gethui()) or CoreGui

local old = GuiParent:FindFirstChild("NexusHub")
if old then old:Destroy() end

local Config = {WalkSpeed=16,JumpPower=50,InfJump=false,Noclip=false,FOV=90,FOVLocked=true,AntiAFK=true,AmbientBackup=game.Lighting.Ambient}

local function GetHum() local c=LocalPlayer.Character return c and c:FindFirstChildOfClass("Humanoid") end

local sg = Instance.new("ScreenGui", GuiParent)
sg.Name = "NexusHub"
sg.ResetOnSpawn = false

local Main = Instance.new("Frame", sg)
Main.Size = UDim2.new(0, 400, 0, 380)
Main.Position = UDim2.new(0.5, -200, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(30, 15, 50)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local st = Instance.new("UIStroke", Main)
st.Color = Color3.fromRGB(200, 100, 255)
st.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Nexus Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.new(1,1,1)
Title.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 25)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14
Close.TextColor3 = Color3.new(1,1,1)
Close.BorderSizePixel = 0
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 5)
Close.MouseButton1Click:Connect(function() sg:Destroy() end)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -20, 1, -50)
Scroll.Position = UDim2.new(0, 10, 0, 40)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollBarThickness = 3
local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 6)

local function AddToggle(name, def, cb)
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(1, -5, 0, 40)
    f.BackgroundColor3 = Color3.fromRGB(45, 25, 70)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -60, 1, 0)
    l.Position = UDim2.new(0, 15, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.Font = Enum.Font.Gotham
    l.TextSize = 13
    l.TextColor3 = Color3.new(1,1,1)
    l.TextXAlignment = Enum.TextXAlignment.Left
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0, 35, 0, 18)
    b.Position = UDim2.new(1, -45, 0.5, -9)
    b.BackgroundColor3 = def and Color3.fromRGB(170, 80, 255) or Color3.fromRGB(60, 40, 80)
    b.Text = ""
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    local state = def
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(170, 80, 255) or Color3.fromRGB(60, 40, 80)
        cb(state)
    end)
end

local function AddSlider(name, min, max, def, cb)
    local f = Instance.new("Frame", Scroll)
    f.Size = UDim2.new(1, -5, 0, 50)
    f.BackgroundColor3 = Color3.fromRGB(45, 25, 70)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, -60, 0, 25)
    l.Position = UDim2.new(0, 15, 0, 3)
    l.BackgroundTransparency = 1
    l.Text = name
    l.Font = Enum.Font.Gotham
    l.TextSize = 13
    l.TextColor3 = Color3.new(1,1,1)
    l.TextXAlignment = Enum.TextXAlignment.Left
    local v = Instance.new("TextLabel", f)
    v.Size = UDim2.new(0, 50, 0, 25)
    v.Position = UDim2.new(1, -55, 0, 3)
    v.BackgroundTransparency = 1
    v.Text = tostring(def)
    v.Font = Enum.Font.GothamBold
    v.TextSize = 13
    v.TextColor3 = Color3.fromRGB(200, 100, 255)
    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(1, -30, 0, 5)
    bar.Position = UDim2.new(0, 15, 0, 35)
    bar.BackgroundColor3 = Color3.fromRGB(60, 40, 80)
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(170, 80, 255)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local drag = false
    bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 
