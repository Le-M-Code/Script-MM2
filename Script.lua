--!strict

--[[ Services ]]--
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

--[[ Configuration ]]--
local CONFIG = {
    UI_NAME = "MM2 Premium UI",
    MAIN_COLOR = Color3.fromRGB(40, 40, 40), -- Couleur de fond principale
    ACCENT_COLOR = Color3.fromRGB(0, 120, 255), -- Couleur d'accentuation (bleu)
    TEXT_COLOR = Color3.fromRGB(255, 255, 255), -- Couleur du texte
    GLASS_ALPHA = 0.2, -- Transparence pour l'effet Glassmorphism
    GLASS_BLUR = 10, -- Intensité du flou pour l'effet Glassmorphism
    ANIMATION_TIME = 0.2, -- Durée des animations en secondes
    MINI_MODE_SIZE = UDim2.new(0, 50, 0, 50), -- Taille du bouton en mode mini
    FULL_MODE_SIZE = UDim2.new(0, 600, 0, 400), -- Taille de l'interface en mode complet
}

--[[ Fonctions utilitaires ]]--
local function createFrame(parent, name, size, position, color, transparency, border, cornerRadius)
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = size or UDim2.new(0, 200, 0, 100)
    frame.Position = position or UDim2.new(0.5, -100, 0.5, -50)
    frame.BackgroundColor3 = color or CONFIG.MAIN_COLOR
    frame.BackgroundTransparency = transparency or 0
    frame.BorderSizePixel = border or 0
    frame.Parent = parent

    if cornerRadius then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, cornerRadius)
        corner.Parent = frame
    end

    return frame
end

local function createTextLabel(parent, name, text, size, position, textColor, textSize, textFont, textXAlignment, textYAlignment)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Text = text
    label.Size = size or UDim2.new(1, 0, 0, 30)
    label.Position = position or UDim2.new(0, 0, 0, 0)
    label.TextColor3 = textColor or CONFIG.TEXT_COLOR
    label.TextSize = textSize or 18
    label.Font = textFont or Enum.Font.GothamBold
    label.BackgroundTransparency = 1
    label.TextXAlignment = textXAlignment or Enum.TextXAlignment.Center
    label.TextYAlignment = textYAlignment or Enum.TextYAlignment.Center
    label.Parent = parent
    return label
end

local function createTextButton(parent, name, text, size, position, color, transparency, textColor, textSize, textFont, cornerRadius)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Text = text
    button.Size = size or UDim2.new(0, 100, 0, 30)
    button.Position = position or UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = color or CONFIG.ACCENT_COLOR
    button.BackgroundTransparency = transparency or 0
    button.TextColor3 = textColor or CONFIG.TEXT_COLOR
    button.TextSize = textSize or 16
    button.Font = textFont or Enum.Font.GothamBold
    button.BorderSizePixel = 0
    button.Parent = parent

    if cornerRadius then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, cornerRadius)
        corner.Parent = button
    end

    return button
end

--[[ Initialisation de l'interface ]]--
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Premium_UI"
ScreenGui.DisplayOrder = 999 -- S'assure que l'UI est au-dessus des autres
ScreenGui.Parent = playerGui

-- Conteneur principal de l'UI (pour le Glassmorphism)
local MainContainer = createFrame(ScreenGui, "MainContainer", CONFIG.FULL_MODE_SIZE, UDim2.new(0.5, -CONFIG.FULL_MODE_SIZE.X.Offset / 2, 0.5, -CONFIG.FULL_MODE_SIZE.Y.Offset / 2), CONFIG.MAIN_COLOR, CONFIG.GLASS_ALPHA, 0, 10)
MainContainer.ClipsDescendants = true

-- Effet visuel Premium (Bordure Glassmorphism)
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1.5
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Transparency = 0.8
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainContainer

-- Le BlurEffect doit être dans Lighting pour fonctionner sur Roblox
local GlassBlur = Instance.new("BlurEffect")
GlassBlur.Name = "MM2_UI_Blur"
GlassBlur.Size = CONFIG.GLASS_BLUR
GlassBlur.Enabled = true
GlassBlur.Parent = game:GetService("Lighting")

-- Header de l'UI
local Header = createFrame(MainContainer, "Header", UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 0), CONFIG.MAIN_COLOR, 0.1, 0, 0)
local TitleLabel = createTextLabel(Header, "TitleLabel", CONFIG.UI_NAME, UDim2.new(1, -50, 1, 0), UDim2.new(0, 0, 0, 0), CONFIG.TEXT_COLOR, 20, Enum.Font.GothamBold)
local CloseButton = createTextButton(Header, "CloseButton", "X", UDim2.new(0, 40, 1, 0), UDim2.new(1, -40, 0, 0), Color3.fromRGB(200, 0, 0), 0, CONFIG.TEXT_COLOR, 18, Enum.Font.GothamBold, 0)

-- Conteneur pour les onglets
local TabContainer = createFrame(MainContainer, "TabContainer", UDim2.new(0, 150, 1, -40), UDim2.new(0, 0, 0, 40), CONFIG.MAIN_COLOR, 0.1, 0, 0)
local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Vertical
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabContainer

-- Conteneur pour le contenu des onglets
local ContentContainer = createFrame(MainContainer, "ContentContainer", UDim2.new(1, -150, 1, -40), UDim2.new(0, 150, 0, 40), CONFIG.MAIN_COLOR, 0.1, 0, 0)
ContentContainer.ClipsDescendants = true

--[[ Logique du mode mini ]]--
local MiniModeButton = createTextButton(playerGui, "MiniModeButton", "MM2", CONFIG.MINI_MODE_SIZE, UDim2.new(0, 10, 0, 10), CONFIG.ACCENT_COLOR, 0, CONFIG.TEXT_COLOR, 16, Enum.Font.GothamBold, 5)
MiniModeButton.ZIndex = 1000 -- S'assure qu'il est toujours visible

local isUIOpen = true

local function toggleUIVisibility()
    isUIOpen = not isUIOpen
    
    local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    
    if isUIOpen then
        MainContainer.Visible = true
        MainContainer.Size = UDim2.new(0, 0, 0, 0)
        MainContainer.Position = MiniModeButton.Position
        
        TweenService:Create(MainContainer, tweenInfo, {
            Size = CONFIG.FULL_MODE_SIZE,
            Position = UDim2.new(0.5, -CONFIG.FULL_MODE_SIZE.X.Offset / 2, 0.5, -CONFIG.FULL_MODE_SIZE.Y.Offset / 2),
            BackgroundTransparency = CONFIG.GLASS_ALPHA
        }):Play()
        
        TweenService:Create(GlassBlur, tweenInfo, {Size = CONFIG.GLASS_BLUR}):Play()
        
        -- Animation du bouton mini (disparition)
        TweenService:Create(MiniModeButton, tweenInfo, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
        task.delay(0.4, function() MiniModeButton.Visible = false end)
    else
        TweenService:Create(MainContainer, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = MiniModeButton.Position,
            BackgroundTransparency = 1
        }):Play()
        
        TweenService:Create(GlassBlur, tweenInfo, {Size = 0}):Play()
        
        -- Animation du bouton mini (apparition)
        MiniModeButton.Visible = true
        MiniModeButton.Size = UDim2.new(0, 0, 0, 0)
        MiniModeButton.BackgroundTransparency = 1
        TweenService:Create(MiniModeButton, tweenInfo, {Size = CONFIG.MINI_MODE_SIZE, BackgroundTransparency = 0}):Play()
        
        task.delay(0.4, function() MainContainer.Visible = false end)
    end
end

CloseButton.MouseButton1Click:Connect(toggleUIVisibility)
MiniModeButton.MouseButton1Click:Connect(toggleUIVisibility)

-- Initialisation de l'état de l'UI
MainContainer.Size = CONFIG.FULL_MODE_SIZE
MainContainer.Position = UDim2.new(0.5, -CONFIG.FULL_MODE_SIZE.X.Offset / 2, 0.5, -CONFIG.FULL_MODE_SIZE.Y.Offset / 2)
MiniModeButton.Visible = false -- Le bouton mini est caché au démarrage car l'UI est ouverte

-- Fonction de Drag générique
local function makeDraggable(frame, handle)
    local dragging = false
    local dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(MainContainer, Header)
makeDraggable(MiniModeButton, MiniModeButton)

--[[ Système de Composants ]]--
local Tabs = {}
local CurrentTab = nil

local function createTab(tabName)
    local tabButton = createTextButton(TabContainer, tabName .. "Tab", tabName, UDim2.new(1, -10, 0, 35), nil, CONFIG.MAIN_COLOR, 0.2, CONFIG.TEXT_COLOR, 14, Enum.Font.GothamBold, 5)
    
    local tabContent = Instance.new("CanvasGroup")
    tabContent.Name = tabName .. "Content"
    tabContent.Size = UDim2.new(1, -20, 1, -20)
    tabContent.Position = UDim2.new(0, 10, 0, 10)
    tabContent.BackgroundTransparency = 1
    tabContent.Visible = false
    tabContent.Parent = ContentContainer
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = tabContent

    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingLeft = UDim.new(0, 5)
    contentPadding.PaddingRight = UDim.new(0, 5)
    contentPadding.PaddingTop = UDim.new(0, 5)
    contentPadding.Parent = tabContent

    tabButton.MouseEnter:Connect(function()
        TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.ACCENT_COLOR}):Play()
    end)
    
    tabButton.MouseLeave:Connect(function()
        if CurrentTab and CurrentTab.Button ~= tabButton then
            TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.MAIN_COLOR}):Play()
        end
    end)

    tabButton.MouseButton1Click:Connect(function()
        if CurrentTab and CurrentTab.Button ~= tabButton then
            local oldTab = CurrentTab
            CurrentTab = {Button = tabButton, Content = tabContent}
            
            -- Animation de sortie de l'ancien onglet
            TweenService:Create(oldTab.Content, TweenInfo.new(0.2), {GroupTransparency = 1}):Play()
            task.delay(0.2, function()
                oldTab.Content.Visible = false
                oldTab.Button.BackgroundColor3 = CONFIG.MAIN_COLOR
                
                -- Animation d'entrée du nouvel onglet
                tabContent.Visible = true
                tabContent.GroupTransparency = 1
                tabButton.BackgroundColor3 = CONFIG.ACCENT_COLOR
                TweenService:Create(tabContent, TweenInfo.new(0.2), {GroupTransparency = 0}):Play()
            end)
        end
    end)

    Tabs[tabName] = {Button = tabButton, Content = tabContent}
    
    -- Activer le premier onglet par défaut
    if not CurrentTab then
        tabButton.BackgroundColor3 = CONFIG.ACCENT_COLOR
        tabContent.Visible = true
        CurrentTab = {Button = tabButton, Content = tabContent}
    end

    return tabContent
end

local function createToggle(parent, text, default, callback)
    local toggleFrame = createFrame(parent, text .. "Toggle", UDim2.new(1, 0, 0, 35), nil, CONFIG.MAIN_COLOR, 0.3, 0, 5)
    local toggleLabel = createTextLabel(toggleFrame, "Label", text, UDim2.new(1, -50, 1, 0), UDim2.new(0, 10, 0, 0), CONFIG.TEXT_COLOR, 14, Enum.Font.Gotham, Enum.TextXAlignment.Left)
    
    local toggleButton = createTextButton(toggleFrame, "Button", "", UDim2.new(0, 40, 0, 20), UDim2.new(1, -45, 0.5, -10), Color3.fromRGB(100, 100, 100), 0, CONFIG.TEXT_COLOR, 0, Enum.Font.Gotham, 10)
    local toggleIndicator = createFrame(toggleButton, "Indicator", UDim2.new(0, 16, 0, 16), UDim2.new(0, 2, 0.5, -8), CONFIG.TEXT_COLOR, 0, 0, 8)
    
    local isOn = default or false
    
    local function updateToggle()
        local targetPos = isOn and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local targetColor = isOn and CONFIG.ACCENT_COLOR or Color3.fromRGB(100, 100, 100)
        
        TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        
        callback(isOn)
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        isOn = not isOn
        updateToggle()
    end)
    
    updateToggle()
    return toggleFrame
end

local function createSlider(parent, text, min, max, default, callback)
    local sliderFrame = createFrame(parent, text .. "Slider", UDim2.new(1, 0, 0, 50), nil, CONFIG.MAIN_COLOR, 0.3, 0, 5)
    local sliderLabel = createTextLabel(sliderFrame, "Label", text .. ": " .. tostring(default), UDim2.new(1, -20, 0, 20), UDim2.new(0, 10, 0, 5), CONFIG.TEXT_COLOR, 14, Enum.Font.Gotham, Enum.TextXAlignment.Left)
    
    local sliderBar = createFrame(sliderFrame, "Bar", UDim2.new(1, -20, 0, 6), UDim2.new(0, 10, 0, 35), Color3.fromRGB(60, 60, 60), 0, 0, 3)
    local sliderFill = createFrame(sliderBar, "Fill", UDim2.new((default - min) / (max - min), 0, 1, 0), UDim2.new(0, 0, 0, 0), CONFIG.ACCENT_COLOR, 0, 0, 3)
    local sliderKnob = createFrame(sliderBar, "Knob", UDim2.new(0, 12, 0, 12), UDim2.new((default - min) / (max - min), -6, 0.5, -6), CONFIG.TEXT_COLOR, 0, 0, 6)
    
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * pos)
        
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        sliderKnob.Position = UDim2.new(pos, -6, 0.5, -6)
        sliderLabel.Text = text .. ": " .. tostring(value)
        
        callback(value)
    end
    
    local dragging = false
    sliderKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    return sliderFrame
end

local function createDropdown(parent, text, options, callback)
    local dropdownFrame = createFrame(parent, text .. "Dropdown", UDim2.new(1, 0, 0, 35), nil, CONFIG.MAIN_COLOR, 0.3, 0, 5)
    local dropdownLabel = createTextLabel(dropdownFrame, "Label", text, UDim2.new(1, -30, 1, 0), UDim2.new(0, 10, 0, 0), CONFIG.TEXT_COLOR, 14, Enum.Font.Gotham, Enum.TextXAlignment.Left)
    
    local arrow = createTextLabel(dropdownFrame, "Arrow", ">", UDim2.new(0, 20, 1, 0), UDim2.new(1, -25, 0, 0), CONFIG.TEXT_COLOR, 14, Enum.Font.GothamBold)
    
    local listFrame = createFrame(parent, text .. "List", UDim2.new(1, 0, 0, #options * 30), nil, CONFIG.MAIN_COLOR, 0.1, 0, 5)
    listFrame.Visible = false
    listFrame.ZIndex = 10
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = listFrame
    
    local listStroke = Instance.new("UIStroke")
    listStroke.Thickness = 1
    listStroke.Color = Color3.fromRGB(255, 255, 255)
    listStroke.Transparency = 0.8
    listStroke.Parent = listFrame
    
    for _, option in ipairs(options) do
        local optionBtn = createTextButton(listFrame, option, option, UDim2.new(1, 0, 0, 30), nil, CONFIG.MAIN_COLOR, 0.5, CONFIG.TEXT_COLOR, 12, Enum.Font.Gotham, 0)
        optionBtn.MouseButton1Click:Connect(function()
            dropdownLabel.Text = text .. ": " .. option
            listFrame.Visible = false
            arrow.Rotation = 0
            callback(option)
        end)
    end
    
    dropdownFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            listFrame.Visible = not listFrame.Visible
            arrow.Rotation = listFrame.Visible and 90 or 0
        end
    end)
    
    return dropdownFrame
end

--[[ Initialisation du contenu ]]--
local CombatTab = createTab("Combat")
local VisualsTab = createTab("Visuals")
local MiscTab = createTab("Misc")

-- Exemples de fonctionnalités pour MM2
createToggle(CombatTab, "Auto Farm", false, function(v) print("Auto Farm:", v) end)
createSlider(CombatTab, "Kill Aura Range", 5, 50, 15, function(v) print("Range:", v) end)

createToggle(VisualsTab, "ESP Players", true, function(v) print("ESP:", v) end)
createToggle(VisualsTab, "ESP Items", false, function(v) print("Items ESP:", v) end)
createDropdown(VisualsTab, "ESP Theme", {"Classic", "Rainbow", "Outline"}, function(v) print("Theme:", v) end)

createSlider(MiscTab, "WalkSpeed", 16, 100, 16, function(v) 
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = v
    end
end)
createToggle(MiscTab, "Infinite Jump", false, function(v) print("Inf Jump:", v) end)

print("MM2 Premium UI Initialized with Components")
