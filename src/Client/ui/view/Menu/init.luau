--!strict

--[[
    Menu View
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local networking = require(ReplicatedStorage.networking)
local Children = Fusion.Children

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>
type StateObject<T> = Fusion.UsedAs<T>
type Value<T> = Fusion.Value<T>

local Theme = require(script.Parent.Parent.Theme)

local Component = script.Parent.Parent.component
local COMPONENTS = {
	-- Core:
	Card = require(Component.Core.Card),
	Text = require(Component.Core.Text),
	Button = require(Component.Buttons.Raised),
}
local VIEWS = {
	Navigation = require(script.Navigation),
}

type Props = {
	Parent: UsedAs<Instance?>?,
}

return function(_scope: Scope, props: Props): Instance
	type InnerScope = Scope<Fusion & typeof(COMPONENTS) & typeof(VIEWS)>
	local scope = _scope:innerScope(COMPONENTS, VIEWS) :: InnerScope

	local theme = Theme.Contextual:now()
	local shadow = {
		Offset = UDim2.fromScale(0, -0.05),
		--Transparency = 0.9,
		Color = theme.Shadow,
	}
	local texture = {
		--Asset = "rbxassetid://135045731054130",
		Asset = "rbxassetid://97813006995261",
		Color = theme.Secondary,
		Transparency = 0,
	}

	return scope:New "Frame" {
		Parent = props.Parent,

		AnchorPoint = Vector2.one / 2,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),

		BackgroundTransparency = 1,

		[Children] = {
			scope:New "UIPadding" {
				PaddingTop = UDim.new(0.01),
				PaddingBottom = UDim.new(0.01),
				PaddingLeft = UDim.new(0.01),
				PaddingRight = UDim.new(0.01),
			},

			scope:Navigation { Shadow = shadow :: any },
			-- TODO: All navigations points should be Views inside the "Screens" Folder.
			-- >>>>> Determining which is active at what time will then be handled here.

			scope:Button {
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.fromScale(1, 1),
				Size = UDim2.fromScale(0.2, 0.1),

				Color = theme.Primary,
				Shadow = shadow :: any,
				Texture = texture :: any,

				Corners = UDim.new(0.15),

				Activated = function()
					networking.startGame:fire()
				end,

				[Children] = {
					scope:New "UIPadding" {
						PaddingTop = UDim.new(0.2),
						PaddingBottom = UDim.new(0.2),
						PaddingLeft = UDim.new(0.2),
						PaddingRight = UDim.new(0.2),
					},
					scope:Text {
						AnchorPoint = Vector2.one / 2,
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(1, 1),

						Text = "PLAY",
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
			},
		},
	}
end
