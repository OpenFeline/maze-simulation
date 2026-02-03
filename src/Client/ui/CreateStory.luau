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

		-- What in the actual fuck is this - butterfriez
		PlayerState.UpdatePlayerState(CONSTANTS.USER_NAME, function(current)
			current = table.clone(current)
			current.replays = {
				{
					Algorithms = { maze = "RecursiveBacktracker", solver = "AStar" },
					time = 60 * 5,
					date = DateTime.now().UnixTimestampMillis,
				},
				{
					Algorithms = { maze = "RecursiveBacktracker", solver = "AStar" },
					time = 60 * 2,
					date = DateTime.now().UnixTimestampMillis,
				},
				{
					Algorithms = { maze = "RecursiveBacktracker", solver = "AStar" },
					time = 60 * 7,
					date = DateTime.now().UnixTimestampMillis,
				},
				{
					Algorithms = { maze = "RecursiveBacktracker", solver = "AStar" },
					time = 60 * 3,
					date = DateTime.now().UnixTimestampMillis,
				},
				{
					Algorithms = { maze = "RecursiveBacktracker", solver = "AStar" },
					time = 60 * 2,
					date = DateTime.now().UnixTimestampMillis,
				},
				{
					Algorithms = { maze = "RecursiveBacktracker", solver = "AStar" },
					time = 60 * 8,
					date = DateTime.now().UnixTimestampMillis,
				},
			}
			return current
		end)

		storyFunc(props)
	end)
end
