local Players = game.Players
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local GuiParent
if gethui then GuiParent = gethui() else GuiParent = game:GetService("CoreGui") end

pcall(function() 
    local old = GuiParent:FindFirstChild("KloudHub")
    if old then old:Destroy() end
end)

-- ============ ТЕМЫ ============
local Themes = {
    Default = {
        Bg = Color3.fromRGB(30, 15, 50),
        Panel = Color3.fromRGB(45, 25, 70),
        Panel2 = Color3.fromRGB(55, 30, 85),
        Accent = Color3.fromRGB(170, 80, 255),
        Glow = Color3.fromRGB(200, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(200, 180, 220),
        ToggleOff = Color3.fromRGB(60, 40, 80),
        Transparency = 0,
    },
    Green = {
        Bg = Color3.fromRGB(15, 40, 20),
        Panel = Color3.fromRGB(25, 55, 30),
        Panel2 = Color3.fromRGB(35, 70, 40),
        Accent = Color3.fromRGB(80, 255, 120),
        Glow = Color3.fromRGB(100, 255, 140),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(200, 220, 200),
        ToggleOff = Color3.fromRGB(40, 60, 45),
        Transparency = 0,
    },
    Red = {
        Bg = Color3.fromRGB(40, 15, 15),
        Panel = Color3.fromRGB(60, 25, 25),
        Panel2 = Color3.fromRGB(80, 35, 35),
        Accent = Color3.fromRGB(255, 60, 60),
        Glow = Color3.fromRGB(255, 100, 100),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(220, 200, 200),
        ToggleOff = Color3.fromRGB(70, 40, 40),
        Transparency = 0,
    },
    Black = {
        Bg = Color3.fromRGB(15, 15, 15),
        Panel = Color3.fromRGB(25, 25, 25),
        Panel2 = Color3.fromRGB(40, 40, 40),
        Accent = Color3.fromRGB(180, 180, 180),
        Glow = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(180, 180, 180),
        ToggleOff = Color3.fromRGB(50, 50, 50),
        Transparency = 0,
    },
    Transparent = {
        Bg = Color3.fromRGB(20, 10, 40),
        Panel = Color3.fromRGB(50, 30, 80),
        Panel2 = Color3.fromRGB(60, 40, 90),
        Accent = Color3.fromRGB(170, 80, 255),
        Glow = Color3.fromRGB(200, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(200, 180, 220),
        ToggleOff = Color3.fromRGB(60, 40, 80),
        Transparency = 0.4,
    },
    Aios = {
        Bg = Color3.fromRGB(0, 0, 0),
        Panel = Color3.fromRGB(10, 10, 10),
        Panel2 = Color3.fromRGB(25, 25, 25),
        Accent = Color3.fromRGB(255, 255, 255),
        Glow = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(200, 200, 200),
        ToggleOff = Color3.fromRGB(40, 40, 40),
        Transparency = 0.5,
    },
    Ocean = {
        Bg = Color3.fromRGB(10, 25, 50),
        Panel = Color3.fromRGB(20, 40, 75),
        Panel2 = Color3.fromRGB(30, 55, 95),
        Accent = Color3.fromRGB(80, 180, 255),
        Glow = Color3.fromRGB(100, 200, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(200, 220, 240),
        ToggleOff = Color3.fromRGB(40, 60, 90),
        Transparency = 0,
    },
    Sunset = {
        Bg = Color3.fromRGB(50, 20, 40),
        Panel = Color3.fromRGB(80, 35, 60),
        Panel2 = Color3.fromRGB(100, 50, 75),
        Accent = Color3.fromRGB(255, 140, 80),
        Glow = Color3.fromRGB(255, 180, 100),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(240, 210, 200),
        ToggleOff = Color3.fromRGB(90, 55, 70),
        Transparency = 0,
    },
}

local Colors = Themes.Default
local ThemedElements = {}

local Config = {
    -- Universal
    PlayerChams=false, PlayerESP=false, InfJump=false, Noclip=false,
    WalkSpeed=16, JumpPower=50, FOV=90, FOVLocked=true,
    Fullbright=false, RemoveFog=false, AntiAFK=true,
    -- Bomb Tag
    AutoDodgeBomb=false, AutoPassBomb=false,
    -- Theme
    CurrentTheme="Default",
}
Config.AmbientBackup = game:GetService("Lighting").Ambient
Config.FogEndBackup = game:GetService("Lighting").FogEnd

local function GetHum() 
    local c = LocalPlayer.Character 
    return c and c:FindFirstChildOfClass("Humanoid") 
end
local function GetRoot() 
    local c = LocalPlayer.Character 
    return c and c:FindFirstChild("HumanoidRootPart") 
end

local function HasBomb()
    local c = LocalPlayer.Character
    if not c then return false end
    for _, v in pairs(c:GetChildren()) do
        if v:IsA("Tool") and v.Name:lower():find("bomb") then return true end
    end
    for _, v in pairs(c:GetDescendants()) do
        if v.Name:lower():find("bomb") then return true end
    end
    return false
end

local function GetClosestPlayer()
    local closest, dist = nil, math.huge
    local root = GetRoot()
    if not root then return nil end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local pr = p.Character:FindFirstChild("HumanoidRootPart")
            local ph = p.Character:FindFirstChildOfClass("Humanoid")
            if pr and ph and ph.Health > 0 then
                local d = (root.Position - pr.Position).Magnitude
                if d < dist then dist = d closest = p end
            end
        end
    end
    return closest
end

local ChamsFolder = Instance.new("Folder")
ChamsFolder.Name = "KLOUD_Chams"
ChamsFolder.Parent = GuiParent

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "KLOUD_ESP"
ESPFolder.Parent = GuiParent

local function CreatePlayerCham(Plr)
    if not Plr or Plr == LocalPlayer then return end
    if not Plr.Character then return end
    local existing = ChamsFolder:FindFirstChild(Plr.Name)
    if existing then existing:Destroy() end
    local folder = Instance.new("Folder", ChamsFolder)
    folder.Name = Plr.Name
    for _, v in pairs(Plr.Character:GetChildren()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = v.Size
            box.Adornee = v
            box.AlwaysOnTop = true
            box.ZIndex = 5
            box.Transparency = 0.3
            box.Color3 = Colors.Accent
            box.Parent = folder
        end
    end
    local hum = Plr.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Died:Connect(function()
            local f = ChamsFolder:FindFirstChild(Plr.Name)
            if f then f:Destroy() end
        end)
    end
end

local function RemovePlayerCham(Plr)
    local f = ChamsFolder:FindFirstChild(Plr.Name)
    if f then f:Destroy() end
end

local function CreatePlayerESP(Plr)
    if not Plr or Plr == LocalPlayer then return end
    if not Plr.Character then return end
    local head = Plr.Character:FindFirstChild("Head")
    if not head then return end
    local existing = ESPFolder:FindFirstChild(Plr.Name)
    if existing then existing:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Adornee = head
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 100, 0, 30)
    bb.StudsOffset = Vector3.new(0, 2, 0)
    bb.Name = Plr.Name
    bb.Parent = ESPFolder
    local tl = Instance.new("TextLabel", bb)
    tl.BackgroundTransparency = 1
    tl.Size = UDim2.new(1, 0, 1, 0)
    tl.Text = Plr.Name
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 14
    tl.TextColor3 = Colors.Accent
    tl.TextStrokeTransparency = 0.3
    local hum = Plr.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Died:Connect(function()
            local f = ESPFolder:FindFirstChild(Plr.Name)
            if f then f:Destroy() end
        end)
    end
end

local function RemovePlayerESP(Plr)
    local f = ESPFolder:FindFirstChild(Plr.Name)
    if f then f:Destroy() end
end

local function SetupCharAdded(Plr)
    if Plr == LocalPlayer then return end
    Plr.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart", 10)
        task.wait(1)
        if Config.PlayerChams then CreatePlayerCham(Plr) end
        if Config.PlayerESP then CreatePlayerESP(Plr) end
    end)
    Plr.CharacterRemoving:Connect(function()
        RemovePlayerCham(Plr)
        RemovePlayerESP(Plr)
    end)
end

for _, p in pairs(Players:GetPlayers()) do SetupCharAdded(p) end
Players.PlayerAdded:Connect(function(p) SetupCharAdded(p) end)
Players.PlayerRemoving:Connect(function(p) 
    RemovePlayerCham(p) 
    RemovePlayerESP(p) 
end)

local function SetFullbright(state)
    local lt = game:GetService("Lighting")
    if state then
        lt.Ambient = Color3.new(1,1,1)
        lt.ColorShift_Bottom = Color3.new(1,1,1)
        lt.ColorShift_Top = Color3.new(1,1,1)
    else
        lt.Ambient = Config.AmbientBackup
    end
end

local function SetRemoveFog(state)
    local lt = game:GetService("Lighting")
    if state then lt.FogEnd = 100000 else lt.FogEnd = Config.FogEndBackup end
end

-- ============ UI ============
local sg = Instance.new("ScreenGui")
sg.Name = "KloudHub"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = GuiParent

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 620, 0, 420)
Main.Position = UDim2.new(0.5, -310, 0.5, -210)
Main.BackgroundColor3 = Colors.Bg
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = sg
ThemedElements[Main] = "Bg"

local mc = Instance.new("UICorner", Main) mc.CornerRadius = UDim.new(0, 10)
local glow = Instance.new("UIStroke", Main)
glow.Color = Colors.Glow
glow.Thickness = 2
glow.Transparency = 0.3
ThemedElements[glow] = "Glow_Stroke"

local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Kloud Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextColor3 = Colors.Text
Title.TextXAlignment = Enum.TextXAlignment.Left
ThemedElements[Title] = "Text_Label"

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 25)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22
CloseBtn.TextColor3 = Colors.TextDim
CloseBtn.AutoButtonColor = false
CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255,70,70)}):Play() end)
CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Colors.TextDim}):Play() end)

local ReopenBtn = Instance.new("TextButton", sg)
ReopenBtn.Size = UDim2.new(0, 80, 0, 35)
ReopenBtn.Position = UDim2.new(0, 20, 0, 100)
ReopenBtn.BackgroundColor3 = Colors.Bg
ReopenBtn.Text = "Kloud"
ReopenBtn.Font = Enum.Font.GothamBold
ReopenBtn.TextSize = 14
ReopenBtn.TextColor3 = Colors.Text
ReopenBtn.BorderSizePixel = 0
ReopenBtn.Visible = false
ReopenBtn.Active = true
ReopenBtn.Draggable = true
ReopenBtn.AutoButtonColor = false
local rbc = Instance.new("UICorner", ReopenBtn) rbc.CornerRadius = UDim.new(0, 8)
local rbs = Instance.new("UIStroke", ReopenBtn)
rbs.Color = Colors.Glow
rbs.Thickness = 2
rbs.Transparency = 0.3
ThemedElements[ReopenBtn] = "Bg"
ThemedElements[rbs] = "Glow_Stroke"

local MinArrow = Instance.new("TextButton", sg)
MinArrow.Size = UDim2.new(0, 25, 0, 40)
MinArrow.Position = UDim2.new(0, 0, 0.5, -20)
MinArrow.BackgroundColor3 = Colors.Bg
MinArrow.Text = "<"
MinArrow.Font = Enum.Font.GothamBold
MinArrow.TextSize = 18
MinArrow.TextColor3 = Colors.Text
MinArrow.BorderSizePixel = 0
MinArrow.AutoButtonColor = false
local mac = Instance.new("UICorner", MinArrow) mac.CornerRadius = UDim.new(0, 6)
local mas = Instance.new("UIStroke", MinArrow)
mas.Color = Colors.Glow
mas.Thickness = 2
mas.Transparency = 0.3
ThemedElements[MinArrow] = "Bg"
ThemedElements[mas] = "Glow_Stroke"

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 145, 1, -50)
Sidebar.Position = UDim2.new(0, 10, 0, 45)
Sidebar.BackgroundTransparency = 1
local SL = Instance.new("UIListLayout", Sidebar)
SL.Padding = UDim.new(0, 4)

local ContentTitle = Instance.new("TextLabel", Main)
ContentTitle.Size = UDim2.new(1, -180, 0, 35)
ContentTitle.Position = UDim2.new(0, 170, 0, 45)
ContentTitle.BackgroundTransparency = 1
ContentTitle.Text = "Universal"
ContentTitle.Font = Enum.Font.GothamBold
ContentTitle.TextSize = 22
ContentTitle.TextColor3 = Colors.Text
ContentTitle.TextXAlignment = Enum.TextXAlignment.Left
ThemedElements[ContentTitle] = "Text_Label"

local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(1, -180, 1, -95)
Content.Position = UDim2.new(0, 170, 0, 85)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.ScrollBarThickness = 3
Content.ScrollBarImageColor3 = Colors.Accent
local CL = Instance.new("UIListLayout", Content)
CL.Padding = UDim.new(0, 8)

local Tabs = {}
local CurrentTab = nil

local function ClearContent()
    for k in pairs(ThemedElements) do
        if k and k.Parent and k:IsDescendantOf(Content) then
            ThemedElements[k] = nil
        end
    end
    for _, v in pairs(Content:GetChildren()) do
        if not v:IsA("UIListLayout") then v:Destroy() end
    end
end

local function AddToggle(name, default, callback)
    local frame = Instance.new("Frame", Content)
    frame.Size = UDim2.new(1, -5, 0, 45)
    frame.BackgroundColor3 = Colors.Panel
    frame.BackgroundTransparency = Colors.Transparency
    frame.BorderSizePixel = 0
    ThemedElements[frame] = "Panel"
    local fc = Instance.new("UICorner", frame) fc.CornerRadius = UDim.new(0, 6)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Position = UDim2.new(0, 15, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = Colors.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    ThemedElements[lbl] = "Text_Label"
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -55, 0.5, -10)
    btn.BackgroundColor3 = default and Colors.Accent or Colors.ToggleOff
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    local bc = Instance.new("UICorner", btn) bc.CornerRadius = UDim.new(1, 0)
    local dot = Instance.new("Frame", btn)
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    dot.BackgroundColor3 = Colors.Text
    dot.BorderSizePixel = 0
    local dc = Instance.new("UICorner", dot) dc.CornerRadius = UDim.new(1, 0)
    local state = default
    ThemedElements[btn] = state and "Accent" or "ToggleOff"
    btn.MouseButton1Click:Connect(function()
        state = not state
        ThemedElements[btn] = state and "Accent" or "ToggleOff"
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = state and Colors.Accent or Colors.ToggleOff}):Play()
        TweenService:Create(dot, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        callback(state)
    end)
end

local function AddSlider(name, min, max, default, callback)
    local frame = Instance.new("Frame", Content)
    frame.Size = UDim2.new(1, -5, 0, 55)
    frame.BackgroundColor3 = Colors.Panel
    frame.BackgroundTransparency = Colors.Transparency
    frame.BorderSizePixel = 0
    ThemedElements[frame] = "Panel"
    local fc = Instance.new("UICorner", frame) fc.CornerRadius = UDim.new(0, 6)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -70, 0, 25)
    lbl.Position = UDim2.new(0, 15, 0, 5)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = Colors.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    ThemedElements[lbl] = "Text_Label"
    local val = Instance.new("TextLabel", frame)
    val.Size = UDim2.new(0, 50, 0, 25)
    val.Position = UDim2.new(1, -65, 0, 5)
    val.BackgroundTransparency = 1
    val.Text = tostring(default)
    val.Font = Enum.Font.GothamBold
    val.TextSize = 14
    val.TextColor3 = Colors.Accent
    val.TextXAlignment = Enum.TextXAlignment.Right
    ThemedElements[val] = "Text_Accent"
    local bar = Instance.new("Frame", frame)
    bar.Size = UDim2.new(1, -30, 0, 5)
    bar.Position = UDim2.new(0, 15, 0, 35)
    bar.BackgroundColor3 = Colors.ToggleOff
    bar.BorderSizePixel = 0
    ThemedElements[bar] = "ToggleOff"
    local bc = Instance.new("UICorner", bar) bc.CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Colors.Accent
    fill.BorderSizePixel = 0
    ThemedElements[fill] = "Accent"
    local flc = Instance.new("UICorner", fill) flc.CornerRadius = UDim.new(1, 0)
    local dragging = false
    bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    UserInput.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInput.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local v = math.floor(min + (max-min) * pos)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            val.Text = tostring(v)
            callback(v)
        end
    end)
end

local function AddButton(name, callback)
    local btn = Instance.new("TextButton", Content)
    btn.Size = UDim2.new(1, -5, 0, 40)
    btn.BackgroundColor3 = Colors.Panel
    btn.BackgroundTransparency = Colors.Transparency
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Colors.Text
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    ThemedElements[btn] = "Panel"
    local bc = Instance.new("UICorner", btn) bc.CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
end

local function AddDropdown(name, options, default, callback)
    local frame = Instance.new("Frame", Content)
    frame.Size = UDim2.new(1, -5, 0, 45)
    frame.BackgroundColor3 = Colors.Panel
    frame.BackgroundTransparency = Colors.Transparency
    frame.BorderSizePixel = 0
    ThemedElements[frame] = "Panel"
    local fc = Instance.new("UICorner", frame) fc.CornerRadius = UDim.new(0, 6)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 15, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = Colors.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    ThemedElements[lbl] = "Text_Label"
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.5, -20, 0, 25)
    btn.Position = UDim2.new(0.5, 5, 0.5, -12)
    btn.BackgroundColor3 = Colors.Panel2
    btn.Text = default .. " ▼"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextColor3 = Colors.Text
    btn.BorderSizePixel = 0
    ThemedElements[btn] = "Panel2"
    local bc = Instance.new("UICorner", btn) bc.CornerRadius = UDim.new(0, 4)
    local idx = 1
    for i, v in pairs(options) do if v == default then idx = i end end
    btn.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #options then idx = 1 end
        btn.Text = options[idx] .. " ▼"
        callback(options[idx])
    end)
end

local function AddTab(name, icon, contentFunc)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Colors.Panel
    btn.BackgroundTransparency = 1
    btn.Text = "   " .. icon .. "  " .. name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextColor3 = Colors.TextDim
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    local bc = Instance.new("UICorner", btn) bc.CornerRadius = UDim.new(0, 6)
    Tabs[name] = {btn = btn, func = contentFunc}
    btn.MouseButton1Click:Connect(function()
        if CurrentTab then
            local ct = Tabs[CurrentTab]
            ct.btn.BackgroundTransparency = 1
            ct.btn.TextColor3 = Colors.TextDim
            ThemedElements[ct.btn] = nil
        end
        CurrentTab = name
        btn.BackgroundTransparency = Colors.Transparency
        btn.BackgroundColor3 = Colors.Panel
        btn.TextColor3 = Colors.Text
        ThemedElements[btn] = "Panel_Active"
        ContentTitle.Text = name
        ClearContent()
        contentFunc()
    end)
end

-- ============ ПРИМЕНИТЬ ТЕМУ ============
local function ApplyTheme()
    for elem, kind in pairs(ThemedElements) do
        if elem and elem.Parent then
            pcall(function()
                if kind == "Bg" then
                    elem.BackgroundColor3 = Colors.Bg
                    if elem:IsA("Frame") or elem:IsA("TextButton") then
                        elem.BackgroundTransparency = 0
                    end
                elseif kind == "Panel" then
                    elem.BackgroundColor3 = Colors.Panel
                    elem.BackgroundTransparency = Colors.Transparency
                elseif kind == "Panel_Active" then
                    elem.BackgroundColor3 = Colors.Panel
                    elem.BackgroundTransparency = Colors.Transparency
                    elem.TextColor3 = Colors.Text
                elseif kind == "Panel2" then
                    elem.BackgroundColor3 = Colors.Panel2
                elseif kind == "Accent" then
                    elem.BackgroundColor3 = Colors.Accent
                elseif kind == "ToggleOff" then
                    elem.BackgroundColor3 = Colors.ToggleOff
                elseif kind == "Text_Label" then
                    elem.TextColor3 = Colors.Text
                elseif kind == "Text_Accent" then
                    elem.TextColor3 = Colors.Accent
                elseif kind == "Glow_Stroke" then
                    elem.Color = Colors.Glow
                end
            end)
        end
    end
    Main.BackgroundColor3 = Colors.Bg
    ReopenBtn.BackgroundColor3 = Colors.Bg
    MinArrow.BackgroundColor3 = Colors.Bg
    glow.Color = Colors.Glow
    rbs.Color = Colors.Glow
    mas.Color = Colors.Glow
    Title.TextColor3 = Colors.Text
    ContentTitle.TextColor3 = Colors.Text
    Content.ScrollBarImageColor3 = Colors.Accent
end

local function ChangeTheme(themeName)
    if Themes[themeName] then
        Colors = Themes[themeName]
        Config.CurrentTheme = themeName
        ApplyTheme()
    end
end

-- ============ ВКЛАДКИ ============
AddTab("Universal", "🌐", function()
    AddToggle("Player Chams", Config.PlayerChams, function(v)
        Config.PlayerChams = v
        if v then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then CreatePlayerCham(p) end
            end
        else
            for _, p in pairs(Players:GetPlayers()) do RemovePlayerCham(p) end
        end
    end)
    AddToggle("Player ESP (Names)", Config.PlayerESP, function(v)
        Config.PlayerESP = v
        if v then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then CreatePlayerESP(p) end
            end
        else
            for _, p in pairs(Players:GetPlayers()) do RemovePlayerESP(p) end
        end
    end)
    AddSlider("WalkSpeed", 16, 200, Config.WalkSpeed, function(v)
        Config.WalkSpeed = v
        local h = GetHum() if h then h.WalkSpeed = v end
    end)
    AddSlider("JumpPower", 50, 300, Config.JumpPower, function(v)
        Config.JumpPower = v
        local h = GetHum() if h then h.JumpPower = v end
    end)
    AddSlider("FOV", 70, 120, Config.FOV, function(v)
        Config.FOV = v
        Camera.FieldOfView = v
    end)
    AddToggle("Lock FOV", Config.FOVLocked, function(v) Config.FOVLocked = v end)
    AddToggle("Infinite Jump", Config.InfJump, function(v) Config.InfJump = v end)
    AddToggle("Noclip", Config.Noclip, function(v) Config.Noclip = v end)
end)

AddTab("Misc", "≡", function()
    AddToggle("Fullbright", Config.Fullbright, function(v) Config.Fullbright = v SetFullbright(v) end)
    AddToggle("Remove Fog", Config.RemoveFog, function(v) Config.RemoveFog = v SetRemoveFog(v) end)
    AddDropdown("Theme", {"Default","Green","Red","Black","Transparent","Aios","Ocean","Sunset"}, Config.CurrentTheme, function(t)
        ChangeTheme(t)
    end)
end)

AddTab("Trap", "△", function()
    AddToggle("Auto Pass Bomb", Config.AutoPassBomb, function(v) Config.AutoPassBomb = v end)
    AddToggle("Auto Dodge Bomb", Config.AutoDodgeBomb, function(v) Config.AutoDodgeBomb = v end)
end)

AddTab("Server", "≣", function()
    AddButton("Rejoin", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end)
    AddToggle("Anti AFK", Config.AntiAFK, function(v) Config.AntiAFK = v end)
end)

AddTab("Settings", "⚙", function()
    AddButton("Destroy GUI", function()
        sg:Destroy()
        ChamsFolder:Destroy()
        ESPFolder:Destroy()
        SetFullbright(false)
        SetRemoveFog(false)
        Camera.FieldOfView = 70
        local h = GetHum()
        if h then h.WalkSpeed = 16 h.JumpPower = 50 end
    end)
end)

task.wait(0.1)
Tabs["Universal"].btn.BackgroundTransparency = 0
Tabs["Universal"].btn.BackgroundColor3 = Colors.Panel
Tabs["Universal"].btn.TextColor3 = Colors.Text
ThemedElements[Tabs["Universal"].btn] = "Panel_Active"
CurrentTab = "Universal"
Tabs["Universal"].func()

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    MinArrow.Visible = false
    ReopenBtn.Visible = true
end)

ReopenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    MinArrow.Visible = true
    ReopenBtn.Visible = false
    MinArrow.Text = "<"
end)

MinArrow.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    MinArrow.Text = Main.Visible and "<" or ">"
end)

UserInput.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if Main.Visible then
            Main.Visible = false
            MinArrow.Visible = false
            ReopenBtn.Visible = true
        else
            Main.Visible = true
            MinArrow.Visible = true
            ReopenBtn.Visible = false
            MinArrow.Text = "<"
        end
    end
end)

UserInput.JumpRequest:Connect(function()
    if Config.InfJump then
        local h = GetHum() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

task.spawn(function()
    while task.wait(0.15) do
        if Config.AutoPassBomb and HasBomb() then
            local target = GetClosestPlayer()
            local root = GetRoot()
            if target and target.Character and root then
                local tr = target.Character:FindFirstChild("HumanoidRootPart")
                if tr then
                    pcall(function()
                        local targetPos = tr.Position
                        local myPos = targetPos + (tr.CFrame.LookVector * 3)
                        root.CFrame = CFrame.new(myPos, targetPos)
                    end)
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if Config.AutoDodgeBomb and not HasBomb() then
            local root = GetRoot()
            if root then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj.Name:lower():find("bomb") then
                        local d = (root.Position - obj.Position).Magnitude
                        if d < 15 then
                            local away = (root.Position - obj.Position).Unit * 30
                            root.CFrame = CFrame.new(root.Position + away)
                            break
                        end
                    end
                end
            end
        end
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

pcall(function()
    game.StarterGui:SetCore("SendNotification", {Title = "Kloud Hub", Text = "Loaded! RightShift = hide", Duration = 5})
end)
