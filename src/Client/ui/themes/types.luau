--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Fusion = require(ReplicatedStorage.Packages.Fusion)

type ThemeLayout<T> = {
	Primary: T,
	Secondary: T,
	Accent: T,
	Shadow: T,
	Text: T,
}

export type Theme = ThemeLayout<Color3>
export type DynamicTheme = ThemeLayout<Fusion.StateObject<Color3>>

local PLACEHOLDER_COLOR: Color3 = Color3.new()

local placeholder: Theme = {
	Primary = PLACEHOLDER_COLOR,
	Secondary = PLACEHOLDER_COLOR,
	Accent = PLACEHOLDER_COLOR,
	Shadow = PLACEHOLDER_COLOR,
	Text = PLACEHOLDER_COLOR,
}
return placeholder
