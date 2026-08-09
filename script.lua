local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local GuiParent = (gethui and gethui()) or CoreGui

pcall(function() 
    local old = GuiParent:FindFirstChild("NexusHub")
    if old then old:Destroy() end
end)

local Config = {WalkSpeed=16,JumpPower=50,InfJump=false,Noclip=false,FOV=90,FOVLocked=true,AntiAFK=true,AmbientBackup=game.Lighting.Ambient}

local function GetHum() 
    local c = LocalPlayer.Character 
    return c and c:FindFirstChildOfClass("Humanoid") 
end

local sg = Instance.new("ScreenGui")
sg.Name = "NexusHub"
sg.ResetOnSpawn = false
sg.Parent = GuiParent

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 400, 0, 380)
Main.Position = UDim2.new(0.5, -200, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(30, 15, 50)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = sg

local uic = Instance.new("UICorner")
uic.CornerRadius = UDim.new(0, 10)
uic.Parent = Main

local st = Instance.new("UIStroke")
st.Color = Color3.fromRGB(200, 100, 255)
st.Thickness = 2
st.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Nexus Hub | Bomb Tag"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 30, 0, 25)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14
Close.TextColor3 = Color3.new(1, 1, 1)
Close.BorderSizePixel = 0
Close.Parent = Main
local cuic = Instance.new("UICorner")
cuic.CornerRadius = UDim.new(0, 5)
cuic.Parent = Close
Close.MouseButton1Click:Connect(function() sg:Destroy() end)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -50)
Scroll.Position = UDim2.new(0, 10, 0, 40)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.ScrollBarThickness = 3
Scroll.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.Parent = Scroll

local function AddToggle(name, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -5, 0, 40)
    f.BackgroundColor3 = Color3.fromRGB(45, 25, 70)
    f.BorderSizePixel = 0
    f.Parent = Scroll
    local fuic = Instance.new("UICorner") fuic.CornerRadius = UDim.new(0, 6) fuic.Parent = f
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -60, 1, 0)
    l.Position = UDim2.new(0, 15, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = name
    l.Font = Enum.Font.Gotham
    l.TextSize = 13
    l.TextColor3 = Color3.new(1, 1, 1)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 35, 0, 18)
    b.Position = UDim2.new(1, -45, 0.5, -9)
    b.BackgroundColor3 = def and Color3.fromRGB(170, 80, 255) or Color3.fromRGB(60, 40, 80)
    b.Text = ""
    b.BorderSizePixel = 0
    b.Parent = f
    local buic = Instance.new("UICorner") buic.CornerRadius = UDim.new(1, 0) buic.Parent = b
    local state = def
    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(170, 80, 255) or Color3.fromRGB(60, 40, 80)
        cb(state)
    end)
end

local function AddSlider(name, min, max, def, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -5, 0, 50)
    f.BackgroundColor3 = Color3.fromRGB(45, 25, 70)
    f.BorderSizePixel = 0
    f.Parent = Scroll
    local fuic = Instance.new("UICorner") fuic.CornerRadius = UDim.new(0, 6) fuic.Parent = f
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -60, 0, 25)
    l.Position = UDim2.new(0, 15, 0, 3)
    l.BackgroundTransparency = 1
    l.Text = name
    l.Font = Enum.Font.Gotham
    l.TextSize = 13
    l.TextColor3 = Color3.new(1, 1, 1)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
    local v = Instance.new("TextLabel")
    v.Size = UDim2.new(0, 50, 0, 25)
    v.Position = UDim2.new(1, -55, 0, 3)
    v.BackgroundTransparency = 1
    v.Text = tostring(def)
    v.Font = Enum.Font.GothamBold
    v.TextSize = 13
    v.TextColor3 = Color3.fromRGB(200, 100, 255)
    v.Parent = f
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -30, 0, 5)
    bar.Position = UDim2.new(0, 15, 0, 35)
    bar.BackgroundColor3 = Color3.fromRGB(60, 40, 80)
    bar.Parent = f
    local buic = Instance.new("UICorner") buic.CornerRadius = UDim.new(1, 0) buic.Parent = bar
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(170, 80, 255)
    fill.Parent = bar
    local fuic2 = Instance.new("UICorner") fuic2.CornerRadius = UDim.new(1, 0) fuic2.Parent = fill
    local drag = false
    bar.InputBegan:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end 
    end)
    UserInput.InputEnded:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end 
    end)
    UserInput.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local p = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max-min) * p)
            fill.Size = UDim2.new(p, 0, 1, 0)
            v.Text = tostring(val)
            cb(val)
        end
    end)
end

AddSlider("WalkSpeed", 16, 200, 16, function(v) 
    Config.WalkSpeed = v 
    local h = GetHum() 
    if h then h.WalkSpeed = v end 
end)
AddSlider("JumpPower", 50, 300, 50, function(v) 
    Config.JumpPower = v 
    local h = GetHum() 
    if h then h.JumpPower = v end 
end)
AddSlider("FOV", 70, 120, 90, function(v) 
    Config.FOV = v 
    Camera.FieldOfView = v 
end)
AddToggle("Lock FOV", true, function(v) Config.FOVLocked = v end)
AddToggle("Infinite Jump", false, function(v) Config.InfJump = v end)
AddToggle("Noclip", false, function(v) Config.Noclip = v end)
AddToggle("Fullbright", false, function(v)
    if v then
        game.Lighting.Ambient = Color3.new(1, 1, 1)
        game.Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        game.Lighting.ColorShift_Top = Color3.new(1, 1, 1)
    else
        game.Lighting.Ambient = Config.AmbientBackup
    end
end)
AddToggle("Anti-AFK", true, function(v) Config.AntiAFK = v end)

UserInput.JumpRequest:Connect(function()
    if Config.InfJump then 
        local h = GetHum() 
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end 
    end
end)

UserInput.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightShift then 
        Main.Visible = not Main.Visible 
    end
end)

LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end
end)

RunService.RenderStepped:Connect(function()
    if Config.FOVLocked and Camera.FieldOfView ~= Config.FOV then 
        Camera.FieldOfView = Config.FOV 
    end
    if Config.Noclip then
        local c = LocalPlayer.Character
        if c then
            for _, v in pairs(c:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    local h = char:WaitForChild("Humanoid")
    task.wait(0.3)
    h.WalkSpeed = Config.WalkSpeed
    h.JumpPower = Config.JumpPower
end)

game.StarterGui:SetCore("SendNotification", {Title = "Nexus Hub", Text = "Loaded! RightShift = hide", Duration = 5})
