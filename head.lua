-- Check Game
if game.PlaceId == 121864768012064 then
    local CurrentVersion = "Script Fish It By Rafscape"

    local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()

    local GUI = Mercury:Create {
        Name = CurrentVersion,
        Size = UDim2.fromOffset(600, 400),
        Theme = Mercury.Themes.Dark,
        Link = "https://github.com/deeeity/mercury-lib"
    }

    ---Toggle untuk Auto Fishing

    -- Variabel untuk menyimpan path ke RemoteFunction dan RemoteEvent agar lebih rapi
    local NetService = game:GetService("ReplicatedStorage").Packages._Index["sleitnick_net@0.2.0"].net

    local chargeRod = NetService:FindFirstChild("RF/ChargeFishingRod")
    local requestMinigame = NetService:FindFirstChild("RF/RequestFishingMinigameStarted")
    local completeFishing = NetService:FindFirstChild("RE/FishingCompleted")

    -- Variabel untuk mengontrol loop
    local isAutoFishing = false

    fishingTab:Toggle {
        Name = "Auto Fishing",
        Description = "Aktifkan untuk memancing secara otomatis",
        Callback = function(Value)
            -- 'Value' akan menjadi true jika toggle diaktifkan, dan false jika dinonaktifkan
            isAutoFishing = Value

            -- Memulai loop jika toggle diaktifkan
            while isAutoFishing do
                -- Cek ulang jika toggle masih aktif sebelum melanjutkan
                if not isAutoFishing then break end

                pcall(function()
                    -- Perintah Pertama: Charge a vara
                    local args1 = {
                        [1] = 1756433828.009514
                    }
                    chargeRod:InvokeServer(unpack(args1))
                    wait(0.5) -- Jeda singkat antar perintah

                    -- Perintah Kedua: Mulai minigame
                    local args2 = {
                        [1] = -1.233184814453125,
                        [2] = 0.9063576566786857
                    }
                    requestMinigame:InvokeServer(unpack(args2))
                    wait(0.5) -- Jeda singkat antar perintah

                    -- Perintah Ketiga: Selesaikan memancing
                    completeFishing:FireServer()
                    completeFishing:FireServer()
                    completeFishing:FireServer()
                end)

                -- Jeda sebelum memulai siklus memancing berikutnya
                wait(2)
            end
        end,
        Enabled = false -- Nilai awal saat game dimulai (nonaktif)
    }
end
