--!strict

-- Services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Fusion | Definitions:
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

-- Fusion | Types:
type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>
type Value<T> = Fusion.Value<T>

-- Component | Dependencies:
local UI = script.Parent.Parent.Parent

local Theme = require(UI.Theme)

local Shadow = require(UI.types.Shadow)
type Shadow = Shadow.Shadow

local Texture = require(UI.types.Texture)
type Texture = Texture.Texture

local Layout = require(script.Layout)

local COMPONENTS = {
	Text = require(UI.component.Texts.Iconic),
	Button = require(UI.component.Buttons.Raised),
}

-- Component | Types:
type ButtonInfo = {
	Name: string,
	Icon: Texture,
	Activated: (GuiObject) -> ()?,
}
type Props = {
	Parent: UsedAs<Instance?>?,
	Buttons: { ButtonInfo }?,
	Shadow: Shadow.Shadow?,
}

-- Component | Constructor:
return function(_scope: Scope, props: Props)
	type InnerScope = Scope<Fusion & typeof(COMPONENTS)>
	local scope = _scope:innerScope(COMPONENTS) :: InnerScope

	local buttonInfo = props.Buttons or Layout

	local theme = Theme.Contextual:now()
	local texture: Texture = {
		--Asset = "rbxassetid://135045731054130",
		Asset = "rbxassetid://97813006995261",
		Color = theme.Secondary,
		Transparency = 0,
	}

	return scope:New "Frame" {
		Parent = props.Parent,
		Active = false,

		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.fromScale(0.5, 0),
		Size = UDim2.fromScale(0.65, 0.075),

		BackgroundTransparency = 1,

		[Children] = {
			scope:New "UIListLayout" {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			},
			scope:ForValues(buttonInfo, function(use: any, scope: InnerScope, info: ButtonInfo)
				local hovered = scope:Value(false) :: Value<boolean>
				local button = scope:Button {
					Size = UDim2.fromScale(0.3, 1),

					Color = theme.Primary,
					Shadow = props.Shadow,
					Texture = texture,

					Hovered = hovered,
					Activated = info.Activated,

					[Children] = {
						scope:New "UIPadding" {
							PaddingTop = UDim.new(0.2),
							PaddingBottom = UDim.new(0.2),
							PaddingLeft = UDim.new(0.2),
							PaddingRight = UDim.new(0.2),
						},
						scope:Text {
							Size = UDim2.fromScale(1, 1),

							Icon = info.Icon,
							Toggle = hovered,

							Text = info.Name,
							TextScaled = true,
							Color = theme.Text,

							Font = Font.fromEnum(Enum.Font.BuilderSansBold),

							[Children] = scope:New "UIStroke" {
								ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
								StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
								Thickness = 0.05,
								Color = theme.Shadow,
							},
						},
					},
				}
				return button
			end),
		},
	}
end
