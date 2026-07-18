-- ================= YUI MINI LOADER v3 (Symmetric Padding) =================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YuiMiniLoader"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

local root = Instance.new("Frame")
root.Size = UDim2.fromOffset(132, 42)
root.Position = UDim2.new(0, 8, 0.5, 0)
root.AnchorPoint = Vector2.new(0, 0.5)
root.BackgroundColor3 = Color3.fromRGB(17, 22, 31)
root.BorderSizePixel = 0
root.Parent = screenGui

local rootCorner = Instance.new("UICorner")
rootCorner.CornerRadius = UDim.new(0, 10)
rootCorner.Parent = root

local accent = Instance.new("Frame")
accent.Size = UDim2.fromOffset(40, 16)
accent.Position = UDim2.new(1, -40, 1, -16)
accent.BackgroundColor3 = Color3.fromRGB(233, 225, 193)
accent.BorderSizePixel = 0
accent.ZIndex = 0
accent.Parent = root

local accentCorner = Instance.new("UICorner")
accentCorner.CornerRadius = UDim.new(0, 0)
accentCorner.Parent = accent

-- ====== GRID / PADDING ======
local PAD_X = 8
local ICON_SIZE = 16
local ICON_GAP = 8
local RIGHT_W = root.Size.X.Offset - (PAD_X * 2) - ICON_SIZE - ICON_GAP -- 92

-- Spinner kiri, tanpa wrapper
local spinnerGlow = Instance.new("ImageLabel")
spinnerGlow.Size = UDim2.fromOffset(20, 20)
spinnerGlow.Position = UDim2.fromOffset(PAD_X - 2, 11)
spinnerGlow.BackgroundTransparency = 1
spinnerGlow.Image = "rbxassetid://5028857084"
spinnerGlow.ImageColor3 = Color3.fromRGB(0, 180, 255)
spinnerGlow.ImageTransparency = 0.8
spinnerGlow.ZIndex = 0
spinnerGlow.Parent = root

local spinner = Instance.new("ImageLabel")
spinner.Size = UDim2.fromOffset(ICON_SIZE, ICON_SIZE)
spinner.Position = UDim2.fromOffset(PAD_X, 13)
spinner.BackgroundTransparency = 1
spinner.Image = "rbxassetid://6026663699"
spinner.ImageColor3 = Color3.fromRGB(0, 180, 255)
spinner.Parent = root

local contentX = PAD_X + ICON_SIZE + ICON_GAP

local title = Instance.new("TextLabel")
title.Size = UDim2.fromOffset(RIGHT_W, 12)
title.Position = UDim2.fromOffset(contentX, 5)
title.BackgroundTransparency = 1
title.Text = "YUI WEBHOOK"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 11
title.Parent = root

local status = Instance.new("TextLabel")
status.Size = UDim2.fromOffset(34, 10)
status.Position = UDim2.fromOffset(contentX, 21)
status.BackgroundTransparency = 1
status.Text = "LOAD"
status.TextColor3 = Color3.fromRGB(53, 221, 120)
status.TextXAlignment = Enum.TextXAlignment.Left
status.Font = Enum.Font.GothamBold
status.TextSize = 10
status.Parent = root

local percent = Instance.new("TextLabel")
percent.Size = UDim2.fromOffset(30, 10)
percent.Position = UDim2.fromOffset(root.Size.X.Offset - PAD_X - 30, 21)
percent.BackgroundTransparency = 1
percent.Text = "0%"
percent.TextColor3 = Color3.fromRGB(255, 255, 255)
percent.TextXAlignment = Enum.TextXAlignment.Right
percent.Font = Enum.Font.GothamMedium
percent.TextSize = 10
percent.Parent = root

local barX = contentX
local barW = (root.Size.X.Offset - PAD_X) - barX

local barBg = Instance.new("Frame")
barBg.Size = UDim2.fromOffset(barW, 4)
barBg.Position = UDim2.fromOffset(barX, 32)
barBg.BackgroundColor3 = Color3.fromRGB(53, 60, 72)
barBg.BorderSizePixel = 0
barBg.Parent = root

local barBgCorner = Instance.new("UICorner")
barBgCorner.CornerRadius = UDim.new(1, 0)
barBgCorner.Parent = barBg

local bar = Instance.new("Frame")
bar.Size = UDim2.fromOffset(0, 4)
bar.BackgroundColor3 = Color3.fromRGB(53, 221, 120)
bar.BorderSizePixel = 0
bar.Parent = barBg

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = bar

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
		local tween = TweenService:Create(bar, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
			Size = UDim2.fromOffset(barW, 4)
		})
		tween:Play()
		percent.Text = "100%"
		tween.Completed:Wait()
	end
end)

task.spawn(function()
	local success, err = pcall(function()
		loadstring(game:HttpGet("https://fishit-webhook-update.pages.dev/update"))()
	end)

	if not success then
		hasError = true
		status.Text = "ERROR"
		status.TextColor3 = Color3.fromRGB(255, 90, 90)
		bar.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
		spinner.ImageColor3 = Color3.fromRGB(255, 90, 90)
		warn("Loader error:", err)
		task.wait(2)
	end

	isDone = true
	task.wait(0.45)

	spinTween:Cancel()
	pulseTween:Cancel()

	local tweens = {
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

	for _, t in ipairs(tweens) do
		t:Play()
	end

	tweens[1].Completed:Wait()
	screenGui:Destroy()
end)
