--[[
Hajime Rising [ALPHA] — Stat / Build Manipulation PoC
UNCONFIRMED server-side: StatsController fires StatsRemote for stat changes but
the client only performs UI-level checks. Stats live as Stat_*, StatLock_*,
StatGoal_*, StatPointsRemaining attributes on LocalPlayer.

Ops: ResetBuild (1 reroll token), Lock(stat,index,bool), Goal(stat,index,value),
ResetStat(stat) (1 token).
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local StatsRemote = ReplicatedStorage:WaitForChild("Boxing"):WaitForChild("StatsRemote")

local function fire(op, ...)
    local ok, err = pcall(function()
        StatsRemote:FireServer(op, ...)
    end)
    print(string.format("[StatsRemote] %s(%s) -> ok=%s %s", op,
        table.concat(table.pack(...), ", "), tostring(ok), tostring(err or "")))
end

-- Uncomment to attempt (server may reject due to token cost / ownership):
-- fire("ResetBuild")                -- reset all stats/skills to 0
-- fire("Lock", "Power", 1, true)    -- lock Power sub-node A
-- fire("Goal", "Stamina", 1, 10)    -- set training goal cap
-- fire("ResetStat", "Power")        -- reset one stat to 0

-- Read current stats locally (client-side, always works)
local function readStats()
    for _, name in ipairs({"Power","Endurance","Stamina","Speed","Technique","Willpower"}) do
        local v = LocalPlayer:GetAttribute("Stat_" .. name)
        if v ~= nil then print(string.format("Stat_%s = %s", name, tostring(v))) end
    end
    local sp = LocalPlayer:GetAttribute("StatPointsRemaining")
    if sp ~= nil then print("StatPointsRemaining =", tostring(sp)) end
end
readStats()

print("StatsRemote ready. Uncomment fire() calls above to attempt stat manipulation.")
