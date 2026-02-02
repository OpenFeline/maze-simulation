--!strict

--[[
    Replay View
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Hooks = script.Parent.Parent.hooks

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local PlayerState = require(ReplicatedStorage.state.atoms.PlayerState)
local Children = Fusion.Children

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>
type StateObject<T> = Fusion.UsedAs<T>

local Theme = require(script.Parent.Parent.Theme)
local UseAtom = require(Hooks.UseAtom)

local Component = script.Parent.Parent.component
local Button = require(Component.Core.Button)
local Card = require(Component.Core.Card)
local Text = require(Component.Core.Text)

type Props = {
	Parent: UsedAs<Instance?>?,
	Player: string,
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

	local replays = UseAtom(scope, function()
		local state = PlayerState.GetPlayerState(props.Player)

		if state then return state.replays end

		return {}
	end)

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
				Size = UDim2.fromScale(1, 0.15),

				Texture = texture :: any,
				Color = theme.Primary,

				[Children] = {
					scope:New "ScrollingFrame" {
						AnchorPoint = Vector2.one / 2,
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromScale(1, 1),
						CanvasSize = UDim2.new(1, 0, 1, 0),
						AutomaticCanvasSize = Enum.AutomaticSize.X,

						BackgroundTransparency = 1,

						ScrollingDirection = Enum.ScrollingDirection.X,

						[Children] = {
							scope:ForValues(replays, function(a0, a1, value: PlayerState.Replay)
								return Button(scope, {
									AnchorPoint = Vector2.new(0.5, 1),
									Position = UDim2.fromScale(0.5, 1),
									Size = UDim2.new(0, 130, 1, 0),
									Shadow = {
										Offset = UDim2.fromScale(0, -0.05),
										Color = theme.Shadow,
										Ratio = 1,
									},

									Corners = UDim.new(0.15),
									Color = theme.Primary,

									[Children] = {
										scope:New "UIStroke" {
											ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
											StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
											BorderStrokePosition = Enum.BorderStrokePosition.Inner,

											Color = theme.Shadow,
											Thickness = 0.025,
										},
										Text(scope, {
											Size = UDim2.fromScale(1, 1),

											Text = `Date: {value.date}\nTime: {value.time}\nMaze: {value.Algorithms.maze}\nSolver: {value.Algorithms.solver}`,
											TextScaled = true,
											Color = theme.Text,
											Font = Font.fromEnum(Enum.Font.BuilderSansExtraBold),

											Shadow = {
												Offset = UDim2.fromScale(0, -0.05),
												Color = theme.Shadow,
												Ratio = 1,
											},

											[Children] = scope:New "UIStroke" {
												ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
												StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,

												Color = theme.Shadow,
												Thickness = 0.025,
											},
										}),
									},
								})
							end),

							scope:New "UIListLayout" {
								FillDirection = Enum.FillDirection.Horizontal,
								Padding = UDim.new(0, 15),
							} :: any,

							scope:New "UIPadding" {
								PaddingTop = UDim.new(0.05),
								PaddingBottom = UDim.new(0.1),
							} :: any,
						},
					},
				},
			}),
		},
	}
end
