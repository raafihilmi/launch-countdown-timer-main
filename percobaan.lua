local WindUI = loadstring(game:HttpGet("https://pastebin.com/raw/m8P8dLfd"))()


-- [[ MAIN WINDOW CREATION ]] --
local Window = WindUI:CreateWindow({
    Title = "TForge",
    Icon = "gamepad-2",
    Author = "JumantaraHub v18",
    Theme = "Plant",
    Folder = "UniversalScript_v18s"
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

-- [[ FUNCTION: GET EQUIPMENT GUIDs ]] --
local function GetEquipmentsToSell(targetNames)
    local guids = {}
    local Knit = require(game:GetService("ReplicatedStorage").Shared.Packages.Knit)

    -- Coba akses Data Pemain
    local success, PlayerController = pcall(function() return Knit.GetController("PlayerController") end)
    if success and PlayerController and PlayerController.Replica then
        local Data = PlayerController.Replica.Data

        -- Kita cari di Data.Equipments (Sesuai temuan debug)
        -- Jika kosong, fallback ke Data.Inventory.Equipments (Sesuai temuan decompiler)
        local EquipSource = Data.Equipments or (Data.Inventory and Data.Inventory.Equipments)

        if EquipSource then
            for _, itemData in pairs(EquipSource) do
                if type(itemData) == "table" then
                    -- Cek Nama Item
                    if table.find(targetNames, itemData.Name) then
                        -- AMBIL GUID (Ini kunci utama penjualan!)
                        if itemData.GUID then
                            table.insert(guids, itemData.GUID)
                        end
                    end
                end
            end
        end
    end
    return guids
end

-- [[ TABS ]] --
local MainSection = Window:Section({ Title = "Main", Icon = "swords" })
local SetupTab = MainSection:Tab({ Title = "Setup", Icon = "wrench" })
local AutoMineTab = MainSection:Tab({ Title = "Auto Mine", Icon = "pickaxe" })
local AutoFightTab = MainSection:Tab({ Title = "Auto Fight", Icon = "swords" })
local ShopTab = Window:Tab({ Title = "Shop & Sell", Icon = "shopping-cart" })
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
ShopTab:Button({
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

ShopTab:Button({
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
ShopTab:Section({ Title = "Bulk Selling" })

-- 2. MULTI DROPDOWN ITEM (LENGKAP)
ShopTab:Dropdown({
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
ShopTab:Toggle({
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

ShopTab:Space()

-- 3. EQUIPMENT GENERATOR (Tanpa Group, Langsung Section per Kategori)
local sortedCats = {}
for cat in pairs(EquipmentDatabase) do table.insert(sortedCats, cat) end
table.sort(sortedCats)

for _, categoryName in ipairs(sortedCats) do
    local items = EquipmentDatabase[categoryName]
    local defaultValues = {}

    -- Auto select untuk Armor
    if categoryName == "Medium Armor" or categoryName == "Light Armor" then
        defaultValues = items
    end

    -- Setup config table
    getgenv().CategoryConfig[categoryName] = { Items = defaultValues, Auto = false }

    -- LANGSUNG SECTION KE TAB
    local section = ShopTab:Section({
        Title = categoryName,
        Box = true,
        BoxBorder = true,
        Opened = false -- Default tertutup biar UI rapi (user expand jika butuh)
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

            if Value then
                task.spawn(function()
                    while getgenv().CategoryConfig[categoryName].Auto do
                        local targetNames = getgenv().CategoryConfig[categoryName].Items
                        if #targetNames > 0 then
                            -- 1. Cari GUID item di Inventory
                            local guidsToSell = GetEquipmentsToSell(targetNames)

                            if #guidsToSell > 0 then
                                -- 2. Masukkan ke Basket
                                local basket = {}
                                for _, guid in pairs(guidsToSell) do
                                    basket[guid] = true -- Format Basket Equipment: [GUID] = true
                                end

                                -- 3. Jual!
                                pcall(function()
                                    local args = { "SellConfirm", { ["Basket"] = basket } }
                                    game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.DialogueService
                                        .RF.RunCommand:InvokeServer(unpack(args))
                                end)

                                -- Notif kecil (opsional, matikan jika spam)
                                -- WindUI:Notify({Title = "Sold", Content = #guidsToSell .. " items from " .. categoryName, Duration = 1})
                            end
                        end
                        task.wait(3)
                    end
                end)
            end
        end
    })

    ShopTab:Space()
end
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
