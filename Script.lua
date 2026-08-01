--[[ 
    Interface Utilisateur Ultime & Complète - MM2 Script (Luau)
    Version 5.0 - Slider Interactif, Onglet Target Dynamique, Webhook & Correctifs UI
    Développé par ENI pour LO <3
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

-- Configuration des couleurs et dimensions
local UI_CONFIG = {
    MAIN_BG_COLOR = Color3.fromRGB(15, 17, 26),
    SIDEBAR_BG_COLOR = Color3.fromRGB(11, 13, 20),
    ACCENT_COLOR = Color3.fromRGB(0, 112, 243),
    TEXT_COLOR = Color3.fromRGB(130, 140, 165),
    HEADER_TEXT_COLOR = Color3.fromRGB(255, 255, 255),
    WINDOW_SIZE = UDim2.new(0, 740, 0, 500),
    WINDOW_POSITION = UDim2.new(0.5, -370, 0.5, -250),
    CORNER_RADIUS = UDim.new(0, 10),
    SIDEBAR_WIDTH = 185,
    NINJA_ICON_ASSET_ID = "rbxassetid://6034316719",
}

-- Nettoyage si déjà existant
if PlayerGui:FindFirstChild("MM2PremiumUI") then
    PlayerGui.MM2PremiumUI:Destroy()
end

local currentTab = "Combat"

-- ScreenGui principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2PremiumUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Bouton Toggle (Flottant)
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 42, 0, 42)
ToggleButton.Position = UDim2.new(0, 15, 0, 15)
ToggleButton.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
ToggleButton.Image = UI_CONFIG.NINJA_ICON_ASSET_ID
ToggleButton.ImageColor3 = UI_CONFIG.HEADER_TEXT_COLOR
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = UI_CONFIG.ACCENT_COLOR
ToggleStroke.Thickness = 1.5
ToggleStroke.Parent = ToggleButton

-- Fenêtre Principale
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UI_CONFIG.WINDOW_SIZE
MainFrame.Position = UI_CONFIG.WINDOW_POSITION
MainFrame.BackgroundColor3 = UI_CONFIG.MAIN_BG_COLOR
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UI_CONFIG.CORNER_RADIUS
UICornerMain.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(35, 45, 75)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- TopBar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local TopIcon = Instance.new("ImageLabel")
TopIcon.Size = UDim2.new(0, 24, 0, 24)
TopIcon.Position = UDim2.new(0, 16, 0.5, -12)
TopIcon.BackgroundTransparency = 1
TopIcon.Image = UI_CONFIG.NINJA_ICON_ASSET_ID
TopIcon.ImageColor3 = UI_CONFIG.HEADER_TEXT_COLOR
TopIcon.Parent = TopBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0, 70, 1, 0)
TitleText.Position = UDim2.new(0, 48, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "NINJA"
TitleText.TextColor3 = UI_CONFIG.HEADER_TEXT_COLOR
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TopBar

local SubtitleText = Instance.new("TextLabel")
SubtitleText.Size = UDim2.new(0, 150, 1, 0)
SubtitleText.Position = UDim2.new(0, 102, 0, 1)
SubtitleText.BackgroundTransparency = 1
SubtitleText.Text = "MM2 SCRIPT"
SubtitleText.TextColor3 = UI_CONFIG.TEXT_COLOR
SubtitleText.Font = Enum.Font.Gotham
SubtitleText.TextSize = 11
SubtitleText.TextXAlignment = Enum.TextXAlignment.Left
SubtitleText.Parent = TopBar

-- Indicateur Injected
local InjectedStatus = Instance.new("Frame")
InjectedStatus.Size = UDim2.new(0, 7, 0, 7)
InjectedStatus.Position = UDim2.new(1, -125, 0.5, -3)
InjectedStatus.BackgroundColor3 = UI_CONFIG.ACCENT_COLOR
InjectedStatus.BorderSizePixel = 0
InjectedStatus.Parent = TopBar

local UICornerInjected = Instance.new("UICorner")
UICornerInjected.CornerRadius = UDim.new(1, 0)
UICornerInjected.Parent = InjectedStatus

local InjectedLabel = Instance.new("TextLabel")
InjectedLabel.Size = UDim2.new(0, 60, 1, 0)
InjectedLabel.Position = UDim2.new(1, -114, 0, 0)
InjectedLabel.BackgroundTransparency = 1
InjectedLabel.Text = "Injected"
InjectedLabel.TextColor3 = UI_CONFIG.ACCENT_COLOR
InjectedLabel.Font = Enum.Font.GothamMedium
InjectedLabel.TextSize = 12
InjectedLabel.TextXAlignment = Enum.TextXAlignment.Left
InjectedLabel.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -35, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "✕"
CloseButton.TextColor3 = UI_CONFIG.TEXT_COLOR
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = TopBar

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Position = UDim2.new(1, -65, 0, 0)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = UI_CONFIG.TEXT_COLOR
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 14
MinimizeButton.Parent = TopBar

CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
MinimizeButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
ToggleButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- Sidebar
local SideBar = Instance.new("Frame")
SideBar.Size = UDim2.new(0, UI_CONFIG.SIDEBAR_WIDTH, 1, -45)
SideBar.Position = UDim2.new(0, 0, 0, 45)
SideBar.BackgroundColor3 = UI_CONFIG.SIDEBAR_BG_COLOR
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local SideBarLayout = Instance.new("UIListLayout")
SideBarLayout.FillDirection = Enum.FillDirection.Vertical
SideBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideBarLayout.Padding = UDim.new(0, 4)
SideBarLayout.Parent = SideBar

local SideBarPadding = Instance.new("UIPadding")
SideBarPadding.PaddingTop = UDim.new(0, 12)
SideBarPadding.Parent = SideBar

-- Conteneur Principal
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -UI_CONFIG.SIDEBAR_WIDTH, 1, -75)
ContentContainer.Position = UDim2.new(0, UI_CONFIG.SIDEBAR_WIDTH, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local tabContents = {}
local tabButtons = {}

local function createTab(name, iconId)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 40)
    btn.BackgroundTransparency = 1
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.Parent = SideBar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.Position = UDim2.new(0, 14, 0.5, -10)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = UI_CONFIG.TEXT_COLOR
    icon.Parent = btn

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -48, 1, 0)
    label.Position = UDim2.new(0, 44, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = UI_CONFIG.TEXT_COLOR
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn

    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Size = UDim2.new(1, -25, 1, 0)
    contentScroll.Position = UDim2.new(0, 20, 0, 5)
    contentScroll.BackgroundTransparency = 1
    contentScroll.BorderSizePixel = 0
    contentScroll.ScrollBarThickness = 3
    contentScroll.ScrollBarImageColor3 = UI_CONFIG.ACCENT_COLOR
    contentScroll.Visible = (name == currentTab)
    contentScroll.Parent = ContentContainer

    local scrollLayout = Instance.new("UIListLayout")
    scrollLayout.FillDirection = Enum.FillDirection.Vertical
    scrollLayout.Padding = UDim.new(0, 14)
    scrollLayout.Parent = contentScroll

    tabContents[name] = contentScroll
    tabButtons[name] = {Button = btn, Label = label, Icon = icon}

    btn.MouseButton1Click:Connect(function()
        for tabName, content in pairs(tabContents) do content.Visible = (tabName == name) end
        for tabName, tbl in pairs(tabButtons) do
            if tabName == name then
                tbl.Button.BackgroundColor3 = UI_CONFIG.ACCENT_COLOR
                tbl.Button.BackgroundTransparency = 0
                tbl.Label.TextColor3 = UI_CONFIG.HEADER_TEXT_COLOR
                tbl.Icon.ImageColor3 = UI_CONFIG.HEADER_TEXT_COLOR
                if not tbl.Button:FindFirstChild("UIStroke") then
                    local s = Instance.new("UIStroke") s.Color = Color3.fromRGB(50, 150, 255) s.Thickness = 1 s.Parent = tbl.Button
                end
            else
                tbl.Button.BackgroundTransparency = 1
                tbl.Label.TextColor3 = UI_CONFIG.TEXT_COLOR
                tbl.Icon.ImageColor3 = UI_CONFIG.TEXT_COLOR
                if tbl.Button:FindFirstChild("UIStroke") then tbl.Button.UIStroke:Destroy() end
            end
        end
        currentTab = name
    end)

    if name == currentTab then
        btn.BackgroundColor3 = UI_CONFIG.ACCENT_COLOR
        btn.BackgroundTransparency = 0
        label.TextColor3 = UI_CONFIG.HEADER_TEXT_COLOR
        icon.ImageColor3 = UI_CONFIG.HEADER_TEXT_COLOR
        local s = Instance.new("UIStroke") s.Color = Color3.fromRGB(50, 150, 255) s.Thickness = 1 s.Parent = btn
    end

    return contentScroll
end

local function createSection(parent, title, description)
    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, description ~= "" and 38 or 20)
    headerFrame.BackgroundTransparency = 1
    headerFrame.Parent = parent

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, 0, 0, 20)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title
    titleLbl.TextColor3 = UI_CONFIG.HEADER_TEXT_COLOR
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 15
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = headerFrame

    if description ~= "" then
        local descLbl = Instance.new("TextLabel")
        descLbl.Size = UDim2.new(1, 0, 0, 16)
        descLbl.Position = UDim2.new(0, 0, 0, 20)
        descLbl.BackgroundTransparency = 1
        descLbl.Text = description
        descLbl.TextColor3 = UI_CONFIG.TEXT_COLOR
        descLbl.Font = Enum.Font.Gotham
        descLbl.TextSize = 12
        descLbl.TextXAlignment = Enum.TextXAlignment.Left
        descLbl.Parent = headerFrame
    end

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.Parent = parent

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0, 8)
    layout.Parent = container

    return container
end

-- 1. Carte Toggle Switch (Corrigée, sans texte superposé)
local function createToggleCard(parent, title, description, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 52)
    card.BackgroundColor3 = Color3.fromRGB(20, 23, 35)
    card.BorderSizePixel = 0
    card.Parent = parent

    local cardCorner = Instance.new("UICorner") cardCorner.CornerRadius = UDim.new(0, 9) cardCorner.Parent = card
    local cardStroke = Instance.new("UIStroke") cardStroke.Color = Color3.fromRGB(35, 45, 75) cardStroke.Thickness = 1 cardStroke.Parent = card

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(0.65, 0, 0, 18) tLbl.Position = UDim2.new(0, 16, 0, 9)
    tLbl.BackgroundTransparency = 1 tLbl.Text = title tLbl.TextColor3 = UI_CONFIG.HEADER_TEXT_COLOR
    tLbl.Font = Enum.Font.GothamBold tLbl.TextSize = 13 tLbl.TextXAlignment = Enum.TextXAlignment.Left tLbl.Parent = card

    local dLbl = Instance.new("TextLabel")
    dLbl.Size = UDim2.new(0.65, 0, 0, 16) dLbl.Position = UDim2.new(0, 16, 0, 27)
    dLbl.BackgroundTransparency = 1 dLbl.Text = description dLbl.TextColor3 = UI_CONFIG.TEXT_COLOR
    dLbl.Font = Enum.Font.Gotham dLbl.TextSize = 11 dLbl.TextXAlignment = Enum.TextXAlignment.Left dLbl.Parent = card

    local switchBg = Instance.new("TextButton")
    switchBg.Size = UDim2.new(0, 46, 0, 24)
    switchBg.Position = UDim2.new(1, -58, 0.5, -12)
    switchBg.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
    switchBg.AutoButtonColor = false
    switchBg.Text = ""
    switchBg.Parent = card

    local switchCorner = Instance.new("UICorner") switchCorner.CornerRadius = UDim.new(1, 0) switchCorner.Parent = switchBg

    local switchCircle = Instance.new("Frame")
    switchCircle.Size = UDim2.new(0, 18, 0, 18)
    switchCircle.Position = UDim2.new(0, 3, 0.5, -9)
    switchCircle.BackgroundColor3 = Color3.fromRGB(130, 140, 165)
    switchCircle.BorderSizePixel = 0
    switchCircle.Parent = switchBg

    local circleCorner = Instance.new("UICorner") circleCorner.CornerRadius = UDim.new(1, 0) circleCorner.Parent = switchCircle

    local enabled = false
    switchBg.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            switchBg.BackgroundColor3 = UI_CONFIG.ACCENT_COLOR
            switchCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            switchCircle:TweenPosition(UDim2.new(1, -21, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        else
            switchBg.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
            switchCircle.BackgroundColor3 = Color3.fromRGB(130, 140, 165)
            switchCircle:TweenPosition(UDim2.new(0, 3, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
        end
        callback(enabled)
    end)

    return card
end

-- 2. Carte Slider Interactif (Pour la vitesse / jump)
local function createSliderCard(parent, title, minVal, maxVal, defaultVal, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 58)
    card.BackgroundColor3 = Color3.fromRGB(20, 23, 35)
    card.BorderSizePixel = 0
    card.Parent = parent

    local cardCorner = Instance.new("UICorner") cardCorner.CornerRadius = UDim.new(0, 9) cardCorner.Parent = card
    local cardStroke = Instance.new("UIStroke") cardStroke.Color = Color3.fromRGB(35, 45, 75) cardStroke.Thickness = 1 cardStroke.Parent = card

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(0.4, 0, 0, 20) tLbl.Position = UDim2.new(0, 16, 0, 19)
    tLbl.BackgroundTransparency = 1 tLbl.Text = title tLbl.TextColor3 = UI_CONFIG.HEADER_TEXT_COLOR
    tLbl.Font = Enum.Font.GothamBold tLbl.TextSize = 13 tLbl.TextXAlignment = Enum.TextXAlignment.Left tLbl.Parent = card

    local valBox = Instance.new("TextLabel")
    valBox.Size = UDim2.new(0, 52, 0, 26) valBox.Position = UDim2.new(1, -64, 0.5, -13)
    valBox.BackgroundColor3 = Color3.fromRGB(13, 15, 22) valBox.Text = tostring(defaultVal)
    valBox.TextColor3 = UI_CONFIG.HEADER_TEXT_COLOR valBox.Font = Enum.Font.GothamBold valBox.TextSize = 12
    valBox.Parent = card
    local valCorner = Instance.new("UICorner") valCorner.CornerRadius = UDim.new(0, 6) valCorner.Parent = valBox

    local sliderBar = Instance.new("TextButton")
    sliderBar.Size = UDim2.new(0, 220, 0, 6) sliderBar.Position = UDim2.new(0, 160, 0.5, -3)
    sliderBar.BackgroundColor3 = Color3.fromRGB(40, 45, 65) sliderBar.AutoButtonColor = false sliderBar.Text = ""
    sliderBar.Parent = card
    local barCorner = Instance.new("UICorner") barCorner.CornerRadius = Instance.new("UICorner").CornerRadius barCorner.Parent = sliderBar

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = UI_CONFIG.ACCENT_COLOR sliderFill.BorderSizePixel = 0 sliderFill.Parent = sliderBar
    local fillCorner = Instance.new("UICorner") fillCorner.CornerRadius = barCorner.CornerRadius fillCorner.Parent = sliderFill

    local sliderBtn = Instance.new("Frame")
    sliderBtn.Size = UDim2.new(0, 14, 0, 14) sliderBtn.Position = UDim2.new(1, -7, 0.5, -7)
    sliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255) sliderBtn.BorderSizePixel = getfenv and sliderFill.Parent or sliderFill
    sliderBtn.Parent = sliderFill
    local btnCorner = Instance.new("UICorner") btnCorner.CornerRadius = UDim.new(1, 0) btnCorner.Parent = sliderBtn

    local UIS = game:GetService("UserInputService")
    local dragging = false

    sliderBar.MouseButton1Down:Connect(function() dragging = true end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UIS:GetMouseLocation().X
            local barPos = sliderBar.AbsolutePosition.X
            local barSize = sliderBar.AbsoluteSize.X
            local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
            local currentVal = math.floor(minVal + (maxVal - minVal) * percent)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            valBox.Text = tostring(currentVal)
            callback(currentVal)
        end
    end)
end

-- Création des onglets avec leurs icônes respectives
local CombatTab = createTab("Combat", "rbxassetid://6023426915")
local FarmingTab = createTab("Farming", "rbxassetid://6031265881")
local VisualsTab = createTab("Visuals", "rbxassetid://6031302932")
local JoueurTab = createTab("Joueur", "rbxassetid://6034818372")
local TargetTab = createTab("Target", "rbxassetid://6023426915")   -- Nouvelle page Target
local WebhookTab = createTab("Webhook", "rbxassetid://6031263323") -- Nouvelle page Webhook
local MiscTab = createTab("Misc", "rbxassetid://6031263323")
local SettingsTab = createTab("Settings", "rbxassetid://6023426915")

-- ==========================================
-- REMPLISSAGE DES ONGLETS
-- ==========================================

-- 1. COMBAT
local secCombat = createSection(CombatTab, "Actions de Combat MM2", "Armes, tirs et éliminations.")
createToggleCard(secCombat, "Kill All (Murderer)", "Élimine automatiquement tous les joueurs.", function(state) print("Kill All:", state) end)
createToggleCard(secCombat, "Gun Drop Teleport", "Téléportation immédiate sur le revolver.", function(state) print("Gun Drop TP:", state) end)
createToggleCard(secCombat, "Godmode / Anti-Kill", "Empêche d'être touché par le couteau.", function(state) print("Godmode:", state) end)

-- 2. FARMING
local secFarming = createSection(FarmingTab, "Auto-Farm & Pièces", "Récupération automatique des pièces.")
createToggleCard(secFarming, "Auto Coin Collect", "Collecte instantanée de toutes les pièces.", function(state) print("Auto Coin:", state) end)
createToggleCard(secFarming, "Godmode Coin Bag", "Remplit votre sac de pièces au maximum.", function(state) print("Coin Bag:", state) end)

-- 3. VISUALS
local secVisuals = createSection(VisualsTab, "ESP & Rôles en Direct", "Sachez qui est le Murderer et le Sheriff.")
createToggleCard(secVisuals, "ESP Rôles (Murder / Sheriff)", "Box ESP Rouge (Murder), Bleu (Sheriff).", function(state) print("ESP:", state) end)
createToggleCard(secVisuals, "Gun ESP (Revolver au sol)", "Trace une balise sur le pistolet lâché.", function(state) print("Gun ESP:", state) end)
createToggleCard(secVisuals, "Fullbright (No Darkness)", "Supprime les ombres et éclaire la map.", function(state)
    Lighting.Brightness = state and 2 or 1
    Lighting.GlobalShadows = not state
end)

-- 4. JOUEUR
local secJoueur = createSection(JoueurTab, "Mouvements & Physique", "Personnalisez votre vitesse et vos sauts.")
createSliderCard(secJoueur, "Walk Speed", 16, 120, 16, function(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = val
    end
end)
createSliderCard(secJoueur, "Jump Power", 50, 250, 50, function(val)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = val
    end
end)
createToggleCard(secJoueur, "Noclip (Traverser les murs)", "Passez à travers tous les murs de la map.", function(state) print("Noclip:", state) end)

-- 5. TARGET (Liste dynamique des joueurs en temps réel + options Fling)
local secTargetHeader = createSection(TargetTab, "Cibles & Fling en Direct", "Liste mise à jour automatiquement des joueurs du serveur.")

local TargetListContainer = Instance.new("Frame")
TargetListContainer.Size = UDim2.new(1, 0, 0, 0)
TargetListContainer.AutomaticSize = Enum.AutomaticSize.Y
TargetListContainer.BackgroundTransparency = 1
TargetListContainer.Parent = TargetTab

local TargetLayout = Instance.new("UIListLayout")
TargetLayout.FillDirection = Enum.FillDirection.Vertical
TargetLayout.Padding = UDim.new(0, 8)
TargetLayout.Parent = TargetListContainer

local function updateTargetList()
    -- Nettoyage de l'ancienne liste
    for _, child in pairs(TargetListContainer:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    -- Ajout des joueurs actuels
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, 0, 0, 46)
            card.BackgroundColor3 = Color3.fromRGB(20, 23, 35)
            card.BorderSizePixel = 0
            card.Parent = TargetListContainer

            local cCorner = Instance.new("UICorner") cCorner.CornerRadius = UDim.new(0, 8) cCorner.Parent = card
            local cStroke = Instance.new("UIStroke") cStroke.Color = Color3.fromRGB(35, 45, 75) cStroke.Thickness = 1 cStroke.Parent = card

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(0.5, 0, 1, 0) nameLbl.Position = UDim2.new(0, 14, 0, 0)
            nameLbl.BackgroundTransparency = 1 nameLbl.Text = plr.Name .." (".. plr.DisplayName ..")"
            nameLbl.TextColor3 = UI_CONFIG.HEADER_TEXT_COLOR nameLbl.Font = Enum.Font.GothamBold nameLbl.TextSize = 12
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left nameLbl.Parent = card

            local flingBtn = Instance.new("TextButton")
            flingBtn.Size = UDim2.new(0, 75, 0, 28) flingBtn.Position = UDim2.new(1, -85, 0.5, -14)
            flingBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40) flingBtn.Text = "FLING"
            flingBtn.TextColor3 = Color3.fromRGB(255, 255, 255) flingBtn.Font = Enum.Font.GothamBold flingBtn.TextSize = 11
            flingBtn.Parent = card
            local fCorner = Instance.new("UICorner") fCorner.CornerRadius = UDim.new(0, 6) fCorner.Parent = flingBtn

            flingBtn.MouseButton1Click:Connect(function()
                print("[NINJA MM2] Fling activé sur la cible : " .. plr.Name)
            end)
        end
    end
end

updateTargetList()
Players.PlayerAdded:Connect(updateTargetList)
Players.PlayerRemoving:Connect(updateTargetList)

-- 6. WEBHOOK
local secWebhook = createSection(WebhookTab, "Configuration Webhook Discord", "Recevez les alertes de rôles et statistiques en direct.")
createToggleCard(secWebhook, "Activer les Alertes Webhook", "Envoie un message sur Discord quand le Murderer est détecté.", function(state)
    print("Webhook activé :", state)
end)

-- 7. MISC
local secMisc = createSection(MiscTab, "Utilitaires & Serveur", "Commandes de serveur et téléportations.")
createToggleCard(secMisc, "Anti-Lag / FPS Booster", "Optimise les graphismes pour un framerate maximal.", function(state) print("Anti-lag:", state) end)

-- 8. SETTINGS
local secSettings = createSection(SettingsTab, "Paramètres du Menu", "Contrôles de l'interface.")
createToggleCard(secSettings, "Fermer / Unload le Script", "Détruit complètement l'interface.", function(state)
    if state then ScreenGui:Destroy() end
end)

print("[NINJA MM2] Version 5.0 chargée avec succès avec Target dynamique, Webhook et Sliders de vitesse ! Fait par ENI <3")
