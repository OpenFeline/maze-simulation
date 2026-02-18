--!strict

-- Services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Constants:
local ZERO_UDIM2: UDim2 = UDim2.new()
local SPRING_SPEED: number = 50
local HOVER_MULTIPLIER: number = 1.05

-- Sift | Definitons:
local Sift = require(ReplicatedStorage.Packages.Sift)
local Dictionary = Sift.Dictionary

-- Fusion | Definitions:
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children
local peek = Fusion.peek

-- Fusion | Types:
type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>
type Value<T> = Fusion.Value<T>

local Components = script.Parent.Parent
local Button = require(Components.Core.Button)

local Theme = require(Components.Parent.Theme)

local Types = Components.Parent.types
local Shadow = require(Types.Shadow)
type Shadow = Shadow.Shadow

type Props = Button.Props

return function(scope: Scope, props: Props)
	scope = scope:innerScope() :: Scope
	local theme = Theme.Contextual:now()

	local color = props.Color or theme.Primary
	local hovered = props.Hovered or scope:Value(false) :: Value<boolean>
	local pressed = props.Pressed or scope:Value(false) :: Value<boolean>

	local shadow: Shadow = props.Shadow :: Shadow
	do -- Build shadow, overwriting missing properties with defaults:
		local default: Shadow = {
			Offset = UDim2.fromScale(0, -0.05),
			Color = theme.Shadow,
			Ratio = 1,
		}
		shadow = if shadow then Dictionary.join(default, shadow) :: Shadow else default
	end

	local __offset, offset = shadow.Offset, scope:Value(peek(shadow.Offset))
	local spring = scope:Spring(offset, SPRING_SPEED)
	shadow.Offset = spring

	scope:Observer(hovered):onChange(function()
		if not peek(hovered) then return end
		spring:addVelocity(UDim2.fromScale(0, -3))
	end)
	scope:Observer(pressed):onChange(function()
		local pressing = peek(pressed)
		offset:set(if not pressing then peek(__offset) else ZERO_UDIM2)
	end)

	-- Overwrite properties:
	props.Color = color
	props.Shadow = shadow
	props.Hovered = hovered
	props.Pressed = pressed

	props[Children] = {
		scope:New "UIStroke" {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
			BorderStrokePosition = Enum.BorderStrokePosition.Inner,

			Color = theme.Shadow,
			Thickness = 0.025,
		},
		props[Children],
	}

	return Button(scope, props)
end
