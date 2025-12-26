local WindUI = loadstring(game:HttpGet("https://pastebin.com/raw/m8P8dLfd"))()

-- [[ THEMES CONFIGURATION ]] --
WindUI:AddTheme({
    Name = "Peach Glow Dominant",
    Accent = Color3.fromHex("#474350"),
    Background = Color3.fromHex("#FFFFFF"),
    BackgroundTransparency = 0,
    Outline = Color3.fromHex("#474350"),
    Text = Color3.fromHex("#474350"),
    Placeholder = Color3.fromHex("#474350"),
    Button = Color3.fromHex("#474350"),
    Icon = Color3.fromHex("#474350"),
    Hover = Color3.fromHex("#fafac6"),
    WindowBackground = Color3.fromHex("#FECDAA"),
    WindowShadow = Color3.fromHex("#000000"),
    WindowTopbarTitle = Color3.fromHex("#474350"),
    WindowTopbarAuthor = Color3.fromHex("#474350"),
    WindowTopbarIcon = Color3.fromHex("#474350"),
    WindowTopbarButtonIcon = Color3.fromHex("#474350"),
    TabBackground = Color3.fromHex("#FFFFFF"),
    TabTitle = Color3.fromHex("#474350"),
    TabIcon = Color3.fromHex("#474350"),
    ElementBackground = Color3.fromHex("#f8fff4"),
    ElementTitle = Color3.fromHex("#474350"),
    ElementDesc = Color3.fromHex("#474350"),
    ElementIcon = Color3.fromHex("#474350"),
    PopupBackground = Color3.fromHex("#fcffeb"),
    PopupBackgroundTransparency = 0,
    PopupTitle = Color3.fromHex("#474350"),
    PopupContent = Color3.fromHex("#474350"),
    PopupIcon = Color3.fromHex("#474350"),
    DialogBackground = Color3.fromHex("#fcffeb"),
    DialogBackgroundTransparency = 0,
    DialogTitle = Color3.fromHex("#474350"),
    DialogContent = Color3.fromHex("#474350"),
    DialogIcon = Color3.fromHex("#474350"),
    Toggle = Color3.fromHex("#474350"),
    ToggleBar = Color3.fromHex("#fafac6"),
    Checkbox = Color3.fromHex("#474350"),
    CheckboxIcon = Color3.fromHex("#fafac6"),
    Slider = Color3.fromHex("#474350"),
    SliderThumb = Color3.fromHex("#fafac6")
})
-- (Tema lain disembunyikan agar script ringkas, Peach Glow tetap default)

-- [[ MAIN WINDOW CREATION ]] --
local Window = WindUI:CreateWindow({
    Title = "TForge",
    Icon = "gamepad-2",
    Author = "JumantaraHub",
    Theme = "Peach Glow Dominant",
    Folder = "UniversalScript_v3"
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
getgenv().AutoRun = false -- Variabel baru untuk Auto Run

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

-- [[ TABS ]] --
local MainTab = Window:Tab({ Title = "Main", Icon = "swords" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local SettingTab = Window:Tab({ Title = "Settings", Icon = "settings" })

-- [[ MAIN TAB ]] --
MainTab:Toggle({
    Title = "Auto Click (Universal)",
    Value = false,
    Callback = function(Value)
        getgenv().AutoClick = Value
        if Value then
            task.spawn(function()
                local VirtualUser = game:GetService("VirtualUser")
                while getgenv().AutoClick do
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new(987, 132))
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- [[ PLAYER TAB ]] --
local SectionMove = PlayerTab:Section({ Title = "Movement" })

-- FITUR BARU: AUTO RUN
PlayerTab:Toggle({
    Title = "Auto Run (Knit)",
    Desc = "Auto Sprint using Remote",
    Value = false,
    Callback = function(Value)
        getgenv().AutoRun = Value
        if Value then
            WindUI:Notify({Title = "Auto Run", Content = "Running enabled!", Duration = 1})
            StartAutoRun()
        else
            WindUI:Notify({Title = "Auto Run", Content = "Running disabled.", Duration = 1})
            StopRunSequence()
        end
    end
})

PlayerTab:Toggle({
    Title = "No Clip",
    Desc = "Walk through walls",
    Value = false,
    Callback = function(Value)
        getgenv().NoClip = Value
    end
})

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
    Values = {"Peach Glow Dominant"},
    Value = "Peach Glow Dominant",
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
