local WindUI = loadstring(game:HttpGet("https://pastebin.com/raw/m8P8dLfd"))()

-- ============================================
-- CONFIGURATION MODULE
-- ============================================
local Config = {
    Window = {
        Title = "Brew A Potion by JumantaraHub",
        Icon = "game",
        Author = "JumantaraHub",
        Theme = "Plant",
        Folder = "BAP_JumantaraHub",
        KeySystem = {                                                   
        Note = "Key System. With platoboost.",              
        API = {                                                     
            { -- PlatoBoost
                Type = "platoboost",                                
                ServiceId = 16361, -- service id
                Secret = "4485a80f-25df-4788-b082-5d3f19a932ac", -- platoboost secret
            },                                                      
        },                                                          
    },  
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
    UserInputService = game:GetService("UserInputService"),
    VirtualInputManager = game:GetService("VirtualInputManager"),
}

local LocalPlayer = Services.Players.LocalPlayer

-- ============================================
-- STATE MANAGER
-- ============================================
local State = {
    AutoFarm = false,
    GameMode = "Raid",
    GameDifficulty = "Normal",
    AttackDelay = 0.45,
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
    UseParallelBrewing = false,
    CauldronPriority = { "Cauldron1", "Cauldron2", "Cauldron3", "Cauldron4" },

    AutoSwitchCauldron = true,
    WaitForCauldron = false,

    AutoSellPotion = false,
    SellPotionDelay = 300,
    ReverseAttackDirection = true,
    AttackAngleOffset = 180,
    AutoClickMinigame = true,
    MinigameClickDelay = 0.1,
    DebugMinigame = false,
    AutoOpenChest = false,
    AutoPlaceChest = false,
    SelectedChestRarity = "All",
    AutoBuyStaff = false,
    TargetStaffs = {},
    AutoBuyMagic = false,
    SelectedMagic = "",
}

-- ============================================
-- UI REFERENCES
-- ============================================
local UIRefs = {
    AutoFarmToggle = nil,
    MagicToggle = nil
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

function Utilities.FireRemote(actionName, args)
    Remote:FireServer(
        actionName,
        args,
        Services.Workspace:GetServerTimeNow()
    )
end

function Utilities.GetTarget()
    local nearestEnemy = nil
    local minDistance = math.huge
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    local centerPosition = nil

    if State.GameMode == "Siege" then
        local world = Services.Workspace:FindFirstChild("World")
        local renders = world and world:FindFirstChild("Renders")
        local crystal = renders and renders:FindFirstChild("Crystal Forest")

        if crystal then
            if crystal:IsA("Model") then
                centerPosition = crystal:GetPivot().Position
            elseif crystal:IsA("BasePart") then
                centerPosition = crystal.Position
            end
        end
    end

    if not centerPosition then
        if myRoot then
            centerPosition = myRoot.Position
        else
            return nil
        end
    end

    for _, enemy in pairs(EnemiesFolder:GetChildren()) do
        local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")

        if enemyRoot then
            local health = enemy:GetAttribute("Health")
            local isAlive = true
            if health and health <= 0 then isAlive = false end

            if isAlive then
                local dist = (centerPosition - enemyRoot.Position).Magnitude

                local inRange = true
                if State.GameMode ~= "Siege" and dist > State.SearchRange then
                    inRange = false
                end

                if inRange and dist < minDistance then
                    minDistance = dist
                    nearestEnemy = enemyRoot
                end
            end
        end
    end

    return nearestEnemy
end

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

function Utilities.WalkTo(position)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not (hum and root) then return end

    hum:MoveTo(position)

    local t = 0
    while t < 8 do
        if (root.Position - position).Magnitude <= 6 then return true end
        task.wait(0.1)
        t = t + 0.1
    end
    return false
end

function Utilities.GetIngredient()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return nil end

    local function IsValidItem(tool)
        if not tool:IsA("Tool") or not tool:GetAttribute("ID") then return false end

        if string.find(tool.Name, "Potion") or string.find(tool.Name, "Chest") then
            return false
        end

        if State.SelectedRarity == "All" then
            return true
        else
            local data = ItemDataModule:GetData(tool.Name)
            if data and data.Data and data.Data.Rarity == State.SelectedRarity then
                return true
            end
        end
        return false
    end

    for _, tool in pairs(backpack:GetChildren()) do
        if IsValidItem(tool) then
            if tool:GetAttribute("Enchant") ~= nil then
                print("[AutoBrew] Found Enchanted Item: " .. tool.Name)
                return tool
            end
        end
    end

    for _, tool in pairs(backpack:GetChildren()) do
        if IsValidItem(tool) then
            if tool:GetAttribute("Enchant") == nil then
                return tool
            end
        end
    end

    return nil
end

function Utilities.GetCauldronData(cauldronName)
    local mainData = LocalPlayer:WaitForChild("Data"):WaitForChild("MainData")
    local plotData = mainData:WaitForChild("PlotData")
    return plotData:FindFirstChild(cauldronName)
end

-- ============================================
-- MINIGAME DETECTOR MODULE
-- ============================================
local MinigameDetector = {}

function MinigameDetector.FindMinigameGUI()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")

    local possibleNames = {
        "BrewMinigame",
        "Minigame",
        "PotionMinigame",
        "BrewingGame",
        "CauldronMinigame"
    }

    for _, name in ipairs(possibleNames) do
        local gui = playerGui:FindFirstChild(name)
        if gui and gui.Enabled then
            return gui
        end
    end

    for _, gui in pairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled then
            for _, descendant in pairs(gui:GetDescendants()) do
                if (descendant:IsA("ImageButton") or descendant:IsA("TextButton")) then
                    local text = descendant:FindFirstChildOfClass("TextLabel")
                    if text and string.match(text.Text, "x%d") then
                        return gui
                    end
                end
            end
        end
    end

    return nil
end

function MinigameDetector.FindActiveCircle(minigameGUI)
    if not minigameGUI then return nil end

    local circles = {}

    for _, descendant in pairs(minigameGUI:GetDescendants()) do
        if (descendant:IsA("ImageButton") or descendant:IsA("TextButton")) and descendant.Visible then
            local textLabel = descendant:FindFirstChildOfClass("TextLabel")

            if textLabel then
                local text = textLabel.Text
                local multiplier = string.match(text, "x(%d+%.?%d*)")

                if multiplier then
                    table.insert(circles, {
                        Button = descendant,
                        Multiplier = tonumber(multiplier),
                        Text = text,
                        Position = descendant.AbsolutePosition,
                        Size = descendant.AbsoluteSize
                    })
                end
            end
        end
    end

    if #circles > 0 then
        table.sort(circles, function(a, b)
            return a.Multiplier < b.Multiplier
        end)
        return circles[1]
    end

    return nil
end

function MinigameDetector.ClickCircle(circleData)
    if not circleData then return false end

    local button = circleData.Button

    pcall(function()
        for _, connection in pairs(getconnections(button.MouseButton1Click)) do
            connection:Fire()
        end
        for _, connection in pairs(getconnections(button.Activated)) do
            connection:Fire()
        end
    end)

    task.spawn(function()
        local center = circleData.Position + (circleData.Size / 2)

        pcall(function()
            Services.VirtualInputManager:SendMouseButtonEvent(
                center.X, center.Y, 0, true, game, 0
            )
            task.wait(0.05)
            Services.VirtualInputManager:SendMouseButtonEvent(
                center.X, center.Y, 0, false, game, 0
            )
        end)
    end)

    if State.DebugMinigame then
        print("[Minigame] Clicked:", circleData.Text)
    end

    return true
end

function MinigameDetector.WaitForCircle(minigameGUI, timeout)
    timeout = timeout or 2
    local startTime = tick()

    while tick() - startTime < timeout do
        local circle = MinigameDetector.FindActiveCircle(minigameGUI)
        if circle then
            return circle
        end
        task.wait(0.05)
    end

    return nil
end

-- ============================================
-- AUTO MINIGAME CLICKER
-- ============================================
local MinigameClicker = {}
MinigameClicker.IsActive = false
MinigameClicker.CurrentMultiplier = 1.0

function MinigameClicker.PlayMinigame()
    if not State.AutoClickMinigame then
        print("[Minigame] Manual mode - Play yourself!")
        return false
    end

    MinigameClicker.IsActive = true
    MinigameClicker.CurrentMultiplier = 1.0

    print("[Minigame] Starting auto-clicker...")

    task.wait(0.5)
    local minigameGUI = MinigameDetector.FindMinigameGUI()

    if not minigameGUI then
        print("[Minigame] GUI not found!")
        MinigameClicker.IsActive = false
        return false
    end

    print("[Minigame] GUI Found:", minigameGUI.Name)

    local clickCount = 0
    local maxClicks = 50

    while MinigameClicker.IsActive and clickCount < maxClicks do
        local circle = MinigameDetector.WaitForCircle(minigameGUI, 1)

        if circle then
            local success = MinigameDetector.ClickCircle(circle)

            if success then
                clickCount = clickCount + 1
                MinigameClicker.CurrentMultiplier = circle.Multiplier

                if State.DebugMinigame then
                    print("[Minigame] Progress: x" .. circle.Multiplier .. " (" .. clickCount .. " clicks)")
                end
            end

            task.wait(State.MinigameClickDelay)
        else
            if State.DebugMinigame then
                print("[Minigame] No more circles found")
            end
            break
        end
    end

    print("[Minigame] Finished! Final multiplier: x" .. MinigameClicker.CurrentMultiplier)
    MinigameClicker.IsActive = false

    return true
end

function MinigameClicker.Stop()
    MinigameClicker.IsActive = false
    print("[Minigame] Stopped")
end

-- ============================================
-- MAGIC BUYING LOGIC
-- ============================================
local MagicLogic = {}

function MagicLogic.StartLoop()
    task.spawn(function()
        print("[Magic] Auto Buy Started")

        local mainData = LocalPlayer:WaitForChild("Data"):WaitForChild("MainData")
        local equippedMagic = mainData:WaitForChild("EquippedMagic")

        while State.AutoBuyMagic do
            if State.SelectedMagic == "" then
                print("[Magic] No magic selected.")
                State.AutoBuyMagic = false
                if UIRefs.MagicToggle then UIRefs.MagicToggle:Set(false) end
                break
            end

            if equippedMagic.Value == State.SelectedMagic then
                print("[Magic] Success! You now have " .. State.SelectedMagic)

                State.AutoBuyMagic = false

                if UIRefs.MagicToggle then
                    UIRefs.MagicToggle:Set(false)
                end

                WindUI:Notify({
                    Title = "Auto Buy Finished",
                    Content = "Successfully bought: " .. State.SelectedMagic,
                    Duration = 4
                })

                break
            end

            print("[Magic] Buying: " .. State.SelectedMagic)
            Utilities.FireRemote("BuyMagic", { State.SelectedMagic })

            task.wait(1.5)
        end

        print("[Magic] Auto Buy Stopped")
    end)
end

-- ============================================
-- STAFF BUYING LOGIC
-- ============================================
local StaffLogic = {}

function StaffLogic.StartLoop()
    task.spawn(function()
        print("[Staff] Auto Buy Started")

        while State.AutoBuyStaff do
            if #State.TargetStaffs > 0 then
                for _, staffName in ipairs(State.TargetStaffs) do
                    if not State.AutoBuyStaff then break end

                    print("[Staff] Buying: " .. staffName)
                    Utilities.FireRemote("BuyStaff", { staffName })

                    task.wait(0.5)
                end
            else
                if math.random(1, 20) == 1 then
                    print("[Staff] No staffs selected in dropdown!")
                end
            end

            task.wait(120)
        end

        print("[Staff] Auto Buy Stopped")
    end)
end

-- ============================================
-- CHEST LOGIC MODULE
-- ============================================
local ChestLogic = {}

function ChestLogic.GetChestFromBackpack()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return nil end

    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and string.find(string.lower(tool.Name), "chest") then
            local isValid = false

            if State.SelectedChestRarity == "All" then
                isValid = true
            elseif tool.Name == State.SelectedChestRarity then
                isValid = true
            end

            if isValid then
                local id = tool:GetAttribute("ID")
                if id then
                    return id, tool.Name
                end
            end
        end
    end
    return nil
end

function ChestLogic.GetPairSlot(slotNum)
    if slotNum <= 4 then
        return "Slot" .. slotNum
    else
        return "Slot" .. (slotNum - 4)
    end
end

function ChestLogic.StartLoop()
    task.spawn(function()
        print("[Chest] Logic Started")

        while State.AutoOpenChest or State.AutoPlaceChest do
            local mainData = LocalPlayer:WaitForChild("Data"):WaitForChild("MainData"):WaitForChild("PlotData")

            for i = 1, 8 do
                if not (State.AutoOpenChest or State.AutoPlaceChest) then break end

                local slotName = "Slot" .. i
                local slotData = mainData:FindFirstChild(slotName)

                if slotData then
                    local draining = slotData:FindFirstChild("Draining")
                    local timeRemaining = slotData:FindFirstChild("TimeRemaining")

                    if draining and timeRemaining then
                        if State.AutoOpenChest and draining.Value == true and timeRemaining.Value <= 0 then
                            local pairName = ChestLogic.GetPairSlot(i)
                            print("[Chest] Opening " .. slotName .. " & " .. pairName)

                            local args = { slotName, pairName }
                            Utilities.FireRemote("OpenChest", args)
                            task.wait(1)
                        elseif State.AutoPlaceChest and draining.Value == false then
                            local chestID, chestName = ChestLogic.GetChestFromBackpack()

                            if chestID then
                                print("[Chest] Placing " .. chestName .. " into " .. slotName)

                                local args = { slotName, chestID }
                                Utilities.FireRemote("PlaceOnSlot", args)
                                task.wait(1)
                            end
                        end
                    end
                end
            end

            task.wait(2)
        end
        print("[Chest] Logic Stopped")
    end)
end

-- ============================================
-- BREWING LOGIC
-- ============================================
local Brewing = {}

function Brewing.IsCauldronUnlocked(cauldronName)
    local cData = Utilities.GetCauldronData(cauldronName)
    return cData and cData.Unlocked.Value or false
end

function Brewing.GetUnlockedCauldrons()
    local unlocked = {}

    for i = 1, 4 do
        local name = "Cauldron" .. i
        if Brewing.IsCauldronUnlocked(name) then
            table.insert(unlocked, name)
        end
    end

    return unlocked
end

function Brewing.GetCauldronStatus(cauldronName)
    local cData = Utilities.GetCauldronData(cauldronName)
    if not cData then return "LOCKED" end

    local isCooking = cData.Cooking.Value
    local timeRemaining = cData.TimeRemaining.Value
    local itemsJson = cData.Items.Value
    local itemsTable = Services.HttpService:JSONDecode(itemsJson)
    local count = #itemsTable
    local capacity = 5 + cData.Boost.Value

    if isCooking then
        if timeRemaining <= 0 then
            return "READY_TO_CLAIM"
        else
            return "COOKING"
        end
    elseif count >= 2 then
        return "READY_TO_BREW"
    elseif count > 0 then
        return "PARTIALLY_FILLED"
    else
        return "EMPTY"
    end
end

function Brewing.GetNextAvailableCauldron()
    for _, name in ipairs(State.CauldronPriority) do
        if Brewing.IsCauldronUnlocked(name) then
            local status = Brewing.GetCauldronStatus(name)

            if status == "EMPTY" or status == "PARTIALLY_FILLED" or status == "READY_TO_CLAIM" then
                return name, status
            end
        end
    end

    if State.WaitForCauldron then
        return Brewing.GetFastestCookingCauldron()
    end

    return nil, nil
end

function Brewing.GetFastestCookingCauldron()
    local fastest = nil
    local minTime = math.huge

    for i = 1, 4 do
        local name = "Cauldron" .. i
        local cData = Utilities.GetCauldronData(name)

        if cData and cData.Cooking.Value then
            local timeRemaining = cData.TimeRemaining.Value
            if timeRemaining < minTime and timeRemaining > 0 then
                minTime = timeRemaining
                fastest = name
            end
        end
    end

    return fastest, minTime
end

function Brewing.ProcessCauldron(cauldronName)
    if not State.AutoBrew then return false end

    local cData = Utilities.GetCauldronData(cauldronName)
    local cPrompt = Utilities.GetCauldronPrompt(cauldronName)

    if not cData or not cPrompt then return false end
    if not cData.Unlocked.Value then return false end

    local cModel = cPrompt.Parent
    local status = Brewing.GetCauldronStatus(cauldronName)

    State.IsBrewing[cauldronName] = true

    if status == "READY_TO_CLAIM" then
        print("[AutoBrew] Claiming " .. cauldronName)
        Utilities.WalkTo(cModel.Position)
        Utilities.FireRemote("ClaimPotion", { cauldronName, cModel })
        task.wait(1.5)
        State.IsBrewing[cauldronName] = false
        return true
    end

    if status == "COOKING" then
        if State.AutoSwitchCauldron then
            State.IsBrewing[cauldronName] = false
            return false
        else
            local timeRemaining = cData.TimeRemaining.Value
            print("[AutoBrew] Waiting " .. cauldronName .. " (" .. math.ceil(timeRemaining) .. "s)")
            task.wait(math.min(timeRemaining + 1, 10))
            return Brewing.ProcessCauldron(cauldronName)
        end
    end

    if status == "EMPTY" or status == "PARTIALLY_FILLED" then
        local itemsJson = cData.Items.Value
        local itemsTable = Services.HttpService:JSONDecode(itemsJson)
        local count = #itemsTable
        local capacity = 5 + cData.Boost.Value

        local noItemAttempts = 0
        while count < capacity do
            local item = Utilities.GetIngredient()

            if not item then
                noItemAttempts = noItemAttempts + 1
                if noItemAttempts >= 3 then
                    print("[AutoBrew] No more ingredients with rarity: " .. State.SelectedRarity)
                    break
                end
                task.wait(0.5)
            else
                noItemAttempts = 0

                Utilities.WalkTo(cModel.Position)

                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                if hum then
                    hum:EquipTool(item)
                    task.wait(0.3)

                    if cPrompt and cPrompt.Parent then
                        fireproximityprompt(cPrompt)
                        print("[AutoBrew] Added " .. item.Name .. " (" .. State.SelectedRarity .. ") to " .. cauldronName)
                    end

                    task.wait(State.AddItemDelay)

                    if item.Parent == LocalPlayer.Character then
                        hum:UnequipTools()
                    end
                end

                task.wait(0.2)
                itemsJson = cData.Items.Value
                itemsTable = Services.HttpService:JSONDecode(itemsJson)
                count = #itemsTable
            end
        end
    end

    if status == "READY_TO_BREW" or Brewing.GetCauldronStatus(cauldronName) == "READY_TO_BREW" then
        print("[AutoBrew] Starting Brew " .. cauldronName)

        Utilities.FireRemote("ConfirmBrew", { cauldronName, cModel })

        print("[AutoBrew] Playing minigame...")
        if State.AutoClickMinigame then
            print("[AutoBrew] Auto-playing minigame...")
            MinigameClicker.PlayMinigame()
        else
            print("[AutoBrew] Manual minigame - Click the circles yourself!")
            task.wait(State.MinigameDuration)
        end

        task.wait(1)
    end

    State.IsBrewing[cauldronName] = false
    return true
end

function Brewing.StartSequentialLoop()
    task.spawn(function()
        print("[AutoBrew] Starting Sequential Mode (1 by 1)")

        while State.AutoBrew do
            local processedAny = false

            for _, cauldronName in ipairs(State.CauldronPriority) do
                if not State.AutoBrew then break end

                if State.BrewTargetCauldron == "All" or State.BrewTargetCauldron == cauldronName then
                    if Brewing.IsCauldronUnlocked(cauldronName) then
                        local success = Brewing.ProcessCauldron(cauldronName)
                        if success then
                            processedAny = true
                        end
                        task.wait(0.5)
                    end
                end
            end

            if not processedAny then
                task.wait(2)
            else
                task.wait(1)
            end
        end

        print("[AutoBrew] Sequential Loop Stopped")
    end)
end

function Brewing.StartParallelLoop()
    task.spawn(function()
        print("[AutoBrew] Starting Parallel Mode (All at once)")

        while State.AutoBrew do
            local threads = {}

            for _, cauldronName in ipairs(State.CauldronPriority) do
                if not State.AutoBrew then break end

                if State.BrewTargetCauldron == "All" or State.BrewTargetCauldron == cauldronName then
                    if Brewing.IsCauldronUnlocked(cauldronName) then
                        table.insert(threads, task.spawn(function()
                            Brewing.ProcessCauldron(cauldronName)
                        end))
                    end
                end
            end

            local waitTime = 0
            while waitTime < 30 do
                local allDone = true
                for name, status in pairs(State.IsBrewing) do
                    if status then allDone = false end
                end
                if allDone then break end
                task.wait(1)
                waitTime = waitTime + 1
            end

            task.wait(2)
        end

        print("[AutoBrew] Parallel Loop Stopped")
    end)
end

function Brewing.StartSmartQueue()
    task.spawn(function()
        print("[AutoBrew] Starting Smart Queue Mode")

        while State.AutoBrew do
            for i = 1, 4 do
                local name = "Cauldron" .. i
                if Brewing.GetCauldronStatus(name) == "READY_TO_CLAIM" then
                    Brewing.ProcessCauldron(name)
                end
            end

            local nextCauldron, status = Brewing.GetNextAvailableCauldron()

            if nextCauldron then
                print("[AutoBrew] Processing " .. nextCauldron .. " (Status: " .. status .. ")")
                Brewing.ProcessCauldron(nextCauldron)
            else
                local fastest, minTime = Brewing.GetFastestCookingCauldron()
                if fastest and minTime < 30 then
                    print("[AutoBrew] All cooking. Waiting for " .. fastest .. " (" .. math.ceil(minTime) .. "s)")
                    task.wait(math.min(minTime + 1, 10))
                else
                    task.wait(5)
                end
            end

            task.wait(1)
        end

        print("[AutoBrew] Smart Queue Stopped")
    end)
end

function Brewing.StartLoop()
    if State.UseParallelBrewing then
        Brewing.StartParallelLoop()
    elseif State.AutoSwitchCauldron then
        Brewing.StartSmartQueue()
    else
        Brewing.StartSequentialLoop()
    end
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

        local distance = (myPos - enemyPos).Magnitude
        local direction = (enemyPos - myPos).Unit

        if distance < State.SafeRadius then
            local retreatPos = myPos - (direction * 8)
            humanoid:MoveTo(retreatPos)
        elseif distance > (State.SafeRadius + 5) then
            humanoid:MoveTo(enemyPos)
        end

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

            Utilities.FireRemote("StartLobby", nil)
            task.wait(1)
            if State.GameMode == "Siege" then
                Utilities.FireRemote("ChangeGamemode", { "Siege" })
                task.wait(0.2)
                Utilities.FireRemote("ChangeGamemode", { "Siege" })
                print("[AutoFarm] Set Game Mode to Siege")
                task.wait(0.5)
            end
            if State.GameDifficulty then
                Utilities.FireRemote("ChangeDifficulty", { State.GameDifficulty })
                task.wait(0.2)
                Utilities.FireRemote("ChangeDifficulty", { State.GameDifficulty })
                print("[AutoFarm] Set Game Difficulty to " .. State.GameDifficulty)
                task.wait(0.5)
            end
            task.wait(1)
            if not State.AutoFarm then break end

            Utilities.FireRemote("StartGame", nil)
            WindUI:Notify({ Title = "Game Start", Content = "Entering Combat Mode!", Duration = 2 })
            task.wait(1)

            local isDead = false

            while State.AutoFarm do
                if LocalPlayer:GetAttribute("Dead") == true then
                    isDead = true
                    WindUI:Notify({ Title = "Status", Content = "Player Dead. Resetting...", Duration = 2 })
                    break
                end

                local targetRoot = Utilities.GetTarget()

                if targetRoot then
                    Farming.KiteLogic(targetRoot)

                    local attackCFrame = targetRoot.CFrame
                    if State.ReverseAttackDirection then
                        local pos = targetRoot.CFrame.Position
                        local lookVec = -targetRoot.CFrame.LookVector
                        attackCFrame = CFrame.lookAt(pos, pos + lookVec)
                    end
                    local attackArgs = { attackCFrame }
                    Utilities.FireRemote("UseMove", attackArgs)
                end

                task.wait(State.AttackDelay)
            end

            if not State.AutoFarm then break end

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
-- MINIGAME MONITOR
-- ============================================
local MinigameMonitor = {}
MinigameMonitor.Connection = nil

function MinigameMonitor.Start()
    if MinigameMonitor.Connection then return end

    print("[MinigameMonitor] Started")

    MinigameMonitor.Connection = Services.RunService.Heartbeat:Connect(function()
        if not State.AutoClickMinigame then return end
        if MinigameClicker.IsActive then return end

        local minigameGUI = MinigameDetector.FindMinigameGUI()

        if minigameGUI then
            task.spawn(function()
                MinigameClicker.PlayMinigame()
            end)
        end
    end)
end

function MinigameMonitor.Stop()
    if MinigameMonitor.Connection then
        MinigameMonitor.Connection:Disconnect()
        MinigameMonitor.Connection = nil
    end
    print("[MinigameMonitor] Stopped")
end

-- ============================================
-- MAIN UI CREATION
-- ============================================
local Window = WindUI:CreateWindow(Config.Window)
Window:EditOpenButton(Config.OpenButton)

-- ============================================
-- TAB CREATION (SESUAI URUTAN)
-- ============================================
local MainTab = Window:Tab({ Title = "Auto Farm", Icon = "swords" })
local ChestTab = Window:Tab({ Title = "Chest (Patched)", Icon = "package", Locked = true })
local SellPotionTab = Window:Tab({ Title = "Sell Potion", Icon = "circle-dollar-sign" })
local ShopsTab = Window:Tab({ Title = "Shops", Icon = "shopping-cart" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

-- ============================================
-- MAIN TAB CONTENT
-- ============================================
local FarmSection = MainTab:Section({ Title = "Combat Loop" })

FarmSection:Dropdown({
    Title = "Game Mode",
    Desc = "Select Fight Mode (Raid/Siege)",
    Values = { "Raid", "Siege" },
    Value = "Raid",
    Callback = function(Value)
        State.GameMode = Value
        print("[Settings] Game Mode set to:", Value)
    end
})

FarmSection:Dropdown({
    Title = "Game Difficulty",
    Values = { "Normal", "Hard" },
    Value = "Normal",
    Callback = function(Value)
        State.GameDifficulty = Value
        print("[Settings] Game Difficulty set to:", Value)
    end
})

UIRefs.AutoFarmToggle = FarmSection:Toggle({
    Title = "Auto Farm",
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
    Value = { Min = 0.05, Max = 1, Default = 0.45 },
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
    Desc = "Auto Add Ingredients -> Brew -> Claim (All 4 Cauldrons)",
    Value = false,
    Callback = function(Value)
        State.AutoBrew = Value
        if Value then
            Brewing.StartLoop()
        else
            print("[System] Stopping Auto Brew...")
        end
    end
})

BrewSection:Dropdown({
    Title = "Target Cauldron",
    Desc = "Which cauldron to brew",
    Values = { "All", "Cauldron1", "Cauldron2", "Cauldron3", "Cauldron4" },
    Value = "All",
    Callback = function(Value)
        State.BrewTargetCauldron = Value
        print("[Settings] Target Cauldron:", Value)
    end
})

BrewSection:Dropdown({
    Title = "Brewing Mode",
    Desc = "How to process multiple cauldrons",
    Values = { "Smart Queue", "Sequential", "Parallel" },
    Value = "Smart Queue",
    Callback = function(Value)
        if Value == "Parallel" then
            State.UseParallelBrewing = true
            State.AutoSwitchCauldron = false
        elseif Value == "Smart Queue" then
            State.UseParallelBrewing = false
            State.AutoSwitchCauldron = true
        else
            State.UseParallelBrewing = false
            State.AutoSwitchCauldron = false
        end
        print("[Settings] Brewing Mode:", Value)
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

BrewSection:Toggle({
    Title = "Wait for Cooking",
    Desc = "Wait for cauldron to finish or skip to next?",
    Value = false,
    Callback = function(Value)
        State.WaitForCauldron = Value
    end
})

BrewSection:Toggle({
    Title = "Auto Click Minigame",
    Desc = "Automatically click circles in brewing minigame",
    Value = true,
    Callback = function(Value)
        State.AutoClickMinigame = Value

        if Value then
            MinigameMonitor.Start()
        else
            MinigameMonitor.Stop()
            MinigameClicker.Stop()
        end
    end
})

BrewSection:Slider({
    Title = "Minigame Click Delay",
    Desc = "Time between clicks (Lower = Faster)",
    Value = { Min = 0.05, Max = 0.5, Default = 0.1 },
    Step = 0.05,
    Callback = function(Value)
        State.MinigameClickDelay = Value
    end
})

BrewSection:Toggle({
    Title = "Debug Minigame",
    Desc = "Show detailed minigame logs",
    Value = false,
    Callback = function(Value)
        State.DebugMinigame = Value
    end
})

-- ============================================
-- CHEST TAB CONTENT
-- ============================================
local ChestSection = ChestTab:Section({ Title = "Manager" })

ChestSection:Dropdown({
    Title = "Select Chest Rarity",
    Desc = "Choose which chest to auto place",
    Values = { "All", "Rare Chest", "Magical Chest", "Epic Chest", "Legendary Chest", "Mythical Chest" },
    Value = "All",
    Callback = function(Value)
        State.SelectedChestRarity = Value
        print("[Chest] Rarity filter set to:", Value)
    end
})

ChestSection:Toggle({
    Title = "Auto Place Chest",
    Desc = "Automatically place selected chest into empty slots",
    Value = false,
    Callback = function(Value)
        State.AutoPlaceChest = Value
        if Value then
            if not State.AutoOpenChest then
                ChestLogic.StartLoop()
            end
        end
    end
})

ChestSection:Toggle({
    Title = "Auto Open Chest",
    Desc = "Automatically open finished chests",
    Value = false,
    Callback = function(Value)
        State.AutoOpenChest = Value
        if Value then
            if not State.AutoPlaceChest then
                ChestLogic.StartLoop()
            end
        end
    end
})

-- ============================================
-- SELL POTION TAB CONTENT
-- ============================================
local SellPotionSection = SellPotionTab:Section({ Title = "Sell Potion" })

SellPotionSection:Toggle({
    Title = "Auto Sell Potion",
    Value = false,
    Callback = function(Value)
        State.AutoSellPotion = Value
        if Value then
            task.spawn(function()
                while State.AutoSellPotion do
                    WindUI:Notify({ Title = "System", Content = "Selling Potions...", Duration = 1 })
                    Utilities.FireRemote("SellPotions", {}, Services.Workspace:GetServerTimeNow())
                    task.wait(State.SellPotionDelay)
                end
            end)
        else
            WindUI:Notify({ Title = "System", Content = "Stopping Auto Sell...", Duration = 2 })
        end
    end
})

SellPotionSection:Slider({
    Title = "Sell Delay",
    Desc = "Time between each sell attempt (seconds)",
    Value = { Min = 60, Max = 600, Default = 300 },
    Step = 1,
    Callback = function(Value)
        State.SellPotionDelay = Value
        print("[Settings] Sell Delay:", Value .. "s")
    end
})

-- ============================================
-- SHOPS TAB CONTENT
-- ============================================
local ShopSection = ShopsTab:Section({ Title = "Open GUI (No NPC Required)" })

local ShopList = {
    "WispShop",
    "MagicShop",
    "ShardWitch",
    "TravelingMerchant",
    "StaffShop",
    "RelicShop"
}

for _, shopName in ipairs(ShopList) do
    ShopSection:Button({
        Title = "Open " .. shopName,
        Desc = "Opens the " .. shopName .. " interface",
        Callback = function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local LocalPlayer = game:GetService("Players").LocalPlayer

            local success, err = pcall(function()
                local Interface = require(ReplicatedStorage.Modules.Client.Interface)
                local TargetFrame = LocalPlayer.PlayerGui.Main.Frames:FindFirstChild(shopName)

                if TargetFrame and TargetFrame:FindFirstChild("MainFrame") then
                    Interface:GetElement(TargetFrame.MainFrame):Show()
                else
                    error("Frame not found: " .. shopName)
                end
            end)

            if success then
                WindUI:Notify({ Title = "Shop", Content = shopName .. " Opened!", Duration = 2 })
            else
                WindUI:Notify({ Title = "Error", Content = "Failed to open " .. shopName, Duration = 2 })
                warn("[Shop Error] " .. tostring(err))
            end
        end
    })
end

local StaffSection = ShopsTab:Section({ Title = "Auto Buy Staffs" })

local StaffList = {
    "Starter Staff", "Apprentice Staff", "Master's Staff", "Energy Staff",
    "Earth Staff", "Fire Staff", "Wind Staff", "Lightning Staff",
    "Nature Staff", "Water Staff", "Light Staff", "Holy Staff",
    "Explosion Staff", "Dark Staff", "Flower Staff", "Void Staff",
    "Dusk Staff", "Mystic Staff", "Venom Staff", "Reaper Staff",
    "Lunar Staff", "Atomic Staff", "Fractal Staff"
}

StaffSection:Dropdown({
    Title = "Select Staffs",
    Desc = "Choose which staffs to auto-buy (Multi-select)",
    Values = StaffList,
    Multi = true,
    Value = {},
    Callback = function(Value)
        State.TargetStaffs = Value
        print("[Staff] Selected Items:", table.concat(Value, ", "))
    end
})

StaffSection:Toggle({
    Title = "Auto Buy Selected Staff",
    Desc = "Continuously attempts to buy selected staffs",
    Value = false,
    Callback = function(Value)
        State.AutoBuyStaff = Value
        if Value then
            StaffLogic.StartLoop()
        end
    end
})

local MagicSection = ShopsTab:Section({ Title = "Auto Buy Magic" })

local MagicList = {
    "Fire Flies", "Earth Slam", "Energy Blast", "Fire Ball", "Wind Slice",
    "Boulder Roll", "Water Bullets", "Wind Cyclone", "Tsunami",
    "Light Beam", "Light Ray", "Holy Light", "Flower Bloom", "Purify",
    "Void Slash", "Void Heart", "Venom Surge", "Reaper Frenzy",
    "Lunar Shatter", "Atomic Blast", "Fractal Cleave"
}

MagicSection:Dropdown({
    Title = "Select Magic",
    Desc = "Choose one magic to auto-buy",
    Values = MagicList,
    Value = "",
    Multi = false,
    Callback = function(Value)
        State.SelectedMagic = Value
        print("[Magic] Selected Target:", Value)
    end
})

UIRefs.MagicToggle = MagicSection:Toggle({
    Title = "Auto Buy Selected Magic",
    Desc = "Continuously attempts to buy the selected magic until equipped",
    Value = false,
    Callback = function(Value)
        State.AutoBuyMagic = Value
        if Value then
            if State.SelectedMagic == "" then
                WindUI:Notify({ Title = "Warning", Content = "Please select a magic first!", Duration = 3 })
                if UIRefs.MagicToggle then UIRefs.MagicToggle:Set(false) end
            else
                MagicLogic.StartLoop()
            end
        end
    end
})

-- ============================================
-- PLAYER TAB CONTENT
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
-- SETTINGS TAB CONTENT
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
    State.IsFarming = false
    State.AutoBrew = false
    State.AutoSellPotion = false
    State.AutoClickMinigame = false
    State.AutoPlaceChest = false
    State.AutoOpenChest = false
    State.AutoBuyStaff = false
    State.AutoBuyMagic = false
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end

    print("✅ [JumantaraHub] Script Unloaded!")
end)

print("✅ [JumantaraHub] Brew a Potion Script Loaded!")