local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.maze.types)

export type BaseSolver<NodeMeta> = {
	solve: (self: BaseSolver<NodeMeta>) -> { types.Node<NodeMeta> }, -- path
}

return {}
