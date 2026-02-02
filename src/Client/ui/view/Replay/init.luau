--!strict

--[[
    Replay View
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>
type StateObject<T> = Fusion.UsedAs<T>

local Theme = require(script.Parent.Parent.Theme)

local Component = script.Parent.Parent.component
local Button = require(Component.Core.Button)
local Card = require(Component.Core.Card)
local Text = require(Component.Core.Text)

type Props = {
	Parent: UsedAs<Instance?>?,
}

return function(scope: Scope, props: Props): Instance
	scope = scope:innerScope({}) :: Scope

	local theme = Theme.Contextual:now()
	local texture = {
		Asset = "rbxassetid://17259633983",
		Transparency = 0.75,
		ScaleType = Enum.ScaleType.Tile,
		TileSize = UDim2.fromOffset(100, 100),
	}

	return scope:New "Frame" {
		Parent = props.Parent,

		AnchorPoint = Vector2.one / 2,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),

		BackgroundTransparency = 1,

		[Children] = {
			Card(scope, {
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.fromScale(0.5, 1),
				Size = UDim2.fromScale(1, 0.1),

				Texture = texture :: any,
				Color = theme.Primary,
			}),
		},
	}
end
