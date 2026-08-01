--[[ 
    Interface Utilisateur Premium Autonome pour Cheat MM2 Roblox (Luau) 
    Design Haute Fidélité - Inspiré de l'image fournie 
    Développé par Manus AI 

    Ce script implémente une interface utilisateur de style ImGui entièrement personnalisée en Luau, 
    sans dépendances externes, en reproduisant fidèlement le design premium. 
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Configuration des couleurs et dimensions de l'UI
local UI_CONFIG = {
    MAIN_BG_COLOR = Color3.fromRGB(25, 25, 35), -- Fond principal très sombre
    ACCENT_COLOR = Color3.fromRGB(0, 120, 255), -- Bleu néon pour les accents
    TEXT_COLOR = Color3.fromRGB(220, 220, 220), -- Texte gris clair
    HEADER_TEXT_COLOR = Color3.fromRGB(255, 255, 255), -- Texte blanc pour les titres
    INJECTED_COLOR = Color3.fromRGB(0, 200, 0), -- Vert pour 'Injected'
    WINDOW_SIZE = UDim2.new(0, 700, 0, 500), -- Taille de la fenêtre principale
    WINDOW_POSITION = UDim2.new(0.5, -350, 0.5, -250), -- Centré
    CORNER_RADIUS = UDim.new(0, 10), -- Rayon des coins arrondis
    SIDEBAR_WIDTH = UDim2.new(0, 180, 1, 0), -- Largeur de la sidebar
    TOGGLE_BUTTON_SIZE = UDim2.new(0, 40, 0, 40),
    NINJA_ICON_ASSET_ID = "rbxassetid://1234567890", -- REMPLACEZ CECI PAR L'ID DE VOTRE ICÔNE NINJA
    NINJA_ICON_COLOR = Color3.fromRGB(255, 255, 255) -- Couleur de l'icône ninja
}

-- Variables d'état de l'UI
local isUIHidden = false
local currentTab = "Combat" -- Onglet par défaut

-- Crée le ScreenGui principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2PremiumUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Crée le bouton toggle (icône ninja) - en haut à gauche de l'écran
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UI_CONFIG.TOGGLE_BUTTON_SIZE
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Image = UI_CONFIG.NINJA_ICON_ASSET_ID
ToggleButton.ImageColor3 = UI_CONFIG.NINJA_ICON_COLOR
ToggleButton.ZIndex = 10
ToggleButton.Parent = ScreenGui

local function toggleUIVisibility()
    isUIHidden = not isUIHidden
    ScreenGui.MainFrame.Visible = not isUIHidden
end

ToggleButton.MouseButton1Click:Connect(toggleUIVisibility)

-- Crée le cadre principal de l'UI (la fenêtre)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UI_CONFIG.WINDOW_SIZE
MainFrame.Position = UI_CONFIG.WINDOW_POSITION
MainFrame.BackgroundColor3 = UI_CONFIG.MAIN_BG_COLOR
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true -- Permet de glisser la fenêtre
MainFrame.Visible = true -- Visible par défaut
MainFrame.Parent = ScreenGui

-- Ajout des coins arrondis au MainFrame
local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UI_CONFIG.CORNER_RADIUS
UICornerMain.Parent = MainFrame

-- Crée la barre de titre supérieure
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = UI_CONFIG.MAIN_BG_COLOR
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(0, 200, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "NINJA"
TitleText.TextColor3 = UI_CONFIG.HEADER_TEXT_COLOR
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 20
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TopBar

local SubtitleText = Instance.new("TextLabel")
SubtitleText.Name = "SubtitleText"
SubtitleText.Size = UDim2.new(0, 200, 1, 0)
SubtitleText.Position = UDim2.new(0, 70, 0, 0)
SubtitleText.BackgroundTransparency = 1
SubtitleText.Text = "MM2 SCRIPT"
SubtitleText.TextColor3 = UI_CONFIG.TEXT_COLOR
SubtitleText.Font = Enum.Font.Gotham
SubtitleText.TextSize = 12
SubtitleText.TextXAlignment = Enum.TextXAlignment.Left
SubtitleText.Parent = TopBar

local InjectedStatus = Instance.new("Frame")
InjectedStatus.Name = "InjectedStatus"
InjectedStatus.Size = UDim2.new(0, 10, 0, 10)
InjectedStatus.Position = UDim2.new(1, -100, 0.5, -5)
InjectedStatus.BackgroundColor3 = UI_CONFIG.INJECTED_COLOR
InjectedStatus.BorderSizePixel = 0
InjectedStatus.Parent = TopBar

local UICornerInjected = Instance.new("UICorner")
UICornerInjected.CornerRadius = UDim.new(0.5, 0) -- Cercle
UICornerInjected.Parent = InjectedStatus

local InjectedLabel = Instance.new("TextLabel")
InjectedLabel.Name = "InjectedLabel"
InjectedLabel.Size = UDim2.new(0, 60, 1, 0)
InjectedLabel.Position = UDim2.new(1, -90, 0, 0)
InjectedLabel.BackgroundTransparency = 1
InjectedLabel.Text = "Injected"
InjectedLabel.TextColor3 = UI_CONFIG.INJECTED_COLOR
InjectedLabel.Font = Enum.Font.Gotham
InjectedLabel.TextSize = 14
InjectedLabel.TextXAlignment = Enum.TextXAlignment.Left
InjectedLabel.Parent = TopBar

-- Boutons de contrôle de fenêtre (minimiser, fermer)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = UI_CONFIG.MAIN_BG_COLOR
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "X"
CloseButton.TextColor3 = UI_CONFIG.TEXT_COLOR
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.Parent = TopBar
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    isUIHidden = true
end)

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.BackgroundColor3 = UI_CONFIG.MAIN_BG_COLOR
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = UI_CONFIG.TEXT_COLOR
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 18
MinimizeButton.Parent = TopBar
MinimizeButton.MouseButton1Click:Connect(function()
    -- Implémenter la minimisation si nécessaire, pour l'instant juste cacher
    MainFrame.Visible = false
    isUIHidden = true
end)

-- Crée la sidebar de navigation
local SideBar = Instance.new("Frame")
SideBar.Name = "SideBar"
SideBar.Size = UI_CONFIG.SIDEBAR_WIDTH
SideBar.Position = UDim2.new(0, 0, 0, 40) -- Sous la TopBar
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30) -- Plus sombre que le fond principal
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local SideBarLayout = Instance.new("UIListLayout")
SideBarLayout.FillDirection = Enum.FillDirection.Vertical
SideBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideBarLayout.Padding = UDim.new(0, 5)
SideBarLayout.Parent = SideBar

-- Crée le cadre de contenu principal
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -UI_CONFIG.SIDEBAR_WIDTH.Offset, 1, -40) -- Prend le reste de l'espace
ContentFrame.Position = UDim2.new(0, UI_CONFIG.SIDEBAR_WIDTH.Offset, 0, 40)
ContentFrame.BackgroundColor3 = UI_CONFIG.MAIN_BG_COLOR
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.FillDirection = Enum.FillDirection.Vertical
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
ContentLayout.Padding = UDim.new(0, 10)
ContentLayout.Parent = ContentFrame

-- Dictionnaire pour stocker les cadres de contenu des onglets
local tabContents = {}

-- Fonction pour créer un bouton de navigation dans la sidebar
local function createSideBarButton(name, iconAssetId)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = name .. "ButtonFrame"
    buttonFrame.Size = UDim2.new(1, -10, 0, 40)
    buttonFrame.Position = UDim2.new(0, 5, 0, 0)
    buttonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Parent = SideBar

    local UICornerButton = Instance.new("UICorner")
    UICornerButton.CornerRadius = UDim.new(0, 5)
    UICornerButton.Parent = buttonFrame

    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = name
    button.TextColor3 = UI_CONFIG.TEXT_COLOR
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.TextWrapped = true
    button.Parent = buttonFrame

    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 24, 0, 24)
    icon.Position = UDim2.new(0, 10, 0.5, -12)
    icon.BackgroundTransparency = 1
    icon.Image = iconAssetId
    icon.ImageColor3 = UI_CONFIG.TEXT_COLOR
    icon.Parent = buttonFrame

    local function selectTab()
        for _, frame in pairs(tabContents) do
            frame.Visible = false
        end
        tabContents[name].Visible = true
        currentTab = name

        -- Mettre à jour la couleur des boutons de la sidebar
        for _, btn in pairs(SideBar:GetChildren()) do
            if btn:IsA("Frame") and string.find(btn.Name, "ButtonFrame") then
                local btnText = btn:FindFirstChildOfClass("TextButton")
                if btnText and btnText.Text == name then
                    btn.BackgroundColor3 = UI_CONFIG.ACCENT_COLOR
                else
                    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                end
            end
        end
    end

    button.MouseButton1Click:Connect(selectTab)

    -- Créer le cadre de contenu pour cet onglet
    local tabContentFrame = Instance.new("Frame")
    tabContentFrame.Name = name .. "TabContent"
    tabContentFrame.Size = UDim2.new(1, -20, 1, -20) -- Avec padding
    tabContentFrame.Position = UDim2.new(0, 10, 0, 10)
    tabContentFrame.BackgroundColor3 = UI_CONFIG.MAIN_BG_COLOR
    tabContentFrame.BackgroundTransparency = 1
    tabContentFrame.BorderSizePixel = 0
    tabContentFrame.Visible = (name == currentTab)
    tabContentFrame.Parent = ContentFrame

    local tabContentLayout = Instance.new("UIListLayout")
    tabContentLayout.FillDirection = Enum.FillDirection.Vertical
    tabContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    tabContentLayout.Padding = UDim.new(0, 10)
    tabContentLayout.Parent = tabContentFrame

    tabContents[name] = tabContentFrame

    return tabContentFrame, buttonFrame -- Retourne le cadre de contenu et le cadre du bouton
end

-- Fonction pour créer une section dans un onglet
local function createSection(parentFrame, title, description)
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = title:gsub(" ", "") .. "Section"
    sectionFrame.Size = UDim2.new(1, 0, 0, 0) -- Taille ajustée par le layout
    sectionFrame.AutomaticSize = Enum.AutomaticSize.Y -- Ajuste la hauteur automatiquement
    sectionFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45) -- Fond de section légèrement plus clair
    sectionFrame.BorderSizePixel = 0
    sectionFrame.Parent = parentFrame

    local UICornerSection = Instance.new("UICorner")
    UICornerSection.CornerRadius = UI_CONFIG.CORNER_RADIUS
    UICornerSection.Parent = sectionFrame

    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "SectionTitle"
    sectionTitle.Size = UDim2.new(1, 0, 0, 25)
    sectionTitle.Position = UDim2.new(0, 0, 0, 5)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = title
    sectionTitle.TextColor3 = UI_CONFIG.HEADER_TEXT_COLOR
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.TextSize = 16
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.TextWrapped = true
    sectionTitle.Parent = sectionFrame

    local sectionDescription = Instance.new("TextLabel")
    sectionDescription.Name = "SectionDescription"
    sectionDescription.Size = UDim2.new(1, 0, 0, 20)
    sectionDescription.Position = UDim2.new(0, 0, 0, 25)
    sectionDescription.BackgroundTransparency = 1
    sectionDescription.Text = description
    sectionDescription.TextColor3 = UI_CONFIG.TEXT_COLOR
    sectionDescription.Font = Enum.Font.Gotham
    sectionDescription.TextSize = 12
    sectionDescription.TextXAlignment = Enum.TextXAlignment.Left
    sectionDescription.TextWrapped = true
    sectionDescription.Parent = sectionFrame

    local sectionLayout = Instance.new("UIListLayout")
    sectionLayout.FillDirection = Enum.FillDirection.Vertical
    sectionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    sectionLayout.Padding = UDim.new(0, 5)
    sectionLayout.Parent = sectionFrame

    return sectionFrame
end

-- Fonction pour créer un bouton stylisé
local function createStyledButton(parentFrame, text, iconAssetId, description, callback)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = text:gsub(" ", "") .. "ButtonFrame"
    buttonFrame.Size = UDim2.new(1, -20, 0, 60)
    buttonFrame.Position = UDim2.new(0, 10, 0, 0)
    buttonFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55) -- Fond de bouton
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Parent = parentFrame

    local UICornerButton = Instance.new("UICorner")
    UICornerButton.CornerRadius = UI_CONFIG.CORNER_RADIUS
    UICornerButton.Parent = buttonFrame

    local button = Instance.new("TextButton")
    button.Name = text:gsub(" ", "") .. "Button"
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    button.Parent = buttonFrame

    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 32, 0, 32)
    icon.Position = UDim2.new(0, 10, 0.5, -16)
    icon.BackgroundTransparency = 1
    icon.Image = iconAssetId
    icon.ImageColor3 = UI_CONFIG.ACCENT_COLOR
    icon.Parent = buttonFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(0, 150, 0, 20)
    titleLabel.Position = UDim2.new(0, 50, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = text
    titleLabel.TextColor3 = UI_CONFIG.HEADER_TEXT_COLOR
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = buttonFrame

    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "DescriptionLabel"
    descLabel.Size = UDim2.new(0, 200, 0, 20)
    descLabel.Position = UDim2.new(0, 50, 0, 30)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = description
    descLabel.TextColor3 = UI_CONFIG.TEXT_COLOR
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 12
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = buttonFrame

    local playButton = Instance.new("ImageButton")
    playButton.Name = "PlayButton"
    playButton.Size = UDim2.new(0, 30, 0, 30)
    playButton.Position = UDim2.new(1, -40, 0.5, -15)
    playButton.BackgroundTransparency = 1
    playButton.Image = "rbxassetid://3926305904" -- Icône de lecture (Play)
    playButton.ImageColor3 = UI_CONFIG.ACCENT_COLOR
    playButton.Parent = buttonFrame

    playButton.MouseButton1Click:Connect(callback)

    return buttonFrame
end

-- Fonction pour créer un toggle stylisé
local function createStyledToggle(parentFrame, text, defaultValue, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = text:gsub(" ", "") .. "ToggleFrame"
    toggleFrame.Size = UDim2.new(1, -20, 0, 30)
    toggleFrame.Position = UDim2.new(0, 10, 0, 0)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parentFrame

    local UICornerToggle = Instance.new("UICorner")
    UICornerToggle.CornerRadius = UDim.new(0, 5)
    UICornerToggle.Parent = toggleFrame

    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "ToggleLabel"
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.Position = UDim2.new(0, 10, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = text
    toggleLabel.TextColor3 = UI_CONFIG.TEXT_COLOR
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextSize = 14
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 50, 0, 20)
    toggleButton.Position = UDim2.new(1, -60, 0.5, -10)
    toggleButton.BackgroundColor3 = defaultValue and UI_CONFIG.ACCENT_COLOR or Color3.fromRGB(60, 60, 70)
    toggleButton.Text = defaultValue and "ON" or "OFF"
    toggleButton.TextColor3 = UI_CONFIG.HEADER_TEXT_COLOR
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 12
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame

    local UICornerToggleBtn = Instance.new("UICorner")
    UICornerToggleBtn.CornerRadius = UDim.new(0, 5)
    UICornerToggleBtn.Parent = toggleButton

    local value = defaultValue

    toggleButton.MouseButton1Click:Connect(function()
        value = not value
        toggleButton.BackgroundColor3 = value and UI_CONFIG.ACCENT_COLOR or Color3.fromRGB(60, 60, 70)
        toggleButton.Text = value and "ON" or "OFF"
        if callback then callback(value) end
    end)

    return toggleFrame
end

-- Création des onglets et sections
local CombatTabContent, CombatButtonFrame = createSideBarButton("Combat", "rbxassetid://6030396009") -- Exemple d'icône d'épée
local FarmingTabContent, FarmingButtonFrame = createSideBarButton("Farming", "rbxassetid://6030396009") -- Exemple d'icône de sac d'argent
local PlayerTabContent, PlayerButtonFrame = createSideBarButton("Player", "rbxassetid://6030396009") -- Exemple d'icône de personne
local VisualsTabContent, VisualsButtonFrame = createSideBarButton("Visuals", "rbxassetid://6030396009") -- Exemple d'icône d'œil
local MiscTabContent, MiscButtonFrame = createSideBarButton("Misc", "rbxassetid://6030396009") -- Exemple d'icône de trois points
local SettingsTabContent, SettingsButtonFrame = createSideBarButton("Settings", "rbxassetid://6030396009") -- Exemple d'icône d'engrenage

-- Sélectionne l'onglet Combat par défaut et met à jour son style
CombatButtonFrame.BackgroundColor3 = UI_CONFIG.ACCENT_COLOR

-- Contenu de l'onglet Combat
local CombatMainSection = createSection(CombatTabContent, "Combat", "Prenez le contrôle. Éliminez. Dominez.")

createStyledButton(CombatMainSection, "Kill All", "rbxassetid://6030396009", "Éliminez tous les joueurs sur le serveur.", function()
    print("Fonctionnalité Kill All activée!")
    -- Implémentation réelle de Kill All ici
end)

createStyledButton(CombatMainSection, "Fling Player", "rbxassetid://6030396009", "Projetez le joueur sélectionné.", function()
    print("Fonctionnalité Fling Player activée!")
    -- Implémentation réelle de Fling Player ici
end)

-- Contenu de l'onglet Farming
local FarmingMainSection = createSection(FarmingTabContent, "Farming", "Collectez des ressources rapidement.")

createStyledButton(FarmingMainSection, "Farm Pièces", "rbxassetid://6030396009", "Collectez toutes les pièces à proximité.", function()
    print("Fonctionnalité Farm Pièces activée!")
    -- Implémentation réelle de Farm Pièces ici
end)

-- Contenu de l'onglet Settings
local SettingsVisualsSection = createSection(SettingsTabContent, "Visuels", "Ajustez l'apparence de l'interface.")

createStyledToggle(SettingsVisualsSection, "Animations Fluides", true, function(value)
    print("Animations Fluides: " .. tostring(value))
    -- Placeholder pour des options d'animations fluides
end)

-- Message de confirmation pour l'utilisateur
print("Interface utilisateur MM2 Premium autonome chargée avec succès!")
