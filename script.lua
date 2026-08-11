-- 🟣 Deft Universal v2.5 | Delta + Solara | Mobile Support
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local injector = "Unknown"
if identifyexecutor then
    local exec = identifyexecutor():lower()
    if exec:find("solara") then injector = "Solara"
    elseif exec:find("delta") then injector = "Delta"
    elseif exec:find("codex") then injector = "Codex"
    elseif exec:find("hydrogen") then injector = "Hydrogen"
    elseif exec:find("krnl") then injector = "Krnl"
    elseif exec:find("fluxus") then injector = "Fluxus"
    elseif exec:find("scriptware") then injector = "Script-Ware"
    elseif exec:find("xeno") then injector = "Xeno"
    else injector = identifyexecutor() end
end

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

pcall(function()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        local old1 = pg:FindFirstChild("DeftUniversal") if old1 then old1:Destroy() end
        local old2 = pg:FindFirstChild("InfoOverlay") if old2 then old2:Destroy() end
    end
end)

-- ============ CONFIG ============
local Config = {
    -- Visuals
    ESP = false,
    Chams = false,
    Tracers = false,
    TracerColor = Color3.fromRGB(140, 100, 255),
    TracerDuration = 3,
    TracerStyle = "Purple",
    PlayerTracers = false,
    -- Aimbot
    SilentAim = false,
    AimPart = "Head",
    -- Misc
    SpeedGlitch = false,
    BoostValue = 35,
    AutoJump = false,
    Fly = false,
    FlySpeed = 50,
    Noclip = false,
    WalkSpeed = 16,
    JumpPower = 50,
    AntiAFK = true,
}

-- ============ INFO OVERLAY ============
local InfoGUI = Instance.new("ScreenGui")
InfoGUI.Name = "InfoOverlay"
InfoGUI.Parent = LocalPlayer:WaitForChild("PlayerGui")
InfoGUI.ResetOnSpawn = false

local InfoFrame = Instance.new("Frame")
InfoFrame.Size = UDim2.new(0, 180, 0, 40)
InfoFrame.Position = UDim2.new(1, -190, 0, 10)
InfoFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
InfoFrame.BackgroundTransparency = 0.3
InfoFrame.BorderSizePixel = 0
InfoFrame.Parent = InfoGUI

local Chip = Instance.new("TextLabel")
Chip.Size = UDim2.new(0, 20, 0, 20)
Chip.Position = UDim2.new(0, 8, 0, 10)
Chip.BackgroundTransparency = 1
Chip.Text = "⬡"
Chip.TextColor3 = Color3.fromRGB(140, 100, 255)
Chip.Font = Enum.Font.SourceSansBold
Chip.TextSize = 16
Chip.Parent = InfoFrame

local InjectorLabel = Instance.new("TextLabel")
InjectorLabel.Size = UDim2.new(0, 60, 0, 20)
InjectorLabel.Position = UDim2.new(0, 32, 0, 4)
InjectorLabel.BackgroundTransparency = 1
InjectorLabel.Text = injector
InjectorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InjectorLabel.Font = Enum.Font.SourceSansBold
InjectorLabel.TextSize = 11
InjectorLabel.TextXAlignment = Enum.TextXAlignment.Left
InjectorLabel.Parent = InfoFrame

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(0, 45, 0, 20)
FPSLabel.Position = UDim2.new(0, 32, 0, 18)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS: 0"
FPSLabel.TextColor3 = Color3.fromRGB(140, 100, 255)
FPSLabel.Font = Enum.Font.SourceSansBold
FPSLabel.TextSize = 10
FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
FPSLabel.Parent = InfoFrame

local PingLabel = Instance.new("TextLabel")
PingLabel.Size = UDim2.new(0, 50, 0, 20)
PingLabel.Position = UDim2.new(0, 90, 0, 18)
PingLabel.BackgroundTransparency = 1
PingLabel.Text = "PING: 0"
PingLabel.TextColor3 = Color3.fromRGB(140, 100, 255)
PingLabel.Font = Enum.Font.SourceSansBold
PingLabel.TextSize = 10
PingLabel.TextXAlignment = Enum.TextXAlignment.Left
PingLabel.Parent = InfoFrame

local lastTime = tick()
local frames = 0
RunService.RenderStepped:Connect(function()
    frames = frames + 1
    if tick() - lastTime >= 0.5 then
        local fps = math.floor(frames / (tick() - lastTime))
        FPSLabel.Text = "FPS: " .. fps
        pcall(function()
            local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            PingLabel.Text = "PING: " .. math.floor(ping)
        end)
        frames = 0
        lastTime = tick()
    end
end)

-- ============ ESP / CHAMS ============
local function CreateESP(player)
    if not player or player == LocalPlayer or not player.Character then return end
    if player.Character:FindFirstChild("DeftESP") then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "DeftESP"
    highlight.FillColor = Color3.fromRGB(140, 100, 255)
    highlight.FillTransparency = 0.75
    highlight.OutlineColor = Color3.fromRGB(140, 100, 255)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = player.Character
end

local function RemoveESP(player)
    if player and player.Character then
        local h = player.Character:FindFirstChild("DeftESP")
        if h then h:Destroy() end
    end
end

local function CreateChams(player)
    if not player or player == LocalPlayer or not player.Character then return end
    if player.Character:FindFirstChild("DeftChams") then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "DeftChams"
    highlight.FillColor = Color3.fromRGB(140, 100, 255)
    highlight.FillTransparency = 0.4
    highlight.OutlineColor = Color3.new(1,1,1)
    highlight.OutlineTransparency = 0.3
    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    highlight.Parent = player.Character
end

local function RemoveChams(player)
    if player and player.Character then
        local h = player.Character:FindFirstChild("DeftChams")
        if h then h:Destroy() end
    end
end

-- Auto refresh при респавне
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        p.CharacterAdded:Connect(function(char)
            char:WaitForChild("HumanoidRootPart", 10)
            task.wait(1)
            if Config.ESP then CreateESP(p) end
            if Config.Chams then CreateChams(p) end
        end)
    end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart", 10)
        task.wait(1)
        if Config.ESP then CreateESP(p) end
        if Config.Chams then CreateChams(p) end
    end)
end)

-- ============ BULLET TRACERS (улучшенные) ============
local TracerFolder = Instance.new("Folder")
TracerFolder.Name = "DeftTracers"
TracerFolder.Parent = workspace

local TracerColors = {
    Purple = Color3.fromRGB(140, 100, 255),
    Red = Color3.fromRGB(255, 60, 60),
    Blue = Color3.fromRGB(60, 120, 255),
    Green = Color3.fromRGB(60, 255, 120),
    White = Color3.fromRGB(255, 255, 255),
    Cyan = Color3.fromRGB(0, 255, 255),
    Pink = Color3.fromRGB(255, 100, 200),
    Rainbow = "rainbow",
}

local function CreateBulletTracer(origin, endPos)
    local tracer = Instance.new("Part")
    tracer.Name = "Tracer"
    tracer.Anchored = true
    tracer.CanCollide = false
    tracer.CastShadow = false
    tracer.Material = Enum.Material.Neon
    tracer.Transparency = 0
    
    local color = TracerColors[Config.TracerStyle] or Config.TracerColor
    if color == "rainbow" then
        tracer.Color = Color3.fromHSV(math.random(), 1, 1)
    else
        tracer.Color = color
    end
    
    local distance = (endPos - origin).Magnitude
    tracer.Size = Vector3.new(0.1, 0.1, distance)
    tracer.CFrame = CFrame.new(origin, endPos) * CFrame.new(0, 0, -distance/2)
    tracer.Parent = TracerFolder
    
    -- Плавное затухание
    local tween = TweenService:Create(tracer, TweenInfo.new(Config.TracerDuration, Enum.EasingStyle.Linear), {
        Transparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function()
        tracer:Destroy()
    end)
end

-- Хук на выстрел из оружия
local function GetWeaponMuzzle()
    local char = LocalPlayer.Character
    if not char then return nil end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return nil end
    -- Ищем handle или muzzle attachment
    local muzzle = tool:FindFirstChild("Muzzle", true) 
        or tool:FindFirstChild("Barrel", true)
        or tool:FindFirstChild("Handle")
    if muzzle then
        if muzzle:IsA("Attachment") then
            return muzzle.WorldPosition
        elseif muzzle:IsA("BasePart") then
            return muzzle.Position
        end
    end
    return nil
end

local function GetShotEndPosition()
    -- Точка куда смотрит мышка/камера
    local target = Mouse.Target
    if target and Mouse.Hit then
        return Mouse.Hit.Position
    end
    -- Иначе просто вперёд из камеры на 300 стад
    return Camera.CFrame.Position + Camera.CFrame.LookVector * 300
end

-- Отлавливаем выстрелы через Tool.Activated
local function HookTool(tool)
    if not tool:IsA("Tool") then return end
    tool.Activated:Connect(function()
        if Config.Tracers then
            task.wait() -- ждём кадр
            local origin = GetWeaponMuzzle()
            if origin then
                local endPos = GetShotEndPosition()
                CreateBulletTracer(origin, endPos)
            end
        end
    end)
end

-- Хукаем все инструменты
if LocalPlayer:FindFirstChild("Backpack") then
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        HookTool(tool)
    end
    LocalPlayer.Backpack.ChildAdded:Connect(HookTool)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(item)
        if item:IsA("Tool") then HookTool(item) end
    end)
end)

if LocalPlayer.Character then
    for _, item in ipairs(LocalPlayer.Character:GetChildren()) do
        if item:IsA("Tool") then HookTool(item) end
    end
end

-- ============ SILENT AIM ============
local function GetClosestPlayer()
    local closest = nil
    local shortestDist = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild(Config.AimPart)
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if head and hum and hum.Health > 0 then
                local sp, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(sp.X, sp.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

-- ============ MOVEMENT ============
local function GetHum() local c = LocalPlayer.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function GetRoot() local c = LocalPlayer.Character return c and c:FindFirstChild("HumanoidRootPart") end

local flyBV, flyBG
local function StartFly()
    local root = GetRoot() if not root then return end
    flyBV = Instance.new("BodyVelocity", root)
    flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBV.Velocity = Vector3.new(0, 0, 0)
    flyBG = Instance.new("BodyGyro", root)
    flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBG.P = 1000
end

local function StopFly()
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end
end

RunService.RenderStepped:Connect(function()
    -- Fly
    if Config.Fly and flyBV and flyBG then
        local cam = Camera.CFrame
        local move = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
        flyBV.Velocity = move * Config.FlySpeed
        flyBG.CFrame = cam
    end
    -- Silent Aim
    if Config.SilentAim and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local target = GetClosestPlayer()
        if target and target.Character then
            local part = target.Character:FindFirstChild(Config.AimPart)
            if part then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if Config.Noclip then
        local c = LocalPlayer.Character
        if c then
            for _, v in ipairs(c:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
            end
        end
    end
end)

-- Speed Glitch
local speedConn
local function StartSpeedGlitch()
    if speedConn then return end
    speedConn = RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        local moveDir = hum.MoveDirection.Magnitude > 0 and hum.MoveDirection.Unit or Vector3.new()
        local jumping = UserInputService:IsKeyDown(Enum.KeyCode.Space) or hum.Jump
        if jumping and hum.FloorMaterial ~= Enum.Material.Air then
            local boost = moveDir * Config.BoostValue
            root.Velocity = Vector3.new(root.Velocity.X + boost.X, 45, root.Velocity.Z + boost.Z)
        end
        if hum.FloorMaterial == Enum.Material.Air and moveDir.Magnitude > 0 then
            local air = moveDir * 2.5
            root.Velocity = Vector3.new(root.Velocity.X + air.X, root.Velocity.Y, root.Velocity.Z + air.Z)
        end
        local maxSpeed = 150
        local hSpeed = Vector3.new(root.Velocity.X, 0, root.Velocity.Z).Magnitude
        if hSpeed > maxSpeed then
            local scale = maxSpeed / hSpeed
            root.Velocity = Vector3.new(root.Velocity.X * scale, root.Velocity.Y, root.Velocity.Z * scale)
        end
    end)
end

local function StopSpeedGlitch()
    if speedConn then speedConn:Disconnect() speedConn = nil end
end

-- Auto Jump
local autoJumpRunning = false
local function StartAutoJump()
    if autoJumpRunning then return end
    autoJumpRunning = true
    task.spawn(function()
        while autoJumpRunning do
            local hum = GetHum()
            if hum and hum.FloorMaterial ~= Enum.Material.Air then
                hum.Jump = true
            end
            task.wait(0.05)
        end
    end)
end

local function StopAutoJump()
    autoJumpRunning = false
end

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end
end)

-- Обновляем скорость после респавна
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    task.wait(0.3)
    hum.WalkSpeed = Config.WalkSpeed
    hum.JumpPower = Config.JumpPower
    if Config.Fly then StopFly() task.wait(0.5) StartFly() end
end)-- ============ MAIN GUI ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeftUniversal"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, isMobile and 260 or 240, 0, isMobile and 400 or 360)
MainFrame.Position = UDim2.new(0.5, -120, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.BackgroundTransparency = 0.1
MainFrame.Parent = ScreenGui

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, isMobile and 34 or 28)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TitleBar.BackgroundTransparency = 0.1
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "deft v2.5"
Title.TextColor3 = Color3.fromRGB(140, 100, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = isMobile and 17 or 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, isMobile and 34 or 28, 1, 0)
CloseButton.Position = UDim2.new(1, -28, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
CloseButton.BackgroundTransparency = 0.1
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(140, 100, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = isMobile and 20 or 18
CloseButton.Parent = TitleBar

-- Reopen button
local ReopenBtn = Instance.new("TextButton")
ReopenBtn.Size = UDim2.new(0, 70, 0, 28)
ReopenBtn.Position = UDim2.new(0, 15, 0, 100)
ReopenBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
ReopenBtn.BackgroundTransparency = 0.2
ReopenBtn.Text = "⬡ deft"
ReopenBtn.TextColor3 = Color3.fromRGB(140, 100, 255)
ReopenBtn.Font = Enum.Font.SourceSansBold
ReopenBtn.TextSize = 13
ReopenBtn.BorderSizePixel = 0
ReopenBtn.Visible = false
ReopenBtn.Active = true
ReopenBtn.Draggable = true
ReopenBtn.Parent = ScreenGui

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ReopenBtn.Visible = true
end)

ReopenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ReopenBtn.Visible = false
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
        ReopenBtn.Visible = not MainFrame.Visible
    end
end)

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, 0, 0, isMobile and 36 or 30)
TabContainer.Position = UDim2.new(0, 0, 0, isMobile and 34 or 28)
TabContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabContainer.BackgroundTransparency = 0.1
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local ContentArea = Instance.new("ScrollingFrame")
ContentArea.Size = UDim2.new(1, 0, 1, -(isMobile and 70 or 58))
ContentArea.Position = UDim2.new(0, 0, 0, isMobile and 70 or 58)
ContentArea.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
ContentArea.BackgroundTransparency = 0.1
ContentArea.BorderSizePixel = 0
ContentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentArea.ScrollBarThickness = 3
ContentArea.ScrollBarImageColor3 = Color3.fromRGB(140, 100, 255)
ContentArea.Parent = MainFrame

local function createTab(name, position)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0.33, 0, 1, 0)
    tab.Position = UDim2.new(position, 0, 0, 0)
    tab.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    tab.BackgroundTransparency = 0.1
    tab.BorderSizePixel = 0
    tab.Text = name
    tab.TextColor3 = Color3.fromRGB(120, 120, 120)
    tab.Font = Enum.Font.SourceSansSemiBold
    tab.TextSize = isMobile and 14 or 12
    tab.Parent = TabContainer
    return tab
end

local visualTab = createTab("VISUALS", 0)
local aimTab = createTab("AIMBOT", 0.33)
local miscTab = createTab("MISC", 0.66)

local function setActiveTab(tab)
    for _, t in pairs(TabContainer:GetChildren()) do
        if t:IsA("TextButton") then t.TextColor3 = Color3.fromRGB(120, 120, 120) end
    end
    tab.TextColor3 = Color3.fromRGB(140, 100, 255)
end

-- ============ HELPERS для GUI ============
local function ClearContent()
    for _, v in ipairs(ContentArea:GetChildren()) do
        if not v:IsA("UIListLayout") then v:Destroy() end
    end
end

local function AddToggle(name, default, callback)
    local frame = Instance.new("Frame", ContentArea)
    frame.Size = UDim2.new(1, -24, 0, isMobile and 36 or 32)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = "  " .. name
    btn.TextColor3 = default and Color3.fromRGB(140, 100, 255) or Color3.fromRGB(140, 140, 140)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = isMobile and 15 or 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    
    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0, 8, 1, -16)
    indicator.Position = UDim2.new(1, -18, 0, 8)
    indicator.BackgroundColor3 = default and Color3.fromRGB(140, 100, 255) or Color3.fromRGB(60, 60, 60)
    indicator.BorderSizePixel = 0
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.TextColor3 = state and Color3.fromRGB(140, 100, 255) or Color3.fromRGB(140, 140, 140)
        indicator.BackgroundColor3 = state and Color3.fromRGB(140, 100, 255) or Color3.fromRGB(60, 60, 60)
        callback(state)
    end)
end

local function AddSlider(name, min, max, default, callback)
    local frame = Instance.new("Frame", ContentArea)
    frame.Size = UDim2.new(1, -24, 0, isMobile and 46 or 42)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -50, 0, 20)
    label.Position = UDim2.new(0, 8, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(140, 140, 140)
    label.Font = Enum.Font.SourceSans
    label.TextSize = isMobile and 14 or 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local bar = Instance.new("Frame", frame)
    bar.Size = UDim2.new(1, -16, 0, isMobile and 8 or 5)
    bar.Position = UDim2.new(0, 8, 0, isMobile and 28 or 26)
    bar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    bar.BorderSizePixel = 0
    
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(140, 100, 255)
    fill.BorderSizePixel = 0
    
    local knob = Instance.new("TextButton", bar)
    knob.Size = UDim2.new(0, isMobile and 14 or 10, 0, isMobile and 14 or 10)
    knob.Position = UDim2.new((default-min)/(max-min), -5, 0.5, -5)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.Text = ""
    
    local dragging = false
    knob.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = bar.AbsolutePosition.X
            local sliderWidth = bar.AbsoluteSize.X
            local percent = math.clamp((mousePos.X - sliderPos) / sliderWidth, 0, 1)
            local value = math.floor(min + percent * (max - min))
            fill.Size = UDim2.new(percent, 0, 1, 0)
            knob.Position = UDim2.new(percent, -5, 0.5, -5)
            label.Text = name .. ": " .. value
            callback(value)
        end
    end)
end

local function AddDropdown(name, options, default, callback)
    local frame = Instance.new("Frame", ContentArea)
    frame.Size = UDim2.new(1, -24, 0, isMobile and 36 or 32)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(140, 140, 140)
    label.Font = Enum.Font.SourceSans
    label.TextSize = isMobile and 14 or 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.5, -8, 0, isMobile and 26 or 22)
    btn.Position = UDim2.new(0.5, 0, 0.5, -(isMobile and 13 or 11))
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    btn.Text = default .. " >"
    btn.TextColor3 = Color3.fromRGB(140, 100, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = isMobile and 13 or 11
    btn.BorderSizePixel = 0
    
    local idx = 1
    for i, v in ipairs(options) do if v == default then idx = i end end
    btn.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #options then idx = 1 end
        btn.Text = options[idx] .. " >"
        callback(options[idx])
    end)
end

local function AddButton(name, callback)
    local btn = Instance.new("TextButton", ContentArea)
    btn.Size = UDim2.new(1, -24, 0, isMobile and 36 or 32)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.BackgroundTransparency = 0.1
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(140, 100, 255)
    btn.Font = Enum.Font.SourceSansSemiBold
    btn.TextSize = isMobile and 14 or 12
    btn.MouseButton1Click:Connect(callback)
end

-- Padding + layout для контента
local padding = Instance.new("UIPadding", ContentArea)
padding.PaddingTop = UDim.new(0, 8)
padding.PaddingLeft = UDim.new(0, 12)
local layout = Instance.new("UIListLayout", ContentArea)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- ============ ВКЛАДКИ ============
local function ShowVisuals()
    ClearContent()
    
    AddToggle("ESP", Config.ESP, function(v)
        Config.ESP = v
        if v then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then CreateESP(p) end
            end
        else
            for _, p in ipairs(Players:GetPlayers()) do RemoveESP(p) end
        end
    end)
    
    AddToggle("Chams", Config.Chams, function(v)
        Config.Chams = v
        if v then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then CreateChams(p) end
            end
        else
            for _, p in ipairs(Players:GetPlayers()) do RemoveChams(p) end
        end
    end)
    
    AddToggle("Bullet Tracers", Config.Tracers, function(v) Config.Tracers = v end)
    
    AddDropdown("Tracer Color", {"Purple", "Red", "Blue", "Green", "White", "Cyan", "Pink", "Rainbow"}, Config.TracerStyle, function(v)
        Config.TracerStyle = v
    end)
    
    AddSlider("Duration (sec)", 1, 10, Config.TracerDuration, function(v)
        Config.TracerDuration = v
    end)
end

local function ShowAimbot()
    ClearContent()
    
    AddToggle("Silent Aim", Config.SilentAim, function(v) Config.SilentAim = v end)
    
    AddDropdown("Hit Part", {"Head", "Torso", "HumanoidRootPart", "UpperTorso"}, Config.AimPart, function(v)
        Config.AimPart = v
    end)
    
    local infoLabel = Instance.new("TextLabel", ContentArea)
    infoLabel.Size = UDim2.new(1, -24, 0, 40)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "Hold LMB while enabled\nto activate aim"
    infoLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
    infoLabel.Font = Enum.Font.SourceSans
    infoLabel.TextSize = 11
    infoLabel.TextWrapped = true
end

local function ShowMisc()
    ClearContent()
    
    AddToggle("BHop Speed", Config.SpeedGlitch, function(v)
        Config.SpeedGlitch = v
        if v then StartSpeedGlitch() else StopSpeedGlitch() end
    end)
    
    AddSlider("Boost", 10, 100, Config.BoostValue, function(v)
        Config.BoostValue = v
    end)
    
    AddToggle("Auto Jump", Config.AutoJump, function(v)
        Config.AutoJump = v
        if v then StartAutoJump() else StopAutoJump() end
    end)
    
    AddToggle("Fly (WASD+Space/Ctrl)", Config.Fly, function(v)
        Config.Fly = v
        if v then StartFly() else StopFly() end
    end)
    
    AddSlider("Fly Speed", 10, 150, Config.FlySpeed, function(v)
        Config.FlySpeed = v
    end)
    
    AddToggle("Noclip", Config.Noclip, function(v) Config.Noclip = v end)
    
    AddSlider("WalkSpeed", 16, 200, Config.WalkSpeed, function(v)
        Config.WalkSpeed = v
        local h = GetHum() if h then h.WalkSpeed = v end
    end)
    
    AddSlider("JumpPower", 50, 300, Config.JumpPower, function(v)
        Config.JumpPower = v
        local h = GetHum() if h then h.JumpPower = v end
    end)
    
    AddToggle("Anti AFK", Config.AntiAFK, function(v) Config.AntiAFK = v end)
    
    AddButton("Rejoin Server", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end)
end

setActiveTab(visualTab)
visualTab.MouseButton1Click:Connect(function() setActiveTab(visualTab) ShowVisuals() end)
aimTab.MouseButton1Click:Connect(function() setActiveTab(aimTab) ShowAimbot() end)
miscTab.MouseButton1Click:Connect(function() setActiveTab(miscTab) ShowMisc() end)

-- Drag
local dragging = false
local dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Vector2.new(MainFrame.Position.X.Offset, MainFrame.Position.Y.Offset)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
    end
end)

ShowVisuals()

pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "⬡ Deft v2.5",
        Text = "Loaded! RightShift = hide",
        Duration = 5,
    })
end)
