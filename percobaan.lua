local WindUI = loadstring(game:HttpGet("https://pastebin.com/raw/m8P8dLfd"))()


-- [[ MAIN WINDOW CREATION ]] --
local Window = WindUI:CreateWindow({
    Title = "TForge",
    Icon = "gamepad-2",
    Author = "JumantaraHub v16",
    Theme = "Plant",
    Folder = "UniversalScript_v16s"
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
getgenv().SelectedMobs = {} --

-- [[ SERVICES ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- [[ ESP FUNCTIONS ]] --
local espHolder = Instance.new("Folder", game.CoreGui)
espHolder.Name = "WindUI_ESP_Storage"

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
local function FindNearestRockInSelectedAreas()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local nearestRock = nil
    local minDist = math.huge

    local rocksFolder = workspace:FindFirstChild("Rocks")
    if not rocksFolder then return nil end

    -- Loop area yang dipilih user
    for _, areaName in pairs(getgenv().SelectedAreas) do
        local area = rocksFolder:FindFirstChild(areaName)
        if area then
            -- Loop SpawnLocation di dalam Area
            for _, spawnLoc in pairs(area:GetChildren()) do
                if spawnLoc.Name == "SpawnLocation" then
                    local rockModel = spawnLoc:FindFirstChildWhichIsA("Model")

                    if rockModel then
                        -- [[ PENGECEKAN HEALTH DI SINI ]] --
                        local isDead = false

                        -- Cek 1: Apakah ada Attribute "Health"?
                        local hpAttr = rockModel:GetAttribute("Health")
                        if hpAttr and hpAttr <= 0 then isDead = true end

                        -- Cek 2: Apakah ada Child bernama "Health" (Objek Value)?
                        local hpVal = rockModel:FindFirstChild("Health")
                        if hpVal and hpVal:IsA("ValueBase") and hpVal.Value <= 0 then isDead = true end

                        -- Cek 3: Cek Humanoid (Jaga-jaga)
                        local hum = rockModel:FindFirstChild("Humanoid")
                        if hum and hum.Health <= 0 then isDead = true end

                        -- JIKA BATU MATI, SKIP (Lanjutkan ke batu berikutnya)
                        if not isDead then
                            -- Ambil posisi target
                            local targetCFrame = rockModel:GetPivot()

                            -- Cek jarak
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

-- [[ TABS ]] --
local MainSection = Window:Section({ Title = "Main", Icon = "swords" })
local SetupTab = MainSection:Tab({ Title = "Setup", Icon = "wrench" })
local AutoMineTab = MainSection:Tab({ Title = "Auto Mine", Icon = "pickaxe" })
local AutoFightTab = MainSection:Tab({ Title = "Auto Fight", Icon = "swords" })
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
    Values = MobDatabase["Island 1: Stonewake"], -- Default awal
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
AutoMineTab:Dropdown({
    Title = "Select Mining Area",
    Values = GetAreaList(), -- Mengambil list otomatis
    Multi = true,           -- Bisa pilih banyak area
    Value = {},
    Desc = "Select areas to farm",
    Callback = function(Value)
        getgenv().SelectedAreas = Value
    end
})

-- Tombol Refresh jika area baru loading (Opsional)
AutoMineTab:Button({
    Title = "Refresh Area List",
    Callback = function()
        local newList = GetAreaList()
        AreaDropdown:Refresh(newList) -- Fitur refresh WindUI
        WindUI:Notify({ Title = "Success", Content = "Area list updated!", Duration = 1 })
    end
})
AutoMineTab:Toggle({
    Title = "Auto Mine",
    Desc = "Tween -> Anchor -> LookAt -> Mine",
    Value = false,
    Callback = function(Value)
        getgenv().AutoMine = Value

        -- Unanchor jika dimatikan
        if not Value then
            SetAnchor(false)
            WindUI:Notify({ Title = "Auto Mine", Content = "Stopped.", Duration = 1 })
        end

        if Value then
            task.spawn(function()
                while getgenv().AutoMine do
                    local targetCFrame = FindNearestRockInSelectedAreas()

                    if targetCFrame then
                        local rockPos = targetCFrame.Position

                        -- [[ PERBAIKAN DI SINI ]] --
                        -- Menambahkan getgenv().MineDistance ke sumbu Z
                        -- Posisi = Pusat Batu + Tinggi (Y) + Jarak Mundur/Maju (Z)
                        local targetPos = rockPos + Vector3.new(0, getgenv().GlobalHeight, getgenv().GlobalDistance)

                        -- Memaksa player menatap ke arah batu (Aim Fix)
                        local finalCFrame = CFrame.lookAt(targetPos, rockPos)

                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local dist = (hrp.Position - targetPos).Magnitude

                            -- Jika jauh, Tween dulu
                            if dist > 2 then
                                SetAnchor(false)
                                TweenTo(finalCFrame)
                            else
                                -- Jika dekat, teleport paksa biar presisi
                                hrp.CFrame = finalCFrame
                            end

                            -- Bekukan posisi (Anti-Jitter)
                            SetAnchor(true)
                        end

                        -- Attack
                        local isReady = EquipToolByName(getgenv().TargetMineName)
                        if isReady then
                            pcall(function()
                                local args = { getgenv().TargetMineName }
                                game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.ToolService.RF
                                    .ToolActivated:InvokeServer(unpack(args))
                            end)
                        end
                    else
                        -- Jika tidak ada target
                        SetAnchor(false)
                        WindUI:Notify({ Title = "Warning", Content = "No rocks found!", Duration = 1 })
                        task.wait(2)
                    end

                    task.wait(0.1)
                end

                SetAnchor(false)
            end)
        end
    end
})
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
