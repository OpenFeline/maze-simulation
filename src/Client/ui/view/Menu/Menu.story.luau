local CreateStory = require(script.Parent.Parent.Parent.CreateStory)

local Menu = require(script.Parent)

return CreateStory(function(props)
	Menu(props.scope, {
		Parent = props.target,
	})
end)
