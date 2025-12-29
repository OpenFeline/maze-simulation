local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local PlayerState = require(ReplicatedStorage.state.atoms.PlayerState)
local DataHandlers = require(ServerStorage.Data)

Players.PlayerAdded:Connect(function(player)
	local key = player.Name
	DataHandlers.LoadData(player)
	PlayerState.SetPlayerState(key, PlayerState.DefaultPlayerState)

	local data = DataHandlers.GetPlayerData(key)

	PlayerState.UpdatePlayerState(key, function(currentState: PlayerState.PlayerState)
		currentState = table.clone(currentState)
		currentState.coins = data.coins
		currentState.algorithms = {
			maze = data.mazeGenerationAlgorithm,
			solver = data.mazeSolverAlgorithm,
		}

		return currentState -- forgot to return this so it caused me to debug why playerstate wasn't being set for an hour looooooooooool
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	DataHandlers.SavePlayerData(player.Name)
end)
