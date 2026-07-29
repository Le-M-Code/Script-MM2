local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
if not Rayfield then return error("Rayfield pas chargé — CDN peut-être down") end

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- ==================== CONFIG ====================
_G.AutoFarm = false
_G.Methode = "Teleport"
_G.VitesseTween = 30
_G.EviterMurder = true
_G.DistEvite = 40

_G.AutoKill = false

_G.Aimbot = false
_G.CibleAim = "Murderer"
_G.Lissage = 0.2
_G.FOV = 150

_G.ESP = false
_G.ESPieces = false
_G.AutoGun = false
_G.Noclip = false
_G.InfJump = false

local ws = 16
local jp = 50

-- ==================== UTILITAIRES ====================

local function role(joueur)
	if not joueur or not joueur.Character then return "Innocent" end
	if joueur.Backpack:FindFirstChild("Knife") or joueur.Character:FindFirstChild("Knife") then return "Murderer" end
	if joueur.Backpack:FindFirstChild("Gun") or joueur.Character:FindFirstChild("Gun") then return "Sheriff" end
	return "Innocent"
end

local function getMurder()
	for _, p in ipairs(Players:GetPlayers()) do
		if role(p) == "Murderer" then return p end
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
	local pcs = {}
	for _, e in ipairs(workspace:GetDescendants()) do
		local n = e.Name
		if n == "Coin_Container" or n == "CoinContainer" or n == "GoldCoin" or n == "Coin" or n == "Gem" then
			table.insert(pcs, e)
		end
	end
	return pcs
end

local function equipeCouteau()
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

-- ==================== KILL STABLE ====================
local function killAll()
	local ok, err = pcall(function()
		local couteau = equipeCouteau()
		if not couteau then
			Rayfield:Notify({Title = "Le M MM2", Content = "T'as pas le couteau bg", Duration = 3})
			return
		end
		for _, v in ipairs(Players:GetPlayers()) do
			if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
				local h = v.Character:FindFirstChildOfClass("Humanoid")
				if h and h.Health > 0 then
					local moi = LP.Character
					if moi and moi:FindFirstChild("HumanoidRootPart") and moi:FindFirstChildOfClass("Humanoid") and moi:FindFirstChildOfClass("Humanoid").Health > 0 then
						moi.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.5)
						task.wait(0.08)
						couteau:Activate()
						task.wait(0.08)
					else
						break
					end
				end
			end
		end
	end)
	if not ok then
		Rayfield:Notify({Title = "Le M MM2", Content = "Raté mais réessaye bg", Duration = 3})
	end
end

local function setupMvt(perso)
	local h = perso:WaitForChild("Humanoid", 5)
	if h then
		h.WalkSpeed = ws
		h.UseJumpPower = true
		h.JumpPower = jp
	end
end

LP.CharacterAdded:Connect(setupMvt)
if LP.Character then setupMvt(LP.Character) end

-- ==================== UI ====================
local Fenetre = Rayfield:CreateWindow({
	Name = "Le M MM2",
	LoadingTitle = "Le M MM2",
	LoadingSubtitle = "by LO",
	ConfigurationSaving = { Enabled = false, FolderName = "LeMM2", FileName = "config" },
	Discord = { Enabled = false },
	KeySystem = false
})

-- Onglet Farm
local Farm = Fenetre:CreateTab("Farm Pièces", 4483362458)
Farm:CreateSection("Auto Farm")

Farm:CreateToggle({ Name = "Activer l'Auto Farm", CurrentValue = false, Flag = "AF", Callback = function(v) _G.AutoFarm = v end })

Farm:CreateDropdown({ Name = "Méthode", Options = {"Teleport", "Tween"}, CurrentOption = {"Teleport"}, MultipleOptions = false, Flag = "Meth", Callback = function(o) _G.Methode = o[1] end })

Farm:CreateSlider({ Name = "Vitesse Tween", Range = {10, 100}, CurrentValue = 30, Increment = 1, Suffix = "studs/s", Flag = "VT", Callback = function(v) _G.VitesseTween = v end })

Farm:CreateToggle({ Name = "Éviter le Murderer", CurrentValue = true, Flag = "Ev", Callback = function(v) _G.EviterMurder = v end })

Farm:CreateSlider({ Name = "Distance d'évitement", Range = {10, 150}, CurrentValue = 40, Increment = 5, Suffix = "studs", Flag = "DE", Callback = function(v) _G.DistEvite = v end })

-- Onglet Tuer
local Tuer = Fenetre:CreateTab("Tuer", 4483362458)
Tuer:CreateSection("Meurtre")

Tuer:CreateButton({ Name = "Tuer tout le monde", Callback = killAll })

Tuer:CreateToggle({ Name = "Auto Kill en boucle", CurrentValue = false, Flag = "AK", Callback = function(v) _G.AutoKill = v end })

Tuer:CreateSection("Téléportations")

Tuer:CreateButton({ Name = "Aller au Murderer", Callback = function()
	local m = getMurder()
	if m and m.Character and m.Character:FindFirstChild("HumanoidRootPart") then
		tp(m.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2))
	else
		Rayfield:Notify({Title = "Le M MM2", Content = "Murderer pas trouvé", Duration = 3})
	end
end })

Tuer:CreateButton({ Name = "Aller au Sheriff", Callback = function()
	local s = nil
	for _, p in ipairs(Players:GetPlayers()) do
		if role(p) == "Sheriff" then s = p break end
	end
	if s and s.Character and s.Character:FindFirstChild("HumanoidRootPart") then
		tp(s.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2))
	else
		Rayfield:Notify({Title = "Le M MM2", Content = "Sheriff pas trouvé", Duration = 3})
	end
end })

-- Onglet Combat
local Combat = Fenetre:CreateTab("Combat & Aim", 4483362458)
Combat:CreateSection("Aimbot")

Combat:CreateToggle({ Name = "Activer l'Aimbot (Clic Droit)", CurrentValue = false, Flag = "Aim", Callback = function(v) _G.Aimbot = v end })

Combat:CreateDropdown({ Name = "Cible", Options = {"Murderer", "Sheriff", "Tous"}, CurrentOption = {"Murderer"}, MultipleOptions = false, Flag = "Cible", Callback = function(o) _G.CibleAim = o[1] end })

Combat:CreateSlider({ Name = "Lissage", Range = {1, 10}, CurrentValue = 2, Increment = 1, Suffix = "/10", Flag = "Liss", Callback = function(v) _G.Lissage = v / 10 end })

Combat:CreateSlider({ Name = "FOV", Range = {30, 500}, CurrentValue = 150, Increment = 10, Suffix = "px", Flag = "FOV", Callback = function(v) _G.FOV = v end })

Combat:CreateSection("Assistance")

Combat:CreateToggle({ Name = "Auto ramasser le gun", CurrentValue = false, Flag = "AG", Callback = function(v) _G.AutoGun = v end })

-- Onglet Visuels
local Visu = Fenetre:CreateTab("Visuels & ESP", 4483362458)
Visu:CreateSection("ESP")

Visu:CreateToggle({ Name = "ESP Joueurs & Rôles", CurrentValue = false, Flag = "ESP", Callback = function(v) _G.ESP = v end })

Visu:CreateToggle({ Name = "ESP Pièces & Gemmes", CurrentValue = false, Flag = "EP", Callback = function(v) _G.ESPieces = v end })

-- Onglet Mouvements
local Mouv = Fenetre:CreateTab("Mouvements", 4483362458)
Mouv:CreateSection("Modifications")

Mouv:CreateSlider({ Name = "Vitesse (WalkSpeed)", Range = {16, 150}, CurrentValue = 16, Increment = 1, Suffix = "studs/s", Flag = "WS", Callback = function(v)
	ws = v
	local c = LP.Character
	if c and c:FindFirstChildOfClass("Humanoid") then c:FindFirstChildOfClass("Humanoid").WalkSpeed = v end
end })

Mouv:CreateSlider({ Name = "Saut (JumpPower)", Range = {50, 250}, CurrentValue = 50, Increment = 5, Suffix = "studs", Flag = "JP", Callback = function(v)
	jp = v
	local c = LP.Character
	if c and c:FindFirstChildOfClass("Humanoid") then
		c:FindFirstChildOfClass("Humanoid").UseJumpPower = true
		c:FindFirstChildOfClass("Humanoid").JumpPower = v
	end
end })

Mouv:CreateToggle({ Name = "Noclip (murs)", CurrentValue = false, Flag = "NC", Callback = function(v) _G.Noclip = v end })

Mouv:CreateToggle({ Name = "Saut infini", CurrentValue = false, Flag = "SI", Callback = function(v) _G.InfJump = v end })

-- ==================== BOUCLES ====================

-- Farm
task.spawn(function()
	while true do
		task.wait(0.1)
		if _G.AutoFarm and not _G.AutoKill then
			local c = LP.Character
			if c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid") and c:FindFirstChildOfClass("Humanoid").Health > 0 then
				local pcs = getPieces()
				if #pcs > 0 then
					local meilleur = nil
					local dMin = math.huge
					local maPos = c.HumanoidRootPart.Position
					local m = getMurder()
					local posM = m and m.Character and m.Character:FindFirstChild("HumanoidRootPart") and m.Character.HumanoidRootPart.Position

					for _, p in ipairs(pcs) do
						local part = p:IsA("BasePart") and p or p:FindFirstChildWhichIsA("BasePart", true)
						if part then
							local safe = true
							if _G.EviterMurder and posM and (part.Position - posM).Magnitude < _G.DistEvite then safe = false end
							if safe then
								local d = (part.Position - maPos).Magnitude
								if d < dMin then dMin = d meilleur = part end
							end
						end
					end

					if meilleur then
						pcall(function()
							if _G.Methode == "Teleport" then
								tp(meilleur.CFrame)
								task.wait(0.2)
							else
								local r = c and c:FindFirstChild("HumanoidRootPart")
								if r then
									local d = (r.Position - meilleur.Position).Magnitude
									local t = d / (_G.VitesseTween or 30)
									local tw = TweenService:Create(r, TweenInfo.new(t, Enum.EasingStyle.Linear), {CFrame = meilleur.CFrame})
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

-- Auto Kill
task.spawn(function()
	while true do
		task.wait(0.2)
		if _G.AutoKill then
			pcall(function()
				local couteau = equipeCouteau()
				if not couteau then
					_G.AutoKill = false
					Rayfield:Notify({Title = "Le M MM2", Content = "Plus de couteau", Duration = 3})
					return
				end
				for _, v in ipairs(Players:GetPlayers()) do
					if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
						local h = v.Character:FindFirstChildOfClass("Humanoid")
						if h and h.Health > 0 then
							local moi = LP.Character
							if moi and moi:FindFirstChild("HumanoidRootPart") and moi:FindFirstChildOfClass("Humanoid") and moi:FindFirstChildOfClass("Humanoid").Health > 0 then
								moi.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.2)
								task.wait(0.08)
								couteau:Activate()
								task.wait(0.08)
							else break end
						end
					end
					if not _G.AutoKill then break end
				end
			end)
		end
	end
end)

-- ESP joueurs
task.spawn(function()
	while task.wait(0.5) do
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
					local r = role(p)
					hl.FillColor = r == "Murderer" and Color3.fromRGB(255, 0, 0) or r == "Sheriff" and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(0, 255, 100)
					hl.OutlineColor = hl.FillColor
					hl.Enabled = true
				end
			end
			local gun = nil
			for _, e in ipairs(workspace:GetChildren()) do
				if e.Name == "GunDrop" or (e:IsA("Tool") and e.Name == "Gun") then gun = e break end
			end
			if gun then
				local hl = gun:FindFirstChild("LeM_GunESP")
				if not hl then
					hl = Instance.new("Highlight")
					hl.Name = "LeM_GunESP"
					hl.Parent = gun
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
			for _, p in ipairs(getPieces()) do
				local part = p:IsA("BasePart") and p or p:FindFirstChildWhichIsA("BasePart", true)
				if part and not part:FindFirstChild("LeM_CoinESP") then
					local bg = Instance.new("BillboardGui")
					bg.Name = "LeM_CoinESP"
					bg.AlwaysOnTop = true
					bg.Size = UDim2.new(0, 50, 0, 50)
					bg.Adornee = part
					bg.Parent = part
					local t = Instance.new("TextLabel")
					t.BackgroundTransparency = 1
					t.Size = UDim2.new(1, 0, 1, 0)
					local nP = p.Parent and p.Parent.Name or ""
					local estGem = p.Name:lower():find("gem") or nP:lower():find("gem")
					t.Text = estGem and "💎" or "🪙"
					t.TextColor3 = estGem and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 215, 0)
					t.TextSize = 14
					t.Font = Enum.Font.SourceSansBold
					t.Parent = bg
				end
			end
		else
			for _, e in ipairs(workspace:GetDescendants()) do
				if e.Name == "LeM_CoinESP" then e:Destroy() end
			end
		end
	end
end)

-- Auto gun
task.spawn(function()
	while task.wait(0.5) do
		if _G.AutoGun then
			local c = LP.Character
			if c and c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildOfClass("Humanoid") and c:FindFirstChildOfClass("Humanoid").Health > 0 then
				if not c:FindFirstChild("Gun") and not LP.Backpack:FindFirstChild("Gun") then
					local g = nil
					for _, e in ipairs(workspace:GetChildren()) do
						if e.Name == "GunDrop" or (e:IsA("Tool") and e.Name == "Gun") then g = e break end
					end
					if g then
						local part = g:IsA("BasePart") and g or g:FindFirstChildWhichIsA("BasePart", true)
						if part then pcall(function() tp(part.CFrame) end) end
					end
				end
			end
		end
	end
end)

-- Aimbot
local okFOV, cercle = pcall(function()
	local c = Drawing.new("Circle")
	c.Thickness = 1.5
	c.Color = Color3.fromRGB(255, 0, 100)
	c.Filled = false
	c.Visible = false
	return c
end)

local function getCible()
	local best = nil
	local dMin = math.huge
	local souris = UIS:GetMouseLocation()

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Head") then
			local ok = false
			local r = role(p)
			if _G.CibleAim == "Murderer" and r == "Murderer" then ok = true
			elseif _G.CibleAim == "Sheriff" and r == "Sheriff" then ok = true
			elseif _G.CibleAim == "Tous" then ok = true end

			if ok then
				local ecran, visible = Camera:WorldToViewportPoint(p.Character.Head.Position)
				if visible then
					local d = (Vector2.new(ecran.X, ecran.Y) - souris).Magnitude
					if d < dMin and d <= _G.FOV then dMin = d best = p end
				end
			end
		end
	end
	return best
end

RS.RenderStepped:Connect(function()
	if okFOV and cercle then
		cercle.Size = _G.FOV
		cercle.Position = UIS:GetMouseLocation()
		cercle.Visible = _G.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
	end

	if _G.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
		local cible = getCible()
		if cible and cible.Character and cible.Character:FindFirstChild("Head") then
			local posC = cible.Character.Head.Position
			local cf = Camera.CFrame
			Camera.CFrame = cf:Lerp(CFrame.new(cf.Position, posC), _G.Lissage)
		end
	end
end)

-- Noclip
task.spawn(function()
	RS.Stepped:Connect(function()
		if _G.Noclip or (_G.AutoFarm and _G.Methode == "Tween") then
			local c = LP.Character
			if c then
				for _, p in ipairs(c:GetDescendants()) do
					if p:IsA("BasePart") then p.CanCollide = false end
				end
			end
		end
	end)
end)

-- Inf Jump
UIS.JumpRequest:Connect(function()
	if _G.InfJump then
		local c = LP.Character
		if c and c:FindFirstChildOfClass("Humanoid") then
			c:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
		end
	end
end)

Rayfield:Notify({Title = "Le M MM2", Content = "Prêt bg, tu peux tout casser", Duration = 5})
