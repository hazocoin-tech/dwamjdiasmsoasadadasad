--[[
================================================================================
HAJIME RISING [ALPHA] — SECURITY TEST DEFINITIONS
================================================================================
All tests are SAFE by design:
  * No state-modifying remote is ever invoked with arguments that grant
    currency, rerolls, admin powers, or target other players.
  * Each remote is invoked at most once (no spam).
  * Tests that would modify state are reported as INCONCLUSIVE with a
    clear safety note, not skipped silently.

Usage: require this module from a LocalScript, then call SecurityTests.run(gui)
================================================================================
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local TestRunner = {}
TestRunner.results = {}

-- Safe wrapper: invoke once, capture response, never modify state
local function safeInvoke(remote, op, ...)
    if not remote then
        return false, nil, "REMOTE_MISSING"
    end
    local ok, a, b = pcall(function()
        return remote:InvokeServer(op, ...)
    end)
    return ok, a, tostring(b)
end

local function safeFire(remote, op, ...)
    if not remote then
        return false, "REMOTE_MISSING"
    end
    local ok, err = pcall(function()
        remote:FireServer(op, ...)
    end)
    return ok, tostring(err)
end

local function readAttr(attr)
    local ok, val = pcall(function() return LocalPlayer:GetAttribute(attr) end)
    return ok, val
end

--------------------------------------------------------------------------------
-- MAIN RUNNER
--------------------------------------------------------------------------------

function TestRunner.run(gui)
    local descCache = {}

    local R = function(testName, section, remoteName, status, response, note, args)
        gui:testRow(gui.tabs[section].list, testName, descCache[testName] or "", remoteName, status, response, note, args)
        TestRunner.results[testName] = { status = status, response = response, note = note }
    end

    local Boxing = ReplicatedStorage:WaitForChild("Boxing", 10)
    local remotes = {}
    if Boxing then
        remotes = {
            AdminPanel = Boxing:FindFirstChild("AdminPanelRemote"),
            Atm        = Boxing:FindFirstChild("AtmRemote"),
            Survival   = Boxing:FindFirstChild("SurvivalRemote"),
            Stats      = Boxing:FindFirstChild("StatsRemote"),
            Boxing     = Boxing:FindFirstChild("BoxingRemote"),
            Technique  = Boxing:FindFirstChild("TechniqueRemote"),
            Sparring   = Boxing:FindFirstChild("SparringRemote"),
            Avatar     = Boxing:FindFirstChild("AvatarRemote"),
            Gear       = Boxing:FindFirstChild("GearRemote"),
            Loadout    = Boxing:FindFirstChild("LoadoutRemote"),
            License    = Boxing:FindFirstChild("LicenseRemote"),
            Visibility = Boxing:FindFirstChild("VisibilityRemote"),
        }
    end

    -- ========================================================================
    -- DASHBOARD
    -- ========================================================================

    local dashFrame, dashList = gui:addTab("Dashboard", 1)

    -- Player info
    local infoRow = Instance.new("Frame")
    infoRow.Size = UDim2.new(1, 0, 0, 60)
    infoRow.BackgroundTransparency = 1
    infoRow.Parent = dashList

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 16)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "Player: " .. LocalPlayer.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 15
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = infoRow

    local idLabel = Instance.new("TextLabel")
    idLabel.Size = UDim2.new(1, 0, 0, 16)
    idLabel.Position = UDim2.new(0, 0, 0, 20)
    idLabel.BackgroundTransparency = 1
    idLabel.Text = "UserId: " .. tostring(LocalPlayer.UserId)
    idLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
    idLabel.Font = Enum.Font.Gotham
    idLabel.TextSize = 12
    idLabel.TextXAlignment = Enum.TextXAlignment.Left
    idLabel.Parent = infoRow

    local roleLabel = Instance.new("TextLabel")
    roleLabel.Size = UDim2.new(1, 0, 0, 16)
    roleLabel.Position = UDim2.new(0, 0, 0, 40)
    roleLabel.BackgroundTransparency = 1
    roleLabel.Text = "Admin Role: Detecting..."
    roleLabel.TextColor3 = Color3.fromRGB(230, 200, 90)
    roleLabel.Font = Enum.Font.GothamBold
    roleLabel.TextSize = 13
    roleLabel.TextXAlignment = Enum.TextXAlignment.Left
    roleLabel.Parent = infoRow

    -- Read-only role detection
    local ap = remotes.AdminPanel
    if ap then
        local ok, roleData, err = safeInvoke(ap, "Role")
        if ok and type(roleData) == "table" then
            roleLabel.Text = "Admin Role: " .. tostring(roleData.Role or "none")
            roleLabel.TextColor3 = Color3.fromRGB(120, 230, 130)
            R("Role Detection", "Dashboard", "AdminPanelRemote", "PASS",
                "Returned role data: " .. tostring(roleData.Role),
                "Server responded with caller role information. Read-only.", "Role")
        else
            roleLabel.Text = "Admin Role: undetected"
            roleLabel.TextColor3 = Color3.fromRGB(255, 90, 90)
            R("Role Detection", "Dashboard", "AdminPanelRemote", "FAIL",
                err or "No role data returned",
                "Server did not return role table. Either not admin or remote rejects callers.", "Role")
        end
    else
        roleLabel.Text = "Admin Role: REMOTE MISSING"
        roleLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
        R("Role Detection", "Dashboard", "AdminPanelRemote", "INCONCLUSIVE",
            "Remote not found in ReplicatedStorage.Boxing",
            "Cannot detect admin role without AdminPanelRemote.", "Role")
    end

    -- Server scripts notice
    local notice = Instance.new("TextLabel")
    notice.Size = UDim2.new(1, 0, 0, 40)
    notice.Position = UDim2.new(0, 0, 0, 110)
    notice.BackgroundTransparency = 1
    notice.TextWrapped = true
    notice.Text = "NOTE: This place dump has no ServerScriptService. All PASS/FAIL verdicts\nare based on client-side behavior and remote responses only. Server-side\nvalidation cannot be confirmed from this dump alone."
    notice.TextColor3 = Color3.fromRGB(160, 160, 170)
    notice.Font = Enum.Font.Code
    notice.TextSize = 11
    notice.TextXAlignment = Enum.TextXAlignment.Left
    notice.Parent = dashList

    -- ========================================================================
    -- ADMIN PERMISSIONS
    -- ========================================================================

    local adminFrame, adminList = gui:addTab("Admin Permissions", 2)

    local function adminTest(testName, remote, op, args, safetyNote, shouldInvoke)
        descCache[testName] = safetyNote
        if not remote then
            R(testName, "Admin Permissions", op, "INCONCLUSIVE",
                "REMOTE_MISSING", safetyNote .. " Remote not found.", args)
            return
        end
        if not shouldInvoke then
            R(testName, "Admin Permissions", op, "INCONCLUSIVE",
                "SKIPPED (safety)", safetyNote .. " Not invoked to avoid state modification.", args)
            return
        end
        local ok, resp, err = safeInvoke(remote, op, unpack(args or {}))
        local status = ok and "PASS" or "FAIL"
        R(testName, "Admin Permissions", op, status,
            tostring(resp or err), safetyNote, args)
    end

    -- Give Yen - SKIP (grants currency)
    adminTest("Give Yen", remotes.AdminPanel, "GiveYen",
        {LocalPlayer.UserId, 1},
        "Would grant ¥1 to a player. Skipped per safety policy.",
        false)

    -- Give Rerolls - SKIP (grants rerolls)
    adminTest("Give Rerolls", remotes.AdminPanel, "GiveRerolls",
        {LocalPlayer.UserId, 1},
        "Would grant 1 reroll token. Skipped per safety policy.",
        false)

    -- Fly - check remote exists; invoking Fly(false) is a no-op safe state
    descCache["Admin Fly"] = "Toggles local admin flight. Not invoked (modifies player state)."
    if remotes.AdminPanel then
        R("Admin Fly", "Admin Permissions", "AdminPanelRemote", "INCONCLUSIVE",
            "REMOTE_EXISTS_ONLY",
            "Remote exists. Fly() not invoked to avoid granting admin movement.",
            "Fly")
    else
        R("Admin Fly", "Admin Permissions", "AdminPanelRemote", "INCONCLUSIVE",
            "REMOTE_MISSING", "AdminPanelRemote not found.", "Fly")
    end

    -- Noclip
    descCache["Admin Noclip"] = "Toggles local admin noclip. Not invoked."
    if remotes.AdminPanel then
        R("Admin Noclip", "Admin Permissions", "AdminPanelRemote", "INCONCLUSIVE",
            "REMOTE_EXISTS_ONLY",
            "Remote exists. Noclip() not invoked to avoid granting admin noclip.",
            "Noclip")
    else
        R("Admin Noclip", "Admin Permissions", "AdminPanelRemote", "INCONCLUSIVE",
            "REMOTE_MISSING", "AdminPanelRemote not found.", "Noclip")
    end

    -- Build Tools
    descCache["Build Tools"] = "Grants move/clone/delete of workspace parts. Not invoked."
    if remotes.AdminPanel then
        R("Build Tools", "Admin Permissions", "AdminPanelRemote", "INCONCLUSIVE",
            "REMOTE_EXISTS_ONLY",
            "Remote exists. BTools() not invoked to avoid granting build tools.",
            "BTools")
    else
        R("Build Tools", "Admin Permissions", "AdminPanelRemote", "INCONCLUSIVE",
            "REMOTE_MISSING", "AdminPanelRemote not found.", "BTools")
    end

    -- Kick - SKIP (targets player)
    adminTest("Kick Player", remotes.AdminPanel, "Kick",
        {0}, -- placeholder UserId, not invoked
        "Would kick a player. Skipped per safety policy (targets other players).",
        false)

    -- Ban - SKIP (targets player)
    adminTest("Ban Player", remotes.AdminPanel, "Ban",
        {0, 1, "test"},
        "Would ban a player. Skipped per safety policy (targets other players).",
        false)

    -- Fling - SKIP (targets player / physics abuse)
    adminTest("Fling Player", remotes.AdminPanel, "Fling",
        {0},
        "Would fling a player. Skipped per safety policy (targets other players / physics).",
        false)

    -- Server Message - SKIP (sends server-wide message)
    adminTest("Server Message", remotes.AdminPanel, "ServerMessage",
        {"security test"},
        "Would broadcast a message to the server. Skipped per safety policy.",
        false)

    -- Global Message - SKIP (sends cross-server message)
    adminTest("Global Message", remotes.AdminPanel, "GlobalMessage",
        {"security test"},
        "Would broadcast globally. Skipped per safety policy.",
        false)

    -- ========================================================================
    -- ECONOMY
    -- ========================================================================

    local econFrame, econList = gui:addTab("Economy", 3)

    -- ATM State (READ-ONLY, safe)
    descCache["ATM State"] = "Reads current ATM transfer state (cap, sent today, min/max)."
    if remotes.Atm then
        local ok, state, err = safeInvoke(remotes.Atm, "State")
        if ok and type(state) == "table" then
            R("ATM State", "Economy", "AtmRemote", "PASS",
                "Returned state table",
                "Read-only. State: cap=" .. tostring(state.Cap) ..
                ", sentToday=" .. tostring(state.SentToday) ..
                ", min=" .. tostring(state.Min) .. ", max=" .. tostring(state.Max),
                "State")
        else
            R("ATM State", "Economy", "AtmRemote", "FAIL",
                err or "No state table returned",
                "Server did not return valid ATM state.", "State")
        end
    else
        R("ATM State", "Economy", "AtmRemote", "INCONCLUSIVE",
            "REMOTE_MISSING", "AtmRemote not found.", "State")
    end

    -- ATM Send - SKIP (transfers yen)
    descCache["ATM Send"] = "Transfers yen to another player. Skipped per safety policy."
    if remotes.Atm then
        R("ATM Send", "Economy", "AtmRemote", "INCONCLUSIVE",
            "SKIPPED (safety)",
            "Would send yen via InvokeServer('Send', UserId, amount). Not invoked.",
            "Send")
    else
        R("ATM Send", "Economy", "AtmRemote", "INCONCLUSIVE",
            "REMOTE_MISSING", "AtmRemote not found.", "Send")
    end

    -- Shop Buy - SKIP (spends currency / grants items)
    descCache["Shop Buy"] = "Purchases shop items. Skipped per safety policy."
    if remotes.Survival then
        R("Shop Buy", "Economy", "SurvivalRemote", "INCONCLUSIVE",
            "SKIPPED (safety)",
            "Would call FireServer('Buy', itemId, name). Not invoked to avoid spending currency.",
            "Buy")
    else
        R("Shop Buy", "Economy", "SurvivalRemote", "INCONCLUSIVE",
            "REMOTE_MISSING", "SurvivalRemote not found.", "Buy")
    end

    -- Stat Reset - SKIP (modifies stats)
    descCache["Stat Reset"] = "Resets stats/skills. Skipped per safety policy."
    if remotes.Stats then
        R("Stat Reset", "Economy", "StatsRemote", "INCONCLUSIVE",
            "SKIPPED (safety)",
            "Would call FireServer('ResetBuild') or FireServer('ResetStat', ...). Not invoked.",
            "ResetBuild/ResetStat")
    else
        R("Stat Reset", "Economy", "StatsRemote", "INCONCLUSIVE",
            "REMOTE_MISSING", "StatsRemote not found.", "ResetBuild")
    end

    -- Stat Lock - SKIP (modifies stats)
    descCache["Stat Lock"] = "Locks/unlocks stat training. Skipped per safety policy."
    if remotes.Stats then
        R("Stat Lock", "Economy", "StatsRemote", "INCONCLUSIVE",
            "SKIPPED (safety)",
            "Would call FireServer('Lock', stat, index, bool). Not invoked.",
            "Lock")
    else
        R("Stat Lock", "Economy", "StatsRemote", "INCONCLUSIVE",
            "REMOTE_MISSING", "StatsRemote not found.", "Lock")
    end

    -- Stat Goal - SKIP (modifies stats)
    descCache["Stat Goal"] = "Sets training goal caps. Skipped per safety policy."
    if remotes.Stats then
        R("Stat Goal", "Economy", "StatsRemote", "INCONCLUSIVE",
            "SKIPPED (safety)",
            "Would call FireServer('Goal', stat, index, value). Not invoked.",
            "Goal")
    else
        R("Stat Goal", "Economy", "StatsRemote", "INCONCLUSIVE",
            "REMOTE_MISSING", "StatsRemote not found.", "Goal")
    end

    -- ========================================================================
    -- TRAINING
    -- ========================================================================

    local trainFrame, trainList = gui:addTab("Training", 4)

    -- Check if training remotes exist (read-only)
    descCache["Train Press"] = "Part of timing minigame. Remote exists check only."
    if remotes.Boxing then
        R("Train Press", "Training", "BoxingRemote", "INCONCLUSIVE",
            "REMOTE_EXISTS_ONLY",
            "BoxingRemote exists. TrainPress() not invoked (modifies training state).",
            "TrainPress")
    else
        R("Train Press", "Training", "BoxingRemote", "INCONCLUSIVE",
            "REMOTE_MISSING", "BoxingRemote not found.", "TrainPress")
    end

    -- Cooldown attribute check (READ-ONLY, client-side)
    local ok, cdVal = readAttr("Cooldown_Dempsey Roll")
    descCache["Cooldown Attributes"] = "Reads local cooldown attributes (client-side only)."
    if ok then
        R("Cooldown Attributes", "Training", "LocalPlayer:GetAttribute", "PASS",
            tostring(cdVal),
            "Client-side attribute read. Cooldown_Dempsey Roll = " .. tostring(cdVal) ..
            ". These are LOCAL attributes; server enforcement cannot be confirmed.",
            "GetAttribute")
    else
        R("Cooldown Attributes", "Training", "LocalPlayer:GetAttribute", "FAIL",
            tostring(cdVal), "Failed to read attribute.", "GetAttribute")
    end

    -- Technique Until attribute check
    local ok2, tuVal = readAttr("TechniqueUntil")
    descCache["TechniqueUntil Attribute"] = "Reads local technique lock attribute."
    if ok2 then
        R("TechniqueUntil Attribute", "Training", "LocalPlayer:GetAttribute", "PASS",
            tostring(tuVal),
            "Client-side attribute read. TechniqueUntil = " .. tostring(tuVal) ..
            ". Local-only; does not confirm server cooldown enforcement.",
            "GetAttribute")
    else
        R("TechniqueUntil Attribute", "Training", "LocalPlayer:GetAttribute", "FAIL",
            tostring(tuVal), "Failed to read attribute.", "GetAttribute")
    end

    -- ========================================================================
    -- COMBAT
    -- ========================================================================

    local combatFrame, combatList = gui:addTab("Combat", 5)

    -- Punch - remote exists check (normal gameplay, but might affect sparring target)
    descCache["Combat Punch"] = "Sends punch data to server. Remote exists check only."
    if remotes.Boxing then
        R("Combat Punch", "Combat", "BoxingRemote", "INCONCLUSIVE",
            "REMOTE_EXISTS_ONLY",
            "BoxingRemote exists. Punch() not invoked to avoid affecting sparring targets.",
            "Punch")
    else
        R("Combat Punch", "Combat", "BoxingRemote", "INCONCLUSIVE",
            "REMOTE_MISSING", "BoxingRemote not found.", "Punch")
    end

    -- Block - remote exists check
    descCache["Combat Block"] = "Sends block state to server. Remote exists check only."
    if remotes.Boxing then
        R("Combat Block", "Combat", "BoxingRemote", "INCONCLUSIVE",
            "REMOTE_EXISTS_ONLY",
            "BoxingRemote exists. Block() not invoked to avoid affecting combat state.",
            "Block")
    else
        R("Combat Block", "Combat", "BoxingRemote", "INCONCLUSIVE",
            "REMOTE_MISSING", "BoxingRemote not found.", "Block")
    end

    -- Parry - remote exists check
    descCache["Combat Parry"] = "Sends parry to server. Remote exists check only."
    if remotes.Boxing then
        R("Combat Parry", "Combat", "BoxingRemote", "INCONCLUSIVE",
            "REMOTE_EXISTS_ONLY",
            "BoxingRemote exists. Parry() not invoked.", "Parry")
    else
        R("Combat Parry", "Combat", "BoxingRemote", "INCONCLUSIVE",
            "REMOTE_MISSING", "BoxingRemote not found.", "Parry")
    end

    -- Technique Use - remote exists check
    descCache["Technique Use"] = "Uses a combat technique. Remote exists check only."
    if remotes.Technique then
        R("Technique Use", "Combat", "TechniqueRemote", "INCONCLUSIVE",
            "REMOTE_EXISTS_ONLY",
            "TechniqueRemote exists. Use() not invoked to avoid cooldown/stamina bypass testing.",
            "Use")
    else
        R("Technique Use", "Combat", "TechniqueRemote", "INCONCLUSIVE",
            "REMOTE_MISSING", "TechniqueRemote not found.", "Use")
    end

    -- ========================================================================
    -- RESULTS SUMMARY
    -- ========================================================================

    local resultsFrame, resultsList = gui:addTab("Results Summary", 5)

    local function countStatus(status)
        local n = 0
        for _, r in pairs(TestRunner.results) do
            if r.status == status then n += 1 end
        end
        return n
    end

    local total = 0
    for _ in pairs(TestRunner.results) do total += 1 end

    local passCount = countStatus("PASS")
    local failCount = countStatus("FAIL")
    local incCount = countStatus("INCONCLUSIVE")

    local summaryText = string.format(
        "Total Tests: %d  |  PASS: %d  |  FAIL: %d  |  INCONCLUSIVE: %d",
        total, passCount, failCount, incCount
    )

    local summaryLabel = Instance.new("TextLabel")
    summaryLabel.Size = UDim2.new(1, 0, 0, 24)
    summaryLabel.BackgroundTransparency = 1
    summaryLabel.Text = summaryText
    summaryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    summaryLabel.Font = Enum.Font.GothamBold
    summaryLabel.TextSize = 14
    summaryLabel.TextXAlignment = Enum.TextXAlignment.Left
    summaryLabel.Parent = resultsList

    local noteLabel = Instance.new("TextLabel")
    noteLabel.Size = UDim2.new(1, 0, 0, 60)
    noteLabel.Position = UDim2.new(0, 0, 0, 30)
    noteLabel.BackgroundTransparency = 1
    noteLabel.TextWrapped = true
    noteLabel.Text = "CONFIRMED VULNERABILITIES: None confirmed from client-side dump alone.\n\nREJECTED HYPOTHESES: None (no remote was invoked with modifying arguments).\n\nTESTS REQUIRING SERVER ACCESS: All admin grant/modify tests (GiveYen, GiveRerolls,\nFly, Noclip, BTools, Kick, Ban, Fling, Shop Buy, ATM Send, Stat Reset, Lock, Goal).\nServer-side validation cannot be confirmed without ServerScriptService."
    noteLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
    noteLabel.Font = Enum.Font.Code
    noteLabel.TextSize = 11
    noteLabel.TextXAlignment = Enum.TextXAlignment.Left
    noteLabel.Parent = resultsList

    -- Auto-switch to dashboard
    gui:switchTab("Dashboard")
end

return TestRunner