--!strict

-- Services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Fusion:
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local scope = Fusion:scoped()

local ThemeContainer = script.Parent.themes
local types = require(ThemeContainer.types)
export type Theme = types.Theme

local DEFAULT_THEME_NAME: ThemeName = "Dark"

local Theme = {}

Theme.List = table.freeze {
	Dark = require(ThemeContainer.Dark),
	Light = require(ThemeContainer.Light),
}
export type ThemeName = keyof<typeof(Theme.List)>

--[[
	TODO: Update this value alongside PlayerState...
	We can't pull in PlayerState here because stories depend on
	this ModuleScript. Game state can't be loaded prior to runtime!
]]
Theme.Name = scope:Value(DEFAULT_THEME_NAME)

local dynamic = {} :: types.DynamicTheme
for property in types :: { [string]: Color3 } do
	(dynamic :: any)[property] = scope:Computed(function(use: any)
		local name = use(Theme.Name)
		return (Theme.List :: any)[name][property]
	end)
end

Theme.Contextual = Fusion.Contextual(dynamic)

return Theme
