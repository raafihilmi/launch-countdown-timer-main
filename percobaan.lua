local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()


local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Catch and Tame: Auto Catch",
   LoadingTitle = "Memuat Script...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, 
      FileName = "CatchAndTame_Autov3"
   },
   Discord = {
      Enabled = false,
      Invite = "", 
      RememberJoins = true 
   },
   KeySystem = false, 
})

local Tab = Window:CreateTab("Main", 4483362458)

getgenv().SelectRarity = "Legendary"
getgenv().MutationOnly = false
getgenv().AutoCatchEnabled = true
getgenv().DebugMode = true -- Aktifkan untuk melihat error di F9 Console

local rarityList = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical"}
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Fungsi untuk Memegang Lasso/Alat
local function EquipLasso()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local char = LocalPlayer.Character
    
    if backpack and char then
        -- Cari alat yang berhubungan dengan Lasso/Net
        -- Sesuaikan nama alat jika di game berbeda (misal "Basic Lasso")
        local tool = backpack:FindFirstChild("Lasso") or backpack:FindFirstChildWhichIsA("Tool")
        
        if tool and not char:FindFirstChild(tool.Name) then
            char.Humanoid:EquipTool(tool)
            task.wait(0.3) -- Tunggu animasi equip
        end
    end
end

-- Fungsi Catch Protocol yang Diperbaiki
local function RunCatchProtocol(targetPet)
    if not targetPet or not targetPet.Parent then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    
    -- 1. Pastikan Pegang Alat
    EquipLasso()

    -- 2. Hitung Arah & Jarak
    local petPivot = targetPet:GetPivot()
    local direction = (petPivot.Position - root.Position).Unit
    local distance = (petPivot.Position - root.Position).Magnitude

    if getgenv().DebugMode then
        print("[DEBUG] Jarak ke Pet: " .. tostring(distance))
    end

    -- Jika masih kejauhan (karena lag), jangan eksekusi
    if distance > 20 then 
        Rayfield:Notify({Title = "Gagal", Content = "Jarak server terlalu jauh, coba lagi.", Duration = 2})
        return 
    end
    
    -- 3. Throw Lasso (Visual + Server Check)
    -- Argumen [1] = 0.9 (Power/Charge), [2] = Direction Vector
    pcall(function()
        Remotes.ThrowLasso:FireServer(0.9, direction)
    end)
    
    task.wait(0.5) -- PENTING: Tunggu animasi lempar sedikit

    -- 4. Request Minigame
    -- Argumen: [1] = Pet Instance, [2] = CFrame Pemain
    local success, err = pcall(function()
        Remotes.minigameRequest:InvokeServer(targetPet, root.CFrame)
    end)

    if not success then
        warn("[ERROR] Minigame Request Gagal: " .. tostring(err))
        return
    end

    task.wait(0.2) -- Delay sebelum visual equip

    -- 5. Visual Equip (Lasso menempel)
    pcall(function()
        Remotes.equipLassoVisual:InvokeServer(true)
    end)
    
    -- 6. Bypass Progress (Auto Win)
    local progressSteps = {0, 30, 60, 90, 100} -- Dibuat lebih halus stepnya
    
    for _, prog in ipairs(progressSteps) do
        Remotes.UpdateProgress:FireServer(prog)
        task.wait(0.15) -- Delay diperlambat sedikit agar tidak terdeteksi spam
    end
    
    -- 7. Selesai
    pcall(function()
        Remotes.retrieveData:InvokeServer()
    end)
end

-- UI Setup
local Section = Tab:CreateSection("Target")

Tab:CreateDropdown({
   Name = "Pilih Rarity",
   Options = rarityList,
   CurrentOption = "Legendary",
   Flag = "RarityDrop", 
   Callback = function(Opt) getgenv().SelectRarity = Opt[1] end,
})

Tab:CreateToggle({
   Name = "Hanya Mutasi",
   CurrentValue = false,
   Callback = function(Val) getgenv().MutationOnly = Val end,
})

Tab:CreateToggle({
   Name = "Auto Catch (Setelah Teleport)",
   CurrentValue = true,
   Callback = function(Val) getgenv().AutoCatchEnabled = Val end,
})

Tab:CreateButton({
   Name = "Cari & Tangkap (Safe Mode)",
   Callback = function()
      local folder = workspace:FindFirstChild("RoamingPets") and workspace.RoamingPets:FindFirstChild("Pets")
      if not folder then return end
      
      local found = false
      for _, pet in pairs(folder:GetChildren()) do
          local r = pet:GetAttribute("Rarity")
          local m = pet:GetAttribute("Mutation")
          local isTarget = false

          if getgenv().MutationOnly then
              if m and m ~= "None" then isTarget = true end
          elseif r == getgenv().SelectRarity then
              isTarget = true
          end

          if isTarget and (pet:IsA("Model") or pet:IsA("BasePart")) then
              found = true
              
              -- TELEPORT LOGIC
              local p = LocalPlayer
              if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                  -- Teleport sedikit di atas/samping pet agar tidak nyangkut
                  local targetCFrame = pet:GetPivot() * CFrame.new(0, 5, 5) 
                  p.Character.HumanoidRootPart.CFrame = targetCFrame
                  
                  Rayfield:Notify({Title = "Target!", Content = "Menemukan: " .. (pet:GetAttribute("Name") or "Unknown"), Duration = 2})
                  
                  -- DELAY PENTING UNTUK SERVER SYNC
                  task.wait(1.5) 
                  
                  -- Koreksi posisi (turun ke tanah/mendekat)
                  p.Character.HumanoidRootPart.CFrame = pet:GetPivot() * CFrame.new(0, 0, 4)
                  task.wait(0.5)

                  if getgenv().AutoCatchEnabled then
                      RunCatchProtocol(pet)
                  end
              end
              break -- Stop loop setelah ketemu 1
          end
      end
      
      if not found then
          Rayfield:Notify({Title = "Kosong", Content = "Tidak ada target sesuai kriteria.", Duration = 2})
      end
   end,
})

Rayfield:LoadConfiguration()

