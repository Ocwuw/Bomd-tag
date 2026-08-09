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

local Config = {
    AutoFarm=false, CoinChams=false, PlayerChams=false, AutoGrabGun=false, GunDroppedCham=false,
    Fullbright=false, RemoveFog=false,
    AutoDodgeBomb=false, AutoPassBomb=false, BombESP=false,
    WalkSpeed=16, JumpPower=50, InfJump=false, Noclip=false,
    FOV=90, FOVLocked=true, AntiAFK=true
}
Config.AmbientBackup = game:GetService("Lighting").Ambient
Config.FogEndBackup = game:GetService("Lighting").FogEnd

local Colors = {
    Bg = Color3.fromRGB(30, 15, 50),
    Panel = Color3.fromRGB(45, 25, 70),
    Panel2 = Color3.fromRGB(55, 30, 85),
    Accent = Color3.fromRGB(170, 80, 255),
    Glow = Color3.fromRGB(200, 100, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(200, 180, 220),
    ToggleOff = Color3.fromRGB(60, 40, 80),
    Close = Color3.fromRGB(255, 70, 70),
}

local function GetHum() 
    local c = LocalPlayer.Character 
    return c and c:FindFirstChildOfClass("Humanoid") 
end
local function GetRoot() 
    local c = LocalPlayer.Character 
    return c and c:FindFirstChild("HumanoidRootPart") 
end

-- Проверка: есть ли у меня бомба
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

-- Ближайший игрок (не я)
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
                if d < dist then
                    dist = d
                    closest = p
                end
            end
        end
    end
    return closest
end

local ChamsFolder = Instance.new("Folder")
ChamsFolder.Name = "KLOUD_Chams"
ChamsFolder.Parent = GuiParent

local function CreatePlayerCham(Plr)
    if not Plr.Character then return end
    if ChamsFolder:FindFirstChild(Plr.Name) then return end
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
end

local function RemovePlayerCham(Plr)
    local f = ChamsFolder:FindFirstChild(Plr.Name)
    if f then f:Destroy() end
end

local function CreateCoinChams()
    pcall(function()
        local coinFolder = Instance.new("Folder", ChamsFolder)
        coinFolder.Name = "Coins"
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("coin") or obj.Name:lower():find("cash")) then
                local box = Instance.new("BoxHandleAdornment")
                box.Size = obj.Size
                box.Adornee = obj
                box.AlwaysOnTop = true
                box.ZIndex = 5
                box.Transparency = 0.2
                box.Color3 = Color3.fromRGB(255, 215, 0)
                box.Parent = coinFolder
            end
        end
    end)
end

local function CreateGunChams()
    pcall(function()
        local gf = Instance.new("Folder", ChamsFolder)
        gf.Name = "Guns"
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") or (obj:IsA("BasePart") and obj.Name:lower():find("gun")) then
                local part = obj:IsA("Tool") and obj:FindFirstChildOfClass("BasePart") or obj
                if part then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Size = part.Size
                    box.Adornee = part
                    box.AlwaysOnTop = true
                    box.ZIndex = 5
                    box.Transparency = 0.2
                    box.Color3 = Color3.fromRGB(0, 255, 100)
                    box.Parent = gf
                end
            end
        end
    end)
end

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

local mc = Instance.new("UICorner", Main) mc.CornerRadius = UDim.new(0, 10)
local glow = Instance.new("UIStroke", Main)
glow.Color = Colors.Glow
glow.Thickness = 2
glow.Transparency = 0.3

local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Kloud"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Colors.TextDim
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 25)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22
CloseBtn.TextColor3 = Colors.TextDim
CloseBtn.AutoButtonColor = false
CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Colors.Close}):Play() end)
CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Colors.TextDim}):Play() end)

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
ContentTitle.Text = "Main"
ContentTitle.Font = Enum.Font.GothamBold
ContentTitle.TextSize = 22
ContentTitle.TextColor3 = Colors.Text
ContentTitle.TextXAlignment = Enum.TextXAlignment.Left

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
    for _, v in pairs(Content:GetChildren()) do
        if not v:IsA("UIListLayout") then v:Destroy() end
    end
end

local function AddToggle(name, default, callback)
    local frame = Instance.new("Frame", Content)
    frame.Size = UDim2.new(1, -5, 0, 45)
    frame.BackgroundColor3 = Colors.Panel
    frame.BorderSizePixel = 0
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
    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = state and Colors.Accent or Colors.ToggleOff}):Play()
        TweenService:Create(dot, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        callback(state)
    end)
end

local function AddSlider(name, min, max, default, callback)
    local frame = Instance.new("Frame", Content)
    frame.Size = UDim2.new(1, -5, 0, 55)
    frame.BackgroundColor3 = Colors.Panel
    frame.BorderSizePixel = 0
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
    local val = Instance.new("TextLabel", frame)
    val.Size = UDim2.new(0, 50, 0, 25)
    val.Position = UDim2.new(1, -65, 0, 5)
    val.BackgroundTransparency = 1
    val.Text = tostring(default)
    val.Font = Enum.Font.GothamBold
    val.TextSize = 14
    val.TextColor3 = Colors.Accent
    val.TextXAlignment = Enum.TextXAlignment.Right
    local bar = Instance.new("Frame", frame)
    bar.Size = UDim2.new(1, -30, 0, 5)
    bar.Position = UDim2.new(0, 15, 0, 35)
    bar.BackgroundColor3 = Colors.ToggleOff
    bar.BorderSizePixel = 0
    local bc = Instance.new("UICorner", bar) bc.CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Colors.Accent
    fill.BorderSizePixel = 0
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
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Colors.Text
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    local bc = Instance.new("UICorner", btn) bc.CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
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
        end
        CurrentTab = name
        btn.BackgroundTransparency = 0
        btn.BackgroundColor3 = Colors.Panel
        btn.TextColor3 = Colors.Text
        ContentTitle.Text = name
        ClearContent()
        contentFunc()
    end)
end

AddTab("Main", "❖", function()
    AddToggle("Auto Farm", Config.AutoFarm, function(v) Config.AutoFarm = v end)
    AddToggle("Coin Chams", Config.CoinChams, function(v)
        Config.CoinChams = v
        if v then CreateCoinChams() else
            local c = ChamsFolder:FindFirstChild("Coins")
            if c then c:Destroy() end
        end
    end)
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
    AddToggle("Automatically Grab Gun", Config.AutoGrabGun, function(v) Config.AutoGrabGun = v end)
    AddToggle("Gun Dropped Cham", Config.GunDroppedCham, function(v)
        Config.GunDroppedCham = v
        if v then CreateGunChams() else
            local g = ChamsFolder:FindFirstChild("Guns")
            if g then g:Destroy() end
        end
    end)
end)

AddTab("Misc", "≡", function()
    AddToggle("Fullbright", Config.Fullbright, function(v) Config.Fullbright = v SetFullbright(v) end)
    AddToggle("Remove Fog", Config.RemoveFog, function(v) Config.RemoveFog = v SetRemoveFog(v) end)
end)

AddTab("Trap", "△", function()
    AddToggle("Auto Pass Bomb", Config.AutoPassBomb, function(v) Config.AutoPassBomb = v end)
    AddToggle("Auto Dodge Bomb", Config.AutoDodgeBomb, function(v) Config.AutoDodgeBomb = v end)
end)

AddTab("Player", "♂", function()
    AddSlider("WalkSpeed", 16, 200, Config.WalkSpeed, function(v)
        Config.WalkSpeed = v
        local h = GetHum() if h then h.WalkSpeed = v end
    end)
    AddSlider("JumpPower", 50, 300, Config.JumpPower, function(v)
        Config.JumpPower = v
        local h = GetHum() if h then h.JumpPower = v end
    end)
    AddToggle("Infinite Jump", Config.InfJump, function(v) Config.InfJump = v end)
    AddToggle("Noclip", Config.Noclip, function(v) Config.Noclip = v end)
end)

AddTab("Emotes", "☺", function()
    AddButton("Sit", function()
        local h = GetHum() if h then h.Sit = true end
    end)
    AddButton("Reset Character", function()
        local h = GetHum() if h then h.Health = 0 end
    end)
end)

AddTab("Server", "≣", function()
    AddButton("Rejoin", function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end)
    AddToggle("Anti AFK", Config.AntiAFK, function(v) Config.AntiAFK = v end)
end)

AddTab("Settings", "⚙", function()
    AddSlider("FOV", 70, 120, Config.FOV, function(v)
        Config.FOV = v
        Camera.FieldOfView = v
    end)
    AddToggle("Lock FOV", Config.FOVLocked, function(v) Config.FOVLocked = v end)
    AddButton("Destroy GUI", function()
        sg:Destroy()
        ChamsFolder:Destroy()
        SetFullbright(false)
        SetRemoveFog(false)
        Camera.FieldOfView = 70
    end)
end)

task.wait(0.1)
Tabs["Main"].btn.BackgroundTransparency = 0
Tabs["Main"].btn.BackgroundColor3 = Colors.Panel
Tabs["Main"].btn.TextColor3 = Colors.Text
CurrentTab = "Main"
Tabs["Main"].func()

CloseBtn.MouseButton1Click:Connect(function()
    sg:Destroy()
    ChamsFolder:Destroy()
    SetFullbright(false)
    SetRemoveFog(false)
    Camera.FieldOfView = 70
end)

MinArrow.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    MinArrow.Text = Main.Visible and "<" or ">"
end)

UserInput.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
        MinArrow.Text = Main.Visible and "<" or ">"
    end
end)

UserInput.JumpRequest:Connect(function()
    if Config.InfJump then
        local h = GetHum() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Auto Pass Bomb — телепортируется к ближайшему игроку если у тебя бомба
task.spawn(function()
    while task.wait(0.2) do
        if Config.AutoPassBomb and HasBomb() then
            local target = GetClosestPlayer()
            local root = GetRoot()
            if target and target.Character and root then
                local tr = target.Character:FindFirstChild("HumanoidRootPart")
                if tr then
                    pcall(function()
                        root.CFrame = tr.CFrame * CFrame.new(0, 0, -3)
                    end)
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        if Config.AutoGrabGun then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Tool") and obj.Name:lower():find("gun") then
                    local root = GetRoot()
                    local part = obj:FindFirstChildOfClass("BasePart")
                    if root and part and (root.Position - part.Position).Magnitude < 20 then
                        pcall(function() obj.Parent = LocalPlayer.Backpack end)
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if Config.AutoFarm then
            local root = GetRoot()
            if root then
                local closest, dist = nil, math.huge
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():find("coin") or obj.Name:lower():find("cash")) then
                        local d = (root.Position - obj.Position).Magnitude
                        if d < dist then dist = d closest = obj end
                    end
                end
                if closest then root.CFrame = CFrame.new(closest.Position + Vector3.new(0, 3, 0)) end
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
    game.StarterGui:SetCore("SendNotification", {Title = "Kloud", Text = "Loaded! RightShift = hide", Duration = 5})
end)
