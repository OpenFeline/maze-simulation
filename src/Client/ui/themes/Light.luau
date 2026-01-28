--!strict

local types = require(script.Parent.types)

local theme: types.Theme = {
	Primary = Color3.fromHex("#FAFAFA"),
	Secondary = Color3.fromHex("#E3F2FD"),
	Accent = Color3.new(1, 0.439216, 0.180392),
	Shadow = Color3.fromHex("#777777"),
	Text = Color3.new(0.2, 0.196078, 0.192157),
}
return theme
