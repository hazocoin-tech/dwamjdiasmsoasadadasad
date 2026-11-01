--[[
================================================================================
HAJIME RISING [ALPHA] — SECURITY TEST GUI BOOTSTRAP
================================================================================
Place this LocalScript in StarterPlayer > StarterPlayerScripts.

It loads the GUI framework and test module, then runs all security tests.
================================================================================
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Wait for player gui
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Load modules from the same folder (require by path won't work in a single
-- LocalScript, so we inline the require logic using the file names if they
-- are ModuleScripts in the same location, or we can just load them directly.
-- For this bootstrap, we expect SecurityTestGUI.lua and SecurityTests.lua to
-- be ModuleScripts siblings of this file.)

local guiModule = script:FindFirstChild("SecurityTestGUI")
local testsModule = script:FindFirstChild("SecurityTests")

if not guiModule or not testsModule then
    warn("[SecurityTestGUI] Missing required sibling modules: SecurityTestGUI, SecurityTests")
    return
end

local GUI = require(guiModule)
local TestRunner = require(testsModule)

-- Build GUI
local gui = GUI:create()

-- Small delay to let UI render
task.wait(0.2)

-- Run all tests
local ok, err = pcall(function()
    TestRunner.run(gui)
end)

if not ok then
    warn("[SecurityTestGUI] Test runner error:", err)
end

print("[SecurityTestGUI] Security test GUI loaded. Tests complete.")
