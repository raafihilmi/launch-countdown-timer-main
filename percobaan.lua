local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()

local Window = Rayfield:CreateWindow({
   Name = "The Forge - Utility Script",
   LoadingTitle = "Memuat Script...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, 
      FileName = "TheForgeConfig"
   },
   KeySystem = false,
})

local MainTab = Window:CreateTab("Main", 4483362458)

----------------------------------------------------------------
-- BAGIAN 1: FUNGSI UTILITAS (Pembersih Teks)
----------------------------------------------------------------

local function getCurrentRace()
    local player = game.Players.LocalPlayer
    local success, result = pcall(function()
        -- Mengambil teks dari path UI
        local label = player.PlayerGui.Sell.RaceUI.CurrentRace
        local rawText = label.Text
        
        -- Membersihkan tag HTML <font> agar tersisa nama ras saja
        local cleanText = rawText:gsub("<[^>]+>", "")
        
        -- Menghapus spasi ekstra di awal/akhir
        return cleanText:match("^%s*(.-)%s*$")
    end)
    
    if success then
        return result
    else
        return "Unknown"
    end
end

----------------------------------------------------------------
-- BAGIAN 2: AUTO REROLL (Demon / Angel)
----------------------------------------------------------------

local AutoRerollEnabled = false

MainTab:CreateSection("Auto Reroll System")

MainTab:CreateLabel("Target Otomatis: Demon atau Angel")

MainTab:CreateToggle({
   Name = "Auto Reroll Race",
   CurrentValue = false,
   Flag = "AutoRerollToggle", 
   Callback = function(Value)
        AutoRerollEnabled = Value
        
        if Value then
            Rayfield:Notify({Title = "Sistem", Content = "Auto Reroll Dimulai...", Duration = 2})
            
            task.spawn(function()
                while AutoRerollEnabled do
                    local myRace = getCurrentRace()
                    
                    -- Cek Target
                    if myRace == "Demon" or myRace == "Angel" then
                        Rayfield:Notify({
                            Title = "BERHASIL!",
                            Content = "Stop! Anda mendapatkan: " .. myRace,
                            Duration = 5,
                            Image = 4483362458,
                        })
                        AutoRerollEnabled = false
                        break
                    end
                    
                    
                    pcall(function()
                        game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.RaceService.RF.Reroll:InvokeServer()
                    end)
                    
                    -- Jeda agar UI sempat update dan tidak error
                    task.wait(1.5) 
                end
            end)
        else
            Rayfield:Notify({Title = "Sistem", Content = "Auto Reroll Dimatikan.", Duration = 2})
        end
   end,
})

MainTab:CreateButton({
   Name = "Cek Ras Saya Saat Ini",
   Callback = function()
       local race = getCurrentRace()
       Rayfield:Notify({Title = "Info Ras", Content = race, Duration = 2})
   end,
})

----------------------------------------------------------------
-- BAGIAN 3: CLAIM ALL CODES (Updated)
----------------------------------------------------------------

MainTab:CreateSection("Code Redeemer")

-- Daftar kode sesuai permintaan Anda
local codeList = {
    "200K!",
    "100K!",
    "40KLIKES",
    "20KLIKES",
    "15KLIKES",
    "10KLIKES",
    "5KLIKES",
    "BETARELEASE!",
    "POSTRELEASEQNA"
}

MainTab:CreateButton({
   Name = "Claim Semua Codes",
   Callback = function()
       Rayfield:Notify({Title = "Proses", Content = "Mencoba menukarkan kode...", Duration = 3})
       
       for _, codeName in ipairs(codeList) do
           local args = {
               [1] = codeName
           }

           -- Eksekusi Remote Code
           local success, err = pcall(function()
               game:GetService("ReplicatedStorage").Shared.Packages.Knit.Services.CodeService.RF.RedeemCode:InvokeServer(unpack(args))
           end)
           
           if success then
               print("Sukses redeem: " .. codeName)
           else
               print("Gagal redeem: " .. codeName)
           end
           
           task.wait(0.5) -- Jeda agar aman dari kick
       end
       
       Rayfield:Notify({Title = "Selesai", Content = "Semua kode telah diproses.", Duration = 3})
   end,
})

