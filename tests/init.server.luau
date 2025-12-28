--!nocheck

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local testez = require(ReplicatedStorage.DevPackages.testez)

if RunService:IsStudio() then
	testez.TestBootstrap:run({ script.Parent }, testez.Reporters.TextReporterQuiet)
end
