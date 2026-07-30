--// =========================================================
--// YUI FISH IT ONLY LOADERS
--// =========================================================

local ALLOWED_PLACE_ID = 121864768012064

if game.PlaceId ~= ALLOWED_PLACE_ID then
    return
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
if not player then
    return
end

local playerGui = player:WaitForChild("PlayerGui", 10)
if not playerGui then
    return
end

local camera = Workspace.CurrentCamera
if not camera then
    return
end

local VERSION_URLS = {
    NEW = "https://webhook.fadel.web.id/update",
    OLD = "https://raw.githubusercontent.com/newfadel/yuiwebhook/refs/heads/master/webhook_old.lua",
}

-- =========================================================
-- LICENSE MONITOR BRIDGE
-- =========================================================
local function resolveLicenseMonitor()
    local candidates = {}

    local okGenv, genv = pcall(function()
        return getgenv and getgenv()
    end)
    if okGenv and type(genv) == "table" then
        table.insert(candidates, genv)
    end

    local okFenv, fenv = pcall(function()
        return getfenv and getfenv(0)
    end)
    if okFenv and type(fenv) == "table" then
        table.insert(candidates, fenv)
    end

    local okG, gtbl = pcall(function()
        return _G
    end)
    if okG and type(gtbl) == "table" then
        table.insert(candidates, gtbl)
    end

    for _, env in ipairs(candidates) do
        if env.yui_license_monitor ~= nil then
            return env.yui_license_monitor
        end
    end

    return nil
end

local yui_license_monitor = resolveLicenseMonitor()

-- =========================================================
-- UI ROOT
-- =========================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YuiMiniLoader"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- =========================================================
-- LOADER UI
-- =========================================================
local root = Instance.new("Frame")
root.Name = "Root"
root.Size = UDim2.fromOffset(138, 42)
root.Position = UDim2.new(0, 8, 0.5, 0)
root.AnchorPoint = Vector2.new(0, 0.5)
root.BackgroundColor3 = Color3.fromRGB(17, 22, 31)
root.BorderSizePixel = 0
root.Visible = false
root.Parent = screenGui

local rootCorner = Instance.new("UICorner")
rootCorner.CornerRadius = UDim.new(0, 10)
rootCorner.Parent = root

local accent = Instance.new("Frame")
accent.Name = "Accent"
accent.Size = UDim2.fromOffset(42, 16)
accent.Position = UDim2.new(1, -42, 1, -16)
accent.BackgroundColor3 = Color3.fromRGB(233, 225, 193)
accent.BorderSizePixel = 0
accent.ZIndex = 0
accent.Parent = root

local accentCorner = Instance.new("UICorner")
accentCorner.CornerRadius = UDim.new(0, 0)
accentCorner.Parent = accent

local PAD_X = 8
local ICON_SIZE = 16
local ICON_GAP = 8
local CONTENT_X = PAD_X + ICON_SIZE + ICON_GAP
local RIGHT_PAD = 8
local ROOT_W = root.Size.X.Offset

local spinnerGlow = Instance.new("ImageLabel")
spinnerGlow.Name = "SpinnerGlow"
spinnerGlow.Size = UDim2.fromOffset(20, 20)
spinnerGlow.Position = UDim2.fromOffset(PAD_X - 2, 11)
spinnerGlow.BackgroundTransparency = 1
spinnerGlow.Image = "rbxassetid://5028857084"
spinnerGlow.ImageColor3 = Color3.fromRGB(0, 180, 255)
spinnerGlow.ImageTransparency = 0.8
spinnerGlow.ZIndex = 0
spinnerGlow.Parent = root

local spinner = Instance.new("ImageLabel")
spinner.Name = "Spinner"
spinner.Size = UDim2.fromOffset(ICON_SIZE, ICON_SIZE)
spinner.Position = UDim2.fromOffset(PAD_X, 13)
spinner.BackgroundTransparency = 1
spinner.Image = "rbxassetid://6026663699"
spinner.ImageColor3 = Color3.fromRGB(0, 180, 255)
spinner.Parent = root

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.fromOffset(ROOT_W - CONTENT_X - RIGHT_PAD, 12)
title.Position = UDim2.fromOffset(CONTENT_X, 5)
title.BackgroundTransparency = 1
title.Text = "YUI WEBHOOK"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 11
title.TextTruncate = Enum.TextTruncate.AtEnd
title.Parent = root

local status = Instance.new("TextLabel")
status.Name = "Status"
status.Size = UDim2.fromOffset(34, 10)
status.Position = UDim2.fromOffset(CONTENT_X, 21)
status.BackgroundTransparency = 1
status.Text = "LOAD"
status.TextColor3 = Color3.fromRGB(53, 221, 120)
status.TextXAlignment = Enum.TextXAlignment.Left
status.Font = Enum.Font.GothamBold
status.TextSize = 10
status.Parent = root

local percent = Instance.new("TextLabel")
percent.Name = "Percent"
percent.Size = UDim2.fromOffset(30, 10)
percent.Position = UDim2.fromOffset(ROOT_W - RIGHT_PAD - 30, 21)
percent.BackgroundTransparency = 1
percent.Text = "0%"
percent.TextColor3 = Color3.fromRGB(255, 255, 255)
percent.TextXAlignment = Enum.TextXAlignment.Right
percent.Font = Enum.Font.GothamMedium
percent.TextSize = 10
percent.Parent = root

local barX = CONTENT_X
local barW = (ROOT_W - RIGHT_PAD) - barX

local barBg = Instance.new("Frame")
barBg.Name = "BarBg"
barBg.Size = UDim2.fromOffset(barW, 4)
barBg.Position = UDim2.fromOffset(barX, 32)
barBg.BackgroundColor3 = Color3.fromRGB(53, 60, 72)
barBg.BorderSizePixel = 0
barBg.Parent = root

local barBgCorner = Instance.new("UICorner")
barBgCorner.CornerRadius = UDim.new(1, 0)
barBgCorner.Parent = barBg

local bar = Instance.new("Frame")
bar.Name = "Bar"
bar.Size = UDim2.fromOffset(0, 4)
bar.BackgroundColor3 = Color3.fromRGB(53, 221, 120)
bar.BorderSizePixel = 0
bar.Parent = barBg

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = bar

-- =========================================================
-- CHOOSER UI
-- =========================================================
local chooserOverlay = Instance.new("Frame")
chooserOverlay.Name = "ChooserOverlay"
chooserOverlay.Size = UDim2.fromScale(1, 1)
chooserOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
chooserOverlay.BackgroundTransparency = 0.35
chooserOverlay.BorderSizePixel = 0
chooserOverlay.Parent = screenGui

local chooserPanel = Instance.new("Frame")
chooserPanel.Name = "ChooserPanel"
chooserPanel.Size = UDim2.fromOffset(700, 236)
chooserPanel.Position = UDim2.fromScale(0.5, 0.5)
chooserPanel.AnchorPoint = Vector2.new(0.5, 0.5)
chooserPanel.BackgroundColor3 = Color3.fromRGB(16, 20, 30)
chooserPanel.BorderSizePixel = 0
chooserPanel.Parent = chooserOverlay

local chooserScale = Instance.new("UIScale")
chooserScale.Scale = 1
chooserScale.Parent = chooserPanel

local chooserCorner = Instance.new("UICorner")
chooserCorner.CornerRadius = UDim.new(0, 16)
chooserCorner.Parent = chooserPanel

local chooserStroke = Instance.new("UIStroke")
chooserStroke.Color = Color3.fromRGB(63, 72, 92)
chooserStroke.Transparency = 0.4
chooserStroke.Thickness = 1
chooserStroke.Parent = chooserPanel

local chooserTitle = Instance.new("TextLabel")
chooserTitle.Size = UDim2.new(1, -92, 0, 24)
chooserTitle.Position = UDim2.fromOffset(16, 14)
chooserTitle.BackgroundTransparency = 1
chooserTitle.Text = "Select Lua Version"
chooserTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
chooserTitle.TextXAlignment = Enum.TextXAlignment.Left
chooserTitle.Font = Enum.Font.GothamBold
chooserTitle.TextSize = 19
chooserTitle.Parent = chooserPanel

local chooserDesc = Instance.new("TextLabel")
chooserDesc.Size = UDim2.new(1, -92, 0, 16)
chooserDesc.Position = UDim2.fromOffset(16, 36)
chooserDesc.BackgroundTransparency = 1
chooserDesc.Text = "Choose which loader version you want to use."
chooserDesc.TextColor3 = Color3.fromRGB(170, 178, 192)
chooserDesc.TextXAlignment = Enum.TextXAlignment.Left
chooserDesc.Font = Enum.Font.Gotham
chooserDesc.TextSize = 12
chooserDesc.Parent = chooserPanel

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.fromOffset(28, 28)
closeButton.Position = UDim2.new(1, -40, 0, 14)
closeButton.BackgroundColor3 = Color3.fromRGB(28, 33, 45)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(235, 235, 235)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.AutoButtonColor = false
closeButton.Parent = chooserPanel

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = Color3.fromRGB(78, 86, 104)
closeStroke.Transparency = 0.45
closeStroke.Thickness = 1
closeStroke.Parent = closeButton

local cardsHolder = Instance.new("Frame")
cardsHolder.Name = "CardsHolder"
cardsHolder.Size = UDim2.new(1, -32, 1, -70)
cardsHolder.Position = UDim2.fromOffset(16, 56)
cardsHolder.BackgroundTransparency = 1
cardsHolder.Parent = chooserPanel

local listLayout = Instance.new("UIListLayout")
listLayout.FillDirection = Enum.FillDirection.Horizontal
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
listLayout.Padding = UDim.new(0, 12)
listLayout.Parent = cardsHolder

local function createVersionCard(data)
    local card = Instance.new("TextButton")
    card.Name = data.Name
    card.Size = UDim2.fromOffset(320, 136)
    card.BackgroundColor3 = Color3.fromRGB(25, 29, 40)
    card.AutoButtonColor = false
    card.Text = ""
    card.Parent = cardsHolder

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 14)
    cardCorner.Parent = card

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(70, 78, 96)
    cardStroke.Transparency = 0.58
    cardStroke.Thickness = 1
    cardStroke.Parent = card

    local badgesWrap = Instance.new("Frame")
    badgesWrap.Name = "BadgesWrap"
    badgesWrap.Size = UDim2.new(1, -28, 0, 20)
    badgesWrap.Position = UDim2.fromOffset(14, 10)
    badgesWrap.BackgroundTransparency = 1
    badgesWrap.Parent = card

    local badgesLayout = Instance.new("UIListLayout")
    badgesLayout.FillDirection = Enum.FillDirection.Horizontal
    badgesLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    badgesLayout.Padding = UDim.new(0, 6)
    badgesLayout.Parent = badgesWrap

    local statusBadge = Instance.new("TextLabel")
    statusBadge.Name = "StatusBadge"
    statusBadge.AutomaticSize = Enum.AutomaticSize.X
    statusBadge.Size = UDim2.fromOffset(0, 20)
    statusBadge.BackgroundColor3 = data.AccentColor
    statusBadge.BackgroundTransparency = 0.1
    statusBadge.Text = "  " .. data.BadgeText .. "  "
    statusBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusBadge.Font = Enum.Font.GothamBold
    statusBadge.TextSize = 10
    statusBadge.Parent = badgesWrap

    local statusBadgeCorner = Instance.new("UICorner")
    statusBadgeCorner.CornerRadius = UDim.new(1, 0)
    statusBadgeCorner.Parent = statusBadge

    local dateBadge = Instance.new("TextLabel")
    dateBadge.Name = "DateBadge"
    dateBadge.AutomaticSize = Enum.AutomaticSize.X
    dateBadge.Size = UDim2.fromOffset(0, 20)
    dateBadge.BackgroundColor3 = Color3.fromRGB(36, 41, 55)
    dateBadge.Text = "  Updated " .. data.LastUpdate .. "  "
    dateBadge.TextColor3 = Color3.fromRGB(214, 220, 230)
    dateBadge.Font = Enum.Font.GothamMedium
    dateBadge.TextSize = 10
    dateBadge.Parent = badgesWrap

    local dateBadgeCorner = Instance.new("UICorner")
    dateBadgeCorner.CornerRadius = UDim.new(1, 0)
    dateBadgeCorner.Parent = dateBadge

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -28, 0, 22)
    nameLabel.Position = UDim2.fromOffset(14, 38)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = data.Title
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 16
    nameLabel.Parent = card

    local noteTitle = Instance.new("TextLabel")
    noteTitle.Size = UDim2.new(1, -28, 0, 14)
    noteTitle.Position = UDim2.fromOffset(14, 62)
    noteTitle.BackgroundTransparency = 1
    noteTitle.Text = "Description Notes"
    noteTitle.TextColor3 = Color3.fromRGB(136, 144, 160)
    noteTitle.TextXAlignment = Enum.TextXAlignment.Left
    noteTitle.Font = Enum.Font.GothamBold
    noteTitle.TextSize = 10
    noteTitle.Parent = card

    local noteLabel = Instance.new("TextLabel")
    noteLabel.Size = UDim2.new(1, -28, 0, 42)
    noteLabel.Position = UDim2.fromOffset(14, 80)
    noteLabel.BackgroundTransparency = 1
    noteLabel.Text = data.Note
    noteLabel.TextColor3 = Color3.fromRGB(228, 231, 236)
    noteLabel.TextWrapped = true
    noteLabel.TextYAlignment = Enum.TextYAlignment.Top
    noteLabel.TextXAlignment = Enum.TextXAlignment.Left
    noteLabel.Font = Enum.Font.Gotham
    noteLabel.TextSize = 12
    noteLabel.Parent = card

    local scale = Instance.new("UIScale")
    scale.Scale = 1
    scale.Parent = card

    local hoverIn = TweenService:Create(scale, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {Scale = 1.015})
    local hoverOut = TweenService:Create(scale, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {Scale = 1})
    local bgIn = TweenService:Create(card, TweenInfo.new(0.16), {BackgroundColor3 = Color3.fromRGB(30, 35, 48)})
    local bgOut = TweenService:Create(card, TweenInfo.new(0.16), {BackgroundColor3 = Color3.fromRGB(25, 29, 40)})
    local strokeIn = TweenService:Create(cardStroke, TweenInfo.new(0.16), {
        Transparency = 0.18,
        Color = data.AccentColor
    })
    local strokeOut = TweenService:Create(cardStroke, TweenInfo.new(0.16), {
        Transparency = 0.58,
        Color = Color3.fromRGB(70, 78, 96)
    })

    card.MouseEnter:Connect(function()
        hoverIn:Play()
        bgIn:Play()
        strokeIn:Play()
    end)

    card.MouseLeave:Connect(function()
        hoverOut:Play()
        bgOut:Play()
        strokeOut:Play()
    end)

    return card
end

local selectedUrl = nil
local hasSelected = false
local isClosed = false

local function updateChooserScale()
    local vp = camera.ViewportSize
    local scaleX = vp.X / 760
    local scaleY = vp.Y / 340
    local scale = math.min(scaleX, scaleY)
    scale = math.clamp(scale, 0.62, 1)
    chooserScale.Scale = scale
end

updateChooserScale()

camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    updateChooserScale()
end)

local function closeChooserAndExit()
    if isClosed then
        return
    end
    isClosed = true
    screenGui:Destroy()
end

local function closeChooserForLoading()
    local fade = {
        TweenService:Create(chooserOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}),
        TweenService:Create(chooserPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(684, 228)
        })
    }

    for _, t in ipairs(fade) do
        t:Play()
    end

    fade[2].Completed:Wait()
    if chooserOverlay and chooserOverlay.Parent then
        chooserOverlay:Destroy()
    end
end

local newCard = createVersionCard({
    Name = "NewVersionCard",
    Title = "NEW VERSION",
    BadgeText = "ALPHA",
    AccentColor = Color3.fromRGB(45, 155, 255),
    Note = "Notes : stable di region SG/HK dengan ping bagus",
    LastUpdate = "27 Jul 2026",
})

local oldCard = createVersionCard({
    Name = "OldVersionCard",
    Title = "OLD VERSION",
    BadgeText = "STABLE",
    AccentColor = Color3.fromRGB(80, 190, 120),
    Note = "Issue : versi lama, tidak ada pembaharuan feature lagi, namun terbukti stabil di seluruh region RF",
    LastUpdate = "24 Jun 2026",
})

local function selectVersion(url)
    if hasSelected or isClosed then
        return
    end

    hasSelected = true
    selectedUrl = url
    closeChooserForLoading()
    root.Visible = true
end

newCard.MouseButton1Click:Connect(function()
    selectVersion(VERSION_URLS.NEW)
end)

oldCard.MouseButton1Click:Connect(function()
    selectVersion(VERSION_URLS.OLD)
end)

local closeHoverIn = TweenService:Create(closeButton, TweenInfo.new(0.15), {
    BackgroundColor3 = Color3.fromRGB(40, 46, 62)
})

local closeHoverOut = TweenService:Create(closeButton, TweenInfo.new(0.15), {
    BackgroundColor3 = Color3.fromRGB(28, 33, 45)
})

closeButton.MouseEnter:Connect(function()
    closeHoverIn:Play()
end)

closeButton.MouseLeave:Connect(function()
    closeHoverOut:Play()
end)

closeButton.MouseButton1Click:Connect(function()
    closeChooserAndExit()
end)

local chooserIntroTween = TweenService:Create(
    chooserPanel,
    TweenInfo.new(0.18, Enum.EasingStyle.Quad),
    {Size = UDim2.fromOffset(716, 244)}
)
chooserIntroTween:Play()

-- =========================================================
-- ERROR POPUP
-- =========================================================
local function showErrorPopup(code)
    code = tostring(code or "UNKNOWN")

    local overlay = Instance.new("Frame")
    overlay.Name = "ErrorOverlay"
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.Position = UDim2.fromScale(0, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.35
    overlay.BorderSizePixel = 0
    overlay.Parent = screenGui

    local modal = Instance.new("Frame")
    modal.Name = "Modal"
    modal.Size = UDim2.fromOffset(380, 150)
    modal.Position = UDim2.fromScale(0.5, 0.5)
    modal.AnchorPoint = Vector2.new(0.5, 0.5)
    modal.BackgroundColor3 = Color3.fromRGB(20, 24, 34)
    modal.BorderSizePixel = 0
    modal.Parent = overlay

    local modalCorner = Instance.new("UICorner")
    modalCorner.CornerRadius = UDim.new(0, 12)
    modalCorner.Parent = modal

    local modalStroke = Instance.new("UIStroke")
    modalStroke.Color = Color3.fromRGB(255, 90, 90)
    modalStroke.Transparency = 0.25
    modalStroke.Thickness = 1
    modalStroke.Parent = modal

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -24, 0, 26)
    titleLabel.Position = UDim2.fromOffset(12, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Kode Error {" .. code .. "}"
    titleLabel.TextColor3 = Color3.fromRGB(255, 95, 95)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.Parent = modal

    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -24, 1, -62)
    msgLabel.Position = UDim2.fromOffset(12, 42)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = "Mohon maaf saya saat ini koneksi kamu bermasalah atau server lisensi tidak dapat terhubung.. silahkan ulangi atau tanya admin di whatsapp"
    msgLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextYAlignment = Enum.TextYAlignment.Top
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextSize = 14
    msgLabel.TextWrapped = true
    msgLabel.Parent = modal

    local okButton = Instance.new("TextButton")
    okButton.Size = UDim2.fromOffset(92, 30)
    okButton.Position = UDim2.new(1, -104, 1, -42)
    okButton.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
    okButton.Text = "Tutup"
    okButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    okButton.Font = Enum.Font.GothamBold
    okButton.TextSize = 14
    okButton.AutoButtonColor = true
    okButton.Parent = modal

    local okCorner = Instance.new("UICorner")
    okCorner.CornerRadius = UDim.new(0, 8)
    okCorner.Parent = okButton

    okButton.MouseButton1Click:Connect(function()
        overlay:Destroy()
    end)

    local popupTween = TweenService:Create(modal, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size = UDim2.fromOffset(390, 156)
    })
    popupTween:Play()
end

local function extractHttpCode(err)
    if typeof(err) ~= "string" then
        return "UNKNOWN"
    end

    local code = err:match("(%d%d%d)")
    if code then
        return code
    end

    if err:find("ConnectFail") or err:find("Timedout") or err:find("Timeout") or err:find("SslConnectFail") then
        return "CONNECTION"
    end

    return "UNKNOWN"
end

local function hideLoader()
    local fadeTweens = {
        TweenService:Create(root, TweenInfo.new(0.25), {BackgroundTransparency = 1}),
        TweenService:Create(accent, TweenInfo.new(0.25), {BackgroundTransparency = 1}),
        TweenService:Create(spinner, TweenInfo.new(0.25), {ImageTransparency = 1}),
        TweenService:Create(spinnerGlow, TweenInfo.new(0.25), {ImageTransparency = 1}),
        TweenService:Create(title, TweenInfo.new(0.25), {TextTransparency = 1}),
        TweenService:Create(status, TweenInfo.new(0.25), {TextTransparency = 1}),
        TweenService:Create(percent, TweenInfo.new(0.25), {TextTransparency = 1}),
        TweenService:Create(barBg, TweenInfo.new(0.25), {BackgroundTransparency = 1}),
        TweenService:Create(bar, TweenInfo.new(0.25), {BackgroundTransparency = 1}),
    }

    for _, tween in ipairs(fadeTweens) do
        tween:Play()
    end

    fadeTweens[1].Completed:Wait()
    root.Visible = false
end

-- =========================================================
-- ANIMATION
-- =========================================================
local spinTween = TweenService:Create(
    spinner,
    TweenInfo.new(0.85, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1),
    {Rotation = 360}
)

local pulseTween = TweenService:Create(
    spinnerGlow,
    TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {ImageTransparency = 0.9}
)

local isDone = false
local hasError = false

local function updateProgress(v)
    v = math.clamp(v, 0, 1)
    bar.Size = UDim2.fromOffset(math.floor(barW * v), 4)
    percent.Text = string.format("%d%%", math.floor(v * 100))
end

task.spawn(function()
    local displayed = 0

    while not hasSelected and not isClosed do
        task.wait()
    end

    if isClosed then
        return
    end

    spinTween:Play()
    pulseTween:Play()

    while not isDone and not isClosed do
        local target = 0.94
        displayed = displayed + (target - displayed) * 0.04
        updateProgress(displayed)
        task.wait()
    end

    if not hasError and not isClosed then
        local tween = TweenService:Create(
            bar,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad),
            {Size = UDim2.fromOffset(barW, 4)}
        )
        tween:Play()
        percent.Text = "100%"
        tween.Completed:Wait()
    end
end)

-- =========================================================
-- MAIN EXECUTION
-- =========================================================
task.spawn(function()
    while not selectedUrl and not isClosed do
        task.wait()
    end

    if isClosed or not selectedUrl then
        return
    end

    local success, err = pcall(function()
        local source = game:HttpGet(selectedUrl)
        local chunk = loadstring(source)

        if not chunk then
            error("LOADSTRING_FAILED")
        end

        local baseEnv = getfenv(chunk)
        local customEnv = setmetatable({
            yui_license_monitor = yui_license_monitor
        }, {
            __index = baseEnv
        })

        setfenv(chunk, customEnv)
        chunk()
    end)

    if not success then
        hasError = true

        local code = extractHttpCode(err)

        status.Text = "ERROR"
        status.TextColor3 = Color3.fromRGB(255, 90, 90)
        bar.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
        spinner.ImageColor3 = Color3.fromRGB(255, 90, 90)
        spinnerGlow.ImageColor3 = Color3.fromRGB(255, 90, 90)

        warn("[YUI Loader] Error:", err)

        task.wait(0.8)
        isDone = true
        spinTween:Cancel()
        pulseTween:Cancel()
        hideLoader()
        showErrorPopup(code)
        return
    end

    isDone = true
    task.wait(0.45)

    spinTween:Cancel()
    pulseTween:Cancel()

    local fadeTweens = {
        TweenService:Create(root, TweenInfo.new(0.25), {BackgroundTransparency = 1}),
        TweenService:Create(accent, TweenInfo.new(0.25), {BackgroundTransparency = 1}),
        TweenService:Create(spinner, TweenInfo.new(0.25), {ImageTransparency = 1}),
        TweenService:Create(spinnerGlow, TweenInfo.new(0.25), {ImageTransparency = 1}),
        TweenService:Create(title, TweenInfo.new(0.25), {TextTransparency = 1}),
        TweenService:Create(status, TweenInfo.new(0.25), {TextTransparency = 1}),
        TweenService:Create(percent, TweenInfo.new(0.25), {TextTransparency = 1}),
        TweenService:Create(barBg, TweenInfo.new(0.25), {BackgroundTransparency = 1}),
        TweenService:Create(bar, TweenInfo.new(0.25), {BackgroundTransparency = 1}),
    }

    for _, tween in ipairs(fadeTweens) do
        tween:Play()
    end

    fadeTweens[1].Completed:Wait()
    screenGui:Destroy()
end)
