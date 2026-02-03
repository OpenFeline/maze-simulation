local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CONSTANTS = require(ReplicatedStorage.core.CONSTANTS)
local CreateStory = require(script.Parent.Parent.Parent.CreateStory)

local Replay = require(script.Parent)

return CreateStory(function(props)
	Replay(props.scope, { Parent = props.target, Player = CONSTANTS.USER_NAME })
end)
