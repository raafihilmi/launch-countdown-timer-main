local WindUI = loadstring(game:HttpGet("https://pastebin.com/raw/m8P8dLfd"))()


-- [[ MAIN WINDOW CREATIONS ]] --
local Window = WindUI:CreateWindow({
    Title = "TForge",
    Icon = "gamepad-2",
    Author = "JumantaraHub v19",
    Theme = "Plant",
    Folder = "UniversalScript_v19s"
})

Window:EditOpenButton({
    Title = "Open Menu",
    Icon = "menu",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true
})

-- [[ GLOBAL VARIABLES ]] --
-- [[ DATABASE MOBS ]] --
local MobDatabase = {
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
}
-- [[ DATABASE ORE LENGKAP (HASIL DUMP) ]] --
local OreList = {
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
}
-- [[ RARITY DATA (FROM ACTUAL GAME DUMP) ]] --
local OreRarityDatabaseAuto = {
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
}

-- [[ ROCK DATABASE (HASIL DUMP) ]] --
local RockList = {
    "Basalt Core", "Basalt Rock", "Basalt Vein", "Boulder",
    "Crimson Crystal", "Cyan Crystal", "Earth Crystal", "Floating Crystal",
    "Iceberg", "Icy Boulder", "Icy Pebble", "Icy Rock",
    "Large Ice Crystal", "Light Crystal", "Lucky Block",
    "Medium Ice Crystal", "Pebble", "Rock", "Small Ice Crystal",
    "Violet Crystal", "Volcanic Rock"
}
-- [[ DATABASE: EQUIPMENTS (RAW DUMP) ]] --
local RawEquipData = {
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
}


-- Default Variable
getgenv().CurrentWorld = ""
getgenv().AutoClick = false
getgenv().WalkSpeedVal = 16
getgenv().JumpPowerVal = 50
getgenv().NoClip = false
getgenv().ESPEnabled = false
getgenv().AutoRun = false
getgenv().AutoAttack = false
getgenv().AutoMine = false
getgenv().TargetWeaponName = "Weapon"
getgenv().TargetMineName = "Pickaxe"
getgenv().SelectedAreas = {}
getgenv().TweenSpeed = 50
getgenv().GlobalHeight = 5
getgenv().GlobalDistance = 0
getgenv().AutoFarmMobs = false
getgenv().SelectedMobs = {}
getgenv().SelectedSellItems = {} -- Menampung item yang dipilih
local SellAmount = 1
getgenv().AutoSell = false
getgenv().SelectedRocks = {}
getgenv().SelectedSellEquips = {}
getgenv().CategoryConfig = {}
getgenv().SelectedRarityToSell = "Common"
getgenv().AutoSellByRarity = false
getgenv().RarityOreSelection = {}
-- [[ MERCHANT STATE TRACKING ]] --
getgenv().MerchantInitInProgress = false
getgenv().LastMerchantInitTime = 0
getgenv().MerchantInitCooldown = 3
-- [[ QUEUE MANAGEMENT SYSTEM ]] --
getgenv().SellQueue = {} -- {type: "Ore" atau "Equipment", data: {...}}
getgenv().IsProcessingQueue = false
getgenv().CurrentMerchantDialog = nil
getgenv().AutoSellOreActive = false
getgenv().AutoSellEquipActive = false
getgenv().CurrentMerchantInit = nil -- "Ore" atau "Equipment"
getgenv().OreNPCReference = nil     -- Reference ke Ore NPC untuk re-init
getgenv().LastOreDialogTime = 0
getgenv().ForgeSlots = {
    [1] = { Ore = nil, Amount = 0 },
    [2] = { Ore = nil, Amount = 0 },
    [3] = { Ore = nil, Amount = 0 },
    [4] = { Ore = nil, Amount = 0 }
}
getgenv().ForgeItemType = "Weapon"
getgenv().DesyncX = "0"
getgenv().DesyncY = "0"
getgenv().DesyncZ = "0"
getgenv().DesyncActive = false
getgenv().LoopOnJoin = false

-- [[ SERVICES ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- [[ ESP FUNCTIONS ]] --
local espHolder = Instance.new("Folder", game.CoreGui)
espHolder.Name = "WindUI_ESP_Storage"

-- [[ LOGIC: MERGE CATEGORIES ]] --
local EquipmentDatabase = {}
local MergedCategories = {
    ["Light Armor"] = { "LightChestplate", "LightHelmet", "LightLeggings" },
    ["Medium Armor"] = { "MediumChestplate", "MediumHelmet", "MediumLeggings" },
}
for cat, items in pairs(RawEquipData) do
    local isMerged = false
    for _, subCats in pairs(MergedCategories) do
        if table.find(subCats, cat) then
            isMerged = true
            break
        end
    end
    if not isMerged then
        EquipmentDatabase[cat] = items
    end
end

-- 2. Masukkan kategori gabungan (Armor)
for newName, subCats in pairs(MergedCategories) do
    EquipmentDatabase[newName] = {}
    for _, oldCat in pairs(subCats) do
        if RawEquipData[oldCat] then
            for _, item in pairs(RawEquipData[oldCat]) do
                table.insert(EquipmentDatabase[newName], item)
            end
        end
    end
    table.sort(EquipmentDatabase[newName]) -- Urutkan abjad itemnya
end
-- [[ UTILITY: GET ORES BY RARITY ]] --
local function GetOresByRarity(rarity)
    local result = {}
    for oreName, orRarity in pairs(OreRarityDatabaseAuto) do
        if orRarity == rarity then
            table.insert(result, oreName)
        end
    end
    table.sort(result)
    return result
end

-- [[ UTILITY: GET ALL RARITIES ]] --
local function GetAllRarities()
    local rarities = {}
    for _, rarity in pairs(OreRarityDatabaseAuto) do
        if not table.find(rarities, rarity) then
            table.insert(rarities, rarity)
        end
    end
    table.sort(rarities)
    return rarities
end
-- [[ HELPER: Add to Queue ]] --
local function AddToSellQueue(queueItem)
    table.insert(getgenv().SellQueue, queueItem)
    print("[QUEUE] Added: " .. queueItem.type .. " | Queue size: " .. #getgenv().SellQueue)
end

-- [[ HELPER: Process Queue Sequential ]] --
local function ProcessSellQueue()
    if getgenv().IsProcessingQueue then
        print("[QUEUE] Already processing, skipping...")
        return
    end

    getgenv().IsProcessingQueue = true

    task.spawn(function()
        while #getgenv().SellQueue > 0 and (getgenv().AutoSellOreActive or getgenv().AutoSellEquipActive) do
            local queueItem = getgenv().SellQueue[1]

            print("\n[QUEUE] Processing: " .. queueItem.type)

            if queueItem.type == "Ore" then
                -- Proses Ore Sell
                local oresToSell = queueItem.data.ores
                local selectedRarity = queueItem.data.rarity
                local sellAmount = queueItem.data.amount

                if #oresToSell > 0 then
                    local basket = {}
                    for _, oreName in pairs(oresToSell) do
                        basket[oreName] = sellAmount
                    end

                    print("[QUEUE] Selling " .. #oresToSell .. " ore types (" .. selectedRarity .. ")")

                    local success, err = pcall(function()
                        local args = {
                            [1] = "SellConfirm",
                            [2] = { ["Basket"] = basket }
                        }
                        game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.DialogueService.RF
                            .RunCommand:InvokeServer(unpack(args))
                    end)

                    if success then
                        print("✅ [QUEUE] Ore sold successfully!")
                        WindUI:Notify({
                            Title = "Ore Sold",
                            Content = "Sold " .. #oresToSell .. " types",
                            Duration = 0.8
                        })
                    else
                        warn("❌ [QUEUE] Ore sell failed: " .. tostring(err))
                    end
                end
            elseif queueItem.type == "Equipment" then
                -- Proses Equipment Sell
                local categoryName = queueItem.data.category
                local targetNames = queueItem.data.items

                if #targetNames > 0 then
                    print("[QUEUE] Scanning " .. categoryName)

                    local guidsToSell = GetEquipmentsToSell(targetNames)

                    if #guidsToSell > 0 then
                        local basket = {}
                        for _, guid in pairs(guidsToSell) do
                            basket[guid] = true
                        end

                        print("[QUEUE] Selling " .. #guidsToSell .. " items from " .. categoryName)

                        local success, err = pcall(function()
                            local args = { "SellConfirm", { ["Basket"] = basket } }
                            game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.DialogueService
                                .RF.RunCommand:InvokeServer(unpack(args))
                        end)

                        if success then
                            print("✅ [QUEUE] Equipment sold successfully!")
                            WindUI:Notify({
                                Title = "Equipment Sold",
                                Content = "Sold " .. #guidsToSell .. " items",
                                Duration = 0.8
                            })
                        else
                            warn("❌ [QUEUE] Equipment sell failed: " .. tostring(err))
                        end
                    else
                        print("💤 [QUEUE] No items found in " .. categoryName)
                    end
                end
            end

            -- Hapus dari queue setelah diproses
            table.remove(getgenv().SellQueue, 1)

            task.wait(1) -- Delay kecil antara item
        end

        print("[QUEUE] Processing completed")
        getgenv().IsProcessingQueue = false
    end)
end
-- [[ GET INVENTORY ORES BY RARITY ]] --
local function GetInventoryOresByRarity(rarity)
    local ores = {}
    local Knit = require(game:GetService("ReplicatedStorage").Shared.Packages.Knit)

    local success, PlayerController = pcall(function()
        return Knit.GetController("PlayerController")
    end)

    if success and PlayerController and PlayerController.Replica then
        local Inventory = PlayerController.Replica.Data.Inventory

        for oreName, quantity in pairs(Inventory) do
            if type(quantity) == "number" and quantity > 0 then
                -- Cek apakah ore ini ada di database dan rarity cocok
                if OreRarityDatabaseAuto[oreName] and OreRarityDatabaseAuto[oreName] == rarity then
                    table.insert(ores, oreName)
                end
            end
        end
    end

    return ores
end
-- [[ ESP LOGIC ]] --
local function ClearESP()
    espHolder:ClearAllChildren()
end

local function CreateESP(player)
    if player == LocalPlayer then return end

    local function UpdateVisuals()
        if not getgenv().ESPEnabled then return end

        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- Highlight
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

            -- Text Tag
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
                        if not getgenv().ESPEnabled then
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

local function ToggleESP(state)
    getgenv().ESPEnabled = state
    if state then
        for _, p in pairs(Players:GetPlayers()) do
            CreateESP(p)
        end
        Players.PlayerAdded:Connect(function(p)
            CreateESP(p)
        end)
    else
        for _, p in pairs(Players:GetPlayers()) do
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

-- [[ NOCLIP FUNCTION ]] --
RunService.Stepped:Connect(function()
    if getgenv().NoClip then
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

-- [[ AUTO RUN LOGIC ]] --
local function DetectCurrentWorld()
    local rocks = workspace:FindFirstChild("Rocks")
    if rocks then
        for _, folder in pairs(rocks:GetChildren()) do
            local n = folder.Name
            if string.find(n, "Island3") then return "Island 3: Frostspire" end
            if string.find(n, "Island2") then return "Island 2: Forgotten" end
        end
    end
    return "Island 1: Stonewake" -- Default
end
getgenv().CurrentWorld = DetectCurrentWorld()

local function StartAutoRun()
    task.spawn(function()
        while getgenv().AutoRun do
            pcall(function()
                -- Menggunakan path remote yang Anda berikan
                ReplicatedStorage.Shared.Packages.Knit.Services.CharacterService.RF.Run:InvokeServer()
            end)
            task.wait(0.5) -- Loop setiap 0.5 detik untuk memastikan lari tetap aktif
        end
    end)
end

local function StopRunSequence()
    pcall(function()
        -- Menggunakan path remote yang Anda berikan untuk stop
        ReplicatedStorage.Shared.Packages.Knit.Services.CharacterService.RF.StopRun:InvokeServer()
    end)
end
local function EquipToolByName(targetName)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local backpack = LocalPlayer.Backpack

    if char and hum and hum.Health > 0 then
        -- 1. Cek apakah alat sudah dipegang?
        local toolInHand = char:FindFirstChild(targetName)
        if toolInHand then
            return true -- Tool sudah di tangan, SIAP.
        end

        -- 2. Jika tidak, cari di Backpack
        local toolInBag = backpack:FindFirstChild(targetName)
        if toolInBag then
            -- Opsional: Lepas alat lain dulu (Unequip) agar tidak bug
            hum:UnequipTools()

            -- Equip alat target
            hum:EquipTool(toolInBag)

            return true -- Berhasil equip
        end
    end

    return false -- Tool tidak ditemukan di tangan maupun backpack
end
-- Fungsi mengambil daftar nama Area dari Workspace.Rocks
local function GetAreaList()
    local list = {}
    local rocksFolder = workspace:FindFirstChild("Rocks")
    if rocksFolder then
        for _, folder in pairs(rocksFolder:GetChildren()) do
            table.insert(list, folder.Name)
        end
    end
    return list
end

-- Fungsi Tween (Gerak Halus)
local function TweenTo(targetCFrame)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local dist = (hrp.Position - targetCFrame.Position).Magnitude

        -- MENGGUNAKAN VARIABLE GLOBAL
        local speed = getgenv().TweenSpeed

        -- Mencegah error jika speed 0 atau nil
        if speed == nil or speed <= 0 then speed = 50 end

        local time = dist / speed

        local info = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local tween = TweenService:Create(hrp, info, { CFrame = targetCFrame })
        tween:Play()
        tween.Completed:Wait()
    end
end

-- [[ HELPER: TWEEN TO LOCATION ]] --
local function TweenToNPC(npcPos, distance)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end

    local targetPos = npcPos * CFrame.new(0, 0, distance)
    local finalCFrame = CFrame.lookAt(targetPos.Position, npcPos.Position)

    SetAnchor(false)
    TweenTo(finalCFrame)
    return true
end
-- [[ FUNCTION: INIT MERCHANT ORE ]] --
local function InitMerchantOre()
    print("\n[MERCHANT INIT] Starting Ore Merchant initialization...")

    return task.spawn(function()
        local success = false

        -- Cari Toko & NPC
        local shop = workspace:FindFirstChild("Shops") and workspace.Shops:FindFirstChild("Ore Seller")
        local npc = workspace:FindFirstChild("Proximity") and workspace.Proximity:FindFirstChild("Greedy Cey")

        if shop and npc then
            print("✅ [MERCHANT INIT] Found Ore Seller and Greedy Cey NPC")

            -- Tween ke Toko
            print("[MERCHANT INIT] Walking to merchant...")
            if TweenToNPC(shop.WorldPivot, 5) then
                task.wait(0.5)

                -- Buka Dialog
                print("[MERCHANT INIT] Opening dialogue...")
                local dialogSuccess, dialogErr = pcall(function()
                    local args = { npc }
                    game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.ProximityService.RF.Dialogue
                        :InvokeServer(unpack(args))
                end)

                if dialogSuccess then
                    print("✅ [MERCHANT INIT] Ore Merchant ready for selling!")
                    getgenv().CurrentMerchantInit = "Ore"
                    getgenv().LastMerchantInitTime = tick()
                    success = true
                else
                    warn("❌ [MERCHANT INIT] Failed to open dialogue: " .. tostring(dialogErr))
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
-- [[ FUNCTION: INIT MERCHANT EQUIPMENT ]] --
local function InitMerchantEquipment()
    print("\n[MERCHANT INIT] Starting Equipment Merchant initialization...")

    return task.spawn(function()
        local success = false

        local npc = workspace:FindFirstChild("Proximity") and workspace.Proximity:FindFirstChild("Marbles")

        if npc then
            print("✅ [MERCHANT INIT] Found Marbles NPC")

            -- Tween ke NPC Marbles
            print("[MERCHANT INIT] Walking to equipment merchant...")
            local npcPos = npc:GetPivot()
            if TweenToNPC(npcPos, 5) then
                task.wait(0.5)

                -- Force Dialogue
                print("[MERCHANT INIT] Opening dialogue...")
                local dialogSuccess, dialogErr = pcall(function()
                    local args = { npc }
                    game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.ProximityService.RF.Dialogue
                        :InvokeServer(unpack(args))
                end)

                if dialogSuccess then
                    print("✅ [MERCHANT INIT] Equipment Merchant ready for selling!")
                    getgenv().CurrentMerchantInit = "Equipment"
                    getgenv().LastMerchantInitTime = tick()
                    success = true
                else
                    warn("❌ [MERCHANT INIT] Failed to open dialogue: " .. tostring(dialogErr))
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
-- [[ FUNCTION: CHECK IF MERCHANT NEEDS RE-INIT ]] --
local function NeedsMerchantReinit(requiredMerchant)
    local timeSinceInit = tick() - getgenv().LastMerchantInitTime
    local needsReinit = getgenv().CurrentMerchantInit ~= requiredMerchant or
        timeSinceInit > getgenv().MerchantInitCooldown

    return needsReinit
end
-- [[ FUNCTION: AUTO INIT AND SELL ORES ]] --
local function AutoSellOresWithMerchant()
    task.spawn(function()
        while getgenv().AutoSellOreActive do
            -- 1. CHECK IF MERCHANT INIT NEEDED
            if NeedsMerchantReinit("Ore") then
                print("\n[AUTO SELL ORE] Merchant re-initialization required...")
                print("[AUTO SELL ORE] Current merchant: " .. tostring(getgenv().CurrentMerchantInit))
                print("[AUTO SELL ORE] Initializing Ore Merchant...")

                InitMerchantOre()
                task.wait(2) -- Wait for init to complete
            end

            -- 2. SELL ORES
            local selectedRarity = getgenv().SelectedRarityToSell
            local oresToSell = getgenv().RarityOreSelection

            if #oresToSell > 0 then
                local basket = {}
                for _, oreName in pairs(oresToSell) do
                    basket[oreName] = SellAmount
                end

                print("\n[AUTO SELL ORE] " .. string.rep("=", 60))
                print("Rarity: " .. selectedRarity)
                print("Selling " .. #oresToSell .. " ore types")
                print(string.rep("=", 60))

                local success, err = pcall(function()
                    local args = {
                        [1] = "SellConfirm",
                        [2] = {
                            ["Basket"] = basket
                        }
                    }
                    game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.DialogueService.RF
                        .RunCommand:InvokeServer(unpack(args))
                end)

                if success then
                    print("✅ [AUTO SELL ORE] Successfully sold " .. #oresToSell .. " ore types")
                    WindUI:Notify({
                        Title = "Ore Sold",
                        Content = "Sold " .. #oresToSell .. " types of " .. selectedRarity,
                        Duration = 1
                    })
                else
                    warn("❌ [AUTO SELL ORE] Failed: " .. tostring(err))
                    getgenv().CurrentMerchantInit = nil -- Reset merchant state on error
                end
            else
                print("⚠️ [AUTO SELL ORE] No ores selected")
            end

            task.wait(2.5) -- Wait before next sell cycle
        end

        print("[AUTO SELL ORE] Stopped")
    end)
end

-- [[ FUNCTION: AUTO INIT AND SELL EQUIPMENT ]] --
local function AutoSellEquipmentWithMerchant()
    task.spawn(function()
        while getgenv().AutoSellEquipActive do
            -- 1. CHECK IF MERCHANT INIT NEEDED
            if NeedsMerchantReinit("Equipment") then
                print("\n[AUTO SELL EQUIP] Merchant re-initialization required...")
                print("[AUTO SELL EQUIP] Current merchant: " .. tostring(getgenv().CurrentMerchantInit))
                print("[AUTO SELL EQUIP] Initializing Equipment Merchant...")

                InitMerchantEquipment()
                task.wait(2) -- Wait for init to complete
            end

            -- 2. SELL EQUIPMENT
            for categoryName, config in pairs(getgenv().CategoryConfig) do
                if config.Auto and #config.Items > 0 then
                    local targetNames = config.Items

                    print("\n[AUTO SELL EQUIP] Scanning category: " .. categoryName)

                    -- Find equipment to sell
                    local guidsToSell = GetEquipmentsToSell(targetNames)

                    if #guidsToSell > 0 then
                        local basket = {}
                        for _, guid in pairs(guidsToSell) do
                            basket[guid] = true
                        end

                        print("[AUTO SELL EQUIP] Found " .. #guidsToSell .. " items in " .. categoryName)

                        local success, err = pcall(function()
                            local args = { "SellConfirm", { ["Basket"] = basket } }
                            game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.DialogueService
                                .RF.RunCommand:InvokeServer(unpack(args))
                        end)

                        if success then
                            print("✅ [AUTO SELL EQUIP] Sold " .. #guidsToSell .. " from " .. categoryName)
                            WindUI:Notify({
                                Title = "Equipment Sold",
                                Content = "Sold " .. #guidsToSell .. " " .. categoryName,
                                Duration = 1
                            })
                        else
                            warn("❌ [AUTO SELL EQUIP] Failed: " .. tostring(err))
                            getgenv().CurrentMerchantInit = nil -- Reset on error
                            break                               -- Exit category loop and reinit
                        end
                    end

                    task.wait(1.5) -- Small delay between categories
                end
            end

            task.wait(2) -- Wait before next cycle
        end

        print("[AUTO SELL EQUIP] Stopped")
    end)
end

-- [[ SMART SELL COORDINATOR (Handle both active simultaneously) ]] --
local function SmartSellCoordinator()
    print("\n[SMART COORDINATOR] Starting intelligent sell system...")

    task.spawn(function()
        while getgenv().AutoSellOreActive or getgenv().AutoSellEquipActive do
            local bothActive = getgenv().AutoSellOreActive and getgenv().AutoSellEquipActive

            if bothActive then
                print("[SMART COORDINATOR] Both Ore and Equipment selling active - optimizing merchant usage...")

                -- Prioritize based on which one needs sell first
                -- This could be expanded with more sophisticated logic

                -- If current merchant is Ore, sell ore then switch
                if getgenv().CurrentMerchantInit == "Ore" and getgenv().AutoSellOreActive then
                    print("[SMART COORDINATOR] Selling ores first...")
                    local selectedRarity = getgenv().SelectedRarityToSell
                    local oresToSell = getgenv().RarityOreSelection

                    if #oresToSell > 0 then
                        local basket = {}
                        for _, oreName in pairs(oresToSell) do
                            basket[oreName] = SellAmount
                        end

                        pcall(function()
                            local args = {
                                [1] = "SellConfirm",
                                [2] = { ["Basket"] = basket }
                            }
                            game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.DialogueService.RF
                                .RunCommand:InvokeServer(unpack(args))
                        end)
                    end

                    task.wait(1.5)

                    -- Now switch to equipment
                    print("[SMART COORDINATOR] Switching to equipment merchant...")
                    getgenv().CurrentMerchantInit = nil
                    InitMerchantEquipment()
                    task.wait(2)

                    -- Sell equipment
                    for categoryName, config in pairs(getgenv().CategoryConfig) do
                        if config.Auto and #config.Items > 0 then
                            local guidsToSell = GetEquipmentsToSell(config.Items)
                            if #guidsToSell > 0 then
                                local basket = {}
                                for _, guid in pairs(guidsToSell) do
                                    basket[guid] = true
                                end

                                pcall(function()
                                    local args = { "SellConfirm", { ["Basket"] = basket } }
                                    game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.DialogueService
                                        .RF.RunCommand:InvokeServer(unpack(args))
                                end)
                            end
                            task.wait(1.5)
                        end
                    end

                    -- Reset for next cycle
                    getgenv().CurrentMerchantInit = nil
                    task.wait(1)
                else
                    -- Just wait a bit and let individual loops handle it
                    task.wait(2)
                end
            else
                task.wait(1)
            end
        end

        print("[SMART COORDINATOR] Stopped")
    end)
end

-- [[ UPDATE AUTO SELL ORE TOGGLE ]] --
-- Ganti callback untuk Auto Sell by Rarity toggle dengan ini:
local function UpdateAutoSellOreToggle(Value)
    getgenv().AutoSellOreActive = Value

    if not Value then
        WindUI:Notify({
            Title = "Auto Sell Ore",
            Content = "Stopped selling ore by rarity.",
            Duration = 1
        })
    else
        print("🟢 [AUTO SELL ORE] STARTED")
        if not getgenv().AutoSellEquipActive then
            -- Only run if equipment selling not active
            AutoSellOresWithMerchant()
        else
            print("[AUTO SELL ORE] Equipment selling also active - using smart coordinator")
            SmartSellCoordinator()
        end
    end
end

-- [[ UPDATE AUTO SELL EQUIPMENT TOGGLE ]] --
-- Ganti callback untuk Auto Sell Equipment toggles dengan ini:
local function UpdateAutoSellEquipmentToggle(categoryName, Value)
    getgenv().CategoryConfig[categoryName].Auto = Value

    -- Check if any equipment category is enabled
    local anyEquipActive = false
    for _, config in pairs(getgenv().CategoryConfig) do
        if config.Auto then
            anyEquipActive = true
            break
        end
    end

    getgenv().AutoSellEquipActive = anyEquipActive

    if not Value then
        print("[AUTO SELL EQUIP] Disabled for category: " .. categoryName)
    else
        print("🟢 [AUTO SELL EQUIP] STARTED for category: " .. categoryName)
        if not getgenv().AutoSellOreActive then
            -- Only run if ore selling not active
            AutoSellEquipmentWithMerchant()
        else
            print("[AUTO SELL EQUIP] Ore selling also active - using smart coordinator")
            SmartSellCoordinator()
        end
    end
end
-- [[ EXPORT FUNCTIONS ]] --
_G.AutoMerchantSystem = {
    InitOre = InitMerchantOre,
    InitEquipment = InitMerchantEquipment,
    AutoSellOres = AutoSellOresWithMerchant,
    AutoSellEquipment = AutoSellEquipmentWithMerchant,
    UpdateOreToggle = UpdateAutoSellOreToggle,
    UpdateEquipToggle = UpdateAutoSellEquipmentToggle,
    GetCurrentMerchant = function() return getgenv().CurrentMerchantInit end,
    GetOreStatus = function() return getgenv().AutoSellOreActive end,
    GetEquipStatus = function() return getgenv().AutoSellEquipActive end,
}

print("\n✅ [AUTO MERCHANT SYSTEM] Loaded successfully!")
print("Features:")
print("  • Auto-initialize merchants when needed")
print("  • Intelligent re-initialization with cooldown")
print("  • Support simultaneous ore + equipment selling")
print("  • Smart coordinator to manage both merchants")
print("\nDebug Commands:")
print("  _G.AutoMerchantSystem.GetCurrentMerchant()")
print("  _G.AutoMerchantSystem.GetOreStatus()")
print("  _G.AutoMerchantSystem.GetEquipStatus()")
-- Fungsi Mencari Rock di dalam Area yang dipilih
-- [[ UPDATED LOGIC: SMART AREA SCAN ]] --
local function FindNearestRockInSelectedAreas()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local nearestRock = nil
    local minDist = math.huge

    local rocksFolder = workspace:FindFirstChild("Rocks")
    if not rocksFolder then return nil end

    -- 1. TENTUKAN AREA MANA YANG AKAN DI-SCAN
    local areasToScan = {}

    if #getgenv().SelectedAreas > 0 then
        -- KONDISI A: User memilih Area spesifik
        -- Kita hanya masukkan folder area yang dipilih ke daftar scan
        for _, areaName in pairs(getgenv().SelectedAreas) do
            local folder = rocksFolder:FindFirstChild(areaName)
            if folder then
                table.insert(areasToScan, folder)
            end
        end
    else
        -- KONDISI B: User TIDAK memilih Area (Kosong)
        -- Kita masukkan SEMUA folder yang ada di Rocks ke daftar scan (Global Scan)
        areasToScan = rocksFolder:GetChildren()
    end

    -- 2. MULAI SCANNING PADA AREA YANG DITENTUKAN
    for _, area in pairs(areasToScan) do
        -- Pastikan itu Folder/Model area valid
        if area:IsA("Folder") or area:IsA("Model") then
            for _, spawnLoc in pairs(area:GetChildren()) do
                if spawnLoc.Name == "SpawnLocation" then
                    local rockModel = spawnLoc:FindFirstChildWhichIsA("Model")

                    if rockModel then
                        -- 3. LOGIKA FILTER BATU (TARGET ROCKS)
                        local isTarget = false

                        -- Jika User TIDAK memilih filter batu (kosong), anggap semua target
                        if #getgenv().SelectedRocks == 0 then
                            isTarget = true
                        else
                            -- Jika User memilih batu spesifik, cek apakah nama batu ini cocok
                            if table.find(getgenv().SelectedRocks, rockModel.Name) then
                                isTarget = true
                            end
                        end

                        -- Lanjutkan jika Target Valid & Belum Mati
                        if isTarget then
                            -- Cek Health (Atribut/Value/Humanoid)
                            local isDead = false

                            local hpAttr = rockModel:GetAttribute("Health")
                            if hpAttr and hpAttr <= 0 then isDead = true end

                            local hpVal = rockModel:FindFirstChild("Health")
                            if hpVal and hpVal:IsA("ValueBase") and hpVal.Value <= 0 then isDead = true end

                            local hum = rockModel:FindFirstChild("Humanoid")
                            if hum and hum.Health <= 0 then isDead = true end

                            if not isDead then
                                local targetCFrame = rockModel:GetPivot()
                                local dist = (hrp.Position - targetCFrame.Position).Magnitude
                                if dist < minDist then
                                    minDist = dist
                                    nearestRock = targetCFrame
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return nearestRock
end
local function GetCleanName(name)
    -- Menghapus semua angka (%d+) dari nama
    local clean = string.gsub(name, "%d+", "")
    -- Menghapus spasi berlebih di akhir nama (jika ada)
    return string.match(clean, "^%s*(.-)%s*$")
end

-- Scan folder Living untuk mengambil nama BASE Mob (tanpa angka)
local function GetMobList()
    local list = {}
    local living = workspace:FindFirstChild("Living")
    if living then
        for _, model in pairs(living:GetChildren()) do
            if model:IsA("Model") and model:FindFirstChild("Humanoid") then
                -- Cek apakah Model ini Player Asli?
                if not Players:GetPlayerFromCharacter(model) then
                    local cleanName = GetCleanName(model.Name)

                    -- Masukkan ke list hanya jika nama bersihnya belum ada
                    if not table.find(list, cleanName) then
                        table.insert(list, cleanName)
                    end
                end
            end
        end
    end
    table.sort(list) -- Urutkan abjad biar rapi
    return list
end

-- Mencari Mob terdekat dengan logika "Nama Bersih"
local function FindNearestMob()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local nearestMob = nil
    local minDist = math.huge

    local living = workspace:FindFirstChild("Living")
    if living then
        for _, mob in pairs(living:GetChildren()) do
            -- 1. Ambil Nama Bersih mob ini (misal: Brute Zombie176 -> Brute Zombie)
            local mobCleanName = GetCleanName(mob.Name)

            -- 2. Cek apakah Nama Bersih ini ada di daftar pilihan user?
            if table.find(getgenv().SelectedMobs, mobCleanName) then
                local mobHum = mob:FindFirstChild("Humanoid")
                local mobRoot = mob:FindFirstChild("HumanoidRootPart") or mob.PrimaryPart

                -- 3. Cek Validitas & Darah
                if mobHum and mobRoot and mobHum.Health > 0 then
                    local dist = (hrp.Position - mobRoot.Position).Magnitude

                    if dist < minDist then
                        minDist = dist
                        nearestMob = mobRoot -- Kita return RootPart-nya langsung
                    end
                end
            end
        end
    end

    return nearestMob
end
-- Fungsi untuk mengatur Anchored HumanoidRootPart
local function SetAnchor(state)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Anchored = state
    end
end
-- [[ HELPER: GET MOBS FOR DROPDOWN ]] --
local function GetMobOptions()
    local world = getgenv().CurrentWorld
    if world == "[DETECTED IN SERVER]" then
        return GetMobList()
    else
        return MobDatabase[world] or {}
    end
end

-- [[ FUNCTION: GET EQUIPMENT GUIDs (FIXED LOGIC) ]] --
local function GetEquipmentsToSell(targetNames)
    local guids = {}
    local Knit = require(game:GetService("ReplicatedStorage").Shared.Packages.Knit)

    local success, PlayerController = pcall(function() return Knit.GetController("PlayerController") end)
    if success and PlayerController and PlayerController.Replica then
        local Data = PlayerController.Replica.Data

        -- Cek sumber data (Equipments / Inventory.Equipments)
        local EquipSource = Data.Equipments or (Data.Inventory and Data.Inventory.Equipments)

        if EquipSource then
            -- print("[DEBUG SCAN] Memulai Scan Inventory...")

            for _, itemData in pairs(EquipSource) do
                if type(itemData) == "table" then
                    -- [[ PERBAIKAN LOGIKA ]] --
                    -- Beberapa item namanya ada di properti 'Name', tapi ada juga di 'Type'
                    local realName = itemData.Name or itemData.Type

                    if realName and table.find(targetNames, realName) then
                        -- Ambil GUID
                        local id = itemData.GUID or itemData.UniqueId

                        if id then
                            table.insert(guids, id)
                            print("   ✅ Ditemukan: " .. realName .. " | ID: " .. tostring(id))
                        else
                            warn("   ⚠️ Item ditemukan (" .. realName .. ") tapi TIDAK ADA GUID!")
                        end
                    end
                end
            end
        else
            warn("❌ [DEBUG] Gagal menemukan folder Equipments!")
        end
    end
    return guids
end

-- [[ HELPER: CEK INVENTORY (FIXED) ]] --
local function GetPlayerOreAmount(oreName)
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Knit = require(ReplicatedStorage.Shared.Packages.Knit)

    local hasController, PlayerController = pcall(function()
        return Knit.GetController("PlayerController")
    end)

    if hasController and PlayerController and PlayerController.Replica then
        local Data = PlayerController.Replica.Data

        -- [[ LOGIKA PENCARIAN ]] --
        local targetData = nil

        -- 1. Cek Data.Inventory (Prioritas Utama)
        if Data.Inventory then
            -- Cek Data.Inventory.Ores
            if Data.Inventory.Ores and Data.Inventory.Ores[oreName] then
                targetData = Data.Inventory.Ores[oreName]

                -- Cek Data.Inventory.Misc (Kadang ore masuk sini)
            elseif Data.Inventory.Misc and Data.Inventory.Misc[oreName] then
                targetData = Data.Inventory.Misc[oreName]

                -- Cek Langsung di Inventory (Rare case)
            elseif Data.Inventory[oreName] then
                targetData = Data.Inventory[oreName]
            end
        end

        -- 2. Cek Data.Ores (Backup)
        if not targetData and Data.Ores and Data.Ores[oreName] then
            targetData = Data.Ores[oreName]
        end

        -- [[ PENGAMBILAN NILAI ]] --
        if targetData then
            if type(targetData) == "number" then
                return targetData
            elseif type(targetData) == "table" then
                -- Cek field Amount atau Value
                return targetData.Amount or targetData.Value or targetData.Count or 0
            end
        end
    end

    return 0 -- Tidak ketemu / Kosong
end
-- [[ FUNGSI AUTO FORGE (UPDATED) ]] --
local function RunAutoForge()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")

    -- 1. Susun Resep & Validasi Bahan
    local finalRecipe = {}
    local totalMaterials = 0
    local missingMaterials = false

    print("🔍 [Check] Memeriksa ketersediaan bahan...")

    for i = 1, 4 do
        local data = getgenv().ForgeSlots[i]
        if data.Ore and data.Amount > 0 then
            -- Cek Inventory Dulu!
            local ownedAmount = GetPlayerOreAmount(data.Ore)

            -- Jika kita butuh lebih dari yang dimiliki
            -- (Perlu dihitung akumulasi jika ada slot kembar)
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
                break -- Stop loop
            end

            -- Masukkan ke resep jika aman
            if finalRecipe[data.Ore] then
                finalRecipe[data.Ore] = finalRecipe[data.Ore] + data.Amount
            else
                finalRecipe[data.Ore] = data.Amount
            end
            totalMaterials = totalMaterials + data.Amount
        end
    end

    -- Batalkan jika bahan kurang atau kosong
    if missingMaterials then return end
    if totalMaterials == 0 then
        WindUI:Notify({ Title = "Forge Failed", Content = "Please select materials first!", Duration = 3 })
        return
    end

    -- 2. Definisi Remote
    local KnitServices = ReplicatedStorage.Shared.Packages.Knit.Services
    local ProximityService = KnitServices.ProximityService.RF.Forge
    local ForgeService = KnitServices.ForgeService.RF.StartForge
    local ForgeEndService = KnitServices.ForgeService.RF.EndForge

    local ChangeSequence = KnitServices.ForgeService.RF.ChangeSequence
    local ForgeModel = Workspace.Proximity.Forge

    local function GetTime() return Workspace:GetServerTimeNow() end

    -- 3. Eksekusi Sequence
    print("🔨 [Auto Forge] Starting...")
    WindUI:Notify({ Title = "Forge", Content = "Starting process...", Duration = 2 })

    -- Step 1: Open & Start
    -- ProximityService:InvokeServer(ForgeModel)
    -- task.wait(0.5)
    ForgeService:InvokeServer(ForgeModel)
    task.wait(0.5)

    -- Step 2: Melt (CRITICAL CHECK)
    -- Kita gunakan pcall untuk menangkap jika server menolak (error)
    -- Dan kita cek return valuenya
    local meltSuccess, meltResult = pcall(function()
        return ChangeSequence:InvokeServer("Melt", {
            FastForge = false,
            ItemType = getgenv().ForgeItemType,
            Ores = finalRecipe
        })
    end)

    -- VALIDASI SERVER: Jika Melt gagal/nil, hentikan proses!
    if not meltSuccess or not meltResult then
        warn("❌ Server menolak Melt! Kemungkinan bug inventory atau cooldown.")
        WindUI:Notify({ Title = "Forge Error", Content = "Server rejected the recipe!", Duration = 4 })

        -- Reset/End Forge Paksa supaya tidak stuck
        pcall(function() KnitServices.ForgeService.RF.EndForge:InvokeServer() end)
        return
    end

    print("✅ [Melt] Diterima server. Lanjut...")
    task.wait(4) -- Tunggu animasi melt

    -- Step 3: Pour
    ChangeSequence:InvokeServer("Pour", { ClientTime = GetTime(), InContact = true })
    print("✅ [Pour] Diterima server. Lanjut...")
    task.wait(2)

    -- Step 4: Hammer (5x Pukulan)
    for i = 1, 10 do
        ChangeSequence:InvokeServer("Hammer", { ClientTime = GetTime() })
        task.wait(0.35)
    end
    print("✅ [Hammer] Diterima server. Lanjut...")
    task.wait(1)

    -- Step 5: Water & Showcase
    -- ChangeSequence:InvokeServer("Water", { ClientTime = GetTime() })
    --print("✅ [Water] Diterima server. Lanjut...")
    print("🌊 [Water] Mengirim sinyal pendinginan...")

    -- Bungkus dalam task.spawn agar berjalan di thread terpisah (Parallel)
    -- Script utama TIDAK akan menunggu baris ini selesai
    task.spawn(function()
        pcall(function()
            -- Gunakan waktu server saat ini agar valid
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
-- [[ FUNGSI SET REPLICATION FLAG DESYNC]] --
local function SetReplicationFlag(isDesync)
    -- Cek support executor
    if not setfflag then
        WindUI:Notify({ Title = "Error", Content = "Executor tidak support 'setfflag'", Duration = 3 })
        return
    end

    if isDesync then
        task.wait(1)
        setfflag("NextGenReplicatorEnabledWrite4", "true")
    else
        task.wait(1)
        setfflag("NextGenReplicatorEnabledWrite4", "false")
    end
end

-- [[ FUNGSI TWEEN ]] --
local function TweenToPos(targetPos)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local dist = (hrp.Position - targetPos).Magnitude
        local speed = getgenv().TweenSpeed or 50
        local time = dist / speed

        local info = TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local tween = TweenService:Create(hrp, info, { CFrame = CFrame.new(targetPos) })

        -- Matikan Anchor sementara biar bisa tween
        local wasAnchored = hrp.Anchored
        hrp.Anchored = false
        tween:Play()
        tween.Completed:Wait()
        hrp.Anchored = wasAnchored
    end
end

-- [[ LOGIKA AKTIVASI DESYNC ]] --
local function ActivateDesyncRoutine()
    local tx = tonumber(getgenv().DesyncX) or 0
    local ty = tonumber(getgenv().DesyncY) or 0
    local tz = tonumber(getgenv().DesyncZ) or 0
    local targetPos = Vector3.new(tx, ty, tz)

    WindUI:Notify({ Title = "Desync", Content = "Moving to Freeze Point...", Duration = 1 })

    -- 1. Tween ke Posisi
    TweenToPos(targetPos)
    task.wait(0.2)

    -- 2. Aktifkan Flag (Freeze Server)
    SetReplicationFlag(true)

    WindUI:Notify({ Title = "Desync Active", Content = "Server frozen at location.", Duration = 3 })

    -- Visual Indicator
    local char = LocalPlayer.Character
    if char then
        local hl = Instance.new("Highlight")
        hl.Name = "DesyncGlow"
        hl.FillColor = Color3.fromRGB(0, 255, 255)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.Parent = char
    end
end

local function DeactivateDesyncRoutine()
    -- Matikan Flag (Normal)
    SetReplicationFlag(false)
    WindUI:Notify({ Title = "Desync Off", Content = "Back to normal.", Duration = 2 })

    local char = LocalPlayer.Character
    if char and char:FindFirstChild("DesyncGlow") then
        char.DesyncGlow:Destroy()
    end
end

-- [[ REFRESH LOGIC (LOOP ON JOIN) ]] --
local function RefreshDesyncForNewPlayer()
    if not getgenv().DesyncActive then return end

    print("[DESYNC] New player joined! Refreshing ghost position...")
    WindUI:Notify({ Title = "New Player", Content = "Refreshing Ghost Position...", Duration = 2 })

    -- 1. Simpan Status Auto Farm saat ini
    local wasMining = getgenv().AutoMine
    local wasFarming = getgenv().AutoFarmMobs
    local wasSellingOre = getgenv().AutoSellOreActive
    local wasSellingEquip = getgenv().AutoSellEquipActive

    -- 2. Pause Semua Aktivitas (Biar gak konflik Tween)
    getgenv().AutoMine = false
    getgenv().AutoFarmMobs = false
    -- (Auto Sell gak perlu dipause karena dia pakai remote, bukan tween fisik, tapi aman dipause)

    -- 3. Lakukan Prosedur Refresh
    local tx = tonumber(getgenv().DesyncX) or 0
    local ty = tonumber(getgenv().DesyncY) or 0
    local tz = tonumber(getgenv().DesyncZ) or 0
    local targetPos = Vector3.new(tx, ty, tz)

    -- A. Matikan Flag dulu (Biar bisa gerak di server)
    -- Sesuai request: "set flag false" (Normal/Sync)
    SetReplicationFlag(false)

    -- B. Tween Balik ke Posisi Ghost (Agar server lihat kita disana)
    TweenToPos(targetPos)

    -- C. Tunggu 1 Detik (Sesuai request: "wait 1s")
    task.wait(1)

    -- D. Nyalakan Flag Lagi (Desync/Freeze)
    -- Sesuai request: "set flag on"
    SetReplicationFlag(true)

    print("[DESYNC] Ghost refreshed! Resuming activities...")

    -- 4. Resume Aktivitas
    getgenv().AutoMine = wasMining
    getgenv().AutoFarmMobs = wasFarming

    -- Pancing ulang loop jika mati
    if wasMining then
        -- Trigger ulang fungsi AutoMine jika perlu, atau biarkan loop utama menangkap perubahan variabel
        -- Karena loop Anda pakai `while getgenv().AutoMine do`, mengubah jadi true akan otomatis jalan lagi di spawn baru jika loop lama mati,
        -- TAPI loop lama Anda mungkin masih hidup dan cuma menunggu.
        -- Mari kita pastikan toggle UI nya update atau biarkan variabel global bekerja.
    end
end
-- [[ TABS ]] --
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

-- [[ MAIN TAB ]] --
-- [[ SETUP TAB CONTENT ]] --
SetupTab:Slider({
    Title = "Tween Speed",
    Desc = "Movement Speed (Auto Mine & Fight)",
    Value = { Min = 10, Max = 300, Default = 50 },
    Step = 5,
    Callback = function(Value)
        getgenv().TweenSpeed = Value
    end
})

SetupTab:Slider({
    Title = "Height Offset (Y)",
    Desc = "Height above target (Mob/Rock)",
    Value = { Min = -10, Max = 20, Default = 5 },
    Step = 0.5,
    Callback = function(Value)
        getgenv().GlobalHeight = Value
    end
})

SetupTab:Slider({
    Title = "Distance Offset (Z)",
    Desc = "Distance offset from target center",
    Value = { Min = -10, Max = 20, Default = 0 },
    Step = 0.5,
    Callback = function(Value)
        getgenv().GlobalDistance = Value
    end
})
-- [[ AUTO FIGHT TAB ]] --
-- [[ AUTO FIGHT TAB UI ]] --

-- 1. DROPDOWN PILIH DUNIA
AutoFightTab:Dropdown({
    Title = "Select World / Region",
    Values = {
        "Island 1: Stonewake",
        "Island 2: Forgotten",
        "Island 3: Frostspire",
        "[DETECTED IN SERVER]" -- Opsi jika ingin scan manual
    },
    Value = getgenv().CurrentWorld,
    Desc = "Detected: " .. getgenv().CurrentWorld,
    Callback = function(Value)
        getgenv().CurrentWorld = Value
    end
})

-- 3. DROPDOWN PILIH MOB (DINAMIS)
MobDropdown = AutoFightTab:Dropdown({
    Title = "Select Target Mobs",
    Values = GetMobOptions(), -- Default awal
    Multi = true,
    AllowNone = true,
    Value = {},
    Callback = function(Value)
        getgenv().SelectedMobs = Value
    end
})

-- 4. TOGGLE UTAMA (LOGIKA STABILIZER)
AutoFightTab:Toggle({
    Title = "Auto Farm Mobs",
    Value = false,
    Callback = function(Value)
        getgenv().AutoFarmMobs = Value

        if not Value then
            SetAnchor(false)
            WindUI:Notify({ Title = "Auto Farm", Content = "Stopped.", Duration = 1 })
        end

        if Value then
            task.spawn(function()
                while getgenv().AutoFarmMobs do
                    local targetPart = FindNearestMob() -- Fungsi pencari mob (Clean Name)

                    if targetPart then
                        local mobPos = targetPart.Position

                        -- Menggunakan Global Setup
                        local targetPos = mobPos + Vector3.new(0, getgenv().GlobalHeight, getgenv().GlobalDistance)
                        local finalCFrame = CFrame.lookAt(targetPos, mobPos)

                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local dist = (hrp.Position - targetPos).Magnitude

                            -- Logic Stabilizer (Jauh Tween, Dekat Anchor)
                            if dist > 8 then
                                SetAnchor(false)
                                TweenTo(finalCFrame)
                            else
                                SetAnchor(true)
                                hrp.CFrame = hrp.CFrame:Lerp(finalCFrame, 0.5)
                            end

                            -- Serang
                            local isReady = EquipToolByName(getgenv().TargetWeaponName)
                            if isReady then
                                pcall(function()
                                    local args = { getgenv().TargetWeaponName }
                                    game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.ToolService.RF
                                        .ToolActivated:InvokeServer(unpack(args))
                                end)
                            end
                        end
                    else
                        SetAnchor(false)
                    end
                    task.wait() -- Loop Cepat
                end
                SetAnchor(false)
            end)
        end
    end
})
-- AUTO MINE TAB
-- [[ AUTO MINE TAB UPDATE ]] --

-- 1. Dropdown Area (Code Lama - Tetap Perlu)
AutoMineTab:Dropdown({
    Title = "Select Mining Area",
    Values = GetAreaList(),
    Multi = true,
    Value = {},
    AllowNone = true,
    Desc = "Where to look for rocks",
    Callback = function(Value)
        getgenv().SelectedAreas = Value
    end
})

AutoMineTab:Button({
    Title = "Refresh Area List",
    Desc = "Click if new areas loaded",
    Callback = function()
        local newList = GetAreaList()
        -- Pastikan menyimpan object dropdown ke variabel jika ingin refresh
        -- AreaDropdown:Refresh(newList) (Sesuaikan jika Anda menyimpan variabelnya)
        WindUI:Notify({ Title = "Success", Content = "Area list updated!", Duration = 1 })
    end
})

-- 2. DROPDOWN FILTER BATU (BARU!)
AutoMineTab:Dropdown({
    Title = "Filter Target Rocks (Optional)",
    Values = RockList, -- Menggunakan List dari Dump
    Multi = true,
    Value = {},
    Desc = "Leave EMPTY to mine everything. Select to filter.",
    Callback = function(Value)
        getgenv().SelectedRocks = Value
    end
})

-- 3. Toggle Auto Mine (Code Lama - Tidak berubah)
AutoMineTab:Toggle({
    Title = "Auto Mine",
    Desc = "Tween -> Anchor -> LookAt -> Mine",
    Value = false,
    Callback = function(Value)
        getgenv().AutoMine = Value

        if not Value then
            SetAnchor(false)
            WindUI:Notify({ Title = "Auto Mine", Content = "Stopped.", Duration = 1 })
        end

        if Value then
            task.spawn(function()
                while getgenv().AutoMine do
                    -- Fungsi ini sekarang sudah support Filter!
                    local targetCFrame = FindNearestRockInSelectedAreas()

                    if targetCFrame then
                        -- ... (Logika Tween & Mining sama seperti sebelumnya) ...
                        local rockPos = targetCFrame.Position
                        local targetPos = rockPos + Vector3.new(0, getgenv().GlobalHeight, getgenv().GlobalDistance)
                        local finalCFrame = CFrame.lookAt(targetPos, rockPos)

                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local dist = (hrp.Position - targetPos).Magnitude
                            if dist > 2 then
                                SetAnchor(false)
                                TweenTo(finalCFrame)
                            else
                                hrp.CFrame = finalCFrame
                                SetAnchor(true)
                            end

                            local isReady = EquipToolByName(getgenv().TargetMineName)
                            if isReady then
                                pcall(function()
                                    local args = { getgenv().TargetMineName }
                                    game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.ToolService.RF
                                        .ToolActivated:InvokeServer(unpack(args))
                                end)
                            end
                        end
                    else
                        SetAnchor(false)
                        -- Tidak perlu notif spam jika sedang mencari filter tertentu
                    end
                    task.wait(0.1)
                end
                SetAnchor(false)
            end)
        end
    end
})
-- AUTO SELL TAB
AutoSellOreTab:Button({
    Title = "Initialize Merchant",
    Desc = "Walk & Talk to Greedy Cey (Once)",
    Callback = function()
        task.spawn(function()
            -- Cari Toko & NPC
            local shop = workspace:FindFirstChild("Shops") and workspace.Shops:FindFirstChild("Ore Seller")
            local npc = workspace:FindFirstChild("Proximity") and workspace.Proximity:FindFirstChild("Greedy Cey")

            if shop and npc then
                SetAnchor(false)
                WindUI:Notify({ Title = "Shop", Content = "Walking to Merchant...", Duration = 1 })

                -- Tween ke Toko
                local targetPos = shop.WorldPivot * CFrame.new(0, 0, 5)
                local finalCFrame = CFrame.lookAt(targetPos.Position, shop.WorldPivot.Position)
                TweenTo(finalCFrame)

                -- Buka Dialog
                task.wait(0.5)
                pcall(function()
                    local args = { npc }
                    game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.ProximityService.RF.Dialogue
                        :InvokeServer(unpack(args))
                end)
                WindUI:Notify({ Title = "Shop", Content = "Dialog Opened! Remote Sell Ready.", Duration = 3 })
            else
                WindUI:Notify({ Title = "Error", Content = "Merchant not found!", Duration = 2 })
            end
        end)
    end
})

AutoSellEquipTab:Button({
    Title = "Init: Weapon Merchant",
    Desc = "Walk & Talk to Marbles (REQUIRED for Weapons)",
    Callback = function()
        task.spawn(function()
            local npc = workspace:FindFirstChild("Proximity") and workspace.Proximity:FindFirstChild("Marbles")
            -- Cari Toko Weapon (Biasanya dekat spawn/Ore Seller, atau kita pake posisi NPC)

            if npc then
                SetAnchor(false)
                WindUI:Notify({ Title = "Weapon Shop", Content = "Walking...", Duration = 1 })

                -- Tween ke NPC Marbles
                local npcPos = npc:GetPivot()
                local targetPos = npcPos * CFrame.new(0, 0, 5)
                TweenTo(CFrame.lookAt(targetPos.Position, npcPos.Position))

                task.wait(0.5)
                -- Force Dialogue (Sesuai Request Anda)
                pcall(function()
                    local args = {
                        [1] = npc
                    }

                    game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.ProximityService.RF.Dialogue
                        :InvokeServer(unpack(args))
                end)
                WindUI:Notify({ Title = "Weapon Shop", Content = "Ready!", Duration = 2 })
            else
                WindUI:Notify({ Title = "Error", Content = "Marbles NPC not found!", Duration = 2 })
            end
        end)
    end
})
AutoSellOreTab:Section({ Title = "Bulk Selling" })

-- 2. MULTI DROPDOWN ITEM (LENGKAP)
AutoSellOreTab:Dropdown({
    Title = "Select Items to Sell",
    Values = OreList, -- Database Ore 86 item
    Multi = true,     -- BISA PILIH BANYAK
    Value = {},
    Desc = "Select ores/stones to sell",
    Callback = function(Value)
        getgenv().SelectedSellItems = Value
    end
})
-- 4. AUTO SELL (SPAM BULK)
AutoSellOreTab:Toggle({
    Title = "Auto Sell Selected",
    Desc = "Loop sell selected items",
    Value = false,
    Callback = function(Value)
        getgenv().AutoSell = Value

        if Value then
            task.spawn(function()
                while getgenv().AutoSell do
                    local itemsToSell = getgenv().SelectedSellItems
                    if #itemsToSell > 0 then
                        -- Buat Basket ulang setiap loop
                        local basketContent = {}
                        for _, itemName in pairs(itemsToSell) do
                            basketContent[itemName] = SellAmount
                        end

                        pcall(function()
                            local args = {
                                [1] = "SellConfirm",
                                [2] = {
                                    ["Basket"] = basketContent
                                }
                            }
                            game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.DialogueService.RF
                                .RunCommand:InvokeServer(unpack(args))
                        end)
                    end
                    task.wait(1.5) -- Delay aman agar tidak dianggap spammer
                end
            end)
        end
    end
})
AutoSellOreTab:Dropdown({
    Title = "Select Rarity to Sell",
    Values = GetAllRarities(),
    Value = "Common",
    Desc = "Choose ore rarity to sell",
    Callback = function(Value)
        getgenv().SelectedRarityToSell = Value

        -- Get ores for this rarity
        local oresForRarity = GetOresByRarity(Value)
        getgenv().RarityOreSelection = oresForRarity

        -- Notify user
        local oreCount = #oresForRarity
        WindUI:Notify({
            Title = "Rarity Filter",
            Content = "Found " .. oreCount .. " ores with rarity: " .. Value,
            Duration = 2
        })

        print("[RARITY SELL] Selected Rarity: " .. Value)
        print("[RARITY SELL] Available Ores (" .. oreCount .. "): " .. table.concat(oresForRarity, ", "))
    end
})
AutoSellOreTab:Toggle({
    Title = "Auto Sell by Rarity",
    Desc = "Main selling loop with equipment helper",
    Value = false,
    Callback = function(Value)
        getgenv().AutoSellOreActive = Value

        if not Value then
            WindUI:Notify({
                Title = "Auto Sell Ore",
                Content = "Stopped.",
                Duration = 1
            })
            return
        end

        print("\n🟢 [AUTO SELL ORE] STARTED - Main Loop")

        task.spawn(function()
            -- STEP 1: INIT ORE MERCHANT (ONCE)
            print("[AUTO SELL ORE] Initializing Ore Merchant...")

            local shop = workspace:FindFirstChild("Shops") and workspace.Shops:FindFirstChild("Ore Seller")
            local npc = workspace:FindFirstChild("Proximity") and workspace.Proximity:FindFirstChild("Greedy Cey")

            if not shop or not npc then
                warn("❌ Ore Merchant not found!")
                getgenv().AutoSellOreActive = false
                return
            end

            getgenv().OreNPCReference = npc -- Store reference

            -- Tween ke Ore Merchant
            print("[AUTO SELL ORE] Walking to Ore Merchant...")
            local targetPos = shop.WorldPivot * CFrame.new(0, 0, 5)
            local finalCFrame = CFrame.lookAt(targetPos.Position, shop.WorldPivot.Position)
            SetAnchor(false)
            TweenTo(finalCFrame)

            task.wait(0.5)

            -- Buka Dialog Ore
            print("[AUTO SELL ORE] Opening Ore Merchant dialog...")
            local initSuccess = pcall(function()
                local args = { npc }
                game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.ProximityService.RF.Dialogue
                    :InvokeServer(unpack(args))
            end)

            if not initSuccess then
                warn("❌ Failed to open Ore Merchant dialog!")
                getgenv().AutoSellOreActive = false
                return
            end

            print("✅ [AUTO SELL ORE] Ore Merchant initialized! Starting main loop...")
            getgenv().CurrentMerchantInit = "Ore"
            getgenv().LastOreDialogTime = tick()
            task.wait(1)

            -- STEP 2: MAIN LOOP
            while getgenv().AutoSellOreActive do
                -- ========== CHECK EQUIPMENT FIRST (HELPER) ==========
                if getgenv().AutoSellEquipActive then
                    print("\n[AUTO SELL] Checking for equipment to sell...")

                    local hasEquipToSell = false
                    local equipsToProcess = {}

                    -- Scan semua kategori equipment
                    for categoryName, config in pairs(getgenv().CategoryConfig) do
                        if config.Auto and #config.Items > 0 then
                            local targetNames = config.Items
                            local guidsToSell = GetEquipmentsToSell(targetNames)

                            if #guidsToSell > 0 then
                                hasEquipToSell = true
                                table.insert(equipsToProcess, {
                                    category = categoryName,
                                    guids = guidsToSell
                                })
                            end
                        end
                    end

                    -- Jika ada equipment yang bisa dijual
                    if hasEquipToSell then
                        print("[AUTO SELL] Found equipment to sell! Switching to Equipment Merchant...")

                        -- Switch ke Equipment Merchant
                        local equipNpc = workspace:FindFirstChild("Proximity") and
                            workspace.Proximity:FindFirstChild("Marbles")

                        if equipNpc then
                            -- Tween ke Equipment NPC
                            local npcPos = equipNpc:GetPivot()
                            local targetPos = npcPos * CFrame.new(0, 0, 5)
                            SetAnchor(false)
                            TweenTo(CFrame.lookAt(targetPos.Position, npcPos.Position))

                            task.wait(0.5)

                            -- Open Equipment Dialog
                            local equipDialogSuccess = pcall(function()
                                local args = { equipNpc }
                                game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.ProximityService.RF
                                    .Dialogue
                                    :InvokeServer(unpack(args))
                            end)

                            if equipDialogSuccess then
                                print("✅ [AUTO SELL] Equipment Merchant dialog opened!")
                                task.wait(0.5)

                                -- Sell semua equipment yang ada
                                for _, equipData in ipairs(equipsToProcess) do
                                    local basket = {}
                                    for _, guid in pairs(equipData.guids) do
                                        basket[guid] = true
                                    end

                                    print("[AUTO SELL] Selling " ..
                                        #equipData.guids .. " items from " .. equipData.category)

                                    local sellSuccess, sellErr = pcall(function()
                                        local args = { "SellConfirm", { ["Basket"] = basket } }
                                        game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services
                                            .DialogueService
                                            .RF.RunCommand:InvokeServer(unpack(args))
                                    end)

                                    if sellSuccess then
                                        print("✅ [AUTO SELL] Equipment sold!")
                                        WindUI:Notify({
                                            Title = "Equipment Sold",
                                            Content = "Sold " .. #equipData.guids .. " items",
                                            Duration = 0.8
                                        })
                                    else
                                        warn("❌ Equipment sell failed: " .. tostring(sellErr))
                                    end

                                    task.wait(1)
                                end

                                -- Switch back to Ore Merchant
                                print("[AUTO SELL] Equipment done! Switching back to Ore Merchant...")

                                local targetPos = shop.WorldPivot * CFrame.new(0, 0, 5)
                                local finalCFrame = CFrame.lookAt(targetPos.Position, shop.WorldPivot.Position)
                                SetAnchor(false)
                                TweenTo(finalCFrame)

                                task.wait(0.5)

                                -- Re-init Ore Dialog
                                local oreReInitSuccess = pcall(function()
                                    local args = { getgenv().OreNPCReference }
                                    game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.ProximityService
                                        .RF.Dialogue
                                        :InvokeServer(unpack(args))
                                end)

                                if oreReInitSuccess then
                                    print("✅ [AUTO SELL] Ore Merchant dialog re-opened!")
                                    getgenv().LastOreDialogTime = tick()
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

                -- ========== SELL ORES (MAIN) ==========
                local selectedRarity = getgenv().SelectedRarityToSell
                local oresToSell = getgenv().RarityOreSelection

                if #oresToSell > 0 then
                    local basket = {}
                    for _, oreName in pairs(oresToSell) do
                        basket[oreName] = SellAmount
                    end

                    print("\n[AUTO SELL ORE] Selling " .. #oresToSell .. " ore types (" .. selectedRarity .. ")")

                    local success, err = pcall(function()
                        local args = {
                            [1] = "SellConfirm",
                            [2] = { ["Basket"] = basket }
                        }
                        game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.DialogueService.RF
                            .RunCommand:InvokeServer(unpack(args))
                    end)

                    if success then
                        print("✅ [AUTO SELL ORE] Ore sold!")
                        WindUI:Notify({
                            Title = "Ore Sold",
                            Content = "Sold " .. #oresToSell .. " types",
                            Duration = 0.8
                        })
                    else
                        warn("❌ Ore sell failed: " .. tostring(err))

                        -- Re-init dialog jika failed
                        print("[AUTO SELL ORE] Re-initializing Ore Merchant dialog...")
                        local reInitSuccess = pcall(function()
                            local args = { getgenv().OreNPCReference }
                            game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.ProximityService.RF
                                .Dialogue
                                :InvokeServer(unpack(args))
                        end)

                        if reInitSuccess then
                            print("✅ [AUTO SELL ORE] Dialog re-initialized")
                            getgenv().LastOreDialogTime = tick()
                        else
                            warn("❌ Failed to re-init dialog, stopping")
                            break
                        end
                    end
                else
                    print("⚠️ No ores selected for rarity: " .. selectedRarity)
                end

                task.wait(2.5) -- Main loop delay
            end

            print("[AUTO SELL ORE] Main loop stopped")
            getgenv().CurrentMerchantInit = nil
        end)
    end
})



-- 3. EQUIPMENT GENERATOR (Tanpa Group, Langsung Section per Kategori)
local sortedCats = {}
for cat in pairs(EquipmentDatabase) do table.insert(sortedCats, cat) end
table.sort(sortedCats)

for _, categoryName in ipairs(sortedCats) do
    local items = EquipmentDatabase[categoryName]
    local defaultValues = {}

    if categoryName == "Medium Armor" or categoryName == "Light Armor" then
        defaultValues = items
    end

    getgenv().CategoryConfig[categoryName] = { Items = defaultValues, Auto = false }

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
        Callback = function(Value)
            getgenv().CategoryConfig[categoryName].Items = Value
        end
    })

    section:Toggle({
        Title = "Auto Sell " .. categoryName,
        Callback = function(Value)
            getgenv().CategoryConfig[categoryName].Auto = Value

            -- Update AutoSellEquipActive status
            local anyEquipActive = false
            for _, config in pairs(getgenv().CategoryConfig) do
                if config.Auto then
                    anyEquipActive = true
                    break
                end
            end
            getgenv().AutoSellEquipActive = anyEquipActive

            if Value then
                print("[AUTO SELL EQUIP] Enabled for category: " .. categoryName)
                print("⚠️  [AUTO SELL EQUIP] Note: Equipment selling requires Auto Sell Ore to be ACTIVE!")

                if not getgenv().AutoSellOreActive then
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

-- ========================================
-- DEBUG COMMANDS
-- ========================================

_G.DebugAutoMerchant = function()
    print("\n" .. string.rep("=", 60))
    print("AUTO SELL SYSTEM DEBUG")
    print(string.rep("=", 60))
    print("Auto Sell Ore Active: " .. tostring(getgenv().AutoSellOreActive))
    print("Auto Sell Equip Active: " .. tostring(getgenv().AutoSellEquipActive))
    print("Current Merchant: " .. tostring(getgenv().CurrentMerchantInit))
    print("Last Ore Dialog Time: " .. string.format("%.1f", tick() - getgenv().LastOreDialogTime) .. "s ago")
    print(string.rep("=", 60) .. "\n")
end

print("✅ [AUTO SELL] Simplified system loaded!")
print("Priority: ORE (Main) > EQUIPMENT (Helper)")
print("Commands: _G.DebugAutoMerchant()")


-- [[ PLAYER TAB ]] --
local SectionMove = PlayerTab:Section({ Title = "Movement" })

-- FITUR BARU: AUTO RUN
local SectionGroup1 = PlayerTab:Group({})
SectionGroup1:Toggle({
    Title = "Auto Run",
    Value = false,
    Callback = function(Value)
        getgenv().AutoRun = Value
        if Value then
            WindUI:Notify({ Title = "Auto Run", Content = "Running enabled!", Duration = 1 })
            StartAutoRun()
        else
            WindUI:Notify({ Title = "Auto Run", Content = "Running disabled.", Duration = 1 })
            StopRunSequence()
        end
    end
})

SectionGroup1:Space()

SectionGroup1:Toggle({
    Title = "No Clip",
    Value = false,
    Callback = function(Value)
        getgenv().NoClip = Value
    end
})

PlayerTab:Space()
PlayerTab:Slider({
    Title = "WalkSpeed",
    Value = { Min = 16, Max = 200, Default = 16 },
    Step = 1,
    Callback = function(Value)
        getgenv().WalkSpeedVal = Value
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
        getgenv().JumpPowerVal = Value
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
    Callback = function(Value)
        ToggleESP(Value)
    end
})

-- [[ SETTINGS TAB ]] --
SettingTab:Keybind({
    Title = "Keybind",
    Desc = "Keybind to open ui",
    Value = "RightControl",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

SettingTab:Dropdown({
    Title = "Select Theme",
    Values = {
        "Plant",
        "Rose",
        "Dark"
    },
    Value = "Plant",
    Callback = function(option)
        WindUI:SetTheme(option)
    end
})

-- Loop Speed Keeper
task.spawn(function()
    while task.wait(1) do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if LocalPlayer.Character.Humanoid.WalkSpeed ~= getgenv().WalkSpeedVal then
                LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedVal
            end
        end
    end
end)

local ConfigSection = ForgeTab:Section({ Title = "1. Configuration" })
ConfigSection:Dropdown({
    Title = "Target Item Type",
    Values = { "Weapon", "Armor" },
    Value = "Weapon",
    Callback = function(v)
        getgenv().ForgeItemType = v
    end
})

-- Bagian Resep (4 Slot)
local RecipeSection = ForgeTab:Section({ Title = "2. Recipe Mixer" })

-- Loop untuk membuat 4 Slot secara otomatis agar code rapi
for i = 1, 4 do
    RecipeSection:Dropdown({
        Title = "Select Ore",
        Values = OreList, -- Mengambil dari OreList di script utama Anda
        Multi = false,    -- Single Select sesuai request
        Value = nil,
        Desc = "Choose material for Slot " .. i,
        Callback = function(v)
            getgenv().ForgeSlots[i].Ore = v
        end
    })

    RecipeSection:Slider({
        Title = "Amount",
        Desc = "Quantity for this slot",
        Value = { Min = 0, Max = 10, Default = 0 }, -- Default 0 sesuai request
        Step = 1,
        Callback = function(v)
            getgenv().ForgeSlots[i].Amount = v
        end
    })
end

-- Tombol Eksekusi
local ActionSection = ForgeTab:Section({ Title = "3. Action" })
ActionSection:Button({
    Title = "START FORGE",
    Desc = "Make sure you are close to the Anvil!",
    Callback = function()
        task.spawn(RunAutoForge)
    end
})

-- DESYNC
local DesyncSection = DesyncTab:Section({ Title = "Coordinates Desync" })

local InputX = DesyncSection:Input({
    Title = "X",
    Value = getgenv().DesyncX,
    Callback = function(Text) getgenv().DesyncX = Text end
})

local InputY = DesyncSection:Input({
    Title = "Y",
    Value = getgenv().DesyncY,
    Callback = function(Text) getgenv().DesyncY = Text end
})

local InputZ = DesyncSection:Input({
    Title = "Z",
    Value = getgenv().DesyncZ,
    Callback = function(Text) getgenv().DesyncZ = Text end
})

DesyncSection:Button({
    Title = "Save Current Position",
    Desc = "Capture where you stand now",
    Callback = function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local pos = hrp.Position
            -- Update Global Vars
            getgenv().DesyncX = tostring(math.floor(pos.X))
            getgenv().DesyncY = tostring(math.floor(pos.Y))
            getgenv().DesyncZ = tostring(math.floor(pos.Z))

            -- Update UI
            InputX:Set(getgenv().DesyncX)
            InputY:Set(getgenv().DesyncY)
            InputZ:Set(getgenv().DesyncZ)

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
        getgenv().DesyncActive = Value
        if Value then
            task.spawn(ActivateDesyncRoutine)
        else
            task.spawn(DeactivateDesyncRoutine)
        end
    end
})

-- Toggle Loop on Join
DesyncSection:Toggle({
    Title = "Loop When New Player Join",
    Desc = "Refresh ghost pos when someone joins",
    Value = false,
    Callback = function(Value)
        getgenv().LoopOnJoin = Value
    end
})

-- Listener Player Added
Players.PlayerAdded:Connect(function(player)
    if getgenv().LoopOnJoin and getgenv().DesyncActive then
        task.spawn(RefreshDesyncForNewPlayer)
    end
end)

-- END OF DESYNC TAB --
local SectionPhysics = PlayerTab:Section({ Title = "Physics & Support" })

-- [[ 1. ANTI GRAVITY ]] --
SectionPhysics:Toggle({
    Title = "Anti Gravity",
    Desc = "Keep Y position stable (Float)",
    Value = false,
    Callback = function(Value)
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if Value then
            if hrp then
                -- Hapus BodyVelocity lama jika ada (biar gak numpuk)
                for _, v in pairs(hrp:GetChildren()) do
                    if v.Name == "WindUI_AntiGravity" then v:Destroy() end
                end

                -- Buat BodyVelocity baru
                local bv = Instance.new("BodyVelocity")
                bv.Name = "WindUI_AntiGravity"
                bv.Velocity = Vector3.new(0, 0, 0)
                -- MaxForce Y sangat besar, X dan Z nol agar bisa tetap jalan
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

-- [[ 2. PLATFORM WALKING (TANAH DI UDARA) ]] --
getgenv().PlatformLoop = nil

SectionPhysics:Toggle({
    Title = "Sky Platform",
    Desc = "Spawn glass floor under your feet",
    Value = false,
    Callback = function(Value)
        if Value then
            -- Buat Part Platform
            local plat = Instance.new("Part")
            plat.Name = "WindUI_SkyPlatform"
            plat.Size = Vector3.new(10, 1, 10) -- Ukuran 10x10
            plat.Anchored = true
            plat.Transparency = 0.6
            plat.Material = Enum.Material.Glass
            plat.Color = Color3.fromRGB(0, 255, 255) -- Warna Cyan
            plat.CanCollide = true
            plat.Parent = workspace

            -- Loop agar platform mengikuti pemain
            if getgenv().PlatformLoop then getgenv().PlatformLoop:Disconnect() end

            getgenv().PlatformLoop = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")

                if char and hrp and plat.Parent then
                    -- Set posisi tepat di bawah kaki (Offset -3.5 studs)
                    plat.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - 3.5, hrp.Position.Z)
                else
                    -- Cleanup otomatis jika karakter hilang
                    if getgenv().PlatformLoop then getgenv().PlatformLoop:Disconnect() end
                    if plat then plat:Destroy() end
                end
            end)

            WindUI:Notify({ Title = "Platform", Content = "Created.", Duration = 1 })
        else
            -- Matikan Loop dan Hapus Part
            if getgenv().PlatformLoop then getgenv().PlatformLoop:Disconnect() end

            local p = workspace:FindFirstChild("WindUI_SkyPlatform")
            if p then p:Destroy() end

            WindUI:Notify({ Title = "Platform", Content = "Removed.", Duration = 1 })
        end
    end
})
