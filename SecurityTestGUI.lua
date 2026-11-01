--[[
================================================================================
HAJIME RISING [ALPHA] — SECURITY TESTING GUI
================================================================================
Authorized security testing tool. SAFE BY DESIGN:
  * Never targets other players (no kick/ban/fling/GMs on others)
  * Never grants currency, rerolls, or admin privileges
  * Never spams remotes (one invocation per test)
  * Prefer read-only tests; modifying tests are skipped with INCONCLUSIVE
  * Reports which tests cannot be completed due to missing server scripts

Usage: Place as a LocalScript in StarterPlayer > StarterPlayerScripts.
================================================================================
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Safety flag: set to true only in a private test server with disposable accounts.
-- This GUI never invokes state-modifying remotes regardless of this flag.
local PRIVATE_TEST_SERVER = false

--==============================================================================
-- REMOTE CACHE
--==============================================================================

local Boxing = ReplicatedStorage:WaitForChild("Boxing", 10)
local REMOTES = {}
if Boxing then
    local function safeWait(name, timeout)
        local inst = Boxing:WaitForChild(name, timeout or 5)
        return inst
    end
    REMOTES = {
        AdminPanel = safeWait("AdminPanelRemote"),
        Atm        = safeWait("AtmRemote"),
        Survival   = safeWait("SurvivalRemote"),
        Stats      = safeWait("StatsRemote"),
        Boxing     = safeWait("BoxingRemote"),
        Technique  = safeWait("TechniqueRemote"),
        Sparring   = safeWait("SparringRemote"),
        Avatar     = safeWait("AvatarRemote"),
        Gear       = safeWait("GearRemote"),
        Loadout    = safeWait("LoadoutRemote"),
        License    = safeWait("LicenseRemote"),
        Visibility = safeWait("VisibilityRemote"),
    }
end

--==============================================================================
-- TEST LOGGER
--==============================================================================

local Log = {}
Log.entries = {}

function Log:add(test, section, remote, args, response, status, note)
    local entry = {
        test = test,
        section = section,
        remote = remote or "N/A",
        args = args or "N/A",
        response = response or "N/A",
        status = status or "INCONCLUSIVE",
        note = note or "",
        timestamp = os.clock(),
    }
    table.insert(self.entries, entry)
    self:_refreshUI(entry)
end

function Log:_refreshUI(entry)
    if not _G.SecurityTestGUI then return end
    local gui = _G.SecurityTestGUI
    if not gui.logList then return end

    local row = Instance.new("Frame")
    row.Name = "LogRow"
    row.Size = UDim2.new(1, 0, 0, 20)
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 100, 1, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Font = Enum.Font.Code
    statusLabel.TextSize = 12
    statusLabel.Text = string.format("[%s] %s", entry.status, entry.test)
    statusLabel.TextColor3 = entry.status == "PASS" and Color3.fromRGB(120, 230, 130)
        or entry.status == "FAIL" and Color3.fromRGB(255, 90, 90)
        or Color3.fromRGB(230, 200, 90)
    statusLabel.Parent = row

    local detailLabel = Instance.new("TextLabel")
    detailLabel.Size = UDim2.new(1, -100, 1, 0)
    detailLabel.Position = UDim2.new(0, 100, 0, 0)
    detailLabel.BackgroundTransparency = 1
    detailLabel.TextXAlignment = Enum.TextXAlignment.Left
    detailLabel.Font = Enum.Font.Code
    detailLabel.TextSize = 11
    detailLabel.Text = string.format("%s → %s | %s", entry.remote, entry.response, entry.note)
    detailLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
    detailLabel.Parent = row

    row.Parent = gui.logList
    gui.logList.CanvasSize = UDim2.new(0, 0, 0, #gui.logList:GetChildren() * 20)
end

--==============================================================================
-- TEST RUNNER (SAFE)
--==============================================================================

local TestRunner = {}
TestRunner.results = {}

-- Invoke a function-remote read-only style and capture result
function TestRunner:invokeRemote(remote, op, ...)
    if not remote then
        return false, nil, "Remote not found"
    end
    local ok, a, b = pcall(function()
        return remote:InvokeServer(op, ...)
    end)
    return ok, a, tostring(b)
end

function TestRunner:fireRemote(remote, op, ...)
    if not remote then
        return false, "Remote not found"
    end
    local ok, err = pcall(function()
        remote:FireServer(op, ...)
    end)
    return ok, tostring(err)
end

function TestRunner:readAttribute(attrName)
    local ok, val = pcall(function()
        return LocalPlayer:GetAttribute(attrName)
    end)
    return ok, val
end

-- Record a result
function TestRunner:record(test, section, remote, status, response, note, args)
    self.results[test] = {
        test = test, section = section, remote = remote,
        status = status, response = response, note = note, args = args,
    }
    Log:add(test, section, remote, args or "", response, status, note)
end

--==============================================================================
-- GUI CONSTRUCTION
--==============================================================================

local GUI = {}

function GUI:create()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SecurityTestGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 780, 0, 560)
    Main.Position = UDim2.new(0.5, -390, 0.5, -280)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    Main.Active = true
    Main.Draggable = true

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

    -- Title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 32)
    TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Hajime Rising — Security Test GUI"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 0, 24)
    CloseBtn.Position = UDim2.new(1, -34, 0, 4)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 14
    CloseBtn.Parent = TitleBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        _G.SecurityTestGUI = nil
    end)

    -- Tab buttons
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, 0, 0, 30)
    TabBar.Position = UDim2.new(0, 0, 0, 32)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = Main

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Parent = TabBar

    -- Content area
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, 0, 1, -92)
    Content.Position = UDim2.new(0, 0, 0, 62)
    Content.BackgroundTransparency = 1
    Content.Parent = Main

    -- Log area
    local LogFrame = Instance.new("Frame")
    LogFrame.Name = "LogFrame"
    LogFrame.Size = UDim2.new(1, 0, 0, 130)
    LogFrame.Position = UDim2.new(0, 0, 1, -130)
    LogFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    LogFrame.BorderSizePixel = 0
    LogFrame.Parent = Main

    Instance.new("UICorner", LogFrame).CornerRadius = UDim.new(0, 6)

    local LogLabel = Instance.new("TextLabel")
    LogLabel.Size = UDim2.new(1, 0, 0, 18)
    LogLabel.Position = UDim2.new(0, 8, 0, 4)
    LogLabel.BackgroundTransparency = 1
    LogLabel.Text = "REMOTE CALL LOG"
    LogLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
    LogLabel.Font = Enum.Font.GothamBold
    LogLabel.TextSize = 12
    LogLabel.TextXAlignment = Enum.TextXAlignment.Left
    LogLabel.Parent = LogFrame

    local LogScroll = Instance.new("ScrollingFrame")
    LogScroll.Name = "LogScroll"
    LogScroll.Size = UDim2.new(1, -16, 1, -26)
    LogScroll.Position = UDim2.new(0, 8, 0, 24)
    LogScroll.BackgroundTransparency = 1
    LogScroll.BorderSizePixel = 0
    LogScroll.ScrollBarThickness = 4
    LogScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    LogScroll.Parent = LogFrame

    local LogList = Instance.new("UIListLayout")
    LogList.SortOrder = Enum.SortOrder.LayoutOrder
    LogList.Parent = LogScroll

    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingLeft = UDim.new(0, 4)
    UIPadding.PaddingRight = UDim.new(0, 4)
    UIPadding.PaddingTop = UDim.new(0, 2)
    UIPadding.PaddingBottom = UDim.new(0, 2)
    UIPadding.Parent = LogScroll

    GUI.screenGui = ScreenGui
    GUI.main = Main
    GUI.content = Content
    GUI.logList = LogScroll
    GUI.logScroll = LogScroll
    GUI.tabs = {}
    GUI.currentTab = nil

    -- Tab switching
    function GUI:switchTab(name)
        if self.currentTab then
            self.currentTab.frame.Visible = false
            self.currentTab.button.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
        end
        local tab = self.tabs[name]
        if not tab then return end
        tab.frame.Visible = true
        tab.button.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
        self.currentTab = tab
    end

    function GUI:addTab(name, order)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 130, 1, 0)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(220, 220, 230)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.Parent = TabBar
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

        local frame = Instance.new("ScrollingFrame")
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel = 0
        frame.ScrollBarThickness = 4
        frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        frame.Visible = false
        frame.Parent = Content

        local list = Instance.new("UIListLayout")
        list.SortOrder = Enum.SortOrder.LayoutOrder
        list.Padding = UDim.new(0, 6)
        list.Parent = frame

        local padding = Instance.new("UIPadding")
        padding.PaddingLeft = UDim.new(0, 10)
        padding.PaddingRight = UDim.new(0, 10)
        padding.PaddingTop = UDim.new(0, 8)
        padding.PaddingBottom = UDim.new(0, 8)
        padding.Parent = frame

        btn.MouseButton1Click:Connect(function()
            self:switchTab(name)
        end)

        self.tabs[name] = { button = btn, frame = frame, list = list }
        if order == 1 then
            self:switchTab(name)
        end
        return frame, list
    end

    -- Status badge helper
    function GUI:statusBadge(parent, status)
        local badge = Instance.new("TextLabel")
        badge.Size = UDim2.new(0, 70, 0, 18)
        badge.BackgroundTransparency = 0
        badge.BackgroundColor3 = status == "PASS" and Color3.fromRGB(40, 90, 50)
            or status == "FAIL" and Color3.fromRGB(90, 40, 40)
            or Color3.fromRGB(70, 60, 30)
        badge.Text = status
        badge.TextColor3 = Color3.new(1, 1, 1)
        badge.Font = Enum.Font.GothamBold
        badge.TextSize = 11
        badge.Parent = parent
        Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 4)
        return badge
    end

    -- Test row helper
    function GUI:testRow(list, testName, desc, remoteName, status, response, note, args)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 44)
        row.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
        row.BorderSizePixel = 0
        row.Parent = list
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0, 150, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = testName
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 13
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = row

        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -330, 0, 16)
        descLabel.Position = UDim2.new(0, 155, 0, 4)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = desc
        descLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 11
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.TextWrapped = true
        descLabel.Parent = row

        local remoteLabel = Instance.new("TextLabel")
        remoteLabel.Size = UDim2.new(0, 90, 0, 14)
        remoteLabel.Position = UDim2.new(1, -240, 0, 4)
        remoteLabel.BackgroundTransparency = 1
        remoteLabel.Text = remoteName or "—"
        remoteLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
        remoteLabel.Font = Enum.Font.Code
        remoteLabel.TextSize = 10
        remoteLabel.TextXAlignment = Enum.TextXAlignment.Right
        remoteLabel.Parent = row

        local badge = self:statusBadge(row, status)
        badge.Position = UDim2.new(1, -160, 0, 4)

        local noteLabel = Instance.new("TextLabel")
        noteLabel.Size = UDim2.new(1, -330, 0, 16)
        noteLabel.Position = UDim2.new(0, 155, 0, 22)
        noteLabel.BackgroundTransparency = 1
        noteLabel.Text = note
        noteLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
        noteLabel.Font = Enum.Font.Code
        noteLabel.TextSize = 10
        noteLabel.TextXAlignment = Enum.TextXAlignment.Left
        noteLabel.TextWrapped = true
        noteLabel.Parent = row

        local respLabel = Instance.new("TextLabel")
        respLabel.Size = UDim2.new(0, 200, 0, 14)
        respLabel.Position = UDim2.new(1, -290, 0, 22)
        respLabel.BackgroundTransparency = 1
        respLabel.Text = tostring(response)
        respLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
        respLabel.Font = Enum.Font.Code
        respLabel.TextSize = 10
        respLabel.TextXAlignment = Enum.TextXAlignment.Right
        respLabel.Parent = row

        -- Log entry
        Log:add(testName, nil, remoteName, args or "", response, status, note)

        return row
    end

    _G.SecurityTestGUI = GUI
    return GUI
end

return GUI