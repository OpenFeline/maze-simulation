--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UI = script.Parent.Parent.Parent.Parent

local Texture = require(UI.types.Texture)
local networking = require(ReplicatedStorage.networking)
type Texture = Texture.Texture

export type ButtonInfo = {
	Name: string,
	Icon: Texture,
	Activated: (GuiObject) -> ()?,
}
local function Button(info: ButtonInfo): ButtonInfo
	return info
end

return {
	Button {
		Name = "REPLAY",
		Icon = {
			Asset = "rbxassetid://8445470392",
			Offset = Vector2.new(604, 804),
			Size = Vector2.new(96, 96),
			ScaleType = Enum.ScaleType.Fit,
		},
		Activated = function()
			networking.requestChangeState:fire("REPLAYSEL")
		end,
	},
	Button {
		Name = "HOME",
		Icon = {
			Asset = "rbxassetid://8445471713",
			Offset = Vector2.new(704, 904),
			Size = Vector2.new(96, 96),
			ScaleType = Enum.ScaleType.Fit,
		},
		Activated = function()
			networking.requestChangeState:fire("LOBBY")
		end,
	},
	Button {
		Name = "STORE",
		Icon = {
			Asset = "rbxassetid://8445471713",
			Offset = Vector2.new(704, 204),
			Size = Vector2.new(96, 96),
			ScaleType = Enum.ScaleType.Fit,
		},
	},
}
