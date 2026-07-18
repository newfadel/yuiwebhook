--// =========================================================
--// YUI FISH IT ONLY LOADER
--// =========================================================

local ALLOWED_PLACE_ID = 121864768012064

if game.PlaceId ~= ALLOWED_PLACE_ID then
	return
end


local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
if not player then
	return
end

local playerGui = player:WaitForChild("PlayerGui", 10)
if not playerGui then
	return
end

-- =========================================================
-- UI ROOT
-- =========================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YuiMiniLoader"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

local root = Instance.new("Frame")
root.Name = "Root"
root.Size = UDim2.fromOffset(138, 42)
root.Position = UDim2.new(0, 8, 0.5, 0)
root.AnchorPoint = Vector2.new(0, 0.5)
root.BackgroundColor3 = Color3.fromRGB(17, 22, 31)
root.BorderSizePixel = 0
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
spinTween:Play()

local pulseTween = TweenService:Create(
	spinnerGlow,
	TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
	{ImageTransparency = 0.9}
)
pulseTween:Play()

local isDone = false
local hasError = false

local function updateProgress(v)
	v = math.clamp(v, 0, 1)
	bar.Size = UDim2.fromOffset(math.floor(barW * v), 4)
	percent.Text = string.format("%d%%", math.floor(v * 100))
end

task.spawn(function()
	local displayed = 0
	while not isDone do
		local target = 0.94
		displayed = displayed + (target - displayed) * 0.04
		updateProgress(displayed)
		task.wait()
	end

	if not hasError then
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
	local success, err = pcall(function()
		loadstring(game:HttpGet("https://fishit-webhook-update.pages.dev/update"))()
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
