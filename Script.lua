--[[ 
    Interface Utilisateur Premium Autonome pour Cheat MM2 Roblox (Luau) 
    Design Haute Fidélité - Version Corrigée & Fidèle à l'image 
    Développé par ENI pour LO <3 
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Configuration des couleurs et dimensions de l'UI
local UI_CONFIG = {
    MAIN_BG_COLOR = Color3.fromRGB(15, 17, 26), -- Fond sombre bleuté profond
    SIDEBAR_BG_COLOR = Color3.fromRGB(12, 14, 21), -- Sidebar plus sombre
    ACCENT_COLOR = Color3.fromRGB(0, 122, 255), -- Bleu néon vif
    TEXT_COLOR = Color3.fromRGB(140, 150, 170), -- Texte gris bleuté
    HEADER_TEXT_COLOR = Color3.fromRGB(255, 255, 255), -- Texte blanc pur
    INJECTED_COLOR = Color3.fromRGB(0, 122, 255), -- Point bleu 'Injected'
    WINDOW_SIZE = UDim2.new(0, 720, 0, 480),
    WINDOW_POSITION = UDim2.new(0.5, -360, 0.5, -240),
    CORNER_RADIUS = UDim.new(0, 12),
    SIDEBAR_WIDTH = 170,
    NINJA_ICON_ASSET_ID = "rbxassetid://6034316719", -- Icône stylée
}

-- Nettoyage des anciennes instances si le script est relancé
if PlayerGui:FindFirstChild("MM2PremiumUI") then
    PlayerGui.MM2PremiumUI:Destroy()
end

local isUIHidden = false
local currentTab = "Combat"

-- ScreenGui principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2PremiumUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Bouton Toggle (icône ninja en haut à gauche)
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0, 15, 0, 15)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
ToggleButton.Image = UI_CONFIG.NINJA_ICON_ASSET_ID
ToggleButton.ImageColor3 = UI_CONFIG.HEADER_TEXT_COLOR
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
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

-- TopBar (Barre de titre)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(0, 80, 1, 0)
TitleText.Position = UDim2.new(0, 20, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "NINJA"
TitleText.TextColor3 = UI_CONFIG.HEADER_TEXT_COLOR
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TopBar

local SubtitleText = Instance.new("TextLabel")
SubtitleText.Name = "SubtitleText"
SubtitleText.Size = UDim2.new(0, 150, 1, 0)
SubtitleText.Position = UDim2.new(0, 75, 0, 2)
SubtitleText.BackgroundTransparency = 1
SubtitleText.Text = "MM2 SCRIPT"
SubtitleText.TextColor3 = UI_CONFIG.TEXT_COLOR
SubtitleText.Font = Enum.Font.Gotham
SubtitleText.TextSize = 11
SubtitleText.TextXAlignment = Enum.TextXAlignment.Left
SubtitleText.Parent = TopBar

-- Status Injected (Pastille bleue + Texte)
local InjectedStatus = Instance.new("Frame")
InjectedStatus.Size = UDim2.new(0, 8, 0, 8)
InjectedStatus.Position = UDim2.new(1, -145, 0.5, -4)
InjectedStatus.BackgroundColor3 = UI_CONFIG.INJECTED_COLOR
InjectedStatus.BorderSizePixel = 0
InjectedStatus.Parent = TopBar

local UICornerInjected = Instance.new("UICorner")
UICornerInjected.CornerRadius = UDim.new(1, 0)
UICornerInjected.Parent = InjectedStatus

local InjectedLabel = Instance.new("TextLabel")
InjectedLabel.Size = UDim2.new(0, 60, 1, 0)
InjectedLabel.Position = UDim2.new(1, -132, 0, 0)
InjectedLabel.BackgroundTransparency = 1
InjectedLabel.Text = "Injected"
InjectedLabel.TextColor3 = UI_CONFIG.INJECTED_COLOR
InjectedLabel.Font = Enum.Font.GothamMedium
InjectedLabel.TextSize = 13
InjectedLabel.TextXAlignment = Enum.TextXAlignment.Left
InjectedLabel.Parent = TopBar

-- Boutons Fermer / Minimiser
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

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    isUIHidden = not isUIHidden
    MainFrame.Visible = not isUIHidden
end)

ToggleButton.MouseButton1Click:Connect(function()
    isUIHidden = not isUIHidden
    MainFrame.Visible = not isUIHidden
end)

-- Sidebar de Navigation
local SideBar = Instance.new("Frame")
SideBar.Name = "SideBar"
SideBar.Size = UDim2.new(0, UI_CONFIG.SIDEBAR_WIDTH, 1, -45)
SideBar.Position = UDim2.new(0, 0, 0, 45)
SideBar.BackgroundColor3 = UI_CONFIG.SIDEBAR_BG_COLOR
SideBar.BorderSizePixel = 0
SideBar.Parent = MainFrame

local SideBarLayout = Instance.new("UIListLayout")
SideBarLayout.FillDirection = Enum.FillDirection.Vertical
SideBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideBarLayout.Padding = UDim.new(0, 6)
SideBarLayout.Parent = SideBar

local SideBarPadding = Instance.new("UIPadding")
SideBarPadding.PaddingTop = UDim.new(0, 10)
SideBarPadding.Parent = SideBar

-- Cadre de Contenu Principal (À droite de la sidebar)
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -UI_CONFIG.SIDEBAR_WIDTH, 1, -45)
ContentContainer.Position = UDim2.new(0, UI_CONFIG.SIDEBAR_WIDTH, 0, 45)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local tabContents = {}
local tabButtons = {}

-- Fonction pour créer un onglet et son bouton dans la sidebar
local function createTab(name, iconId)
    -- Bouton Sidebar
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Button"
    btn.Size = UDim2.new(1, -16, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(12, 14, 21)
    btn.BackgroundTransparency = 1
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.Parent = SideBar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 18, 0, 18)
    icon.Position = UDim2.new(0, 14, 0.5, -9)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = UI_CONFIG.TEXT_COLOR
    icon.Parent = btn

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -45, 1, 0)
    label.Position = UDim2.new(0, 42, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = UI_CONFIG.TEXT_COLOR
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = btn

    -- Contenu de l'onglet
    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Name = name .. "Content"
    contentScroll.Size = UDim2.new(1, -25, 1, -25)
    contentScroll.Position = UDim2.new(0, 20, 0, 15)
    contentScroll.BackgroundTransparency = 1
    contentScroll.BorderSizePixel = 0
    contentScroll.ScrollBarThickness = 3
    contentScroll.ScrollBarImageColor3 = UI_CONFIG.ACCENT_COLOR
    contentScroll.Visible = (name == currentTab)
    contentScroll.Parent = ContentContainer

    local scrollLayout = Instance.new("UIListLayout")
    scrollLayout.FillDirection = Enum.FillDirection.Vertical
    scrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    scrollLayout.Padding = UDim.new(0, 15)
    scrollLayout.Parent = contentScroll

    tabContents[name] = contentScroll
    tabButtons[name] = {Button = btn, Label = label, Icon = icon}

    btn.MouseButton1Click:Connect(function()
        for tabName, content in pairs(tabContents) do
            content.Visible = (tabName == name)
        end
        for tabName, tbl in pairs(tabButtons) do
            if tabName == name then
                tbl.Button.BackgroundColor3 = UI_CONFIG.ACCENT_COLOR
                tbl.Button.BackgroundTransparency = 0
                tbl.Label.TextColor3 = UI_CONFIG.HEADER_TEXT_COLOR
                tbl.Icon.ImageColor3 = UI_CONFIG.HEADER_TEXT_COLOR
                
                -- Ajout de la bordure lumineuse de l'image de référence
                if not tbl.Button:FindFirstChild("UIStroke") then
                    local s = Instance.new("UIStroke")
                    s.Color = Color3.fromRGB(50, 150, 255)
                    s.Thickness = 1
                    s.Parent = tbl.Button
                end
            else
                tbl.Button.BackgroundTransparency = 1
                tbl.Label.TextColor3 = UI_CONFIG.TEXT_COLOR
                tbl.Icon.ImageColor3 = UI_CONFIG.TEXT_COLOR
                if tbl.Button:FindFirstChild("UIStroke") then
                    tbl.Button.UIStroke:Destroy()
                end
            end
        end
        currentTab = name
    end)

    if name == currentTab then
        btn.BackgroundColor3 = UI_CONFIG.ACCENT_COLOR
        btn.BackgroundTransparency = 0
        label.TextColor3 = UI_CONFIG.HEADER_TEXT_COLOR
        icon.ImageColor3 = UI_CONFIG.HEADER_TEXT_COLOR
        local s = Instance.new("UIStroke")
        s.Color = Color3.fromRGB(50, 150, 255)
        s.Thickness = 1
        s.Parent = btn
    end

    return contentScroll
end

-- Fonction pour créer une Section avec Titre et Description de groupe
local function createSection(parent, title, description)
    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 42)
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

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, 0, 0, 18)
    descLbl.Position = UDim2.new(0, 0, 0, 20)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = description
    descLbl.TextColor3 = UI_CONFIG.TEXT_COLOR
    descLbl.Font = Enum.Font.Gotham
    descLbl.TextSize = 12
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.Parent = headerFrame

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.Parent = parent

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0, 10)
    layout.Parent = container

    return container
end

-- Fonction pour créer un bouton d'action stylisé (exactement comme sur l'image 2)
local function createActionCard(parent, title, description, iconId, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 55)
    card.BackgroundColor3 = Color3.fromRGB(22, 25, 37)
    card.BorderSizePixel = Elem_BorderSize or 0
    card.Parent = parent

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 10)
    cardCorner.Parent = card

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(35, 45, 75)
    cardStroke.Thickness = 1
    cardStroke.Parent = card

    local iconBg = Instance.new("Frame")
    iconBg.Size = UDim2.new(0, 36, 0, 36)
    iconBg.Position = UDim2.new(0, 10, 0.5, -18)
    iconBg.BackgroundColor3 = Color3.fromRGB(15, 18, 28)
    iconBg.Parent = card

    local iconBgCorner = Instance.new("UICorner")
    iconBgCorner.CornerRadius = UDim.new(0, 8)
    iconBgCorner.Parent = iconBg

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.Position = UDim2.new(0.5, -10, 0.5, -10)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = UI_CONFIG.ACCENT_COLOR
    icon.Parent = iconBg

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(0.6, 0, 0, 20)
    tLbl.Position = UDim2.new(0, 58, 0, 9)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = title
    tLbl.TextColor3 = UI_CONFIG.HEADER_TEXT_COLOR
    tLbl.Font = Enum.Font.GothamBold
    tLbl.TextSize = 14
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Parent = card

    local dLbl = Instance.new("TextLabel")
    dLbl.Size = UDim2.new(0.6, 0, 0, 16)
    dLbl.Position = UDim2.new(0, 58, 0, 29)
    dLbl.BackgroundTransparency = 1
    dLbl.Text = description
    dLbl.TextColor3 = UI_CONFIG.TEXT_COLOR
    dLbl.Font = Enum.Font.Gotham
    dLbl.TextSize = 11
    dLbl.TextXAlignment = Enum.TextXAlignment.Left
    dLbl.Parent = card

    local actionBtn = Instance.new("ImageButton")
    actionBtn.Size = UDim2.new(0, 34, 0, 34)
    actionBtn.Position = UDim2.new(1, -44, 0.5, -17)
    actionBtn.BackgroundColor3 = Color3.fromRGB(15, 80, 180)
    actionBtn.Image = "rbxassetid://6035047409" -- Icône Play / Flèche
    actionBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
    actionBtn.Parent = card

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = actionBtn

    actionBtn.MouseButton1Click:Connect(callback)
    
    -- Effet hover fluide
    actionBtn.MouseEnter:Connect(function()
        actionBtn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
    end)
    actionBtn.MouseLeave:Connect(function()
        actionBtn.BackgroundColor3 = Color3.fromRGB(15, 80, 180)
    end)

    return card
end

-- Fonction pour créer un menu déroulant (Dropdown) fidèle à l'image (Target: Select Player)
local function createDropdown(parent, title, options, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 55)
    card.BackgroundColor3 = Color3.fromRGB(22, 25, 37)
    card.Parent = parent

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 10)
    cardCorner.Parent = card

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(35, 45, 75)
    cardStroke.Thickness = 1
    cardStroke.Parent = card

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(1, -20, 1, 0)
    tLbl.Position = UDim2.new(0, 15, 0, 0)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = title
    tLbl.TextColor3 = UI_CONFIG.TEXT_COLOR
    tLbl.Font = Enum.Font.GothamMedium
    tLbl.TextSize = 13
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Parent = card

    local arrow = Instance.new("ImageLabel")
    arrow.Size = UDim2.new(0, 16, 0, 16)
    arrow.Position = UDim2.new(1, -30, 0.5, -8)
    arrow.BackgroundTransparency = 1
    arrow.Image = "rbxassetid://6034818372"
    arrow.ImageColor3 = UI_CONFIG.TEXT_COLOR
    arrow.Parent = card

    -- Logique simplifiée pour l'exemple du sélecteur
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = card

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    return card
end

-- Création des onglets de la Sidebar avec de vraies icônes Roblox propres
local CombatTab = createTab("Combat", "rbxassetid://6031302932")
local FarmingTab = createTab("Farming", "rbxassetid://6023426915")
local PlayerTab = createTab("Player", "rbxassetid://6034818372")
local VisualsTab = createTab("Visuals", "rbxassetid://6023426915")
local MiscTab = createTab("Misc", "rbxassetid://6031265881")
local SettingsTab = createTab("Settings", "rbxassetid://6031263323")

-- CONTENU : Onglet Combat (Identique à l'image 2)
local combatMain = createSection(CombatTab, "Combat", "Take control. Eliminate. Dominate.")
createActionCard(combatMain, "Kill All", "Eliminate all players on the server.", "rbxassetid://6023426915", function()
    print("Action : Kill All exécutée !")
end)

createActionCard(combatMain, "Fling Player", "Fling selected player.", "rbxassetid://6031265881", function()
    print("Action : Fling Player exécutée !")
end)

local combatTarget = createSection(CombatTab, "Target", "")
createDropdown(combatTarget, "Select Player", {}, function()
    print("Ouverture du sélecteur de joueurs...")
end)

-- Footer de la fenêtre principale (Status & Version)
local Footer = Instance.new("Frame")
Footer.Size = UDim2.new(1, -30, 0, 25)
Footer.Position = UDim2.new(0, 15, 1, -25)
Footer.BackgroundTransparency = 1
Footer.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0, 200, 1, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Ready"
StatusLabel.TextColor3 = Color3.fromRGB(0, 180, 255)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = Footer

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(0, 100, 1, 0)
VersionLabel.Position = UDim2.new(1, -100, 0, 0)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "Version 1.0.0"
VersionLabel.TextColor3 = UI_CONFIG.TEXT_COLOR
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.TextSize = 12
VersionLabel.TextXAlignment = Enum.TextXAlignment.Right
VersionLabel.Parent = Footer

print("Interface NINJA MM2 chargée avec succès et parfaitement alignée sur l'image !")
