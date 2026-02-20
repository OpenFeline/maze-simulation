--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PLACEHOLDER_TEXT: string = "N/A"
local SPRING_SPEED: number = 25
local PADDING: UDim = UDim.new(0.25)
local UI = script.Parent.Parent.Parent

local Sift = require(ReplicatedStorage.Packages.Sift)
local Dictionary = Sift.Dictionary

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type Value<T> = Fusion.Value<T>

local Roblox = require(UI.types.Roblox)

local Texture = require(UI.types.Texture)
type Texture = Texture.Texture

local Text = require(UI.component.Core.Text)

type Props = Text.Props & {
	Toggle: Value<boolean>,
	Icon: Texture.Texture,
}

return function(scope: Scope, props: Props)
	scope = scope:innerScope() :: Scope

	props.Text = props.Text or PLACEHOLDER_TEXT

	local imageProps: Roblox.GuiObject = {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ImageColor3 = props.Icon.Color or props.Color,
	}
	Texture.Apply(props.Icon, imageProps)

	local textProps: Roblox.GuiObject = {
		Size = UDim2.fromScale(1, 1),
	}

	local goal = scope:Computed(function(use: any)
		if use(props.Toggle) then
			return UDim2.new(0.5, 0, -(1 + PADDING.Scale), -PADDING.Offset)
		else
			return UDim2.fromScale(0.5, 0)
		end
	end)
	local position = scope:Spring(goal, SPRING_SPEED)

	return scope:New "Frame" {
		Parent = props.Parent,

		ZIndex = props.ZIndex,
		LayoutOrder = props.LayoutOrder,
		ClipsDescendants = true,

		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Size = props.Size,

		BackgroundTransparency = 1,

		[Children] = scope:New "Frame" {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = position,
			Size = UDim2.fromScale(1, 1),

			BackgroundTransparency = 1,
			[Children] = {
				scope:New "UIListLayout" {
					FillDirection = Enum.FillDirection.Vertical,
					Padding = PADDING,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Top,
				},
				scope:New("ImageLabel")(imageProps :: any),
				Text(scope, Dictionary.join(props, textProps) :: any),
			},
		},
	}
end
