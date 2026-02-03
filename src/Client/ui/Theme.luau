--!strict

-- Services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Fusion:
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local scope = Fusion:scoped()
local peek = Fusion.peek

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type StateObject<T> = Fusion.StateObject<T>

local PlayerState = require(script.Parent.state.PlayerState)

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

Theme.Name = scope:Computed(function(use: any)
	local state: PlayerState.PlayerState = use(PlayerState.current)
	return if state then state.uiTheme else DEFAULT_THEME_NAME
end)

local dynamic = {} :: types.DynamicTheme
for property in types :: { [string]: Color3 } do
	(dynamic :: any)[property] = scope:Computed(function(use: any)
		local name = use(Theme.Name)
		return (Theme.List :: any)[name][property]
	end)
end

Theme.Contextual = Fusion.Contextual(dynamic :: Theme)

do
	local module = ReplicatedStorage.Packages:FindFirstChild("UILabs")
	if module then
		local UILabs = require(module)
		Theme.Story = table.freeze {
			Control = UILabs.EnumList(Theme.List :: any, DEFAULT_THEME_NAME),
			Apply = function(scope: Scope, theme: StateObject<Theme>, func: (scope: Scope) -> ())
				local tempScope: Scope? = nil
				scope:Observer(theme):onBind(function()
					local current = peek(theme)

					if tempScope then
						tempScope:doCleanup()
						tempScope = nil
					end

					Theme.Contextual:is(current):during(function()
						tempScope = scope:innerScope() :: Scope
						func(tempScope)
					end :: any)
				end)
			end,
		}
	end
end

return Theme
