local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Catch and Tame Helper (Manual)",
   LoadingTitle = "Memuat Script...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, 
      FileName = "CatchAndTameConfig_Manual"
   },
   Discord = {
      Enabled = false,
      Invite = "", 
      RememberJoins = true 
   },
   KeySystem = false, 
})

local Tab = Window:CreateTab("Main Features", 4483362458)

-- Variabel Global
getgenv().SelectRarity = "Legendary" -- Default
getgenv().MutationOnly = false
getgenv().ESPEnabled = false

local rarityList = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical"}

local Section = Tab:CreateSection("Konfigurasi Target")

-- Dropdown Rarity
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

-- Toggle Mutasi
Tab:CreateToggle({
   Name = "Hanya Cari Mutasi (Mutation Only)",
   CurrentValue = false,
   Flag = "MutationToggle", 
   Callback = function(Value)
      getgenv().MutationOnly = Value
   end,
})

local Section2 = Tab:CreateSection("Eksekusi")

-- Fungsi Teleport Sekali Jalan
local function TeleportOnce()
    local p = game.Players.LocalPlayer
    local folder = workspace:FindFirstChild("RoamingPets") and workspace.RoamingPets:FindFirstChild("Pets")
    local foundTarget = false -- Penanda apakah target ketemu
    
    if folder and p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        for _, pet in pairs(folder:GetChildren()) do
            -- Baca Attributes
            local petRarity = pet:GetAttribute("Rarity")
            local petMutation = pet:GetAttribute("Mutation")
            
            local isTarget = false
            
            -- Cek Kriteria
            if getgenv().MutationOnly then
                if petMutation and petMutation ~= "None" then
                    isTarget = true
                end
            else
                if petRarity == getgenv().SelectRarity then
                    isTarget = true
                end
            end
            
            -- Eksekusi Teleport
            if isTarget then
                if pet:IsA("Model") or pet:IsA("BasePart") then
                    -- Pindah posisi
                    p.Character.HumanoidRootPart.CFrame = pet:GetPivot()
                    
                    -- Notifikasi Berhasil
                    Rayfield:Notify({
                        Title = "Target Ditemukan!",
                        Content = "Teleport ke: " .. (pet:GetAttribute("Name") or "Unknown") .. " | " .. (petRarity or "?"),
                        Duration = 3,
                        Image = 4483362458,
                    })
                    
                    foundTarget = true
                    break -- BERHENTI LOOPING SETELAH KETEMU SATU
                end
            end
        end
    end
    
    -- Notifikasi jika tidak ada yang cocok sama sekali
    if not foundTarget then
        Rayfield:Notify({
            Title = "Tidak Ditemukan",
            Content = "Tidak ada Pet dengan kriteria tersebut di server ini.",
            Duration = 3,
            Image = 4483362458,
        })
    end
end

-- Tombol (Button) untuk Teleport
Tab:CreateButton({
   Name = "Teleport ke 1 Target (Sekali)",
   Callback = function()
      TeleportOnce()
   end,
})

-- Fitur ESP (Tetap ada untuk bantuan visual)
local function UpdateESP()
    local folder = workspace:FindFirstChild("RoamingPets") and workspace.RoamingPets:FindFirstChild("Pets")
    if not folder then return end
    
    for _, pet in pairs(folder:GetChildren()) do
        if pet:IsA("Model") or pet:IsA("BasePart") then
            local highlight = pet:FindFirstChild("GeminiESP")
            
            if not getgenv().ESPEnabled then
                if highlight then highlight:Destroy() end
            else
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "GeminiESP"
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = pet
                end
                
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
                
                local r = pet:GetAttribute("Rarity") or "Nil"
                local m = pet:GetAttribute("Mutation") or "None"
                bg.Adornee = pet
                bg.InfoGui.TextLabel.Text = r .. "\n" .. m
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
