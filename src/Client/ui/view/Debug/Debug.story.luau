local ReplicatedStorage = game:GetService("ReplicatedStorage")

local fusion = require(ReplicatedStorage.Packages.fusion)
local labs = require(ReplicatedStorage.Packages:FindFirstChild("ui-labs"))

local PlayerState = require(ReplicatedStorage.state.atoms.PlayerState)

local DebugView = require(script.Parent)

local FAKE_DEBUG_STATES do
    local cyclic = {}
    cyclic.self = cyclic

    FAKE_DEBUG_STATES = {
        coins = 0,
        name = "Roblox",
        module = cyclic,
        set = {
            A = true,
            B = true,
            C = false
        },
        array = { { value = BrickColor.Red() }, { value = BrickColor.Yellow() }, { value = BrickColor.Blue() } }
    }
end

return labs.CreateFusionStory({
    fusion = fusion,
}, function (props)
    DebugView(props.scope, {
        Parent = props.target,
        States = FAKE_DEBUG_STATES
    })
end)