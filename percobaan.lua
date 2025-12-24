local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Catch and Tame: AUTO FARM",
   LoadingTitle = "Memuat Script...",
   LoadingSubtitle = "JumantaraHub v10",
   Theme= "Ocean",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, 
      FileName = "CatchAndTame_Autov10"
   },
   Discord = {
      Enabled = false,
      Invite = "", 
      RememberJoins = true 
   },
   KeySystem = false, 
})

local Tab = Window:CreateTab("Main", 4483362458)
local CollectTab = Window:CreateTab("Auto Collect", 4483362458)
local SellTab = Window:CreateTab("Auto Sell", 4483362458)
local BuyTab = Window:CreateTab("Auto Buy Food", 4483362458)

getgenv().SelectRarity = "Legendary"
getgenv().MutationOnly = false
getgenv().AutoCatchEnabled = true
getgenv().DebugMode = true
getgenv().AutoCollectCash = false
getgenv().AutoSell = false
getgenv().SellConfig = {
    ["Common"] = false,
    ["Uncommon"] = false,
    ["Rare"] = false,
    ["Epic"] = false,
    ["Legendary"] = false,
    ["Mythical"] = false
}
getgenv().AutoBuyFood = false
getgenv().SelectedFoodList = {}-- Default
getgenv().BuyAmount = 1

local rarityList = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical"}
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local foodList = {
    "Apple", "Banana", "Orange", "Watermelon", "Pizza", 
    "Burger", "Sushi", "Ice Cream", "Cake", "Steak" 
    -- Tambahkan nama lain di sini jika ada
}
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

-- FUNGSI BARU: Auto Farm Khusus Event Candy
local function StartCandyFarm()
    -- Menggunakan spawn agar loop berjalan di background tidak membuat game freeze
    task.spawn(function()
        while getgenv().AutoFarmCandy do
            local folder = workspace:FindFirstChild("RoamingPets") and workspace.RoamingPets:FindFirstChild("Pets")
            local foundTarget = false
            
            if folder then
                for _, pet in pairs(folder:GetChildren()) do
                    -- Cek status toggle setiap saat agar bisa dimatikan kapan saja
                    if not getgenv().AutoFarmCandy then break end
                    
                    -- Deteksi Pet berdasarkan Attribute "CandyMax" (Sesuai Screenshot)
                    -- Kita cek apakah attribute itu ada (nil atau tidak)
                    local isCandyPet = pet:GetAttribute("CandyMax")
                    
                    if isCandyPet and (pet:IsA("Model") or pet:IsA("BasePart")) then
                        foundTarget = true
                        
                        -- Proses Teleport & Catch
                        local p = game.Players.LocalPlayer
                        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            -- Teleport ke lokasi Pet
                            p.Character.HumanoidRootPart.CFrame = pet:GetPivot()
                            task.wait(0.5) -- Delay agar server memuat posisi kita
                            
                            -- Panggil fungsi catch yang sudah dibuat sebelumnya
                            -- Pastikan fungsi RunCatchProtocol sudah ada di script Anda
                            RunCatchProtocol(pet)
                            
                            -- Tunggu proses tangkap selesai sebelum cari yang lain
                            -- Sesuaikan waktu ini (4 detik biasanya cukup untuk animasi + server)
                            task.wait(4)
                        end
                    end
                end
            end
            
            -- Jika tidak ada pet candy tersisa, tunggu sebentar sebelum scan ulang
            if not foundTarget and getgenv().AutoFarmCandy then
                Rayfield:Notify({Title = "Menunggu Spawn", Content = "Mencari Pet Candy...", Duration = 1})
                task.wait(3)
            end
            
            task.wait(0.5) -- Delay aman loop
        end
    end)
end

-- FUNGSI BARU: Auto Farm Berdasarkan Rarity/Mutation (Looping)
local function StartRarityFarm()
    task.spawn(function()
        while getgenv().AutoFarmRarity do
            local folder = workspace:FindFirstChild("RoamingPets") and workspace.RoamingPets:FindFirstChild("Pets")
            local foundTarget = false
            
            if folder then
                for _, pet in pairs(folder:GetChildren()) do
                    if not getgenv().AutoFarmRarity then break end -- Cek jika dimatikan tiba-tiba
                    
                    -- Filter Logic (Sama seperti sebelumnya)
                    local r = pet:GetAttribute("Rarity")
                    local m = pet:GetAttribute("Mutation")
                    local isTarget = false

                    if getgenv().MutationOnly then
                        if m and m ~= "None" then isTarget = true end
                    elseif r == getgenv().SelectRarity then
                        isTarget = true
                    end
                    
                    if isTarget and (pet:IsA("Model") or pet:IsA("BasePart")) then
                        foundTarget = true
                        
                        -- Proses Eksekusi
                        local p = game.Players.LocalPlayer
                        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            -- Teleport
                            p.Character.HumanoidRootPart.CFrame = pet:GetPivot() * CFrame.new(0, 2, 0)
                            
                            -- Tunggu sebentar (Server Sync)
                            task.wait(0.5)
                            
                            -- Panggil fungsi catch protocol (Safe Mode)
                            RunCatchProtocol(pet)
                            
                            -- Delay sebelum lanjut ke pet berikutnya
                            -- Beri waktu 4-5 detik agar animasi selesai & inventory update
                            task.wait(4.5)
                        end
                    end
                end
            end
            
            -- Jika tidak ada target, tunggu sebentar sebelum scan ulang
            if not foundTarget and getgenv().AutoFarmRarity then
                Rayfield:Notify({Title = "Mencari...", Content = "Menunggu spawn " .. getgenv().SelectRarity, Duration = 1})
                task.wait(3)
            end
            
            task.wait(1) -- Delay loop utama
        end
    end)
end

local function StartAutoCollect()
    task.spawn(function()
        while getgenv().AutoCollectCash do
            local p = game.Players.LocalPlayer
            local pensFolder = workspace:FindFirstChild("PlayerPens")
            local myPen = nil

            -- 1. Cari Pen Milik Player (Berdasarkan Attribute "Owner")
            if pensFolder then
                for _, pen in pairs(pensFolder:GetChildren()) do
                    -- Cek attribute Owner
                    local ownerName = pen:GetAttribute("Owner")
                    if ownerName == p.Name then
                        myPen = pen
                        break
                    end
                end
            end

            -- 2. Eksekusi Collect jika Pen ditemukan
            if myPen then
                local petsFolder = myPen:FindFirstChild("Pets")
                if petsFolder then
                    for _, pet in pairs(petsFolder:GetChildren()) do
                        -- Cek status toggle biar bisa berhenti seketika
                        if not getgenv().AutoCollectCash then break end
                        
                        -- Remote Argument: UUID Pet (Biasanya Nama Folder Pet = UUID)
                        -- Menggunakan pcall agar script tidak stop jika ada error kecil
                        pcall(function()
                            local args = {
                                [1] = pet.Name -- Mengambil UUID dari nama folder pet
                            }
                            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("collectPetCash"):FireServer(unpack(args))
                        end)
                        
                        -- Delay sangat kecil antar pet agar remote masuk (0.05 - 0.1 detik)
                        task.wait(0.05) 
                    end
                end
            else
                -- Jika Pen belum ketemu (mungkin belum loading)
                if getgenv().DebugMode then
                    warn("Pen player tidak ditemukan. Pastikan sudah claim tycoon/pen.")
                end
            end

            -- Delay sebelum scan ulang (2 detik cukup cepat)
            task.wait(2)
        end
    end)
end

-- Logic Auto Sell
local function StartAutoSell()
    task.spawn(function()
        while getgenv().AutoSell do
            local RS = game:GetService("ReplicatedStorage")
            
            -- 1. Ambil Data Inventory Terbaru
            local success, inventory = pcall(function()
                return RS.Remotes.getPetInventory:InvokeServer()
            end)

            if success and inventory then
                local soldCount = 0
                
                for uuid, data in pairs(inventory) do
                    -- Cek status toggle utama
                    if not getgenv().AutoSell then break end

                    -- 2. Filter Berdasarkan Rarity Pilihan
                    if data.rarity and getgenv().SellConfig[data.rarity] then
                        
                        -- Cek Keamanan: Jangan jual pet yang sedang dipakai (Equipped)
                        -- Di banyak game, data inventory punya flag 'equipped' atau 'isEquipped'
                        if not data.equipped and not data.isEquipped then
                            
                            -- 3. Eksekusi Jual (Sesuai Decompile: UUID, false)
                            pcall(function()
                                RS.Remotes.sellPet:InvokeServer(uuid, false)
                            end)
                            
                            soldCount = soldCount + 1
                            task.wait(0.1) -- Jeda per pet agar tidak disconnect
                        end
                    end
                end
                
                if soldCount > 0 then
                   -- Optional: Print ke console (F9) untuk memantau
                   if getgenv().DebugMode then print("Terjual: " .. soldCount .. " pets.") end
                end
            else
                if getgenv().DebugMode then warn("Gagal mengambil inventory") end
            end
            
            -- Delay sebelum scan ulang inventory (3 detik)
            task.wait(3) 
        end
    end)
end

local function StartAutoBuy()
    task.spawn(function()
        while getgenv().AutoBuyFood do
            -- Menggunakan pcall agar script tidak berhenti total jika ada error kecil
            local success, err = pcall(function()
                
                -- PATH REMOTE TERBARU (Sesuai temuan Anda)
                -- Menggunakan WaitForChild di awal untuk memastikan game sudah loading
                local RS = game:GetService("ReplicatedStorage")
                local Packages = RS:WaitForChild("Packages")
                local Index = Packages:WaitForChild("_Index")
                
                -- Mencari folder knit yang spesifik "sleitnick_knit@1.7.0"
                -- Kita gunakan bracket ["nama"] karena ada karakter @ dan .
                local KnitPkg = Index:WaitForChild("sleitnick_knit@1.7.0") 
                local Services = KnitPkg:WaitForChild("knit"):WaitForChild("Services")
                local BuyRemote = Services:WaitForChild("FoodService"):WaitForChild("RE"):WaitForChild("BuyFood")

                if BuyRemote then
                    -- LOOPING: Membeli setiap makanan yang dipilih
                    for _, foodName in pairs(getgenv().SelectedFoodList) do
                        
                        -- Cek lagi jika toggle dimatikan saat loop berjalan
                        if not getgenv().AutoBuyFood then break end

                        -- Fire Remote dengan argumen: (NamaMakanan, Jumlah)
                        BuyRemote:FireServer(foodName, getgenv().BuyAmount)
                        
                        -- Delay kecil antar item (0.2 detik)
                        task.wait(0.2) 
                    end
                end
            end)

            if not success and getgenv().DebugMode then
                warn("Error Auto Buy: " .. tostring(err))
            end

            -- Delay setelah satu putaran selesai
            task.wait(1) 
        end
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

Tab:CreateToggle({
   Name = "Auto Farm Event Candy (Loop)",
   CurrentValue = false,
   Flag = "CandyFarmToggle", 
   Callback = function(Value)
      getgenv().AutoFarmCandy = Value
      if Value then
          Rayfield:Notify({Title = "Auto Farm Aktif", Content = "Mulai berburu Pet Candy...", Duration = 2})
          StartCandyFarm()
      else
          Rayfield:Notify({Title = "Auto Farm Stop", Content = "Berhenti setelah target saat ini.", Duration = 2})
      end
   end,
})
local SectionExecution = Tab:CreateSection("Eksekusi")

-- 1. TOMBOL SINGLE CATCH (Hanya 1 Kali)
Tab:CreateButton({
   Name = "Tangkap 1 Target (Safe Mode)",
   Callback = function()
      Rayfield:Notify({Title = "Mode Manual", Content = "Mencari 1 target...", Duration = 2})
      
      local folder = workspace:FindFirstChild("RoamingPets") and workspace.RoamingPets:FindFirstChild("Pets")
      if not folder then return end
      
      local found = false
      for _, pet in pairs(folder:GetChildren()) do
          local r = pet:GetAttribute("Rarity")
          local m = pet:GetAttribute("Mutation")
          local isTarget = false

          -- Filter
          if getgenv().MutationOnly then
              if m and m ~= "None" then isTarget = true end
          elseif r == getgenv().SelectRarity then
              isTarget = true
          end

          if isTarget and (pet:IsA("Model") or pet:IsA("BasePart")) then
              found = true
              
              -- Teleport & Catch Sekali Saja
              local p = game.Players.LocalPlayer
              if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                  p.Character.HumanoidRootPart.CFrame = pet:GetPivot() * CFrame.new(0, 5, 5)
                  task.wait(0.5)
                  p.Character.HumanoidRootPart.CFrame = pet:GetPivot() -- Koreksi posisi
                  task.wait(1) -- Waktu untuk sync
                  
                  RunCatchProtocol(pet) -- Eksekusi
                  
                  Rayfield:Notify({Title = "Selesai", Content = "Target diproses.", Duration = 2})
              end
              break -- PENTING: Perintah ini menghentikan loop setelah ketemu 1
          end
      end
      
      if not found then
          Rayfield:Notify({Title = "Kosong", Content = "Tidak ada target " .. getgenv().SelectRarity, Duration = 2})
      end
   end,
})

-- 2. TOGGLE AUTO FARM (Looping Terus-menerus)
Tab:CreateToggle({
   Name = "Auto Farm Rarity Terpilih (Loop)",
   CurrentValue = false,
   Flag = "RarityFarmToggle", 
   Callback = function(Value)
      getgenv().AutoFarmRarity = Value
      if Value then
          Rayfield:Notify({Title = "Auto Farm ON", Content = "Mencari semua " .. getgenv().SelectRarity, Duration = 2})
          StartRarityFarm()
      else
          Rayfield:Notify({Title = "Auto Farm OFF", Content = "Berhenti setelah target ini.", Duration = 2})
      end
   end,
})

-- AUTO COLLECT TAB
local SectionCollect = CollectTab:CreateSection("Fitur Farming")

CollectTab:CreateToggle({
   Name = "Auto Collect Cash (My Pen)",
   CurrentValue = false,
   Flag = "AutoCollectToggle", 
   Callback = function(Value)
      getgenv().AutoCollectCash = Value
      if Value then
          Rayfield:Notify({Title = "Auto Collect ON", Content = "Mengambil cash dari Pen Anda...", Duration = 2})
          StartAutoCollect()
      else
          Rayfield:Notify({Title = "Auto Collect OFF", Content = "Berhenti mengambil cash.", Duration = 2})
      end
   end,
})

-- AUTO SELL TAB
local SectionConfig = SellTab:CreateSection("Pilih Rarity untuk Dijual")

-- Loop untuk membuat Toggle setiap Rarity secara otomatis
local rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical"}

for _, rarity in ipairs(rarities) do
    SellTab:CreateToggle({
       Name = "Jual " .. rarity,
       CurrentValue = false,
       Flag = "Sell" .. rarity, -- ID Unik untuk Config
       Callback = function(Value)
          getgenv().SellConfig[rarity] = Value
       end,
    })
end

local SectionAction = SellTab:CreateSection("Eksekusi")

SellTab:CreateToggle({
   Name = "Aktifkan Auto Sell (Loop)",
   CurrentValue = false,
   Flag = "AutoSellMain", 
   Callback = function(Value)
      getgenv().AutoSell = Value
      if Value then
          Rayfield:Notify({Title = "Auto Sell ON", Content = "Mulai menjual pet terpilih...", Duration = 2})
          StartAutoSell()
      else
          Rayfield:Notify({Title = "Auto Sell OFF", Content = "Berhenti menjual.", Duration = 2})
      end
   end,
})

-- AUTO BUY FOOD TAB
local SectionBuy = BuyTab:CreateSection("Konfigurasi Pembelian")

BuyTab:CreateDropdown({
   Name = "Pilih Makanan (Bisa Lebih dari 1)",
   Options = foodList,
   CurrentOption = {"Apple"}, 
   MultipleOptions = true, -- Multi Select aktif
   Flag = "FoodDropdownMulti", 
   Callback = function(Option)
      getgenv().SelectedFoodList = Option
   end,
})

BuyTab:CreateSlider({
   Name = "Jumlah Per Item",
   Range = {1, 100},
   Increment = 1,
   Suffix = "Pcs",
   CurrentValue = 1,
   Flag = "BuyAmountSlider", 
   Callback = function(Value)
      getgenv().BuyAmount = Value
   end,
})

local SectionExec = BuyTab:CreateSection("Eksekusi")

BuyTab:CreateToggle({
   Name = "Auto Buy Food (Loop)",
   CurrentValue = false,
   Flag = "AutoBuyToggle", 
   Callback = function(Value)
      getgenv().AutoBuyFood = Value
      if Value then
          Rayfield:Notify({Title = "Auto Buy ON", Content = "Membeli makanan...", Duration = 2})
          StartAutoBuy()
      else
          Rayfield:Notify({Title = "Auto Buy OFF", Content = "Berhenti.", Duration = 2})
      end
   end,
})
Rayfield:LoadConfiguration()










