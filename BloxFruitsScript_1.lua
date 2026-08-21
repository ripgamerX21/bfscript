-- ============================================================
--  BLOX FRUITS UNIVERSAL SCRIPT v2
--  Executor : KRNL / Delta iOS / Fluxus / Synapse X
--  Game     : Blox Fruits (Update 23+)
--  Level Cap: 2800
--  GUI Lib  : Orion (jsdelivr CDN — Delta iOS compatible)
-- ============================================================

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 1 — SERVICES                                   │
-- └─────────────────────────────────────────────────────────┘
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService  = game:GetService("UserInputService")
local Workspace         = game:GetService("Workspace")
local StarterGui        = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local Mouse       = LocalPlayer:GetMouse()

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 2 — CONFIG                                     │
-- └─────────────────────────────────────────────────────────┘
local CFG = {
    AutoFarm = {
        Enabled     = false,
        TargetLevel = 2800,
        KillAura    = false,
        AuraRadius  = 40,
        UseSkills   = true,
        Walkspeed   = 80,
        JumpPower   = 100,
        TeleportMob = true,
    },
    AutoStat = {
        Enabled  = false,
        Priority = {"Melee", "Defense", "Sword", "Gun", "Fruit"},
    },
    FruitSniper = {
        Enabled     = false,
        AutoCollect = true,
        Notify      = true,
        SpawnRadius = 5000,
        BlackList   = {"Bomb", "Spike", "Chop"},
    },
    FruitESP = {
        Enabled   = false,
        Billboard = true,
        MaxDist   = 8000,
    },
    FastAttack = {
        Enabled   = false,
        Speed     = 0.08, -- tool animation speed multiplier
    },
    AutoQuest = {
        Enabled   = false,
    },
    AutoRaid = {
        Enabled   = false,
        Island    = "Flower",  -- Flower / Magma / Ice / Sand / Forest / Minimap
    },
    SeaEvent = {
        Enabled   = false,
        AutoJoin  = true,
    },
    AutoChest = {
        Enabled   = false,
        Radius    = 200,
    },
    Dungeon = {
        Enabled   = false,
        AutoStart = true,
    },
    BossFarm = {
        Enabled    = false,
        BossTarget = "rip_indra",
    },
    MasteryFarm = {
        Enabled = false,
        Weapon  = "Sword",
    },
    Movement = {
        FlyEnabled = false,
        FlySpeed   = 60,
        AntiAFK    = true,
        AntiKick   = true,
    },
    UI = {
        Keybinds = {
            ToggleFly = Enum.KeyCode.F,
        },
    },
}

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 3 — MOB TABLE (Level 1 → 2800)                 │
-- └─────────────────────────────────────────────────────────┘
local MOB_TABLE = {
    -- Sea 1
    { min=1,    max=15,   island="StartIsland",   mob="Bandit",              pos=Vector3.new(977,  9,  -749)  },
    { min=15,   max=30,   island="StartIsland",   mob="Monkey",              pos=Vector3.new(1035, 69, -851)  },
    { min=30,   max=60,   island="MushroomIsland", mob="Mushroomite",        pos=Vector3.new(-1100,8,  -3500) },
    { min=60,   max=90,   island="JungleIsland",  mob="Gorilla",             pos=Vector3.new(-2136,6,  -73)   },
    { min=90,   max=120,  island="PirateIsland",  mob="Pirate",              pos=Vector3.new(-3027,6,  1663)  },
    { min=120,  max=150,  island="MarineBase",    mob="Marine",              pos=Vector3.new(3438, 9,  3316)  },
    { min=150,  max=190,  island="DesertIsland",  mob="Desert Bandit",       pos=Vector3.new(924,  9,  4350)  },
    { min=190,  max=210,  island="DesertIsland",  mob="Desert Officer",      pos=Vector3.new(1050, 9,  4500)  },
    { min=210,  max=250,  island="FuncyIsland",   mob="Snow Bandit",         pos=Vector3.new(-3200,228,3000)  },
    { min=250,  max=300,  island="FuncyIsland",   mob="Snowman",             pos=Vector3.new(-3200,228,3100)  },
    { min=300,  max=350,  island="MarineBase2",   mob="Marine Lieutenant",   pos=Vector3.new(4500, 9,  -1600) },
    { min=350,  max=400,  island="MarineBase2",   mob="Marine Captain",      pos=Vector3.new(4600, 9,  -1700) },
    -- Sea 2
    { min=700,  max=750,  island="Kingdom of Rose",mob="Citizen",            pos=Vector3.new(-258, 293,1880)  },
    { min=750,  max=850,  island="Kingdom of Rose",mob="Henchman",           pos=Vector3.new(-120, 293,1975)  },
    { min=850,  max=950,  island="MinionsIsland", mob="Toga Warrior",        pos=Vector3.new(-5694,314,-643)  },
    { min=950,  max=1000, island="DressIsland",   mob="Fishman Warrior",     pos=Vector3.new(-2638,52, -2253) },
    { min=1000, max=1050, island="DressIsland",   mob="Fishman Lord",        pos=Vector3.new(-2900,52, -2400) },
    { min=1050, max=1100, island="MarineBase3",   mob="Marine Vice Admiral", pos=Vector3.new(4800, 9,  1800)  },
    { min=1100, max=1200, island="HotCold",       mob="Lava Pirate",         pos=Vector3.new(-5248,9,  -3384) },
    { min=1200, max=1300, island="HotCold",       mob="Ice Pirate",          pos=Vector3.new(-4820,200,-3600) },
    { min=1300, max=1425, island="WangoIsland",   mob="Wano Soldier",        pos=Vector3.new(-4500,9,  4200)  },
    { min=1425, max=1475, island="WangoIsland",   mob="Wano Raider",         pos=Vector3.new(-4300,9,  4000)  },
    { min=1475, max=1575, island="WangoIsland",   mob="Snow Lurker",         pos=Vector3.new(-4000,9,  3900)  },
    -- Sea 3
    { min=1575, max=1675, island="Port Town",     mob="Pirate Millionaire",  pos=Vector3.new(839,  131,-5213) },
    { min=1675, max=1750, island="Port Town",     mob="Gold Treasure",       pos=Vector3.new(650,  131,-5100) },
    { min=1750, max=1825, island="Hydra Island",  mob="Galley Captain",      pos=Vector3.new(-2384,49, -13900)},
    { min=1825, max=1875, island="Hydra Island",  mob="Mythological Pirate", pos=Vector3.new(-2200,49, -14200)},
    { min=1875, max=1950, island="GreatTree",     mob="Tree Pirate",         pos=Vector3.new(-9855,210,-7350) },
    { min=1950, max=2025, island="GreatTree",     mob="Diablo",              pos=Vector3.new(-10000,210,-7500)},
    { min=2025, max=2100, island="FloatingTurtle",mob="Demonic Soul",        pos=Vector3.new(-13200,480,-8300)},
    { min=2100, max=2200, island="FloatingTurtle",mob="Ectoplasm",           pos=Vector3.new(-13000,480,-8100)},
    { min=2200, max=2300, island="WaterLore",     mob="Sea Soldier",         pos=Vector3.new(-5700, 8, -13400)},
    { min=2300, max=2425, island="WaterLore",     mob="Fishman Raider",      pos=Vector3.new(-5500, 8, -13600)},
    { min=2425, max=2550, island="WaterLore",     mob="Fishman Mercenary",   pos=Vector3.new(-5300, 8, -13800)},
    -- Update 23+ (2550–2800)
    { min=2550, max=2650, island="EliteZone",     mob="Elite Pirate",        pos=Vector3.new(-14000,9, -3000) },
    { min=2650, max=2750, island="EliteZone",     mob="Haunted Pirate",      pos=Vector3.new(-14200,9, -3200) },
    { min=2750, max=2800, island="EliteZone",     mob="Stone Warrior",       pos=Vector3.new(-14500,9, -3500) },
}

-- Raid island teleport positions
local RAID_POSITIONS = {
    Flower  = Vector3.new(-1100, 8, -3500),
    Magma   = Vector3.new(-5248, 9, -3384),
    Ice     = Vector3.new(-4820, 200, -3600),
    Sand    = Vector3.new(924, 9, 4350),
    Forest  = Vector3.new(-9855, 210, -7350),
    Minimap = Vector3.new(-13200, 480, -8300),
}

-- Quest NPC positions per island tier
local QUEST_NPCS = {
    { minLvl=1,    pos=Vector3.new(979,  9, -730),   name="Quest1"   },
    { minLvl=700,  pos=Vector3.new(-200, 293, 1850),  name="Quest2"   },
    { minLvl=1575, pos=Vector3.new(820,  131, -5190), name="Quest3"   },
}

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 4 — STATE                                      │
-- └─────────────────────────────────────────────────────────┘
local State = {
    Character   = nil,
    RootPart    = nil,
    Humanoid    = nil,
    Flying      = false,
    FlyBody     = nil,
    CurrentMob  = nil,
    LastStatAt  = 0,
    AFKTimer    = 0,
    KickTimer   = 0,
    LoopConn    = nil,
    ESPBillboards = {},
    AttackConn  = nil,
}

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 5 — UTILITIES                                  │
-- └─────────────────────────────────────────────────────────┘
local function Notify(title, body)
    StarterGui:SetCore("SendNotification", {
        Title    = title,
        Text     = body,
        Duration = 5,
    })
end

local function GetPlayerLevel()
    local ls = LocalPlayer:FindFirstChild("leaderstats")
    if ls then
        local lvl = ls:FindFirstChild("Level")
        return lvl and lvl.Value or 1
    end
    return 1
end

local function GetStatPoints()
    local data = LocalPlayer:FindFirstChild("Data") or LocalPlayer:FindFirstChild("Stats")
    if data then
        local pts = data:FindFirstChild("StatPoints")
        return pts and pts.Value or 0
    end
    return 0
end

local function SafeTeleport(position)
    if not State.RootPart then return end
    local tween = TweenService:Create(
        State.RootPart,
        TweenInfo.new(0.12, Enum.EasingStyle.Linear),
        { CFrame = CFrame.new(position + Vector3.new(0, 3, 0)) }
    )
    tween:Play()
    tween.Completed:Wait()
end

local function GetMobForLevel(level)
    for _, entry in ipairs(MOB_TABLE) do
        if level >= entry.min and level < entry.max then
            return entry
        end
    end
    return MOB_TABLE[#MOB_TABLE]
end

local function FindNearestMob(mobName)
    local closest, closestDist = nil, math.huge
    for _, model in ipairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and model.Name == mobName then
            local root = model:FindFirstChild("HumanoidRootPart")
            local hum  = model:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 and State.RootPart then
                local dist = (root.Position - State.RootPart.Position).Magnitude
                if dist < closestDist then
                    closest, closestDist = model, dist
                end
            end
        end
    end
    return closest
end

local function IsInSafeZone()
    if not State.RootPart then return false end
    local pos = State.RootPart.Position
    local safeZones = {
        Vector3.new(977, 9, -749),
        Vector3.new(3438, 9, 3316),
    }
    for _, sz in ipairs(safeZones) do
        if (pos - sz).Magnitude < 30 then return true end
    end
    return false
end

local function FireRemote(remoteName, ...)
    local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
        or ReplicatedStorage:FindFirstChild("MainEvent")
    if not Remotes then return end
    local re = Remotes:FindFirstChild(remoteName)
    if re and re:IsA("RemoteEvent") then
        re:FireServer(...)
    end
end

local function BindCharacter(char)
    State.Character = char
    State.RootPart  = char:WaitForChild("HumanoidRootPart", 10)
    State.Humanoid  = char:WaitForChild("Humanoid", 10)
    if State.Humanoid then
        State.Humanoid.WalkSpeed = CFG.AutoFarm.Walkspeed
        State.Humanoid.JumpPower = CFG.AutoFarm.JumpPower
    end
end

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 6 — FLY                                        │
-- └─────────────────────────────────────────────────────────┘
local function EnableFly()
    if State.Flying or not State.RootPart then return end
    State.Flying = true

    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bg.P = 1e4
    bg.Parent = State.RootPart

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Velocity = Vector3.zero
    bv.Parent = State.RootPart

    State.FlyBody = { bg = bg, bv = bv }

    RunService.Heartbeat:Connect(function()
        if not State.Flying then
            bg:Destroy(); bv:Destroy()
            State.FlyBody = nil
            return
        end
        local cam = Workspace.CurrentCamera
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space)       then dir = dir + Vector3.new(0,1,0)  end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0)  end
        bv.Velocity = dir.Magnitude > 0 and dir.Unit * CFG.Movement.FlySpeed or Vector3.zero
        bg.CFrame   = cam.CFrame
    end)
    Notify("Fly", "Active — WASD + Space/Ctrl")
end

local function DisableFly()
    State.Flying = false
    Notify("Fly", "Disabled")
end

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 7 — KILL AURA                                  │
-- └─────────────────────────────────────────────────────────┘
local function RunKillAura()
    if not CFG.AutoFarm.KillAura or not State.RootPart then return end
    if IsInSafeZone() then return end

    for _, model in ipairs(Workspace:GetDescendants()) do
        if model:IsA("Model") then
            local hum  = model:FindFirstChildOfClass("Humanoid")
            local root = model:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and root then
                if (root.Position - State.RootPart.Position).Magnitude <= CFG.AutoFarm.AuraRadius then
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        local re = tool:FindFirstChild("Activate") or ReplicatedStorage:FindFirstChild("Activate")
                        if re and re:IsA("RemoteEvent") then
                            re:FireServer(root.Position)
                        else
                            local cd = model:FindFirstChildOfClass("ClickDetector")
                            if cd then fireclickdetector(cd) end
                        end
                    end
                end
            end
        end
    end
end

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 8 — FAST ATTACK                                │
-- └─────────────────────────────────────────────────────────┘
local function SetFastAttack(enabled)
    if State.AttackConn then
        State.AttackConn:Disconnect()
        State.AttackConn = nil
    end
    if not enabled then return end

    State.AttackConn = RunService.Heartbeat:Connect(function()
        if not CFG.FastAttack.Enabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then return end
        local anim = char:FindFirstChild("Animate")
        if anim then
            local toolAnim = anim:FindFirstChild("toolnone")
                or anim:FindFirstChild("toolslash")
                or anim:FindFirstChild("toollunge")
            if toolAnim then
                local track = toolAnim:FindFirstChildOfClass("Animation")
                if track then
                    -- speed up attack animations via AnimationTrack on the Humanoid's Animator
                    local animator = char:FindFirstChildOfClass("Humanoid")
                        and char.Humanoid:FindFirstChildOfClass("Animator")
                    if animator then
                        for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
                            t:AdjustSpeed(1 / CFG.FastAttack.Speed)
                        end
                    end
                end
            end
        end
    end)
end

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 9 — AUTO FARM                                  │
-- └─────────────────────────────────────────────────────────┘
local function RunAutoFarm()
    if not CFG.AutoFarm.Enabled or not State.RootPart then return end
    if IsInSafeZone() then return end

    local level = GetPlayerLevel()
    if level >= CFG.AutoFarm.TargetLevel then
        CFG.AutoFarm.Enabled = false
        Notify("Auto Farm", "Reached level " .. CFG.AutoFarm.TargetLevel)
        return
    end

    local mobEntry = GetMobForLevel(level)
    State.CurrentMob = mobEntry.mob

    local target = FindNearestMob(mobEntry.mob)
    if target then
        local targetRoot = target:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            if CFG.AutoFarm.TeleportMob then SafeTeleport(targetRoot.Position) end
            RunKillAura()
        end
    else
        SafeTeleport(mobEntry.pos)
    end
end

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 10 — AUTO QUEST                                │
-- └─────────────────────────────────────────────────────────┘
local function RunAutoQuest()
    if not CFG.AutoQuest.Enabled or not State.RootPart then return end

    local level = GetPlayerLevel()
    local questNPC = QUEST_NPCS[1]
    for _, q in ipairs(QUEST_NPCS) do
        if level >= q.minLvl then questNPC = q end
    end

    -- Teleport to NPC and fire interact remote
    SafeTeleport(questNPC.pos)
    task.wait(0.5)

    -- Try ProximityPrompt first, then RemoteEvent
    local npc = Workspace:FindFirstChild(questNPC.name)
    if npc then
        local pp = npc:FindFirstChildOfClass("ProximityPrompt")
        if pp then
            fireproximityprompt(pp)
        else
            FireRemote("QuestStart", npc)
        end
    else
        -- Generic quest accept via MainEvent
        FireRemote("QuestStart")
    end
end

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 11 — AUTO STAT ALLOCATOR                       │
-- └─────────────────────────────────────────────────────────┘
local function RunAutoStat()
    if not CFG.AutoStat.Enabled then return end
    local now = tick()
    if now - State.LastStatAt < 0.5 then return end
    State.LastStatAt = now

    if GetStatPoints() <= 0 then return end
    for _, statName in ipairs(CFG.AutoStat.Priority) do
        FireRemote("UpdateStat", statName)
    end
end

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 12 — FRUIT SNIPER                              │
-- └─────────────────────────────────────────────────────────┘
local FRUIT_KEYWORDS = { "Fruit", "Devil", "Logia", "Paramecia", "Zoan" }

local function IsFruitModel(name)
    for _, kw in ipairs(FRUIT_KEYWORDS) do
        if string.find(name, kw) then return true end
    end
    return false
end

local function IsBlacklisted(name)
    for _, bl in ipairs(CFG.FruitSniper.BlackList) do
        if string.find(name, bl) then return true end
    end
    return false
end

local function CollectFruit(fruitModel)
    local root = fruitModel:FindFirstChild("Handle") or fruitModel:FindFirstChildOfClass("BasePart")
    if not root or not State.RootPart then return end
    local dist = (root.Position - State.RootPart.Position).Magnitude
    if dist > CFG.FruitSniper.SpawnRadius then return end
    if CFG.FruitSniper.Notify then
        Notify("Fruit Sniper", fruitModel.Name .. " — " .. math.floor(dist) .. " studs")
    end
    if CFG.FruitSniper.AutoCollect then
        SafeTeleport(root.Position)
        task.wait(0.3)
        local pp = fruitModel:FindFirstChildOfClass("ProximityPrompt")
        if pp then fireproximityprompt(pp) end
    end
end

local FruitWatchers = {}
local function StartFruitSniper()
    if FruitWatchers.Added then FruitWatchers.Added:Disconnect() end
    FruitWatchers.Added = Workspace.DescendantAdded:Connect(function(obj)
        if not CFG.FruitSniper.Enabled then return end
        if obj:IsA("Model") and IsFruitModel(obj.Name) and not IsBlacklisted(obj.Name) then
            task.wait(0.1)
            CollectFruit(obj)
        end
    end)
end

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 13 — FRUIT ESP                                 │
-- └─────────────────────────────────────────────────────────┘
local function ClearESP()
    for _, bb in ipairs(State.ESPBillboards) do
        if bb and bb.Parent then bb:Destroy() end
    end
    State.ESPBillboards = {}
end

local function RunFruitESP()
    if not CFG.FruitESP.Enabled then ClearESP(); return end
    ClearESP()

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and IsFruitModel(obj.Name) then
            local root = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
            if root and State.RootPart then
                local dist = (root.Position - State.RootPart.Position).Magnitude
                if dist <= CFG.FruitESP.MaxDist then
                    local bb = Instance.new("BillboardGui")
                    bb.Size         = UDim2.new(0, 120, 0, 40)
                    bb.AlwaysOnTop  = true
                    bb.StudsOffset  = Vector3.new(0, 3, 0)
                    bb.Parent       = root

                    local label = Instance.new("TextLabel")
                    label.Size            = UDim2.new(1, 0, 1, 0)
                    label.BackgroundColor3= Color3.fromRGB(255, 60, 60)
                    label.BackgroundTransparency = 0.3
                    label.TextColor3      = Color3.new(1, 1, 1)
                    label.Text            = obj.Name .. "\n" .. math.floor(dist) .. "m"
                    label.TextScaled      = true
                    label.Font            = Enum.Font.GothamBold
                    label.Parent          = bb

                    table.insert(State.ESPBillboards, bb)
                end
            end
        end
    end
end

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 14 — AUTO CHEST                                │
-- └─────────────────────────────────────────────────────────┘
local function RunAutoChest()
    if not CFG.AutoChest.Enabled or not State.RootPart then return end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (string.find(obj.Name, "Chest") or string.find(obj.Name, "chest")) then
            local root = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
            if root then
                local dist = (root.Position - State.RootPart.Position).Magnitude
                if dist <= CFG.AutoChest.Radius then
                    SafeTeleport(root.Position)
                    task.wait(0.2)
                    local pp = obj:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        fireproximityprompt(pp)
                    else
                        local cd = obj:FindFirstChildOfClass("ClickDetector")
                        if cd then fireclickdetector(cd) end
                    end
                end
            end
        end
    end
end

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 15 — AUTO RAID                                 │
-- └─────────────────────────────────────────────────────────┘
local function RunAutoRaid()
    if not CFG.AutoRaid.Enabled or not State.RootPart then return end

    local raidPos = RAID_POSITIONS[CFG.AutoRaid.Island]
    if not raidPos then return end

    -- Teleport to raid start island
    SafeTeleport(raidPos)
    task.wait(1)

    -- Find and interact with raid start NPC / chest
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (string.find(obj.Name:lower(), "raid") or string.find(obj.Name:lower(), "enroll")) then
            local pp = obj:FindFirstChildOfClass("ProximityPrompt")
            if pp then
                fireproximityprompt(pp)
                task.wait(0.5)
                break
            end
        end
    end

    -- Kill mobs inside raid until wave complete
    local wave = 0
    while CFG.AutoRaid.Enabled and wave < 10 do
        local level  = GetPlayerLevel()
        local entry  = GetMobForLevel(level)
        local target = FindNearestMob(entry.mob)
        if target then
            local tr = target:FindFirstChild("HumanoidRootPart")
            if tr then SafeTeleport(tr.Position); RunKillAura() end
        end
        task.wait(0.3)
        wave = wave + 1
    end
end

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 16 — SEA EVENT                                 │
-- └─────────────────────────────────────────────────────────┘
local function RunSeaEvent()
    if not CFG.SeaEvent.Enabled or not State.RootPart then return end

    -- Sea events broadcast via a RemoteEvent or appear as a model in Workspace
    -- Common event model names: "SeaEvent", "Rumble", "Ship", "Kraken"
    local eventModels = {"SeaEvent", "Rumble", "Ship", "Kraken", "Raid_Ship"}

    for _, eventName in ipairs(eventModels) do
        local eventModel = Workspace:FindFirstChild(eventName)
        if eventModel then
            local root = eventModel:FindFirstChild("HumanoidRootPart")
                or eventModel:FindFirstChildOfClass("BasePart")
            if root then
                Notify("Sea Event", eventName .. " detected — joining")
                SafeTeleport(root.Position)
                task.wait(0.5)

                -- Damage the event boss (ship/kraken)
                local hum = eventModel:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool then
                        local re = tool:FindFirstChild("Activate") or ReplicatedStorage:FindFirstChild("Activate")
                        if re then re:FireServer(root.Position) end
                    end
                end
                return
            end
        end
    end
end

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 17 — DUNGEON                                   │
-- └─────────────────────────────────────────────────────────┘
local function RunDungeon()
    if not CFG.Dungeon.Enabled or not State.RootPart then return end

    -- Find dungeon portal/entrance in Workspace
    local dungeonPortal = Workspace:FindFirstChild("DungeonPortal")
        or Workspace:FindFirstChild("Dungeon")
        or Workspace:FindFirstChild("Portal")

    if dungeonPortal then
        local portalPart = dungeonPortal:FindFirstChildOfClass("BasePart")
        if portalPart then
            SafeTeleport(portalPart.Position)
            task.wait(0.5)
            if CFG.Dungeon.AutoStart then
                local pp = dungeonPortal:FindFirstChildOfClass("ProximityPrompt")
                if pp then fireproximityprompt(pp) end
            end
        end
    end

    -- Kill dungeon mobs
    local level = GetPlayerLevel()
    local entry = GetMobForLevel(level)
    local target = FindNearestMob(entry.mob)
    if target then
        local tr = target:FindFirstChild("HumanoidRootPart")
        if tr then SafeTeleport(tr.Position); RunKillAura() end
    end
end

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 18 — BOSS FARM                                 │
-- └─────────────────────────────────────────────────────────┘
local function RunBossFarm()
    if not CFG.BossFarm.Enabled or not State.RootPart then return end
    local boss = FindNearestMob(CFG.BossFarm.BossTarget)
    if boss then
        local br = boss:FindFirstChild("HumanoidRootPart")
        if br then SafeTeleport(br.Position); RunKillAura() end
    else
        SafeTeleport(Vector3.new(-3027, 6, 1663))
    end
end

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 19 — MASTERY FARM                              │
-- └─────────────────────────────────────────────────────────┘
local function RunMasteryFarm()
    if not CFG.MasteryFarm.Enabled or not State.RootPart then return end
    local level = GetPlayerLevel()
    local entry = GetMobForLevel(level)
    local target = FindNearestMob(entry.mob)
    if target then
        local tr = target:FindFirstChild("HumanoidRootPart")
        if tr then SafeTeleport(tr.Position); RunKillAura() end
    end
end

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 20 — ANTI-AFK / ANTI-KICK                      │
-- └─────────────────────────────────────────────────────────┘
local function RunAntiAFK(dt)
    if not CFG.Movement.AntiAFK then return end
    State.AFKTimer = State.AFKTimer + dt
    if State.AFKTimer >= 60 then
        State.AFKTimer = 0
        local cam = Workspace.CurrentCamera
        if cam then cam.CFrame = cam.CFrame * CFrame.Angles(0, math.rad(math.random(-1, 1)), 0) end
    end
end

local function RunAntiKick(dt)
    if not CFG.Movement.AntiKick then return end
    State.KickTimer = State.KickTimer + dt
    if State.KickTimer >= 30 then
        State.KickTimer = 0
        -- VirtualInput heartbeat — KRNL + Delta iOS compatible
        local vip = LocalPlayer.PlayerGui:FindFirstChild("VirtualInputManager")
        if vip then
            vip:SendKeyEvent(true,  Enum.KeyCode.W, false, game)
            task.wait(0.05)
            vip:SendKeyEvent(false, Enum.KeyCode.W, false, game)
        end
    end
end

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 21 — MAIN LOOP                                 │
-- └─────────────────────────────────────────────────────────┘
local ESPTimer = 0

local function StartMainLoop()
    if State.LoopConn then State.LoopConn:Disconnect() end
    State.LoopConn = RunService.Heartbeat:Connect(function(dt)
        if not State.Character or not State.RootPart then return end
        if State.Humanoid and State.Humanoid.Health <= 0 then return end

        RunAutoFarm()
        RunAutoStat()
        RunAutoChest()
        RunSeaEvent()
        RunBossFarm()
        RunMasteryFarm()
        RunAntiAFK(dt)
        RunAntiKick(dt)

        -- ESP refreshes every 5s (expensive)
        ESPTimer = ESPTimer + dt
        if ESPTimer >= 5 then
            ESPTimer = 0
            RunFruitESP()
        end
    end)
end

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 22 — CHARACTER WATCHER                         │
-- └─────────────────────────────────────────────────────────┘
local function OnCharacterAdded(char)
    BindCharacter(char)
    task.wait(2)
    StartMainLoop()
    SetFastAttack(CFG.FastAttack.Enabled)
    if State.Flying then EnableFly() end
end

LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
if LocalPlayer.Character then OnCharacterAdded(LocalPlayer.Character) end

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 23 — KEYBINDS                                  │
-- └─────────────────────────────────────────────────────────┘
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == CFG.UI.Keybinds.ToggleFly then
        if State.Flying then DisableFly() else EnableFly() end
    end
end)

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 24 — GUI (Orion — jsdelivr CDN, Delta iOS safe) │
-- └─────────────────────────────────────────────────────────┘
-- Orion bundled inline — no HttpGet required (MuMu/Delta iOS safe)
local OrionLib
do
local _ORION_SOURCE = [[
local Orion = {}

function Orion:CreateOrion(orionName)
    orionName = orionName or "Orion"
    local isClosed = false
    
    local ScreenGui = Instance.new("ScreenGui")
    local MainWhiteFrame = Instance.new("Frame")
    local mainCorner = Instance.new("UICorner")
    local MainWhiteFrame_2 = Instance.new("Frame")
    local mainCorner_2 = Instance.new("UICorner")
    local tabFrame = Instance.new("Frame")
    local tabList = Instance.new("UIListLayout")
    local tabPadd = Instance.new("UIPadding")
    local header = Instance.new("Frame")
    local mainCorner_4 = Instance.new("UICorner")
    local libTitle = Instance.new("TextLabel")
    local closeLib = Instance.new("ImageButton")
    local elementContainer = Instance.new("Frame")
    local mainCorner_5 = Instance.new("UICorner")
    local mainList = Instance.new("UIListLayout")
    local pagesFolder = Instance.new("Folder")


    
    local UserInputService = game:GetService("UserInputService")

    local TopBar = header

    local Camera = workspace:WaitForChild("Camera")

    local DragMousePosition
    local FramePosition
    local Draggable = false
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Draggable = true
            DragMousePosition = Vector2.new(input.Position.X, input.Position.Y)
            FramePosition = Vector2.new(MainWhiteFrame.Position.X.Scale, MainWhiteFrame.Position.Y.Scale)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Draggable == true then
            local NewPosition = FramePosition + ((Vector2.new(input.Position.X, input.Position.Y) - DragMousePosition) / Camera.ViewportSize)
            MainWhiteFrame.Position = UDim2.new(NewPosition.X, 0, NewPosition.Y, 0)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Draggable = false
        end
    end)

    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    MainWhiteFrame.Name = "MainWhiteFrame"
    MainWhiteFrame.Parent = ScreenGui
    MainWhiteFrame.BackgroundColor3 = Color3.fromRGB(139, 0, 23)
    MainWhiteFrame.BorderSizePixel = 0
    MainWhiteFrame.ClipsDescendants = true
    MainWhiteFrame.Position = UDim2.new(0.236969739, 0, 0.360436916, 0)
    MainWhiteFrame.Size = UDim2.new(0, 528, 0, 310)

    mainCorner.CornerRadius = UDim.new(0, 3)
    mainCorner.Name = "mainCorner"
    mainCorner.Parent = MainWhiteFrame

    MainWhiteFrame_2.Name = "MainWhiteFrame"
    MainWhiteFrame_2.Parent = MainWhiteFrame
    MainWhiteFrame_2.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainWhiteFrame_2.BorderSizePixel = 0
    MainWhiteFrame_2.ClipsDescendants = true
    MainWhiteFrame_2.Position = UDim2.new(0.0113636367, 0, 0, 0)
    MainWhiteFrame_2.Size = UDim2.new(0, 525, 0, 310)

    mainCorner_2.CornerRadius = UDim.new(0, 3)
    mainCorner_2.Name = "mainCorner"
    mainCorner_2.Parent = MainWhiteFrame_2

    tabFrame.Name = "tabFrame"
    tabFrame.Parent = MainWhiteFrame_2
    tabFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    tabFrame.BorderColor3 = Color3.fromRGB(53, 53, 53)
    tabFrame.ClipsDescendants = true
    tabFrame.Size = UDim2.new(0, 100, 0, 309)

    tabList.Name = "tabList"
    tabList.Parent = tabFrame
    tabList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 2)

    tabPadd.Name = "tabPadd"
    tabPadd.Parent = tabFrame
    tabPadd.PaddingRight = UDim.new(0, 2)
    tabPadd.PaddingTop = UDim.new(0, 5)

    header.Name = "header"
    header.Parent = MainWhiteFrame_2
    header.BackgroundColor3 = Color3.fromRGB(181, 1, 31)
    header.Position = UDim2.new(0.207619041, 0, 0.0258064512, 0)
    header.Size = UDim2.new(0, 408, 0, 43)

    mainCorner_4.CornerRadius = UDim.new(0, 3)
    mainCorner_4.Name = "mainCorner"
    mainCorner_4.Parent = header

    libTitle.Name = "libTitle"
    libTitle.Parent = header
    libTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    libTitle.BackgroundTransparency = 1.000
    libTitle.Position = UDim2.new(0.0294117648, 0, 0, 0)
    libTitle.Size = UDim2.new(0, 343, 0, 43)
    libTitle.Font = Enum.Font.GothamSemibold
    libTitle.Text = orionName
    libTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    libTitle.TextSize = 18.000
    libTitle.TextXAlignment = Enum.TextXAlignment.Left

    closeLib.Name = "closeLib"
    closeLib.Parent = header
    closeLib.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    closeLib.BackgroundTransparency = 1.000
    closeLib.Position = UDim2.new(0.91911763, 0, 0.209302321, 0)
    closeLib.Size = UDim2.new(0, 25, 0, 25)
    closeLib.Image = "rbxassetid://4988112250"
    closeLib.MouseButton1Click:Connect(function()
        isClosed = not isClosed
        if isClosed then
            closeLib.Image = "rbxassetid://5165666242"
            game.TweenService:Create(closeLib, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{
                Rotation = 360
            }):Play()
            MainWhiteFrame:TweenSize(UDim2.new(0, 424,0, 58), "In", "Linear", 0.12)
            game.TweenService:Create(MainWhiteFrame_2, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{
                BackgroundTransparency = 1
            }):Play()
            game.TweenService:Create(MainWhiteFrame, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{
                BackgroundTransparency = 1
            }):Play()
        else
            closeLib.Image = "rbxassetid://4988112250"
            game.TweenService:Create(closeLib, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{
                Rotation = 0
            }):Play()
            MainWhiteFrame:TweenSize(UDim2.new(0, 528,0, 310), "In", "Linear", 0.12)
            game.TweenService:Create(MainWhiteFrame_2, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{
                BackgroundTransparency = 0
            }):Play()
            game.TweenService:Create(MainWhiteFrame, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{
                BackgroundTransparency = 0
            }):Play()
        end
    end)

    elementContainer.Name = "elementContainer"
    elementContainer.Parent = MainWhiteFrame_2
    elementContainer.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
    elementContainer.Position = UDim2.new(0.207619041, 0, 0.187096775, 0)
    elementContainer.Size = UDim2.new(0, 408, 0, 243)

    mainCorner_5.CornerRadius = UDim.new(0, 3)
    mainCorner_5.Name = "mainCorner"
    mainCorner_5.Parent = elementContainer

    mainList.Name = "mainList"
    mainList.Parent = MainWhiteFrame
    mainList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    mainList.SortOrder = Enum.SortOrder.LayoutOrder

    pagesFolder.Parent = elementContainer

    local SectionHandler = {}

    function SectionHandler:CreateSection(secName)
        secName = secName or "Tab"

        -- Tab Button Instances
        local tabBtn = Instance.new("TextButton")
        local mainCorner_3 = Instance.new("UICorner")

        tabBtn.Name = "tabBtn"..secName
        tabBtn.Parent = tabFrame
        tabBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
        tabBtn.BorderColor3 = Color3.fromRGB(53, 53, 53)
        tabBtn.Position = UDim2.new(0.0599999987, 0, 0.0323624611, 0)
        tabBtn.Size = UDim2.new(0, 95, 0, 32)
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.Text = secName
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.TextSize = 14.000
        tabBtn.AutoButtonColor = false
    
        mainCorner_3.CornerRadius = UDim.new(0, 3)
        mainCorner_3.Name = "mainCorner"
        mainCorner_3.Parent = tabBtn

        -- New Section Frame Instances
        local newPage = Instance.new("ScrollingFrame")
        local pageItemList = Instance.new("UIListLayout")
        local UIPadding = Instance.new("UIPadding")

        newPage.Name = "newPage"..secName
        newPage.Parent = pagesFolder
        newPage.Active = true
        newPage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        newPage.BackgroundTransparency = 1.000
        newPage.BorderSizePixel = 0
        newPage.Size = UDim2.new(1, 0, 1, 0)
        newPage.ScrollBarThickness = 5
        newPage.ScrollBarImageColor3 = Color3.fromRGB(255, 2, 40)
        newPage.Visible = false

        pageItemList.Name = "pageItemList"
        pageItemList.Parent = newPage
        pageItemList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pageItemList.SortOrder = Enum.SortOrder.LayoutOrder
        pageItemList.Padding = UDim.new(0, 3)

        UIPadding.Parent = newPage
        UIPadding.PaddingRight = UDim.new(0, 5)
        UIPadding.PaddingTop = UDim.new(0, 5)

        local function UpdateSize()
            local cS = pageItemList.AbsoluteContentSize

            game.TweenService:Create(newPage, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                CanvasSize = UDim2.new(0,cS.X,0,cS.Y + 10)
            }):Play()
        end
    
        newPage.ChildAdded:Connect(UpdateSize)
        newPage.ChildRemoved:Connect(UpdateSize)
        UpdateSize()

        tabBtn.MouseButton1Click:Connect(function()
            UpdateSize()
            for i,v in next, pagesFolder:GetChildren() do
                v.Visible = false
                UpdateSize()
            end
            newPage.Visible = true

            for i,v in next, tabFrame:GetChildren() do
                if v:IsA("TextButton") then
                    UpdateSize()
                    game.TweenService:Create(v, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),{
                        BackgroundColor3 = Color3.fromRGB(25,25,25)
                    }):Play()
                end
            end
            game.TweenService:Create(tabBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),{
                BackgroundColor3 = Color3.fromRGB(139, 0, 23)
            }):Play()
        end)

        local ElementHandler = {}

        function ElementHandler:TextLabel(labelText)
            labelText = labelText or ""

            local labelFrame = Instance.new("Frame")
            local mainCorner = Instance.new("UICorner")
            local txtLabel = Instance.new("TextLabel")

            labelFrame.Name = "labelFrame"
            labelFrame.Parent = newPage
            labelFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            labelFrame.Position = UDim2.new(0.0367647074, 0, 0.0185185187, 0)
            labelFrame.Size = UDim2.new(0, 394, 0, 42)

            mainCorner.CornerRadius = UDim.new(0, 3)
            mainCorner.Name = "mainCorner"
            mainCorner.Parent = labelFrame

            txtLabel.Name = "txtLabel"
            txtLabel.Parent = labelFrame
            txtLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            txtLabel.BackgroundTransparency = 1.000
            txtLabel.Position = UDim2.new(0, 0, 0.0238095243, 0)
            txtLabel.Size = UDim2.new(0, 395, 0, 41)
            txtLabel.Font = Enum.Font.GothamSemibold
            txtLabel.Text = labelText
            txtLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            txtLabel.TextSize = 14.000
        end

        function ElementHandler:TextButton(buttonText, buttonInfo, callback)
            buttonText = buttonText or ""
            buttonInfo = buttonInfo or ""
            callback = callback or function() end

            local textButtonFrame = Instance.new("Frame")
            local mainCorner = Instance.new("UICorner")
            local TextButton = Instance.new("TextButton")
            local mainCorner_2 = Instance.new("UICorner")
            local textButtonInfo = Instance.new("TextLabel")

            textButtonFrame.Name = "textButtonFrame"
            textButtonFrame.Parent = newPage
            textButtonFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            textButtonFrame.Position = UDim2.new(0.0147058824, 0, 0.0246913582, 0)
            textButtonFrame.Size = UDim2.new(0, 394, 0, 42)

            mainCorner.CornerRadius = UDim.new(0, 3)
            mainCorner.Name = "mainCorner"
            mainCorner.Parent = textButtonFrame

            TextButton.Parent = textButtonFrame
            TextButton.BackgroundColor3 = Color3.fromRGB(181, 1, 31)
            TextButton.Position = UDim2.new(0.017766498, 0, 0.166666672, 0)
            TextButton.Size = UDim2.new(0, 141, 0, 27)
            TextButton.Font = Enum.Font.GothamSemibold
            TextButton.Text = buttonText
            TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextButton.TextSize = 14.000

            mainCorner_2.CornerRadius = UDim.new(0, 3)
            mainCorner_2.Name = "mainCorner"
            mainCorner_2.Parent = TextButton

            textButtonInfo.Name = "textButtonInfo"
            textButtonInfo.Parent = textButtonFrame
            textButtonInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            textButtonInfo.BackgroundTransparency = 1.000
            textButtonInfo.Position = UDim2.new(0.395939082, 0, 0.0238095243, 0)
            textButtonInfo.Size = UDim2.new(0, 226, 0, 41)
            textButtonInfo.Font = Enum.Font.GothamSemibold
            textButtonInfo.Text = buttonInfo
            textButtonInfo.TextColor3 = Color3.fromRGB(198, 198, 198)
            textButtonInfo.TextSize = 14.000
            textButtonInfo.TextXAlignment = Enum.TextXAlignment.Right

            TextButton.MouseButton1Click:Connect(function()
                callback()
            end)
        end

            function ElementHandler:Toggle(togInfo, callback)
                togInfo = togInfo or ""
                callback = callback or function() end

                local toggleFrame = Instance.new("Frame")
                local mainCorner = Instance.new("UICorner")
                local toggleInfo = Instance.new("TextLabel")
                local toggleInerFrame = Instance.new("Frame")
                local mainCorner_2 = Instance.new("UICorner")
                local toggleInnerFrame1 = Instance.new("Frame")
                local mainCorner_3 = Instance.new("UICorner")
                local toggleBtn = Instance.new("TextButton")
                local mainCorner_4 = Instance.new("UICorner")
                local UIListLayout = Instance.new("UIListLayout")
                local UIListLayout_2 = Instance.new("UIListLayout")

                toggleFrame.Name = "toggleFrame"
                toggleFrame.Parent = newPage
                toggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                toggleFrame.Position = UDim2.new(0.0147058824, 0, 0.0246913582, 0)
                toggleFrame.Size = UDim2.new(0, 394, 0, 42)

                mainCorner.CornerRadius = UDim.new(0, 3)
                mainCorner.Name = "mainCorner"
                mainCorner.Parent = toggleFrame

                toggleInfo.Name = "toggleInfo"
                toggleInfo.Parent = toggleFrame
                toggleInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggleInfo.BackgroundTransparency = 1.000
                toggleInfo.Position = UDim2.new(0.395939082, 0, 0.0238095243, 0)
                toggleInfo.Size = UDim2.new(0, 226, 0, 41)
                toggleInfo.Font = Enum.Font.GothamSemibold
                toggleInfo.Text = togInfo
                toggleInfo.TextColor3 = Color3.fromRGB(198, 198, 198)
                toggleInfo.TextSize = 14.000
                toggleInfo.TextXAlignment = Enum.TextXAlignment.Right

                toggleInerFrame.Name = "toggleInerFrame"
                toggleInerFrame.Parent = toggleFrame
                toggleInerFrame.BackgroundColor3 = Color3.fromRGB(181, 1, 31)
                toggleInerFrame.Position = UDim2.new(0.0177664906, 0, 0.166666672, 0)
                toggleInerFrame.Size = UDim2.new(0, 27, 0, 27)

                mainCorner_2.CornerRadius = UDim.new(0, 3)
                mainCorner_2.Name = "mainCorner"
                mainCorner_2.Parent = toggleInerFrame

                toggleInnerFrame1.Name = "toggleInnerFrame1"
                toggleInnerFrame1.Parent = toggleInerFrame
                toggleInnerFrame1.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                toggleInnerFrame1.Position = UDim2.new(0.0177664906, 0, -0.0185185075, 0)
                toggleInnerFrame1.Size = UDim2.new(0, 25, 0, 25)

                mainCorner_3.CornerRadius = UDim.new(0, 3)
                mainCorner_3.Name = "mainCorner"
                mainCorner_3.Parent = toggleInnerFrame1

                toggleBtn.Name = "toggleBtn"
                toggleBtn.Parent = toggleInnerFrame1
                toggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                toggleBtn.Position = UDim2.new(2.2399888, 0, -0.0185185149, 0)
                toggleBtn.Size = UDim2.new(0, 23, 0, 23)
                toggleBtn.Font = Enum.Font.GothamSemibold
                toggleBtn.Text = ""
                toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                toggleBtn.TextSize = 14.000
                toggleBtn.AutoButtonColor = false

                mainCorner_4.CornerRadius = UDim.new(0, 3)
                mainCorner_4.Name = "mainCorner"
                mainCorner_4.Parent = toggleBtn

                UIListLayout.Parent = toggleInnerFrame1
                UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

                UIListLayout_2.Parent = toggleInerFrame
                UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
                UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center

                local toggled = false
                toggleBtn.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    callback(toggled)
                    if toggled then
                        game.TweenService:Create(toggleBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),{
                            BackgroundColor3 = Color3.fromRGB(181, 1, 31)
                        }):Play()
                    else
                        game.TweenService:Create(toggleBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),{
                            BackgroundColor3 = Color3.fromRGB(25,25,25)
                        }):Play()
                    end 
                end)
            end

                function ElementHandler:Slider(sliderin, minvalue, maxvalue, callback)
                    minvalue = minvalue or 0
                    maxvalue = maxvalue or 500
                    callback = callback or function() end
                    sliderin = sliderin or "info ok"

                    local sliderFrame = Instance.new("Frame")
                    local mainCorner = Instance.new("UICorner")
                    local sliderInfo = Instance.new("TextLabel")
                    local sliderValue = Instance.new("TextLabel")
                    local sliderBtn = Instance.new("TextButton")
                    local sliderdragfrm = Instance.new("UIListLayout")
                    local sliderMainFrm = Instance.new("Frame")
                    local sliderlist = Instance.new("UIListLayout")
                    local mainCorner_2 = Instance.new("UICorner")
                    local mainCorner_3 = Instance.new("UICorner")

                    sliderFrame.Name = "sliderFrame"
                    sliderFrame.Parent = newPage
                    sliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                    sliderFrame.Position = UDim2.new(0.0147058824, 0, 0.0246913582, 0)
                    sliderFrame.Size = UDim2.new(0, 394, 0, 42)

                    mainCorner.CornerRadius = UDim.new(0, 3)
                    mainCorner.Name = "mainCorner"
                    mainCorner.Parent = sliderFrame

                    sliderInfo.Name = "sliderInfo"
                    sliderInfo.Parent = sliderFrame
                    sliderInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    sliderInfo.BackgroundTransparency = 1.000
                    sliderInfo.Position = UDim2.new(0.570575714, 0, 0.0238095243, 0)
                    sliderInfo.Size = UDim2.new(0, 157, 0, 41)
                    sliderInfo.Font = Enum.Font.GothamSemibold
                    sliderInfo.Text = sliderin
                    sliderInfo.TextColor3 = Color3.fromRGB(198, 198, 198)
                    sliderInfo.TextSize = 14.000
                    sliderInfo.TextXAlignment = Enum.TextXAlignment.Right

                    sliderValue.Name = "sliderValue"
                    sliderValue.Parent = sliderFrame
                    sliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    sliderValue.BackgroundTransparency = 1.000
                    sliderValue.Position = UDim2.new(0.395939082, 0, 0.285714298, 0)
                    sliderValue.Size = UDim2.new(0, 68, 0, 17)
                    sliderValue.Font = Enum.Font.GothamSemibold
                    sliderValue.Text = minvalue.."/"..maxvalue
                    sliderValue.TextColor3 = Color3.fromRGB(199, 0, 33)
                    sliderValue.TextSize = 14.000
                    sliderValue.TextXAlignment = Enum.TextXAlignment.Left

                    sliderBtn.Name = "sliderBtn"
                    sliderBtn.Parent = sliderFrame
                    sliderBtn.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
                    sliderBtn.BorderSizePixel = 0
                    sliderBtn.Position = UDim2.new(0.0179999992, 0, 0.381000012, 0)
                    sliderBtn.Size = UDim2.new(0, 141, 0, 10)
                    sliderBtn.AutoButtonColor = false
                    sliderBtn.Font = Enum.Font.SourceSans
                    sliderBtn.Text = ""
                    sliderBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                    sliderBtn.TextSize = 14.000

                    sliderdragfrm.Name = "sliderdragfrm"
                    sliderdragfrm.Parent = sliderBtn
                    sliderdragfrm.SortOrder = Enum.SortOrder.LayoutOrder
                    sliderdragfrm.VerticalAlignment = Enum.VerticalAlignment.Center

                    sliderMainFrm.Name = "sliderMainFrm"
                    sliderMainFrm.Parent = sliderBtn
                    sliderMainFrm.BackgroundColor3 = Color3.fromRGB(181, 1, 31)
                    sliderMainFrm.BorderColor3 = Color3.fromRGB(181, 1, 31)
                    sliderMainFrm.BorderSizePixel = 0
                    sliderMainFrm.Size = UDim2.new(0, 0, 0, 10)

                    sliderlist.Name = "sliderlist"
                    sliderlist.Parent = sliderMainFrm
                    sliderlist.HorizontalAlignment = Enum.HorizontalAlignment.Right
                    sliderlist.SortOrder = Enum.SortOrder.LayoutOrder
                    sliderlist.VerticalAlignment = Enum.VerticalAlignment.Center

                    mainCorner_2.CornerRadius = UDim.new(0, 5)
                    mainCorner_2.Name = "mainCorner"
                    mainCorner_2.Parent = sliderMainFrm
                    mainCorner_2.Archivable = false

                    mainCorner_3.CornerRadius = UDim.new(0, 3)
                    mainCorner_3.Name = "mainCorner"
                    mainCorner_3.Parent = sliderBtn

                    local mouse = game.Players.LocalPlayer:GetMouse()
                        local uis = game:GetService("UserInputService")
                        local Value;

                        sliderBtn.MouseButton1Down:Connect(function()
                            Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 141) * sliderMainFrm.AbsoluteSize.X) + tonumber(minvalue)) or 0
                            pcall(function()
                                callback(Value)
                            end)
                            sliderMainFrm.Size = UDim2.new(0, math.clamp(mouse.X - sliderMainFrm.AbsolutePosition.X, 0, 141), 0, 10)
                            moveconnection = mouse.Move:Connect(function()
                                sliderValue.Text = Value.."/"..maxvalue
                                Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 141) * sliderMainFrm.AbsoluteSize.X) + tonumber(minvalue))
                                pcall(function()
                                    callback(Value)
                                end)
                                sliderMainFrm.Size = UDim2.new(0, math.clamp(mouse.X - sliderMainFrm.AbsolutePosition.X, 0, 141), 0, 10)
                            end)
                            releaseconnection = uis.InputEnded:Connect(function(Mouse)
                                if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then
                                    Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 141) * sliderMainFrm.AbsoluteSize.X) + tonumber(minvalue))
                                    pcall(function()
                                        callback(Value)
                                    end)
                                    sliderValue.Text = Value.."/"..maxvalue
                                    sliderMainFrm.Size = UDim2.new(0, math.clamp(mouse.X - sliderMainFrm.AbsolutePosition.X, 0, 141), 0, 10)
                                    moveconnection:Disconnect()
                                    releaseconnection:Disconnect()
                                end
                            end)
                        end)
                    end

                        function ElementHandler:KeyBind(keInfo, firstt, callback)
                            local oldKey = firstt.Name
                            keInfo = keInfo or ""
                            callback = callback or function() end

                            local keybindFrame = Instance.new("Frame")
                            local mainCorner = Instance.new("UICorner")
                            local TextButton = Instance.new("TextButton")
                            local mainCorner_2 = Instance.new("UICorner")
                            local keybindinfo = Instance.new("TextLabel")

                            keybindFrame.Name = "keybindFrame"
                            keybindFrame.Parent = newPage
                            keybindFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                            keybindFrame.Position = UDim2.new(0.0147058824, 0, 0.0246913582, 0)
                            keybindFrame.Size = UDim2.new(0, 394, 0, 42)

                            mainCorner.CornerRadius = UDim.new(0, 3)
                            mainCorner.Name = "mainCorner"
                            mainCorner.Parent = keybindFrame

                            TextButton.Parent = keybindFrame
                            TextButton.BackgroundColor3 = Color3.fromRGB(181, 1, 31)
                            TextButton.Position = UDim2.new(0.017766498, 0, 0.166666672, 0)
                            TextButton.Size = UDim2.new(0, 76, 0, 27)
                            TextButton.Font = Enum.Font.GothamSemibold
                            TextButton.Text = oldKey
                            TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                            TextButton.TextSize = 14.000

                            mainCorner_2.CornerRadius = UDim.new(0, 3)
                            mainCorner_2.Name = "mainCorner"
                            mainCorner_2.Parent = TextButton

                            keybindinfo.Name = "keybindinfo"
                            keybindinfo.Parent = keybindFrame
                            keybindinfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            keybindinfo.BackgroundTransparency = 1.000
                            keybindinfo.Position = UDim2.new(0.395939082, 0, 0.0238095243, 0)
                            keybindinfo.Size = UDim2.new(0, 226, 0, 41)
                            keybindinfo.Font = Enum.Font.GothamSemibold
                            keybindinfo.Text = keInfo
                            keybindinfo.TextColor3 = Color3.fromRGB(198, 198, 198)
                            keybindinfo.TextSize = 14.000
                            keybindinfo.TextXAlignment = Enum.TextXAlignment.Right

                            TextButton.MouseButton1Click:connect(function(e) 
                                TextButton.Text = ". . ."
                                local a, b = game:GetService('UserInputService').InputBegan:wait();
                                if a.KeyCode.Name ~= "Unknown" then
                                    TextButton.Text = a.KeyCode.Name
                                    oldKey = a.KeyCode.Name;
                                end
                            end)
                    
                            game:GetService("UserInputService").InputBegan:connect(function(current, ok) 
                                if not ok then 
                                    if current.KeyCode.Name == oldKey then 
                                        callback()
                                    end
                                end
                            end)
                        end

                            function ElementHandler:TextBox(textInfo, placeHolderText1, callback)
                                textInfo = textInfo or ""
                                placeHolderText1 = placeHolderText1 or ""
                                callback = callback or function() end
                                local textBoxFrame = Instance.new("Frame")
                                local mainCorner = Instance.new("UICorner")
                                local textboxInfo = Instance.new("TextLabel")
                                local texboxInner = Instance.new("Frame")
                                local mainCorner_2 = Instance.new("UICorner")
                                local textboxinneer = Instance.new("Frame")
                                local mainCorner_3 = Instance.new("UICorner")
                                local UIListLayout = Instance.new("UIListLayout")
                                local TextBox = Instance.new("TextBox")
                                local UIListLayout_2 = Instance.new("UIListLayout")

                                --Properties:

                                textBoxFrame.Name = "textBoxFrame"
                                textBoxFrame.Parent = newPage
                                textBoxFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                                textBoxFrame.Position = UDim2.new(0.0147058824, 0, 0.0246913582, 0)
                                textBoxFrame.Size = UDim2.new(0, 394, 0, 42)

                                mainCorner.CornerRadius = UDim.new(0, 3)
                                mainCorner.Name = "mainCorner"
                                mainCorner.Parent = textBoxFrame

                                textboxInfo.Name = "textboxInfo"
                                textboxInfo.Parent = textBoxFrame
                                textboxInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                textboxInfo.BackgroundTransparency = 1.000
                                textboxInfo.Position = UDim2.new(0.395939082, 0, 0.0238095243, 0)
                                textboxInfo.Size = UDim2.new(0, 226, 0, 41)
                                textboxInfo.Font = Enum.Font.GothamSemibold
                                textboxInfo.Text = textInfo
                                textboxInfo.TextColor3 = Color3.fromRGB(198, 198, 198)
                                textboxInfo.TextSize = 14.000
                                textboxInfo.TextXAlignment = Enum.TextXAlignment.Right

                                texboxInner.Name = "texboxInner"
                                texboxInner.Parent = textBoxFrame
                                texboxInner.BackgroundColor3 = Color3.fromRGB(181, 1, 31)
                                texboxInner.Position = UDim2.new(0.017766498, 0, 0.166666672, 0)
                                texboxInner.Size = UDim2.new(0, 141, 0, 27)

                                mainCorner_2.CornerRadius = UDim.new(0, 3)
                                mainCorner_2.Name = "mainCorner"
                                mainCorner_2.Parent = texboxInner

                                textboxinneer.Name = "textboxinneer"
                                textboxinneer.Parent = texboxInner
                                textboxinneer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                                textboxinneer.ClipsDescendants = true
                                textboxinneer.Position = UDim2.new(0.411347508, 0, 0.0370370373, 0)
                                textboxinneer.Size = UDim2.new(0, 139, 0, 25)

                                mainCorner_3.CornerRadius = UDim.new(0, 3)
                                mainCorner_3.Name = "mainCorner"
                                mainCorner_3.Parent = textboxinneer

                                UIListLayout.Parent = textboxinneer
                                UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                                UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

                                TextBox.Parent = textboxinneer
                                TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                TextBox.BackgroundTransparency = 1.000
                                TextBox.Size = UDim2.new(1, 0, 1, 0)
                                TextBox.Font = Enum.Font.GothamSemibold
                                TextBox.PlaceholderColor3 = Color3.fromRGB(115, 115, 115)
                                TextBox.PlaceholderText = placeHolderText1
                                TextBox.Text = ""
                                TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                                TextBox.TextSize = 13.000
                                TextBox.TextWrapped = true

                                UIListLayout_2.Parent = texboxInner
                                UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
                                UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
                                UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center

                                TextBox.FocusLost:Connect(function(EnterPressed)
                                    if not EnterPressed then return end
                                    callback(TextBox.Text)
                                    TextBox.Text = ""
                                end)
                            end 

                                function ElementHandler:Dropdown(dInfo, list, callback)
                                    dInfo = dInfo or ""
                                    list = list or {}
                                    callback = callback or function() end

                                    local isDropped = false

                                    local dropDownFrame = Instance.new("Frame")
                                    local mainCorner = Instance.new("UICorner")
                                    local dropdownmain = Instance.new("Frame")
                                    local mainCorner_2 = Instance.new("UICorner")
                                    local dropdownItem = Instance.new("TextLabel")
                                    local ImageButton = Instance.new("ImageButton")
                                    local UIListLayout = Instance.new("UIListLayout")

                                    local DropYSize = 42

                                    dropDownFrame.Name = "dropDownFrame"
                                    dropDownFrame.Parent = newPage
                                    dropDownFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                                    dropDownFrame.ClipsDescendants = true
                                    dropDownFrame.Position = UDim2.new(0.011029412, 0, 0.0205760058, 0)
                                    dropDownFrame.Size = UDim2.new(0, 394, 0, 42)

                                    mainCorner.CornerRadius = UDim.new(0, 3)
                                    mainCorner.Name = "mainCorner"
                                    mainCorner.Parent = dropDownFrame

                                    dropdownmain.Name = "dropdownmain"
                                    dropdownmain.Parent = dropDownFrame
                                    dropdownmain.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                                    dropdownmain.Size = UDim2.new(0, 394, 0, 42)

                                    mainCorner_2.CornerRadius = UDim.new(0, 3)
                                    mainCorner_2.Name = "mainCorner"
                                    mainCorner_2.Parent = dropdownmain

                                    dropdownItem.Name = "dropdownItem"
                                    dropdownItem.Parent = dropdownmain
                                    dropdownItem.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                    dropdownItem.BackgroundTransparency = 1.000
                                    dropdownItem.Position = UDim2.new(0.0223523453, 0, 0, 0)
                                    dropdownItem.Size = UDim2.new(0, 291, 0, 41)
                                    dropdownItem.Font = Enum.Font.GothamSemibold
                                    dropdownItem.Text = dInfo
                                    dropdownItem.TextColor3 = Color3.fromRGB(255, 1, 43)
                                    dropdownItem.TextSize = 14.000
                                    dropdownItem.TextXAlignment = Enum.TextXAlignment.Left

                                    ImageButton.Parent = dropdownmain
                                    ImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                    ImageButton.BackgroundTransparency = 1.000
                                    ImageButton.Position = UDim2.new(0.89974618, 0, 0.238095239, 0)
                                    ImageButton.Size = UDim2.new(0, 27, 0, 21)
                                    ImageButton.Image = "rbxassetid://5165666242"
                                    ImageButton.ImageColor3 = Color3.fromRGB(181, 1, 31)
                                    ImageButton.MouseButton1Click:Connect(function()
                                        if isDropped then
                                            isDropped = false
                                            dropDownFrame:TweenSize(UDim2.new(0, 394, 0, 42), "In", "Quint", 0.10)
                                            game.TweenService:Create(ImageButton, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{
                                                Rotation = 0
                                            }):Play()
                                            wait(0.10)
                                            UpdateSize()
                                        else
                                            isDropped = true
                                            dropDownFrame:TweenSize(UDim2.new(0, 394, 0, DropYSize), "In", "Quint", 0.10)
                                            game.TweenService:Create(ImageButton, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{
                                                Rotation = 180
                                            }):Play()
                                            wait(0.10)
                                            UpdateSize()
                                        end
                                    end)


                                    UIListLayout.Parent = dropDownFrame
                                    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                                    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                                    UIListLayout.Padding = UDim.new(0, 5)

                                    for i,v in next, list do
                                        local optionBtn = Instance.new("TextButton")
                                        local mainCorner_3 = Instance.new("UICorner")

                                        optionBtn.Name = "optionBtn"
                                        optionBtn.Parent = dropDownFrame
                                        optionBtn.BackgroundColor3 = Color3.fromRGB(118, 0, 20)
                                        optionBtn.Position = UDim2.new(0.0253807101, 0, 0.311258286, 0)
                                        optionBtn.Size = UDim2.new(0, 377, 0, 39)
                                        optionBtn.Font = Enum.Font.GothamSemibold
                                        optionBtn.Text = "   "..v
                                        optionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                                        optionBtn.TextSize = 14.000
                                        optionBtn.TextXAlignment = Enum.TextXAlignment.Left
                                        DropYSize = DropYSize + 48
                                        mainCorner_3.CornerRadius = UDim.new(0, 3)
                                        mainCorner_3.Name = "mainCorner"
                                        mainCorner_3.Parent = optionBtn

                                        optionBtn.MouseButton1Click:Connect(function()
                                            callback(v)
                                            dropdownItem.Text = dInfo..": "..v
                                            dropDownFrame:TweenSize(UDim2.new(0, 394, 0, 42), "In", "Quint", 0.10)
                                            wait(0.10)
                                            UpdateSize()
                                            game.TweenService:Create(ImageButton, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{
                                                Rotation = 0
                                            }):Play()
                                            isDropped = false
                                        end)
                                    end
        end
        return ElementHandler
    end
    return SectionHandler
end 

return Orion

]]
OrionLib = loadstring(_ORION_SOURCE)()
end

local Window = OrionLib:MakeWindow({
    Name        = "BF Script v2 — Redz Modules",
    HidePremium = false,
    SaveConfig  = true,
    ConfigFolder= "BFScriptV2",
})

-- TAB: Auto Farm
local FarmTab = Window:MakeTab({ Name = "Auto Farm", Icon = "rbxassetid://4483345998" })
FarmTab:AddToggle({ Name="Auto Farm",       Default=false, Callback=function(v) CFG.AutoFarm.Enabled=v      end })
FarmTab:AddToggle({ Name="Kill Aura",       Default=false, Callback=function(v) CFG.AutoFarm.KillAura=v     end })
FarmTab:AddToggle({ Name="Teleport to Mob", Default=true,  Callback=function(v) CFG.AutoFarm.TeleportMob=v  end })
FarmTab:AddToggle({ Name="Use Skills",      Default=true,  Callback=function(v) CFG.AutoFarm.UseSkills=v    end })
FarmTab:AddSlider({ Name="Aura Radius", Min=10, Max=150, Default=40,   Callback=function(v) CFG.AutoFarm.AuraRadius=v   end })
FarmTab:AddSlider({ Name="Target Level",Min=1,  Max=2800,Default=2800, Callback=function(v) CFG.AutoFarm.TargetLevel=v  end })
FarmTab:AddSlider({ Name="Walk Speed",  Min=16, Max=300, Default=80,   Callback=function(v)
    CFG.AutoFarm.Walkspeed=v
    if State.Humanoid then State.Humanoid.WalkSpeed=v end
end })

-- TAB: Combat
local CombatTab = Window:MakeTab({ Name = "Combat", Icon = "rbxassetid://4483345998" })
CombatTab:AddToggle({ Name="Fast Attack", Default=false, Callback=function(v)
    CFG.FastAttack.Enabled=v
    SetFastAttack(v)
end })
CombatTab:AddSlider({ Name="Attack Speed", Min=1, Max=20, Default=8, Callback=function(v)
    CFG.FastAttack.Speed = v / 100
end })
CombatTab:AddToggle({ Name="Boss Farm",   Default=false, Callback=function(v) CFG.BossFarm.Enabled=v    end })
CombatTab:AddTextbox({ Name="Boss Name", Default="rip_indra", TextDisappear=true, Callback=function(v)
    CFG.BossFarm.BossTarget=v
end })

-- TAB: Raid & Events
local RaidTab = Window:MakeTab({ Name = "Raid & Events", Icon = "rbxassetid://4483345998" })
RaidTab:AddToggle({ Name="Auto Raid", Default=false, Callback=function(v)
    CFG.AutoRaid.Enabled=v
    if v then task.spawn(RunAutoRaid) end
end })
RaidTab:AddDropdown({ Name="Raid Island", Default="Flower",
    Options={"Flower","Magma","Ice","Sand","Forest","Minimap"},
    Callback=function(v) CFG.AutoRaid.Island=v end
})
RaidTab:AddToggle({ Name="Sea Event Farm", Default=false, Callback=function(v) CFG.SeaEvent.Enabled=v  end })
RaidTab:AddToggle({ Name="Dungeon Farm",   Default=false, Callback=function(v)
    CFG.Dungeon.Enabled=v
    if v then task.spawn(RunDungeon) end
end })
RaidTab:AddToggle({ Name="Dungeon Auto Start", Default=true, Callback=function(v) CFG.Dungeon.AutoStart=v end })

-- TAB: Quest & Chest
local QuestTab = Window:MakeTab({ Name = "Quest & Chest", Icon = "rbxassetid://4483345998" })
QuestTab:AddToggle({ Name="Auto Quest", Default=false, Callback=function(v) CFG.AutoQuest.Enabled=v end })
QuestTab:AddToggle({ Name="Auto Chest", Default=false, Callback=function(v) CFG.AutoChest.Enabled=v end })
QuestTab:AddSlider({ Name="Chest Radius", Min=50, Max=1000, Default=200, Callback=function(v)
    CFG.AutoChest.Radius=v
end })

-- TAB: Fruit
local FruitTab = Window:MakeTab({ Name = "Fruit", Icon = "rbxassetid://4483345998" })
FruitTab:AddToggle({ Name="Fruit Sniper",   Default=false, Callback=function(v) CFG.FruitSniper.Enabled=v     end })
FruitTab:AddToggle({ Name="Auto Collect",   Default=true,  Callback=function(v) CFG.FruitSniper.AutoCollect=v end })
FruitTab:AddToggle({ Name="Notify on Spawn",Default=true,  Callback=function(v) CFG.FruitSniper.Notify=v      end })
FruitTab:AddSlider({ Name="Snipe Radius", Min=100, Max=10000, Default=5000, Callback=function(v)
    CFG.FruitSniper.SpawnRadius=v
end })
FruitTab:AddToggle({ Name="Fruit ESP",      Default=false, Callback=function(v)
    CFG.FruitESP.Enabled=v
    RunFruitESP()
end })
FruitTab:AddSlider({ Name="ESP Max Distance", Min=500, Max=10000, Default=8000, Callback=function(v)
    CFG.FruitESP.MaxDist=v
end })

-- TAB: Stats & Mastery
local StatTab = Window:MakeTab({ Name = "Stats & Mastery", Icon = "rbxassetid://4483345998" })
StatTab:AddToggle({ Name="Auto Stat Allocator", Default=false, Callback=function(v) CFG.AutoStat.Enabled=v     end })
StatTab:AddDropdown({ Name="Priority 1", Default="Melee",   Options={"Melee","Defense","Sword","Gun","Fruit"}, Callback=function(v) CFG.AutoStat.Priority[1]=v end })
StatTab:AddDropdown({ Name="Priority 2", Default="Defense", Options={"Melee","Defense","Sword","Gun","Fruit"}, Callback=function(v) CFG.AutoStat.Priority[2]=v end })
StatTab:AddDropdown({ Name="Priority 3", Default="Sword",   Options={"Melee","Defense","Sword","Gun","Fruit"}, Callback=function(v) CFG.AutoStat.Priority[3]=v end })
StatTab:AddDropdown({ Name="Priority 4", Default="Gun",     Options={"Melee","Defense","Sword","Gun","Fruit"}, Callback=function(v) CFG.AutoStat.Priority[4]=v end })
StatTab:AddDropdown({ Name="Priority 5", Default="Fruit",   Options={"Melee","Defense","Sword","Gun","Fruit"}, Callback=function(v) CFG.AutoStat.Priority[5]=v end })
StatTab:AddToggle({ Name="Mastery Farm",  Default=false, Callback=function(v) CFG.MasteryFarm.Enabled=v    end })
StatTab:AddDropdown({ Name="Mastery Weapon", Default="Sword", Options={"Sword","Gun","Fruit"}, Callback=function(v) CFG.MasteryFarm.Weapon=v end })

-- TAB: Movement
local MoveTab = Window:MakeTab({ Name = "Movement", Icon = "rbxassetid://4483345998" })
MoveTab:AddToggle({ Name="Fly  [F]",   Default=false, Callback=function(v) if v then EnableFly() else DisableFly() end end })
MoveTab:AddSlider({ Name="Fly Speed",  Min=10, Max=500, Default=60, Callback=function(v) CFG.Movement.FlySpeed=v  end })
MoveTab:AddToggle({ Name="Anti-AFK",   Default=true,  Callback=function(v) CFG.Movement.AntiAFK=v  end })
MoveTab:AddToggle({ Name="Anti-Kick",  Default=true,  Callback=function(v) CFG.Movement.AntiKick=v end })

-- ┌─────────────────────────────────────────────────────────┐
-- │  SECTION 25 — INIT                                      │
-- └─────────────────────────────────────────────────────────┘
StartFruitSniper()
OrionLib:Init()
Notify("BF Script v2", "Loaded — " .. #MOB_TABLE .. " mob entries, Redz modules active")
