-- Check Game
if game.PlaceId == 121864768012064 then
    local CurrentVersion = "Script Fish It By Rafscape"

    local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/main/src.lua"))()
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local player = Players.LocalPlayer
    local net = ReplicatedStorage.Packages._Index:FindFirstChild("sleitnick_net@0.2.0").net

    -- Referensi remote functions/events
    local ChargeFishingRod = net:FindFirstChild("RF/ChargeFishingRod")
    local RequestFishingMinigameStarted = net:FindFirstChild("RF/RequestFishingMinigameStarted")
    local FishingCompleted = net:FindFirstChild("RE/FishingCompleted")

    local GUI = Mercury:Create {
        Name = "Fishing Auto",
        Size = UDim2.fromOffset(400, 300),
        Theme = Mercury.Themes.Dark,
        Link = "https://github.com/deeeity/mercury-lib"
    }

    -- Variabel untuk status auto fishing
    local autoFishingEnabled = false
    local fishingConnection = nil
    local fishingDelay = 0.5 -- Default delay

    -- Fungsi untuk memulai auto fishing
    local function startAutoFishing()
        if autoFishingEnabled then
            return
        end

        autoFishingEnabled = true

        -- Menampilkan notifikasi
        Mercury:Notify {
            Title = "Fishing Auto",
            Text = "Auto fishing dimulai!",
            Duration = 3
        }

        -- Loop auto fishing
        fishingConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not autoFishingEnabled then
                if fishingConnection then
                    fishingConnection:Disconnect()
                end
                return
            end

            -- Memanggil remote functions/events secara berurutan
            local args1 = { [1] = 1756433828.009514 }
            local success1, result1 = pcall(function()
                return ChargeFishingRod:InvokeServer(unpack(args1))
            end)

            if success1 then
                wait(fishingDelay) -- Jeda antara panggilan

                local args2 = {
                    [1] = -1.233184814453125,
                    [2] = 0.9063576566786857
                }

                local success2, result2 = pcall(function()
                    return RequestFishingMinigameStarted:InvokeServer(unpack(args2))
                end)

                if success2 then
                    wait(fishingDelay) -- Jeda sebelum menyelesaikan fishing

                    local success3, result3 = pcall(function()
                        FishingCompleted:FireServer()
                    end)

                    if not success3 then
                        warn("Gagal memanggil FishingCompleted: " .. tostring(result3))
                    end
                else
                    warn("Gagal memanggil RequestFishingMinigameStarted: " .. tostring(result2))
                end
            else
                warn("Gagal memanggil ChargeFishingRod: " .. tostring(result1))
            end
        end)
    end

    -- Fungsi untuk menghentikan auto fishing
    local function stopAutoFishing()
        if not autoFishingEnabled then
            return
        end

        autoFishingEnabled = false

        if fishingConnection then
            fishingConnection:Disconnect()
            fishingConnection = nil
        end

        Mercury:Notify {
            Title = "Fishing Auto",
            Text = "Auto fishing dihentikan!",
            Duration = 3
        }
    end

    -- Membuat GUI
    local Tab = GUI:Tab {
        Name = "Auto Fishing",
        Icon = "rbxassetid://8569322835"
    }

    local Toggle = Tab:Toggle {
        Name = "Auto Fishing",
        StartingState = false,
        Description = "Aktifkan/Nonaktifkan auto fishing",
        Callback = function(state)
            if state then
                startAutoFishing()
            else
                stopAutoFishing()
            end
        end
    }

    -- Section untuk pengaturan tambahan
    Tab:Section {
        Name = "Pengaturan",
        Side = "Right"
    }

    -- Slider untuk mengatur delay antara fishing attempts
    Tab:Slider {
        Name = "Fishing Delay",
        Default = 50,
        Min = 10,
        Max = 100,
        Callback = function(value)
            fishingDelay = value / 100 -- Konversi ke detik (0.1-1.0)
        end
    }

    -- Button untuk test fishing sekali
    Tab:Button {
        Name = "Test Fishing Sekali",
        Callback = function()
            local args1 = { [1] = 1756433828.009514 }
            local success1, result1 = pcall(function()
                return ChargeFishingRod:InvokeServer(unpack(args1))
            end)

            if success1 then
                wait(0.5)

                local args2 = {
                    [1] = -1.233184814453125,
                    [2] = 0.9063576566786857
                }

                local success2, result2 = pcall(function()
                    return RequestFishingMinigameStarted:InvokeServer(unpack(args2))
                end)

                if success2 then
                    wait(0.5)

                    local success3, result3 = pcall(function()
                        FishingCompleted:FireServer()
                    end)

                    if success3 then
                        Mercury:Notify {
                            Title = "Success",
                            Text = "Fishing test berhasil!",
                            Duration = 3
                        }
                    end
                end
            end
        end
    }

    -- Credit section
    Tab:Section {
        Name = "Credit",
        Side = "Left"
    }

    Tab:Label {
        Name = "Dibuat dengan Mercury Lib",
        Description = "Script auto fishing untuk Fish It"
    }
end
