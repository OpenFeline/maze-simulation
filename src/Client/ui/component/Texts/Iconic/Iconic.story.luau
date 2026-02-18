--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.Packages.Sift)
local Dictionary = Sift.Dictionary

local UI = script.Parent.Parent.Parent.Parent

local Story = require(UI.Story)

local Shadow = require(UI.types.Shadow)
local Texture = require(UI.types.Texture)

local Component = require(script.Parent)

Texture.Story.Controls["Texture: ScaleType"].ControlValue = Enum.ScaleType.Fit
Shadow.Story.Controls["Shadow: Offset (X)"].ControlValue = 0
Shadow.Story.Controls["Shadow: Offset (Y)"].ControlValue = 0

local STORY_CONTROLS = {
	Toggled = false,
	Text = "HOME",

	Color = Color3.new(1, 1, 1),

	["Texture: Asset"] = "rbxassetid://13060262529",
}
type Controls = typeof(STORY_CONTROLS) & typeof(Shadow.Story.Controls) & typeof(Texture.Story.Controls)

return Story.Build(
	function(props: Story.Props<Controls>)
		local scope = props.scope
		local controls = props.controls

		local texture = Texture.Story.Properties(scope, controls)
		texture.Color = controls.Color

		local shadow = Shadow.Story.Properties(scope, controls)

		Component(scope, {
			Parent = props.target,

			AnchorPoint = Vector2.one / 2,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.3, 0.2),

			Icon = texture,
			Toggle = controls.Toggled :: any,

			Text = controls.Text,
			TextScaled = true,
			Color = controls.Color,
			Shadow = shadow,
		})

		return nil
	end,
	Story.Controls(
		Shadow.Story.Controls,
		Dictionary.removeKey(Texture.Story.Controls :: any, "Texture: Color"),
		STORY_CONTROLS
	)
)
