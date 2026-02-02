local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Charm = require(ReplicatedStorage.Packages.Charm)

return function<T>(scope, selector: () -> T)
	local state = scope:Value(selector())
	local disconnect = Charm.subscribe(selector, function(v)
		state:set(v)
	end)
	table.insert(scope, disconnect)
	return state
end
