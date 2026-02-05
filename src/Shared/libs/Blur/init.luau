local AssetService = game:GetService("AssetService")
local CaptureService = game:GetService("CaptureService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

assert(RunService:IsClient(), "Blur library can only be required on the client")

local OSGL = require(ReplicatedStorage.Packages.OSGL)

local Window = OSGL.Window
local color = OSGL.color

local camera = workspace.CurrentCamera :: Camera

local function GetSize(image: EditableImage)
	local viewport = camera.ViewportSize
	local img = image.Size

	local scale = math.min(img.X / viewport.X, img.Y / viewport.Y, 1)

	local width = math.floor(viewport.X * scale)
	local height = math.floor(viewport.Y * scale)

	local offsetX = math.floor((img.X - width) / 2)
	local offsetY = math.floor((img.Y - height) / 2)

	return width, height, scale, offsetX, offsetY
end

local function DrawScreen(image: EditableImage)
	CaptureService:CaptureScreenshot(function(screenshot: string)
		image:DrawImage(
			Vector2.zero,
			AssetService:CreateEditableImageAsync(Content.fromUri(screenshot)),
			Enum.ImageCombineType.Add
		)
	end)
end

return function(image: EditableImage)
	DrawScreen(image)
end
