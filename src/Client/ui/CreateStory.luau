local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CONSTANTS = require(ReplicatedStorage.core.CONSTANTS)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local PlayerState = require(ReplicatedStorage.state.atoms.PlayerState)
local SoundManager = require(ReplicatedStorage.libs.SoundManager)
local UILabs = require(ReplicatedStorage.Packages.UILabs)

return function(storyFunc: (props: UILabs.FusionProps) -> (), controls: any)
	return UILabs.CreateFusionStory({ fusion = Fusion, controls = controls }, function(props)
		SoundManager.LoadSounds(ReplicatedStorage.assets.sounds)
		PlayerState.SetPlayerState(CONSTANTS.USER_NAME, PlayerState.DefaultPlayerState)

		storyFunc(props)
	end)
end
