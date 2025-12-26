local WindUI = loadstring(game:HttpGet("https://pastebin.com/raw/m8P8dLfd"))()


-- [[ MAIN WINDOW CREATION ]] --
local Window = WindUI:CreateWindow({
    Title = "TForge",
    Icon = "gamepad-2",
    Author = "JumantaraHub v11",
    Theme = "Plant",
    Folder = "UniversalScript_v11"
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
getgenv().MineHeight = 5
getgenv().MineDistance = 0
getgenv().TweenSpeed = 50

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
                    -- Cek logic hierarki sesuai gambar/deskripsi:
                    -- SpawnLocation > Ada Model Rock > Ada Part/List
                    local rockModel = spawnLoc:FindFirstChildWhichIsA("Model")

                    if rockModel then
                        -- Ambil posisi target
                        -- Kita gunakan GetPivot() karena lebih universal untuk Model
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

    return nearestRock
end
local function SetAnchor(state)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Anchored = state
    end
end
-- [[ TABS ]] --
local MainSection = Window:Section({ Title = "Main", Icon = "swords" })
local AutoMineTab = MainSection:Tab({ Title = "Auto Mine", Icon = "pickaxe" })
local AutoFightTab = MainSection:Tab({ Title = "Auto Fight", Icon = "swords" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local SettingTab = Window:Tab({ Title = "Settings", Icon = "settings" })

-- [[ MAIN TAB ]] --
AutoFightTab:Toggle({
    Title = "Auto Attack",
    Desc = "Equip 'Weapon' & Attack",
    Value = false,
    Callback = function(Value)
        getgenv().AutoAttack = Value

        if Value then
            task.spawn(function()
                while getgenv().AutoAttack do
                    local isReady = EquipToolByName(getgenv().TargetWeaponName)

                    if isReady then
                        pcall(function()
                            local args = { getgenv().TargetWeaponName }
                            game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.ToolService.RF
                                .ToolActivated:InvokeServer(unpack(args))
                        end)
                    end
                end
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
        -- Kamu perlu menyimpan object dropdown ke variable jika ingin refresh,
        -- tapi untuk simpelnya restart script jika area belum load.
        WindUI:Notify({ Title = "Info", Content = "Please re-execute script to refresh list if needed.", Duration = 2 })
    end
})
MainTab:Toggle({
    Title = "Auto Mine",
    Desc = "Tween -> Anchor -> LookAt -> Mine",
    Value = false,
    Callback = function(Value)
        getgenv().AutoMine = Value

        -- Jika dimatikan, pastikan player jatuh kembali (Unanchor)
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

                        -- [[ LOGIKA POSISI BARU ]] --
                        -- Kita gunakan Vector3 biasa agar "Height" selalu ke atas langit (World Space),
                        -- bukan ke atas kepala rock (Object Space) yang mungkin miring.
                        -- Distance kita asumsikan mundur sedikit dari batu.

                        -- Posisi tujuan: Posisi Batu + Tinggi (Y) + Jarak (Z/Mundur)
                        -- Catatan: Logika jarak sederhana disini saya buat random dikit disekitar batu atau fix offset
                        -- Tapi agar simple dan pasti, kita taruh player di atas batu persis + tinggi

                        local targetPos = rockPos + Vector3.new(0, getgenv().MineHeight, 0)

                        -- [[ LOGIKA ROTASI (SOLUSI MASALAH 1) ]] --
                        -- CFrame.lookAt(PosisiKita, PosisiTarget)
                        -- Ini memaksa player menatap langsung ke pusat batu
                        local finalCFrame = CFrame.lookAt(targetPos, rockPos)

                        -- Cek jarak dulu, kalau jauh baru Tween, kalau sudah dekat langsung teleport/diam
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local dist = (hrp.Position - targetPos).Magnitude
                            if dist > 2 then
                                SetAnchor(false) -- Lepas anchor biar bisa jalan/tween
                                TweenTo(finalCFrame)
                            else
                                -- Kalau sudah dekat, paksa set posisi biar akurat menatap batu
                                hrp.CFrame = finalCFrame
                            end

                            -- [[ SOLUSI MASALAH 2 (JITTER) ]] --
                            -- Bekukan player di udara
                            SetAnchor(true)
                        end

                        -- Equip & Attack
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

                    task.wait(0.1) -- Loop speed lebih cepat agar responsif
                end

                -- Jaga-jaga jika loop pecah, unanchor
                SetAnchor(false)
            end)
        end
    end
})
AutoMineTab:Slider({
    Title = "Tween Speed",
    Desc = "Movement Speed (Higher = Faster)",
    Value = { Min = 10, Max = 300, Default = 50 },
    Step = 5,
    Callback = function(Value)
        getgenv().TweenSpeed = Value
    end
})

AutoMineTab:Slider({
    Title = "Mine Height (Y Offset)",
    Desc = "Position height above/below target",
    Value = { Min = -10, Max = 20, Default = 5 },
    Step = 0.5,
    Callback = function(Value)
        getgenv().MineHeight = Value
    end
})

AutoMineTab:Slider({
    Title = "Mine Distance (Z Offset)",
    Desc = "Distance from center of the rock",
    Value = { Min = -10, Max = 20, Default = 0 },
    Step = 0.5,
    Callback = function(Value)
        getgenv().MineDistance = Value
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
    Value = "Planet",
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
