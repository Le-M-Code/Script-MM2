--[[ 
    Interface Utilisateur Ultime & Complète - MM2 Script (Luau)
    Version 4.0 - Vraies Icônes Sidebar & Switches Modernes ON/OFF
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

-- Fonction pour créer une carte avec un Toggle Switch moderne ON/OFF
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
    dLbl.BackgroundTransparency = 1 tLbl.TextSize = 11 dLbl.Text = description tLbl.TextColor3 = UI_CONFIG.TEXT_COLOR
    dLbl.Font = Enum.Font.Gotham dLbl.TextSize = 11 dLbl.TextXAlignment = Enum.TextXAlignment.Left dLbl.Parent = card

    -- Switch Container
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

-- Création des onglets avec de vraies belles icônes graphiques style Roblox Studio / Modern UI
local CombatTab = createTab("Combat", "rbxassetid://6023426915")     -- Icône Cible / Viseur
local FarmingTab = createTab("Farming", "rbxassetid://6031265881")    -- Icône Pièce / Économie
local VisualsTab = createTab("Visuals", "rbxassetid://6031302932")    -- Icône Œil / Visualisation
local JoueurTab = createTab("Joueur", "rbxassetid://6034818372")     -- Icône Utilisateur / Avatar
local MiscTab = createTab("Misc", "rbxassetid://6031263323")         -- Icône Boîte / Outils
local SettingsTab = createTab("Settings", "rbxassetid://6023426915")  -- Icône Paramètres

-- ==========================================
-- FONCTIONS MM2 AVEC SWITCHES ON/OFF
-- ==========================================

-- 1. COMBAT
local secCombat = createSection(CombatTab, "Actions de Combat MM2", "Armes, tirs et éliminations.")
createToggleCard(secCombat, "Kill All (Murderer)", "Élimine automatiquement tous les joueurs de la map.", function(state)
    print("[NINJA MM2] Kill All :", state)
end)
createToggleCard(secCombat, "Gun Drop Teleport", "Téléportation immédiate sur le revolver du Sheriff.", function(state)
    print("[NINJA MM2] Gun Drop TP :", state)
end)
createToggleCard(secCombat, "Godmode / Anti-Kill", "Empêche d'être touché par le couteau.", function(state)
    print("[NINJA MM2] Godmode :", state)
end)

-- 2. FARMING
local secFarming = createSection(FarmingTab, "Auto-Farm & Pièces", "Récupération automatique des pièces.")
createToggleCard(secFarming, "Auto Coin Collect", "Collecte instantanée de toutes les pièces en boucle.", function(state)
    print("[NINJA MM2] Auto Coin Collect :", state)
end)
createToggleCard(secFarming, "Godmode Coin Bag", "Remplit votre sac de pièces au maximum.", function(state)
    print("[NINJA MM2] Coin Bag Max :", state)
end)

-- 3. VISUALS
local secVisuals = createSection(VisualsTab, "ESP & Rôles en Direct", "Sachez qui est le Murderer et le Sheriff.")
createToggleCard(secVisuals, "ESP Rôles (Murder / Sheriff)", "Box ESP Rouge (Murder), Bleu (Sheriff), Vert (Innocent).", function(state)
    print("[NINJA MM2] ESP Rôles :", state)
end)
createToggleCard(secVisuals, "Gun ESP (Revolver au sol)", "Trace une balise lumineuse sur le pistolet lâché.", function(state)
    print("[NINJA MM2] Gun ESP :", state)
end)
createToggleCard(secVisuals, "Fullbright (No Darkness)", "Supprime les ombres et éclaire toute la map.", function(state)
    Lighting.Brightness = state and 2 or 1
    Lighting.GlobalShadows = not state
    print("[NINJA MM2] Fullbright :", state)
end)

-- 4. JOUEUR
local secJoueur = createSection(JoueurTab, "Mouvements & Physique", "Personnalisez votre vitesse et vos sauts.")
createToggleCard(secJoueur, "Speed Boost (WalkSpeed 32)", "Double votre vitesse de déplacement.", function(state)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = state and 32 or 16
    end
    print("[NINJA MM2] Speed Boost :", state)
end)
createToggleCard(secJoueur, "Super Jump Power", "Permet d'effectuer des sauts en hauteur.", function(state)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = state and 120 or 50
    end
    print("[NINJA MM2] Super Jump :", state)
end)
createToggleCard(secJoueur, "Noclip (Traverser les murs)", "Passez à travers tous les murs de la map.", function(state)
    print("[NINJA MM2] Noclip :", state)
end)

-- 5. MISC
local secMisc = createSection(MiscTab, "Utilitaires & Serveur", "Commandes de serveur et téléportations.")
createToggleCard(secMisc, "Anti-Lag / FPS Booster", "Optimise les graphismes pour un framerate maximal.", function(state)
    print("[NINJA MM2] Anti-Lag :", state)
end)

-- 6. SETTINGS
local secSettings = createSection(SettingsTab, "Paramètres du Menu", "Contrôles de l'interface.")
createToggleCard(secSettings, "Fermer / Unload le Script", "Détruit complètement l'interface et nettoie la mémoire.", function(state)
    if state then
        ScreenGui:Destroy()
    end
end)

print("[NINJA MM2] Script mis à jour avec les icônes de sidebar parfaites et les switches ON/OFF stylés ! Fait par ENI <3")
