local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Sift = require(ReplicatedStorage.Packages.Sift)
local Dictionary = Sift.Dictionary

local Fusion = require(ReplicatedStorage.Packages.Fusion)
type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>

local Menu = require(script.Parent)
local Theme = require(script.Parent.Parent.Parent.Theme)

local STORY_CONTROLS = {
	Theme = Theme.Story.Control,
}
type Controls = typeof(STORY_CONTROLS) & typeof(Theme.Story.Controls)

return UILabs.CreateFusionStory({
	fusion = Fusion,
	controls = Dictionary.join(STORY_CONTROLS, Theme.Story.Controls) :: any,
}, function(props)
	local scope = props.scope :: Scope
	local controls = props.controls :: Controls

	Theme.Story.Apply(scope, controls.Theme, function(scope)
		Menu(scope, { Parent = props.target })
	end)
end)
