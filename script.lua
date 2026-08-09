local Players = game.Players
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local GuiParent
if gethui then GuiParent = gethui() else GuiParent = game:GetService("CoreGui") end
pcall(function() local old = GuiParent:FindFirstChild("KloudHub") if old then old:Destroy() end end)

local Themes = {
    Default = {Bg=Color3.fromRGB(30,15,50),Panel=Color3.fromRGB(45,25,70),Panel2=Color3.fromRGB(55,30,85),Accent=Color3.fromRGB(170,80,255),Glow=Color3.fromRGB(200,100,255),Text=Color3.fromRGB(255,255,255),TextDim=Color3.fromRGB(200,180,220),ToggleOff=Color3.fromRGB(60,40,80),Transparency=0},
    Green = {Bg=Color3.fromRGB(15,40,20),Panel=Color3.fromRGB(25,55,30),Panel2=Color3.fromRGB(35,70,40),Accent=Color3.fromRGB(80,255,120),Glow=Color3.fromRGB(100,255,140),Text=Color3.fromRGB(255,255,255),TextDim=Color3.fromRGB(200,220,200),ToggleOff=Color3.fromRGB(40,60,45),Transparency=0},
    Red = {Bg=Color3.fromRGB(40,15,15),Panel=Color3.fromRGB(60,25,25),Panel2=Color3.fromRGB(80,35,35),Accent=Color3.fromRGB(255,60,60),Glow=Color3.fromRGB(255,100,100),Text=Color3.fromRGB(255,255,255),TextDim=Color3.fromRGB(220,200,200),ToggleOff=Color3.fromRGB(70,40,40),Transparency=0},
    Black = {Bg=Color3.fromRGB(15,15,15),Panel=Color3.fromRGB(25,25,25),Panel2=Color3.fromRGB(40,40,40),Accent=Color3.fromRGB(180,180,180),Glow=Color3.fromRGB(255,255,255),Text=Color3.fromRGB(255,255,255),TextDim=Color3.fromRGB(180,180,180),ToggleOff=Color3.fromRGB(50,50,50),Transparency=0},
    Transparent = {Bg=Color3.fromRGB(20,10,40),Panel=Color3.fromRGB(50,30,80),Panel2=Color3.fromRGB(60,40,90),Accent=Color3.fromRGB(170,80,255),Glow=Color3.fromRGB(200,100,255),Text=Color3.fromRGB(255,255,255),TextDim=Color3.fromRGB(200,180,220),ToggleOff=Color3.fromRGB(60,40,80),Transparency=0.4},
    Aios = {Bg=Color3.fromRGB(0,0,0),Panel=Color3.fromRGB(10,10,10),Panel2=Color3.fromRGB(25,25,25),Accent=Color3.fromRGB(255,255,255),Glow=Color3.fromRGB(255,255,255),Text=Color3.fromRGB(255,255,255),TextDim=Color3.fromRGB(200,200,200),ToggleOff=Color3.fromRGB(40,40,40),Transparency=0.5},
    Ocean = {Bg=Color3.fromRGB(10,25,50),Panel=Color3.fromRGB(20,40,75),Panel2=Color3.fromRGB(30,55,95),Accent=Color3.fromRGB(80,180,255),Glow=Color3.fromRGB(100,200,255),Text=Color3.fromRGB(255,255,255),TextDim=Color3.fromRGB(200,220,240),ToggleOff=Color3.fromRGB(40,60,90),Transparency=0},
    Sunset = {Bg=Color3.fromRGB(50,20,40),Panel=Color3.fromRGB(80,35,60),Panel2=Color3.fromRGB(100,50,75),Accent=Color3.fromRGB(255,140,80),Glow=Color3.fromRGB(255,180,100),Text=Color3.fromRGB(255,255,255),TextDim=Color3.fromRGB(240,210,200),ToggleOff=Color3.fromRGB(90,55,70),Transparency=0},
}
local Colors = Themes.Default

local Config = {
    PlayerChams=false, PlayerESP=false, InfJump=false, Noclip=false,
    WalkSpeed=16, JumpPower=50, FOV=90, FOVLocked=true,
    Fullbright=false, RemoveFog=false, AntiAFK=true,
    AutoDodgeBomb=false, AutoPassBomb=false,
    FlyEnabled=false, FlySpeed=50,
    Reflections=false, MotionBlur=false, MotionBlurIntensity=20,
    Saturation=0, CurrentTheme="Default", FPSBoost=false,
}
Config.AmbientBackup = game:GetService("Lighting").Ambient
Config.FogEndBackup = game:GetService("Lighting").FogEnd

local function GetHum() local c = LocalPlayer.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function GetRoot() local c = LocalPlayer.Character return c and c:FindFirstChild("HumanoidRootPart") end

local function HasBomb()
    local c = LocalPlayer.Character if not c then return false end
    for _, v in pairs(c:GetChildren()) do if v:IsA("Tool") and v.Name:lower():find("bomb") then return true end end
    for _, v in pairs(c:GetDescendants()) do if v.Name:lower():find("bomb") then return true end end
    return false
end

local function GetClosestPlayer()
    local closest, dist = nil, math.huge
    local root = GetRoot() if not root then return nil end
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

local ChamsFolder = Instance.new("Folder") ChamsFolder.Name = "KLOUD_Chams" ChamsFolder.Parent = GuiParent
local ESPFolder = Instance.new("Folder") ESPFolder.Name = "KLOUD_ESP" ESPFolder.Parent = GuiParent

local function CreatePlayerCham(Plr)
    if not Plr or Plr == LocalPlayer or not Plr.Character then return end
    local ex = ChamsFolder:FindFirstChild(Plr.Name) if ex then ex:Destroy() end
    local folder = Instance.new("Folder", ChamsFolder) folder.Name = Plr.Name
    for _, v in pairs(Plr.Character:GetChildren()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = v.Size box.Adornee = v box.AlwaysOnTop = true box.ZIndex = 5
            box.Transparency = 0.3 box.Color3 = Colors.Accent box.Parent = folder
        end
    end
    local hum = Plr.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Died:Connect(function() local f = ChamsFolder:FindFirstChild(Plr.Name) if f then f:Destroy() end end) end
end
local function RemovePlayerCham(Plr) local f = ChamsFolder:FindFirstChild(Plr.Name) if f then f:Destroy() end end

local function CreatePlayerESP(Plr)
    if not Plr or Plr == LocalPlayer or not Plr.Character then return end
    local head = Plr.Character:FindFirstChild("Head") if not head then return end
    local ex = ESPFolder:FindFirstChild(Plr.Name) if ex then ex:Destroy() end
    local bb = Instance.new("BillboardGui") bb.Adornee = head bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0,100,0,30) bb.StudsOffset = Vector3.new(0,2,0) bb.Name = Plr.Name bb.Parent = ESPFolder
    local tl = Instance.new("TextLabel", bb) tl.BackgroundTransparency = 1 tl.Size = UDim2.new(1,0,1,0)
    tl.Text = Plr.Name tl.Font = Enum.Font.GothamBold tl.TextSize = 14 tl.TextColor3 = Colors.Accent tl.TextStrokeTransparency = 0.3
    local hum = Plr.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Died:Connect(function() local f = ESPFolder:FindFirstChild(Plr.Name) if f then f:Destroy() end end) end
end
local function RemovePlayerESP(Plr) local f = ESPFolder:FindFirstChild(Plr.Name) if f then f:Destroy() end end

local function SetupCharAdded(Plr)
    if Plr == LocalPlayer then return end
    Plr.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart", 10) task.wait(1)
        if Config.PlayerChams then CreatePlayerCham(Plr) end
        if Config.PlayerESP then CreatePlayerESP(Plr) end
    end)
    Plr.CharacterRemoving:Connect(function() RemovePlayerCham(Plr) RemovePlayerESP(Plr) end)
end
for _, p in pairs(Players:GetPlayers()) do SetupCharAdded(p) end
Players.PlayerAdded:Connect(function(p) SetupCharAdded(p) end)
Players.PlayerRemoving:Connect(function(p) RemovePlayerCham(p) RemovePlayerESP(p) end)

local function SetFullbright(s) local lt = game:GetService("Lighting")
    if s then lt.Ambient=Color3.new(1,1,1) lt.ColorShift_Bottom=Color3.new(1,1,1) lt.ColorShift_Top=Color3.new(1,1,1)
    else lt.Ambient=Config.AmbientBackup end
end
local function SetRemoveFog(s) local lt = game:GetService("Lighting")
    if s then lt.FogEnd=100000 else lt.FogEnd=Config.FogEndBackup end
end

local flyBV, flyBG
local function StartFly()
    local root = GetRoot() if not root then return end
    flyBV = Instance.new("BodyVelocity", root) flyBV.MaxForce = Vector3.new(9e9,9e9,9e9) flyBV.Velocity = Vector3.new(0,0,0)
    flyBG = Instance.new("BodyGyro", root) flyBG.MaxTorque = Vector3.new(9e9,9e9,9e9) flyBG.P = 1000
end
local function StopFly() if flyBV then flyBV:Destroy() flyBV = nil end if flyBG then flyBG:Destroy() flyBG = nil end end

local function SetReflections(s)
    Config.Reflections = s
    pcall(function()
        local lt = game:GetService("Lighting")
        if s then
            local bloom = lt:FindFirstChild("KloudBloom") or Instance.new("BloomEffect", lt)
            bloom.Name = "KloudBloom" bloom.Intensity = 0.3 bloom.Size = 24 bloom.Threshold = 0.8
            local sr = lt:FindFirstChild("KloudSunRays") or Instance.new("SunRaysEffect", lt)
            sr.Name = "KloudSunRays" sr.Intensity = 0.1 sr.Spread = 0.5
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("floor") or obj.Name:lower():find("ground") or obj.Name:lower():find("base") or obj.Position.Y < 5) then
                    if obj.Reflectance < 0.2 then obj.Reflectance = 0.3 end
                end
            end
        else
            local b = lt:FindFirstChild("KloudBloom") if b then b:Destroy() end
            local s2 = lt:FindFirstChild("KloudSunRays") if s2 then s2:Destroy() end
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Reflectance > 0 then obj.Reflectance = 0 end
            end
        end
    end)
end

local function SetMotionBlur(enabled)
    Config.MotionBlur = enabled
    pcall(function()
        local lt = game:GetService("Lighting")
        if enabled then
            local blur = lt:FindFirstChild("KloudMotionBlur") or Instance.new("BlurEffect", lt)
            blur.Name = "KloudMotionBlur" blur.Size = 0
        else
            local blur = lt:FindFirstChild("KloudMotionBlur")
            if blur then blur:Destroy() end
        end
    end)
end

local function SetSaturation(val)
    Config.Saturation = val
    pcall(function()
        local lt = game:GetService("Lighting")
        local cc = lt:FindFirstChild("KloudSaturation") or Instance.new("ColorCorrectionEffect", lt)
        cc.Name = "KloudSaturation" cc.Saturation = val
    end)
end

local function SetTime(timeStr)
    pcall(function()
        local lt = game:GetService("Lighting")
        if timeStr == "Day" then lt.ClockTime = 12
        elseif timeStr == "Noon" then lt.ClockTime = 14
        elseif timeStr == "Evening" then lt.ClockTime = 18
        elseif timeStr == "Night" then lt.ClockTime = 0
        elseif timeStr == "Midnight" then lt.ClockTime = 23
        elseif timeStr == "Sunrise" then lt.ClockTime = 6
        elseif timeStr == "Sunset" then lt.ClockTime = 19 end
    end)
end

-- ========== SKYBOX ==========
local Skyboxes = {
    Realistic = {
        Up = "rbxassetid://6444884785", Dn = "rbxassetid://6444884785",
        Lf = "rbxassetid://6444884785", Rt = "rbxassetid://6444884785",
        Ft = "rbxassetid://6444884785", Bk = "rbxassetid://6444884785",
    },
    Sunset = {
        Up = "rbxassetid://271042516", Dn = "rbxassetid://271077243",
        Lf = "rbxassetid://271077958", Rt = "rbxassetid://271077996",
        Ft = "rbxassetid://271077829", Bk = "rbxassetid://271077869",
    },
    Space = {
        Up = "rbxassetid://159454299", Dn = "rbxassetid://159454296",
        Lf = "rbxassetid://159454286", Rt = "rbxassetid://159454300",
        Ft = "rbxassetid://159454288", Bk = "rbxassetid://159454293",
    },
    Nebula = {
        Up = "rbxassetid://159454299", Dn = "rbxassetid://159454296",
        Lf = "rbxassetid://159454286", Rt = "rbxassetid://159454300",
        Ft = "rbxassetid://159454288", Bk = "rbxassetid://159454293",
    },
    Clouds = {
        Up = "rbxassetid://456977674", Dn = "rbxassetid://456977674",
        Lf = "rbxassetid://456977674", Rt = "rbxassetid://456977674",
        Ft = "rbxassetid://456977674", Bk = "rbxassetid://456977674",
    },
}

local function SetSkybox(name)
    pcall(function()
        local lt = game:GetService("Lighting")
        -- Удаляем старый Sky
        for _, v in pairs(lt:GetChildren()) do
            if v:IsA("Sky") then v:Destroy() end
        end
        if name == "Default" then return end
        
        local sky = Instance.new("Sky")
        sky.Name = "KloudSky"
        if Skyboxes[name] then
            local s = Skyboxes[name]
            sky.SkyboxUp = s.Up sky.SkyboxDn = s.Dn
            sky.SkyboxLf = s.Lf sky.SkyboxRt = s.Rt
            sky.SkyboxFt = s.Ft sky.SkyboxBk = s.Bk
        end
        sky.StarCount = (name == "Space" or name == "Nebula") and 3000 or 0
        sky.Parent = lt
    end)
end

-- ========== FPS BOOST ==========
local originalTerrainDecoration = nil
local originalGlobalShadows = nil
local originalCastShadow = {}

local function SetFPSBoost(s)
    Config.FPSBoost = s
    pcall(function()
        local lt = game:GetService("Lighting")
        if s then
            -- Сохраняем оригиналы
            if originalGlobalShadows == nil then originalGlobalShadows = lt.GlobalShadows end
            if workspace.Terrain and originalTerrainDecoration == nil then
                originalTerrainDecoration = workspace.Terrain.Decoration
            end
            
            -- Отключаем тени
            lt.GlobalShadows = false
            lt.Brightness = 2
            
            -- Убираем траву
            if workspace.Terrain then workspace.Terrain.Decoration = false end
            
            -- Отключаем всё лишнее
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    if originalCastShadow[v] == nil then originalCastShadow[v] = v.CastShadow end
                    v.CastShadow = false
                    v.Material = Enum.Material.SmoothPlastic
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Explosion") then
                    v.Enabled = false
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1
                end
            end
            
            -- Убираем эффекты Lighting (кроме наших)
            for _, v in pairs(lt:GetChildren()) do
                if (v:IsA("BloomEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect")) 
                and not v.Name:find("Kloud") then
                    v.Enabled = false
                end
            end
        else
            -- Возвращаем оригиналы
            if originalGlobalShadows ~= nil then lt.GlobalShadows = originalGlobalShadows end
            if workspace.Terrain and originalTerrainDecoration ~= nil then workspace.Terrain.Decoration = originalTerrainDecoration end
            for part, val in pairs(originalCastShadow) do
                if part and part.Parent then part.CastShadow = val end
            end
            for _, v in pairs(game:GetService("Lighting"):GetChildren()) do
                if v:IsA("BloomEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") then
                    v.Enabled = true
                end
            end
        end
    end)
end

-- ========== COPY OUTFIT ==========
local function CopyOutfit(targetPlayer)
    pcall(function()
        if not targetPlayer or not targetPlayer.Character then return end
        local myChar = LocalPlayer.Character
        if not myChar then return end
        
        local targetHum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
        local myHum = myChar:FindFirstChildOfClass("Humanoid")
        if not targetHum or not myHum then return end
        
        -- Удаляем все свои аксессуары/шляпы
        for _, v in pairs(myChar:GetChildren()) do
            if v:IsA("Accessory") or v:IsA("Hat") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("BodyColors") then
                v:Destroy()
            end
        end
        
        -- Копируем всё с цели
        for _, v in pairs(targetPlayer.Character:GetChildren()) do
            if v:IsA("Accessory") or v:IsA("Hat") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("BodyColors") then
                local clone = v:Clone()
                clone.Parent = myChar
            end
        end
        
        -- Копируем HumanoidDescription (если возможно)
        pcall(function()
            local desc = targetHum:GetAppliedDescription()
            myHum:ApplyDescription(desc)
        end)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "✅ Copy Outfit",
            Text = "Скопирован внешний вид: " .. targetPlayer.Name,
            Duration = 4
        })
    end)
end

local lastCamCF = Camera.CFrame

-- ============ UI ============
local sg = Instance.new("ScreenGui") sg.Name = "KloudHub" sg.ResetOnSpawn = false sg.Parent = GuiParent

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 620, 0, 420) Main.Position = UDim2.new(0.5, -310, 0.5, -210)
Main.BackgroundColor3 = Colors.Bg Main.BorderSizePixel = 0 Main.Active = true Main.Draggable = true Main.Parent = sg
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local glow = Instance.new("UIStroke", Main) glow.Color = Colors.Glow glow.Thickness = 2 glow.Transparency = 0.3

local ledL = Instance.new("Frame", Main) ledL.Size = UDim2.new(0,2,1,-20) ledL.Position = UDim2.new(0,-4,0,10)
ledL.BackgroundColor3 = Color3.new(1,1,1) ledL.BorderSizePixel = 0 ledL.BackgroundTransparency = 0.3
local lgL = Instance.new("UIGradient", ledL)
lgL.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(200,200,255)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))})
lgL.Rotation = 90

local ledR = Instance.new("Frame", Main) ledR.Size = UDim2.new(0,2,1,-20) ledR.Position = UDim2.new(1,2,0,10)
ledR.BackgroundColor3 = Color3.new(1,1,1) ledR.BorderSizePixel = 0 ledR.BackgroundTransparency = 0.3
local lgR = Instance.new("UIGradient", ledR)
lgR.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(200,200,255)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))})
lgR.Rotation = 90

task.spawn(function()
    while sg.Parent do
        TweenService:Create(lgL, TweenInfo.new(2,Enum.EasingStyle.Sine), {Offset=Vector2.new(0,1)}):Play()
        TweenService:Create(lgR, TweenInfo.new(2,Enum.EasingStyle.Sine), {Offset=Vector2.new(0,1)}):Play()
        task.wait(2)
        TweenService:Create(lgL, TweenInfo.new(2,Enum.EasingStyle.Sine), {Offset=Vector2.new(0,-1)}):Play()
        TweenService:Create(lgR, TweenInfo.new(2,Enum.EasingStyle.Sine), {Offset=Vector2.new(0,-1)}):Play()
        task.wait(2)
    end
end)

local TitleBar = Instance.new("Frame", Main) TitleBar.Size = UDim2.new(1,0,0,35) TitleBar.BackgroundTransparency = 1

local BoltLabel = Instance.new("TextLabel", TitleBar)
BoltLabel.Size = UDim2.new(0,25,0,25) BoltLabel.Position = UDim2.new(0,5,0,5)
BoltLabel.BackgroundTransparency = 1 BoltLabel.Text = "⚡" BoltLabel.TextSize = 18 BoltLabel.Font = Enum.Font.GothamBold
BoltLabel.TextColor3 = Color3.new(1,1,1)
local boltGrad = Instance.new("UIGradient", BoltLabel)
boltGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(200,200,255)),ColorSequenceKeypoint.new(1,Color3.new(1,1,1))})
boltGrad.Rotation = 90
task.spawn(function()
    while sg.Parent do
        TweenService:Create(boltGrad, TweenInfo.new(1.5,Enum.EasingStyle.Sine), {Offset=Vector2.new(0,-1)}):Play()
        task.wait(1.5)
        TweenService:Create(boltGrad, TweenInfo.new(1.5,Enum.EasingStyle.Sine), {Offset=Vector2.new(0,1)}):Play()
        task.wait(1.5)
    end
end)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(0,200,1,0) Title.Position = UDim2.new(0,30,0,0)
Title.BackgroundTransparency = 1 Title.Text = "Kloud Hub" Title.Font = Enum.Font.GothamBold
Title.TextSize = 15 Title.TextColor3 = Colors.Text Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0,30,0,25) CloseBtn.Position = UDim2.new(1,-35,0,5)
CloseBtn.BackgroundTransparency = 1 CloseBtn.Text = "×" CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22 CloseBtn.TextColor3 = Colors.TextDim CloseBtn.AutoButtonColor = false
CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn,TweenInfo.new(0.15),{TextColor3=Color3.fromRGB(255,70,70)}):Play() end)
CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseBtn,TweenInfo.new(0.15),{TextColor3=Colors.TextDim}):Play() end)

local ReopenBtn = Instance.new("TextButton", sg)
ReopenBtn.Size = UDim2.new(0,80,0,35) ReopenBtn.Position = UDim2.new(0,20,0,100)
ReopenBtn.BackgroundColor3 = Colors.Bg ReopenBtn.Text = "⚡ Kloud" ReopenBtn.Font = Enum.Font.GothamBold
ReopenBtn.TextSize = 13 ReopenBtn.TextColor3 = Colors.Text ReopenBtn.BorderSizePixel = 0
ReopenBtn.Visible = false ReopenBtn.Active = true ReopenBtn.Draggable = true ReopenBtn.AutoButtonColor = false
Instance.new("UICorner", ReopenBtn).CornerRadius = UDim.new(0,8)
local rbs = Instance.new("UIStroke", ReopenBtn) rbs.Color = Colors.Glow rbs.Thickness = 2 rbs.Transparency = 0.3

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0,145,1,-50) Sidebar.Position = UDim2.new(0,10,0,45) Sidebar.BackgroundTransparency = 1
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0,4)

local ContentTitle = Instance.new("TextLabel", Main)
ContentTitle.Size = UDim2.new(1,-180,0,35) ContentTitle.Position = UDim2.new(0,170,0,45)
ContentTitle.BackgroundTransparency = 1 ContentTitle.Text = "Universal" ContentTitle.Font = Enum.Font.GothamBold
ContentTitle.TextSize = 22 ContentTitle.TextColor3 = Colors.Text ContentTitle.TextXAlignment = Enum.TextXAlignment.Left

local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(1,-180,1,-95) Content.Position = UDim2.new(0,170,0,85)
Content.BackgroundTransparency = 1 Content.BorderSizePixel = 0
Content.CanvasSize = UDim2.new(0,0,0,0) Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.ScrollBarThickness = 3 Content.ScrollBarImageColor3 = Colors.Accent
Instance.new("UIListLayout", Content).Padding = UDim.new(0,8)

local Tabs = {}
local CurrentTab = nil
local function ClearContent() for _, v in pairs(Content:GetChildren()) do if not v:IsA("UIListLayout") then v:Destroy() end end end

local function AddToggle(name, default, callback)
    local frame = Instance.new("Frame", Content) frame.Size = UDim2.new(1,-5,0,45)
    frame.BackgroundColor3 = Colors.Panel frame.BackgroundTransparency = Colors.Transparency frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)
    local lbl = Instance.new("TextLabel", frame) lbl.Size = UDim2.new(1,-70,1,0) lbl.Position = UDim2.new(0,15,0,0)
    lbl.BackgroundTransparency = 1 lbl.Text = name lbl.Font = Enum.Font.Gotham lbl.TextSize = 14
    lbl.TextColor3 = Colors.Text lbl.TextXAlignment = Enum.TextXAlignment.Left
    local btn = Instance.new("TextButton", frame) btn.Size = UDim2.new(0,40,0,20) btn.Position = UDim2.new(1,-55,0.5,-10)
    btn.BackgroundColor3 = default and Colors.Accent or Colors.ToggleOff btn.Text = "" btn.AutoButtonColor = false btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    local dot = Instance.new("Frame", btn) dot.Size = UDim2.new(0,16,0,16)
    dot.Position = default and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
    dot.BackgroundColor3 = Colors.Text dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(btn,TweenInfo.new(0.2),{BackgroundColor3 = state and Colors.Accent or Colors.ToggleOff}):Play()
        TweenService:Create(dot,TweenInfo.new(0.2),{Position = state and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)}):Play()
        callback(state)
    end)
end

local function AddSlider(name, min, max, default, callback)
    local frame = Instance.new("Frame", Content) frame.Size = UDim2.new(1,-5,0,55)
    frame.BackgroundColor3 = Colors.Panel frame.BackgroundTransparency = Colors.Transparency frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)
    local lbl = Instance.new("TextLabel", frame) lbl.Size = UDim2.new(1,-70,0,25) lbl.Position = UDim2.new(0,15,0,5)
    lbl.BackgroundTransparency = 1 lbl.Text = name lbl.Font = Enum.Font.Gotham lbl.TextSize = 14
    lbl.TextColor3 = Colors.Text lbl.TextXAlignment = Enum.TextXAlignment.Left
    local val = Instance.new("TextLabel", frame) val.Size = UDim2.new(0,50,0,25) val.Position = UDim2.new(1,-65,0,5)
    val.BackgroundTransparency = 1 val.Text = tostring(default) val.Font = Enum.Font.GothamBold
    val.TextSize = 14 val.TextColor3 = Colors.Accent val.TextXAlignment = Enum.TextXAlignment.Right
    local bar = Instance.new("Frame", frame) bar.Size = UDim2.new(1,-30,0,5) bar.Position = UDim2.new(0,15,0,35)
    bar.BackgroundColor3 = Colors.ToggleOff bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)
    local fill = Instance.new("Frame", bar) fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = Colors.Accent fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)
    local dragging = false
    bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    UserInput.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInput.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local v = math.floor(min + (max-min) * pos)
            fill.Size = UDim2.new(pos,0,1,0) val.Text = tostring(v) callback(v)
        end
    end)
end

local function AddButton(name, callback)
    local btn = Instance.new("TextButton", Content) btn.Size = UDim2.new(1,-5,0,40)
    btn.BackgroundColor3 = Colors.Panel btn.BackgroundTransparency = Colors.Transparency
    btn.Text = name btn.Font = Enum.Font.GothamBold btn.TextSize = 14
    btn.TextColor3 = Colors.Text btn.AutoButtonColor = false btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    btn.MouseButton1Click:Connect(callback)
end

local function AddDropdown(name, options, default, callback)
    local frame = Instance.new("Frame", Content) frame.Size = UDim2.new(1,-5,0,45)
    frame.BackgroundColor3 = Colors.Panel frame.BackgroundTransparency = Colors.Transparency frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)
    local lbl = Instance.new("TextLabel", frame) lbl.Size = UDim2.new(0.5,0,1,0) lbl.Position = UDim2.new(0,15,0,0)
    lbl.BackgroundTransparency = 1 lbl.Text = name lbl.Font = Enum.Font.Gotham lbl.TextSize = 14
    lbl.TextColor3 = Colors.Text lbl.TextXAlignment = Enum.TextXAlignment.Left
    local btn = Instance.new("TextButton", frame) btn.Size = UDim2.new(0.5,-20,0,25)
    btn.Position = UDim2.new(0.5,5,0.5,-12) btn.BackgroundColor3 = Colors.Panel2
    btn.Text = default.." ▼" btn.Font = Enum.Font.Gotham btn.TextSize = 12
    btn.TextColor3 = Colors.Text btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
    local idx = 1
    for i, v in pairs(options) do if v == default then idx = i end end
    btn.MouseButton1Click:Connect(function()
        idx = idx + 1 if idx > #options then idx = 1 end
        btn.Text = options[idx].." ▼" callback(options[idx])
    end)
end

local function AddTextbox(name, placeholder, callback)
    local frame = Instance.new("Frame", Content) frame.Size = UDim2.new(1,-5,0,45)
    frame.BackgroundColor3 = Colors.Panel frame.BackgroundTransparency = Colors.Transparency frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)
    local lbl = Instance.new("TextLabel", frame) lbl.Size = UDim2.new(0.4,0,1,0) lbl.Position = UDim2.new(0,15,0,0)
    lbl.BackgroundTransparency = 1 lbl.Text = name lbl.Font = Enum.Font.Gotham lbl.TextSize = 13
    lbl.TextColor3 = Colors.Text lbl.TextXAlignment = Enum.TextXAlignment.Left
    local tb = Instance.new("TextBox", frame) tb.Size = UDim2.new(0.6,-20,0,25)
    tb.Position = UDim2.new(0.4,5,0.5,-12) tb.BackgroundColor3 = Colors.Panel2
    tb.Text = "" tb.PlaceholderText = placeholder tb.Font = Enum.Font.Gotham tb.TextSize = 12
    tb.TextColor3 = Colors.Text tb.PlaceholderColor3 = Colors.TextDim tb.BorderSizePixel = 0
    tb.ClearTextOnFocus = false
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0,4)
    tb.FocusLost:Connect(function() callback(tb.Text) end)
end

local function AddTab(name, icon, contentFunc)
    local btn = Instance.new("TextButton", Sidebar) btn.Size = UDim2.new(1,0,0,38)
    btn.BackgroundColor3 = Colors.Panel btn.BackgroundTransparency = 1
    btn.Text = "   "..icon.."  | "..name btn.Font = Enum.Font.Gotham btn.TextSize = 14
    btn.TextColor3 = Colors.TextDim btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    Tabs[name] = {btn = btn, func = contentFunc}
    btn.MouseButton1Click:Connect(function()
        if CurrentTab then local ct = Tabs[CurrentTab] ct.btn.BackgroundTransparency = 1 ct.btn.TextColor3 = Colors.TextDim end
        CurrentTab = name btn.BackgroundTransparency = Colors.Transparency
        btn.BackgroundColor3 = Colors.Panel btn.TextColor3 = Colors.Text
        ContentTitle.Text = name ClearContent() contentFunc()
    end)
end

-- ============ ВКЛАДКИ ============
AddTab("Universal", "🌐", function()
    AddToggle("Player Chams", Config.PlayerChams, function(v)
        Config.PlayerChams = v
        if v then for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreatePlayerCham(p) end end
        else for _, p in pairs(Players:GetPlayers()) do RemovePlayerCham(p) end end
    end)
    AddToggle("Player ESP", Config.PlayerESP, function(v)
        Config.PlayerESP = v
        if v then for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreatePlayerESP(p) end end
        else for _, p in pairs(Players:GetPlayers()) do RemovePlayerESP(p) end end
    end)
    AddSlider("WalkSpeed", 16, 200, Config.WalkSpeed, function(v) Config.WalkSpeed = v local h = GetHum() if h then h.WalkSpeed = v end end)
    AddSlider("JumpPower", 50, 300, Config.JumpPower, function(v) Config.JumpPower = v local h = GetHum() if h then h.JumpPower = v end end)
    AddSlider("FOV", 70, 120, Config.FOV, function(v) Config.FOV = v Camera.FieldOfView = v end)
    AddToggle("Lock FOV", Config.FOVLocked, function(v) Config.FOVLocked = v end)
    AddToggle("Infinite Jump", Config.InfJump, function(v) Config.InfJump = v end)
    AddToggle("Noclip", Config.Noclip, function(v) Config.Noclip = v end)
    AddToggle("Fly", Config.FlyEnabled, function(v) Config.FlyEnabled = v if v then StartFly() else StopFly() end end)
    AddSlider("Fly Speed", 10, 100, Config.FlySpeed, function(v) Config.FlySpeed = v end)
    AddToggle("FPS Boost", Config.FPSBoost, function(v) SetFPSBoost(v) end)
    AddTextbox("Copy Outfit (введи ник)", "Player name...", function(txt)
        if txt == "" then return end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Name:lower():find(txt:lower()) and p ~= LocalPlayer then
                CopyOutfit(p) return
            end
        end
        game.StarterGui:SetCore("SendNotification", {Title="❌ Не найден", Text="Игрок не найден", Duration=3})
    end)
end)

AddTab("Visuals", "🎨", function()
    AddToggle("Motion Blur", Config.MotionBlur, function(v) SetMotionBlur(v) end)
    AddSlider("Blur Intensity", 5, 50, Config.MotionBlurIntensity, function(v) Config.MotionBlurIntensity = v end)
    AddSlider("Saturation", -100, 100, Config.Saturation, function(v) SetSaturation(v / 100) end)
    AddToggle("Realistic (Reflections)", Config.Reflections, function(v) SetReflections(v) end)
    AddDropdown("Time of Day", {"Day","Noon","Evening","Sunset","Night","Midnight","Sunrise"}, "Day", function(t) SetTime(t) end)
    AddDropdown("Skybox", {"Default","Realistic","Sunset","Space","Nebula","Clouds"}, "Default", function(s) SetSkybox(s) end)
    AddToggle("Fullbright", Config.Fullbright, function(v) Config.Fullbright = v SetFullbright(v) end)
    AddToggle("Remove Fog", Config.RemoveFog, function(v) Config.RemoveFog = v SetRemoveFog(v) end)
end)

AddTab("Misc", "≡", function()
    AddDropdown("Theme", {"Default","Green","Red","Black","Transparent","Aios","Ocean","Sunset"}, Config.CurrentTheme, function(t)
        Config.CurrentTheme = t Colors = Themes[t]
        Main.BackgroundColor3 = Colors.Bg glow.Color = Colors.Glow
        ReopenBtn.BackgroundColor3 = Colors.Bg rbs.Color = Colors.Glow
        Title.TextColor3 = Colors.Text ContentTitle.TextColor3 = Colors.Text
        Content.ScrollBarImageColor3 = Colors.Accent
        if Tabs[CurrentTab] then ClearContent() Tabs[CurrentTab].func() end
    end)
end)

AddTab("Trap", "△", function()
    AddToggle("Auto Pass Bomb", Config.AutoPassBomb, function(v) Config.AutoPassBomb = v end)
    AddToggle("Auto Dodge Bomb", Config.AutoDodgeBomb, function(v) Config.AutoDodgeBomb = v end)
end)

AddTab("Server", "≣", function()
    AddButton("Rejoin", function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end)
    AddToggle("Anti AFK", Config.AntiAFK, function(v) Config.AntiAFK = v end)
end)

AddTab("Settings", "⚙", function()
    AddButton("Destroy GUI", function()
        sg:Destroy() ChamsFolder:Destroy() ESPFolder:Destroy()
        SetFullbright(false) SetRemoveFog(false) SetReflections(false) SetMotionBlur(false) SetFPSBoost(false) StopFly()
        pcall(function() local lt = game:GetService("Lighting")
            local s = lt:FindFirstChild("KloudSaturation") if s then s:Destroy() end
            for _, v in pairs(lt:GetChildren()) do if v:IsA("Sky") and v.Name == "KloudSky" then v:Destroy() end end
        end)
        Camera.FieldOfView = 70
        local h = GetHum() if h then h.WalkSpeed = 16 h.JumpPower = 50 end
    end)
end)

task.wait(0.1)
Tabs["Universal"].btn.BackgroundTransparency = 0
Tabs["Universal"].btn.BackgroundColor3 = Colors.Panel
Tabs["Universal"].btn.TextColor3 = Colors.Text
CurrentTab = "Universal" Tabs["Universal"].func()

CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false ReopenBtn.Visible = true end)
ReopenBtn.MouseButton1Click:Connect(function() Main.Visible = true ReopenBtn.Visible = false end)
UserInput.InputBegan:Connect(function(input, gp) if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if Main.Visible then Main.Visible = false ReopenBtn.Visible = true
        else Main.Visible = true ReopenBtn.Visible = false end
    end
end)

UserInput.JumpRequest:Connect(function()
    if Config.InfJump then local h = GetHum() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
end)

RunService.RenderStepped:Connect(function()
    if Config.FlyEnabled and flyBV and flyBG then
        local root = GetRoot()
        if root then
            local cam = Camera.CFrame
            local move = Vector3.new()
            if UserInput:IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
            if UserInput:IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
            if UserInput:IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
            if UserInput:IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
            if UserInput:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
            if UserInput:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
            flyBV.Velocity = move * Config.FlySpeed flyBG.CFrame = cam
        end
    end
    if Config.FOVLocked and Camera.FieldOfView ~= Config.FOV then Camera.FieldOfView = Config.FOV end
    if Config.Noclip then
        local c = LocalPlayer.Character
        if c then for _, v in pairs(c:GetDescendants()) do if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end end end
    end
    if Config.MotionBlur then
        pcall(function()
            local blur = game:GetService("Lighting"):FindFirstChild("KloudMotionBlur")
            if blur then
                local currentCF = Camera.CFrame
                local angleDiff = math.abs(currentCF.LookVector:Dot(lastCamCF.LookVector))
                local posDiff = (currentCF.Position - lastCamCF.Position).Magnitude
                local speed = math.clamp((1 - angleDiff) * 100 + posDiff, 0, 1)
                local targetBlur = speed * Config.MotionBlurIntensity
                blur.Size = blur.Size + (targetBlur - blur.Size) * 0.3
                lastCamCF = currentCF
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.15) do
        if Config.AutoPassBomb and HasBomb() then
            local target = GetClosestPlayer() local root = GetRoot()
            if target and target.Character and root then
                local tr = target.Character:FindFirstChild("HumanoidRootPart")
                if tr then pcall(function()
                    local tp = tr.Position local mp = tp + (tr.CFrame.LookVector * 3)
                    root.CFrame = CFrame.new(mp, tp)
                end) end
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
                        if d < 15 then root.CFrame = CFrame.new(root.Position + (root.Position - obj.Position).Unit * 30) break end
                    end
                end
            end
        end
    end
end)

LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then local vu = game:GetService("VirtualUser") vu:CaptureController() vu:ClickButton2(Vector2.new()) end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    local h = char:WaitForChild("Humanoid") task.wait(0.3)
    h.WalkSpeed = Config.WalkSpeed h.JumpPower = Config.JumpPower
    if Config.FlyEnabled then StopFly() task.wait(0.5) StartFly() end
    if Config.FPSBoost then task.wait(1) SetFPSBoost(true) end
end)

pcall(function() game.StarterGui:SetCore("SendNotification", {Title="⚡ Kloud Hub", Text="Loaded! RightShift = hide", Duration=5}) end)
