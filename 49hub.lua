-- ========================================================
--                     49HUB - MM2 SCRIPT                  
--                 UI Theme: Dark / Gray Minimal           
-- ========================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "49hub | Murder Mystery 2",
   Icon = 0,
   LoadingTitle = "49hub Loading...",
   LoadingSubtitle = "by 49hub Team",
   Theme = "Dark", -- ใช้โทนสีเทาเข้มมินิมอล

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "49hub_Settings",
      FileName = "MM2_Config"
   },

   KeySystem = false -- ปิดระบบคีย์เพื่อความสะดวกในการใช้งาน
})

-- ==================== TABS ====================
local MainTab = Window:CreateTab("Main", 4483362458)
local EspTab = Window:CreateTab("Visuals / ESP", 4483362458)
local CombatTab = Window:CreateTab("Combat", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

-- ==================== MAIN TAB ====================
MainTab:CreateSection("Auto Farming")

local AutoCoin = false
MainTab:CreateToggle({
   Name = "Auto Collect Coins (เก็บเหรียญอัตโนมัติ)",
   CurrentValue = false,
   Flag = "AutoCoinToggle",
   Callback = function(Value)
      AutoCoin = Value
      task.spawn(function()
         while AutoCoin do
            task.wait(0.1)
            pcall(function()
               local container = workspace:FindFirstChild("CoinContainer") or workspace:FindFirstChild("CoinArea")
               if container then
                  for _, coin in pairs(container:GetChildren()) do
                     if AutoCoin and coin:IsA("BasePart") and game.Players.LocalPlayer.Character then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = coin.CFrame
                        task.wait(0.2)
                     end
                  end
               end
            end)
         end
      end)
   end,
})

MainTab:CreateSection("Movement")

MainTab:CreateSlider({
   Name = "WalkSpeed (ความเร็วการเดิน)",
   Range = {16, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

MainTab:CreateSlider({
   Name = "JumpPower (กระโดดสูง)",
   Range = {50, 200},
   Increment = 5,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(Value)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
         game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
      end
   end,
})

-- ==================== ESP TAB ====================
EspTab:CreateSection("Player ESP")

local EspEnabled = false
EspTab:CreateToggle({
   Name = "Enable Roles ESP (มองเห็นบทบาทผู้เล่น)",
   CurrentValue = false,
   Flag = "EspToggle",
   Callback = function(Value)
      EspEnabled = Value
      task.spawn(function()
         while EspEnabled do
            task.wait(1)
            for _, player in pairs(game.Players:GetPlayers()) do
               if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                  local head = player.Character.Head
                  local billboard = head:FindFirstChild("49hub_ESP") or Instance.new("BillboardGui")
                  billboard.Name = "49hub_ESP"
                  billboard.AlwaysOnTop = true
                  billboard.Size = UDim2.new(0, 100, 0, 50)
                  billboard.StudsOffset = Vector3.new(0, 2, 0)
                  billboard.Parent = head

                  local textLabel = billboard:FindFirstChild("TextLabel") or Instance.new("TextLabel")
                  textLabel.Parent = billboard
                  textLabel.Size = UDim2.new(1, 0, 1, 0)
                  textLabel.BackgroundTransparency = 1
                  textLabel.TextScaled = true
                  textLabel.Font = Enum.Font.SourceSansBold

                  -- เช็คบทบาท (Murder / Sheriff / Innocent)
                  if player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then
                     textLabel.Text = player.Name .. " [MURDER]"
                     textLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                  elseif player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun") then
                     textLabel.Text = player.Name .. " [SHERIFF]"
                     textLabel.TextColor3 = Color3.fromRGB(50, 150, 255)
                  else
                     textLabel.Text = player.Name .. " [INNOCENT]"
                     textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                  end

                  billboard.Enabled = EspEnabled
               end
            end
         end
         if not EspEnabled then
            for _, player in pairs(game.Players:GetPlayers()) do
               if player.Character and player.Character:FindFirstChild("Head") then
                  local esp = player.Character.Head:FindFirstChild("49hub_ESP")
                  if esp then esp:Destroy() end
               end
            end
         end
      end)
   end,
})

-- ==================== COMBAT TAB ====================
CombatTab:CreateSection("Sheriff Helper")

CombatTab:CreateButton({
   Name = "Shoot Murderer (ยิงฆาตกรอัตโนมัติ)",
   Callback = function()
      pcall(function()
         for _, plr in pairs(game.Players:GetPlayers()) do
            if plr.Backpack:FindFirstChild("Knife") or (plr.Character and plr.Character:FindFirstChild("Knife")) then
               local gun = game.Players.LocalPlayer.Character:FindFirstChild("Gun") or game.Players.LocalPlayer.Backpack:FindFirstChild("Gun")
               if gun then
                  game.Players.LocalPlayer.Character.Humanoid:EquipTool(gun)
                  task.wait(0.1)
                  -- จำลองการยิงไปยังตำแหน่งฆาตกร
                  gun:Activate()
               end
            end
         end
      end)
   end,
})

-- ==================== MISC TAB ====================
MiscTab:CreateSection("Server Settings")

MiscTab:CreateButton({
   Name = "Rejoin Server (เข้าเซิร์ฟเวอร์ใหม่)",
   Callback = function()
      game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
   end,
})

Rayfield:Notify({
   Title = "49hub Activated",
   Content = "โหลด UI โทนสีเทาเรียบร้อยแล้ว!",
   Duration = 5,
   Image = 4483362458,
})
