--[[
Hajime Rising [ALPHA] — Debug Teleport _G.place PoC
CONFIRMED: ReplicatedStorage/_TestHarnessClient.luau defines _G.place(p1), which
teleports the local player's HumanoidRootPart relative to workspace.BoxingDummies.TestDummy,
zeroes velocity, and snaps the camera.
UNCONFIRMED activation: nothing in this dump require()s _TestHarnessClient, so
_G.place may not exist unless another script loads it.
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local harness = ReplicatedStorage:WaitForChild("_TestHarnessClient", 5)
if harness then
    local ok, fn = pcall(function() return require(harness) end)
    if ok and type(fn) == "function" then
        fn() -- defines _G.place
        print("_G.place defined via _TestHarnessClient")
    else
        warn("Failed to require _TestHarnessClient:", tostring(fn))
    end
else
    warn("_TestHarnessClient not found in ReplicatedStorage")
end

-- Usage examples (only if _G.place was defined):
-- _G.place(0)  -- teleport onto the test dummy
-- _G.place(5)  -- teleport 5 studs in front of it

if _G and type(_G.place) == "function" then
    print("Ready: call _G.place(studs) to teleport to the BoxingDummies test dummy.")
else
    print("_G.place not available (harness not loaded).")
end

-- Convenience: teleport now if dummy exists
task.delay(1, function()
    if _G and type(_G.place) == "function" then
        local dummy = workspace:FindFirstChild("BoxingDummies") and workspace.BoxingDummies:FindFirstChild("TestDummy")
        if dummy then
            print("TestDummy found. Teleporting...")
            _G.place(3)
        end
    end
end)
