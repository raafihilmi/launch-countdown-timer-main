local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Catch and Tame: Auto Catch",
   LoadingTitle = "Memuat Script...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, 
      FileName = "CatchAndTame_Autov2"
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
getgenv().SelectRarity = "Legendary"
getgenv().MutationOnly = false
getgenv().ESPEnabled = false
getgenv().AutoCatchEnabled = true -- Default Nyala

local rarityList = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical"}
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")

-- Fungsi Catch Protocol (Berdasarkan Log Remote Anda)
local function RunCatchProtocol(targetPet)
    local p = game.Players.LocalPlayer
    if not targetPet or not targetPet.Parent then return end
    
    -- Jarak aman dan arah
    local root = p.Character.HumanoidRootPart
    local direction = (targetPet:GetPivot().Position - root.Position).Unit
    
    -- 1. Visual Lasso (Optional tapi bagus untuk bypass anticheat visual)
    -- Log 1: args = {[1] = 0.9, [2] = Vector3}
    Remotes.ThrowLasso:FireServer(0.9, direction)
    
    -- 2. Request Minigame (PENTING)
    -- Log 2: args = {[1] = PetInstance, [2] = CFrame}
    -- Kita gunakan CFrame pemain saat ini
    task.wait(0.5)
    Remotes.minigameRequest:InvokeServer(targetPet, root.CFrame)
    Remotes.retrieveData:InvokeServer()
    
    -- 3. Visual Equip (Log 4)
    Remotes.equipLassoVisual:InvokeServer(true)
    
    -- 4. Bypass Progress Bar (Log 5-9)
    -- Mengirim paket progress secara cepat
    local progressSteps = {0, 30, 40, 95, 100}
    
    for _, prog in ipairs(progressSteps) do
        Remotes.UpdateProgress:FireServer(prog)
        task.wait(0.1) -- Delay kecil agar terlihat "natural" tapi cepat
    end
    
    -- 5. Finalize Data (Log 10)
    Remotes.retrieveData:InvokeServer()
    
    -- Catatan: Log 11 & 12 (RequestWalkPet) tidak saya masukkan otomatis
    -- agar inventory Anda tidak berantakan dengan auto-equip setiap kali menangkap.
end

local Section = Tab:CreateSection("Konfigurasi Target")

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

Tab:CreateToggle({
   Name = "Hanya Cari Mutasi (Mutation Only)",
   CurrentValue = false,
   Flag = "MutationToggle", 
   Callback = function(Value)
      getgenv().MutationOnly = Value
   end,
})

local Section2 = Tab:CreateSection("Eksekusi & Catch")

Tab:CreateToggle({
   Name = "Auto Catch setelah Teleport",
   CurrentValue = true,
   Flag = "AutoCatchToggle", 
   Callback = function(Value)
      getgenv().AutoCatchEnabled = Value
   end,
})

-- Fungsi Teleport + Trigger Catch
local function TeleportAndCatch()
    local p = game.Players.LocalPlayer
    local folder = workspace:FindFirstChild("RoamingPets") and workspace.RoamingPets:FindFirstChild("Pets")
    local foundTarget = false 
    
    if folder and p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
        for _, pet in pairs(folder:GetChildren()) do
            local petRarity = pet:GetAttribute("Rarity")
            local petMutation = pet:GetAttribute("Mutation")
            local isTarget = false
            
            if getgenv().MutationOnly then
                if petMutation and petMutation ~= "None" then isTarget = true end
            else
                if petRarity == getgenv().SelectRarity then isTarget = true end
            end
            
            if isTarget then
                if pet:IsA("Model") or pet:IsA("BasePart") then
                    -- 1. Teleport
                    p.Character.HumanoidRootPart.CFrame = pet:GetPivot()
                    
                    Rayfield:Notify({
                        Title = "Target Ditemukan!",
                        Content = "Mencoba menangkap: " .. (pet:GetAttribute("Name") or "Unknown"),
                        Duration = 3,
                        Image = 4483362458,
                    })
                    
                    -- Tunggu sebentar agar server sadar kita dekat pet
                    task.wait(0.5)
                    
                    -- 2. Jalankan Auto Catch jika diaktifkan
                    if getgenv().AutoCatchEnabled then
                        RunCatchProtocol(pet)
                        Rayfield:Notify({
                            Title = "Selesai!",
                            Content = "Proses penangkapan selesai.",
                            Duration = 3,
                            Image = 4483362458,
                        })
                    end
                    
                    foundTarget = true
                    break 
                end
            end
        end
    end
    
    if not foundTarget then
        Rayfield:Notify({
            Title = "Tidak Ditemukan",
            Content = "Tidak ada Pet sesuai kriteria.",
            Duration = 3,
            Image = 4483362458,
        })
    end
end

Tab:CreateButton({
   Name = "Cari & Tangkap (Sekali)",
   Callback = function()
      TeleportAndCatch()
   end,
})

-- ESP Section (Tetap sama)
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
                    highlight.Parent = pet
                end
                local bg = pet:FindFirstChild("InfoGui") or Instance.new("BillboardGui", pet)
                bg.Name = "InfoGui"
                bg.Size = UDim2.new(0, 100, 0, 50)
                bg.AlwaysOnTop = true
                bg.Adornee = pet
                local txt = bg:FindFirstChild("TextLabel") or Instance.new("TextLabel", bg)
                txt.Size = UDim2.new(1,0,1,0)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = Color3.new(1,1,1)
                txt.Text = (pet:GetAttribute("Rarity") or "?") .. "\n" .. (pet:GetAttribute("Mutation") or "None")
            end
        end
    end
end

Tab:CreateToggle({
   Name = "Aktifkan ESP",
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

