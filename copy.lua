-- LocalScript (StarterPlayerScripts)
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- Создаём эффект подсветки
local highlight = Instance.new("Highlight")
highlight.FillColor = Color3.fromRGB(255, 0, 0) -- 🔴 красный цвет
highlight.OutlineColor = Color3.fromRGB(255, 100, 100)
highlight.FillTransparency = 0.5
highlight.OutlineTransparency = 0
highlight.Enabled = false
highlight.Parent = workspace

local currentTarget = nil

-- функция копирования текста в буфер обмена (работает только в Roblox Studio)
local function copyToClipboard(text)
	if setclipboard then
		setclipboard(text)
	elseif syn and syn.write_clipboard then
		syn.write_clipboard(text)
	elseif Clipboard and Clipboard.set then
		Clipboard.set(text)
	else
		warn("Clipboard function not supported in this environment.")
	end
end

-- функция для получения модели игрока под курсором
local function getPlayerFromMouse()
	local target = mouse.Target
	if not target then return nil end
	
	local model = target:FindFirstAncestorOfClass("Model")
	if not model then return nil end
	
	local targetPlayer = game.Players:GetPlayerFromCharacter(model)
	if targetPlayer and targetPlayer ~= player then
		return model
	end
	
	return nil
end

-- постоянная проверка наведения
game:GetService("RunService").RenderStepped:Connect(function()
	local targetCharacter = getPlayerFromMouse()
	
	if targetCharacter then
		if currentTarget ~= targetCharacter then
			currentTarget = targetCharacter
			highlight.Adornee = targetCharacter
			highlight.Enabled = true
		end
	else
		currentTarget = nil
		highlight.Enabled = false
	end
end)

-- клик по игроку = копирование ID картинки из BillboardGui
mouse.Button1Down:Connect(function()
	if not currentTarget then return end

	local head = currentTarget:FindFirstChild("Head")
	if not head then return end

	local billboard = head:FindFirstChild("BillboardGui")
	if not billboard then return end

	local imageLabel = billboard:FindFirstChild("ImageLabel")
	if not imageLabel then return end

	local imageId = imageLabel.Image
	if imageId and imageId ~= "" then
		copyToClipboard(imageId)
		print("✅ flag copied:", imageId)
	else
		warn("⚠️ flag does not exists.")
	end
end)
