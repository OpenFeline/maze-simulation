--!strict

--[[
    Generates a sourcemap from an active project sync tool: Rojo or Argon.
    Then installs packages via wally, re-typing them with wally-package-types.
]]

local process = require("@lune/process")

local PROJECT_FILE = "default.project.json"
local PROJECT_SYNC_TOOLS = { "rojo", "argon" }
local EXC_OPTIONS: process.ExecOptions = { stdio = "forward" }

for _, tool in PROJECT_SYNC_TOOLS do
    local success, result = pcall(process.exec, tool, {"sourcemap", "--output", "sourcemap.json", PROJECT_FILE})
    if success and result.ok then break end
end

process.exec("wally", {"install"}, EXC_OPTIONS)
process.exec("wally-package-types", {"--sourcemap", "sourcemap.json", "Packages"}, EXC_OPTIONS)
