local WindUI = loadstring(game:HttpGet("https://pastebin.com/raw/m8P8dLfd"))()

-- ============================================
-- CONFIGURATION MODULE
-- ============================================
local Config = {
    Window = {
        Title = "TForge",
        Icon = "gamepad-2",
        Author = "JumantaraHub v23",
        Theme = "Plant",
        Folder = "UniversalScript_v23s"
    },

    OpenButton = {
        Title = "Open Menu",
        Icon = "menu",
        CornerRadius = UDim.new(0, 16),
        StrokeThickness = 2,
        Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
        OnlyMobile = false,
        Enabled = true,
        Draggable = true
    }
}

-- ============================================
-- DATABASE MODULE
-- ============================================
local Database = {
    Mobs = {
        ["Island 1: Stonewake"] = {
            "Zombie", "Delver Zombie", "EliteZombie", "Brute Zombie"
        },
        ["Island 2: Forgotten"] = {
            "Bomber", "Skeleton Rogue", "Axe Skeleton", "Deathaxe Skeleton",
            "Elite Rogue Skeleton", "Elite Deathaxe Skeleton",
            "Slime", "Blazing Slime", "Blight Pyromancer", "Reaper"
        },
        ["Island 3: Frostspire"] = {
            "Crystal Spider", "Diamond Spider", "Prismarine Spider",
            "Common Orc", "Elite Orc", "Crystal Golem", "Yeti", "Ice Golem Boss"
        },
        ["[DETECTED IN SERVER]"] = {}
    },

    Ores = {
        "Aether Lotus", "Aetherit", "Aite", "Amethyst", "Aqujade", "Arcane Crystal",
        "Bananite", "Blue Crystal", "Boneite", "Cardboardite", "Ceyite", "Cobalt",
        "Coinite", "Copper", "Crimson Crystal", "Crimsonite", "Cryptex", "Cuprite",
        "Dark Boneite", "Darkryte", "Demonite", "Diamond", "Emerald", "Etherealite",
        "Eye Ore", "Fichillium", "Fichilliumorite", "Fireite", "Frost Fossil",
        "Galaxite", "Galestor", "Gargantuan", "Gold", "Graphite", "Grass",
        "Green Crystal", "Heavenite", "Iceite", "Iron", "Lapis Lazuli", "Larimar",
        "Lgarite", "Lightite", "Magenta Crystal", "Magmaite", "Malachite", "Marblite",
        "Mistvein", "Moltenfrost", "Mosasaursit", "Mushroomite", "Mythril",
        "Neurotite", "Obsidian", "Orange Crystal", "Platinum", "Poopite", "Pumice",
        "Quartz", "Rainbow Crystal", "Rivalite", "Ruby", "Sanctis", "Sand Stone",
        "Sapphire", "Scheelite", "Silver", "Slimite", "Snowite", "Starite", "Stone",
        "Sulfur", "Suryafal", "Tide Carve", "Tin", "Titanium", "Topaz", "Tungsten",
        "Uranium", "Vanegos", "Velchire", "Voidfractal", "Voidstar", "Volcanic Rock",
        "Vooite", "Zephyte"
    },

    OreRarity = {
        ["Sapphire"] = "Rare",
        ["Rivalite"] = "Epic",
        ["Obsidian"] = "Epic",
        ["Sanctis"] = "Legendary",
        ["Ruby"] = "Epic",
        ["Darkryte"] = "Mythic",
        ["Marblite"] = "Exotic",
        ["Tungsten"] = "Common",
        ["Cuprite"] = "Epic",
        ["Volcanic Rock"] = "Rare",
        ["Magmaite"] = "Legendary",
        ["Neurotite"] = "Epic",
        ["Crimson Crystal"] = "Epic",
        ["Dark Boneite"] = "Rare",
        ["Graphite"] = "Rare",
        ["Fireite"] = "Legendary",
        ["Green Crystal"] = "Epic",
        ["Emerald"] = "Epic",
        ["Slimite"] = "Epic",
        ["Magenta Crystal"] = "Epic",
        ["Moltenfrost"] = "Epic",
        ["Crimsonite"] = "Epic",
        ["Lgarite"] = "Rare",
        ["Amethyst"] = "Rare",
        ["Malachite"] = "Epic",
        ["Sand Stone"] = "Common",
        ["Quartz"] = "Rare",
        ["Diamond"] = "Rare",
        ["Gargantuan"] = "Divine",
        ["Lightite"] = "Legendary",
        ["Galestor"] = "Epic",
        ["Snowite"] = "Legendary",
        ["Blue Crystal"] = "Epic",
        ["Coinite"] = "Epic",
        ["Cardboardite"] = "Common",
        ["Bananite"] = "Uncommon",
        ["Heavenite"] = "Divine",
        ["Fichillium"] = "Relic",
        ["Tin"] = "Uncommon",
        ["Mistvein"] = "Rare",
        ["Gold"] = "Uncommon",
        ["Galaxite"] = "Divine",
        ["Suryafal"] = "Relic",
        ["Rainbow Crystal"] = "Legendary",
        ["Boneite"] = "Rare",
        ["Aqujade"] = "Epic",
        ["Lapis Lazuli"] = "Uncommon",
        ["Mosasaursit"] = "Exotic",
        ["Platinum"] = "Rare",
        ["Iceite"] = "Mythic",
        ["Vooite"] = "Exotic",
        ["Ceyite"] = "Exotic",
        ["Sulfur"] = "Uncommon",
        ["Starite"] = "Mythic",
        ["Grass"] = "Common",
        ["Eye Ore"] = "Legendary",
        ["Titanium"] = "Uncommon",
        ["Iron"] = "Common",
        ["Aether Lotus"] = "Rare",
        ["Vanegos"] = "Rare",
        ["Zephyte"] = "Rare",
        ["Etherealite"] = "Mythic",
        ["Voidstar"] = "Legendary",
        ["Demonite"] = "Mythic",
        ["Uranium"] = "Legendary",
        ["Aite"] = "Epic",
        ["Frost Fossil"] = "Epic",
        ["Fichilliumorite"] = "Unobtainable",
        ["Cryptex"] = "Epic",
        ["Mythril"] = "Legendary",
        ["Mushroomite"] = "Rare",
        ["Voidfractal"] = "Rare",
        ["Copper"] = "Common",
        ["Aetherit"] = "Rare",
        ["Stone"] = "Common",
        ["Silver"] = "Uncommon",
        ["Poopite"] = "Epic",
        ["Topaz"] = "Rare",
        ["Velchire"] = "Legendary",
        ["Tide Carve"] = "Epic",
        ["Pumice"] = "Rare",
        ["Orange Crystal"] = "Epic",
        ["Larimar"] = "Epic",
        ["Scheelite"] = "Rare",
        ["Cobalt"] = "Uncommon",
        ["Arcane Crystal"] = "Mythic",
    },

    Rocks = {
        "Basalt Core", "Basalt Rock", "Basalt Vein", "Boulder",
        "Crimson Crystal", "Cyan Crystal", "Earth Crystal", "Floating Crystal",
        "Iceberg", "Icy Boulder", "Icy Pebble", "Icy Rock",
        "Large Ice Crystal", "Light Crystal", "Lucky Block",
        "Medium Ice Crystal", "Pebble", "Rock", "Small Ice Crystal",
        "Violet Crystal", "Volcanic Rock"
    },

    Equipment = {
        Raw = {
            ["Axe"] = { "Axe", "Battleaxe", "Curved Handle Axe", "Spade Armed Axe" },
            ["ColossalSword"] = { "Great Sword", "Dragon Slayer", "Hammer", "Skull Crusher", "Comically Large Spoon", "Excalibur" },
            ["Dagger"] = { "Dagger", "Falchion Knife", "Gladius Dagger", "Hook" },
            ["Gauntlet"] = { "Ironhand", "Boxing Gloves", "Relevator", "Savage Claws" },
            ["GreatAxe"] = { "Reaper", "Scythe", "Double Battle Axe", "Wyvern Axe", "Greater Battle Axe" },
            ["GreatSword"] = { "Crusader Sword", "Long Sword" },
            ["HeavyChestplate"] = { "Knight Chestplate", "Dark Knight Chestplate", "Wolf Chestplate", "Raven's Chestplate" },
            ["HeavyHelmet"] = { "Knight Helmet", "Dark Knight Helmet", "Wolf Helmet", "Raven's Helmet" },
            ["HeavyLeggings"] = { "Knight Leggings", "Dark Knight Leggings", "Wolf Leggings", "Raven's Leggings" },
            ["Katana"] = { "Uchigatana", "Tachi" },
            ["LightChestplate"] = { "Light Chestplate" },
            ["LightHelmet"] = { "Light Helmet" },
            ["LightLeggings"] = { "Light Leggings" },
            ["Mace"] = { "Mace", "Spiked Mace", "Winged Mace", "Hammerhead Mace", "Grave Maker" },
            ["MediumChestplate"] = { "Medium Chestplate", "Samurai Chestplate", "Viking Chestplate" },
            ["MediumHelmet"] = { "Medium Helmet", "Samurai Helmet", "Viking Helmet" },
            ["MediumLeggings"] = { "Medium Leggings", "Samurai Leggings", "Viking Leggings" },
            ["Spear"] = { "Angelic Spear", "Demonic Spear", "Spear", "Trident" },
            ["StraightSword"] = { "Falchion", "Gladius", "Cutlass", "Rapier", "Chaos", "Candy Cane", "Hell Slayer" }
        },

        MergedCategories = {
            ["Light Armor"] = { "LightChestplate", "LightHelmet", "LightLeggings" },
            ["Medium Armor"] = { "MediumChestplate", "MediumHelmet", "MediumLeggings" },
        }
    }
}

-- Process merged equipment categories
Database.Equipment.Processed = {}
for cat, items in pairs(Database.Equipment.Raw) do
    local isMerged = false
    for _, subCats in pairs(Database.Equipment.MergedCategories) do
        if table.find(subCats, cat) then
            isMerged = true
            break
        end
    end
    if not isMerged then
        Database.Equipment.Processed[cat] = items
    end
end

for newName, subCats in pairs(Database.Equipment.MergedCategories) do
    Database.Equipment.Processed[newName] = {}
    for _, oldCat in pairs(subCats) do
        if Database.Equipment.Raw[oldCat] then
            for _, item in pairs(Database.Equipment.Raw[oldCat]) do
                table.insert(Database.Equipment.Processed[newName], item)
            end
        end
    end
    table.sort(Database.Equipment.Processed[newName])
end

-- ============================================
-- SERVICES MODULE
-- ============================================
local Services = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    TweenService = game:GetService("TweenService"),
    Workspace = game:GetService("Workspace")
}

local LocalPlayer = Services.Players.LocalPlayer

-- ============================================
-- STATE MANAGER
-- ============================================
local State = {
    CurrentWorld = "",
    AutoClick = false,
    WalkSpeedVal = 16,
    JumpPowerVal = 50,
    NoClip = false,
    ESPEnabled = false,
    AutoRun = false,
    AutoAttack = false,
    AutoMine = false,
    TargetWeaponName = "Weapon",
    TargetMineName = "Pickaxe",
    SelectedAreas = {},
    TweenSpeed = 50,
    GlobalHeight = 5,
    GlobalDistance = 0,
    AutoFarmMobs = false,
    SelectedMobs = {},
    SelectedSellItems = {},
    SellAmount = 1,
    AutoSell = false,
    SelectedRocks = {},
    SelectedSellEquips = {},
    CategoryConfig = {},
    SelectedRarityToSell = "Common",
    AutoSellByRarity = false,
    RarityOreSelection = {},
    MerchantInitInProgress = false,
    LastMerchantInitTime = 0,
    MerchantInitCooldown = 3,
    SellQueue = {},
    IsProcessingQueue = false,
    CurrentMerchantDialog = nil,
    AutoSellOreActive = false,
    AutoSellEquipActive = false,
    CurrentMerchantInit = nil,
    OreNPCReference = nil,
    LastOreDialogTime = 0,
    ForgeSlots = {
        [1] = { Ore = nil, Amount = 0 },
        [2] = { Ore = nil, Amount = 0 },
        [3] = { Ore = nil, Amount = 0 },
        [4] = { Ore = nil, Amount = 0 }
    },
    ForgeItemType = "Weapon",
    DesyncX = "0",
    DesyncY = "0",
    DesyncZ = "0",
    DesyncActive = false,
    LoopOnJoin = false,
    PlatformLoop = nil,
    SmartMine = false,
    KeepOres = {},
    IgnoredRocks = {},
    CurrentTargetRock = nil,
    AvoidStealing = false,
    Priority1 = {},
    Priority2 = {},
    Priority3 = {},
    MineOthers = false,

    FilterSpecificRocks = {},
}
-- ============================================
-- REPLICATE SIGNAL FUNCTION (UNTUK DESYNC)
-- ============================================
if not replicatesignal then
    replicatesignal = function(signal)
        warn("replicatesignal tidak tersedia di executor ini")
        return false
    end
end
-- ============================================
-- UTILITY FUNCTIONS
-- ============================================
local Utilities = {}

function Utilities.GetCleanName(name)
    local clean = string.gsub(name, "%d+", "")
    return string.match(clean, "^%s*(.-)%s*$")
end

function Utilities.SetAnchor(state)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Anchored = state
    end
end

function Utilities.EquipToolByName(targetName)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local backpack = LocalPlayer.Backpack

    if char and hum and hum.Health > 0 then
        local toolInHand = char:FindFirstChild(targetName)
        if toolInHand then return true end

        local toolInBag = backpack:FindFirstChild(targetName)
        if toolInBag then
            hum:UnequipTools()
            hum:EquipTool(toolInBag)
            return true
        end
    end
    return false
end

function Utilities.GetAreaList()
    local list = {}
    local rocksFolder = Services.Workspace:FindFirstChild("Rocks")
    if rocksFolder then
        for _, folder in pairs(rocksFolder:GetChildren()) do
            table.insert(list, folder.Name)
        end
    end
    return list
end

function Utilities.GetMobList()
    local list = {}
    local living = Services.Workspace:FindFirstChild("Living")
    if living then
        for _, model in pairs(living:GetChildren()) do
            if model:IsA("Model") and model:FindFirstChild("Humanoid") then
                if not Services.Players:GetPlayerFromCharacter(model) then
                    local cleanName = Utilities.GetCleanName(model.Name)
                    if not table.find(list, cleanName) then
                        table.insert(list, cleanName)
                    end
                end
            end
        end
    end
    table.sort(list)
    return list
end

function Utilities.GetMobOptions()
    local world = State.CurrentWorld
    if world == "[DETECTED IN SERVER]" then
        return Utilities.GetMobList()
    else
        return Database.Mobs[world] or {}
    end
end

function Utilities.GetAllRarities()
    local rarities = {}
    for _, rarity in pairs(Database.OreRarity) do
        if not table.find(rarities, rarity) then
            table.insert(rarities, rarity)
        end
    end
    table.sort(rarities)
    return rarities
end

function Utilities.GetOresByRarity(rarity)
    local result = {}
    for oreName, oreRarity in pairs(Database.OreRarity) do
        if oreRarity == rarity then
            table.insert(result, oreName)
        end
    end
    table.sort(result)
    return result
end

function Utilities.GetPlayerOreAmount(oreName)
    local ReplicatedStorage = Services.ReplicatedStorage
    local Knit = require(ReplicatedStorage.Shared.Packages.Knit)

    local hasController, PlayerController = pcall(function()
        return Knit.GetController("PlayerController")
    end)

    if hasController and PlayerController and PlayerController.Replica then
        local Data = PlayerController.Replica.Data

        local targetData = nil
        if Data.Inventory then
            if Data.Inventory.Ores and Data.Inventory.Ores[oreName] then
                targetData = Data.Inventory.Ores[oreName]
            elseif Data.Inventory.Misc and Data.Inventory.Misc[oreName] then
                targetData = Data.Inventory.Misc[oreName]
            elseif Data.Inventory[oreName] then
                targetData = Data.Inventory[oreName]
            end
        end

        if not targetData and Data.Ores and Data.Ores[oreName] then
            targetData = Data.Ores[oreName]
        end

        if targetData then
            if type(targetData) == "number" then
                return targetData
            elseif type(targetData) == "table" then
                return targetData.Amount or targetData.Value or targetData.Count or 0
            end
        end
    end
    return 0
end

function Utilities.GetEquipmentsToSell(targetNames)
    local guids = {}
    local Knit = require(Services.ReplicatedStorage.Shared.Packages.Knit)

    local success, PlayerController = pcall(function() return Knit.GetController("PlayerController") end)
    if success and PlayerController and PlayerController.Replica then
        local Data = PlayerController.Replica.Data
        local EquipSource = Data.Equipments or (Data.Inventory and Data.Inventory.Equipments)

        if EquipSource then
            for _, itemData in pairs(EquipSource) do
                if type(itemData) == "table" then
                    local realName = itemData.Name or itemData.Type
                    if realName and table.find(targetNames, realName) then
                        local id = itemData.GUID or itemData.UniqueId
                        if id then table.insert(guids, id) end
                    end
                end
            end
        end
    end
    return guids
end

-- ============================================
-- MOVEMENT FUNCTIONS
-- ============================================
local Movement = {}

function Movement.DetectCurrentWorld()
    local rocks = Services.Workspace:FindFirstChild("Rocks")
    if rocks then
        for _, folder in pairs(rocks:GetChildren()) do
            local n = folder.Name
            if string.find(n, "Island3") then return "Island 3: Frostspire" end
            if string.find(n, "Island2") then return "Island 2: Forgotten" end
        end
    end
    return "Island 1: Stonewake"
end

function Movement.TweenTo(targetCFrame)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local dist = (hrp.Position - targetCFrame.Position).Magnitude
        local speed = State.TweenSpeed or 50

        if speed <= 0 then speed = 50 end

        local time = dist / speed

        if time ~= time or time == math.huge then
            warn("Waktu tween tidak valid:", time)
            time = 1
        end

        -- PERBAIKAN: Gunakan TweenInfo.new, bukan Services.TweenInfo.new
        local info = TweenInfo.new(
            time,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        )

        local tween = Services.TweenService:Create(hrp, info, {
            CFrame = targetCFrame
        })

        tween:Play()

        local success, err = pcall(function()
            tween.Completed:Wait()
        end)

        if not success then
            warn("Tween gagal:", err)
        end
    else
        warn("Karakter atau HumanoidRootPart tidak ditemukan untuk TweenTo.")
    end
end

function Movement.TweenToNPC(npcPos, distance)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end

    local targetPos = npcPos * CFrame.new(0, 0, distance)
    local finalCFrame = CFrame.lookAt(targetPos.Position, npcPos.Position)

    Utilities.SetAnchor(false)

    -- Gunakan TweenTo yang sudah diperbaiki
    local success, err = pcall(function()
        Movement.TweenTo(finalCFrame)
    end)

    return success
end

function Movement.DetectCurrentWorld()
    local rocks = Services.Workspace:FindFirstChild("Rocks")
    if rocks then
        for _, folder in pairs(rocks:GetChildren()) do
            local n = folder.Name
            if string.find(n, "Island3") then return "Island 3: Frostspire" end
            if string.find(n, "Island2") then return "Island 2: Forgotten" end
        end
    end
    return "Island 1: Stonewake"
end

function Movement.TweenToPos(targetPos)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local dist = (hrp.Position - targetPos).Magnitude
        local speed = State.TweenSpeed or 50

        -- Pastikan speed tidak 0 atau negatif
        if speed <= 0 then speed = 50 end

        local time = dist / speed

        -- Pastikan time tidak NaN atau infinite
        if time ~= time or time == math.huge then
            warn("Waktu tween tidak valid:", time)
            time = 1
        end

        -- PERBAIKAN: Gunakan TweenInfo.new, bukan Services.TweenInfo.new
        local info = TweenInfo.new(
            time,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.Out
        )

        local tween = Services.TweenService:Create(hrp, info, {
            CFrame = CFrame.new(targetPos)
        })

        local wasAnchored = hrp.Anchored
        hrp.Anchored = false
        tween:Play()

        -- Gunakan pcall untuk handle error
        local success, err = pcall(function()
            tween.Completed:Wait()
        end)

        if not success then
            warn("Tween gagal:", err)
        end

        hrp.Anchored = wasAnchored
    else
        warn("Karakter atau HumanoidRootPart tidak ditemukan untuk TweenToPos.")
    end
end

-- ============================================
-- ESP SYSTEM
-- ============================================
local ESP = {
    Holder = Instance.new("Folder", game.CoreGui)
}

ESP.Holder.Name = "WindUI_ESP_Storage"

function ESP.Clear()
    ESP.Holder:ClearAllChildren()
end

function ESP.Create(player)
    if player == LocalPlayer then return end

    local function UpdateVisuals()
        if not State.ESPEnabled then return end

        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if not char:FindFirstChild("WindESP_Highlight") then
                local hl = Instance.new("Highlight")
                hl.Name = "WindESP_Highlight"
                hl.Adornee = char
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.FillTransparency = 0.5
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.OutlineTransparency = 0
                hl.Parent = char
            end

            local head = char:FindFirstChild("Head")
            if head and not head:FindFirstChild("WindESP_Tag") then
                local bg = Instance.new("BillboardGui")
                bg.Name = "WindESP_Tag"
                bg.Adornee = head
                bg.Size = UDim2.new(0, 200, 0, 50)
                bg.StudsOffset = Vector3.new(0, 2, 0)
                bg.AlwaysOnTop = true

                local nameLabel = Instance.new("TextLabel", bg)
                nameLabel.Size = UDim2.new(1, 0, 1, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.TextStrokeTransparency = 0
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.Font = Enum.Font.SourceSansBold
                nameLabel.TextSize = 14

                task.spawn(function()
                    while char and char.Parent and head:FindFirstChild("WindESP_Tag") do
                        if not State.ESPEnabled then
                            bg:Destroy()
                            break
                        end

                        local dist = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
                            and (LocalPlayer.Character.HumanoidRootPart.Position - head.Position).Magnitude or 0

                        nameLabel.Text = player.Name .. "\n[" .. math.floor(dist) .. "m]"
                        task.wait(0.1)
                    end
                end)

                bg.Parent = head
            end
        end
    end

    player.CharacterAdded:Connect(function(c)
        task.wait(1)
        UpdateVisuals()
    end)

    if player.Character then
        UpdateVisuals()
    end
end

function ESP.Toggle(state)
    State.ESPEnabled = state
    if state then
        for _, p in pairs(Services.Players:GetPlayers()) do
            ESP.Create(p)
        end
        Services.Players.PlayerAdded:Connect(function(p)
            ESP.Create(p)
        end)
    else
        for _, p in pairs(Services.Players:GetPlayers()) do
            if p.Character then
                local hl = p.Character:FindFirstChild("WindESP_Highlight")
                if hl then hl:Destroy() end

                local head = p.Character:FindFirstChild("Head")
                if head then
                    local tag = head:FindFirstChild("WindESP_Tag")
                    if tag then tag:Destroy() end
                end
            end
        end
    end
end

-- ============================================
-- FARMING FUNCTIONS
-- ============================================
local Farming = {}

function Farming.FindNearestRockInSelectedAreas()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local rocksFolder = Services.Workspace:FindFirstChild("Rocks")
    if not rocksFolder then return nil end

    local candidates = {
        P1 = {},
        P2 = {},
        P3 = {},
        Other = {}
    }

    local areasToScan = {}
    if #State.SelectedAreas > 0 then
        for _, areaName in pairs(State.SelectedAreas) do
            local folder = rocksFolder:FindFirstChild(areaName)
            if folder then table.insert(areasToScan, folder) end
        end
    else
        areasToScan = rocksFolder:GetChildren()
    end

    for _, area in pairs(areasToScan) do
        if area:IsA("Folder") or area:IsA("Model") then
            for _, spawnLoc in pairs(area:GetChildren()) do
                if spawnLoc.Name == "SpawnLocation" then
                    local rockModel = spawnLoc:FindFirstChildWhichIsA("Model")

                    if rockModel and not State.IgnoredRocks[rockModel] then
                        local isDead = false
                        local hp = 0
                        local hpAttr = rockModel:GetAttribute("Health")
                        if hpAttr then hp = hpAttr end
                        local hpVal = rockModel:FindFirstChild("Health")
                        if hpVal and hpVal:IsA("ValueBase") then hp = hpVal.Value end

                        if hp <= 0 then isDead = true end

                        if not isDead then
                            local rockName = rockModel.Name
                            local tPos = rockModel:GetPivot().Position
                            local dist = (hrp.Position - tPos).Magnitude
                            local data = { Model = rockModel, CFrame = rockModel:GetPivot(), Dist = dist }

                            if table.find(State.Priority1, rockName) then
                                table.insert(candidates.P1, data)
                            elseif table.find(State.Priority2, rockName) then
                                table.insert(candidates.P2, data)
                            elseif table.find(State.Priority3, rockName) then
                                table.insert(candidates.P3, data)
                            elseif State.MineOthers then
                                table.insert(candidates.Other, data)
                            end
                        end
                    end
                end
            end
        end
    end

    local function GetClosest(list)
        local closest = nil
        local minDist = math.huge
        for _, data in pairs(list) do
            if data.Dist < minDist then
                minDist = data.Dist
                closest = data
            end
        end
        return closest
    end

    local winner = GetClosest(candidates.P1)
    if winner then return winner.CFrame, winner.Model end

    winner = GetClosest(candidates.P2)
    if winner then return winner.CFrame, winner.Model end

    winner = GetClosest(candidates.P3)
    if winner then return winner.CFrame, winner.Model end

    winner = GetClosest(candidates.Other)
    if winner then return winner.CFrame, winner.Model end

    return nil, nil
end

function Farming.GetOreInRock(rockModel)
    if not rockModel then return nil end

    local oreModel = rockModel:FindFirstChild("Ore")
    if oreModel then
        for _, child in pairs(oreModel:GetChildren()) do
            if table.find(Database.Ores, child.Name) then
                return child.Name
            end

            for _, dbOre in pairs(Database.Ores) do
                if string.find(child.Name, dbOre) then
                    return dbOre
                end
            end
        end
        return "Unknown Ore"
    end

    local attributes = rockModel:GetAttributes()
    for attName, attValue in pairs(attributes) do
        if type(attValue) == "string" and table.find(Database.Ores, attValue) then
            return attValue
        end
    end

    for _, child in pairs(rockModel:GetDescendants()) do
        if child:IsA("StringValue") and table.find(Database.Ores, child.Value) then
            return child.Value
        end
    end

    return nil
end

function Farming.ShowOreESP(rockModel, oreName)
    if not rockModel or not oreName then return end
    if rockModel:FindFirstChild("SmartMineESP") then return end

    local bg = Instance.new("BillboardGui")
    bg.Name = "SmartMineESP"
    bg.Adornee = rockModel.PrimaryPart or rockModel:FindFirstChild("Part")
    bg.Size = UDim2.new(0, 200, 0, 50)
    bg.StudsOffset = Vector3.new(0, 3, 0)
    bg.AlwaysOnTop = true

    local label = Instance.new("TextLabel", bg)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 0.8, 0) -- Warna Emas
    label.TextStrokeTransparency = 0
    label.TextSize = 20
    label.Text = "Contains: " .. oreName

    bg.Parent = rockModel
end

function Farming.FindNearestMob()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local nearestMob = nil
    local minDist = math.huge

    local living = Services.Workspace:FindFirstChild("Living")
    if living then
        for _, mob in pairs(living:GetChildren()) do
            local mobCleanName = Utilities.GetCleanName(mob.Name)
            if table.find(State.SelectedMobs, mobCleanName) then
                local mobHum = mob:FindFirstChild("Humanoid")
                local mobRoot = mob:FindFirstChild("HumanoidRootPart") or mob.PrimaryPart

                if mobHum and mobRoot and mobHum.Health > 0 then
                    local dist = (hrp.Position - mobRoot.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearestMob = mobRoot
                    end
                end
            end
        end
    end
    return nearestMob
end

-- ============================================
-- MERCHANT SYSTEM
-- ============================================
local Merchant = {}

function Merchant.NeedsReinit(requiredMerchant)
    local timeSinceInit = tick() - State.LastMerchantInitTime
    local needsReinit = State.CurrentMerchantInit ~= requiredMerchant or
        timeSinceInit > State.MerchantInitCooldown
    return needsReinit
end

function Merchant.InitOre()
    print("\n[MERCHANT INIT] Starting Ore Merchant initialization...")
    return task.spawn(function()
        local success = false
        local shop = Services.Workspace:FindFirstChild("Shops") and Services.Workspace.Shops:FindFirstChild("Ore Seller")
        local npc = Services.Workspace:FindFirstChild("Proximity") and
            Services.Workspace.Proximity:FindFirstChild("Greedy Cey")

        if shop and npc then
            print("✅ [MERCHANT INIT] Found Ore Seller and Greedy Cey NPC")
            print("[MERCHANT INIT] Walking to merchant...")

            if Movement.TweenToNPC(shop.WorldPivot, 5) then
                task.wait(0.5)
                print("[MERCHANT INIT] Opening dialogue...")

                local dialogSuccess = pcall(function()
                    local args = { npc }
                    Services.ReplicatedStorage.Shared.Packages.Knit.Services.ProximityService.RF.Dialogue
                        :InvokeServer(unpack(args))
                end)

                if dialogSuccess then
                    print("✅ [MERCHANT INIT] Ore Merchant ready for selling!")
                    State.CurrentMerchantInit = "Ore"
                    State.LastMerchantInitTime = tick()
                    success = true
                else
                    warn("❌ [MERCHANT INIT] Failed to open dialogue")
                end
            else
                warn("❌ [MERCHANT INIT] Failed to tween to merchant")
            end
        else
            warn("❌ [MERCHANT INIT] Ore Seller or Greedy Cey not found!")
        end
        return success
    end)
end

function Merchant.InitEquipment()
    print("\n[MERCHANT INIT] Starting Equipment Merchant initialization...")
    return task.spawn(function()
        local success = false
        local npc = Services.Workspace:FindFirstChild("Proximity") and
            Services.Workspace.Proximity:FindFirstChild("Marbles")

        if npc then
            print("✅ [MERCHANT INIT] Found Marbles NPC")
            print("[MERCHANT INIT] Walking to equipment merchant...")

            local npcPos = npc:GetPivot()
            if Movement.TweenToNPC(npcPos, 5) then
                task.wait(0.5)
                print("[MERCHANT INIT] Opening dialogue...")

                local dialogSuccess = pcall(function()
                    local args = { npc }
                    Services.ReplicatedStorage.Shared.Packages.Knit.Services.ProximityService.RF.Dialogue
                        :InvokeServer(unpack(args))
                end)

                if dialogSuccess then
                    print("✅ [MERCHANT INIT] Equipment Merchant ready for selling!")
                    State.CurrentMerchantInit = "Equipment"
                    State.LastMerchantInitTime = tick()
                    success = true
                else
                    warn("❌ [MERCHANT INIT] Failed to open dialogue")
                end
            else
                warn("❌ [MERCHANT INIT] Failed to tween to merchant")
            end
        else
            warn("❌ [MERCHANT INIT] Marbles NPC not found!")
        end
        return success
    end)
end

-- ============================================
-- FORGE SYSTEM
-- ============================================
local Forge = {}

function Forge.Run()
    local ReplicatedStorage = Services.ReplicatedStorage
    local Workspace = Services.Workspace

    local finalRecipe = {}
    local totalMaterials = 0
    local missingMaterials = false

    print("🔍 [Check] Memeriksa ketersediaan bahan...")

    for i = 1, 4 do
        local data = State.ForgeSlots[i]
        if data.Ore and data.Amount > 0 then
            local ownedAmount = Utilities.GetPlayerOreAmount(data.Ore)
            local currentNeed = data.Amount
            if finalRecipe[data.Ore] then currentNeed = currentNeed + finalRecipe[data.Ore] end

            if ownedAmount < currentNeed then
                WindUI:Notify({
                    Title = "Missing Materials!",
                    Content = "Need " .. currentNeed .. " " .. data.Ore .. ", but you have " .. ownedAmount,
                    Duration = 4
                })
                warn("❌ Kurang bahan: " .. data.Ore .. " (Punya: " .. ownedAmount .. ", Butuh: " .. currentNeed .. ")")
                missingMaterials = true
                break
            end

            if finalRecipe[data.Ore] then
                finalRecipe[data.Ore] = finalRecipe[data.Ore] + data.Amount
            else
                finalRecipe[data.Ore] = data.Amount
            end
            totalMaterials = totalMaterials + data.Amount
        end
    end

    if missingMaterials or totalMaterials == 0 then
        if totalMaterials == 0 then
            WindUI:Notify({ Title = "Forge Failed", Content = "Please select materials first!", Duration = 3 })
        end
        return
    end

    local KnitServices = ReplicatedStorage.Shared.Packages.Knit.Services
    local ForgeService = KnitServices.ForgeService.RF.StartForge
    local ChangeSequence = KnitServices.ForgeService.RF.ChangeSequence
    local ForgeModel = Workspace.Proximity.Forge

    local function GetTime() return Workspace:GetServerTimeNow() end

    print("🔨 [Auto Forge] Starting...")
    WindUI:Notify({ Title = "Forge", Content = "Starting process...", Duration = 2 })

    ForgeService:InvokeServer(ForgeModel)
    task.wait(0.5)

    local meltSuccess, meltResult = pcall(function()
        return ChangeSequence:InvokeServer("Melt", {
            FastForge = false,
            ItemType = State.ForgeItemType,
            Ores = finalRecipe
        })
    end)

    if not meltSuccess or not meltResult then
        warn("❌ Server menolak Melt! Kemungkinan bug inventory atau cooldown.")
        WindUI:Notify({ Title = "Forge Error", Content = "Server rejected the recipe!", Duration = 4 })
        pcall(function() KnitServices.ForgeService.RF.EndForge:InvokeServer() end)
        return
    end

    print("✅ [Melt] Diterima server. Lanjut...")
    task.wait(4)

    ChangeSequence:InvokeServer("Pour", { ClientTime = GetTime(), InContact = true })
    print("✅ [Pour] Diterima server. Lanjut...")
    task.wait(2)

    for i = 1, 10 do
        ChangeSequence:InvokeServer("Hammer", { ClientTime = GetTime() })
        task.wait(0.35)
    end
    print("✅ [Hammer] Diterima server. Lanjut...")
    task.wait(1)

    task.spawn(function()
        pcall(function()
            ChangeSequence:InvokeServer("Water", { ClientTime = GetTime() })
        end)
    end)
    task.wait(4)

    local claimSuccess = pcall(function()
        ChangeSequence:InvokeServer("Showcase", {})
    end)

    if claimSuccess then
        WindUI:Notify({ Title = "Success", Content = "Item Forged Successfully!", Duration = 3 })
        print("✅ Forge Selesai!")
        task.wait(1)
    end
    task.wait(1)
end

-- ============================================
-- DESYNC SYSTEM
-- ============================================
local Desync = {}

function Desync.SetReplicationFlag(isDesync)
    if not setfflag then
        WindUI:Notify({
            Title = "Error",
            Content = "Executor tidak support 'setfflag'",
            Duration = 3
        })
        return false
    end

    local flagName = "NextGenReplicatorEnabledWrite4"

    if isDesync then
        local success, err = pcall(function()
            setfflag(flagName, "true")
        end)

        if success then
            print("✅ FFlag diaktifkan:", flagName)
            return true
        else
            warn("❌ Gagal mengaktifkan FFlag:", err)
            return false
        end
    else
        local success, err = pcall(function()
            setfflag(flagName, "false")
        end)

        if success then
            print("✅ FFlag dimatikan:", flagName)
            return true
        else
            warn("❌ Gagal mematikan FFlag:", err)
            return false
        end
    end
end

function Desync.Activate()
    local Player = Services.Players.LocalPlayer
    local tx = tonumber(State.DesyncX) or 0
    local ty = tonumber(State.DesyncY) or 0
    local tz = tonumber(State.DesyncZ) or 0
    local targetPos = Vector3.new(tx, ty, tz)

    WindUI:Notify({ Title = "Desync", Content = "Memulai proses desync...", Duration = 2 })

    -- 1. Picu Respawn (Kode temuan)
    print("Memicu Respawn...")
    local success1, err1 = pcall(function()
        replicatesignal(Player.ConnectDiedSignalBackend)
    end)

    if not success1 then
        warn("Gagal memicu ConnectDiedSignalBackend:", err1)
    end

    task.wait(0.1)

    local success2, err2 = pcall(function()
        replicatesignal(Player.Kill)
    end)

    if not success2 then
        warn("Gagal memicu Kill:", err2)
    end


    print("Menunggu 4 detik...")
    task.wait(4)

    print("Mengaktifkan FFlag...")
    setfflag("NextGenReplicatorEnabledWrite4", "true")


    task.wait(1.5)
    local char = Player.Character
    if char and targetPos ~= Vector3.new(0, 0, 0) then
        WindUI:Notify({ Title = "Desync", Content = "Bergerak ke posisi target...", Duration = 1 })
        Movement.TweenToPos(targetPos)
    end
    WindUI:Notify({
        Title = "Desync Active",
        Content = "Server frozen! Karakter menjadi ghost.",
        Duration = 3
    })
    task.wait(3)
    -- Visual Indicator
    if char then
        local hl = Instance.new("Highlight")
        hl.Name = "DesyncGlow"
        hl.FillColor = Color3.fromRGB(0, 255, 255)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.Parent = char
    end
end

function Desync.Deactivate()
    setfflag("NextGenReplicatorEnabledWrite4", "false")
    WindUI:Notify({ Title = "Desync Off", Content = "Back to normal.", Duration = 2 })

    local char = LocalPlayer.Character
    if char and char:FindFirstChild("DesyncGlow") then
        char.DesyncGlow:Destroy()
    end
end

function Desync.RefreshForNewPlayer()
    if not State.DesyncActive then return end

    print("[DESYNC] New player joined! Refreshing ghost position...")
    WindUI:Notify({ Title = "New Player", Content = "Refreshing Ghost Position...", Duration = 2 })

    local wasMining = State.AutoMine
    local wasFarming = State.AutoFarmMobs
    local wasSellingOre = State.AutoSellOreActive
    local wasSellingEquip = State.AutoSellEquipActive

    State.AutoMine = false
    State.AutoFarmMobs = false
    Desync.Deactivate()
    task.wait(2)
    Desync.Activate()
    print("[DESYNC] Ghost refreshed! Resuming activities...")
    State.AutoMine = wasMining
    State.AutoFarmMobs = wasFarming
end

-- ============================================
-- RUN SERVICE LOOPS
-- ============================================
Services.RunService.Stepped:Connect(function()
    if State.NoClip then
        local char = LocalPlayer.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if LocalPlayer.Character.Humanoid.WalkSpeed ~= State.WalkSpeedVal then
                LocalPlayer.Character.Humanoid.WalkSpeed = State.WalkSpeedVal
            end
        end
    end
end)

-- ============================================
-- PLAYER JOIN LISTENER
-- ============================================
Services.Players.PlayerAdded:Connect(function(player)
    if State.LoopOnJoin and State.DesyncActive then
        task.spawn(Desync.RefreshForNewPlayer)
    end
end)

-- ============================================
-- UI CREATION
-- ============================================
local Window = WindUI:CreateWindow(Config.Window)
Window:EditOpenButton(Config.OpenButton)

State.CurrentWorld = Movement.DetectCurrentWorld()

-- Create tabs
local MainSection = Window:Section({ Title = "Main", Icon = "swords" })
local SetupTab = MainSection:Tab({ Title = "Setup", Icon = "wrench" })
local AutoMineTab = MainSection:Tab({ Title = "Auto Mine", Icon = "pickaxe" })
local AutoFightTab = MainSection:Tab({ Title = "Auto Fight", Icon = "swords" })
local DesyncTab = MainSection:Tab({ Title = "Desync", Icon = "ghost" })
local ForgeTab = Window:Tab({ Title = "Forge", Icon = "hammer" })
local ShopSection = Window:Section({ Title = "Shop & Sell", Icon = "shopping-cart" })
local AutoSellOreTab = ShopSection:Tab({ Title = "Auto Sell Ore", Icon = "dollar-sign" })
local AutoSellEquipTab = ShopSection:Tab({ Title = "Auto Sell Equipment", Icon = "armor" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local SettingTab = Window:Tab({ Title = "Settings", Icon = "settings" })

-- Setup Tab
SetupTab:Slider({
    Title = "Tween Speed",
    Desc = "Movement Speed (Auto Mine & Fight)",
    Value = { Min = 10, Max = 300, Default = 50 },
    Step = 5,
    Callback = function(Value) State.TweenSpeed = Value end
})

SetupTab:Slider({
    Title = "Height Offset (Y)",
    Desc = "Height above target (Mob/Rock)",
    Value = { Min = -10, Max = 20, Default = 5 },
    Step = 0.5,
    Callback = function(Value) State.GlobalHeight = Value end
})

SetupTab:Slider({
    Title = "Distance Offset (Z)",
    Desc = "Distance offset from target center",
    Value = { Min = -10, Max = 20, Default = 0 },
    Step = 0.5,
    Callback = function(Value) State.GlobalDistance = Value end
})

-- Auto Fight Tab
AutoFightTab:Dropdown({
    Title = "Select World / Region",
    Values = {
        "Island 1: Stonewake",
        "Island 2: Forgotten",
        "Island 3: Frostspire",
        "[DETECTED IN SERVER]"
    },
    Value = State.CurrentWorld,
    Desc = "Detected: " .. State.CurrentWorld,
    Callback = function(Value) State.CurrentWorld = Value end
})

local MobDropdown = AutoFightTab:Dropdown({
    Title = "Select Target Mobs",
    Values = Utilities.GetMobOptions(),
    Multi = true,
    AllowNone = true,
    Value = {},
    Callback = function(Value) State.SelectedMobs = Value end
})

AutoFightTab:Toggle({
    Title = "Auto Farm Mobs",
    Value = false,
    Callback = function(Value)
        State.AutoFarmMobs = Value
        if not Value then
            Utilities.SetAnchor(false)
            WindUI:Notify({ Title = "Auto Farm", Content = "Stopped.", Duration = 1 })
        end

        if Value then
            task.spawn(function()
                while State.AutoFarmMobs do
                    local targetPart = Farming.FindNearestMob()
                    if targetPart then
                        local mobPos = targetPart.Position
                        local targetPos = mobPos + Vector3.new(0, State.GlobalHeight, State.GlobalDistance)
                        local finalCFrame = CFrame.lookAt(targetPos, mobPos)

                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local dist = (hrp.Position - targetPos).Magnitude
                            if dist > 8 then
                                Utilities.SetAnchor(false)
                                Movement.TweenTo(finalCFrame)
                            else
                                Utilities.SetAnchor(true)
                                hrp.CFrame = hrp.CFrame:Lerp(finalCFrame, 0.5)
                            end

                            local isReady = Utilities.EquipToolByName(State.TargetWeaponName)
                            if isReady then
                                pcall(function()
                                    local args = { State.TargetWeaponName }
                                    Services.ReplicatedStorage.Shared.Packages.Knit.Services.ToolService.RF
                                        .ToolActivated:InvokeServer(unpack(args))
                                end)
                            end
                        end
                    else
                        Utilities.SetAnchor(false)
                    end
                    task.wait()
                end
                Utilities.SetAnchor(false)
            end)
        end
    end
})
-- ============================================
-- AUTO MINE TAB (FINAL)
-- ============================================

AutoMineTab:Dropdown({
    Title = "Select Mining Area",
    Values = Utilities.GetAreaList(),
    Multi = true,
    Value = {},
    AllowNone = true,
    Callback = function(Value) State.SelectedAreas = Value end
})

AutoMineTab:Button({
    Title = "Refresh Area List",
    Callback = function()
        WindUI:Notify({ Title = "Success", Content = "Area list updated!", Duration = 1 })
    end
})

-- SECTION PRIORITAS
AutoMineTab:Section({ Title = "Target Priority System" })

AutoMineTab:Dropdown({
    Title = "1st Priority (High)",
    Values = Database.Rocks,
    Multi = true,
    Value = {},
    Desc = "Bot will search these FIRST.",
    Callback = function(Value) State.Priority1 = Value end
})

AutoMineTab:Dropdown({
    Title = "2nd Priority (Medium)",
    Values = Database.Rocks,
    Multi = true,
    Value = {},
    Desc = "Search these if Prio 1 not found.",
    Callback = function(Value) State.Priority2 = Value end
})

AutoMineTab:Dropdown({
    Title = "3rd Priority (Low)",
    Values = Database.Rocks,
    Multi = true,
    Value = {},
    Desc = "Search these if Prio 1 & 2 not found.",
    Callback = function(Value) State.Priority3 = Value end
})

AutoMineTab:Toggle({
    Title = "Mine Others (Fallback)",
    Desc = "If no Priority rocks found, mine anything?",
    Value = false,
    Callback = function(Value) State.MineOthers = Value end
})

AutoMineTab:Section({ Title = "Smart Filters & Logic" })

AutoMineTab:Toggle({
    Title = "Avoid Stealing (Anti-KS)",
    Desc = "Skip rock if someone else hit it first",
    Value = false,
    Callback = function(Value) State.AvoidStealing = Value end
})

AutoMineTab:Toggle({
    Title = "Enable Smart Mine",
    Desc = "Read ore content inside rock",
    Value = false,
    Callback = function(Value) State.SmartMine = Value end
})

AutoMineTab:Dropdown({
    Title = "Apply Filter To Rocks...",
    Values = Database.Rocks,
    Multi = true,
    Value = {},
    Desc = "ONLY check ore content for THESE rocks. Others are auto-mined.",
    Callback = function(Value) State.FilterSpecificRocks = Value end
})

AutoMineTab:Dropdown({
    Title = "Keep Selected Ores",
    Values = Database.Ores,
    Multi = true,
    Value = {},
    Desc = "If filter applies, only keep these.",
    Callback = function(Value) State.KeepOres = Value end
})

AutoMineTab:Toggle({
    Title = "Auto Mine",
    Desc = "Start Mining Loop",
    Value = false,
    Callback = function(Value)
        State.AutoMine = Value
        if not Value then
            Utilities.SetAnchor(false)
            State.IgnoredRocks = {}
            WindUI:Notify({ Title = "Auto Mine", Content = "Stopped.", Duration = 1 })
        end

        if Value then
            task.spawn(function()
                while State.AutoMine do
                    local targetCFrame, rockModel = Farming.FindNearestRockInSelectedAreas()

                    if targetCFrame and rockModel then
                        local rockPos = targetCFrame.Position
                        local targetPos = rockPos + Vector3.new(0, State.GlobalHeight, State.GlobalDistance)
                        local finalCFrame = CFrame.lookAt(targetPos, rockPos)

                        local char = LocalPlayer.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        local hum = char and char:FindFirstChild("Humanoid")

                        if hrp and hum and hum.Health > 0 then
                            local dist = (hrp.Position - targetPos).Magnitude
                            if dist > 6 then
                                Utilities.SetAnchor(false)
                                Movement.TweenTo(finalCFrame)
                            else
                                hrp.CFrame = finalCFrame
                                Utilities.SetAnchor(true)

                                -- =============================================
                                -- LOGIKA MINING
                                -- =============================================
                                local shouldSkip = false
                                Utilities.EquipToolByName(State.TargetMineName)

                                while rockModel and rockModel.Parent and State.AutoMine do
                                    local currChar = LocalPlayer.Character
                                    local currHrp = currChar and currChar:FindFirstChild("HumanoidRootPart")
                                    local currHum = currChar and currChar:FindFirstChild("Humanoid")

                                    if not currHrp or not currHum or currHum.Health <= 0 then
                                        break
                                    end

                                    local currentDist = (currHrp.Position - rockPos).Magnitude

                                    if currentDist > 15 then
                                        Utilities.SetAnchor(false)
                                        break
                                    end

                                    local hp = 0
                                    local hpAttr = rockModel:GetAttribute("Health")
                                    if hpAttr then hp = hpAttr end
                                    local hpVal = rockModel:FindFirstChild("Health")
                                    if hpVal and hpVal:IsA("ValueBase") then hp = hpVal.Value end
                                    if hp <= 0 then break end

                                    if State.AvoidStealing then
                                        local lastHit = rockModel:GetAttribute("LastHitPlayer")
                                        if lastHit and lastHit ~= LocalPlayer.Name and lastHit ~= "" then
                                            shouldSkip = true
                                            break
                                        end
                                    end

                                    if State.SmartMine then
                                        local isRestrictedRock = table.find(State.FilterSpecificRocks, rockModel.Name)
                                        if isRestrictedRock then
                                            local scanResult = Farming.GetOreInRock(rockModel)
                                            if scanResult and scanResult ~= "Unknown Ore" then
                                                if #State.KeepOres > 0 and not table.find(State.KeepOres, scanResult) then
                                                    print("❌ [Filter] Skipping " ..
                                                        rockModel.Name .. " contains " .. scanResult)
                                                    shouldSkip = true
                                                    break
                                                else
                                                    if not rockModel:FindFirstChild("SmartMineESP") then
                                                        Farming.ShowOreESP(rockModel, scanResult)
                                                    end
                                                end
                                            end
                                        end
                                    end

                                    -- Hit Action
                                    pcall(function()
                                        local args = { State.TargetMineName }
                                        Services.ReplicatedStorage.Shared.Packages.Knit.Services.ToolService.RF
                                            .ToolActivated:InvokeServer(unpack(args))
                                    end)

                                    task.wait(0.1)
                                end

                                if shouldSkip then
                                    State.IgnoredRocks[rockModel] = true
                                    Utilities.SetAnchor(false)
                                    task.wait(0.3)
                                end
                            end
                        end
                    else
                        Utilities.SetAnchor(false)
                        if next(State.IgnoredRocks) ~= nil then
                            for model, _ in pairs(State.IgnoredRocks) do
                                if not model.Parent then State.IgnoredRocks[model] = nil end
                            end
                        end
                    end
                    task.wait(0.1)
                end
                Utilities.SetAnchor(false)
                State.IgnoredRocks = {}
            end)
        end
    end
})
-- Auto Sell Ore Tab
AutoSellOreTab:Button({
    Title = "Initialize Merchant",
    Desc = "Walk & Talk to Greedy Cey (Once)",
    Callback = function()
        task.spawn(function()
            local shop = Services.Workspace:FindFirstChild("Shops") and
                Services.Workspace.Shops:FindFirstChild("Ore Seller")
            local npc = Services.Workspace:FindFirstChild("Proximity") and
                Services.Workspace.Proximity:FindFirstChild("Greedy Cey")

            if shop and npc then
                Utilities.SetAnchor(false)
                WindUI:Notify({ Title = "Shop", Content = "Walking to Merchant...", Duration = 1 })

                local targetPos = shop.WorldPivot * CFrame.new(0, 0, 5)
                local finalCFrame = CFrame.lookAt(targetPos.Position, shop.WorldPivot.Position)
                Movement.TweenTo(finalCFrame)

                task.wait(0.5)
                pcall(function()
                    local args = { npc }
                    Services.ReplicatedStorage.Shared.Packages.Knit.Services.ProximityService.RF.Dialogue
                        :InvokeServer(unpack(args))
                end)
                WindUI:Notify({ Title = "Shop", Content = "Dialog Opened! Remote Sell Ready.", Duration = 3 })
            else
                WindUI:Notify({ Title = "Error", Content = "Merchant not found!", Duration = 2 })
            end
        end)
    end
})

AutoSellOreTab:Section({ Title = "Bulk Selling" })
AutoSellOreTab:Dropdown({
    Title = "Select Items to Sell",
    Values = Database.Ores,
    Multi = true,
    Value = {},
    Desc = "Select ores/stones to sell",
    Callback = function(Value) State.SelectedSellItems = Value end
})

AutoSellOreTab:Toggle({
    Title = "Auto Sell Selected",
    Desc = "Loop sell selected items",
    Value = false,
    Callback = function(Value)
        State.AutoSell = Value
        if Value then
            task.spawn(function()
                while State.AutoSell do
                    local itemsToSell = State.SelectedSellItems
                    if #itemsToSell > 0 then
                        local basketContent = {}
                        for _, itemName in pairs(itemsToSell) do
                            basketContent[itemName] = State.SellAmount
                        end

                        pcall(function()
                            local args = {
                                [1] = "SellConfirm",
                                [2] = { ["Basket"] = basketContent }
                            }
                            Services.ReplicatedStorage.Shared.Packages.Knit.Services.DialogueService.RF
                                .RunCommand:InvokeServer(unpack(args))
                        end)
                    end
                    task.wait(1.5)
                end
            end)
        end
    end
})

AutoSellOreTab:Dropdown({
    Title = "Select Rarity to Sell",
    Values = Utilities.GetAllRarities(),
    Multi = true,
    Value = {},
    Desc = "Choose ore rarities to sell",
    Callback = function(Value)
        State.SelectedRarityToSell = Value
        local finalOreList = {}

        for _, rarity in pairs(Value) do
            local ores = Utilities.GetOresByRarity(rarity)
            for _, oreName in pairs(ores) do
                table.insert(finalOreList, oreName)
            end
        end

        State.RarityOreSelection = finalOreList

        WindUI:Notify({
            Title = "Rarity Filter",
            Content = "Selected " .. #Value .. " rarities (" .. #finalOreList .. " items)",
            Duration = 2
        })
    end
})

AutoSellOreTab:Toggle({
    Title = "Auto Sell by Rarity",
    Desc = "Main selling loop with equipment helper",
    Value = false,
    Callback = function(Value)
        State.AutoSellOreActive = Value
        if not Value then
            WindUI:Notify({ Title = "Auto Sell Ore", Content = "Stopped.", Duration = 1 })
            return
        end

        task.spawn(function()
            local shop = Services.Workspace:FindFirstChild("Shops") and
                Services.Workspace.Shops:FindFirstChild("Ore Seller")
            local npc = Services.Workspace:FindFirstChild("Proximity") and
                Services.Workspace.Proximity:FindFirstChild("Greedy Cey")

            if not shop or not npc then
                warn("❌ Ore Merchant not found!")
                State.AutoSellOreActive = false
                return
            end

            State.OreNPCReference = npc

            local targetPos = shop.WorldPivot * CFrame.new(0, 0, 5)
            local finalCFrame = CFrame.lookAt(targetPos.Position, shop.WorldPivot.Position)
            Utilities.SetAnchor(false)
            Movement.TweenTo(finalCFrame)

            task.wait(0.5)

            local initSuccess = pcall(function()
                local args = { npc }
                Services.ReplicatedStorage.Shared.Packages.Knit.Services.ProximityService.RF.Dialogue
                    :InvokeServer(unpack(args))
            end)

            if not initSuccess then
                warn("❌ Failed to open Ore Merchant dialog!")
                State.AutoSellOreActive = false
                return
            end

            State.CurrentMerchantInit = "Ore"
            State.LastOreDialogTime = tick()
            task.wait(1)

            while State.AutoSellOreActive do
                -- ==========================================
                -- BAGIAN LOGIKA JUAL EQUIPMENT (TIDAK BERUBAH)
                -- ==========================================
                if State.AutoSellEquipActive then
                    print("\n[AUTO SELL] Checking for equipment to sell...")
                    local hasEquipToSell = false
                    local equipsToProcess = {}

                    for categoryName, config in pairs(State.CategoryConfig) do
                        if config.Auto and #config.Items > 0 then
                            local targetNames = config.Items
                            local guidsToSell = Utilities.GetEquipmentsToSell(targetNames)

                            if #guidsToSell > 0 then
                                hasEquipToSell = true
                                table.insert(equipsToProcess, {
                                    category = categoryName,
                                    guids = guidsToSell
                                })
                            end
                        end
                    end

                    if hasEquipToSell then
                        print("[AUTO SELL] Found equipment to sell! Switching to Equipment Merchant...")
                        local equipNpc = Services.Workspace:FindFirstChild("Proximity") and
                            Services.Workspace.Proximity:FindFirstChild("Marbles")

                        if equipNpc then
                            local npcPos = equipNpc:GetPivot()
                            local targetPos = npcPos * CFrame.new(0, 0, 5)
                            Utilities.SetAnchor(false)
                            Movement.TweenTo(CFrame.lookAt(targetPos.Position, npcPos.Position))

                            task.wait(0.5)
                            local equipDialogSuccess = pcall(function()
                                local args = { equipNpc }
                                Services.ReplicatedStorage.Shared.Packages.Knit.Services.ProximityService.RF
                                    .Dialogue:InvokeServer(unpack(args))
                            end)

                            if equipDialogSuccess then
                                print("✅ [AUTO SELL] Equipment Merchant dialog opened!")
                                task.wait(0.5)

                                for _, equipData in ipairs(equipsToProcess) do
                                    local basket = {}
                                    for _, guid in pairs(equipData.guids) do
                                        basket[guid] = true
                                    end

                                    print("[AUTO SELL] Selling " ..
                                        #equipData.guids .. " items from " .. equipData.category)

                                    local sellSuccess = pcall(function()
                                        local args = { "SellConfirm", { ["Basket"] = basket } }
                                        Services.ReplicatedStorage.Shared.Packages.Knit.Services
                                            .DialogueService.RF.RunCommand:InvokeServer(unpack(args))
                                    end)

                                    if sellSuccess then
                                        print("✅ [AUTO SELL] Equipment sold!")
                                        WindUI:Notify({
                                            Title = "Equipment Sold",
                                            Content = "Sold " .. #equipData.guids .. " items",
                                            Duration = 0.8
                                        })
                                    else
                                        warn("❌ Equipment sell failed")
                                    end
                                    task.wait(1)
                                end

                                print("[AUTO SELL] Equipment done! Switching back to Ore Merchant...")
                                local targetPos = shop.WorldPivot * CFrame.new(0, 0, 5)
                                local finalCFrame = CFrame.lookAt(targetPos.Position, shop.WorldPivot.Position)
                                Utilities.SetAnchor(false)
                                Movement.TweenTo(finalCFrame)

                                task.wait(0.5)
                                local oreReInitSuccess = pcall(function()
                                    local args = { State.OreNPCReference }
                                    Services.ReplicatedStorage.Shared.Packages.Knit.Services.ProximityService
                                        .RF.Dialogue:InvokeServer(unpack(args))
                                end)

                                if oreReInitSuccess then
                                    print("✅ [AUTO SELL] Ore Merchant dialog re-opened!")
                                    State.LastOreDialogTime = tick()
                                else
                                    warn("❌ Failed to re-init Ore Merchant dialog")
                                end
                            else
                                warn("❌ Failed to open Equipment Merchant dialog")
                            end
                        else
                            print("⚠️ Equipment NPC (Marbles) not found")
                        end
                    end
                end

                -- ==========================================
                -- BAGIAN LOGIKA JUAL ORE (DIPERBARUI)
                -- ==========================================
                local selectedRarities = State.SelectedRarityToSell
                local oresToSell = State.RarityOreSelection

                if #oresToSell > 0 then
                    local basket = {}
                    for _, oreName in pairs(oresToSell) do
                        basket[oreName] = State.SellAmount
                    end

                    -- PERBAIKAN: Handle display jika selectedRarities adalah table (Multi) atau string (Single)
                    local rarityDisplay = ""
                    if type(selectedRarities) == "table" then
                        rarityDisplay = table.concat(selectedRarities, ", ")
                    else
                        rarityDisplay = tostring(selectedRarities)
                    end

                    local success = pcall(function()
                        local args = {
                            [1] = "SellConfirm",
                            [2] = { ["Basket"] = basket }
                        }
                        Services.ReplicatedStorage.Shared.Packages.Knit.Services.DialogueService.RF
                            .RunCommand:InvokeServer(unpack(args))
                    end)

                    if success then
                        WindUI:Notify({
                            Title = "Ore Sold",
                            Content = "Sold " .. #oresToSell .. " types",
                            Duration = 0.8
                        })
                    else
                        warn("❌ Ore sell failed")
                        print("[AUTO SELL ORE] Re-initializing Ore Merchant dialog...")
                        local reInitSuccess = pcall(function()
                            local args = { State.OreNPCReference }
                            Services.ReplicatedStorage.Shared.Packages.Knit.Services.ProximityService.RF
                                .Dialogue:InvokeServer(unpack(args))
                        end)

                        if reInitSuccess then
                            print("✅ [AUTO SELL ORE] Dialog re-initialized")
                            State.LastOreDialogTime = tick()
                        else
                            warn("❌ Failed to re-init dialog, stopping")
                            break
                        end
                    end
                else
                    print("⚠️ No ores selected. Please select Rarities in the Dropdown.")
                end
                task.wait(2.5)
            end
            print("[AUTO SELL ORE] Main loop stopped")
            State.CurrentMerchantInit = nil
        end)
    end
})
-- Auto Sell Equipment Tab
AutoSellEquipTab:Button({
    Title = "Init: Weapon Merchant",
    Desc = "Walk & Talk to Marbles (REQUIRED for Weapons)",
    Callback = function()
        task.spawn(function()
            local npc = Services.Workspace:FindFirstChild("Proximity") and
                Services.Workspace.Proximity:FindFirstChild("Marbles")
            if npc then
                Utilities.SetAnchor(false)
                WindUI:Notify({ Title = "Weapon Shop", Content = "Walking...", Duration = 1 })

                local npcPos = npc:GetPivot()
                local targetPos = npcPos * CFrame.new(0, 0, 5)
                Movement.TweenTo(CFrame.lookAt(targetPos.Position, npcPos.Position))

                task.wait(0.5)
                pcall(function()
                    local args = { [1] = npc }
                    Services.ReplicatedStorage.Shared.Packages.Knit.Services.ProximityService.RF.Dialogue
                        :InvokeServer(unpack(args))
                end)
                WindUI:Notify({ Title = "Weapon Shop", Content = "Ready!", Duration = 2 })
            else
                WindUI:Notify({ Title = "Error", Content = "Marbles NPC not found!", Duration = 2 })
            end
        end)
    end
})

local sortedCats = {}
for cat in pairs(Database.Equipment.Processed) do table.insert(sortedCats, cat) end
table.sort(sortedCats)

for _, categoryName in ipairs(sortedCats) do
    local items = Database.Equipment.Processed[categoryName]
    local defaultValues = {}

    if categoryName == "Medium Armor" or categoryName == "Light Armor" then
        defaultValues = items
    end

    State.CategoryConfig[categoryName] = { Items = defaultValues, Auto = false }

    local section = AutoSellEquipTab:Section({
        Title = categoryName,
        Box = true,
        BoxBorder = true,
        Opened = false
    })

    section:Dropdown({
        Title = "Items in " .. categoryName,
        Values = items,
        Multi = true,
        Value = defaultValues,
        Callback = function(Value) State.CategoryConfig[categoryName].Items = Value end
    })

    section:Toggle({
        Title = "Auto Sell " .. categoryName,
        Callback = function(Value)
            State.CategoryConfig[categoryName].Auto = Value
            local anyEquipActive = false
            for _, config in pairs(State.CategoryConfig) do
                if config.Auto then
                    anyEquipActive = true
                    break
                end
            end
            State.AutoSellEquipActive = anyEquipActive

            if Value then
                print("[AUTO SELL EQUIP] Enabled for category: " .. categoryName)
                print("⚠️  [AUTO SELL EQUIP] Note: Equipment selling requires Auto Sell Ore to be ACTIVE!")

                if not State.AutoSellOreActive then
                    WindUI:Notify({
                        Title = "Info",
                        Content = "Enable Auto Sell Ore first for equipment selling to work",
                        Duration = 3
                    })
                end
            else
                print("[AUTO SELL EQUIP] Disabled for category: " .. categoryName)
            end
        end
    })
end

-- Player Tab
local SectionMove = PlayerTab:Section({ Title = "Movement" })
local SectionGroup1 = PlayerTab:Group({})

SectionGroup1:Toggle({
    Title = "Auto Run",
    Value = false,
    Callback = function(Value)
        State.AutoRun = Value
        if Value then
            WindUI:Notify({ Title = "Auto Run", Content = "Running enabled!", Duration = 1 })
        else
            WindUI:Notify({ Title = "Auto Run", Content = "Running disabled.", Duration = 1 })
        end
    end
})

SectionGroup1:Space()
SectionGroup1:Toggle({
    Title = "No Clip",
    Value = false,
    Callback = function(Value) State.NoClip = Value end
})

PlayerTab:Space()
PlayerTab:Slider({
    Title = "WalkSpeed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Step = 1,
    Callback = function(Value)
        State.WalkSpeedVal = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

PlayerTab:Slider({
    Title = "JumpPower",
    Value = { Min = 50, Max = 300, Default = 50 },
    Step = 1,
    Callback = function(Value)
        State.JumpPowerVal = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    end
})

local SectionVisual = PlayerTab:Section({ Title = "Visuals" })
PlayerTab:Toggle({
    Title = "ESP Player",
    Desc = "See players through walls (Highlight & Name)",
    Value = false,
    Callback = function(Value) ESP.Toggle(Value) end
})

local SectionPhysics = PlayerTab:Section({ Title = "Physics & Support" })
SectionPhysics:Toggle({
    Title = "Anti Gravity",
    Desc = "Keep Y position stable (Float)",
    Value = false,
    Callback = function(Value)
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if Value then
            if hrp then
                for _, v in pairs(hrp:GetChildren()) do
                    if v.Name == "WindUI_AntiGravity" then v:Destroy() end
                end

                local bv = Instance.new("BodyVelocity")
                bv.Name = "WindUI_AntiGravity"
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.MaxForce = Vector3.new(0, math.huge, 0)
                bv.P = 9000
                bv.Parent = hrp

                WindUI:Notify({ Title = "Anti Gravity", Content = "Enabled. You will not fall.", Duration = 2 })
            end
        else
            if hrp then
                for _, v in pairs(hrp:GetChildren()) do
                    if v.Name == "WindUI_AntiGravity" then v:Destroy() end
                end
            end
            WindUI:Notify({ Title = "Anti Gravity", Content = "Disabled.", Duration = 1 })
        end
    end
})

SectionPhysics:Toggle({
    Title = "Sky Platform",
    Desc = "Spawn glass floor under your feet",
    Value = false,
    Callback = function(Value)
        if Value then
            local plat = Instance.new("Part")
            plat.Name = "WindUI_SkyPlatform"
            plat.Size = Vector3.new(10, 1, 10)
            plat.Anchored = true
            plat.Transparency = 0.6
            plat.Material = Enum.Material.Glass
            plat.Color = Color3.fromRGB(0, 255, 255)
            plat.CanCollide = true
            plat.Parent = Services.Workspace

            if State.PlatformLoop then State.PlatformLoop:Disconnect() end

            State.PlatformLoop = Services.RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if char and hrp and plat.Parent then
                    plat.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 3.5, hrp.Position.Z)
                else
                    if State.PlatformLoop then State.PlatformLoop:Disconnect() end
                    if plat then plat:Destroy() end
                end
            end)

            WindUI:Notify({ Title = "Platform", Content = "Created.", Duration = 1 })
        else
            if State.PlatformLoop then State.PlatformLoop:Disconnect() end
            local p = Services.Workspace:FindFirstChild("WindUI_SkyPlatform")
            if p then p:Destroy() end
            WindUI:Notify({ Title = "Platform", Content = "Removed.", Duration = 1 })
        end
    end
})

-- Settings Tab
SettingTab:Keybind({
    Title = "Keybind",
    Desc = "Keybind to open ui",
    Value = "RightControl",
    Callback = function(v) Window:SetToggleKey(Enum.KeyCode[v]) end
})

SettingTab:Dropdown({
    Title = "Select Theme",
    Values = { "Plant", "Rose", "Dark" },
    Value = "Plant",
    Callback = function(option) WindUI:SetTheme(option) end
})

-- Forge Tab
local ConfigSection = ForgeTab:Section({ Title = "1. Configuration" })
ConfigSection:Dropdown({
    Title = "Target Item Type",
    Values = { "Weapon", "Armor" },
    Value = "Weapon",
    Callback = function(v) State.ForgeItemType = v end
})

local RecipeSection = ForgeTab:Section({ Title = "2. Recipe Mixer" })
for i = 1, 4 do
    RecipeSection:Dropdown({
        Title = "Select Ore",
        Values = Database.Ores,
        Multi = false,
        Value = nil,
        Desc = "Choose material for Slot " .. i,
        Callback = function(v) State.ForgeSlots[i].Ore = v end
    })

    RecipeSection:Slider({
        Title = "Amount",
        Desc = "Quantity for this slot",
        Value = { Min = 0, Max = 10, Default = 0 },
        Step = 1,
        Callback = function(v) State.ForgeSlots[i].Amount = v end
    })
end

local ActionSection = ForgeTab:Section({ Title = "3. Action" })
ActionSection:Button({
    Title = "START FORGE",
    Desc = "Make sure you are close to the Anvil!",
    Callback = function() task.spawn(Forge.Run) end
})

-- Desync Tab
local DesyncSection = DesyncTab:Section({ Title = "Coordinates Desync" })

local InputX = DesyncSection:Input({
    Title = "X",
    Value = State.DesyncX,
    Callback = function(Text) State.DesyncX = Text end
})

local InputY = DesyncSection:Input({
    Title = "Y",
    Value = State.DesyncY,
    Callback = function(Text) State.DesyncY = Text end
})

local InputZ = DesyncSection:Input({
    Title = "Z",
    Value = State.DesyncZ,
    Callback = function(Text) State.DesyncZ = Text end
})

DesyncSection:Button({
    Title = "Save Current Position",
    Desc = "Capture where you stand now",
    Callback = function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local pos = hrp.Position
            State.DesyncX = tostring(math.floor(pos.X))
            State.DesyncY = tostring(math.floor(pos.Y))
            State.DesyncZ = tostring(math.floor(pos.Z))

            InputX:Set(State.DesyncX)
            InputY:Set(State.DesyncY)
            InputZ:Set(State.DesyncZ)

            WindUI:Notify({ Title = "Saved", Content = "Position captured!", Duration = 1 })
        end
    end
})

DesyncSection:Space()
DesyncSection:Toggle({
    Title = "Enable Desync (FFlag)",
    Desc = "Tween -> Toggle Flag",
    Value = false,
    Callback = function(Value)
        State.DesyncActive = Value
        if Value then
            task.spawn(Desync.Activate)
        else
            task.spawn(Desync.Deactivate)
        end
    end
})

DesyncSection:Toggle({
    Title = "Loop When New Player Join",
    Desc = "Refresh ghost pos when someone joins",
    Value = false,
    Callback = function(Value) State.LoopOnJoin = Value end
})

-- ============================================
-- GLOBAL EXPORTS
-- ============================================
_G.TForge = {
    Config = Config,
    Database = Database,
    Services = Services,
    State = State,
    Utilities = Utilities,
    Movement = Movement,
    Farming = Farming,
    Merchant = Merchant,
    Forge = Forge,
    Desync = Desync
}

print("\n✅ [TForge] Script loaded successfully!")
print("📊 Modules: Config, Database, Utilities, Movement, Farming, Merchant, Forge, Desync")
print("🔧 Use _G.TForge to access all modules")
