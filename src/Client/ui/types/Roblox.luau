--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children

type UsedAs<T> = Fusion.UsedAs<T>
type Child = Fusion.Child

export type GuiObject = {
	Parent: UsedAs<Instance>?,
	AnchorPoint: UsedAs<Vector2>?,
	Position: UsedAs<UDim2>?,
	Size: UsedAs<UDim2>?,
}
export type Children = { [typeof(Children)]: Child }

return {}
