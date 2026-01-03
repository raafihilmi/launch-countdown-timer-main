local WindUI = loadstring(game:HttpGet("https://pastebin.com/raw/m8P8dLfd"))()

-- ============================================
-- CONFIGURATION MODULE
-- ============================================
local Config = {
    Window = {
        Title = "DTE",
        Icon = "shovel",
        Author = "JumantaraHub DTE v2",
        Theme = "Plant",
        Folder = "Jumantara_DTE_v2"
    },
    OpenButton = {
        Title = "Open Menu",
        Icon = "menu",
        CornerRadius = UDim.new(0, 16),
        StrokeThickness = 2,
        Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
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
    RunService = game:GetService("RunService")
}

local LocalPlayer = Services.Players.LocalPlayer

-- ============================================
-- STATE MANAGER
-- ============================================
local State = {
    AutoDig = false,
    AutoSell = false,
    AutoPickup = false,
    DigSpeed = 0.1,
    PickupSpeed = 0.5,
    TargetSellName = "Seller",
    MiningPos = CFrame.new(-56.4173355, -7.15000248, 58.1000633),
    SellerPos = CFrame.new(84.3216019, -6.86413288, -8.73450851),
    IsSelling = false,
    PickupRange = 25,
    DigRadius = 10,
    ShowDigRadius = false,
    AutoEat = false,
    AutoEatDelay = 5,
    AntiGuard = false,
    GuardSafeDistance = 20,
    TargetConsumables = {
        "Chicken", "Chips", "Soda",
        "Burger", "Donut", "Hot Dog", "Energy Booster"
    },
    TargetTools = {
        "Big Shovel", "Trowel", "Spatula", "Toy Shovel", "Spoon"
    },
    WalkSpeed = 30,
    FlyEnabled = false,
    FlySpeed = 50,
    EspPlayer = false,
    EspItem = false,
    AutoUseFood = false,
    SelectedTPNPC = nil,
    AutoTPNPC = false,
}

-- ============================================
-- UI REFERENCES (Untuk sinkronisasi toggle)
-- ============================================
local UIRefs = {
    AutoDigToggle = nil,
    AutoPickupToggle = nil,
    AutoSellToggle = nil
}

-- ============================================
-- VISUALS MODULE
-- ============================================
local Visuals = {
    CirclePart = nil
}

function Visuals.UpdateRadius()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if State.ShowDigRadius and hrp then
        if not Visuals.CirclePart then
            local part = Instance.new("Part")
            part.Name = "DigRadiusVisual"
            part.Shape = Enum.PartType.Cylinder
            part.Color = Color3.fromRGB(255, 0, 0)
            part.Material = Enum.Material.Neon
            part.Transparency = 0.7
            part.Anchored = true
            part.CanCollide = false
            part.CastShadow = false
            part.Parent = Services.Workspace
            Visuals.CirclePart = part
        end

        local diameter = State.DigRadius * 2
        Visuals.CirclePart.Size = Vector3.new(0.2, diameter, diameter)
        Visuals.CirclePart.CFrame = hrp.CFrame * CFrame.new(0, -2.8, 0) * CFrame.Angles(0, 0, math.rad(90))
    else
        if Visuals.CirclePart then
            Visuals.CirclePart:Destroy()
            Visuals.CirclePart = nil
        end
    end
end

Services.RunService.RenderStepped:Connect(Visuals.UpdateRadius)

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================
local Utilities = {}

function Utilities.GetEquippedTool()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local backpack = LocalPlayer.Backpack

    if not char or not hum then return nil end

    local currentTool = char:FindFirstChildWhichIsA("Tool")
    if currentTool then return currentTool end

    for _, toolName in ipairs(State.TargetTools) do
        local tool = backpack:FindFirstChild(toolName)
        if tool then
            hum:EquipTool(tool)
            return tool
        end
    end

    local anyTool = backpack:FindFirstChildWhichIsA("Tool")
    if anyTool then
        hum:EquipTool(anyTool)
        return anyTool
    end

    return nil
end

Utilities.RarityColors = {
    ["Common"] = Color3.fromRGB(255, 255, 255),
    ["Uncommon"] = Color3.fromRGB(30, 200, 60),
    ["Rare"] = Color3.fromRGB(0, 190, 255),
    ["Epic"] = Color3.fromRGB(180, 70, 255),
    ["Legendary"] = Color3.fromRGB(255, 170, 0),
    ["Mythic"] = Color3.fromRGB(255, 0, 0)
}

-- ============================================
-- FARMING FUNCTIONS
-- ============================================
local Farming = {}

function Farming.DoEat()
    local backpack = LocalPlayer.Backpack
    local char = LocalPlayer.Character
    local foodTool = nil

    for _, foodName in pairs(State.TargetConsumables) do
        if char then foodTool = char:FindFirstChild(foodName) end
        if not foodTool and backpack then
            foodTool = backpack:FindFirstChild(foodName)
        end
        if foodTool then break end
    end

    if foodTool then
        local args = { "UseTool", foodTool }
        Services.ReplicatedStorage.Events.GameEvent:FireServer(unpack(args))
    end
end

function Farming.CheckGuardSafety()
    if not State.AntiGuard then return end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local map = Services.Workspace:FindFirstChild("Map")
    local functional = map and map:FindFirstChild("Functional")
    local npcFolder = functional and functional:FindFirstChild("SpawnedNPCs")
    local guard = npcFolder and npcFolder:FindFirstChild("Guard")

    if guard then
        local guardRoot = guard:FindFirstChild("HumanoidRootPart") or guard.PrimaryPart
        if guardRoot then
            local dist = (hrp.Position - guardRoot.Position).Magnitude

            if dist <= State.GuardSafeDistance then
                if State.AutoDig then
                    -- 1. Matikan Auto Dig
                    State.AutoDig = false

                    -- 2. Update toggle UI agar sinkron
                    if UIRefs.AutoDigToggle and UIRefs.AutoDigToggle.Set then
                        UIRefs.AutoDigToggle:Set(false)
                    end

                    -- 3. Tekan "F" (Virtual Input Manager)
                    local vim = game:GetService("VirtualInputManager")
                    vim:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                    task.wait(0.1)
                    vim:SendKeyEvent(false, Enum.KeyCode.F, false, game)

                    -- 4. Notifikasi Bahaya
                    WindUI:Notify({
                        Title = "GUARD DETECTED!",
                        Content = "Stopped digging & Exited hole!",
                        Duration = 5,
                        Type = "Warning"
                    })

                    warn("[SAFETY] Guard detected within " .. math.floor(dist) .. " studs! AutoDig disabled.")
                end
            end
        end
    end
end

Services.RunService.Heartbeat:Connect(Farming.CheckGuardSafety)

function Farming.DoDig()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local tool = Utilities.GetEquippedTool()
    if not tool then
        if not _G.ToolWarned then
            warn("[DEBUG] Tool tidak ditemukan! Pastikan kamu punya 'Spoon' di inventory.")
            _G.ToolWarned = true
        end
        return
    end
    _G.ToolWarned = false

    local targetPos
    local targetMaterial = Enum.Material.Grass

    if State.DigRadius > 0 then
        local angle = math.random() * math.pi * 2
        local radius = math.random() * State.DigRadius
        local offsetX = math.cos(angle) * radius
        local offsetZ = math.sin(angle) * radius

        local rayOrigin = hrp.Position + Vector3.new(offsetX, 5, offsetZ)
        local rayDirection = Vector3.new(0, -20, 0)

        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = { char, Visuals.CirclePart, Services.Workspace:FindFirstChild("Map") }
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude

        local rayResult = Services.Workspace:Raycast(rayOrigin, rayDirection, raycastParams)

        if rayResult then
            targetPos = rayResult.Position
            targetMaterial = rayResult.Material
        else
            targetPos = hrp.Position + Vector3.new(offsetX, -3.5, offsetZ)
        end
    else
        targetPos = hrp.Position + Vector3.new(0, -3.5, 0)
        local rayResult = Services.Workspace:Raycast(hrp.Position, Vector3.new(0, -10, 0))
        if rayResult then targetMaterial = rayResult.Material end
    end

    local args = {
        "UseTool",
        tool,
        Services.Workspace.Terrain,
        targetPos,
        Vector3.yAxis,
        targetMaterial
    }

    local success, err = pcall(function()
        Services.ReplicatedStorage.Events.GameFunction:InvokeServer(unpack(args))
    end)

    if not success then
        warn("[DEBUG] Gagal Digging: " .. tostring(err))
    end
end

function Farming.DoPickup()
    local map = Services.Workspace:FindFirstChild("Map")
    local functional = map and map:FindFirstChild("Functional")
    local spawnedItems = functional and functional:FindFirstChild("SpawnedItems")

    if not spawnedItems then return end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    local hiddenStats = LocalPlayer:FindFirstChild("hiddenstats")
    if hiddenStats then
        local current = hiddenStats:FindFirstChild("CurrentSackSize")
        local max = hiddenStats:FindFirstChild("MaxSackSize")

        if current and max and current.Value >= max.Value then
            WindUI:Notify({
                Title = "Sack Full!",
                Content = "Auto Selling items...",
                Duration = 3,
                Type = "Warning"
            })
            Farming.ProcessSelling()
            return
        end
    end

    if not hrp then return end

    local rarityPriority = { "Mythic", "Legendary", "Epic", "Rare", "Uncommon", "Common" }

    for _, rarityName in ipairs(rarityPriority) do
        local rarityFolder = spawnedItems:FindFirstChild(rarityName)
        if rarityFolder then
            for _, itemModel in pairs(rarityFolder:GetChildren()) do
                if itemModel:IsA("Model") then
                    local uid = itemModel:GetAttribute("UID")
                    local digzoneUid = itemModel:GetAttribute("DigzoneUID")
                    local itemRoot = itemModel:FindFirstChild("Root") or itemModel.PrimaryPart

                    if uid and digzoneUid and itemRoot then
                        if (hrp.Position - itemRoot.Position).Magnitude <= State.PickupRange then
                            hrp.CFrame = itemRoot.CFrame
                            task.wait(0.15)

                            local args = { "PickupDigItem", uid, digzoneUid }
                            Services.ReplicatedStorage.Events.GameEvent:FireServer(unpack(args))
                            itemModel:Destroy()

                            task.wait(0.75)
                            if not State.AutoPickup then return end
                        end
                    end
                end
            end
        end
    end
end

function Farming.ProcessSelling()
    if State.IsSelling then return end
    State.IsSelling = true

    local char = LocalPlayer.Character
    if not char then
        State.IsSelling = false; return
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        State.IsSelling = false; return
    end

    WindUI:Notify({ Title = "Auto Sell", Content = "Teleporting to Seller...", Duration = 2 })
    hrp.CFrame = State.SellerPos
    task.wait(0.3)

    local map = Services.Workspace:FindFirstChild("Map")
    local functional = map and map:FindFirstChild("Functional")
    local spawnedNPCs = functional and functional:FindFirstChild("SpawnedNPCs")
    local seller = spawnedNPCs and spawnedNPCs:FindFirstChild("Seller")

    if seller then
        local rightArm = seller:FindFirstChild("Right Arm")
        local attach = rightArm and rightArm:FindFirstChild("RightGripAttachment")
        local prompt = attach and attach:FindFirstChild("BuyPrompt")

        if prompt then
            fireproximityprompt(prompt)
            task.wait(0.1)
            fireproximityprompt(prompt)
            WindUI:Notify({ Title = "Auto Sell", Content = "Items sold!", Duration = 2 })
        else
            warn("BuyPrompt tidak ditemukan di Right Arm NPC")
        end
    else
        warn("NPC Seller tidak ditemukan di Map/Functional/SpawnedNPCs")
    end

    task.wait(0.2)
    hrp.CFrame = State.MiningPos
    WindUI:Notify({ Title = "Auto Sell", Content = "Returned to mining area.", Duration = 2 })

    State.IsSelling = false
end

-- ============================================
-- PLAYER LOGIC
-- ============================================
local PlayerLogic = {}
local FlyBody = nil
local FlyGyro = nil

function PlayerLogic.ToggleFly(state)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if state and hrp and hum then
        FlyBody = Instance.new("BodyVelocity")
        FlyBody.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        FlyBody.Velocity = Vector3.zero
        FlyBody.Parent = hrp

        FlyGyro = Instance.new("BodyGyro")
        FlyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        FlyGyro.P = 10000
        FlyGyro.D = 100
        FlyGyro.CFrame = hrp.CFrame
        FlyGyro.Parent = hrp

        hum.PlatformStand = true

        task.spawn(function()
            while State.FlyEnabled and char and char.Parent do
                local cam = Services.Workspace.CurrentCamera
                local moveDir = Vector3.zero
                local isMoving = false
                local userInput = game:GetService("UserInputService")

                if userInput:IsKeyDown(Enum.KeyCode.W) then
                    moveDir = moveDir + cam.CFrame.LookVector
                    isMoving = true
                end
                if userInput:IsKeyDown(Enum.KeyCode.S) then
                    moveDir = moveDir - cam.CFrame.LookVector
                    isMoving = true
                end
                if userInput:IsKeyDown(Enum.KeyCode.A) then
                    moveDir = moveDir - cam.CFrame.RightVector
                    isMoving = true
                end
                if userInput:IsKeyDown(Enum.KeyCode.D) then
                    moveDir = moveDir + cam.CFrame.RightVector
                    isMoving = true
                end
                if userInput:IsKeyDown(Enum.KeyCode.Space) then
                    moveDir = moveDir + Vector3.new(0, 1, 0)
                    isMoving = true
                end
                if userInput:IsKeyDown(Enum.KeyCode.LeftControl) then
                    moveDir = moveDir - Vector3.new(0, 1, 0)
                    isMoving = true
                end

                if isMoving then
                    FlyBody.Velocity = moveDir * State.FlySpeed
                    FlyGyro.CFrame = cam.CFrame
                else
                    FlyBody.Velocity = Vector3.zero
                    FlyGyro.CFrame = cam.CFrame
                end
                task.wait()
            end
        end)
    else
        if FlyBody then
            FlyBody:Destroy(); FlyBody = nil
        end
        if FlyGyro then
            FlyGyro:Destroy(); FlyGyro = nil
        end
        if hum then hum.PlatformStand = false end
    end
end

function PlayerLogic.UpdatePlayerESP()
    local folder = Services.Workspace:FindFirstChild("JumantaraESP_Players") or
        Instance.new("Folder", Services.Workspace)
    folder.Name = "JumantaraESP_Players"
    folder:ClearAllChildren()

    if not State.EspPlayer then return end

    for _, plr in pairs(Services.Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local char = plr.Character
            local hl = Instance.new("Highlight")
            hl.Name = plr.Name
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            hl.Adornee = char
            hl.Parent = folder

            local head = char:FindFirstChild("Head")
            if head then
                local bg = Instance.new("BillboardGui")
                bg.Size = UDim2.new(0, 200, 0, 50)
                bg.StudsOffset = Vector3.new(0, 3, 0)
                bg.AlwaysOnTop = true
                bg.Adornee = head
                bg.Parent = folder

                local lbl = Instance.new("TextLabel", bg)
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = plr.Name
                lbl.TextColor3 = Color3.new(1, 1, 1)
                lbl.TextStrokeTransparency = 0
                lbl.TextSize = 14
            end
        end
    end
end

function PlayerLogic.UpdateItemESP()
    local folder = Services.Workspace:FindFirstChild("JumantaraESP_Items") or Instance.new("Folder", Services.Workspace)
    folder.Name = "JumantaraESP_Items"
    folder:ClearAllChildren()

    if not State.EspItem then return end

    local map = Services.Workspace:FindFirstChild("Map")
    local functional = map and map:FindFirstChild("Functional")
    local spawnedItems = functional and functional:FindFirstChild("SpawnedItems")

    if not spawnedItems then return end

    for _, rarityFolder in pairs(spawnedItems:GetChildren()) do
        if rarityFolder:IsA("Folder") then
            local color = Utilities.RarityColors[rarityFolder.Name] or Color3.new(1, 1, 1)

            for _, item in pairs(rarityFolder:GetChildren()) do
                if item:IsA("Model") then
                    local root = item:FindFirstChild("Root") or item.PrimaryPart
                    if root then
                        local bg = Instance.new("BillboardGui")
                        bg.Size = UDim2.new(0, 100, 0, 40)
                        bg.StudsOffset = Vector3.new(0, 2, 0)
                        bg.AlwaysOnTop = true
                        bg.Adornee = root
                        bg.Parent = folder

                        local lbl = Instance.new("TextLabel", bg)
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.Text = item.Name
                        lbl.TextColor3 = color
                        lbl.TextStrokeTransparency = 0
                        lbl.Font = Enum.Font.Bold
                        lbl.TextSize = 12
                    end
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        if State.EspPlayer then PlayerLogic.UpdatePlayerESP() end
        if State.EspItem then PlayerLogic.UpdateItemESP() end
        task.wait(2)
    end
end)

-- ============================================
-- MAIN UI CREATION
-- ============================================
local Window = WindUI:CreateWindow(Config.Window)
Window:EditOpenButton(Config.OpenButton)

-- TAB ORDER: Main > Safety > Instant Ending > TP NPC > Player > Setting
local MainTab = Window:Tab({ Title = "Main Farm", Icon = "pickaxe" })
local SafetyTab = Window:Tab({ Title = "Safety & Food", Icon = "shield" })
local EndingTab = Window:Tab({ Title = "Instant Ending", Icon = "fast-forward" })
local TpNpcTab = Window:Tab({ Title = "TP NPC", Icon = "map-pin" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

-- ============================================
-- MAIN TAB
-- ============================================
local DigSection = MainTab:Section({ Title = "Digging" })

-- Simpan reference ke toggle AutoDig untuk sinkronisasi
UIRefs.AutoDigToggle = DigSection:Toggle({
    Title = "Auto Dig",
    Desc = "Automatically dig within radius",
    Value = false,
    Callback = function(Value)
        State.AutoDig = Value
        if Value then
            task.spawn(function()
                while State.AutoDig do
                    if not State.IsSelling then
                        if State.AutoUseFood then
                            local hiddenStats = LocalPlayer:FindFirstChild("hiddenstats")
                            local energy = hiddenStats and hiddenStats:FindFirstChild("NormalizedEnergy")
                            if energy and energy.Value <= 0 then
                                Farming.DoEat()
                                task.wait(1)
                            end
                        end
                        Farming.DoDig()
                    end
                    task.wait(State.DigSpeed)
                end
            end)
        end
    end
})

DigSection:Toggle({
    Title = "Smart Auto Eat",
    Desc = "Auto eat when Energy is 0",
    Value = false,
    Callback = function(Value)
        State.AutoUseFood = Value
    end
})

DigSection:Slider({
    Title = "Dig Radius",
    Desc = "Area size around player",
    Value = { Min = 0, Max = 30, Default = 10 },
    Step = 1,
    Callback = function(Value)
        State.DigRadius = Value
    end
})

DigSection:Toggle({
    Title = "Show Radius Visual",
    Desc = "Display red circle for digging area",
    Value = false,
    Callback = function(Value)
        State.ShowDigRadius = Value
    end
})

DigSection:Slider({
    Title = "Dig Speed",
    Desc = "Delay between digs (Seconds)",
    Value = { Min = 0.15, Max = 1, Default = 0.25 },
    Step = 0.05,
    Callback = function(Value)
        State.DigSpeed = Value
    end
})

local PickupSection = MainTab:Section({ Title = "Auto Pickup Item" })

UIRefs.AutoPickupToggle = PickupSection:Toggle({
    Title = "Auto Pickup",
    Desc = "Scans & Pickup Item",
    Value = false,
    Callback = function(Value)
        State.AutoPickup = Value
        if Value then
            task.spawn(function()
                while State.AutoPickup do
                    if not State.IsSelling then
                        Farming.DoPickup()
                    end
                    task.wait(State.PickupSpeed)
                end
            end)
        end
    end
})

PickupSection:Slider({
    Title = "Pickup Range",
    Desc = "Max distance to grab items",
    Value = { Min = 10, Max = 100, Default = 25 },
    Step = 5,
    Callback = function(Value)
        State.PickupRange = Value
    end
})

local SellSection = MainTab:Section({ Title = "Selling" })

SellSection:Button({
    Title = "Sell Now (One Time)",
    Desc = "Teleport to seller and back",
    Callback = function()
        task.spawn(Farming.ProcessSelling)
    end
})

UIRefs.AutoSellToggle = SellSection:Toggle({
    Title = "Auto Sell Loop",
    Desc = "Periodically sells items every 30s",
    Value = false,
    Callback = function(Value)
        State.AutoSell = Value
        if Value then
            task.spawn(function()
                while State.AutoSell do
                    task.wait(30)
                    if State.AutoSell then
                        Farming.ProcessSelling()
                    end
                end
            end)
        end
    end
})

local TradeSection = MainTab:Section({ Title = "Trade UI" })

local function GetNPCList()
    local list = {}
    local map = Services.Workspace:FindFirstChild("Map")
    local functional = map and map:FindFirstChild("Functional")
    local npcFolder = functional and functional:FindFirstChild("SpawnedNPCs")

    if npcFolder then
        for _, npc in pairs(npcFolder:GetChildren()) do
            if npc:IsA("Model") then
                table.insert(list, npc.Name)
            end
        end
    end
    return list
end

local npcDropdown = TradeSection:Dropdown({
    Title = "Select NPC",
    Desc = "Choose NPC to open Trade UI",
    Values = GetNPCList(),
    Value = nil,
    Callback = function(npcName)
        if not npcName then return end

        local map = Services.Workspace:FindFirstChild("Map")
        local functional = map and map:FindFirstChild("Functional")
        local npcFolder = functional and functional:FindFirstChild("SpawnedNPCs")
        local targetNPC = npcFolder and npcFolder:FindFirstChild(npcName)

        if targetNPC then
            local Event = Services.ReplicatedStorage.Events.GameEvent

            if firesignal then
                firesignal(Event.OnClientEvent,
                    "ShowTradeUI",
                    targetNPC,
                    "Energy Booster",
                    10
                )
                WindUI:Notify({ Title = "Trade", Content = "UI Opened for " .. npcName, Duration = 2 })
            else
                WindUI:Notify({ Title = "Error", Content = "Executor tidak support 'firesignal'", Duration = 3 })
            end
        else
            WindUI:Notify({ Title = "Error", Content = "NPC tidak ditemukan!", Duration = 2 })
        end
    end
})

TradeSection:Button({
    Title = "Refresh NPC List",
    Desc = "Update the dropdown list",
    Callback = function()
        npcDropdown:SetValues(GetNPCList())
        WindUI:Notify({ Title = "Refreshed", Content = "NPC List updated!", Duration = 1 })
    end
})

local ExtraSection = MainTab:Section({ Title = "Extras" })

ExtraSection:Button({
    Title = "Set Mining Position",
    Desc = "Update return point to current spot",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            State.MiningPos = LocalPlayer.Character.HumanoidRootPart.CFrame
            WindUI:Notify({ Title = "Success", Content = "Mining position updated!", Duration = 2 })
        end
    end
})

-- ============================================
-- SAFETY TAB
-- ============================================
local SafetySection = SafetyTab:Section({ Title = "Night Guard Safety" })

SafetySection:Toggle({
    Title = "Anti-Guard (Auto Exit)",
    Desc = "Press F & Stop Digging if Guard is near",
    Value = false,
    Callback = function(Value)
        State.AntiGuard = Value
    end
})

SafetySection:Slider({
    Title = "Safe Distance",
    Desc = "Distance to trigger escape (Studs)",
    Value = { Min = 10, Max = 50, Default = 20 },
    Step = 1,
    Callback = function(Value)
        State.GuardSafeDistance = Value
    end
})

local FoodSection = SafetyTab:Section({ Title = "Auto Consumables" })

FoodSection:Toggle({
    Title = "Auto Eat/Drink",
    Desc = "Automatically consume Chips/Drinks",
    Value = false,
    Callback = function(Value)
        State.AutoEat = Value
        if Value then
            task.spawn(function()
                while State.AutoEat do
                    Farming.DoEat()
                    task.wait(State.AutoEatDelay)
                end
            end)
        end
    end
})

FoodSection:Slider({
    Title = "Eat Interval",
    Desc = "Seconds between consuming",
    Value = { Min = 1, Max = 60, Default = 5 },
    Step = 1,
    Callback = function(Value)
        State.AutoEatDelay = Value
    end
})

-- ============================================
-- INSTANT ENDING TAB
-- ============================================
local MainEndingSection = EndingTab:Section({ Title = "Main Ending" })

MainEndingSection:Button({
    Title = "Start Ending Sequence",
    Desc = "Auto path -> Walk -> End Trigger",
    Callback = function()
        task.spawn(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            local cam = Services.Workspace.CurrentCamera

            if not hrp or not hum then
                WindUI:Notify({ Title = "Error", Content = "Character not found!", Duration = 2 })
                return
            end

            local sudutAbsolut = 180
            local jarakJalan = 60
            local PosisiAwal = Vector3.new(-53.50029754638672, -7.15000057220459, 56.49897384643555)
            local Posisi1 = Vector3.new(-239.61936950683594, -444.9471130371094, 2773.282470703125)
            local Posisi2 = Vector3.new(-241.4040985107422, -435.1486511230469, 2773.2119140625)
            local Posisi3 = Vector3.new(-32.85221481323242, -518.545166015625, 55.57419204711914)

            WindUI:Notify({ Title = "Instant Ending", Content = "Starting sequence...", Duration = 2 })

            hrp.CFrame = CFrame.new(PosisiAwal)
            task.wait(1)

            hrp.CFrame = CFrame.new(Posisi1)
            task.wait(1)

            hrp.CFrame = CFrame.new(Posisi2)
            task.wait(1)

            hrp.CFrame = CFrame.new(Posisi3)
            task.wait(2)

            WindUI:Notify({ Title = "Instant Ending", Content = "Rotating & Walking...", Duration = 2 })

            if cam then
                cam.CFrame = CFrame.new(cam.CFrame.Position) * CFrame.Angles(0, math.rad(sudutAbsolut), 0)
            end
            hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(sudutAbsolut), 0)
            task.wait(0.2)

            local posisiTujuan = hrp.Position + (hrp.CFrame.LookVector * jarakJalan)
            hum:MoveTo(posisiTujuan)

            WindUI:Notify({ Title = "Instant Ending", Content = "Waiting 11 seconds...", Duration = 10 })
            task.wait(11)

            local success, targetPart = pcall(function()
                return Services.Workspace.Map.Functional.SpawnedChaseSections.EndSection.EndTrigger
            end)

            if success and targetPart then
                hrp.CFrame = targetPart.CFrame
                WindUI:Notify({ Title = "Success", Content = "Teleported to EndTrigger!", Duration = 3 })
            else
                warn("EndTrigger not found at Map.Functional.SpawnedChaseSections.EndSection.EndTrigger")
                WindUI:Notify({ Title = "Error", Content = "EndTrigger not found!", Duration = 3 })
            end
        end)
    end
})

-- ============================================
-- TP NPC TAB
-- ============================================
local TpSection = TpNpcTab:Section({ Title = "NPC Teleport" })

local function GetSpawnedNPCs()
    local list = {}
    local map = Services.Workspace:FindFirstChild("Map")
    local functional = map and map:FindFirstChild("Functional")
    local npcFolder = functional and functional:FindFirstChild("SpawnedNPCs")

    if npcFolder then
        for _, npc in pairs(npcFolder:GetChildren()) do
            if npc:IsA("Model") then
                table.insert(list, npc.Name)
            end
        end
    end
    return list
end

local npcTpDropdown = TpSection:Dropdown({
    Title = "Select NPC",
    Desc = "Choose target from SpawnedNPCs",
    Values = GetSpawnedNPCs(),
    Value = nil,
    Callback = function(Value)
        State.SelectedTPNPC = Value
    end
})

TpSection:Button({
    Title = "Refresh List",
    Desc = "Update NPC list if empty",
    Callback = function()
        npcTpDropdown:SetValues(GetSpawnedNPCs())
        WindUI:Notify({ Title = "Refreshed", Content = "NPC List updated!", Duration = 1 })
    end
})

TpSection:Button({
    Title = "Click to Teleport",
    Desc = "Teleport just one time",
    Callback = function()
        if not State.SelectedTPNPC then
            WindUI:Notify({ Title = "Error", Content = "Select NPC first!", Duration = 2 })
            return
        end

        local map = Services.Workspace:FindFirstChild("Map")
        local npcFolder = map and map.Functional.SpawnedNPCs
        local target = npcFolder and npcFolder:FindFirstChild(State.SelectedTPNPC)

        if target then
            local targetRoot = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and targetRoot then
                LocalPlayer.Character.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
            end
        else
            WindUI:Notify({ Title = "Error", Content = "NPC not found!", Duration = 2 })
        end
    end
})

-- ============================================
-- PLAYER TAB
-- ============================================
local MoveSection = PlayerTab:Section({ Title = "Movement" })

MoveSection:Slider({
    Title = "WalkSpeed",
    Desc = "Set character running speed",
    Value = { Min = 20, Max = 100, Default = 30 },
    Step = 1,
    Callback = function(Value)
        State.WalkSpeed = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

task.spawn(function()
    while true do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if LocalPlayer.Character.Humanoid.WalkSpeed ~= State.WalkSpeed then
                LocalPlayer.Character.Humanoid.WalkSpeed = State.WalkSpeed
            end
        end
        task.wait(0.5)
    end
end)

MoveSection:Toggle({
    Title = "Enable Fly",
    Desc = "Use WASD + Space/Ctrl to fly",
    Value = false,
    Callback = function(Value)
        State.FlyEnabled = Value
        PlayerLogic.ToggleFly(Value)
    end
})

MoveSection:Slider({
    Title = "Fly Speed",
    Value = { Min = 10, Max = 200, Default = 50 },
    Step = 5,
    Callback = function(Value)
        State.FlySpeed = Value
    end
})

local VisualSection = PlayerTab:Section({ Title = "ESP (Visuals)" })

VisualSection:Toggle({
    Title = "ESP Players",
    Desc = "See other players through walls",
    Value = false,
    Callback = function(Value)
        State.EspPlayer = Value
        if not Value then
            local folder = Services.Workspace:FindFirstChild("JumantaraESP_Players")
            if folder then folder:ClearAllChildren() end
        else
            PlayerLogic.UpdatePlayerESP()
        end
    end
})

VisualSection:Toggle({
    Title = "ESP Items (Experimental)",
    Desc = "See items by Rarity color",
    Value = false,
    Callback = function(Value)
        State.EspItem = Value
        if not Value then
            local folder = Services.Workspace:FindFirstChild("JumantaraESP_Items")
            if folder then folder:ClearAllChildren() end
        else
            PlayerLogic.UpdateItemESP()
        end
    end
})

local CursorSection = PlayerTab:Section({ Title = "Cursor Control" })
local cursorFree = true

local CursorToggle = CursorSection:Toggle({
    Title = "Unlock Cursor (Anti-Lock)",
    Desc = "Force mouse visible & free",
    Value = true,
    Callback = function(Value)
        cursorFree = Value
        if not cursorFree then
            game:GetService("UserInputService").MouseIconEnabled = false
            game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.LockCenter
        end
    end
})

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift and not gameProcessed then
        cursorFree = not cursorFree
        if CursorToggle and CursorToggle.Set then
            CursorToggle:Set(cursorFree)
        end
        local statusText = cursorFree and "Unlocked (Free)" or "Locked (Game Mode)"
        WindUI:Notify({
            Title = "Cursor Update",
            Content = "Status: " .. statusText,
            Duration = 1
        })
        if not cursorFree then
            game:GetService("UserInputService").MouseIconEnabled = false
            game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.LockCenter
        end
    end
end)

Services.RunService.RenderStepped:Connect(function()
    if cursorFree then
        game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default
        game:GetService("UserInputService").MouseIconEnabled = true
    end
end)

task.delay(1, function()
    WindUI:Notify({
        Title = "Cursor Unlocked!",
        Content = "Press [Right Shift] to toggle lock mode.",
        Duration = 6,
        Type = "Info"
    })
end)

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
    State.AutoDig = false
    State.AutoPickup = false
    State.AutoSell = false
    State.AutoEat = false
    State.AntiGuard = false
    State.AutoTPNPC = false
    State.FlyEnabled = false

    State.ShowDigRadius = false
    if Visuals and Visuals.CirclePart then
        Visuals.CirclePart:Destroy()
        Visuals.CirclePart = nil
    end

    State.EspPlayer = false
    State.EspItem = false
    local folderP = Services.Workspace:FindFirstChild("JumantaraESP_Players")
    local folderI = Services.Workspace:FindFirstChild("JumantaraESP_Items")
    if folderP then folderP:Destroy() end
    if folderI then folderI:Destroy() end

    if PlayerLogic and PlayerLogic.ToggleFly then
        PlayerLogic.ToggleFly(false)
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end

    local UserInputService = game:GetService("UserInputService")
    UserInputService.MouseIconEnabled = false
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    if cursorFree ~= nil then cursorFree = false end
    print("✅ All features deactivated successfully.")
end)

print("✅ [JumantaraHub] DTE Loaded!")
