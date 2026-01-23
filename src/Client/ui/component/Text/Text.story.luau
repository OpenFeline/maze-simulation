--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UILabs = require(ReplicatedStorage.Packages.UILabs)

local Fusion = require(ReplicatedStorage.Packages.Fusion)

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope

local Component = require(script.Parent)

local STORY_CONTROLS = {
	-- Text Controls:
	Text = "Hello World!",
	TextScaled = true,
	Color = Color3.new(1, 1, 1),
	Font = UILabs.EnumList({
		BuilderSans = Font.fromEnum(Enum.Font.BuilderSans),
		Cartoon = Font.fromEnum(Enum.Font.Cartoon),
	}, "BuilderSans"),

	-- Shadow Controls:
	["Shadow: Offset (X)"] = UILabs.Slider(-2.5, -100, 100),
	["Shadow: Offset (Y)"] = UILabs.Slider(-2.5, -100, 100),
	["Shadow: Ratio"] = UILabs.Slider(0.5, 0, 1),
}
type Controls = typeof(STORY_CONTROLS)

return UILabs.CreateFusionStory({
	fusion = Fusion,
	controls = STORY_CONTROLS,
}, function(props)
	local scope = props.scope :: Scope
	local controls = props.controls :: Controls

	local offset = scope:Computed(function(use: any)
		return UDim2.fromOffset(use(controls["Shadow: Offset (X)"]), use(controls["Shadow: Offset (Y)"]))
	end)

	Component(scope, {
		Parent = props.target,

		AnchorPoint = Vector2.one / 2,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.25, 0.25),

		Shadow = { Offset = offset, Ratio = controls["Shadow: Ratio"] :: any },

		Text = controls.Text,
		TextScaled = controls.TextScaled,
		Color = controls.Color,
		Font = controls.Font :: any,
	})

	return nil
end)
