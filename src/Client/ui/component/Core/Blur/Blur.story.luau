--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Fusion = require(ReplicatedStorage.Packages.Fusion)

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>

local Component = require(script.Parent)

local STORY_CONTROLS = {}
type Controls = typeof(STORY_CONTROLS)

return UILabs.CreateFusionStory({
	fusion = Fusion,
	controls = STORY_CONTROLS,
}, function(props)
	local scope = props.scope :: Scope

	Component(scope, {
		Parent = props.target,
	})

	return nil
end)
