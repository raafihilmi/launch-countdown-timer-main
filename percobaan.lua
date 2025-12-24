local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Catch and Tame Helper",
   LoadingTitle = "Memuat Script...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, 
      FileName = "CatchAndTameConfig"
   },
   Discord = {
      Enabled = false,
      Invite = "", 
      RememberJoins = true 
   },
   KeySystem = false, 
})

local Tab = Window:CreateTab("Main Features", 4483362458) -- Ikon Home

-- Variabel Global
getgenv().AutoTeleport = false
getgenv().SelectRarity = "Legendary" -- Default
getgenv().MutationOnly = false
getgenv().ESPEnabled = false

-- Daftar Rarity (Sesuaikan nama ini jika di game berbeda, misal huruf besar/kecil)
local rarityList = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical"}

local Section = Tab:CreateSection("Konfigurasi Target")

-- Dropdown untuk memilih Rarity
Tab:CreateDropdown({
   Name = "Pilih Rarity Target",
   Options = rarityList,
   CurrentOption = "Legendary",
   MultipleOptions = false,
   Flag = "RarityDropdown", 
   Callback = function(Option)
      getgenv().SelectRarity = Option[1]
   end,
})

-- Toggle: Hanya cari yang ada Mutasi (Mutation ~= "None")
Tab:CreateToggle({
   Name = "Hanya Cari Mutasi (Mutation Only)",
   CurrentValue = false,
   Flag = "MutationToggle", 
   Callback = function(Value)
      getgenv().MutationOnly = Value
   end,
})

local Section2 = Tab:CreateSection("Aksi")

-- Fungsi Teleport
local function TeleportToPet()
    spawn(function()
        while getgenv().AutoTeleport do
            task.wait(0.5) -- Delay agar tidak crash
            local p = game.Players.LocalPlayer
            local folder = workspace:FindFirstChild("RoamingPets") and workspace.RoamingPets:FindFirstChild("Pets")
            
            if folder and p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                for _, pet in pairs(folder:GetChildren()) do
                    -- Membaca Attribute sesuai screenshot Anda (ikon gerigi)
                    local petRarity = pet:GetAttribute("Rarity")
                    local petMutation = pet:GetAttribute("Mutation")
                    
                    -- Logika Pengecekan
                    local isTarget = false
                    
                    if getgenv().MutationOnly then
                        -- Jika cari mutasi, pastikan Mutation tidak "None"
                        if petMutation and petMutation ~= "None" then
                            isTarget = true
                        end
                    else
                        -- Jika tidak harus mutasi, cek Rarity
                        if petRarity == getgenv().SelectRarity then
                            isTarget = true
                        end
                    end
                    
                    -- Eksekusi Teleport
                    if isTarget then
                        -- Menggunakan Pivot karena di screenshot ada 'WorldPivot'
                        if pet:IsA("Model") or pet:IsA("BasePart") then
                            p.Character.HumanoidRootPart.CFrame = pet:GetPivot()
                            Rayfield:Notify({
                                Title = "Pet Ditemukan!",
                                Content = "Menemukan: " .. (pet:GetAttribute("Name") or "Unknown") .. " | " .. (petRarity or "?"),
                                Duration = 3,
                                Image = 4483362458,
                            })
                            task.wait(2) -- Beri waktu untuk menangkap sebelum pindah lagi
                        end
                    end
                end
            end
        end
    end)
end

-- Toggle Teleport
Tab:CreateToggle({
   Name = "Auto Teleport ke Target",
   CurrentValue = false,
   Flag = "TeleportToggle", 
   Callback = function(Value)
      getgenv().AutoTeleport = Value
      if Value then
         TeleportToPet()
      end
   end,
})

-- Fitur Tambahan: ESP (Highlight)
local function UpdateESP()
    local folder = workspace:FindFirstChild("RoamingPets") and workspace.RoamingPets:FindFirstChild("Pets")
    if not folder then return end
    
    for _, pet in pairs(folder:GetChildren()) do
        if pet:IsA("Model") or pet:IsA("BasePart") then
            local highlight = pet:FindFirstChild("GeminiESP")
            
            -- Hapus ESP jika fitur dimatikan
            if not getgenv().ESPEnabled then
                if highlight then highlight:Destroy() end
            else
                -- Buat ESP jika belum ada
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "GeminiESP"
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = pet
                end
                
                -- Tampilkan Info di atas kepala (BillboardGui)
                local bg = pet:FindFirstChild("InfoGui")
                if not bg then
                    bg = Instance.new("BillboardGui")
                    bg.Name = "InfoGui"
                    bg.Size = UDim2.new(0, 100, 0, 50)
                    bg.AlwaysOnTop = true
                    bg.Parent = pet
                    
                    local txt = Instance.new("TextLabel")
                    txt.Parent = bg
                    txt.Size = UDim2.new(1,0,1,0)
                    txt.BackgroundTransparency = 1
                    txt.TextColor3 = Color3.new(1,1,1)
                    txt.TextStrokeTransparency = 0
                end
                
                -- Update Teks berdasarkan Attribute
                local r = pet:GetAttribute("Rarity") or "Nil"
                local m = pet:GetAttribute("Mutation") or "None"
                local s = pet:GetAttribute("Strength") or 0
                bg.Adornee = pet
                bg.InfoGui.TextLabel.Text = r .. "\n" .. m .. " | STR: " .. s
            end
        end
    end
end

Tab:CreateToggle({
   Name = "Aktifkan ESP (Wallhack)",
   CurrentValue = false,
   Flag = "ESPToggle", 
   Callback = function(Value)
      getgenv().ESPEnabled = Value
      if Value then
          -- Loop ringan untuk update ESP
          task.spawn(function()
              while getgenv().ESPEnabled do
                  UpdateESP()
                  task.wait(1)
              end
          end)
      end
   end,
})

Rayfield:LoadConfiguration()
