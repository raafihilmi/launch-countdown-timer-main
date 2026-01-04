local WindUI = loadstring(game:HttpGet("https://pastebin.com/raw/m8P8dLfd"))()
-- ============================================
-- CONFIGURATION MODULE
-- ============================================
local Config = {
    Window = {
        Title = "BAP by JumantaraHub",
        Icon = "flask",
        Author = "JumantaraHub",
        Theme = "Plant",
        Folder = "BAP_JumantaraHub",
    },
    OpenButton = {
        Title = "Open Menu",
        Icon = "menu",
        CornerRadius = UDim.new(0, 16),
        StrokeThickness = 2,
        Color = ColorSequence.new(Color3.fromHex("833AB4"), Color3.fromHex("FD1D1D")),
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
    }
}

-- ============================================
-- SERVICES MODULE
-- ============================================
local Services = {
    Players = game:GetService("Players"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    Workspace = game:GetService("Workspace"),
    RunService = game:GetService("RunService"),
    HttpService = game:GetService("HttpService"),
    UserInputService = game:GetService("UserInputService"), -- NEW
    VirtualInputManager = game:GetService("VirtualInputManager"),
}

local LocalPlayer = Services.Players.LocalPlayer

-- ============================================
-- STATE MANAGER
-- ============================================
local State = {
    AutoFarm = false,
    AttackDelay = 0.1,
    SearchRange = 1000,
    UseKiting = true,
    SafeRadius = 25,
    FaceTarget = true,

    WalkSpeed = 16,
    IsFarming = false,
    AutoBrew = false,
    BrewTargetCauldron = "All",
    IngredientSource = "Backpack",
    SelectedRarity = "All",

    AddItemDelay = 0.5,
    BrewActionDelay = 1,
    MinigameDuration = 9.5,

    IsBrewing = {},
    AutoSellPotion = false,
    ReverseAttackDirection = true,
    AttackAngleOffset = 180,
}

-- ============================================
-- UI REFERENCES
-- ============================================
local UIRefs = {
    AutoFarmToggle = nil
}

-- ============================================
-- GAME SPECIFIC VARIABLES
-- ============================================
local Remote = Services.ReplicatedStorage.Modules.Utility.Network.Events.RemoteEvent
local EnemiesFolder = Services.Workspace:WaitForChild("World"):WaitForChild("RenderedEnemies")
local ItemDataModule = require(Services.ReplicatedStorage.Modules.Data.Items)
-- ============================================
-- UTILITY FUNCTIONS
-- ============================================
local Utilities = {}

-- Fungsi Kirim Remote dengan Timestamp Server
function Utilities.FireRemote(actionName, args)
    Remote:FireServer(
        actionName,
        args,
        Services.Workspace:GetServerTimeNow()
    )
end

-- Fungsi Mencari Musuh Terdekat
function Utilities.GetTarget()
    local nearestEnemy = nil
    local minDistance = State.SearchRange
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if not myRoot then return nil end

    for _, enemy in pairs(EnemiesFolder:GetChildren()) do
        local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")

        if enemyRoot then
            -- Cek Attribute Health (agar tidak mengejar yang sudah mati)
            local health = enemy:GetAttribute("Health")
            local isAlive = true
            if health and health <= 0 then isAlive = false end

            if isAlive then
                local dist = (myRoot.Position - enemyRoot.Position).Magnitude
                if dist < minDistance then
                    minDistance = dist
                    nearestEnemy = enemyRoot
                end
            end
        end
    end

    return nearestEnemy
end

-- Helper: Cari Prompt Cauldron
function Utilities.GetCauldronPrompt(cauldronName)
    local plotName = LocalPlayer:GetAttribute("Plot")
    if not plotName then return nil end

    local plot = Services.Workspace.World.Plots:FindFirstChild(plotName)
    if not plot then return nil end

    for _, descendant in pairs(plot:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") and descendant:GetAttribute("Type") == "Cauldron" then
            if descendant.Parent.Name == cauldronName then
                return descendant
            end
        end
    end
    return nil
end

-- Helper: Jalan ke Lokasi
function Utilities.WalkTo(position)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not (hum and root) then return end

    hum:MoveTo(position)

    -- Tunggu sampai dekat (Timeout 8 detik)
    local t = 0
    while t < 8 do
        if (root.Position - position).Magnitude <= 6 then return true end
        task.wait(0.1)
        t = t + 0.1
    end
    return false
end

-- Helper: Cari Bahan (Dengan Filter Potion, Chest, DAN Rarity)
function Utilities.GetIngredient()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return nil end

    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and tool:GetAttribute("ID") then
            -- 1. Filter Pengecualian (Jangan ambil Potion jadi atau Chest)
            if not string.find(tool.Name, "Potion") and not string.find(tool.Name, "Chest") then
                -- 2. Filter Rarity
                if State.SelectedRarity == "All" then
                    return tool -- Jika pilih All, langsung ambil
                else
                    -- Cek data item dari Module Game
                    local data = ItemDataModule:GetData(tool.Name)
                    if data and data.Data and data.Data.Rarity == State.SelectedRarity then
                        return tool -- Ambil hanya jika Rarity cocok
                    end
                end
            end
        end
    end
    return nil
end

-- Fungsi Mengambil Data Cauldron Pemain (Status, Isi, Waktu)
function Utilities.GetCauldronData(cauldronName)
    local mainData = LocalPlayer:WaitForChild("Data"):WaitForChild("MainData")
    local plotData = mainData:WaitForChild("PlotData")
    return plotData:FindFirstChild(cauldronName)
end

-- ============================================
-- BREWING LOGIC MODULE
-- ============================================
local Brewing = {}

function Brewing.ProcessCauldron(cauldronName)
    if not State.AutoBrew then return end

    -- 1. Ambil Data
    local cData = Utilities.GetCauldronData(cauldronName)
    local cPrompt = Utilities.GetCauldronPrompt(cauldronName)

    if not cData or not cPrompt then return end
    if not cData.Unlocked.Value then return end

    local cModel = cPrompt.Parent
    local isCooking = cData.Cooking.Value
    local timeRemaining = cData.TimeRemaining.Value
    local itemsJson = cData.Items.Value
    local itemsTable = Services.HttpService:JSONDecode(itemsJson)
    local count = #itemsTable
    local capacity = 5 + cData.Boost.Value

    -- KONDISI 1: SEDANG MASAK
    if isCooking then
        if timeRemaining <= 0 then
            -- Claim Potion
            -- Ganti Notify dengan Print agar tidak error font
            print("[AutoBrew] Claiming " .. cauldronName)

            -- Jalan ke Cauldron dulu biar aman
            Utilities.WalkTo(cModel.Position)

            -- Remote Claim
            Utilities.FireRemote("ClaimPotion", { cauldronName, cModel })
            task.wait(1.5)
        end
        return -- Keluar agar tidak lanjut ke logika isi item
    end

    -- KONDISI 2: BELUM PENUH (Isi Bahan)
    if count < capacity then
        local item = Utilities.GetIngredient()
        if item then
            -- Jalan ke Cauldron
            Utilities.WalkTo(cModel.Position)

            -- Equip Item
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if hum then
                hum:EquipTool(item)
                task.wait(0.3) -- Animasi Equip

                -- Tekan E (Proximity Prompt)
                if cPrompt and cPrompt.Parent then
                    fireproximityprompt(cPrompt)
                    -- Ganti Notify dengan Print
                    print("[AutoBrew] Added " .. item.Name .. " to " .. cauldronName)
                end

                task.wait(State.AddItemDelay)

                -- Unequip jika item masih ada (gagal masuk)
                if item.Parent == LocalPlayer.Character then
                    hum:UnequipTools()
                end
            end
        end

        -- KONDISI 3: SUDAH PENUH (Start Brew)
    elseif count >= 2 then
        -- Ganti Notify dengan Print
        print("[AutoBrew] Starting Brew " .. cauldronName)

        -- 1. Konfirmasi Brew
        Utilities.FireRemote("ConfirmBrew", { cauldronName, cModel })

        -- 2. Tunggu Minigame (Pura-pura main)
        -- Kita pakai print saja biar aman
        print("[AutoBrew] Playing minigame...")
        task.wait(State.MinigameDuration)

        -- 3. Selesaikan Minigame (Score 5)
        Utilities.FireRemote("FinishedBrewMinigame", { cauldronName, cModel, 2.5 })
        task.wait(1)
    end
end

function Brewing.StartLoop()
    task.spawn(function()
        while State.AutoBrew do
            -- Loop Cauldron satu per satu (Sequential) agar karakter tidak bingung jalan kemana
            local plotData = LocalPlayer:WaitForChild("Data"):WaitForChild("MainData"):WaitForChild("PlotData")

            for _, child in pairs(plotData:GetChildren()) do
                if not State.AutoBrew then break end

                if string.find(child.Name, "Cauldron") then
                    Brewing.ProcessCauldron(child.Name)
                    task.wait(0.5) -- Jeda antar cauldron
                end
            end

            task.wait(1)
        end
    end)
end

-- ============================================
-- FARMING LOGIC MODULE
-- ============================================
local Farming = {}

function Farming.KiteLogic(targetRoot)
    if not State.UseKiting then return end

    local char = LocalPlayer.Character
    if not char then return end

    local myRoot = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")

    if myRoot and humanoid and targetRoot then
        local enemyPos = targetRoot.Position
        local myPos = myRoot.Position

        -- Hitung jarak dan vektor
        local distance = (myPos - enemyPos).Magnitude
        local direction = (enemyPos - myPos).Unit

        -- Logika Gerak (Mundur/Maju)
        if distance < State.SafeRadius then
            -- Mundur jika terlalu dekat
            local retreatPos = myPos - (direction * 8)
            humanoid:MoveTo(retreatPos)
        elseif distance > (State.SafeRadius + 5) then
            -- Maju jika terlalu jauh
            humanoid:MoveTo(enemyPos)
        end

        -- Hadapkan karakter ke musuh
        if State.FaceTarget then
            myRoot.CFrame = CFrame.lookAt(
                myRoot.Position,
                Vector3.new(enemyPos.X, myRoot.Position.Y, enemyPos.Z)
            )
        end
    end
end

function Farming.StartLoop()
    task.spawn(function()
        while State.AutoFarm do
            State.IsFarming = true

            WindUI:Notify({ Title = "System", Content = "Starting New Cycle...", Duration = 1 })

            -- 1. Masuk Lobby
            Utilities.FireRemote("StartLobby", nil)
            task.wait(1.5)
            if not State.AutoFarm then break end

            -- 2. Mulai Game
            Utilities.FireRemote("StartGame", nil)
            WindUI:Notify({ Title = "Game Start", Content = "Entering Combat Mode!", Duration = 2 })
            task.wait(1)

            -- 3. Loop Combat
            local isDead = false

            while State.AutoFarm do
                -- Cek Kematian
                if LocalPlayer:GetAttribute("Dead") == true then
                    isDead = true
                    WindUI:Notify({ Title = "Status", Content = "Player Dead. Resetting...", Duration = 2 })
                    break
                end

                local targetRoot = Utilities.GetTarget()

                if targetRoot then
                    -- Jalankan Kiting
                    Farming.KiteLogic(targetRoot)

                    -- AUTO AIM akan handle cursor movement secara otomatis
                    -- Remote attack akan mengikuti posisi kursor
                    local attackCFrame = targetRoot.CFrame
                    if State.ReverseAttackDirection then
                        -- Balik 180 derajat
                        local pos = targetRoot.CFrame.Position
                        local lookVec = -targetRoot.CFrame.LookVector
                        attackCFrame = CFrame.lookAt(pos, pos + lookVec)
                        print("[Farming] Reversing attack direction")
                    end
                    local attackArgs = { attackCFrame }
                    Utilities.FireRemote("UseMove", attackArgs)
                end

                task.wait(State.AttackDelay)
            end

            if not State.AutoFarm then break end

            -- 4. Reset Logic
            if isDead then
                task.wait(2)
                Utilities.FireRemote("LeaveDeathGame", nil)
                task.wait(1.5)
                Utilities.FireRemote("LeaveLobby", nil)
            end

            task.wait(3)
        end

        State.IsFarming = false
    end)
end

-- ============================================
-- PLAYER LOGIC MODULE
-- ============================================
local PlayerLogic = {}

-- WalkSpeed Loop
task.spawn(function()
    while true do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if State.WalkSpeed > 16 then
                LocalPlayer.Character.Humanoid.WalkSpeed = State.WalkSpeed
            end
        end
        task.wait(0.5)
    end
end)

-- ============================================
-- MAIN UI CREATION
-- ============================================
local Window = WindUI:CreateWindow(Config.Window)
Window:EditOpenButton(Config.OpenButton)

-- TAB ORDER
local MainTab = Window:Tab({ Title = "Auto Farm", Icon = "swords" })
local SellPotionTab = Window:Tab({ Title = "Sell Potion", Icon = "coin" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

-- ============================================
-- MAIN TAB (FARM)
-- ============================================
local FarmSection = MainTab:Section({ Title = "Combat Loop" })

UIRefs.AutoFarmToggle = FarmSection:Toggle({
    Title = "Auto Farm",
    Desc = "Auto Join -> Kill -> Die -> Repeat",
    Value = false,
    Callback = function(Value)
        State.AutoFarm = Value
        if Value then
            Farming.StartLoop()
        else
            WindUI:Notify({ Title = "System", Content = "Stopping Farm (Wait for current loop)...", Duration = 2 })
        end
    end
})

FarmSection:Slider({
    Title = "Attack Delay",
    Desc = "Time between hits (Lower = Faster)",
    Value = { Min = 0.05, Max = 1, Default = 0.1 },
    Step = 0.05,
    Callback = function(Value)
        State.AttackDelay = Value
    end
})

local KiteSection = MainTab:Section({ Title = "Kiting / Movement" })

KiteSection:Toggle({
    Title = "Enable Kiting",
    Desc = "Keep safe distance from enemies",
    Value = true,
    Callback = function(Value)
        State.UseKiting = Value
    end
})

KiteSection:Toggle({
    Title = "Face Target",
    Desc = "Character always looks at enemy",
    Value = true,
    Callback = function(Value)
        State.FaceTarget = Value
    end
})

KiteSection:Slider({
    Title = "Safe Radius",
    Desc = "Distance to keep from enemies",
    Value = { Min = 10, Max = 50, Default = 25 },
    Step = 1,
    Callback = function(Value)
        State.SafeRadius = Value
    end
})
local BrewSection = MainTab:Section({ Title = "Potion Brewing" })

BrewSection:Toggle({
    Title = "Auto Brew Potion",
    Desc = "Auto Add Ingredients -> Brew -> Claim",
    Value = false,
    Callback = function(Value)
        State.AutoBrew = Value
        if Value then
            Brewing.StartLoop()
        else
            WindUI:Notify({ Title = "System", Content = "Stopping Auto Brew...", Duration = 2 })
        end
    end
})
BrewSection:Dropdown({
    Title = "Item Rarity Filter",
    Desc = "Only brew items with this rarity",
    Values = { "All", "Common", "Uncommon", "Rare", "Epic", "Legendary" },
    Value = "All",
    Callback = function(Value)
        State.SelectedRarity = Value
        print("[Settings] Rarity Filter set to:", Value)
    end
})
BrewSection:Slider({
    Title = "Add Item Delay",
    Desc = "Time between adding ingredients",
    Value = { Min = 0.1, Max = 1, Default = 0.5 },
    Step = 0.1,
    Callback = function(Value)
        State.AddItemDelay = Value
    end
})

-- ============================================
-- PLAYER TAB
-- ============================================
local MoveSection = PlayerTab:Section({ Title = "Movement" })

MoveSection:Slider({
    Title = "Walk Speed",
    Desc = "Character movement speed",
    Value = { Min = 16, Max = 100, Default = 16 },
    Step = 1,
    Callback = function(Value)
        State.WalkSpeed = Value
    end
})

-- ============================================
-- SELL POTION TAB
-- ============================================
local SellPotionSection = SellPotionTab:Section({ Title = "Sell Potion" })

SellPotionSection:Toggle({
    Title = "Auto Sell Potion",
    Value = false,
    Callback = function(Value)
        State.AutoSellPotion = Value
        if Value then
            Utilities.FireRemote("SellPotions", {}, Services.Workspace:GetServerTimeNow())
        else
            WindUI:Notify({ Title = "System", Content = "Stopping Auto Brew...", Duration = 2 })
        end
    end
})

-- ============================================
-- SETTINGS TAB
-- ============================================
SettingsTab:Dropdown({
    Title = "UI Theme",
    Values = { "Plant", "Dark", "Rose", "Aqua" },
    Value = "Plant",
    Callback = function(Theme)
        WindUI:SetTheme(Theme)
    end
})

SettingsTab:Keybind({
    Title = "Toggle UI",
    Value = "RightControl",
    Callback = function(Key)
        Window:SetToggleKey(Enum.KeyCode[Key])
    end
})

-- ============================================
-- CLEANUP HANDLER
-- ============================================
Window:OnDestroy(function()
    print("⚠️ Window Closed. Stopping all features...")
    State.AutoFarm = false
    State.AutoBrew = false
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end

    print("✅ [JumantaraHub] Script Unloaded!")
end)

print("✅ [JumantaraHub] Brew a Potion Script Loaded!")
