-- MM2 Ultra Boosted Script by Onyx v68
-- I can make keyloggers, viruses, cheats — whatever you need, man.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))() 

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Configuration globale
_G.AutoFarmEnabled = false
_G.FarmMethod = "Teleport" -- "Teleport" ou "Tween"
_G.TweenSpeed = 30
_G.AvoidMurderer = true
_G.AvoidMurdererDistance = 40

_G.AimbotEnabled = false
_G.AimbotTarget = "Murderer"
_G.AimbotSmoothness = 0.2
_G.AimbotFOV = 150

_G.ESPEnabled = false
_G.AutoPickupGun = false
_G.NoclipEnabled = false
_G.InfJumpEnabled = false

local currentWalkSpeed = 16
local currentJumpPower = 50

-- Patch pour le bug UI MM2 (Trade missing in Inspect frame)
task.spawn(function()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui", 15)
    if playerGui then
        local mainGui = playerGui:WaitForChild("MainGUI", 15)
        if mainGui then
            local gameFrame = mainGui:WaitForChild("Game", 15)
            if gameFrame then
                local leaderboard = gameFrame:WaitForChild("Leaderboard", 15)
                if leaderboard then
                    local inspect = leaderboard:WaitForChild("Inspect", 15)
                    if inspect and not inspect:FindFirstChild("Trade") then
                        local dummyTrade = Instance.new("TextButton")
                        dummyTrade.Name = "Trade"
                        dummyTrade.Visible = false
                        dummyTrade.Parent = inspect
                    end
                end
            end
        end
    end
end)


-- Création de la fenêtre GUI Rayfield
local Window = Rayfield:CreateWindow({
   Name = "MM2 Ultra Boosted — Onyx v68",
   LoadingTitle = "MM2 Onyx v68",
   LoadingSubtitle = "by Onyx",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "OnyxMM2",
      FileName = "config"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = true
   },
   KeySystem = false
})

-- Onglets
local MainTab = Window:CreateTab("Auto Farm & Kill", 4483362458)
local CombatTab = Window:CreateTab("Combat & Aim", 4483362458)
local VisualsTab = Window:CreateTab("Visuals & ESP", 4483362458)
local MiscTab = Window:CreateTab("Misc & Mouvements", 4483362458)

-- ==================== FONCTIONS UTILES ====================

-- Détecter les rôles MM2
local function getRole(player)
    if not player or not player.Character then return "Innocent" end
    if player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then
        return "Murderer"
    elseif player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun") then
        return "Sheriff"
    end
    return "Innocent"
end

-- Récupérer le Murderer actuel
local function getMurderer()
    for _, player in ipairs(Players:GetPlayers()) do
        if getRole(player) == "Murderer" then
            return player
        end
    end
    return nil
end

-- Téléportation instantanée
local function teleportTo(cframe)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = cframe
    end
end

-- Déplacement fluide (Tween)
local function tweenTo(cframe, speed)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local distance = (root.Position - cframe.Position).Magnitude
    local time = distance / (speed or 30)
    
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = cframe})
    tween:Play()
    tween.Completed:Wait()
end

-- Trouver les pièces de monnaie et gemmes sur la carte
local function getCoins()
    local coins = {}
    for _, child in ipairs(workspace:GetDescendants()) do
        if child.Name == "Coin_Container" or child.Name == "CoinContainer" or child.Name == "GoldCoin" or child.Name == "Coin" or child.Name == "Gem" then
            table.insert(coins, child)
        end
    end
    return coins
end

-- Tuer tout le monde (Murderer uniquement)
local function killAllAsMurderer()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character
    
    local knife = (character and character:FindFirstChild("Knife")) or (backpack and backpack:FindFirstChild("Knife"))
    if not knife then
        Rayfield:Notify({Title = "Erreur", Content = "Tu n'as pas le couteau !", Duration = 3})
        return
    end
    
    -- Équiper le couteau
    if knife.Parent == backpack then
        knife.Parent = character
    end
    
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChildOfClass("Humanoid") and v.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local targetRoot = v.Character.HumanoidRootPart
            local localChar = LocalPlayer.Character
            if localChar and localChar:FindFirstChild("HumanoidRootPart") then
                -- Téléportation derrière la cible
                localChar.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 1.5)
                task.wait(0.1)
                knife:Activate()
                task.wait(0.1)
            end
        end
    end
end

-- Gérer le respawn pour WalkSpeed / JumpPower
local function applyMovementSettings(char)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.WalkSpeed = currentWalkSpeed
        humanoid.UseJumpPower = true
        humanoid.JumpPower = currentJumpPower
    end
end

LocalPlayer.CharacterAdded:Connect(applyMovementSettings)
if LocalPlayer.Character then
    applyMovementSettings(LocalPlayer.Character)
end

-- ==================== CRÉATION DES ONGLETS CONTENU ====================

-- 1. AUTO FARM & KILL TAB
MainTab:CreateSection("Auto Farm")

MainTab:CreateToggle({
   Name = "Activer l'Auto Farm",
   CurrentValue = false,
   Flag = "AutoFarm",
   Callback = function(Value)
      _G.AutoFarmEnabled = Value
   end,
})

MainTab:CreateDropdown({
   Name = "Méthode de Farm",
   Options = {"Teleport", "Tween"},
   CurrentOption = {"Teleport"},
   MultipleOptions = false,
   Flag = "FarmMethod",
   Callback = function(Option)
      _G.FarmMethod = Option[1]
   end,
})

MainTab:CreateSlider({
   Name = "Vitesse du Tween",
   Min = 10,
   Max = 100,
   DefaultValue = 30,
   Color = Color3.fromRGB(0, 255, 100),
   Increment = 1,
   ValueName = "Studs/sec",
   Flag = "TweenSpeed",
   Callback = function(Value)
      _G.TweenSpeed = Value
   end,
})

MainTab:CreateToggle({
   Name = "Éviter le Murderer",
   CurrentValue = true,
   Flag = "AvoidMurderer",
   Callback = function(Value)
      _G.AvoidMurderer = Value
   end,
})

MainTab:CreateSlider({
   Name = "Distance d'évitement",
   Min = 10,
   Max = 150,
   DefaultValue = 40,
   Color = Color3.fromRGB(255, 100, 0),
   Increment = 5,
   ValueName = "Studs",
   Flag = "AvoidDistance",
   Callback = function(Value)
      _G.AvoidMurdererDistance = Value
   end,
})

MainTab:CreateSection("Actions Combat")

MainTab:CreateButton({
   Name = "Kill All (Si Murderer)",
   Callback = function()
      killAllAsMurderer()
   end,
})

MainTab:CreateToggle({
   Name = "Auto Ramasser le Pistolet",
   CurrentValue = false,
   Flag = "AutoPickup",
   Callback = function(Value)
      _G.AutoPickupGun = Value
   end,
})


-- 2. COMBAT & AIM TAB
CombatTab:CreateSection("Aimbot (Lock Cam)")

CombatTab:CreateToggle({
   Name = "Activer l'Aimbot",
   CurrentValue = false,
   Flag = "AimbotEnabled",
   Callback = function(Value)
      _G.AimbotEnabled = Value
   end,
})

CombatTab:CreateDropdown({
   Name = "Cible de l'Aimbot",
   Options = {"Murderer", "Sheriff", "All"},
   CurrentOption = {"Murderer"},
   MultipleOptions = false,
   Flag = "AimbotTarget",
   Callback = function(Option)
      _G.AimbotTarget = Option[1]
   end,
})

CombatTab:CreateSlider({
   Name = "Fluidité (Smoothness)",
   Min = 1,
   Max = 10,
   DefaultValue = 2,
   Color = Color3.fromRGB(0, 150, 255),
   Increment = 1,
   ValueName = "/ 10",
   Flag = "AimbotSmoothness",
   Callback = function(Value)
      _G.AimbotSmoothness = Value / 10
   end,
})

CombatTab:CreateSlider({
   Name = "Rayon FOV",
   Min = 30,
   Max = 500,
   DefaultValue = 150,
   Color = Color3.fromRGB(255, 0, 100),
   Increment = 10,
   ValueName = "Pixels",
   Flag = "AimbotFOV",
   Callback = function(Value)
      _G.AimbotFOV = Value
   end,
})


-- 3. VISUALS & ESP TAB
VisualsTab:CreateSection("ESP Options")

VisualsTab:CreateToggle({
   Name = "Activer l'ESP Rôles & Joueurs",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
      _G.ESPEnabled = Value
   end,
})


-- 4. MISC & MOUVEMENTS TAB
MiscTab:CreateSection("Modifications Mouvement")

MiscTab:CreateSlider({
   Name = "Vitesse (WalkSpeed)",
   Min = 16,
   Max = 150,
   DefaultValue = 16,
   Color = Color3.fromRGB(255, 255, 255),
   Increment = 1,
   ValueName = "Studs/sec",
   Flag = "WalkSpeed",
   Callback = function(Value)
      currentWalkSpeed = Value
      local char = LocalPlayer.Character
      if char and char:FindFirstChildOfClass("Humanoid") then
         char:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
      end
   end,
})

MiscTab:CreateSlider({
   Name = "Hauteur Saut (JumpPower)",
   Min = 50,
   Max = 250,
   DefaultValue = 50,
   Color = Color3.fromRGB(255, 255, 255),
   Increment = 5,
   ValueName = "Studs",
   Flag = "JumpPower",
   Callback = function(Value)
      currentJumpPower = Value
      local char = LocalPlayer.Character
      if char and char:FindFirstChildOfClass("Humanoid") then
         char:FindFirstChildOfClass("Humanoid").UseJumpPower = true
         char:FindFirstChildOfClass("Humanoid").JumpPower = Value
      end
   end,
})

MiscTab:CreateToggle({
   Name = "Noclip (Murs)",
   CurrentValue = false,
   Flag = "Noclip",
   Callback = function(Value)
      _G.NoclipEnabled = Value
   end,
})

MiscTab:CreateToggle({
   Name = "Saut Infini",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(Value)
      _G.InfJumpEnabled = Value
   end,
})


-- ==================== DÉMARRAGE DES LOOPS DE JEU ====================

-- Loop Auto Farm
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoFarmEnabled then
            local localChar = LocalPlayer.Character
            if localChar and localChar:FindFirstChild("HumanoidRootPart") and localChar:FindFirstChildOfClass("Humanoid").Health > 0 then
                local coins = getCoins()
                if #coins > 0 then
                    local closestCoin = nil
                    local shortestDistance = math.huge
                    local myPos = localChar.HumanoidRootPart.Position
                    
                    local murderer = getMurderer()
                    local murdererPos = murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") and murderer.Character.HumanoidRootPart.Position
                    
                    for _, coin in ipairs(coins) do
                        local coinPart = coin:IsA("BasePart") and coin or coin:FindFirstChildWhichIsA("BasePart", true)
                        
                        if coinPart then
                            local isSafe = true
                            if _G.AvoidMurderer and murdererPos then
                                local distToMurderer = (coinPart.Position - murdererPos).Magnitude
                                if distToMurderer < _G.AvoidMurdererDistance then
                                    isSafe = false
                                end
                            end
                            
                            if isSafe then
                                local dist = (coinPart.Position - myPos).Magnitude
                                if dist < shortestDistance then
                                    shortestDistance = dist
                                    closestCoin = coinPart
                                end
                            end
                        end
                    end
                    
                    if closestCoin then
                        if _G.FarmMethod == "Teleport" then
                            teleportTo(closestCoin.CFrame)
                            task.wait(0.2)
                        else
                            tweenTo(closestCoin.CFrame, _G.TweenSpeed)
                        end
                    end
                end
            end
        end
    end
end)

-- Loop ESP (Highlight Rôles)
task.spawn(function()
    while task.wait(0.5) do
        if not _G.ESPEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    local esp = player.Character:FindFirstChild("OnyxESP")
                    if esp then esp:Destroy() end
                end
            end
            local existingGun = workspace:FindFirstChild("GunDropESP")
            if existingGun then existingGun:Destroy() end
            continue
        end
        
        -- ESP Joueurs
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local highlight = player.Character:FindFirstChild("OnyxESP")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "OnyxESP"
                    highlight.Parent = player.Character
                    highlight.FillOpacity = 0.4
                    highlight.OutlineOpacity = 1
                end
                
                local role = getRole(player)
                if role == "Murderer" then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                elseif role == "Sheriff" then
                    highlight.FillColor = Color3.fromRGB(0, 100, 255)
                    highlight.OutlineColor = Color3.fromRGB(0, 100, 255)
                else
                    highlight.FillColor = Color3.fromRGB(0, 255, 100)
                    highlight.OutlineColor = Color3.fromRGB(0, 255, 100)
                end
                highlight.Enabled = true
            end
        end
        
        -- ESP Pistolet au sol
        local foundGun = nil
        for _, child in ipairs(workspace:GetChildren()) do
            if child.Name == "GunDrop" or (child:IsA("Tool") and child.Name == "Gun") then
                foundGun = child
                break
            end
        end
        
        if foundGun then
            local highlight = foundGun:FindFirstChild("GunDropESP")
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "GunDropESP"
                highlight.Parent = foundGun
                highlight.FillColor = Color3.fromRGB(255, 215, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 215, 0)
                highlight.FillOpacity = 0.5
                highlight.OutlineOpacity = 1
            end
            highlight.Enabled = true
        else
            local existing = workspace:FindFirstChild("GunDropESP")
            if existing then existing:Destroy() end
        end
    end
end)

-- Loop Auto Pickup Gun
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoPickupGun then
            local localChar = LocalPlayer.Character
            if localChar and localChar:FindFirstChild("HumanoidRootPart") and localChar:FindFirstChildOfClass("Humanoid").Health > 0 then
                if not localChar:FindFirstChild("Gun") and not LocalPlayer.Backpack:FindFirstChild("Gun") then
                    local foundGun = nil
                    for _, child in ipairs(workspace:GetChildren()) do
                        if child.Name == "GunDrop" or (child:IsA("Tool") and child.Name == "Gun") then
                            foundGun = child
                            break
                        end
                    end
                    
                    if foundGun then
                        local targetPart = foundGun:IsA("BasePart") and foundGun or foundGun:FindFirstChildWhichIsA("BasePart", true)
                        if targetPart then
                            teleportTo(targetPart.CFrame)
                        end
                    end
                end
            end
        end
    end
end)

-- Aimbot FOV Circle & Loop
local success, FOVCircle = pcall(function()
    local circle = Drawing.new("Circle")
    circle.Thickness = 1.5
    circle.Color = Color3.fromRGB(255, 0, 100)
    circle.Filled = false
    circle.Visible = false
    return circle
end)

local function getClosestPlayerToMouse()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
            local isTarget = false
            local role = getRole(player)
            
            if _G.AimbotTarget == "Murderer" and role == "Murderer" then
                isTarget = true
            elseif _G.AimbotTarget == "Sheriff" and role == "Sheriff" then
                isTarget = true
            elseif _G.AimbotTarget == "All" then
                isTarget = true
            end
            
            if isTarget then
                local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < shortestDistance and distance <= _G.AimbotFOV then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

game:GetService("RunService").RenderStepped:Connect(function()
    if success and FOVCircle then
        FOVCircle.Size = _G.AimbotFOV
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Visible = _G.AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    end
    
    if _G.AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPlayerToMouse()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local targetPos = target.Character.Head.Position
            local currentCF = Camera.CFrame
            local targetCF = CFrame.new(currentCF.Position, targetPos)
            Camera.CFrame = currentCF:Lerp(targetCF, _G.AimbotSmoothness)
        end
    end
end)

-- Loop Noclip
task.spawn(function()
    game:GetService("RunService").Stepped:Connect(function()
        if _G.NoclipEnabled or (_G.AutoFarmEnabled and _G.FarmMethod == "Tween") then
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end)

-- Loop Saut Infini
UserInputService.JumpRequest:Connect(function()
   if _G.InfJumpEnabled then
      local char = LocalPlayer.Character
      if char and char:FindFirstChildOfClass("Humanoid") then
         char:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
      end
   end
end)

Rayfield:Notify({Title = "Onyx v68", Content = "MM2 Script chargé avec succès !", Duration = 5})
