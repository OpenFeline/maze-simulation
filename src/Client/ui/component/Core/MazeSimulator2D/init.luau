--!strict

--[[
    Replay View
]]

local AssetService = game:GetService("AssetService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local BaseGenerator = require(ReplicatedStorage.maze.Generation.BaseGenerator)
local Fusion = require(ReplicatedStorage.Packages.Fusion)
local GetPoints = require(ReplicatedStorage.maze.util.GetPoints)
local MazeConfig = require(ReplicatedStorage.core.MazeConfig)
local PlayerState = require(ReplicatedStorage.state.atoms.PlayerState)
local Spinner = require(StarterPlayer.StarterPlayerScripts.ui.component.Core.Spinner)
local types = require(ReplicatedStorage.maze.types)
local Children = Fusion.Children

local Components = script.Parent.Parent

type Fusion = typeof(Fusion)
type Scope<T = Fusion> = Fusion.Scope<T>
type UsedAs<T> = Fusion.UsedAs<T>
type StateObject<T> = Fusion.UsedAs<T>

local cellPx = MazeConfig.nodeSize
local imgSize = MazeConfig.mazeSize * cellPx
local wallColor = Color3.fromRGB(0, 0, 0)

local Theme = require(script.Parent.Parent.Parent.Theme)

local function GetMazeAlgorithmGen(key: string)
	local mazeGenerator = ReplicatedStorage.maze.Generation:FindFirstChild(key)
	return mazeGenerator
end

local function GetMazeSolverGen(key: string)
	local mazeSolver = ReplicatedStorage.maze.Solvers:FindFirstChild(key)
	return mazeSolver
end

local function cellToPixel(x: number, y: number)
	return Vector2.new((x - 1) * cellPx, (y - 1) * cellPx)
end

local function cellToPixelCenter(x: number, y: number): Vector2
	return cellToPixel(x, y) + Vector2.new(cellPx * 0.5, cellPx * 0.5)
end

local function SolveMaze(image: EditableImage, mazeSolverKey: string, maze: BaseGenerator.BaseGenerator<unknown>)
	local solver = GetMazeSolverGen(mazeSolverKey)
	if not solver then return end

	local success, module = pcall(require, solver)

	if not success then return nil end

	local mazeSolver: any = module.new(maze)

	mazeSolver.OnComplete:connect(function(solutionPath)
		for i = 1, #solutionPath - 1 do
			local currentNode = solutionPath[i]

			image:DrawCircle(
				cellToPixelCenter(currentNode.x, currentNode.y),
				1,
				Color3.fromRGB(0, 255, 0),
				0,
				Enum.ImageCombineType.Add
			)
		end
	end)

	task.spawn(mazeSolver.Solve, mazeSolver)
end

local function DrawMaze(
	image: EditableImage,
	mazeGenKey: string,
	mazeSolveKey: string,
	seed: number,
	render: Fusion.Value<boolean>
)
	render:set(false)

	local generator = GetMazeAlgorithmGen(mazeGenKey)
	if not generator then return end

	local success, module = pcall(require, generator)

	if not success then return nil end

	local mazeGenerator: BaseGenerator.BaseGenerator<unknown> = module.new()

	mazeGenerator.OnComplete:connect(function()
		local maze = mazeGenerator:GetMaze()

		for i, _ in maze do
			for j, n2 in maze do
				local currentNode: types.Node<unknown> = maze[i][j]
				local px = cellToPixel(currentNode.x, currentNode.y)

				local x0, y0 = px.X, px.Y
				local x1, y1 = x0 + cellPx, y0 + cellPx

				if currentNode.open.Up then
					image:DrawLine(
						Vector2.new(x0, y0),
						Vector2.new(x1, y0),
						wallColor,
						0,
						Enum.ImageCombineType.Overwrite
					)
				end

				if currentNode.open.Down then
					image:DrawLine(
						Vector2.new(x0, y1),
						Vector2.new(x1, y1),
						wallColor,
						0,
						Enum.ImageCombineType.Overwrite
					)
				end

				if currentNode.open.Left then
					image:DrawLine(
						Vector2.new(x0, y0),
						Vector2.new(x0, y1),
						wallColor,
						0,
						Enum.ImageCombineType.Overwrite
					)
				end

				if currentNode.open.Right then
					image:DrawLine(
						Vector2.new(x1, y0),
						Vector2.new(x1, y1),
						wallColor,
						0,
						Enum.ImageCombineType.Overwrite
					)
				end
			end
		end

		SolveMaze(image, mazeSolveKey, mazeGenerator)
		local start, goal = GetPoints(mazeGenerator)
		image:DrawCircle(
			cellToPixelCenter(start.x, start.y),
			math.floor(cellPx / 4),
			Color3.fromRGB(0, 0, 255),
			0,
			Enum.ImageCombineType.Overwrite
		)
		render:set(true)
	end)

	task.spawn(mazeGenerator.Generate, mazeGenerator, seed)
end

local Types = Components.Parent.types

local Roblox = require(Types.Roblox)
type Object = Roblox.GuiObject

type MazeSimulatorProps = Object & {
	value: UsedAs<PlayerState.Replay | string>,
}

return function(scope: Scope, props: MazeSimulatorProps): any -- Silence type error for now
	local value = props.value

	if value == "FAKE_REPLAY" or not value then
		return Spinner(scope, {
			Parent = props.Parent,
			Size = UDim2.fromOffset(50, 50),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end

	local theme = Theme.Contextual:now()

	local render = scope:Value(false)

	local image = AssetService:CreateEditableImage({
		Size = Vector2.new(imgSize + 1, imgSize + 1),
	})

	DrawMaze(
		image,
		(value :: PlayerState.Replay).algorithms.maze,
		(value :: PlayerState.Replay).algorithms.solver,
		(value :: PlayerState.Replay).date,
		render
	)

	return scope:Computed(function(use)
		if use(render) then
			return scope:New "ImageLabel" {
				Size = props.Size,
				AnchorPoint = props.AnchorPoint,
				Position = props.Position,
				Parent = props.Parent,
				BackgroundColor3 = theme.Secondary,

				ImageContent = Content.fromObject(image),
			}
		end

		return Spinner(scope, {
			Parent = props.Parent,
			Size = UDim2.fromOffset(50, 50),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
		})
	end)
end
