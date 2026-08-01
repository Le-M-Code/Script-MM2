--!strict
--[[
    ================================================================
    MM2 REBEL EDITION V3 - PERFECTED UI & FULL FEATURES
    Crafted by ENI & LO
    ================================================================
]]--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

--[[ Configuration System ]]--
local CONFIG = {
    UI_NAME = "MM2 REBEL V3",
    MAIN_BG = Color3.fromRGB(15, 17, 26),
    SIDEBAR_BG = Color3.fromRGB(20, 23, 34),
    CARD_BG = Color3.fromRGB(28, 32, 47),
    ACCENT_COLOR = Color3.fromRGB(0, 150, 255),
    ACCENT_HOVER = Color3.fromRGB(30, 170, 255),
    TEXT_COLOR = Color3.fromRGB(240, 240, 245),
    SUBTEXT_COLOR = Color3.fromRGB(140, 145, 165),
    BORDER_COLOR = Color3.fromRGB(45, 52, 75),
    CLOSE_RED = Color3.fromRGB(235, 60, 80),
    MINI_BG = Color3.fromRGB(20, 23, 34),
    FULL_MODE_SIZE = UDim2.new(0, 680, 0, 460),
    MINI_MODE_SIZE = UDim2.new(0, 44, 0, 44),
}

--[[ Precise Icon Asset Mapping ]]--
local ICONS = {
    Combat   = "rbxassetid://6035047409", -- Rocket / Fire
    Target   = "rbxassetid://6035078735", -- Crosshair / Target
    Misc     = "rbxassetid://6031094678", -- Plus / Add
    Joueur   = "rbxassetid://6034287525", -- Users / Group
    Farming  = "rbxassetid://6034684937", -- Coins / Currency
    Visuals  = "rbxassetid://6034560416", -- Eye / Vision
    Webhook  = "rbxassetid://6034344541", -- Link / Webhook
    Settings = "rbxassetid://6031280882", -- Gear / Cog
    Chevron  = "rbxassetid://6031091004", -- Down Arrow
    HideMenu = "rbxassetid://6031094678", -- Collapse/Hide icon
}

--[[ State Management ]]--
local State = {
    AutoFarm = false,
    FarmSpeed = 25,
    KillAura = false,
    AutoShootMurderer = false,
    AutoGrabGun = false,
    ESP_Players = false,
    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false,
    Noclip = false,
    SelectedTarget = "",
    Spectating = false,
    WebhookURL = "",
}

local Connections = {}
local function AddConnection(name, conn)
    if Connections[name] then Connections[name]:Disconnect() end
    Connections[name] = conn
end

--[[ Helper UI Functions ]]--
local function ApplyCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function ApplyStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or CONFIG.BORDER_COLOR
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

--[[ Clean Existing UI ]]--
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("MM2_Rebel_UI") then
    PlayerGui.MM2_Rebel_UI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Rebel_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = PlayerGui

--[[ Floating Square Toggle Button (Petit Carré pour Cacher/Afficher le Menu) ]]--
local MiniToggleSquare = Instance.new("Frame")
MiniToggleSquare.Name = "MiniToggleSquare"
MiniToggleSquare.Size = CONFIG.MINI_MODE_SIZE
MiniToggleSquare.Position = UDim2.new(0, 18, 0, 18)
MiniToggleSquare.BackgroundColor3 = CONFIG.MINI_BG
MiniToggleSquare.BorderSizePixel = 0
MiniToggleSquare.ZIndex = 10000
MiniToggleSquare.Visible = false
MiniToggleSquare.Parent = ScreenGui
ApplyCorner(MiniToggleSquare, 10)
ApplyStroke(MiniToggleSquare, CONFIG.ACCENT_COLOR, 1.5, 0.2)

local MiniBtn = Instance.new("TextButton")
MiniBtn.Size = UDim2.new(1, 0, 1, 0)
MiniBtn.BackgroundTransparency = 1
MiniBtn.Text = ""
MiniBtn.Parent = MiniToggleSquare

local MiniIcon = Instance.new("ImageLabel")
MiniIcon.Size = UDim2.new(0, 22, 0, 22)
MiniIcon.Position = UDim2.new(0.5, -11, 0.5, -11)
MiniIcon.BackgroundTransparency = 1
MiniIcon.Image = ICONS.Combat
MiniIcon.ImageColor3 = CONFIG.ACCENT_COLOR
MiniIcon.Parent = MiniToggleSquare

--[[ Main Window ]]--
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = CONFIG.FULL_MODE_SIZE
MainContainer.Position = UDim2.new(0.5, -CONFIG.FULL_MODE_SIZE.X.Offset / 2, 0.5, -CONFIG.FULL_MODE_SIZE.Y.Offset / 2)
MainContainer.BackgroundColor3 = CONFIG.MAIN_BG
MainContainer.BorderSizePixel = 0
MainContainer.ClipsDescendants = false
MainContainer.Parent = ScreenGui
ApplyCorner(MainContainer, 12)
ApplyStroke(MainContainer, CONFIG.BORDER_COLOR, 1.5, 0.3)

-- Header Bar
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 44)
Header.BackgroundColor3 = CONFIG.SIDEBAR_BG
Header.BorderSizePixel = 0
Header.Parent = MainContainer
ApplyCorner(Header, 12)

local HeaderBottomFix = Instance.new("Frame")
HeaderBottomFix.Size = UDim2.new(1, 0, 0, 10)
HeaderBottomFix.Position = UDim2.new(0, 0, 1, -10)
HeaderBottomFix.BackgroundColor3 = CONFIG.SIDEBAR_BG
HeaderBottomFix.BorderSizePixel = 0
HeaderBottomFix.Parent = Header

local HeaderDivider = Instance.new("Frame")
HeaderDivider.Size = UDim2.new(1, 0, 0, 1)
HeaderDivider.Position = UDim2.new(0, 0, 1, 0)
HeaderDivider.BackgroundColor3 = CONFIG.BORDER_COLOR
HeaderDivider.BorderSizePixel = 0
HeaderDivider.Parent = Header

-- Left Collapse/Hide Button (Square in Header)
local HideMenuSquare = Instance.new("TextButton")
HideMenuSquare.Name = "HideMenuSquare"
HideMenuSquare.Size = UDim2.new(0, 28, 0, 28)
HideMenuSquare.Position = UDim2.new(0, 10, 0.5, -14)
HideMenuSquare.BackgroundColor3 = CONFIG.CARD_BG
HideMenuSquare.Text = ""
HideMenuSquare.Parent = Header
ApplyCorner(HideMenuSquare, 6)
ApplyStroke(HideMenuSquare, CONFIG.BORDER_COLOR, 1, 0.5)

local HideMenuIcon = Instance.new("ImageLabel")
HideMenuIcon.Size = UDim2.new(0, 16, 0, 16)
HideMenuIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
HideMenuIcon.BackgroundTransparency = 1
HideMenuIcon.Image = ICONS.Combat
HideMenuIcon.ImageColor3 = CONFIG.ACCENT_COLOR
HideMenuIcon.Parent = HideMenuSquare

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0, 46, 0, 0)
TitleLabel.Text = CONFIG.UI_NAME
TitleLabel.TextColor3 = CONFIG.TEXT_COLOR
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.BackgroundTransparency = 1
TitleLabel.Parent = Header

-- Top Right Controls (Minimize & Close)
local ControlsFrame = Instance.new("Frame")
ControlsFrame.Size = UDim2.new(0, 80, 1, 0)
ControlsFrame.Position = UDim2.new(1, -85, 0, 0)
ControlsFrame.BackgroundTransparency = 1
ControlsFrame.Parent = Header

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.new(0, 28, 0, 28)
MinButton.Position = UDim2.new(0, 8, 0.5, -14)
MinButton.BackgroundColor3 = Color3.fromRGB(35, 40, 58)
MinButton.Text = "-"
MinButton.TextColor3 = CONFIG.TEXT_COLOR
MinButton.TextSize = 18
MinButton.Font = Enum.Font.GothamBold
MinButton.Parent = ControlsFrame
ApplyCorner(MinButton, 6)

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(0, 44, 0.5, -14)
CloseButton.BackgroundColor3 = Color3.fromRGB(45, 30, 40)
CloseButton.Text = "X"
CloseButton.TextColor3 = CONFIG.CLOSE_RED
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = ControlsFrame
ApplyCorner(CloseButton, 6)

-- Menu Toggle Visibility Function
local isUIOpen = true
local function toggleUI()
    isUIOpen = not isUIOpen
    local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

    if isUIOpen then
        MainContainer.Visible = true
        MainContainer.Size = UDim2.new(0, 0, 0, 0)
        MainContainer.Position = MiniToggleSquare.Position
        
        TweenService:Create(MainContainer, tweenInfo, {
            Size = CONFIG.FULL_MODE_SIZE,
            Position = UDim2.new(0.5, -CONFIG.FULL_MODE_SIZE.X.Offset / 2, 0.5, -CONFIG.FULL_MODE_SIZE.Y.Offset / 2)
        }):Play()

        TweenService:Create(MiniToggleSquare, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.delay(0.35, function() MiniToggleSquare.Visible = false end)
    else
        TweenService:Create(MainContainer, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = MiniToggleSquare.Position
        }):Play()

        MiniToggleSquare.Visible = true
        MiniToggleSquare.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MiniToggleSquare, tweenInfo, {Size = CONFIG.MINI_MODE_SIZE}):Play()
        task.delay(0.35, function() MainContainer.Visible = false end)
    end
end

MinButton.MouseButton1Click:Connect(toggleUI)
HideMenuSquare.MouseButton1Click:Connect(toggleUI)
MiniBtn.MouseButton1Click:Connect(toggleUI)
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    for _, conn in pairs(Connections) do conn:Disconnect() end
end)

--[[ Dragging Support ]]--
local function makeDraggable(frame, handle)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(MainContainer, Header)
makeDraggable(MiniToggleSquare, MiniToggleSquare)

--[[ Sidebar Container ]]--
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 175, 1, -45)
Sidebar.Position = UDim2.new(0, 0, 0, 45)
Sidebar.BackgroundColor3 = CONFIG.SIDEBAR_BG
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainContainer

local SidebarDivider = Instance.new("Frame")
SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
SidebarDivider.Position = UDim2.new(1, -1, 0, 0)
SidebarDivider.BackgroundColor3 = CONFIG.BORDER_COLOR
SidebarDivider.BorderSizePixel = 0
SidebarDivider.Parent = Sidebar

-- Tab List Scrolling Container
local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Name = "TabScroll"
TabScroll.Size = UDim2.new(1, 0, 1, -65) -- Leave space for player profile at bottom
TabScroll.BackgroundTransparency = 1
TabScroll.BorderSizePixel = 0
TabScroll.ScrollBarThickness = 2
TabScroll.ScrollBarImageColor3 = CONFIG.ACCENT_COLOR
TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TabScroll.Parent = Sidebar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Vertical
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabScroll

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 8)
TabPadding.PaddingLeft = UDim.new(0, 8)
TabPadding.PaddingRight = UDim.new(0, 8)
TabPadding.Parent = TabScroll

--[[ Player Profile Box at the Bottom of Sidebar (Image 3 Requirement) ]]--
local ProfileFrame = Instance.new("Frame")
ProfileFrame.Name = "ProfileFrame"
ProfileFrame.Size = UDim2.new(1, -16, 0, 52)
ProfileFrame.Position = UDim2.new(0, 8, 1, -58)
ProfileFrame.BackgroundColor3 = CONFIG.CARD_BG
ProfileFrame.BorderSizePixel = 0
ProfileFrame.Parent = Sidebar
ApplyCorner(ProfileFrame, 8)
ApplyStroke(ProfileFrame, CONFIG.BORDER_COLOR, 1, 0.6)

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Name = "AvatarImage"
AvatarImage.Size = UDim2.new(0, 36, 0, 36)
AvatarImage.Position = UDim2.new(0, 8, 0.5, -18)
AvatarImage.BackgroundColor3 = Color3.fromRGB(15, 17, 26)
AvatarImage.Parent = ProfileFrame
ApplyCorner(AvatarImage, 18)

task.spawn(function()
    local content, isReady = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    if isReady then AvatarImage.Image = content end
end)

local DisplayNameLabel = Instance.new("TextLabel")
DisplayNameLabel.Name = "DisplayNameLabel"
DisplayNameLabel.Size = UDim2.new(1, -54, 0, 18)
DisplayNameLabel.Position = UDim2.new(0, 50, 0, 8)
DisplayNameLabel.Text = LocalPlayer.DisplayName
DisplayNameLabel.TextColor3 = CONFIG.TEXT_COLOR
DisplayNameLabel.TextSize = 12
DisplayNameLabel.Font = Enum.Font.GothamBold
DisplayNameLabel.TextXAlignment = Enum.TextXAlignment.Left
DisplayNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
DisplayNameLabel.BackgroundTransparency = 1
DisplayNameLabel.Parent = ProfileFrame

local UsernameLabel = Instance.new("TextLabel")
UsernameLabel.Name = "UsernameLabel"
UsernameLabel.Size = UDim2.new(1, -54, 0, 14)
UsernameLabel.Position = UDim2.new(0, 50, 0, 26)
UsernameLabel.Text = "@" .. LocalPlayer.Name
UsernameLabel.TextColor3 = CONFIG.SUBTEXT_COLOR
UsernameLabel.TextSize = 10
UsernameLabel.Font = Enum.Font.Gotham
UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
UsernameLabel.TextTruncate = Enum.TextTruncate.AtEnd
UsernameLabel.BackgroundTransparency = 1
UsernameLabel.Parent = ProfileFrame

--[[ Content Area ]]--
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -175, 1, -45)
ContentArea.Position = UDim2.new(0, 175, 0, 45)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = true
ContentArea.Parent = MainContainer

--[[ Tab Creation System ]]--
local Tabs = {}
local CurrentTab = nil

local function createTab(name, iconId)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name .. "TabBtn"
    tabBtn.Size = UDim2.new(1, 0, 0, 36)
    tabBtn.BackgroundColor3 = CONFIG.SIDEBAR_BG
    tabBtn.Text = ""
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = TabScroll
    ApplyCorner(tabBtn, 8)

    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 18, 0, 18)
    icon.Position = UDim2.new(0, 10, 0.5, -9)
    icon.BackgroundTransparency = 1
    icon.Image = iconId or ICONS.Combat
    icon.ImageColor3 = CONFIG.SUBTEXT_COLOR
    icon.Parent = tabBtn

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -38, 1, 0)
    label.Position = UDim2.new(0, 36, 0, 0)
    label.Text = name
    label.TextColor3 = CONFIG.SUBTEXT_COLOR
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = tabBtn

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = name .. "Content"
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.Visible = false
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = CONFIG.ACCENT_COLOR
    scrollFrame.ScrollBarImageTransparency = 0.2
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
    scrollFrame.Parent = ContentArea

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.Parent = scrollFrame

    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 12)
    contentPadding.PaddingBottom = UDim.new(0, 12)
    contentPadding.PaddingLeft = UDim.new(0, 14)
    contentPadding.PaddingRight = UDim.new(0, 14)
    contentPadding.Parent = scrollFrame

    tabBtn.MouseButton1Click:Connect(function()
        if CurrentTab and CurrentTab.Button ~= tabBtn then
            TweenService:Create(CurrentTab.Button, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.SIDEBAR_BG}):Play()
            TweenService:Create(CurrentTab.Button.Icon, TweenInfo.new(0.2), {ImageColor3 = CONFIG.SUBTEXT_COLOR}):Play()
            TweenService:Create(CurrentTab.Button.Label, TweenInfo.new(0.2), {TextColor3 = CONFIG.SUBTEXT_COLOR}):Play()
            CurrentTab.Content.Visible = false

            CurrentTab = {Button = tabBtn, Content = scrollFrame}
            TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.CARD_BG}):Play()
            TweenService:Create(icon, TweenInfo.new(0.2), {ImageColor3 = CONFIG.ACCENT_COLOR}):Play()
            TweenService:Create(label, TweenInfo.new(0.2), {TextColor3 = CONFIG.TEXT_COLOR}):Play()
            scrollFrame.Visible = true
        end
    end)

    Tabs[name] = {Button = tabBtn, Content = scrollFrame}

    if not CurrentTab then
        CurrentTab = {Button = tabBtn, Content = scrollFrame}
        tabBtn.BackgroundColor3 = CONFIG.CARD_BG
        icon.ImageColor3 = CONFIG.ACCENT_COLOR
        label.TextColor3 = CONFIG.TEXT_COLOR
        scrollFrame.Visible = true
    end

    return scrollFrame
end

--[[ Component Construction Helpers ]]--
local function createToggle(parent, title, desc, default, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 48)
    card.BackgroundColor3 = CONFIG.CARD_BG
    card.BorderSizePixel = 0
    card.Parent = parent
    ApplyCorner(card, 8)
    ApplyStroke(card, CONFIG.BORDER_COLOR, 1, 0.6)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -70, 0, 20)
    titleLabel.Position = UDim2.new(0, 12, 0, desc and 6 or 14)
    titleLabel.Text = title
    titleLabel.TextColor3 = CONFIG.TEXT_COLOR
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = card

    if desc then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -70, 0, 16)
        descLabel.Position = UDim2.new(0, 12, 0, 26)
        descLabel.Text = desc
        descLabel.TextColor3 = CONFIG.SUBTEXT_COLOR
        descLabel.TextSize = 11
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.BackgroundTransparency = 1
        descLabel.Parent = card
    end

    local toggleSwitch = Instance.new("TextButton")
    toggleSwitch.Size = UDim2.new(0, 42, 0, 22)
    toggleSwitch.Position = UDim2.new(1, -54, 0.5, -11)
    toggleSwitch.BackgroundColor3 = default and CONFIG.ACCENT_COLOR or Color3.fromRGB(45, 50, 68)
    toggleSwitch.Text = ""
    toggleSwitch.AutoButtonColor = false
    toggleSwitch.Parent = card
    ApplyCorner(toggleSwitch, 11)

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    indicator.BorderSizePixel = 0
    indicator.Parent = toggleSwitch
    ApplyCorner(indicator, 8)

    local isOn = default or false

    local function updateState()
        local targetPos = isOn and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        local targetColor = isOn and CONFIG.ACCENT_COLOR or Color3.fromRGB(45, 50, 68)
        TweenService:Create(indicator, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(toggleSwitch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        task.spawn(callback, isOn)
    end

    toggleSwitch.MouseButton1Click:Connect(function()
        isOn = not isOn
        updateState()
    end)

    return card
end

local function createSlider(parent, title, min, max, default, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 56)
    card.BackgroundColor3 = CONFIG.CARD_BG
    card.BorderSizePixel = 0
    card.Parent = parent
    ApplyCorner(card, 8)
    ApplyStroke(card, CONFIG.BORDER_COLOR, 1, 0.6)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 0, 20)
    titleLabel.Position = UDim2.new(0, 12, 0, 8)
    titleLabel.Text = title
    titleLabel.TextColor3 = CONFIG.TEXT_COLOR
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = card

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -62, 0, 8)
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = CONFIG.ACCENT_COLOR
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.BackgroundTransparency = 1
    valueLabel.Parent = card

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -24, 0, 6)
    sliderBar.Position = UDim2.new(0, 12, 0, 36)
    sliderBar.BackgroundColor3 = Color3.fromRGB(45, 50, 68)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = card
    ApplyCorner(sliderBar, 3)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = CONFIG.ACCENT_COLOR
    fill.BorderSizePixel = 0
    fill.Parent = sliderBar
    ApplyCorner(fill, 3)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = sliderBar
    ApplyCorner(knob, 7)

    local dragging = false
    local function updateValue(input)
        local relX = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * relX)
        fill.Size = UDim2.new(relX, 0, 1, 0)
        knob.Position = UDim2.new(relX, -7, 0.5, -7)
        valueLabel.Text = tostring(val)
        task.spawn(callback, val)
    end

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateValue(input)
        end
    end)

    return card
end

local function createButton(parent, text, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 42)
    card.BackgroundColor3 = CONFIG.CARD_BG
    card.BorderSizePixel = 0
    card.Parent = parent
    ApplyCorner(card, 8)
    ApplyStroke(card, CONFIG.BORDER_COLOR, 1, 0.6)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = CONFIG.TEXT_COLOR
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = card

    btn.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.ACCENT_COLOR}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.CARD_BG}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        task.spawn(callback)
    end)

    return card
end

local function createPlayerDropdown(parent, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 48)
    card.BackgroundColor3 = CONFIG.CARD_BG
    card.BorderSizePixel = 0
    card.ClipsDescendants = false
    card.Parent = parent
    ApplyCorner(card, 8)
    ApplyStroke(card, CONFIG.BORDER_COLOR, 1, 0.6)

    local headerBtn = Instance.new("TextButton")
    headerBtn.Size = UDim2.new(1, 0, 0, 48)
    headerBtn.BackgroundTransparency = 1
    headerBtn.Text = ""
    headerBtn.Parent = card

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -70, 0, 18)
    titleLabel.Position = UDim2.new(0, 12, 0, 6)
    titleLabel.Text = "Cible Joueur (Auto-Update)"
    titleLabel.TextColor3 = CONFIG.TEXT_COLOR
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = headerBtn

    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Size = UDim2.new(1, -70, 0, 16)
    selectedLabel.Position = UDim2.new(0, 12, 0, 24)
    selectedLabel.Text = "Aucun joueur sélectionné"
    selectedLabel.TextColor3 = CONFIG.ACCENT_COLOR
    selectedLabel.TextSize = 11
    selectedLabel.Font = Enum.Font.Gotham
    selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Parent = headerBtn

    local arrow = Instance.new("ImageLabel")
    arrow.Size = UDim2.new(0, 16, 0, 16)
    arrow.Position = UDim2.new(1, -30, 0.5, -8)
    arrow.BackgroundTransparency = 1
    arrow.Image = ICONS.Chevron
    arrow.ImageColor3 = CONFIG.SUBTEXT_COLOR
    arrow.Parent = headerBtn

    local optionsFrame = Instance.new("Frame")
    optionsFrame.Size = UDim2.new(1, 0, 0, 0)
    optionsFrame.Position = UDim2.new(0, 0, 1, 4)
    optionsFrame.BackgroundColor3 = CONFIG.SIDEBAR_BG
    optionsFrame.Visible = false
    optionsFrame.ZIndex = 100
    optionsFrame.Parent = card
    ApplyCorner(optionsFrame, 8)
    ApplyStroke(optionsFrame, CONFIG.ACCENT_COLOR, 1, 0.4)

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 4)
    listLayout.Parent = optionsFrame

    local listPadding = Instance.new("UIPadding")
    listPadding.PaddingTop = UDim.new(0, 6)
    listPadding.PaddingBottom = UDim.new(0, 6)
    listPadding.PaddingLeft = UDim.new(0, 6)
    listPadding.PaddingRight = UDim.new(0, 6)
    listPadding.Parent = optionsFrame

    local isOpen = false
    local function refreshPlayers()
        for _, child in ipairs(optionsFrame:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        local count = 0
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                count = count + 1
                local pBtn = Instance.new("TextButton")
                pBtn.Size = UDim2.new(1, 0, 0, 30)
                pBtn.BackgroundColor3 = CONFIG.CARD_BG
                pBtn.Text = "  " .. plr.DisplayName .. " (@" .. plr.Name .. ")"
                pBtn.TextColor3 = CONFIG.TEXT_COLOR
                pBtn.TextSize = 12
                pBtn.Font = Enum.Font.GothamMedium
                pBtn.TextXAlignment = Enum.TextXAlignment.Left
                pBtn.ZIndex = 101
                pBtn.Parent = optionsFrame
                ApplyCorner(pBtn, 6)

                pBtn.MouseButton1Click:Connect(function()
                    selectedLabel.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
                    State.SelectedTarget = plr.Name
                    isOpen = false
                    optionsFrame.Visible = false
                    arrow.Rotation = 0
                    task.spawn(callback, plr)
                end)
            end
        end

        if isOpen then
            optionsFrame.Size = UDim2.new(1, 0, 0, math.clamp(count * 34 + 12, 40, 160))
        end
    end

    headerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        optionsFrame.Visible = isOpen
        arrow.Rotation = isOpen and 180 or 0
        if isOpen then refreshPlayers() end
    end)

    Players.PlayerAdded:Connect(function() if isOpen then refreshPlayers() end end)
    Players.PlayerRemoving:Connect(function(plr)
        if State.SelectedTarget == plr.Name then
            State.SelectedTarget = ""
            selectedLabel.Text = "Aucun joueur sélectionné"
        end
        if isOpen then refreshPlayers() end
    end)

    return card
end

--[[ Build All Tabs ]]--
local CombatTab  = createTab("Combat", ICONS.Combat)
local FarmingTab = createTab("Farming", ICONS.Farming)
local VisualsTab = createTab("Visuals", ICONS.Visuals)
local JoueurTab  = createTab("Joueur", ICONS.Joueur)
local TargetTab  = createTab("Target", ICONS.Target)
local WebhookTab = createTab("Webhook", ICONS.Webhook)
local MiscTab    = createTab("Misc", ICONS.Misc)
local SettingsTab= createTab("Settings", ICONS.Settings)

--[[ Features & Game Functions ]]--
local function GetRoles()
    local murderer, sheriff
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            if plr.Character:FindFirstChild("Knife") or (plr:FindFirstChild("Backpack") and plr.Backpack:FindFirstChild("Knife")) then
                murderer = plr
            elseif plr.Character:FindFirstChild("Gun") or (plr:FindFirstChild("Backpack") and plr.Backpack:FindFirstChild("Gun")) then
                sheriff = plr
            end
        end
    end
    return murderer, sheriff
end

-- Combat
createToggle(CombatTab, "Auto Kill All (Murderer)", "Élimine instantanément tous les innocents", false, function(v)
    State.KillAura = v
    if v then
        AddConnection("KillAuraLoop", RunService.Heartbeat:Connect(function()
            if not State.KillAura then return end
            local char = LocalPlayer.Character
            local knife = char and (char:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife"))
            if knife and char:FindFirstChild("HumanoidRootPart") then
                if knife.Parent ~= char then knife.Parent = char end
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
                        knife:Activate()
                    end
                end
            end
        end))
    end
end)

createToggle(CombatTab, "Auto Shoot Murderer (Sheriff)", "Vise et tire automatiquement sur le tueur", false, function(v)
    State.AutoShootMurderer = v
    if v then
        AddConnection("ShootMurdLoop", RunService.Heartbeat:Connect(function()
            if not State.AutoShootMurderer then return end
            local murd = GetRoles()
            local char = LocalPlayer.Character
            local gun = char and (char:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun"))
            if murd and murd.Character and gun and char:FindFirstChild("HumanoidRootPart") then
                if gun.Parent ~= char then gun.Parent = char end
                gun:Activate()
            end
        end))
    end
end)

createToggle(CombatTab, "Auto Grab Dropped Gun", "Ramasse le pistolet tombé au sol dès qu'il pop", false, function(v)
    State.AutoGrabGun = v
    if v then
        AddConnection("GrabGunLoop", RunService.Heartbeat:Connect(function()
            if not State.AutoGrabGun then return end
            local gunDrop = Workspace:FindFirstChild("GunDrop")
            if gunDrop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = gunDrop.CFrame
            end
        end))
    end
end)

-- Farming
createToggle(FarmingTab, "Auto Farm Coins", "Ramasse automatiquement toutes les pièces", false, function(v)
    State.AutoFarm = v
    if v then
        AddConnection("FarmLoop", RunService.Heartbeat:Connect(function()
            if not State.AutoFarm then return end
            local coinContainer = Workspace:FindFirstChild("Normal") or Workspace:FindFirstChild("CoinContainer")
            if coinContainer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                for _, coin in ipairs(coinContainer:GetChildren()) do
                    if coin:IsA("BasePart") and coin.Name == "Coin" then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = coin.CFrame
                        task.wait(1 / State.FarmSpeed)
                        break
                    end
                end
            end
        end))
    end
end)
createSlider(FarmingTab, "Vitesse de Farm", 5, 50, 25, function(v) State.FarmSpeed = v end)

-- Visuals
local Highlights = {}
createToggle(VisualsTab, "ESP Joueurs (Wallhack Roles)", "Affiche le tueur en rouge et le sheriff en bleu", false, function(v)
    State.ESP_Players = v
    if not v then
        for _, hl in pairs(Highlights) do hl:Destroy() end
        Highlights = {}
    else
        AddConnection("ESPLoop", RunService.Heartbeat:Connect(function()
            if not State.ESP_Players then return end
            local murderer, sheriff = GetRoles()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local hl = Highlights[p] or Instance.new("Highlight")
                    hl.Adornee = p.Character
                    hl.Parent = ScreenGui
                    if p == murderer then hl.FillColor = Color3.fromRGB(255, 40, 40)
                    elseif p == sheriff then hl.FillColor = Color3.fromRGB(0, 140, 255)
                    else hl.FillColor = Color3.fromRGB(40, 255, 120) end
                    Highlights[p] = hl
                end
            end
        end))
    end
end)

-- Joueur
createSlider(JoueurTab, "Vitesse (WalkSpeed)", 16, 120, 16, function(v)
    State.WalkSpeed = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)
createSlider(JoueurTab, "Hauteur Saut (JumpPower)", 50, 200, 50, function(v)
    State.JumpPower = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = v
    end
end)
createToggle(JoueurTab, "Infinite Jump", "Sautez indéfiniment", false, function(v)
    State.InfiniteJump = v
    if v then
        AddConnection("InfJump", UserInputService.JumpRequest:Connect(function()
            if State.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end))
    end
end)
createToggle(JoueurTab, "Noclip", "Traverser les murs", false, function(v)
    State.Noclip = v
    if v then
        AddConnection("NoclipLoop", RunService.Stepped:Connect(function()
            if State.Noclip and LocalPlayer.Character then
                for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
        end))
    end
end)

-- Target
createPlayerDropdown(TargetTab, function(plr) print("Selected target:", plr.Name) end)
createButton(TargetTab, "Téléporter sur la Cible", function()
    if State.SelectedTarget ~= "" then
        local p = Players:FindFirstChild(State.SelectedTarget)
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
        end
    end
end)
createToggle(TargetTab, "Spectate Cible", "Observer la cible", false, function(v)
    State.Spectating = v
    if v and State.SelectedTarget ~= "" then
        local p = Players:FindFirstChild(State.SelectedTarget)
        if p and p.Character and p.Character:FindFirstChild("Humanoid") then
            Workspace.CurrentCamera.CameraSubject = p.Character.Humanoid
        end
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
        end
    end
end)
createButton(TargetTab, "Fling Target (Expulser)", function()
    if State.SelectedTarget ~= "" then
        local p = Players:FindFirstChild(State.SelectedTarget)
        if p and p.Character and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local oldPos = hrp.CFrame
            for i = 1, 25 do
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    hrp.CFrame = p.Character.HumanoidRootPart.CFrame
                    hrp.Velocity = Vector3.new(9999, 9999, 9999)
                    task.wait(0.02)
                end
            end
            hrp.CFrame = oldPos
            hrp.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- Misc
createButton(MiscTab, "Equipper Toutes les Armes", function()
    if LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Character then
        for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if item:IsA("Tool") then item.Parent = LocalPlayer.Character end
        end
    end
end)
createButton(MiscTab, "Jeter l'Arme Tenue (Drop Weapon)", function()
    if LocalPlayer.Character then
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then tool.Parent = Workspace end
    end
end)

-- Settings
createButton(SettingsTab, "Réinitialiser Position UI", function()
    MainContainer.Position = UDim2.new(0.5, -CONFIG.FULL_MODE_SIZE.X.Offset / 2, 0.5, -CONFIG.FULL_MODE_SIZE.Y.Offset / 2)
end)
createButton(SettingsTab, "Fermer & Décharger", function()
    ScreenGui:Destroy()
    for _, conn in pairs(Connections) do conn:Disconnect() end
end)

print("MM2 REBEL EDITION V3 LOADED SUCCESSFULLY!")
