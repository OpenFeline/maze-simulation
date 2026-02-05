--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

local GenTypes = require(ReplicatedStorage.maze.util.GenTypes)

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>

local Components = script.Parent.Parent

local Card = require(Components.Card)
local Component = require(script.Parent)

local STORY_CONTROLS = {
	generator = UILabs.Choose(GenTypes.GenGenerationType(), 1),
	solver = UILabs.Choose(GenTypes.GenSolverType(), 1),
	seed = DateTime.now().UnixTimestampMillis,
}
type Controls = typeof(STORY_CONTROLS)

return UILabs.CreateFusionStory({
	fusion = Fusion,
	controls = STORY_CONTROLS,
}, function(props)
	local scope = props.scope :: Scope
	local controls = props.controls

	Card(scope, {
		Parent = props.target,
		Size = UDim2.fromOffset(200, 200),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),

		[Children] = {
			Component(scope, {
				Parent = props.target,
				value = {
					algorithms = {
						maze = Fusion.peek(controls.generator),
						solver = Fusion.peek(controls.solver),
					},
					seed = controls.seed,
					time = 5 * 60,
				} :: any,

				Size = UDim2.fromScale(0.9, 0.9),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
			}),
		},
	})

	return nil
end)
