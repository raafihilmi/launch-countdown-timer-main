if game.PlaceId == 121864768012064 then
    local CurrentVersion = "Script Fish It By Rafscape"

    -- Langkah 1: Memuat Library Fluent
    local Fluent = loadstring(game:HttpGet("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()

    -- Langkah 2: Membuat Window Utama
    local Window = Fluent:CreateWindow({
        Title = "Rafscape Fishing",
        SubTitle = "Main",
        TabWidth = 160,
        Size = UDim2.fromOffset(480, 480),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    -- Langkah 3: Menambahkan Tab
    local Tabs = {
        Main = Window:AddTab({ Title = "Main", Icon = "rbxassetid://4483345998" }),
    }

    -- Toggle 1: Auto Complete Fishing (dari sebelumnya)
    local isAutoCompleteActive = false
    Tabs.Main:AddToggle("AutoComplete", {
        Title = "Auto Complete Fishing",
        Description = "Otomatis menyelesaikan pancingan secara terus-menerus.",
        Default = false,
        Callback = function(Value)
            isAutoCompleteActive = Value
            if isAutoCompleteActive then
                task.spawn(function()
                    print("Auto Complete Fishing Loop Dimulai!")
                    while isAutoCompleteActive do
                        game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_net@0.2.0").net
                            :FindFirstChild("RE/FishingCompleted"):FireServer()
                        task.wait(0.5)
                    end
                end)
            else
                print("Auto Complete Fishing Loop Dihentikan!")
            end
        end
    })

    -- Toggle 1: Auto Complete Fishing (dari sebelumnya)
    local isAutoFishActive = false
    Tabs.Main:AddToggle("AutoFish", {
        Title = "Auto Fishing",
        Description = "Otomatis menyelesaikan pancingan secara terus-menerus.",
        Default = false,
        Callback = function(Value)
            isAutoFishActive = Value
            if isAutoFishActive then
                task.spawn(function()
                    print("Auto Fishing Dimulai!")
                    local eq = {
                        [1] = 1
                    }

                    game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_net@0.2.0").net
                        :FindFirstChild("RE/EquipToolFromHotbar"):FireServer(unpack(eq))
                    local chg = {
                        [1] = 1756476737.627494
                    }

                    game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_net@0.2.0").net
                        :FindFirstChild("RF/ChargeFishingRod"):InvokeServer(unpack(chg))
                    local rq2 = {
                        [1] = -1.233184814453125,
                        [2] = 1
                    }

                    game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_net@0.2.0").net
                    :FindFirstChild("RF/RequestFishingMinigameStarted"):InvokeServer(unpack(rq2))
                    while isAutoFishActive do
                        local argsd = {
                            [1] = 1
                        }
                        game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_net@0.2.0").net
                            :FindFirstChild("RE/EquipToolFromHotbar"):FireServer(unpack(argsd))
                        task.wait(0.5)
                    end
                end)
            else
                print("Auto Complete Fishing Loop Dihentikan!")
            end
        end
    })
end
