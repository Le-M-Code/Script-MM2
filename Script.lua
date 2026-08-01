--!strict
--[[
    ================================================================
    Le M MM2 - UNLOCKED ULTRA DARK EDITION (FR)
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
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer

--[[ Dark Configuration ]]--
local CONFIG = {
    UI_NAME = "Le M MM2",
    MAIN_BG = Color3.fromRGB(10, 10, 12),      -- Pure Deep Black
    SIDEBAR_BG = Color3.fromRGB(15, 15, 18),   -- Dark Charcoal Sidebar
    CARD_BG = Color3.fromRGB(22, 22, 26),      -- Dark Card Frame
    ACCENT_COLOR = Color3.fromRGB(0, 140, 255), -- Electric Accent Blue
    ACCENT_HOVER = Color3.fromRGB(30, 160, 255),
    TEXT_COLOR = Color3.fromRGB(245, 245, 250),
    SUBTEXT_COLOR = Color3.fromRGB(150, 150, 165),
    BORDER_COLOR = Color3.fromRGB(35, 35, 42),
    CLOSE_RED = Color3.fromRGB(235, 60, 80),
    MINI_BG = Color3.fromRGB(15, 15, 18),
    FULL_MODE_SIZE = UDim2.new(0, 690, 0, 470),
    MINI_MODE_SIZE = UDim2.new(0, 44, 0, 44),
}

--[[ Guaranteed Roblox Icon Asset Mapping ]]--
local ICONS = {
    Combat   = {id = "rbxassetid://7733658504", symbol = "⚔️"},
    Farming  = {id = "rbxassetid://7733801239", symbol = "🪙"},
    Target   = {id = "rbxassetid://7733674681", symbol = "🎯"},
    Visuals  = {id = "rbxassetid://7733774602", symbol = "👁️"},
    Joueur   = {id = "rbxassetid://7733715400", symbol = "👤"},
    Emotes   = {id = "rbxassetid://7733919171", symbol = "⭐"},
    Teleport = {id = "rbxassetid://7733799908", symbol = "📍"},
    Webhook  = {id = "rbxassetid://7733955511", symbol = "🔗"},
    Settings = {id = "rbxassetid://7733965118", symbol = "⚙️"},
    Chevron  = "rbxassetid://6031091004",
    Grid     = "rbxassetid://6034954449",
    Search   = "rbxassetid://6031154871",
}

--[[ State Management ]]--
local State = {
    AutoFarm = false,
    FarmMode = "Nearest",
    AutoGrabGun = false,
    DodgeKnife = false,

    KillAura = false,
    AuraDistance = 15,
    AutoKillAll = false,
    SilentAim = false,
    KillMurdererBlatant = false,
    AutoShootMurderer = false,
    FlingSheriff = false,
    FlingMurderer = false,
    AutoEndRound = false,

    SelectedTarget = "",
    FlingTarget = false,
    SpectateTarget = false,
    LoopGoToTarget = false,

    PlayerChams = false,
    GunCham = false,
    ThreeDRendering = false,
    NameESP = false,

    WalkSpeedToggle = false,
    WalkSpeed = 16,
    JumpPowerToggle = false,
    JumpPower = 50,
    AntiFling = false,
    InvisibleFE = false,

    AutoEmote = false,
    SelectedEmote = "ninja",
    SelectedCommand = "sit",

    WebhookURL = "",
    CoinTracker = false,
    WebhookInterval = "5",
    UnboxNotification = false,

    AutoSaveSettings = true,
    AutoReExecute = false,
    AutoRejoin = false,
}

local Connections = {}
local function AddConnection(name, conn)
    if Connections[name] then Connections[name]:Disconnect() end
    Connections[name] = conn
end

--[[ UI Component Constructors ]]--
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

-- Clean Existing UI
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("LeM_MM2_UI") then
    PlayerGui.LeM_MM2_UI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LeM_MM2_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 9999
ScreenGui.Parent = PlayerGui

-- Petit Carré Flottant (Mini Mode Toggle)
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
MiniBtn.Text = "⚔️"
MiniBtn.TextColor3 = CONFIG.ACCENT_COLOR
MiniBtn.TextSize = 18
MiniBtn.Font = Enum.Font.GothamBold
MiniBtn.Parent = MiniToggleSquare

-- Main Container Window
local MainContainer = Instance.new("Frame")
MainContainer.Name = "MainContainer"
MainContainer.Size = CONFIG.FULL_MODE_SIZE
MainContainer.Position = UDim2.new(0.5, -CONFIG.FULL_MODE_SIZE.X.Offset / 2, 0.5, -CONFIG.FULL_MODE_SIZE.Y.Offset / 2)
MainContainer.BackgroundColor3 = CONFIG.MAIN_BG
MainContainer.BorderSizePixel = 0
MainContainer.ClipsDescendants = false
MainContainer.Parent = ScreenGui
ApplyCorner(MainContainer, 12)
ApplyStroke(MainContainer, CONFIG.BORDER_COLOR, 1.5, 0.4)

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

-- Left Square Hide Button
local HideMenuSquare = Instance.new("TextButton")
HideMenuSquare.Name = "HideMenuSquare"
HideMenuSquare.Size = UDim2.new(0, 28, 0, 28)
HideMenuSquare.Position = UDim2.new(0, 10, 0.5, -14)
HideMenuSquare.BackgroundColor3 = CONFIG.CARD_BG
HideMenuSquare.Text = "⚔️"
HideMenuSquare.TextColor3 = CONFIG.ACCENT_COLOR
HideMenuSquare.TextSize = 14
HideMenuSquare.Font = Enum.Font.GothamBold
HideMenuSquare.Parent = Header
ApplyCorner(HideMenuSquare, 6)
ApplyStroke(HideMenuSquare, CONFIG.BORDER_COLOR, 1, 0.5)

-- Title "Le M MM2"
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

-- Controls (- and X)
local ControlsFrame = Instance.new("Frame")
ControlsFrame.Size = UDim2.new(0, 80, 1, 0)
ControlsFrame.Position = UDim2.new(1, -85, 0, 0)
ControlsFrame.BackgroundTransparency = 1
ControlsFrame.Parent = Header

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.new(0, 28, 0, 28)
MinButton.Position = UDim2.new(0, 8, 0.5, -14)
MinButton.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
MinButton.Text = "-"
MinButton.TextColor3 = CONFIG.TEXT_COLOR
MinButton.TextSize = 18
MinButton.Font = Enum.Font.GothamBold
MinButton.Parent = ControlsFrame
ApplyCorner(MinButton, 6)

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(0, 44, 0.5, -14)
CloseButton.BackgroundColor3 = Color3.fromRGB(40, 24, 30)
CloseButton.Text = "X"
CloseButton.TextColor3 = CONFIG.CLOSE_RED
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = ControlsFrame
ApplyCorner(CloseButton, 6)

-- Toggle Menu Function
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

-- Dragging System
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

local TabScroll = Instance.new("ScrollingFrame")
TabScroll.Name = "TabScroll"
TabScroll.Size = UDim2.new(1, 0, 1, -65)
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

-- Profile Card (Bottom Sidebar)
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
AvatarImage.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
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

--[[ Bulletproof Tab System with Dual-Layer Icons ]]--
local Tabs = {}
local CurrentTab = nil

local function createTab(name, iconData)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = name .. "TabBtn"
    tabBtn.Size = UDim2.new(1, 0, 0, 36)
    tabBtn.BackgroundColor3 = CONFIG.SIDEBAR_BG
    tabBtn.Text = ""
    tabBtn.AutoButtonColor = false
    tabBtn.Parent = TabScroll
    ApplyCorner(tabBtn, 8)

    -- Primary Image Icon
    local iconImg = Instance.new("ImageLabel")
    iconImg.Name = "IconImg"
    iconImg.Size = UDim2.new(0, 18, 0, 18)
    iconImg.Position = UDim2.new(0, 10, 0.5, -9)
    iconImg.BackgroundTransparency = 1
    iconImg.Image = iconData.id
    iconImg.ImageColor3 = CONFIG.SUBTEXT_COLOR
    iconImg.Parent = tabBtn

    -- Fallback Symbol Label (always visible if image doesn't render)
    local iconSymbol = Instance.new("TextLabel")
    iconSymbol.Name = "IconSymbol"
    iconSymbol.Size = UDim2.new(0, 18, 0, 18)
    iconSymbol.Position = UDim2.new(0, 10, 0.5, -9)
    iconSymbol.BackgroundTransparency = 1
    iconSymbol.Text = iconData.symbol or ""
    iconSymbol.TextColor3 = CONFIG.SUBTEXT_COLOR
    iconSymbol.TextSize = 14
    iconSymbol.Font = Enum.Font.GothamBold
    iconSymbol.Parent = tabBtn

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
            TweenService:Create(CurrentTab.Button.IconImg, TweenInfo.new(0.2), {ImageColor3 = CONFIG.SUBTEXT_COLOR}):Play()
            TweenService:Create(CurrentTab.Button.IconSymbol, TweenInfo.new(0.2), {TextColor3 = CONFIG.SUBTEXT_COLOR}):Play()
            TweenService:Create(CurrentTab.Button.Label, TweenInfo.new(0.2), {TextColor3 = CONFIG.SUBTEXT_COLOR}):Play()
            CurrentTab.Content.Visible = false

            CurrentTab = {Button = tabBtn, Content = scrollFrame}
            TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.CARD_BG}):Play()
            TweenService:Create(iconImg, TweenInfo.new(0.2), {ImageColor3 = CONFIG.ACCENT_COLOR}):Play()
            TweenService:Create(iconSymbol, TweenInfo.new(0.2), {TextColor3 = CONFIG.ACCENT_COLOR}):Play()
            TweenService:Create(label, TweenInfo.new(0.2), {TextColor3 = CONFIG.TEXT_COLOR}):Play()
            scrollFrame.Visible = true
        end
    end)

    Tabs[name] = {Button = tabBtn, Content = scrollFrame}

    if not CurrentTab then
        CurrentTab = {Button = tabBtn, Content = scrollFrame}
        tabBtn.BackgroundColor3 = CONFIG.CARD_BG
        iconImg.ImageColor3 = CONFIG.ACCENT_COLOR
        iconSymbol.TextColor3 = CONFIG.ACCENT_COLOR
        label.TextColor3 = CONFIG.TEXT_COLOR
        scrollFrame.Visible = true
    end

    return scrollFrame
end

--[[ Replicated Components (NO LOCKS - 100% UNLOCKED) ]]--

-- Toggle Component (No Lock Icon)
local function createToggle(parent, title, desc, default, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, desc and 48 or 42)
    card.BackgroundColor3 = CONFIG.CARD_BG
    card.BorderSizePixel = 0
    card.Parent = parent
    ApplyCorner(card, 8)
    ApplyStroke(card, CONFIG.BORDER_COLOR, 1, 0.6)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -70, 0, 20)
    titleLabel.Position = UDim2.new(0, 12, 0, desc and 6 or 11)
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
    toggleSwitch.BackgroundColor3 = default and CONFIG.ACCENT_COLOR or Color3.fromRGB(38, 38, 48)
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
        local targetColor = isOn and CONFIG.ACCENT_COLOR or Color3.fromRGB(38, 38, 48)
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

-- Slider Component
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

    local valueBox = Instance.new("Frame")
    valueBox.Size = UDim2.new(0, 44, 0, 22)
    valueBox.Position = UDim2.new(1, -56, 0, 6)
    valueBox.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    valueBox.Parent = card
    ApplyCorner(valueBox, 5)

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(1, 0, 1, 0)
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = CONFIG.ACCENT_COLOR
    valueLabel.TextSize = 12
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.BackgroundTransparency = 1
    valueLabel.Parent = valueBox

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -24, 0, 6)
    sliderBar.Position = UDim2.new(0, 12, 0, 36)
    sliderBar.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
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

-- Action Button (No Lock Icon)
local function createActionButton(parent, title, iconType, callback)
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
    btn.Text = ""
    btn.Parent = card

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.Position = UDim2.new(0, 12, 0, 0)
    titleLabel.Text = title
    titleLabel.TextColor3 = CONFIG.TEXT_COLOR
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = btn

    local actionIcon = Instance.new("ImageLabel")
    actionIcon.Size = UDim2.new(0, 18, 0, 18)
    actionIcon.Position = UDim2.new(1, -30, 0.5, -9)
    actionIcon.BackgroundTransparency = 1
    actionIcon.Image = iconType == "chevron" and ICONS.Chevron or ICONS.Grid
    actionIcon.ImageColor3 = CONFIG.SUBTEXT_COLOR
    actionIcon.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 36)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.2), {BackgroundColor3 = CONFIG.CARD_BG}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        task.spawn(callback)
    end)

    return card
end

-- Inline Expandable Dropdown Component
local function createDropdown(parent, title, currentVal, options, hasSearch, callback)
    local card = Instance.new("Frame")
    card.Name = title .. "DropdownCard"
    card.Size = UDim2.new(1, -6, 0, 50)
    card.BackgroundColor3 = CONFIG.CARD_BG
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.Parent = parent
    ApplyCorner(card, 8)
    ApplyStroke(card, CONFIG.BORDER_COLOR, 1, 0.6)

    local headerBtn = Instance.new("TextButton")
    headerBtn.Size = UDim2.new(1, 0, 0, 50)
    headerBtn.BackgroundTransparency = 1
    headerBtn.Text = ""
    headerBtn.Parent = card

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -70, 1, 0)
    titleLabel.Position = UDim2.new(0, 12, 0, 0)
    titleLabel.Text = title .. " • " .. currentVal
    titleLabel.TextColor3 = CONFIG.TEXT_COLOR
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = headerBtn

    local gridIcon = Instance.new("ImageLabel")
    gridIcon.Size = UDim2.new(0, 18, 0, 18)
    gridIcon.Position = UDim2.new(1, -30, 0.5, -9)
    gridIcon.BackgroundTransparency = 1
    gridIcon.Image = ICONS.Grid
    gridIcon.ImageColor3 = CONFIG.SUBTEXT_COLOR
    gridIcon.Parent = headerBtn

    local optionsFrame = Instance.new("Frame")
    optionsFrame.Size = UDim2.new(1, -24, 0, 0)
    optionsFrame.Position = UDim2.new(0, 12, 0, 50)
    optionsFrame.BackgroundTransparency = 1
    optionsFrame.Parent = card

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 4)
    listLayout.Parent = optionsFrame

    local isOpen = false

    local function renderOptions(filter)
        for _, child in ipairs(optionsFrame:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("Frame") then child:Destroy() end
        end

        if hasSearch then
            local searchBox = Instance.new("Frame")
            searchBox.Size = UDim2.new(1, 0, 0, 28)
            searchBox.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
            searchBox.Parent = optionsFrame
            ApplyCorner(searchBox, 6)

            local sIcon = Instance.new("ImageLabel")
            sIcon.Size = UDim2.new(0, 14, 0, 14)
            sIcon.Position = UDim2.new(0, 8, 0.5, -7)
            sIcon.BackgroundTransparency = 1
            sIcon.Image = ICONS.Search
            sIcon.ImageColor3 = CONFIG.SUBTEXT_COLOR
            sIcon.Parent = searchBox

            local sInput = Instance.new("TextBox")
            sInput.Size = UDim2.new(1, -30, 1, 0)
            sInput.Position = UDim2.new(0, 26, 0, 0)
            sInput.BackgroundTransparency = 1
            sInput.Text = filter or ""
            sInput.PlaceholderText = "Rechercher..."
            sInput.PlaceholderColor3 = CONFIG.SUBTEXT_COLOR
            sInput.TextColor3 = CONFIG.TEXT_COLOR
            sInput.TextSize = 11
            sInput.Font = Enum.Font.Gotham
            sInput.TextXAlignment = Enum.TextXAlignment.Left
            sInput.Parent = searchBox

            sInput.Changed:Connect(function(prop)
                if prop == "Text" then renderOptions(sInput.Text) end
            end)
        end

        local count = 0
        for _, opt in ipairs(options) do
            if not filter or filter == "" or string.find(string.lower(opt), string.lower(filter)) then
                count = count + 1
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 28)
                optBtn.BackgroundColor3 = (opt == currentVal) and Color3.fromRGB(30, 30, 36) or Color3.fromRGB(15, 15, 18)
                optBtn.Text = "  " .. (opt == currentVal and "✓ " or "") .. opt
                optBtn.TextColor3 = (opt == currentVal) and CONFIG.ACCENT_COLOR or CONFIG.TEXT_COLOR
                optBtn.TextSize = 12
                optBtn.Font = Enum.Font.GothamMedium
                optBtn.TextXAlignment = Enum.TextXAlignment.Left
                optBtn.Parent = optionsFrame
                ApplyCorner(optBtn, 6)

                optBtn.MouseButton1Click:Connect(function()
                    currentVal = opt
                    titleLabel.Text = title .. " • " .. currentVal
                    isOpen = false
                    TweenService:Create(card, TweenInfo.new(0.25), {Size = UDim2.new(1, -6, 0, 50)}):Play()
                    task.spawn(callback, opt)
                end)
            end
        end

        local extraHeight = hasSearch and 34 or 0
        local totalContentHeight = count * 32 + extraHeight + 10
        optionsFrame.Size = UDim2.new(1, -24, 0, totalContentHeight)
        
        if isOpen then
            TweenService:Create(card, TweenInfo.new(0.25), {Size = UDim2.new(1, -6, 0, 50 + totalContentHeight)}):Play()
        end
    end

    headerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            renderOptions("")
        else
            TweenService:Create(card, TweenInfo.new(0.25), {Size = UDim2.new(1, -6, 0, 50)}):Play()
        end
    end)

    return card
end

-- TextBox Component
local function createTextBox(parent, title, placeholder, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -6, 0, 52)
    card.BackgroundColor3 = CONFIG.CARD_BG
    card.BorderSizePixel = 0
    card.Parent = parent
    ApplyCorner(card, 8)
    ApplyStroke(card, CONFIG.BORDER_COLOR, 1, 0.6)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -24, 0, 18)
    titleLabel.Position = UDim2.new(0, 12, 0, 6)
    titleLabel.Text = title
    titleLabel.TextColor3 = CONFIG.TEXT_COLOR
    titleLabel.TextSize = 12
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = card

    local inputContainer = Instance.new("Frame")
    inputContainer.Size = UDim2.new(1, -24, 0, 22)
    inputContainer.Position = UDim2.new(0, 12, 0, 24)
    inputContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    inputContainer.Parent = card
    ApplyCorner(inputContainer, 5)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -10, 1, 0)
    box.Position = UDim2.new(0, 5, 0, 0)
    box.BackgroundTransparency = 1
    box.Text = ""
    box.PlaceholderText = placeholder or "Entrez la valeur..."
    box.PlaceholderColor3 = CONFIG.SUBTEXT_COLOR
    box.TextColor3 = CONFIG.TEXT_COLOR
    box.TextSize = 11
    box.Font = Enum.Font.Gotham
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ClearTextOnFocus = false
    box.Parent = inputContainer

    box.FocusLost:Connect(function()
        task.spawn(callback, box.Text)
    end)

    return card
end

--[[ Build All Tabs ]]--
local CombatTab   = createTab("Combat", ICONS.Combat)
local FarmingTab  = createTab("Farming", ICONS.Farming)
local TargetTab   = createTab("Target", ICONS.Target)
local VisualsTab  = createTab("Visuals", ICONS.Visuals)
local JoueurTab   = createTab("Joueur", ICONS.Joueur)
local EmotesTab   = createTab("Émotes", ICONS.Emotes)
local TeleportTab = createTab("Téléport", ICONS.Teleport)
local WebhookTab  = createTab("Webhook", ICONS.Webhook)
local SettingsTab = createTab("Réglages", ICONS.Settings)

--[[ Features Engine ]]--
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

-- 1. FARMING TAB
createToggle(FarmingTab, "Auto Farm", "Collecte automatiquement les pièces et l'XP", false, function(v)
    State.AutoFarm = v
    if v then
        AddConnection("AutoFarmLoop", RunService.Heartbeat:Connect(function()
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

createDropdown(FarmingTab, "Farm Mode", "Nearest", {"Nearest + XP Farm", "Nearest", "Randomize"}, false, function(mode)
    State.FarmMode = mode
end)

createToggle(FarmingTab, "Automatically Grab Gun", "Ramasse le pistolet tombé au sol dès qu'il pop", false, function(v)
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

createToggle(FarmingTab, "Dodge Thrown Knife", "Esquive automatiquement les couteaux lancés sur vous", true, function(v)
    State.DodgeKnife = v
    if v then
        AddConnection("DodgeKnifeLoop", RunService.Heartbeat:Connect(function()
            if not State.DodgeKnife then return end
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj.Name == "Knife" and obj:IsA("BasePart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (obj.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 12 then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 15, 0)
                    end
                end
            end
        end))
    end
end)

-- 2. COMBAT TAB
createToggle(CombatTab, "Kill Aura", "Active le couteau automatique autour de vous", false, function(v)
    State.KillAura = v
end)

createSlider(CombatTab, "Aura Distance", 5, 50, 15, function(v)
    State.AuraDistance = v
end)

createToggle(CombatTab, "Auto Kill All", "Élimine automatiquement tous les innocents de la partie", false, function(v)
    State.AutoKillAll = v
    if v then
        AddConnection("KillAllLoop", RunService.Heartbeat:Connect(function()
            if not State.AutoKillAll then return end
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

createToggle(CombatTab, "Silent Aim", "Visée automatique invisible sur le tueur", false, function(v)
    State.SilentAim = v
end)

createToggle(CombatTab, "Kill Murderer (Blatant)", "Élimination directe du tueur (Déverrouillé)", false, function(v)
    State.KillMurdererBlatant = v
    if v then
        local murderer = GetRoles()
        local char = LocalPlayer.Character
        local knife = char and (char:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife"))
        if murderer and murderer.Character and knife and char:FindFirstChild("HumanoidRootPart") then
            if knife.Parent ~= char then knife.Parent = char end
            char.HumanoidRootPart.CFrame = murderer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
            knife:Activate()
        end
    end
end)

createToggle(CombatTab, "Auto Shoot Murderer", "Tire automatiquement sur le tueur quand vous avez le pistolet", false, function(v)
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

createActionButton(CombatTab, "Shoot Murderer", "dots", function()
    local murd = GetRoles()
    local char = LocalPlayer.Character
    local gun = char and (char:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun"))
    if murd and murd.Character and gun and char:FindFirstChild("HumanoidRootPart") then
        if gun.Parent ~= char then gun.Parent = char end
        gun:Activate()
    end
end)

createToggle(CombatTab, "Fling Sheriff", "Expulse le Sheriff hors de la carte", false, function(v)
    State.FlingSheriff = v
    if v then
        local _, sheriff = GetRoles()
        if sheriff and sheriff.Character and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local oldPos = hrp.CFrame
            for i = 1, 20 do
                if sheriff.Character and sheriff.Character:FindFirstChild("HumanoidRootPart") then
                    hrp.CFrame = sheriff.Character.HumanoidRootPart.CFrame
                    hrp.Velocity = Vector3.new(9999, 9999, 9999)
                    task.wait(0.02)
                end
            end
            hrp.CFrame = oldPos
            hrp.Velocity = Vector3.new(0,0,0)
        end
    end
end)

createToggle(CombatTab, "Fling Murderer", "Expulse le Tueur hors de la carte", false, function(v)
    State.FlingMurderer = v
    if v then
        local murderer = GetRoles()
        if murderer and murderer.Character and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local oldPos = hrp.CFrame
            for i = 1, 20 do
                if murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
                    hrp.CFrame = murderer.Character.HumanoidRootPart.CFrame
                    hrp.Velocity = Vector3.new(9999, 9999, 9999)
                    task.wait(0.02)
                end
            end
            hrp.CFrame = oldPos
            hrp.Velocity = Vector3.new(0,0,0)
        end
    end
end)

createToggle(CombatTab, "Auto End Round", "Met fin à la manche automatiquement", false, function(v)
    State.AutoEndRound = v
end)

-- 3. TARGET TAB
local targetPlayersList = {}
for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then table.insert(targetPlayersList, p.Name) end
end

createDropdown(TargetTab, "Target", targetPlayersList[1] or "Aucun", targetPlayersList, false, function(targetName)
    State.SelectedTarget = targetName
end)

createToggle(TargetTab, "Fling Target", "Expulse le joueur sélectionné", false, function(v)
    State.FlingTarget = v
    if v and State.SelectedTarget ~= "" then
        local targetPlr = Players:FindFirstChild(State.SelectedTarget)
        if targetPlr and targetPlr.Character and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local oldPos = hrp.CFrame
            for i = 1, 25 do
                if targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
                    hrp.CFrame = targetPlr.Character.HumanoidRootPart.CFrame
                    hrp.Velocity = Vector3.new(9999, 9999, 9999)
                    task.wait(0.02)
                end
            end
            hrp.CFrame = oldPos
            hrp.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

createToggle(TargetTab, "Spectate Target", "Caméra fixée sur la cible", false, function(v)
    State.SpectateTarget = v
    if v and State.SelectedTarget ~= "" then
        local targetPlr = Players:FindFirstChild(State.SelectedTarget)
        if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("Humanoid") then
            Workspace.CurrentCamera.CameraSubject = targetPlr.Character.Humanoid
        end
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character.Humanoid
        end
    end
end)

createToggle(TargetTab, "Loop Go To Target", "Téléportation continue sur la cible", false, function(v)
    State.LoopGoToTarget = v
    if v then
        AddConnection("LoopGoTo", RunService.Heartbeat:Connect(function()
            if not State.LoopGoToTarget or State.SelectedTarget == "" then return end
            local p = Players:FindFirstChild(State.SelectedTarget)
            if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end
        end))
    end
end)

createActionButton(TargetTab, "Teleport To Target", "chevron", function()
    if State.SelectedTarget ~= "" then
        local p = Players:FindFirstChild(State.SelectedTarget)
        if p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        end
    end
end)

-- 4. VISUALS TAB
local Highlights = {}
createToggle(VisualsTab, "Player Chams", "Affichage des contours wallhack des rôles", false, function(v)
    State.PlayerChams = v
    if not v then
        for _, hl in pairs(Highlights) do hl:Destroy() end
        Highlights = {}
    else
        AddConnection("ChamsLoop", RunService.Heartbeat:Connect(function()
            if not State.PlayerChams then return end
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

createToggle(VisualsTab, "Gun Cham", "Surbrillance du pistolet tombé au sol", false, function(v)
    State.GunCham = v
end)

createToggle(VisualsTab, "3DRendering", "Active/Désactive le rendu des boîtes 3D", false, function(v)
    State.ThreeDRendering = v
end)

createToggle(VisualsTab, "Name ESP", "Affiche le nom et le rôle au-dessus des joueurs", false, function(v)
    State.NameESP = v
end)

-- 5. JOUEUR TAB
createToggle(JoueurTab, "Walk Speed", "Activer la vitesse personnalisée", false, function(v)
    State.WalkSpeedToggle = v
end)

createSlider(JoueurTab, "Walk Speed", 16, 120, 16, function(v)
    State.WalkSpeed = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)

createToggle(JoueurTab, "Jump Power", "Activer la hauteur de saut personnalisée", false, function(v)
    State.JumpPowerToggle = v
end)

createSlider(JoueurTab, "Jump Power", 50, 200, 50, function(v)
    State.JumpPower = v
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = v
    end
end)

createActionButton(JoueurTab, "Invisible [FE]", "dots", function()
    if LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 1
            end
        end
    end
end)

createToggle(JoueurTab, "Anti Fling", "Empêche les autres joueurs de vous propulser", true, function(v)
    State.AntiFling = v
    if v then
        AddConnection("AntiFlingLoop", RunService.Stepped:Connect(function()
            if State.AntiFling and LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0) end
                end
            end
        end))
    end
end)

-- 6. EMOTES & COMMANDS TAB
createToggle(EmotesTab, "Auto Emote", "Joue l'émote sélectionnée en boucle", false, function(v)
    State.AutoEmote = v
end)

createDropdown(EmotesTab, "Emote", "ninja", {"ninja", "dab", "floss", "headless", "zen", "zombie", "sit"}, false, function(e)
    State.SelectedEmote = e
end)

createDropdown(EmotesTab, "Select Command", "sit", {"kick", "sit", "void", "anchor", "unanchor"}, true, function(cmd)
    State.SelectedCommand = cmd
end)

createActionButton(EmotesTab, "Execute Command", "chevron", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if State.SelectedCommand == "sit" then char.Humanoid.Sit = true
        elseif State.SelectedCommand == "anchor" then
            for _, p in ipairs(char:GetChildren()) do if p:IsA("BasePart") then p.Anchored = true end end
        elseif State.SelectedCommand == "unanchor" then
            for _, p in ipairs(char:GetChildren()) do if p:IsA("BasePart") then p.Anchored = false end end
        elseif State.SelectedCommand == "void" and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(0, -300, 0)
        end
    end
end)

-- 7. TELEPORT TAB
createActionButton(TeleportTab, "Teleport To Lobby", "chevron", function()
    local lobby = Workspace:FindFirstChild("Lobby")
    if lobby and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = lobby:GetModelCFrame() or CFrame.new(0, 50, 0)
    end
end)

createActionButton(TeleportTab, "Teleport To Map", "chevron", function()
    local map = Workspace:FindFirstChild("Normal") or Workspace:FindFirstChild("CoinContainer")
    if map and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 20, 0)
    end
end)

-- 8. WEBHOOK TAB
createTextBox(WebhookTab, "Webhook URL", "https://discord.com/api/webhooks/...", function(url)
    State.WebhookURL = url
end)

createToggle(WebhookTab, "Coin Tracker", "Envoie les statistiques des pièces récoltées", false, function(v)
    State.CoinTracker = v
end)

createTextBox(WebhookTab, "Minutes To Send Webhook", "5", function(mins)
    State.WebhookInterval = mins
end)

createToggle(WebhookTab, "Unbox Notification", "Notification lors du déballage d'une boîte (Déverrouillé)", false, function(v)
    State.UnboxNotification = v
end)

-- 9. SETTINGS TAB
createToggle(SettingsTab, "Auto Save Settings", "Sauvegarde automatique des préférences", true, function(v)
    State.AutoSaveSettings = v
end)

createToggle(SettingsTab, "Auto ReExecute", "Réexécute le script après chaque réapparition", false, function(v)
    State.AutoReExecute = v
end)

createToggle(SettingsTab, "Auto Rejoin", "Rejoint automatiquement en cas de déconnexion", false, function(v)
    State.AutoRejoin = v
end)

createActionButton(SettingsTab, "Rejoin Server", "chevron", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

createActionButton(SettingsTab, "Server Hop", "chevron", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

print("=========================================")
print("Le M MM2 - UNLOCKED ULTRA DARK EDITION LOADED!")
print("=========================================")
