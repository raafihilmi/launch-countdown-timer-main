local WindUI = loadstring(game:HttpGet("https://pastebin.com/raw/m8P8dLfd"))()


-- [[ MAIN WINDOW CREATION ]] --
local Window = WindUI:CreateWindow({
    Title = "TForge",
    Icon = "gamepad-2",
    Author = "JumantaraHub v7",
    Theme = "Plant",
    Folder = "UniversalScript_v7"
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

-- [[ SERVICES ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

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

-- [[ TABS ]] --
local MainSection = Window:Section({ Title = "Main", Icon = "swords" })
local AutoMineTab = MainSection:Tab({ Title = "Auto Mine", Icon = "pickaxe" })
local AutoFightTab = MainSection:Tab({ Title = "Auto Fight", Icon = "swords" })
-- */  Elements Section  /* --
local ElementsSection = Window:Section({
    Title = "Elements",
})

local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local SettingTab = Window:Tab({ Title = "Settings", Icon = "settings" })

-- [[ MAIN TAB ]] --
-- Masukan di Section Combat / Main Tab
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
AutoMineTab:Toggle({
    Title = "Auto Mine",
    Desc = "Equip 'Pickaxe' & Mining",
    Value = false,
    Callback = function(Value)
        getgenv().AutoMine = Value

        if Value then
            task.spawn(function()
                while getgenv().AutoMine do
                    local isReady = EquipToolByName(getgenv().TargetMineName)

                    if isReady then
                        pcall(function()
                            local args = { getgenv().TargetMineName }
                            game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.ToolService.RF
                                .ToolActivated:InvokeServer(unpack(args))
                        end)
                    end
                end
            end)
        end
    end
})

-- [[ PLAYER TAB ]] --
local SectionMove = PlayerTab:Section({ Title = "Movement" })

-- FITUR BARU: AUTO RUN
local SectionGroup1 = PlayerTab:Group({})
SectionGroup1:Toggle({
    Title = "Auto Run (Knit)",
    Desc = "Auto Sprint using Remote",
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
    Desc = "Walk through walls",
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
