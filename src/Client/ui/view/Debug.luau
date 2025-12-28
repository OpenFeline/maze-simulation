--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local fusion = require(ReplicatedStorage.Packages.fusion)

type Fusion = typeof(fusion)
type Scope<T> = fusion.Scope<T>
type UsedAs<T> = fusion.UsedAs<T>

type Props = {
    Parent: UsedAs<Instance?>?
}

return function (scope: Scope<Fusion>, props: Props)
    return scope:New "ScreenGui" {
        Name = "Debug [View]",
        Parent = props.Parent
    }
end