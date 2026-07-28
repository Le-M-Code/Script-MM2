loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- ==================== CONFIG ====================
_G.AutoFarm = false
_G.FarmMethode = "Teleport"
_G.VitesseTween = 30
_G.EviterMurderer = true
_G.DistanceEvitement = 40

_G.AutoKill = false

_G.Aimbot = false
_G.CibleAimbot = "Murderer"
_G.LissageAimbot = 0.2
_G.FOVAimbot = 150

_G.ESP = false
_G.ESPieces = false
_G.AutoPistolet = false
_G.Noclip = false
_G.SautInfini = false

local ws = 16
local jp = 50

-- ==================== FONCTIONS ====================

local function getRole(joueur)
	if not joueur or not joueur.Character then return "Innocent" end
	if joueur.Backpack:FindFirstChild("Knife") or joueur.Character:FindFirstChild("Knife") then
		return "Murderer"
	elseif joueur.Backpack:FindFirstChild("Gun") or joueur.Character:FindFirstChild("Gun") then
		return "Sheriff"
	end
	return "Innocent"
end

local function getMurderer()
	for _, p in ipairs(Players:GetPlayers()) do
		if getRole(p) == "Murderer" then return p end
	end
	return nil
end

local function tp(cf)
	local c = LP.Character
	if c and c:FindFirstChild("HumanoidRootPart") then
		c.HumanoidRootPart.CFrame = cf
	end
end

local function getPieces()
	local pieces = {}
	for _, enfant in ipairs(workspace:GetDescendants()) do
		if enfant.Name == "Coin_Container" or enfant.Name == "CoinContainer" or enfant.Name == "GoldCoin" or enfant.Name == "Coin" or enfant.Name == "Gem" then
			table.insert(pieces, enfant)
		end
	end
	return pieces
end

local function equiperCouteau()
	local sac = LP:FindFirstChild("Backpack")
	local perso = LP.Character
	local couteau = (perso and perso:FindFirstChild("Knife")) or (sac and sac:FindFirstChild("Knife"))
	if not couteau then return nil end

	if couteau.Parent == sac and perso and perso:FindFirstChildOfClass("Humanoid") then
		perso.Humanoid:EquipTool(couteau)
		task.wait(0.15)
	end
	return couteau
end

-- ==================== TUER TOUT LE MONDE (STABLE) ====================
local function tuerToutLeMonde()
	local ok, err = pcall(function()
		local couteau = equiperCouteau()
		if not couteau then
			Rayfield:Notify({Title = "Erreur", Content = "T'as pas le couteau frérot", Duration = 3})
			return
		end

		for _, v in ipairs(Players:GetPlayers()) do
			if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
				local humain = v.Character:FindFirstChildOfClass("Humanoid")
				if humain and humain.Health > 0 then
					local moi = LP.Character
					if moi and moi:FindFirstChild("HumanoidRootPart") then
						moi.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.5)
						task.wait(0.08)
						couteau:Activate()
						task.wait(0.08)
					end
				end
			end
		end
	end)
	if not ok then
		Rayfield:Notify({Title = "Erreur", Content = "Quelque chose a merdé mais c'est pas grave", Duration = 3})
	end
end

local function setupMouvement(perso)
	local h = perso:WaitForChild("Humanoid", 5)
	if h then
		h.WalkSpeed = ws
		h.UseJumpPower = true
		h.JumpPower = jp
	end
end

LP.CharacterAdded:Connect(setupMouvement)
if LP.Character then setupMouvement(LP.Character) end

-- ==================== UI ====================
local Fenetre = Rayfield:CreateWindow({
	Name = "Le M MM2",
	LoadingTitle = "Le M MM2",
	LoadingSubtitle = "Le meilleur pour MM2",
	ConfigurationSaving = { Enabled = false, FolderName = "LeMMM2", FileName = "config" },
	Discord = { Enabled = false },
	KeySystem = false
})

-- Onglet Farm
local FarmOnglet = Fenetre:CreateTab("Farm Pièces", 4483362458)
FarmOnglet:CreateSection("Configuration Auto Farm")

FarmOnglet:CreateToggle({
	Name = "Activer l'Auto Farm",
	CurrentValue = false,
	Flag = "AF",
	Callback = function(v) _G.AutoFarm = v end
})

FarmOnglet:CreateDropdown({
	Name = "Méthode",
	Options = {"Teleport", "Tween"},
	CurrentOption = {"Teleport"},
	MultipleOptions = false,
	Flag = "Methode",
	Callback = function(o) _G.FarmMethode = o[1] end
})

FarmOnglet:CreateSlider({
	Name = "Vitesse Tween",
	Min = 10, Max = 100, Default = 30,
	Color = Color3.fromRGB(0, 255, 100),
	Increment = 1, ValueName = "studs/s",
	Flag = "VTween",
	Callback = function(v) _G.VitesseTween = v end
})

FarmOnglet:CreateToggle({
	Name = "Éviter le Murderer",
	CurrentValue = true,
	Flag = "Evite",
	Callback = function(v) _G.EviterMurderer = v end
})

FarmOnglet:CreateSlider({
	Name = "Distance d'évitement",
	Min = 10, Max = 150, Default = 40,
	Color = Color3.fromRGB(255, 100, 0),
	Increment = 5, ValueName = "studs",
	Flag = "DistEvite",
	Callback = function(v) _G.DistanceEvitement = v end
})

-- Onglet Tuer
local TuerOnglet = Fenetre:CreateTab("Tuer", 4483362458)
TuerOnglet:CreateSection("Actions de Murderer")

TuerOnglet:CreateButton({
	Name = "Tuer tout le monde",
	Callback = tuerToutLeMonde
})

TuerOnglet:CreateToggle({
	Name = "Auto Kill en boucle",
	CurrentValue = false,
	Flag = "AK",
	Callback = function(v) _G.AutoKill = v end
})

TuerOnglet:CreateSection("Téléportations Rapides")

TuerOnglet:CreateButton({
	Name = "Aller au Murderer",
	Callback = function()
		local m = getMurderer()
		if m and m.Character and m.Character:FindFirstChild("HumanoidRootPart") then
			tp(m.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2))
		else
			Rayfield:Notify({Title = "Erreur", Content = "Murderer introuvable", Duration = 3})
		end
	end
})

TuerOnglet:CreateButton({
	Name = "Aller au Sheriff",
	Callback = function()
		local sherif = nil
		for _, p in ipairs(Players:GetPlayers()) do
			if getRole(p) == "Sheriff" then sherif = p break end
		end
		if sherif and sherif.Character and sherif.Character:FindFirstChild("HumanoidRootPart") then
			tp(sherif.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2))
		else
			Rayfield:Notify({Title = "Erreur", Content = "Sheriff introuvable", Duration = 3})
		end
	end
})

-- Onglet Combat
local CombatOnglet = Fenetre:CreateTab("Combat & Aim", 4483362458)
CombatOnglet:CreateSection("Aimbot")

CombatOnglet:CreateToggle({
	Name = "Activer l'Aimbot (Clic Droit)",
	CurrentValue = false,
	Flag = "Aim",
	Callback = function(v) _G.Aimbot = v end
})

CombatOnglet:CreateDropdown({
	Name = "Cible",
	Options = {"Murderer", "Sheriff", "Tous"},
	CurrentOption = {"Murderer"},
	MultipleOptions = false,
	Flag = "CibleAim",
	Callback = function(o) _G.CibleAimbot = o[1] end
})

CombatOnglet:CreateSlider({
	Name = "Lissage",
	Min = 1, Max = 10, Default = 2,
	Color = Color3.fromRGB(0, 150, 255),
	Increment = 1, ValueName = "/10",
	Flag = "Lisse",
	Callback = function(v) _G.LissageAimbot = v / 10 end
})

CombatOnglet:CreateSlider({
	Name = "FOV",
	Min = 30, Max = 500, Default = 150,
	Color = Color3.fromRGB(255, 0, 100),
	Increment = 10, ValueName = "pixels",
	Flag = "FOVAim",
	Callback = function(v) _G.FOVAimbot = v end
})

CombatOnglet:CreateSection("Assistance")

CombatOnglet:CreateToggle({
	Name = "Auto ramasser le pistolet",
	CurrentValue = false,
	Flag = "AP",
	Callback = function(v) _G.AutoPistolet = v end
})

-- Onglet Visuels
local VisuelsOnglet = Fenetre:CreateTab("Visuels & ESP", 4483362458)
VisuelsOnglet:CreateSection("ESP")

VisuelsOnglet:CreateToggle({
	Name = "ESP Joueurs & Rôles",
	CurrentValue = false,
	Flag = "ESP",
	Callback = function(v) _G.ESP = v end
})

VisuelsOnglet:CreateToggle({
	Name = "ESP Pièces & Gemmes",
	CurrentValue = false,
	Flag = "ESPieces",
	Callback = function(v) _G.ESPieces = v end
})

-- Onglet Mouvements
local MouveOnglet = Fenetre:CreateTab("Mouvements & Misc", 4483362458)
MouveOnglet:CreateSection("Modifications")

MouveOnglet:CreateSlider({
	Name = "Vitesse de marche",
	Min = 16, Max = 150, Default = 16,
	Color = Color3.fromRGB(255, 255, 255),
	Increment = 1, ValueName = "studs/s",
	Flag = "WS",
	Callback = function(v)
		ws = v
		local c = LP.Character
		if c and c:FindFirstChildOfClass("Humanoid") then
			c:FindFirstChildOfClass("Humanoid").WalkSpeed = v
		end
	end
})

MouveOnglet:CreateSlider({
	Name = "Hauteur de saut",
	Min = 50, Max = 250, Default = 50,
	Color = Color3.fromRGB(255, 255, 255),
	Increment = 5, ValueName = "studs",
	Flag = "JP",
	Callback = function(v)
		jp = v
		local c = LP.Character
		if c and c:FindFirstChildOfClass("Humanoid") then
			c:FindFirstChildOfClass("Humanoid").UseJumpPower = true
			c:FindFirstChildOfClass("Humanoid").JumpPower = v
		end
	end
})

MouveOnglet:CreateToggle({
	Name = "Noclip (traverser les murs)",
	CurrentValue = false,
	Flag = "NC",
	Callback = function(v) _G.Noclip = v end
})

MouveOnglet:CreateToggle({
	Name = "Saut infini",
	CurrentValue = false,
	Flag = "SI",
	Callback = function(v) _G.SautInfini = v end
})

-- ==================== BOUCLES ====================

-- Auto Farm
task.spawn(function()
	while true do
		task.wait(0.1)
		if _G.AutoFarm and not _G.AutoKill then
			local c = LP.Character
			if c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid") and c:FindFirstChildOfClass("Humanoid").Health > 0 then
				local pieces = getPieces()
				if #pieces > 0 then
					local plusProche = nil
					local distMin = math.huge
					local maPos = c.HumanoidRootPart.Position
					local m = getMurderer()
					local posM = m and m.Character and m.Character:FindFirstChild("HumanoidRootPart") and m.Character.HumanoidRootPart.Position

					for _, piece in ipairs(pieces) do
						local partie = piece:IsA("BasePart") and piece or piece:FindFirstChildWhichIsA("BasePart", true)
						if partie then
							local safe = true
							if _G.EviterMurderer and posM then
								if (partie.Position - posM).Magnitude < _G.DistanceEvitement then
									safe = false
								end
							end
							if safe then
								local d = (partie.Position - maPos).Magnitude
								if d < distMin then
									distMin = d
									plusProche = partie
								end
							end
						end
					end

					if plusProche then
						pcall(function()
							if _G.FarmMethode == "Teleport" then
								tp(plusProche.CFrame)
								task.wait(0.2)
							else
								local racine = c and c:FindFirstChild("HumanoidRootPart")
								if racine then
									local dist = (racine.Position - plusProche.Position).Magnitude
									local temps = dist / (_G.VitesseTween or 30)
									local tw = TweenService:Create(racine, TweenInfo.new(temps, Enum.EasingStyle.Linear), {CFrame = plusProche.CFrame})
									tw:Play()
									tw.Completed:Wait()
								end
							end
						end)
					end
				end
			end
		end
	end
end)

-- Auto Kill boucle
task.spawn(function()
	while true do
		task.wait(0.2)
		if _G.AutoKill then
			local ok, _ = pcall(function()
				local couteau = equiperCouteau()
				if not couteau then
					_G.AutoKill = false
					Rayfield:Notify({Title = "Auto Kill", Content = "T'as plus le couteau frérot", Duration = 3})
					return
				end

				for _, v in ipairs(Players:GetPlayers()) do
					if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
						local h = v.Character:FindFirstChildOfClass("Humanoid")
						if h and h.Health > 0 then
							local moi = LP.Character
							if moi and moi:FindFirstChild("HumanoidRootPart") then
								moi.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.2)
								task.wait(0.08)
								couteau:Activate()
								task.wait(0.08)
							end
						end
					end
					if not _G.AutoKill then break end
				end
			end)
		end
	end
end)

-- ESP
task.spawn(function()
	while task.wait(0.5) do
		-- ESP joueurs
		if _G.ESP then
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local hl = p.Character:FindFirstChild("LeM_ESP")
					if not hl then
						hl = Instance.new("Highlight")
						hl.Name = "LeM_ESP"
						hl.Parent = p.Character
						hl.FillOpacity = 0.4
						hl.OutlineOpacity = 1
					end
					local role = getRole(p)
					if role == "Murderer" then
						hl.FillColor = Color3.fromRGB(255, 0, 0)
						hl.OutlineColor = Color3.fromRGB(255, 0, 0)
					elseif role == "Sheriff" then
						hl.FillColor = Color3.fromRGB(0, 100, 255)
						hl.OutlineColor = Color3.fromRGB(0, 100, 255)
					else
						hl.FillColor = Color3.fromRGB(0, 255, 100)
						hl.OutlineColor = Color3.fromRGB(0, 255, 100)
					end
					hl.Enabled = true
				end
			end

			-- Pistolet au sol
			local arme = nil
			for _, e in ipairs(workspace:GetChildren()) do
				if e.Name == "GunDrop" or (e:IsA("Tool") and e.Name == "Gun") then
					arme = e break
				end
			end
			if arme then
				local hl = arme:FindFirstChild("LeM_GunESP")
				if not hl then
					hl = Instance.new("Highlight")
					hl.Name = "LeM_GunESP"
					hl.Parent = arme
					hl.FillColor = Color3.fromRGB(255, 215, 0)
					hl.OutlineColor = Color3.fromRGB(255, 215, 0)
					hl.FillOpacity = 0.5
					hl.OutlineOpacity = 1
				end
				hl.Enabled = true
			else
				for _, e in ipairs(workspace:GetDescendants()) do
					if e.Name == "LeM_GunESP" then e:Destroy() end
				end
			end
		else
			for _, p in ipairs(Players:GetPlayers()) do
				if p.Character then
					local e = p.Character:FindFirstChild("LeM_ESP")
					if e then e:Destroy() end
				end
			end
			for _, e in ipairs(workspace:GetDescendants()) do
				if e.Name == "LeM_GunESP" then e:Destroy() end
			end
		end

		-- ESP pièces
		if _G.ESPieces then
			for _, piece in ipairs(getPieces()) do
				local partie = piece:IsA("BasePart") and piece or piece:FindFirstChildWhichIsA("BasePart", true)
				if partie and not partie:FindFirstChild("LeM_CoinESP") then
					local bg = Instance.new("BillboardGui")
					bg.Name = "LeM_CoinESP"
					bg.AlwaysOnTop = true
					bg.Size = UDim2.new(0, 50, 0, 50)
					bg.Adornee = partie
					bg.Parent = partie
					local txt = Instance.new("TextLabel")
					txt.BackgroundTransparency = 1
					txt.Size = UDim2.new(1, 0, 1, 0)
					local nomParent = piece.Parent and piece.Parent.Name or ""
					txt.Text = (piece.Name:lower():find("gem") or nomParent:lower():find("gem")) and "💎" or "🪙"
					txt.TextColor3 = (piece.Name:lower():find("gem") or nomParent:lower():find("gem")) and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 215, 0)
					txt.TextSize = 14
					txt.Font = Enum.Font.SourceSansBold
					txt.Parent = bg
				end
			end
		else
			for _, e in ipairs(workspace:GetDescendants()) do
				if e.Name == "LeM_CoinESP" then e:Destroy() end
			end
		end
	end
end)

-- Auto ramasser pistolet
task.spawn(function()
	while task.wait(0.5) do
		if _G.AutoPistolet then
			local c = LP.Character
			if c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid") and c:FindFirstChildOfClass("Humanoid").Health > 0 then
				if not c:FindFirstChild("Gun") and not LP.Backpack:FindFirstChild("Gun") then
					local arme = nil
					for _, e in ipairs(workspace:GetChildren()) do
						if e.Name == "GunDrop" or (e:IsA("Tool") and e.Name == "Gun") then
							arme = e break
						end
					end
					if arme then
						local partie = arme:IsA("BasePart") and arme or arme:FindFirstChildWhichIsA("BasePart", true)
						if partie then
							pcall(function() tp(partie.CFrame) end)
						end
					end
				end
			end
		end
	end
end)

-- Aimbot
local okFOV, cercleFOV = pcall(function()
	local c = Drawing.new("Circle")
	c.Thickness = 1.5
	c.Color = Color3.fromRGB(255, 0, 100)
	c.Filled = false
	c.Visible = false
	return c
end)

local function cibleLaPlusProche()
	local plusProche = nil
	local distMin = math.huge
	local souris = UIS:GetMouseLocation()

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Head") then
			local cible = false
			local role = getRole(p)
			if _G.CibleAimbot == "Murderer" and role == "Murderer" then cible = true
			elseif _G.CibleAimbot == "Sheriff" and role == "Sheriff" then cible = true
			elseif _G.CibleAimbot == "Tous" then cible = true end

			if cible then
				local ecran, visible = Camera:WorldToViewportPoint(p.Character.Head.Position)
				if visible then
					local d = (Vector2.new(ecran.X, ecran.Y) - souris).Magnitude
					if d < distMin and d <= _G.FOVAimbot then
						distMin = d
						plusProche = p
					end
				end
			end
		end
	end
	return plusProche
end

RS.RenderStepped:Connect(function()
	if okFOV and cercleFOV then
		cercleFOV.Size = _G.FOVAimbot
		cercleFOV.Position = UIS:GetMouseLocation()
		cercleFOV.Visible = _G.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
	end

	if _G.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
		local cible = cibleLaPlusProche()
		if cible and cible.Character and cible.Character:FindFirstChild("Head") then
			local posCible = cible.Character.Head.Position
			local cfActuel = Camera.CFrame
			Camera.CFrame = cfActuel:Lerp(CFrame.new(cfActuel.Position, posCible), _G.LissageAimbot)
		end
	end
end)

-- Noclip
task.spawn(function()
	RS.Stepped:Connect(function()
		if _G.Noclip or (_G.AutoFarm and _G.FarmMethode == "Tween") then
			local c = LP.Character
			if c then
				for _, p in ipairs(c:GetDescendants()) do
					if p:IsA("BasePart") then p.CanCollide = false end
				end
			end
		end
	end)
end)

-- Saut infini
UIS.JumpRequest:Connect(function()
	if _G.SautInfini then
		local c = LP.Character
		if c and c:FindFirstChildOfClass("Humanoid") then
			c:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
		end
	end
end)

Rayfield:Notify({Title = "Le M MM2", Content = "Script chargé avec succès bg", Duration = 5})
