-- ⚡ Kloud Hub v4 | MM2 + Mobile Support
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
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
    -- Universal
    PlayerChams=false, PlayerESP=false, InfJump=false, Noclip=false,
    WalkSpeed=16, JumpPower=50, FOV=90, FOVLocked=true,
    Fullbright=false, RemoveFog=false, AntiAFK=true,
    FlyEnabled=false, FlySpeed=50, FPSBoost=false,
    SpeedGlitch=false, SpeedGlitchAmount=30,
    Particles=false,
    -- Bomb Tag
    AutoDodgeBomb=false, AutoPassBomb=false,
    -- Visuals
    Reflections=false, MotionBlur=false, Saturation=0,
    FireBorder=false,
    -- MM2
    TriggerBot=false, TriggerBotRange=30,
    AimbotV1=false, AimbotPart="Head",
    AimbotV2=false,
    RoleESP=false,
    AutoPickupGun=false, AutoPickupGunV2=false,
    FarmCoins=false, FarmCoinsV2=false, FarmCoinsSpeed=50,
    FakeSkin="None",
    -- HUD
    HUDEnabled=true, ShowFPS=true, ShowTime=true, ShowPing=true, ShowSpectators=true,
    -- Theme
    CurrentTheme="Default",
}
Config.AmbientBackup = Lighting.Ambient
Config.FogEndBackup = Lighting.FogEnd

-- ============ HELPERS ============
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

-- ============ MM2 FUNCTIONS ============
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

local function GetCoins()
    local coins = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("coin") or obj.Name:lower():find("cash")) then
            table.insert(coins, obj)
        elseif obj:IsA("Model") and obj.Name:lower():find("coin") then
            local part = obj:FindFirstChildOfClass("BasePart") or obj.PrimaryPart
            if part then table.insert(coins, part) end
        end
    end
    return coins
end

local function GetClosestCoin()
    local root = GetRoot() if not root then return nil end
    local coins = GetCoins()
    local closest, dist = nil, math.huge
    for _, c in ipairs(coins) do
        local d = (root.Position - c.Position).Magnitude
        if d < dist then dist = d closest = c end
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
    -- Проверка что не за стеной
    local ray = Ray.new(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * dist)
    local part = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
    if part and part:IsDescendantOf(murderer.Character) then
        return murderer, head
    end
    return nil
end

-- Fake Skins (Chroma ножи и пушки) - меняет визуал предмета в руке
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

-- Партиклы разноцветные вокруг персонажа
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
    for 
