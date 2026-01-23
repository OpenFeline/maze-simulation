local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DEFAULT_SHADOW_RATIO: number = 0.25

local Fusion = require(ReplicatedStorage.Packages.Fusion)

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>
type StateObject<T> = Fusion.StateObject<T>

export type Shadow = {
	Offset: UsedAs<UDim2>,
	Color: UsedAs<Color3>?,
	Ratio: UsedAs<number>?,
}

return {
	Color = function(scope: Scope, shadow: Shadow, color: UsedAs<Color3>): StateObject<Color3>
		local ratio = shadow.Ratio or DEFAULT_SHADOW_RATIO
		return scope:Computed(function(use: any)
			local h, s, v = (use(shadow.Color or color) :: Color3):ToHSV()
			local ratio = use(ratio) :: number
			return Color3.fromHSV(h, s, v * ratio)
		end)
	end,
	Position = function(scope: Scope, shadow: Shadow, position: UsedAs<UDim2>): StateObject<UDim2>
		return scope:Computed(function(use: any)
			local offset = use(shadow.Offset)
			return use(position) + offset
		end)
	end,
}
