--// =========================================================
--// YUI WEBHOOK - CLEAN MIGRATION POPUP
--// TOP MOST + AUTO DPI + READ ONLY + AUTO SELECT ALL
--// =========================================================

local Players = game:GetService("Players")

local player = Players.LocalPlayer
if not player then
	return
end

local playerGui = player:WaitForChild("PlayerGui", 10)
if not playerGui then
	return
end

local env = getgenv and getgenv() or getfenv()
local currentLicense =
	rawget(env, "yui_license_monitor")
	or rawget(getfenv(), "yui_license_monitor")
	or _G.yui_license_monitor
	or "ISI_LICENSE_KAMU"

currentLicense = tostring(currentLicense)

local latestLoaderUrl = "https://raw.githubusercontent.com/newfadel/yuiwebhook/refs/heads/master/loader.lua"
local newScriptText =
	'yui_license_monitor = "' .. currentLicense .. '"\n' ..
	'loadstring(game:HttpGet("' .. latestLoaderUrl .. '"))()'

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "YuiMigrationInfo"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local overlay = Instance.new("Frame")
overlay.Size = UDim2.fromScale(1, 1)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.35
overlay.BorderSizePixel = 0
overlay.ZIndex = 100
overlay.Parent = screenGui

local modal = Instance.new("Frame")
modal.Size = UDim2.fromOffset(470, 280)
modal.Position = UDim2.fromScale(0.5, 0.5)
modal.AnchorPoint = Vector2.new(0.5, 0.5)
modal.BackgroundColor3 = Color3.fromRGB(13, 17, 25)
modal.BorderSizePixel = 0
modal.ZIndex = 101
modal.Parent = overlay

local modalCorner = Instance.new("UICorner")
modalCorner.CornerRadius = UDim.new(0, 10)
modalCorner.Parent = modal

local modalGradient = Instance.new("UIGradient")
modalGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 20, 31)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 13, 21))
})
modalGradient.Rotation = 90
modalGradient.Parent = modal

local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = modal

local function addTextConstraint(gui, minSize, maxSize)
	local c = Instance.new("UITextSizeConstraint")
	c.MinTextSize = minSize
	c.MaxTextSize = maxSize
	c.Parent = gui
end

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 46)
header.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
header.BorderSizePixel = 0
header.ZIndex = 102
header.Parent = modal

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 10)
headerFix.Position = UDim2.new(0, 0, 1, -10)
headerFix.BackgroundColor3 = Color3.fromRGB(10, 13, 20)
headerFix.BorderSizePixel = 0
headerFix.ZIndex = 102
headerFix.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -150, 1, 0)
title.Position = UDim2.fromOffset(16, 0)
title.BackgroundTransparency = 1
title.Text = "Info Migration Webhook"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.ZIndex = 103
title.Parent = header
addTextConstraint(title, 15, 18)

local badge = Instance.new("TextLabel")
badge.Size = UDim2.fromOffset(108, 20)
badge.Position = UDim2.new(1, -124, 0.5, 0)
badge.AnchorPoint = Vector2.new(0, 0.5)
badge.BackgroundColor3 = Color3.fromRGB(24, 121, 186)
badge.BackgroundTransparency = 0.15
badge.Text = "YUI-WEBHOOK"
badge.TextColor3 = Color3.fromRGB(230, 245, 255)
badge.Font = Enum.Font.GothamBold
badge.TextSize = 10
badge.ZIndex = 103
badge.Parent = header

local badgeCorner = Instance.new("UICorner")
badgeCorner.CornerRadius = UDim.new(0, 7)
badgeCorner.Parent = badge
addTextConstraint(badge, 8, 10)

local desc = Instance.new("TextLabel")
desc.Size = UDim2.new(1, -32, 0, 58)
desc.Position = UDim2.fromOffset(16, 58)
desc.BackgroundTransparency = 1
desc.Text = "Halo pengguna webhook, saat ini yui-webhook pindah alamat script. serta pembaharuan maintenance berkala.. silahkan gunakan script dibawah ini dan dikonfigurasi ulang ya, tersedia di web https://webhook.fadel.web.id :"
desc.TextColor3 = Color3.fromRGB(223, 227, 233)
desc.TextXAlignment = Enum.TextXAlignment.Left
desc.TextYAlignment = Enum.TextYAlignment.Top
desc.Font = Enum.Font.GothamMedium
desc.TextSize = 14
desc.TextWrapped = true
desc.ZIndex = 102
desc.Parent = modal
addTextConstraint(desc, 12, 14)

local codeTitle = Instance.new("TextLabel")
codeTitle.Size = UDim2.new(1, -32, 0, 16)
codeTitle.Position = UDim2.fromOffset(16, 118)
codeTitle.BackgroundTransparency = 1
codeTitle.Text = "Script terbaru"
codeTitle.TextColor3 = Color3.fromRGB(129, 199, 240)
codeTitle.TextXAlignment = Enum.TextXAlignment.Left
codeTitle.Font = Enum.Font.GothamBold
codeTitle.TextSize = 12
codeTitle.ZIndex = 102
codeTitle.Parent = modal
addTextConstraint(codeTitle, 10, 12)

local codeCard = Instance.new("Frame")
codeCard.Size = UDim2.new(1, -32, 0, 82)
codeCard.Position = UDim2.fromOffset(16, 138)
codeCard.BackgroundColor3 = Color3.fromRGB(18, 22, 30)
codeCard.BorderSizePixel = 0
codeCard.ZIndex = 102
codeCard.Parent = modal

local codeCorner = Instance.new("UICorner")
codeCorner.CornerRadius = UDim.new(0, 8)
codeCorner.Parent = codeCard

local codeHeader = Instance.new("Frame")
codeHeader.Size = UDim2.new(1, 0, 0, 18)
codeHeader.BackgroundColor3 = Color3.fromRGB(22, 27, 36)
codeHeader.BorderSizePixel = 0
codeHeader.ZIndex = 103
codeHeader.Parent = codeCard

local codeHeaderCorner = Instance.new("UICorner")
codeHeaderCorner.CornerRadius = UDim.new(0, 8)
codeHeaderCorner.Parent = codeHeader

local codeHeaderFix = Instance.new("Frame")
codeHeaderFix.Size = UDim2.new(1, 0, 0, 7)
codeHeaderFix.Position = UDim2.new(0, 0, 1, -7)
codeHeaderFix.BackgroundColor3 = Color3.fromRGB(22, 27, 36)
codeHeaderFix.BorderSizePixel = 0
codeHeaderFix.ZIndex = 103
codeHeaderFix.Parent = codeHeader

local dots = {
	{10, Color3.fromRGB(255, 95, 86)},
	{22, Color3.fromRGB(255, 189, 46)},
	{34, Color3.fromRGB(39, 201, 63)},
}

for _, item in ipairs(dots) do
	local dot = Instance.new("Frame")
	dot.Size = UDim2.fromOffset(7, 7)
	dot.Position = UDim2.fromOffset(item[1], 5)
	dot.BackgroundColor3 = item[2]
	dot.BorderSizePixel = 0
	dot.ZIndex = 104
	dot.Parent = codeHeader
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(1, 0)
	c.Parent = dot
end

local codeBox = Instance.new("TextBox")
codeBox.Size = UDim2.new(1, -16, 1, -26)
codeBox.Position = UDim2.fromOffset(8, 22)
codeBox.BackgroundTransparency = 1
codeBox.ClearTextOnFocus = false
codeBox.MultiLine = true
codeBox.TextEditable = false
codeBox.TextWrapped = true
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 13
codeBox.TextColor3 = Color3.fromRGB(235, 240, 245)
codeBox.Text = newScriptText
codeBox.ZIndex = 104
codeBox.Parent = codeCard
addTextConstraint(codeBox, 11, 13)

local note = Instance.new("TextLabel")
note.Size = UDim2.new(1, -32, 0, 14)
note.Position = UDim2.fromOffset(16, 224)
note.BackgroundTransparency = 1
note.Text = "Salin manual jika tidak bisa di salin lewat button."
note.TextColor3 = Color3.fromRGB(151, 156, 165)
note.TextXAlignment = Enum.TextXAlignment.Left
note.Font = Enum.Font.Gotham
note.TextSize = 11
note.ZIndex = 102
note.Parent = modal
addTextConstraint(note, 9, 11)

local hint = Instance.new("TextLabel")
hint.Size = UDim2.new(1, -210, 0, 15)
hint.Position = UDim2.fromOffset(16, 244)
hint.BackgroundTransparency = 1
hint.Text = ""
hint.TextColor3 = Color3.fromRGB(151, 156, 165)
hint.TextXAlignment = Enum.TextXAlignment.Left
hint.Font = Enum.Font.GothamMedium
hint.TextSize = 11
hint.ZIndex = 102
hint.Parent = modal
addTextConstraint(hint, 9, 11)

local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.fromOffset(82, 30)
copyButton.Position = UDim2.new(1, -174, 1, -34)
copyButton.BackgroundColor3 = Color3.fromRGB(32, 144, 214)
copyButton.Text = "Copy"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.Font = Enum.Font.GothamBold
copyButton.TextSize = 13
copyButton.ZIndex = 102
copyButton.Parent = modal
addTextConstraint(copyButton, 10, 13)

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 7)
copyCorner.Parent = copyButton

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.fromOffset(82, 30)
closeButton.Position = UDim2.new(1, -88, 1, -34)
closeButton.BackgroundColor3 = Color3.fromRGB(42, 48, 58)
closeButton.Text = "Close"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 13
closeButton.ZIndex = 102
closeButton.Parent = modal
addTextConstraint(closeButton, 10, 13)

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 7)
closeCorner.Parent = closeButton

local function updateAutoDPI()
	local camera = workspace.CurrentCamera
	if not camera then
		return
	end

	local viewport = camera.ViewportSize
	local shortest = math.min(viewport.X, viewport.Y)
	local scale = shortest / 1080
	scale = math.clamp(scale * 1.75, 0.82, 1)
	uiScale.Scale = scale

	if viewport.X <= 540 then
		modal.Size = UDim2.fromOffset(446, 276)
	elseif viewport.X <= 720 then
		modal.Size = UDim2.fromOffset(458, 278)
	else
		modal.Size = UDim2.fromOffset(470, 280)
	end
end

local function selectAllText()
	task.defer(function()
		if not codeBox or not codeBox.Parent then
			return
		end
		codeBox.SelectionStart = 1
		codeBox.CursorPosition = #codeBox.Text + 1
	end)
end

local function copyToClipboard(text)
	if type(setclipboard) == "function" then
		return pcall(setclipboard, text)
	end
	if type(toclipboard) == "function" then
		return pcall(toclipboard, text)
	end
	return false
end

codeBox.Focused:Connect(function()
	selectAllText()
end)

copyButton.MouseButton1Click:Connect(function()
	local ok = copyToClipboard(codeBox.Text)
	codeBox:CaptureFocus()
	selectAllText()

	if ok then
		copyButton.Text = "Copied"
		hint.Text = "Script berhasil disalin ke clipboard."
		hint.TextColor3 = Color3.fromRGB(145, 240, 170)
	else
		copyButton.Text = "Select"
		hint.Text = "Clipboard tidak tersedia, text sudah di-select semua."
		hint.TextColor3 = Color3.fromRGB(255, 214, 125)
	end

	task.delay(1.5, function()
		if copyButton and copyButton.Parent then
			copyButton.Text = "Copy"
		end
	end)
end)

closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

updateAutoDPI()

if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateAutoDPI)
end

task.delay(0.12, function()
	if codeBox and codeBox.Parent then
		codeBox:CaptureFocus()
		selectAllText()
	end
end)
