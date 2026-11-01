--[[
Hajime Rising [ALPHA] — Technique Cooldown Bypass PoC
CONFIRMED client-side: TechniqueController stores cooldowns as LOCAL attributes
(Cooldown_<name>, TechniqueUntil) and clears them locally. A malicious client can
ignore them and spam TechniqueRemote:FireServer("Use", ...).
UNCONFIRMED server-side: the server may still reject rapid "Use" calls.
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local TechniqueRemote = ReplicatedStorage:WaitForChild("Boxing"):WaitForChild("TechniqueRemote")

-- Clear locally-stored cooldown / lock attributes so the client UI won't block input
local function clearLocalCooldowns()
    local count = 0
    for _, attr in ipairs(LocalPlayer:GetAttributes()) do
        local name = attr.Name
        if name == "TechniqueUntil" or name:match("^Cooldown_") then
            LocalPlayer:SetAttribute(name, 0)
            count += 1
        end
    end
    print(string.format("Cleared %d local cooldown/lock attributes", count))
end

clearLocalCooldowns()

-- Re-clear periodically in case the script or other systems rewrite them
task.spawn(function()
    while true do
        clearLocalCooldowns()
        task.wait(1)
    end
end)

-- Spam a technique every frame (server should enforce cooldown/stamina if secure)
local technique = "Dempsey Roll"   -- change to any entry in BoxingTechniques.List
print("Spamming technique:", technique, "(watch for server rejection)")

task.spawn(function()
    while true do
        pcall(function()
            TechniqueRemote:FireServer("Use", technique, nil)
        end)
        task.wait(0.05) -- 20/sec; lower if server rate-limits
    end
end)

-- Optional: counter-pick spam
-- task.spawn(function()
--     while true do
--         pcall(function()
--             TechniqueRemote:FireServer("CounterPick", "Hook")
--             TechniqueRemote:FireServer("CounterPick", "Uppercut")
--         end)
--         task.wait(0.1)
--     end
-- end)
