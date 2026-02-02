local CreateStory = require(script.Parent.Parent.Parent.CreateStory)

local Replay = require(script.Parent)

return CreateStory(function(props)
	Replay(props.scope, { Parent = props.target })
end)
