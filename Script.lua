--[[ 
    Interface Utilisateur Premium Autonome pour Cheat MM2 Roblox (Luau) 
    Développé par Manus AI 

    Ce script implémente une interface utilisateur de style ImGui entièrement personnalisée en Luau, 
    sans dépendances externes. Il est conçu pour être injecté dans un environnement Roblox. 
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Configuration de base de l'UI
local UI_CONFIG = {
    MAIN_COLOR = Color3.fromRGB(0, 120, 255), -- Bleu premium
    ACCENT_COLOR = Color3.fromRGB(25, 25, 25), -- Gris foncé pour les fonds
    TEXT_COLOR = Color3.fromRGB(255, 255, 255), -- Texte blanc
    WINDOW_SIZE = UDim2.new(0, 500, 0, 400),
    WINDOW_POSITION = UDim2.new(0.5, -250, 0.5, -200), -- Centré
    TAB_HEIGHT = 30,
    SECTION_PADDING = 10,
    CONTROL_HEIGHT = 25,
    NINJA_ICON_ASSET_ID = "rbxassetid://1234567890" -- REMPLACEZ CECI PAR L'ID DE VOTRE ICÔNE NINJA
}

-- Variables d'état de l'UI
local isUIHidden = false
local currentTab = "Fonctionnalités"

-- Crée le ScreenGui principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2PremiumUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Crée le bouton toggle (icône ninja)
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 40, 0, 40)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundTransparency = 1
ToggleButton.Image = UI_CONFIG.NINJA_ICON_ASSET_ID
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
MainFrame.BackgroundColor3 = UI_CONFIG.ACCENT_COLOR
MainFrame.BorderSizePixel = 0
MainFrame.Draggable = true -- Permet de glisser la fenêtre
MainFrame.Visible = true -- Visible par défaut
MainFrame.Parent = ScreenGui

-- Crée le titre de la fenêtre
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, UI_CONFIG.TAB_HEIGHT)
TitleBar.BackgroundColor3 = UI_CONFIG.MAIN_COLOR
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundColor3 = UI_CONFIG.MAIN_COLOR
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "MM2 Premium Cheat"
TitleLabel.TextColor3 = UI_CONFIG.TEXT_COLOR
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.Parent = TitleBar

-- Crée le cadre pour les onglets
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, 0, 0, UI_CONFIG.TAB_HEIGHT)
TabBar.Position = UDim2.new(0, 0, 0, UI_CONFIG.TAB_HEIGHT)
TabBar.BackgroundColor3 = UI_CONFIG.ACCENT_COLOR
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabBar

-- Crée le cadre pour le contenu des onglets
local TabContentFrame = Instance.new("Frame")
TabContentFrame.Name = "TabContentFrame"
TabContentFrame.Size = UDim2.new(1, 0, 1, - (UI_CONFIG.TAB_HEIGHT * 2))
TabContentFrame.Position = UDim2.new(0, 0, 0, UI_CONFIG.TAB_HEIGHT * 2)
TabContentFrame.BackgroundColor3 = UI_CONFIG.ACCENT_COLOR
TabContentFrame.BackgroundTransparency = 0.5
TabContentFrame.BorderSizePixel = 0
TabContentFrame.Parent = MainFrame

local TabContentListLayout = Instance.new("UIListLayout")
TabContentListLayout.FillDirection = Enum.FillDirection.Vertical
TabContentListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabContentListLayout.Padding = UDim.new(0, UI_CONFIG.SECTION_PADDING)
TabContentListLayout.Parent = TabContentFrame

-- Fonctions utilitaires pour créer des éléments d'UI
local function createTab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "TabButton"
    tabButton.Size = UDim2.new(0, 100, 1, 0)
    tabButton.BackgroundColor3 = UI_CONFIG.ACCENT_COLOR
    tabButton.Text = name
    tabButton.TextColor3 = UI_CONFIG.TEXT_COLOR
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 14
    tabButton.BorderSizePixel = 0
    tabButton.Parent = TabBar

    local tabContent = Instance.new("Frame")
    tabContent.Name = name .. "TabContent"
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.BackgroundColor3 = UI_CONFIG.ACCENT_COLOR
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.Visible = (name == currentTab) -- Visible si c'est l'onglet actuel
    tabContent.Parent = TabContentFrame

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.FillDirection = Enum.FillDirection.Vertical
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    contentLayout.Padding = UDim.new(0, UI_CONFIG.SECTION_PADDING)
    contentLayout.Parent = tabContent

    tabButton.MouseButton1Click:Connect(function()
        for _, child in ipairs(TabContentFrame:GetChildren()) do
            if child:IsA("Frame") and string.find(child.Name, "TabContent") then
                child.Visible = false
            end
        end
        tabContent.Visible = true
        currentTab = name
    end)

    return tabContent
end

local function createSection(parentFrame, title)
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = title .. "Section"
    sectionFrame.Size = UDim2.new(1, 0, 0, 0) -- Taille ajustée par le layout
    sectionFrame.AutomaticSize = Enum.AutomaticSize.Y -- Ajuste la hauteur automatiquement
    sectionFrame.BackgroundColor3 = UI_CONFIG.ACCENT_COLOR
    sectionFrame.BackgroundTransparency = 0.7
    sectionFrame.BorderSizePixel = 0
    sectionFrame.Parent = parentFrame

    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "SectionTitle"
    sectionTitle.Size = UDim2.new(1, 0, 0, UI_CONFIG.CONTROL_HEIGHT)
    sectionTitle.BackgroundColor3 = UI_CONFIG.MAIN_COLOR
    sectionTitle.BackgroundTransparency = 0.8
    sectionTitle.Text = title
    sectionTitle.TextColor3 = UI_CONFIG.TEXT_COLOR
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.TextSize = 16
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.TextWrapped = true
    sectionTitle.Parent = sectionFrame

    local sectionLayout = Instance.new("UIListLayout")
    sectionLayout.FillDirection = Enum.FillDirection.Vertical
    sectionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    sectionLayout.Padding = UDim.new(0, 5)
    sectionLayout.Parent = sectionFrame

    return sectionFrame
end

local function createButton(parentFrame, text, callback)
    local button = Instance.new("TextButton")
    button.Name = text .. "Button"
    button.Size = UDim2.new(1, -UI_CONFIG.SECTION_PADDING * 2, 0, UI_CONFIG.CONTROL_HEIGHT)
    button.Position = UDim2.new(0, UI_CONFIG.SECTION_PADDING, 0, 0)
    button.BackgroundColor3 = UI_CONFIG.MAIN_COLOR
    button.Text = text
    button.TextColor3 = UI_CONFIG.TEXT_COLOR
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.BorderSizePixel = 0
    button.Parent = parentFrame

    button.MouseButton1Click:Connect(callback)

    return button
end

local function createToggle(parentFrame, text, defaultValue, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = text .. "ToggleFrame"
    toggleFrame.Size = UDim2.new(1, -UI_CONFIG.SECTION_PADDING * 2, 0, UI_CONFIG.CONTROL_HEIGHT)
    toggleFrame.Position = UDim2.new(0, UI_CONFIG.SECTION_PADDING, 0, 0)
    toggleFrame.BackgroundColor3 = UI_CONFIG.ACCENT_COLOR
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parentFrame

    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "ToggleLabel"
    toggleLabel.Size = UDim2.new(0.8, 0, 1, 0)
    toggleLabel.BackgroundColor3 = UI_CONFIG.ACCENT_COLOR
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = text
    toggleLabel.TextColor3 = UI_CONFIG.TEXT_COLOR
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextSize = 14
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0.2, 0, 1, 0)
    toggleButton.Position = UDim2.new(0.8, 0, 0, 0)
    toggleButton.BackgroundColor3 = defaultValue and UI_CONFIG.MAIN_COLOR or Color3.fromRGB(50, 50, 50)
    toggleButton.Text = defaultValue and "ON" or "OFF"
    toggleButton.TextColor3 = UI_CONFIG.TEXT_COLOR
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 14
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleFrame

    local value = defaultValue

    toggleButton.MouseButton1Click:Connect(function()
        value = not value
        toggleButton.BackgroundColor3 = value and UI_CONFIG.MAIN_COLOR or Color3.fromRGB(50, 50, 50)
        toggleButton.Text = value and "ON" or "OFF"
        if callback then callback(value) end
    end)

    return toggleFrame
end

-- Création des onglets et sections
local MainTabContent = createTab("Fonctionnalités")
local CombatSection = createSection(MainTabContent, "Combat")

createButton(CombatSection, "Kill All", function()
    print("Fonctionnalité Kill All activée!")
    -- Implémentation réelle de Kill All ici
end)

createToggle(CombatSection, "Fling Player", false, function(value)
    print("Fling Player: " .. tostring(value))
    -- Implémentation réelle de Fling Player ici
end)

local FarmTabContent = createTab("Farming")
local PieceFarmSection = createSection(FarmTabContent, "Farm Pièces")

createButton(PieceFarmSection, "Farm Pièces", function()
    print("Fonctionnalité Farm Pièces activée!")
    -- Implémentation réelle de Farm Pièces ici
end)

local SettingsTabContent = createTab("Paramètres")
local VisualsSection = createSection(SettingsTabContent, "Visuels")

createToggle(VisualsSection, "Animations Fluides", true, function(value)
    print("Animations Fluides: " .. tostring(value))
    -- Placeholder pour des options d'animations fluides
end)

-- Message de confirmation pour l'utilisateur
print("Interface utilisateur MM2 Premium autonome chargée avec succès!")
