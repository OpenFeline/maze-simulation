--!strict

-- Services:
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Fusion | Definitions:
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Children = Fusion.Children
local peek = Fusion.peek

-- Fusion | Types:
type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>
type Value<T> = Fusion.Value<T>
type Spring<T> = Fusion.Spring<T>
type Child = Fusion.Child

local SoundManager = require(ReplicatedStorage.libs.SoundManager)
SoundManager.Load(ReplicatedStorage.assets.sounds.Button) --> Load button sounds!

local Components = script.Parent.Parent
local Interactions = require(Components.Parent.state.Interactions)
local Theme = require(Components.Parent.Theme)

local Card = require(Components.Core.Card)

export type Props = Card.Props & {
	-- TODO: Interactable: UsedAs<boolean>?,
	Activated: ((GuiObject) -> ())?,
	Hovered: Value<boolean>?,
	Pressed: Value<boolean>?,
}
type Children = { [typeof(Children)]: Child? }

return function(scope: Scope, props: Props)
	scope = scope:innerScope() :: Scope
	local theme = Theme.Contextual:now()

	local ref = props.__ref
	local hovered = props.Hovered or scope:Value(false) :: Value<boolean>
	local pressed = props.Pressed or scope:Value(false) :: Value<boolean>

	-- Ensure reference Value exists:
	if not ref then
		ref = scope:Value(nil) :: Value<GuiObject?>
		props.__ref = ref
	end

	do -- Handle color hover effects:
		local color = props.Color or theme.Primary
		local goal = scope:Value(peek(color))

		scope:Observer(hovered):onChange(function()
			local hovering = peek(hovered)

			local current = peek(color)
			local highlight = current:Lerp(peek(theme.Shadow), 0.25)
			goal:set(if hovering then highlight else current)
		end)
		props.Color = scope:Spring(goal :: any, 50, 2) :: any
	end

	local card = Card(scope, props :: Card.Props & Children)

	local previous: Scope? = nil
	scope:Observer(ref):onBind(function()
		local object = Fusion.peek(ref) :: GuiObject?
		if not object then return end

		if previous then
			previous:doCleanup()
			previous = nil
		end

		local scope = scope:innerScope() :: Scope
		previous = scope

		scope:insert({
			object.MouseEnter:Connect(function()
				Interactions.Hovered:set(object)
				hovered:set(true)

				SoundManager.Play(SoundManager.Get("hover_btn"))
			end),
			object.MouseLeave:Connect(function()
				Interactions.Hovered:set(nil)
				hovered:set(false)
			end),

			object.InputBegan:Connect(function(input)
				if not Interactions.Activated(input) then return end
				pressed:set(true)
			end),
			object.InputEnded:Connect(function(input)
				if not Interactions.Activated(input) then return end
				if props.Activated then props.Activated(object) end
				pressed:set(false)

				SoundManager.Play(SoundManager.Get("click_btn"))
			end),
		})
	end)

	return card
end
