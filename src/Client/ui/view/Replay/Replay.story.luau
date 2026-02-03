--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CONSTANTS = require(ReplicatedStorage.core.CONSTANTS)
local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Fusion = require(ReplicatedStorage.Packages.Fusion)
type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>

local Replay = require(script.Parent)
local Theme = require(script.Parent.Parent.Parent.Theme)

local STORY_CONTROLS = {
	Theme = Theme.Story.Control,
}
type Controls = typeof(STORY_CONTROLS)

return UILabs.CreateFusionStory({
	fusion = Fusion,
	controls = STORY_CONTROLS,
}, function(props)
	local scope = props.scope :: Scope
	local controls = props.controls

	Theme.Story.Apply(scope, controls.Theme, function(scope)
		Replay(scope, { Parent = props.target, Player = CONSTANTS.USER_NAME })
	end)

	return nil
end)
