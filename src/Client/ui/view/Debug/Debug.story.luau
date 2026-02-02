local CreateStory = require(script.Parent.Parent.Parent.CreateStory)

local Debug = require(script.Parent)

local FAKE_DEBUG_STATES: { [string]: unknown }
do
	local cyclic = {}
	cyclic.self = cyclic

	FAKE_DEBUG_STATES = {
		coins = 0,
		name = "Roblox",
		module = cyclic,
		set = {
			A = true,
			B = true,
			C = false,
		},
		array = { { value = BrickColor.Red() }, { value = BrickColor.Yellow() }, { value = BrickColor.Blue() } },
	}
end

return CreateStory(function(props)
	Debug(props.scope, {
		Parent = props.target,
		State = FAKE_DEBUG_STATES,
	})
end)
