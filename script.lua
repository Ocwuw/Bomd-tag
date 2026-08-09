-- ⚡ Kloud Hub v4.4 | Full + Old Visuals
local Players = game.Players or game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game.Lighting or game:GetService("Lighting")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local GuiParent = (gethui and gethui()) or game:GetService("CoreGui")

local IS_MOBILE = UserInput.TouchEnabled and not UserInput.KeyboardEnabled

pcall(function() 
    local old = GuiParent:FindFirstChild("KloudHub") if old then old:Destroy() end
    local oldH = GuiParent:FindFirstChild("KloudHUD") if oldH then oldH:Destroy() end
    local oldM = GuiParent:FindFirstChild("KloudMobile") if oldM then oldM:Destroy() end
end)

local Themes = {
    Default = {Bg=Color3.fromRGB(30,15,50),Panel=Color3.fromRGB(45,25,70),Panel2=Color3.fromRGB(55,30,85),Accent=Color3.fromRGB(170,80,255),Glow=Color3.fromRGB(200,100,255),Text=Color3.fromRGB(255,255,255),TextDim=Color3.fromRGB(200,180,220),ToggleOff=Color3.fromRGB(60,40,80),Transparency=0},
    Green = {Bg=Color3.fromRGB(15,40,20),Panel=Color3.fromRGB(25,55,30),Panel2=Color3.fromRGB(35,70,40),Accent=Color3.fromRGB(80,255,120),Glow=Color3.fromRGB(100,255,140),Text=Color3.fromRGB(255,255,255),TextDim=Color3.fromRGB(200,220,200),ToggleOff=Color3.fromRGB(40,60,45),Transparency=0},
    Red = {Bg=Color3.fromRGB(40,15,15),Panel=Color3.fromRGB(60,25,25),Panel2=Color3.fromRGB(80,35,35),Accent=Color3.fromRGB(255,60,60),Glow=Color3.fromRGB(255,100,100),Text=Color3.fromRGB(255,255,255),TextDim=Color3.fromRGB(220,200,200),ToggleOff=Color3.fromRGB(70,40,40),Transparency=0},
    Black = {Bg=Color3.fromRGB(15,15,15),Panel=Color3.fromRGB(25,25,25),Panel2=Color3.fromRGB(40,40,40),Accent=Color3.fromRGB(180,180,180),Glow=Color3.fromRGB(255,255,255),Text=Color3.fromRGB(255,255,255),TextDim=Color3.fromRGB(180,180,180),ToggleOff=Color3.fromRGB(50,50,50),Transparency=0},
    Aios = {Bg=Color3.fromRGB(0,0,0),Panel=Color3.fromRGB(10,10,10),Panel2=Color3.fromRGB(25,25,25),Accent=Color3.fromRGB(255,255,255),Glow=Color3.fromRGB(255,255,255),Text=Color3.fromRGB(255,255,255),TextDim=Color3.fromRGB(200,200,200),ToggleOff=Color3.fromRGB(40,40,40),Transparency=0.5},
    Ocean = {Bg=Color3.fromRGB(10,25,50),Panel=Color3.fromRGB(20,40,75),Panel2=Color3.fromRGB(30,55,95),Accent=Color3.fromRGB(80,180,255),Glow=Color3.fromRGB(100,200,255),Text=Color3.fromRGB(255,255,255),TextDim=Color3.fromRGB(200,220,240),ToggleOff=Color3.fromRGB(40,60,90),Transparency=0},
    Fire = {Bg=Color3.fromRGB(40,15,5),Panel=Color3.fromRGB(70,25,10),Panel2=Color3.fromRGB(90,35,15),Accent=Color3.fromRGB(255,120,30),Glow=Color3.fromRGB(255,80,20),Text=Color3.fromRGB(255,255,255),TextDim=Color3.fromRGB(255,220,200),ToggleOff=Color3.fromRGB(70,35,20),Transparency=0},
}
local Colors = Themes.Default

local Config = {
    PlayerChams=false, PlayerESP=false, PredictESP=false, InfJump=false, Noclip=false,
    WalkSpeed=16, JumpPower=50, FOV=90, FOVLocked=true,
    Fullbright=false, RemoveFog=false, AntiAFK=true,
    FlyEnabled=false, FlySpeed=50, FPSBoost=false,
    SpeedGlitch=false, SpeedGlitchAmount=30, Particles=false,
    AutoDodgeBomb=false, AutoPassBomb=false,
    Reflections=false, GodRays=false, MotionBlur=false, Saturation=0, FireBorder=false,
    SoftBlur=false, ColorFilter=false, StrongBloom=false,
    TriggerBot=false, TriggerBotRange=30,
    AimbotV1=false, AimbotPart="Head", AimbotV2=false,
    RoleESP=false,
    AutoPickupGun=false, AutoPickupGunV2=false,
    FarmCoins=false, FarmCoinsV2=false, FarmCoinsSpeed=50,
    FakeSkin="None",
    HUDEnabled=true, ShowFPS=true, ShowTime=true, ShowPing=true, ShowSpectators=true,
    CurrentTheme="Default",
}
Config.AmbientBackup = Lighting.Ambient
Config.FogEndBackup = Lighting.FogEnd
Config.BrightnessBackup = Lighting.Brightness

local function GetHum() local c = LocalPlayer.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function GetRoot() local c = LocalPlayer.Character return c and c:FindFirstChild("HumanoidRootPart") end

local function HasBomb()
    local c = LocalPlayer.Character if not c then return false end
    for _, v in ipairs(c:GetChildren()) do if v:IsA("Tool") and v.Name:lower():find("bomb") then return true end end
    return false
end

local function GetClosestPlayer()
    local closest, dist = nil, math.huge
    local root = GetRoot() if not root then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
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

local function GetPlayerRole(Plr)
    if not Plr or not Plr.Character then return "Innocent" end
    local backpack = Plr:FindFirstChild("Backpack")
    local char = Plr.Character
    if (backpack and backpack:FindFirstChild("Knife")) or char:FindFirstChild("Knife") then return "Murderer" end
    if (backpack and backpack:FindFirstChild("Gun")) or char:FindFirstChild("Gun") or 
       (backpack and backpack:FindFirstChild("Revolver")) or char:FindFirstChild("Revolver") then return "Sheriff" end
    return "Innocent"
end

local function GetMurderer()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and GetPlayerRole(p) == "Murderer" then
            if p.Character and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                return p
            end
        end
    end
    return nil
end

local function GetDroppedGun()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if (obj:IsA("Tool") and (obj.Name == "Gun" or obj.Name == "Revolver")) or
           (obj:IsA("Model") and (obj.Name == "GunDrop" or obj.Name == "Gun")) then
            local part = obj:IsA("Tool") and obj:FindFirstChildOfClass("BasePart") or obj:FindFirstChildOfClass("BasePart") or obj.PrimaryPart
            if part and not obj.Parent:IsA("Backpack") and not Players:GetPlayerFromCharacter(obj.Parent) then
                return obj, part
            end
        end
    end
    return nil, nil
end

local function GetClosestCoin()
    local root = GetRoot() if not root then return nil end
    local closest, dist = nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        local part = nil
        if obj:IsA("BasePart") and (obj.Name:lower():find("coin") or obj.Name:lower():find("cash")) then
            part = obj
        elseif obj:IsA("Model") and obj.Name:lower():find("coin") then
            part = obj:FindFirstChildOfClass("BasePart") or obj.PrimaryPart
        end
        if part then
            local d = (root.Position - part.Position).Magnitude
            if d < dist then dist = d closest = part end
        end
    end
    return closest
end

local function CheckMurdererInSight(radius)
    local murderer = GetMurderer()
    if not murderer or not murderer.Character then return nil end
    local head = murderer.Character:FindFirstChild("Head")
    local root = GetRoot()
    if not head or not root then return nil end
    local dist = (root.Position - head.Position).Magnitude
    if dist > radius then return nil end
    local ray = Ray.new(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * dist)
    local part = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
    if part and part:IsDescendantOf(murderer.Character) then
        return murderer, head
    end
    return nil
end

local FakeSkinIds = {
    None = {mesh=nil, texture=nil},
    ["Chroma Seer"] = {mesh="rbxassetid://74540628", texture="rbxassetid://176558037"},
    ["Chroma Darkbringer"] = {mesh="rbxassetid://74540628", texture="rbxassetid://176557694"},
    ["Chroma Heat"] = {mesh="rbxassetid://74540628", texture="rbxassetid://176558169"},
    ["Chroma Gemstone"] = {mesh="rbxassetid://74540628", texture="rbxassetid://176557972"},
    ["Chroma Lightbringer"] = {mesh="rbxassetid://74540628", texture="rbxassetid://176558231"},
    ["Laser Gun"] = {mesh="rbxassetid://90646055", texture="rbxassetid://176558486"},
    ["Gemstone Gun"] = {mesh="rbxassetid://90646055", texture="rbxassetid://176558432"},
}

local function ApplyFakeSkin(skinName)
    Config.FakeSkin = skinName
    local char = LocalPlayer.Character
    if not char then return end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local handle = tool:FindFirstChild("Handle")
            if handle then
                local skin = FakeSkinIds[skinName]
                if skin and skin.mesh then
                    local mesh = handle:FindFirstChildOfClass("SpecialMesh") or Instance.new("SpecialMesh", handle)
                    mesh.MeshId = skin.mesh
                    if skin.texture then mesh.TextureId = skin.texture end
                end
            end
        end
    end
end

local particleAttach = nil
local function SetParticles(state)
    Config.Particles = state
    if particleAttach then particleAttach:Destroy() particleAttach = nil end
    if not state then return end
    local root = GetRoot() if not root then return end
    local att = Instance.new("Attachment", root)
    att.Name = "KloudParticles"
    particleAttach = att
    local colors = {
        Color3.fromRGB(255,80,80), Color3.fromRGB(80,255,80), Color3.fromRGB(80,80,255),
        Color3.fromRGB(255,255,80), Color3.fromRGB(255,80,255), Color3.fromRGB(80,255,255),
    }
    for i, color in ipairs(colors) do
        local p = Instance.new("ParticleEmitter", att)
        p.Texture = "rbxassetid://243660364"
        p.Color = ColorSequence.new(color)
        p.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 0.8)})
        p.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1)})
        p.Rate = 5 p.Lifetime = NumberRange.new(1, 2) p.Speed = NumberRange.new(2, 5)
        p.SpreadAngle = Vector2.new(180, 180)
    end
end

local ChamsFolder = Instance.new("Folder") ChamsFolder.Name = "KLOUD_Chams" ChamsFolder.Parent = GuiParent
local ESPFolder = Instance.new("Folder") ESPFolder.Name = "KLOUD_ESP" ESPFolder.Parent = GuiParent
local RoleESPFolder = Instance.new("Folder") RoleESPFolder.Name = "KLOUD_RoleESP" RoleESPFolder.Parent = GuiParent
local PredictFolder = Instance.new("Folder") PredictFolder.Name = "KLOUD_Predict" PredictFolder.Parent = workspace

local function CreatePlayerCham(Plr)
    if not Plr or Plr == LocalPlayer or not Plr.Character then return end
    local ex = ChamsFolder:FindFirstChild(Plr.Name) if ex then ex:Destroy() end
    local hl = Instance.new("Highlight")
    hl.Name = Plr.Name
    hl.Adornee = Plr.Character
    hl.FillColor = Colors.Accent
    hl.FillTransparency = 0.6
    hl.OutlineColor = Colors.Glow
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = ChamsFolder
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
end
local function RemovePlayerESP(Plr) local f = ESPFolder:FindFirstChild(Plr.Name) if f then f:Destroy() end end

local function CreatePredictESP(Plr)
    if not Plr or Plr == LocalPlayer or not Plr.Character then return end
    local ex = PredictFolder:FindFirstChild(Plr.Name) if ex then ex:Destroy() end
    local part = Instance.new("Part")
    part.Name = Plr.Name
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.Color = Colors.Accent
    part.Size = Vector3.new(0.15, 0.15, 1)
    part.Transparency = 0.3
    part.Parent = PredictFolder
end
local function RemovePredictESP(Plr) local f = PredictFolder:FindFirstChild(Plr.Name) if f then f:Destroy() end end

local function UpdatePredictESP()
    for _, Plr in ipairs(Players:GetPlayers()) do
        if Plr ~= LocalPlayer and Plr.Character then
            local root = Plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local vel = root.AssemblyLinearVelocity
                local speed = Vector3.new(vel.X, 0, vel.Z).Magnitude
                local line = PredictFolder:FindFirstChild(Plr.Name)
                if line and line:IsA("Part") then
                    if speed > 2 then
                        local predictPos = root.Position + Vector3.new(vel.X, 0, vel.Z) * 0.6
                        local dist = (root.Position - predictPos).Magnitude
                        line.Size = Vector3.new(0.2, 0.2, dist)
                        line.CFrame = CFrame.new(root.Position, predictPos) * CFrame.new(0, 0, -dist/2)
                        line.Transparency = 0.2
                        line.Color = speed > 20 and Color3.fromRGB(255, 100, 100) or Colors.Accent
                    else
                        line.Transparency = 1
                    end
                end
            end
        end
    end
end

local function CreateRoleESP(Plr)
    if not Plr or Plr == LocalPlayer or not Plr.Character then return end
    local head = Plr.Character:FindFirstChild("Head") if not head then return end
    local ex = RoleESPFolder:FindFirstChild(Plr.Name) if ex then ex:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Adornee = head bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0, 150, 0, 50) bb.StudsOffset = Vector3.new(0, 2.5, 0)
    bb.Name = Plr.Name bb.Parent = RoleESPFolder
    local name = Instance.new("TextLabel", bb)
    name.Size = UDim2.new(1, 0, 0, 20) name.BackgroundTransparency = 1
    name.Text = Plr.Name name.Font = Enum.Font.GothamBold name.TextSize = 13
    name.TextColor3 = Color3.new(1,1,1) name.TextStrokeTransparency = 0.2
    local role = Instance.new("TextLabel", bb)
    role.Name = "Role" role.Size = UDim2.new(1, 0, 0, 18)
    role.Position = UDim2.new(0, 0, 0, 20) role.BackgroundTransparency = 1
    role.Font = Enum.Font.GothamBold role.TextSize = 12 role.TextStrokeTransparency = 0.2
end
local function RemoveRoleESP(Plr) local f = RoleESPFolder:FindFirstChild(Plr.Name) if f then f:Destroy() end end

local function SetupCharAdded(Plr)
    if Plr == LocalPlayer then return end
    Plr.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart", 10) task.wait(1)
        if Config.PlayerChams then CreatePlayerCham(Plr) end
        if Config.PlayerESP then CreatePlayerESP(Plr) end
        if Config.RoleESP then CreateRoleESP(Plr) end
        if Config.PredictESP then CreatePredictESP(Plr) end
    end)
    Plr.CharacterRemoving:Connect(function() 
        RemovePlayerCham(Plr) RemovePlayerESP(Plr) RemoveRoleESP(Plr) RemovePredictESP(Plr)
    end)
end
for _, p in ipairs(Players:GetPlayers()) do SetupCharAdded(p) end
Players.PlayerAdded:Connect(SetupCharAdded)
Players.PlayerRemoving:Connect(function(p) RemovePlayerCham(p) RemovePlayerESP(p) RemoveRoleESP(p) RemovePredictESP(p) end)

local function SetFullbright(s)
    if s then Lighting.Ambient=Color3.new(1,1,1) Lighting.ColorShift_Bottom=Color3.new(1,1,1) Lighting.ColorShift_Top=Color3.new(1,1,1)
    else Lighting.Ambient=Config.AmbientBackup end
end
local function SetRemoveFog(s) if s then Lighting.FogEnd=100000 else Lighting.FogEnd=Config.FogEndBackup end end

local flyBV, flyBG
local function StartFly()
    local root = GetRoot() if not root then return end
    flyBV = Instance.new("BodyVelocity", root) flyBV.MaxForce = Vector3.new(9e9,9e9,9e9) flyBV.Velocity = Vector3.new(0,0,0)
    flyBG = Instance.new("BodyGyro", root) flyBG.MaxTorque = Vector3.new(9e9,9e9,9e9) flyBG.P = 1000
end
local function StopFly() if flyBV then flyBV:Destroy() flyBV = nil end if flyBG then flyBG:Destroy() flyBG = nil end end

local function SetGodRays(s)
    Config.GodRays = s
    if s then
        local sr = Lighting:FindFirstChild("KloudGodRays") or Instance.new("SunRaysEffect", Lighting)
        sr.Name = "KloudGodRays" sr.Intensity = 0.5 sr.Spread = 1
        local bloom = Lighting:FindFirstChild("KloudLightBloom") or Instance.new("BloomEffect", Lighting)
        bloom.Name = "KloudLightBloom" bloom.Intensity = 0.8 bloom.Size = 30 bloom.Threshold = 0.7
        local dof = Lighting:FindFirstChild("KloudDOF") or Instance.new("DepthOfFieldEffect", Lighting)
        dof.Name = "KloudDOF" dof.FarIntensity = 0.1 dof.FocusDistance = 50 dof.InFocusRadius = 30 dof.NearIntensity = 0
        Lighting.GlobalShadows = true Lighting.Brightness = 2
        Lighting.EnvironmentDiffuseScale = 0.5 Lighting.EnvironmentSpecularScale = 0.5
        Lighting.ExposureCompensation = 0.3
    else
        local sr = Lighting:FindFirstChild("KloudGodRays") if sr then sr:Destroy() end
        local bloom = Lighting:FindFirstChild("KloudLightBloom") if bloom then bloom:Destroy() end
        local dof = Lighting:FindFirstChild("KloudDOF") if dof then dof:Destroy() end
        Lighting.Brightness = Config.BrightnessBackup
        Lighting.EnvironmentDiffuseScale = 0 Lighting.EnvironmentSpecularScale = 0
        Lighting.ExposureCompensation = 0
    end
end

local function SetReflections(s)
    Config.Reflections = s
    if s then
        local bloom = Lighting:FindFirstChild("KloudBloom") or Instance.new("BloomEffect", Lighting)
        bloom.Name = "KloudBloom" bloom.Intensity = 0.3 bloom.Size = 24 bloom.Threshold = 0.8
    else
        local b = Lighting:FindFirstChild("KloudBloom") if b then b:Destroy() end
    end
end

local function SetMotionBlur(enabled)
    Config.MotionBlur = enabled
    if enabled then
        local blur = Lighting:FindFirstChild("KloudMotionBlur") or Instance.new("BlurEffect", Lighting)
        blur.Name = "KloudMotionBlur" blur.Size = 0
    else
        local blur = Lighting:FindFirstChild("KloudMotionBlur") if blur then blur:Destroy() end
    end
end

local function SetSoftBlur(s)
    Config.SoftBlur = s
    if s then
        local b = Lighting:FindFirstChild("KloudSoftBlur") or Instance.new("BlurEffect", Lighting)
        b.Name = "KloudSoftBlur" b.Size = 4
    else
        local b = Lighting:FindFirstChild("KloudSoftBlur") if b then b:Destroy() end
    end
end

local function SetColorFilter(s)
    Config.ColorFilter = s
    if s then
        local cc = Lighting:FindFirstChild("KloudColorFilter") or Instance.new("ColorCorrectionEffect", Lighting)
        cc.Name = "KloudColorFilter" cc.Contrast = 0.2 cc.Brightness = 0.05
    else
        local cc = Lighting:FindFirstChild("KloudColorFilter") if cc then cc:Destroy() end
    end
end

local function SetStrongBloom(s)
    Config.StrongBloom = s
    if s then
        local b = Lighting:FindFirstChild("KloudStrongBloom") or Instance.new("BloomEffect", Lighting)
        b.Name = "KloudStrongBloom" b.Intensity = 1 b.Size = 24 b.Threshold = 0.5
    else
        local b = Lighting:FindFirstChild("KloudStrongBloom") if b then b:Destroy() end
    end
end

local function SetSaturation(val)
    Config.Saturation = val
    local cc = Lighting:FindFirstChild("KloudSaturation") or Instance.new("ColorCorrectionEffect", Lighting)
    cc.Name = "KloudSaturation" cc.Saturation = val
end

local timeMap = {Day=12, Noon=14, Evening=18, Sunset=19, Night=0, Midnight=23, Sunrise=6}
local function SetTime(t) if timeMap[t] then Lighting.ClockTime = timeMap[t] end end

local Skyboxes = {Realistic="rbxassetid://6444884785", Sunset="rbxassetid://271042516", Space="rbxassetid://159454299", Clouds="rbxassetid://456977674"}
local function SetSkybox(name)
    for _, v in ipairs(Lighting:GetChildren()) do if v:IsA("Sky") then v:Destroy() end end
    if name == "Default" then return end
    local sky = Instance.new("Sky") sky.Name = "KloudSky"
    local id = Skyboxes[name]
    if id then sky.SkyboxUp=id sky.SkyboxDn=id sky.SkyboxLf=id sky.SkyboxRt=id sky.SkyboxFt=id sky.SkyboxBk=id end
    sky.StarCount = (name == "Space") and 3000 or 0
    sky.Parent = Lighting
end

local originalCastShadow = {}
local function SetFPSBoost(s)
    Config.FPSBoost = s
    if s then
        Lighting.GlobalShadows = false
        if workspace.Terrain then workspace.Terrain.Decoration = false end
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                if originalCastShadow[v] == nil then originalCastShadow[v] = v.CastShadow end
                v.CastShadow = false v.Material = Enum.Material.SmoothPlastic
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                if v.Parent ~= particleAttach then v.Enabled = false end
            elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
        end
    else
        Lighting.GlobalShadows = true
        if workspace.Terrain then workspace.Terrain.Decoration = true end
        for part, val in pairs(originalCastShadow) do if part and part.Parent then part.CastShadow = val end end
    end
end

local function CopyOutfit(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local myChar = LocalPlayer.Character if not myChar then return end
    local myHum = myChar:FindFirstChildOfClass("Humanoid")
    local targetHum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not myHum or not targetHum then return end
    for _, v in ipairs(myChar:GetChildren()) do
        if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("BodyColors") then v:Destroy() end
    end
    for _, v in ipairs(targetPlayer.Character:GetChildren()) do
        if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("ShirtGraphic") or v:IsA("BodyColors") then
            v:Clone().Parent = myChar
        end
    end
    pcall(function() myHum:ApplyDescription(targetHum:GetAppliedDescription()) end)
end-- ============ HUD ============
local hudGui = Instance.new("ScreenGui") hudGui.Name = "KloudHUD" hudGui.ResetOnSpawn = false hudGui.Parent = GuiParent

local topHud = Instance.new("Frame", hudGui)
topHud.Size = UDim2.new(0, 220, 0, 22)
topHud.Position = UDim2.new(0, 10, 0, 10)
topHud.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
topHud.BackgroundTransparency = 0.4
topHud.BorderSizePixel = 0
Instance.new("UICorner", topHud).CornerRadius = UDim.new(0, 4)
local topHudStroke = Instance.new("UIStroke", topHud) topHudStroke.Color = Colors.Accent topHudStroke.Thickness = 1 topHudStroke.Transparency = 0.5

local hudLayout = Instance.new("UIListLayout", topHud)
hudLayout.FillDirection = Enum.FillDirection.Horizontal
hudLayout.Padding = UDim.new(0, 10)
hudLayout.VerticalAlignment = Enum.VerticalAlignment.Center
Instance.new("UIPadding", topHud).PaddingLeft = UDim.new(0, 8)

local function makeHudLabel(name, defaultText, size)
    local lbl = Instance.new("TextLabel", topHud)
    lbl.Name = name
    lbl.Size = UDim2.new(0, size or 60, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = defaultText
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

local fpsLabel = makeHudLabel("FPS", "⚡ 60", 55)
local timeLabel = makeHudLabel("Time", "🕐 00:00:00", 70)
local pingLabel = makeHudLabel("Ping", "📶 0ms", 60)

local spectFrame = Instance.new("Frame", hudGui)
spectFrame.Size = UDim2.new(0, 160, 0, 30)
spectFrame.Position = UDim2.new(1, -170, 0.35, 0)
spectFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
spectFrame.BackgroundTransparency = 0.4
spectFrame.BorderSizePixel = 0
spectFrame.AutomaticSize = Enum.AutomaticSize.Y
Instance.new("UICorner", spectFrame).CornerRadius = UDim.new(0, 4)
local spectStroke = Instance.new("UIStroke", spectFrame) spectStroke.Color = Colors.Accent spectStroke.Thickness = 1 spectStroke.Transparency = 0.5

local spectTitle = Instance.new("TextLabel", spectFrame)
spectTitle.Size = UDim2.new(1, -10, 0, 22)
spectTitle.Position = UDim2.new(0, 5, 0, 2)
spectTitle.BackgroundTransparency = 1
spectTitle.Text = "👁 Spectators"
spectTitle.Font = Enum.Font.GothamBold
spectTitle.TextSize = 12
spectTitle.TextColor3 = Colors.Accent
spectTitle.TextXAlignment = Enum.TextXAlignment.Left

local spectList = Instance.new("Frame", spectFrame)
spectList.Size = UDim2.new(1, -10, 0, 0)
spectList.Position = UDim2.new(0, 5, 0, 24)
spectList.BackgroundTransparency = 1
spectList.BorderSizePixel = 0
spectList.AutomaticSize = Enum.AutomaticSize.Y
local spectLayout = Instance.new("UIListLayout", spectList) 
spectLayout.Padding = UDim.new(0, 1)
spectLayout.SortOrder = Enum.SortOrder.LayoutOrder
Instance.new("UIPadding", spectList).PaddingBottom = UDim.new(0, 4)

local function UpdateSpectators()
    for _, v in ipairs(spectList:GetChildren()) do if v:IsA("TextLabel") then v:Destroy() end end
    local order = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            order = order + 1
            local isDead = p.Character and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health <= 0
            local lbl = Instance.new("TextLabel", spectList)
            lbl.Size = UDim2.new(1, 0, 0, 14)
            lbl.BackgroundTransparency = 1
            lbl.Text = (isDead and "💀 " or "🎮 ") .. p.Name
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 11
            lbl.TextColor3 = isDead and Color3.fromRGB(255,120,120) or Color3.new(1,1,1)
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.LayoutOrder = order
        end
    end
end

local fpsFrames = {}
local lastTick = tick()
RunService.RenderStepped:Connect(function()
    if not Config.HUDEnabled then return end
    local now = tick()
    local fps = 1 / (now - lastTick)
    lastTick = now
    table.insert(fpsFrames, fps)
    if #fpsFrames > 15 then table.remove(fpsFrames, 1) end
end)

task.spawn(function()
    while task.wait(1) do
        if hudGui.Parent and Config.HUDEnabled then
            fpsLabel.Visible = Config.ShowFPS
            timeLabel.Visible = Config.ShowTime
            pingLabel.Visible = Config.ShowPing
            if Config.ShowFPS then
                local sum = 0
                for _, f in ipairs(fpsFrames) do sum = sum + f end
                local avgFps = math.floor(sum / math.max(#fpsFrames, 1))
                fpsLabel.Text = "⚡ " .. avgFps
                fpsLabel.TextColor3 = avgFps > 40 and Color3.fromRGB(120,255,120) or (avgFps > 20 and Color3.fromRGB(255,220,100) or Color3.fromRGB(255,80,80))
            end
            if Config.ShowTime then timeLabel.Text = "🕐 " .. os.date("%H:%M:%S") end
            if Config.ShowPing then
                pcall(function()
                    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
                    pingLabel.Text = "📶 " .. ping .. "ms"
                end)
            end
            spectFrame.Visible = Config.ShowSpectators
            if Config.ShowSpectators then UpdateSpectators() end
        end
    end
end)

-- ============ МОБИЛЬНЫЕ КНОПКИ ============
local mobileGui = Instance.new("ScreenGui") mobileGui.Name = "KloudMobile" mobileGui.ResetOnSpawn = false mobileGui.Parent = GuiParent
mobileGui.Enabled = IS_MOBILE

local function CreateMobileBtn(name, text, pos, callback)
    local btn = Instance.new("TextButton", mobileGui)
    btn.Name = name
    btn.Size = UDim2.new(0, 65, 0, 65)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(30, 15, 50)
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Active = true
    btn.Draggable = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    local st = Instance.new("UIStroke", btn) st.Color = Colors.Glow st.Thickness = 2 st.Transparency = 0.3
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local mobileFly = CreateMobileBtn("Fly", "🚀\nFly", UDim2.new(1, -80, 0.5, -100), function()
    Config.FlyEnabled = not Config.FlyEnabled
    if Config.FlyEnabled then StartFly() mobileFly.BackgroundColor3 = Colors.Accent
    else StopFly() mobileFly.BackgroundColor3 = Color3.fromRGB(30, 15, 50) end
end)

local mobileJump = CreateMobileBtn("Jump", "⬆️\nInf Jump", UDim2.new(1, -80, 0.5, -25), function()
    Config.InfJump = not Config.InfJump
    mobileJump.BackgroundColor3 = Config.InfJump and Colors.Accent or Color3.fromRGB(30, 15, 50)
end)

local mobileAttack = CreateMobileBtn("Attack", "⚔️\nAttack", UDim2.new(1, -80, 0.5, 50), function()
    local char = LocalPlayer.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then pcall(function() tool:Activate() end) end
        end
    end
end)

local mobileMenu = CreateMobileBtn("Menu", "☰\nMenu", UDim2.new(0, 15, 0.5, -30), function() end)
mobileMenu.BackgroundColor3 = Colors.Accent

-- ============ MAIN UI ============
local sg = Instance.new("ScreenGui") sg.Name = "KloudHub" sg.ResetOnSpawn = false sg.Parent = GuiParent

local MENU_WIDTH = IS_MOBILE and 500 or 620
local MENU_HEIGHT = IS_MOBILE and 340 or 420

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, MENU_WIDTH, 0, MENU_HEIGHT)
Main.Position = UDim2.new(0.5, -MENU_WIDTH/2, 0.5, -MENU_HEIGHT/2)
Main.BackgroundColor3 = Colors.Bg Main.BorderSizePixel = 0 Main.Active = true Main.Draggable = true Main.Parent = sg
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local outerGlow = Instance.new("ImageLabel", Main)
outerGlow.Size = UDim2.new(1, 60, 1, 60) outerGlow.Position = UDim2.new(0, -30, 0, -30)
outerGlow.BackgroundTransparency = 1 outerGlow.Image = "rbxassetid://5028857084"
outerGlow.ImageColor3 = Colors.Glow outerGlow.ImageTransparency = 0.3
outerGlow.ScaleType = Enum.ScaleType.Slice outerGlow.SliceCenter = Rect.new(24, 24, 276, 276) outerGlow.ZIndex = -1

local borderStroke = Instance.new("UIStroke", Main)
borderStroke.Thickness = 3 borderStroke.Color = Colors.Glow
borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
borderStroke.LineJoinMode = Enum.LineJoinMode.Round
local borderGradient = Instance.new("UIGradient", borderStroke)
borderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Colors.Accent),
    ColorSequenceKeypoint.new(0.5, Colors.Glow),
    ColorSequenceKeypoint.new(1, Colors.Accent),
})

local fireContainer = Instance.new("Frame", Main)
fireContainer.Size = UDim2.new(1, 20, 1, 20)
fireContainer.Position = UDim2.new(0, -10, 0, -10)
fireContainer.BackgroundTransparency = 1
fireContainer.BorderSizePixel = 0
fireContainer.ZIndex = -2
fireContainer.Visible = false
fireContainer.ClipsDescendants = false

local fireParticles = {}
local function CreateFireParticle()
    local p = Instance.new("ImageLabel", fireContainer)
    p.Size = UDim2.new(0, math.random(15, 30), 0, math.random(15, 30))
    p.BackgroundTransparency = 1
    p.Image = "rbxassetid://243660364"
    p.ImageColor3 = Color3.fromRGB(255, math.random(80, 180), math.random(0, 50))
    p.ImageTransparency = 0.3
    p.ZIndex = -2
    return p
end

local function SpawnFire()
    for i = 1, 12 do
        local p = CreateFireParticle()
        table.insert(fireParticles, {particle = p, side = math.random(1, 4), offset = math.random()})
    end
end

local function DestroyFire()
    for _, data in ipairs(fireParticles) do if data.particle then data.particle:Destroy() end end
    fireParticles = {}
end

local fireTime = 0
local fireConn = RunService.RenderStepped:Connect(function(dt)
    if not sg.Parent then fireConn:Disconnect() return end
    if not Config.FireBorder then return end
    fireTime = fireTime + dt
    for i, data in ipairs(fireParticles) do
        local p = data.particle
        if p and p.Parent then
            local t = (fireTime + data.offset * 2) % 2
            local progress = t / 2
            local wobble = math.sin(fireTime * 3 + i) * 5
            local mainSize = Main.AbsoluteSize
            if data.side == 1 then
                p.Position = UDim2.new(0, (mainSize.X * data.offset) + wobble, 0, -20 - progress * 30)
            elseif data.side == 2 then
                p.Position = UDim2.new(0, (mainSize.X * data.offset) + wobble, 1, -10 + progress * 30)
            elseif data.side == 3 then
                p.Position = UDim2.new(0, -20 - progress * 30, 0, (mainSize.Y * data.offset) + wobble)
            else
                p.Position = UDim2.new(1, -10 + progress * 30, 0, (mainSize.Y * data.offset) + wobble)
            end
            p.ImageTransparency = 0.2 + progress * 0.7
            local s = math.random(15, 30) * (1 - progress * 0.5)
            p.Size = UDim2.new(0, s, 0, s)
        end
    end
end)

local function SetFireBorder(on)
    Config.FireBorder = on
    fireContainer.Visible = on
    if on and #fireParticles == 0 then SpawnFire()
    elseif not on then DestroyFire() end
end

local rotationTime = 0
local borderConn = RunService.RenderStepped:Connect(function(dt)
    if not sg.Parent then borderConn:Disconnect() return end
    rotationTime = rotationTime + dt * 60
    if rotationTime >= 360 then rotationTime = 0 end
    borderGradient.Rotation = rotationTime
end)

local TitleBar = Instance.new("Frame", Main) TitleBar.Size = UDim2.new(1,0,0,35) TitleBar.BackgroundTransparency = 1

local BoltLabel = Instance.new("TextLabel", TitleBar)
BoltLabel.Size = UDim2.new(0,25,0,25) BoltLabel.Position = UDim2.new(0,5,0,5)
BoltLabel.BackgroundTransparency = 1 BoltLabel.Text = "⚡" BoltLabel.TextSize = 18 BoltLabel.Font = Enum.Font.GothamBold
BoltLabel.TextColor3 = Color3.new(1,1,1)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(0,200,1,0) Title.Position = UDim2.new(0,30,0,0)
Title.BackgroundTransparency = 1 Title.Text = "Kloud Hub" Title.Font = Enum.Font.GothamBold
Title.TextSize = 15 Title.TextColor3 = Colors.Text Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0,30,0,25) CloseBtn.Position = UDim2.new(1,-35,0,5)
CloseBtn.BackgroundTransparency = 1 CloseBtn.Text = "×" CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22 CloseBtn.TextColor3 = Colors.TextDim CloseBtn.AutoButtonColor = false

local ReopenBtn = Instance.new("TextButton", sg)
ReopenBtn.Size = UDim2.new(0,80,0,35) ReopenBtn.Position = UDim2.new(0,20,0,100)
ReopenBtn.BackgroundColor3 = Colors.Bg ReopenBtn.Text = "⚡ Kloud" ReopenBtn.Font = Enum.Font.GothamBold
ReopenBtn.TextSize = 13 ReopenBtn.TextColor3 = Colors.Text ReopenBtn.BorderSizePixel = 0
ReopenBtn.Visible = false ReopenBtn.Active = true ReopenBtn.Draggable = true ReopenBtn.AutoButtonColor = false
Instance.new("UICorner", ReopenBtn).CornerRadius = UDim.new(0,8)
local rbs = Instance.new("UIStroke", ReopenBtn) rbs.Color = Colors.Glow rbs.Thickness = 2 rbs.Transparency = 0.3

local SIDEBAR_WIDTH = IS_MOBILE and 120 or 145
local Sidebar = Instance.new("ScrollingFrame", Main)
Sidebar.Size = UDim2.new(0, SIDEBAR_WIDTH, 1, -50) 
Sidebar.Position = UDim2.new(0, 10, 0, 45) 
Sidebar.BackgroundTransparency = 1
Sidebar.BorderSizePixel = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
Sidebar.ScrollBarThickness = 2
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0,4)

local ContentTitle = Instance.new("TextLabel", Main)
ContentTitle.Size = UDim2.new(1, -SIDEBAR_WIDTH-30, 0, 35) 
ContentTitle.Position = UDim2.new(0, SIDEBAR_WIDTH+25, 0, 45)
ContentTitle.BackgroundTransparency = 1 ContentTitle.Text = "Universal" ContentTitle.Font = Enum.Font.GothamBold
ContentTitle.TextSize = 22 ContentTitle.TextColor3 = Colors.Text ContentTitle.TextXAlignment = Enum.TextXAlignment.Left

local Content = Instance.new("ScrollingFrame", Main)
Content.Size = UDim2.new(1, -SIDEBAR_WIDTH-30, 1, -95) 
Content.Position = UDim2.new(0, SIDEBAR_WIDTH+25, 0, 85)
Content.BackgroundTransparency = 1 Content.BorderSizePixel = 0
Content.CanvasSize = UDim2.new(0,0,0,0) Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.ScrollBarThickness = 3 Content.ScrollBarImageColor3 = Colors.Accent
Instance.new("UIListLayout", Content).Padding = UDim.new(0,8)

local Tabs = {}
local CurrentTab = nil
local function ClearContent() for _, v in ipairs(Content:GetChildren()) do if not v:IsA("UIListLayout") then v:Destroy() end end end

local function AddToggle(name, default, callback)
    local frame = Instance.new("Frame", Content) frame.Size = UDim2.new(1,-5,0,45)
    frame.BackgroundColor3 = Colors.Panel frame.BackgroundTransparency = Colors.Transparency frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)
    local lbl = Instance.new("TextLabel", frame) lbl.Size = UDim2.new(1,-70,1,0) lbl.Position = UDim2.new(0,15,0,0)
    lbl.BackgroundTransparency = 1 lbl.Text = name lbl.Font = Enum.Font.Gotham lbl.TextSize = 13
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
    lbl.BackgroundTransparency = 1 lbl.Text = name lbl.Font = Enum.Font.Gotham lbl.TextSize = 13
    lbl.TextColor3 = Colors.Text lbl.TextXAlignment = Enum.TextXAlignment.Left
    local val = Instance.new("TextLabel", frame) val.Size = UDim2.new(0,50,0,25) val.Position = UDim2.new(1,-65,0,5)
    val.BackgroundTransparency = 1 val.Text = tostring(default) val.Font = Enum.Font.GothamBold
    val.TextSize = 13 val.TextColor3 = Colors.Accent val.TextXAlignment = Enum.TextXAlignment.Right
    local bar = Instance.new("Frame", frame) bar.Size = UDim2.new(1,-30,0,5) bar.Position = UDim2.new(0,15,0,35)
    bar.BackgroundColor3 = Colors.ToggleOff bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)
    local fill = Instance.new("Frame", bar) fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = Colors.Accent fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)
    local dragging = false
    bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    UserInput.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    UserInput.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            local v = math.floor(min + (max-min) * pos)
            fill.Size = UDim2.new(pos,0,1,0) val.Text = tostring(v) callback(v)
        end
    end)
end

local function AddButton(name, callback)
    local btn = Instance.new("TextButton", Content) btn.Size = UDim2.new(1,-5,0,40)
    btn.BackgroundColor3 = Colors.Panel btn.BackgroundTransparency = Colors.Transparency
    btn.Text = name btn.Font = Enum.Font.GothamBold btn.TextSize = 13
    btn.TextColor3 = Colors.Text btn.AutoButtonColor = false btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    btn.MouseButton1Click:Connect(callback)
end

local function AddDropdown(name, options, default, callback)
    local frame = Instance.new("Frame", Content) frame.Size = UDim2.new(1,-5,0,45)
    frame.BackgroundColor3 = Colors.Panel frame.BackgroundTransparency = Colors.Transparency frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)
    local lbl = Instance.new("TextLabel", frame) lbl.Size = UDim2.new(0.4,0,1,0) lbl.Position = UDim2.new(0,15,0,0)
    lbl.BackgroundTransparency = 1 lbl.Text = name lbl.Font = Enum.Font.Gotham lbl.TextSize = 13
    lbl.TextColor3 = Colors.Text lbl.TextXAlignment = Enum.TextXAlignment.Left
    local btn = Instance.new("TextButton", frame) btn.Size = UDim2.new(0.6,-20,0,25)
    btn.Position = UDim2.new(0.4,5,0.5,-12) btn.BackgroundColor3 = Colors.Panel2
    btn.Text = default.." ▼" btn.Font = Enum.Font.Gotham btn.TextSize = 11
    btn.TextColor3 = Colors.Text btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
    local idx = 1
    for i, v in ipairs(options) do if v == default then idx = i end end
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
    lbl.BackgroundTransparency = 1 lbl.Text = name lbl.Font = Enum.Font.Gotham lbl.TextSize = 12
    lbl.TextColor3 = Colors.Text lbl.TextXAlignment = Enum.TextXAlignment.Left
    local tb = Instance.new("TextBox", frame) tb.Size = UDim2.new(0.6,-20,0,25)
    tb.Position = UDim2.new(0.4,5,0.5,-12) tb.BackgroundColor3 = Colors.Panel2
    tb.Text = "" tb.PlaceholderText = placeholder tb.Font = Enum.Font.Gotham tb.TextSize = 11
    tb.TextColor3 = Colors.Text tb.PlaceholderColor3 = Colors.TextDim tb.BorderSizePixel = 0
    tb.ClearTextOnFocus = false
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0,4)
    tb.FocusLost:Connect(function() callback(tb.Text) end)
end

local function AddTab(name, icon, contentFunc)
    local btn = Instance.new("TextButton", Sidebar) btn.Size = UDim2.new(1,0,0,36)
    btn.BackgroundColor3 = Colors.Panel btn.BackgroundTransparency = 1
    btn.Text = "  "..icon.."  "..name btn.Font = Enum.Font.Gotham btn.TextSize = 13
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
end-- ============ ВКЛАДКИ ============
AddTab("Universal", "🌐", function()
    AddToggle("Player Chams (Highlight)", Config.PlayerChams, function(v)
        Config.PlayerChams = v
        if v then for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreatePlayerCham(p) end end
        else for _, p in ipairs(Players:GetPlayers()) do RemovePlayerCham(p) end end
    end)
    AddToggle("Player ESP (Names)", Config.PlayerESP, function(v)
        Config.PlayerESP = v
        if v then for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreatePlayerESP(p) end end
        else for _, p in ipairs(Players:GetPlayers()) do RemovePlayerESP(p) end end
    end)
    AddToggle("Predict ESP (Movement)", Config.PredictESP, function(v)
        Config.PredictESP = v
        if v then for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreatePredictESP(p) end end
        else PredictFolder:ClearAllChildren() end
    end)
    AddSlider("WalkSpeed", 16, 200, Config.WalkSpeed, function(v) Config.WalkSpeed = v local h = GetHum() if h then h.WalkSpeed = v end end)
    AddSlider("JumpPower", 50, 300, Config.JumpPower, function(v) Config.JumpPower = v local h = GetHum() if h then h.JumpPower = v end end)
    AddSlider("FOV", 70, 120, Config.FOV, function(v) Config.FOV = v Camera.FieldOfView = v end)
    AddToggle("Lock FOV", Config.FOVLocked, function(v) Config.FOVLocked = v end)
    AddToggle("Noclip", Config.Noclip, function(v) Config.Noclip = v end)
    AddToggle("Fly", Config.FlyEnabled, function(v) Config.FlyEnabled = v if v then StartFly() else StopFly() end end)
    AddSlider("Fly Speed", 10, 100, Config.FlySpeed, function(v) Config.FlySpeed = v end)
    AddToggle("FPS Boost", Config.FPSBoost, function(v) SetFPSBoost(v) end)
    AddToggle("Particles (Colorful)", Config.Particles, function(v) SetParticles(v) end)
    AddTextbox("Copy Outfit", "Player name...", function(txt)
        if txt == "" then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name:lower():find(txt:lower()) and p ~= LocalPlayer then CopyOutfit(p) return end
        end
    end)
end)

AddTab("Movement", "🏃", function()
    AddToggle("Infinite Jump", Config.InfJump, function(v) Config.InfJump = v end)
    AddToggle("Speed Glitch (Jump = Speed)", Config.SpeedGlitch, function(v) Config.SpeedGlitch = v end)
    AddSlider("Glitch Speed Boost", 10, 100, Config.SpeedGlitchAmount, function(v) Config.SpeedGlitchAmount = v end)
end)

AddTab("Visuals", "🎨", function()
    AddToggle("Motion Blur", Config.MotionBlur, function(v) SetMotionBlur(v) end)
    AddToggle("Bloom (Strong)", Config.StrongBloom, function(v) SetStrongBloom(v) end)
    AddToggle("Color Filter", Config.ColorFilter, function(v) SetColorFilter(v) end)
    AddToggle("Soft Blur", Config.SoftBlur, function(v) SetSoftBlur(v) end)
    AddToggle("God Rays (Shaders)", Config.GodRays, function(v) SetGodRays(v) end)
    AddToggle("Realistic (Bloom)", Config.Reflections, function(v) SetReflections(v) end)
    AddSlider("Saturation", -100, 100, Config.Saturation, function(v) SetSaturation(v / 100) end)
    AddDropdown("Time", {"Day","Noon","Evening","Sunset","Night","Midnight","Sunrise"}, "Day", function(t) SetTime(t) end)
    AddDropdown("Skybox", {"Default","Realistic","Sunset","Space","Clouds"}, "Default", function(s) SetSkybox(s) end)
    AddToggle("Fullbright", Config.Fullbright, function(v) Config.Fullbright = v SetFullbright(v) end)
    AddToggle("Remove Fog", Config.RemoveFog, function(v) Config.RemoveFog = v SetRemoveFog(v) end)
    AddToggle("Fire Border", Config.FireBorder, function(v) SetFireBorder(v) end)
end)

AddTab("MM2", "🔪", function()
    AddToggle("Role ESP", Config.RoleESP, function(v)
        Config.RoleESP = v
        if v then for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateRoleESP(p) end end
        else for _, p in ipairs(Players:GetPlayers()) do RemoveRoleESP(p) end end
    end)
    AddToggle("Trigger Bot", Config.TriggerBot, function(v) Config.TriggerBot = v end)
    AddSlider("Trigger Range", 10, 100, Config.TriggerBotRange, function(v) Config.TriggerBotRange = v end)
    AddToggle("Aimbot V1 (Hold RMB)", Config.AimbotV1, function(v) Config.AimbotV1 = v end)
    AddDropdown("Aim Part", {"Head","HumanoidRootPart","Torso"}, Config.AimbotPart, function(t) Config.AimbotPart = t end)
    AddToggle("Aim Silent V2 (Flick)", Config.AimbotV2, function(v) Config.AimbotV2 = v end)
    AddToggle("Auto Pickup Gun (TP)", Config.AutoPickupGun, function(v) Config.AutoPickupGun = v end)
    AddToggle("Auto Pickup Gun V2 (No TP)", Config.AutoPickupGunV2, function(v) Config.AutoPickupGunV2 = v end)
    AddToggle("Farm Coins (Fly)", Config.FarmCoins, function(v) Config.FarmCoins = v end)
    AddToggle("Farm Coins V2 (Teleport)", Config.FarmCoinsV2, function(v) Config.FarmCoinsV2 = v end)
    AddSlider("Farm Speed", 20, 200, Config.FarmCoinsSpeed, function(v) Config.FarmCoinsSpeed = v end)
    AddDropdown("Fake Skin", {"None","Chroma Seer","Chroma Darkbringer","Chroma Heat","Chroma Gemstone","Chroma Lightbringer","Laser Gun","Gemstone Gun"}, "None", function(s) ApplyFakeSkin(s) end)
end)

AddTab("Bomb Tag", "💣", function()
    AddToggle("Auto Pass Bomb", Config.AutoPassBomb, function(v) Config.AutoPassBomb = v end)
    AddToggle("Auto Dodge Bomb", Config.AutoDodgeBomb, function(v) Config.AutoDodgeBomb = v end)
end)

AddTab("HUD", "📊", function()
    AddToggle("Show HUD", Config.HUDEnabled, function(v) 
        Config.HUDEnabled = v 
        topHud.Visible = v
        spectFrame.Visible = v and Config.ShowSpectators
    end)
    AddToggle("Show FPS", Config.ShowFPS, function(v) Config.ShowFPS = v end)
    AddToggle("Show Time", Config.ShowTime, function(v) Config.ShowTime = v end)
    AddToggle("Show Ping", Config.ShowPing, function(v) Config.ShowPing = v end)
    AddToggle("Show Spectators", Config.ShowSpectators, function(v)
        Config.ShowSpectators = v
        spectFrame.Visible = v and Config.HUDEnabled
    end)
end)

AddTab("Misc", "≡", function()
    AddDropdown("Theme", {"Default","Green","Red","Black","Aios","Ocean","Fire"}, Config.CurrentTheme, function(t)
        Config.CurrentTheme = t Colors = Themes[t]
        Main.BackgroundColor3 = Colors.Bg
        ReopenBtn.BackgroundColor3 = Colors.Bg rbs.Color = Colors.Glow
        Title.TextColor3 = Colors.Text ContentTitle.TextColor3 = Colors.Text
        Content.ScrollBarImageColor3 = Colors.Accent
        borderStroke.Color = Colors.Glow outerGlow.ImageColor3 = Colors.Glow
        topHudStroke.Color = Colors.Accent spectStroke.Color = Colors.Accent
        spectTitle.TextColor3 = Colors.Accent
        borderGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Colors.Accent),
            ColorSequenceKeypoint.new(0.5, Colors.Glow),
            ColorSequenceKeypoint.new(1, Colors.Accent),
        })
        for _, hl in ipairs(ChamsFolder:GetChildren()) do
            if hl:IsA("Highlight") then hl.FillColor = Colors.Accent hl.OutlineColor = Colors.Glow end
        end
        if Tabs[CurrentTab] then ClearContent() Tabs[CurrentTab].func() end
    end)
end)

AddTab("Server", "≣", function()
    AddButton("Rejoin", function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end)
    AddToggle("Anti AFK", Config.AntiAFK, function(v) Config.AntiAFK = v end)
end)

AddTab("Settings", "⚙", function()
    AddButton("Destroy GUI", function()
        sg:Destroy() hudGui:Destroy() mobileGui:Destroy() 
        ChamsFolder:Destroy() ESPFolder:Destroy() RoleESPFolder:Destroy() PredictFolder:Destroy()
        SetFullbright(false) SetRemoveFog(false) SetReflections(false) SetGodRays(false) 
        SetMotionBlur(false) SetSoftBlur(false) SetColorFilter(false) SetStrongBloom(false)
        SetFPSBoost(false) StopFly() DestroyFire() SetParticles(false)
        local s = Lighting:FindFirstChild("KloudSaturation") if s then s:Destroy() end
        for _, v in ipairs(Lighting:GetChildren()) do if v:IsA("Sky") and v.Name == "KloudSky" then v:Destroy() end end
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
mobileMenu.MouseButton1Click:Connect(function() 
    Main.Visible = not Main.Visible 
    ReopenBtn.Visible = not Main.Visible
end)

UserInput.InputBegan:Connect(function(input, gp) if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if Main.Visible then Main.Visible = false ReopenBtn.Visible = true
        else Main.Visible = true ReopenBtn.Visible = false end
    end
end)

UserInput.JumpRequest:Connect(function()
    if Config.InfJump then local h = GetHum() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
    if Config.SpeedGlitch then
        local h = GetHum()
        if h then
            local origSpeed = h.WalkSpeed
            h.WalkSpeed = origSpeed + Config.SpeedGlitchAmount
            task.wait(0.5)
            if h and h.Parent then h.WalkSpeed = Config.WalkSpeed end
        end
    end
end)

local motionLastCF = Camera.CFrame
RunService.RenderStepped:Connect(function()
    if Config.FlyEnabled and flyBV and flyBG then
        local cam = Camera.CFrame
        local move = Vector3.new()
        if UserInput:IsKeyDown(Enum.KeyCode.W) then move = move + cam.LookVector end
        if UserInput:IsKeyDown(Enum.KeyCode.S) then move = move - cam.LookVector end
        if UserInput:IsKeyDown(Enum.KeyCode.A) then move = move - cam.RightVector end
        if UserInput:IsKeyDown(Enum.KeyCode.D) then move = move + cam.RightVector end
        if UserInput:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UserInput:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
        flyBV.Velocity = move * Config.FlySpeed 
        flyBG.CFrame = cam
    end
    if Config.PredictESP then UpdatePredictESP() end
    if Config.FOVLocked and Camera.FieldOfView ~= Config.FOV then Camera.FieldOfView = Config.FOV end
    if Config.MotionBlur then
        local blur = Lighting:FindFirstChild("KloudMotionBlur")
        if blur then
            local curr = Camera.CFrame
            local delta = (curr.LookVector - motionLastCF.LookVector).Magnitude
            blur.Size = math.clamp(delta * 45, 0, 12)
            motionLastCF = curr
        end
    end
    if Config.AimbotV1 and UserInput:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local murderer = GetMurderer()
        if murderer and murderer.Character then
            local part = murderer.Character:FindFirstChild(Config.AimbotPart)
            if part then Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position) end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if Config.Noclip then
        local c = LocalPlayer.Character
        if c then for _, v in ipairs(c:GetDescendants()) do if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end end end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if Config.RoleESP then
            for _, Plr in ipairs(Players:GetPlayers()) do
                if Plr ~= LocalPlayer then
                    local bb = RoleESPFolder:FindFirstChild(Plr.Name)
                    if bb and bb:FindFirstChild("Role") then
                        local role = GetPlayerRole(Plr)
                        local roleLabel = bb.Role
                        if role == "Murderer" then
                            roleLabel.Text = "🔪 MURDERER"
                            roleLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                        elseif role == "Sheriff" then
                            roleLabel.Text = "🔫 SHERIFF"
                            roleLabel.TextColor3 = Color3.fromRGB(50, 150, 255)
                        else
                            roleLabel.Text = "😇 INNOCENT"
                            roleLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                        end
                    elseif not bb and Plr.Character then CreateRoleESP(Plr) end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.05) do
        if Config.TriggerBot then
            local murderer, head = CheckMurdererInSight(Config.TriggerBotRange)
            if murderer and head then
                local char = LocalPlayer.Character
                if char then
                    for _, tool in ipairs(char:GetChildren()) do
                        if tool:IsA("Tool") and (tool.Name == "Gun" or tool.Name == "Revolver") then
                            Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
                            pcall(function() tool:Activate() end)
                            task.wait(0.05)
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.05) do
        if Config.AimbotV2 then
            local murderer, head = CheckMurdererInSight(200)
            if murderer and head then
                local char = LocalPlayer.Character
                if char then
                    for _, tool in ipairs(char:GetChildren()) do
                        if tool:IsA("Tool") and (tool.Name == "Gun" or tool.Name == "Revolver") then
                            local origCF = Camera.CFrame
                            Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
                            pcall(function() tool:Activate() end)
                            task.wait()
                            Camera.CFrame = origCF
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        if Config.AutoPickupGun then
            local gun, part = GetDroppedGun()
            local root = GetRoot()
            if gun and part and root then
                root.CFrame = CFrame.new(part.Position + Vector3.new(0, 2, 0))
                task.wait(0.2)
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if Config.AutoPickupGunV2 then
            local gun, part = GetDroppedGun()
            local root = GetRoot()
            if gun and part and root and (root.Position - part.Position).Magnitude < 8 then
                pcall(function() if gun:IsA("Tool") then gun.Parent = LocalPlayer.Backpack end end)
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.15) do
        if Config.FarmCoins then
            local coin = GetClosestCoin()
            local root = GetRoot()
            if coin and root then
                local dir = (coin.Position - root.Position).Unit
                local dist = (coin.Position - root.Position).Magnitude
                if dist > 3 then
                    root.CFrame = root.CFrame + dir * math.min(Config.FarmCoinsSpeed * 0.15, dist)
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if Config.FarmCoinsV2 then
            local coin = GetClosestCoin()
            local root = GetRoot()
            if coin and root then root.CFrame = CFrame.new(coin.Position + Vector3.new(0, 3, 0)) end
        end
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
                    local tp = tr.Position 
                    local mp = tp + (tr.CFrame.LookVector * 3)
                    root.CFrame = CFrame.new(mp, tp)
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.15) do
        if Config.AutoDodgeBomb and not HasBomb() then
            local root = GetRoot()
            if root then
                for _, obj in ipairs(workspace:GetDescendants()) do
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
    if Config.AntiAFK then 
        local vu = game:GetService("VirtualUser") 
        vu:CaptureController() 
        vu:ClickButton2(Vector2.new()) 
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    local h = char:WaitForChild("Humanoid") 
    task.wait(0.3)
    h.WalkSpeed = Config.WalkSpeed 
    h.JumpPower = Config.JumpPower
    if Config.FlyEnabled then StopFly() task.wait(0.5) StartFly() end
    if Config.FPSBoost then task.wait(1) SetFPSBoost(true) end
    if Config.Particles then task.wait(0.5) SetParticles(true) end
    if Config.FakeSkin and Config.FakeSkin ~= "None" then 
        task.wait(1) 
        char.ChildAdded:Connect(function(item)
            if item:IsA("Tool") then task.wait(0.2) ApplyFakeSkin(Config.FakeSkin) end
        end)
    end
end)

pcall(function() 
    game.StarterGui:SetCore("SendNotification", {
        Title="Kloud Hub v4.4", 
        Text=IS_MOBILE and "Mobile mode! Use side buttons" or "Loaded! RightShift = hide", 
        Duration=5
    }) 
end)
