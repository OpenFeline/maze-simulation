--!strict

local types = require(script.Parent.types)

local theme: types.Theme = {
	Primary = Color3.fromHex("#B6AE9F"),
	Secondary = Color3.fromHex("#C5C7BC"),
	Accent = Color3.new(0.572549, 0.305882, 1),
	Shadow = Color3.fromHex("#4e472e"),
	Text = Color3.new(1, 1, 1),
}
return table.freeze(theme)
