// ============================================
// FILE: VRFirstPersonState (1).luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\VRFirstPersonState (1).luau
// SIZE: 60 bytes
// ============================================
-- https://lua.expert

return {
    inFirstPerson = false
}


// ============================================
// END OF: VRFirstPersonState (1).luau
// ============================================

// ============================================
// FILE: VRFirstPersonState.luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\VRFirstPersonState.luau
// SIZE: 60 bytes
// ============================================
-- https://lua.expert

return {
    inFirstPerson = false
}


// ============================================
// END OF: VRFirstPersonState.luau
// ============================================

// ============================================
// FILE: VRVehicleCamera (1).luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\VRVehicleCamera (1).luau
// SIZE: 10776 bytes
// ============================================
-- https://lua.expert

local t1 = {
    0, 30
}
local VRBaseCamera = require(script.Parent:WaitForChild("VRBaseCamera"))
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VRService = game:GetService("VRService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local mapClamp = CameraUtils.mapClamp
local VehicleCameraConfig = require(script.Parent:WaitForChild("VehicleCamera"):FindFirstChild("VehicleCameraConfig"))
local v1 = RaycastParams.new()

v1.FilterType = Enum.RaycastFilterType.Exclude
v1.IgnoreWater = true

local function yawVelocity(p1, p2) -- line: 36
    return (math.abs((p2.YVector:Dot(p1))))
end

local function computeCameraCFrame(p3, p4, p5) -- line: 40
    local v3 = math.atan2(p4.X, p4.Z)

    return CFrame.new(p3.Position + p4 * p5) * CFrame.Angles(0, v3, 0)
end

local function vrOccludeDisplace(p6, p7, p8, p9) -- line: 45
    -- upvalues: LocalPlayer (copy), v1 (copy)
    local v4 = math.atan2(p7.X, p7.Z)
    local v5 = CFrame.new(p6.Position + p7 * p8) * CFrame.Angles(0, v4, 0)
    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera then
        local Position = p6.Position
        local v6 = (v5.Position - Position) * Vector3.new(1, 0, 1)
        local Magnitude = v6.Magnitude

        if not (Magnitude < 0.5) then
            local t2 = {
                CurrentCamera
            }

            if p9 then
                table.insert(t2, p9)
            end

            local v7 = LocalPlayer and LocalPlayer.Character

            if v7 then
                table.insert(t2, v7)
            end

            v1.FilterDescendantsInstances = t2

            local Unit = v6.Unit
            local v8 = workspace:Raycast(Position, v6, v1)

            if v8 and v8.Normal:Dot(Unit) < 0 then
                local v9 = (v8.Position - Position).Magnitude - 0.5

                if v9 < Magnitude then
                    local v10 = math.max(v9, 0.5)

                    return CFrame.new(p6.Position + Unit * v10) * v5.Rotation
                end
            end
        end
    end

    return v5
end

local v11 = OverlapParams.new()

v11.FilterType = Enum.RaycastFilterType.Exclude

local function findObstructions(p10, p11, p12, p13) -- line: 81
    -- upvalues: VRService (copy), LocalPlayer (copy), v1 (copy), v11 (copy)
    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera then
        local Position = p11.Position
        local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
        local HeadScale = CurrentCamera.HeadScale
        local v12 = p10 * (CFrame.new(UserCFrame.Position * HeadScale) * UserCFrame.Rotation)
        local v13 = v12.Position - Position
        local Magnitude = v13.Magnitude

        if not (Magnitude < 0.5) then
            local t3 = {
                CurrentCamera
            }

            if p13 then
                table.insert(t3, p13)
            end

            local v14 = LocalPlayer and LocalPlayer.Character

            if v14 then
                table.insert(t3, v14)
            end

            v1.FilterDescendantsInstances = t3

            local v15 = workspace:Raycast(Position, v13, v1)

            if v15 then
                local Magnitude2 = (v15.Position - Position).Magnitude

                if Magnitude2 < Magnitude then
                    local LookVector = v12.LookVector
                    local v19 = math.max(math.clamp((1 - -v13.Unit:Dot(LookVector)) / 0.1339745962155613, 0, 1), 1 - Magnitude2 / p12, 0.15)
                    local Position = v15.Position
                    local Position2 = v12.Position
                    local v20 = (Position + Position2) / 2
                    local v21 = Vector3.new(2, 2, (Position2 - Position).Magnitude)
                    local v22 = CFrame.lookAt(v20, Position2)

                    v11.FilterDescendantsInstances = t3

                    return v19, (workspace:GetPartBoundsInBox(v22, v21, v11))
                end
            end
        end
    end

    return 0, {}
end

local n1 = 0.016666666666666666
local self = setmetatable({}, VRBaseCamera)

self.__index = self

function self.new() -- line: 133
    -- upvalues: VRBaseCamera (copy), RunService (copy), n1 (ref), self (copy)
    local v25 = setmetatable(VRBaseCamera.new(), self)

    v25.skipOcclusion = true
    v25:Reset()

    if v25.thirdPersonOptionChanged then
        v25.thirdPersonOptionChanged:Disconnect()
        v25.thirdPersonOptionChanged = nil
    end

    RunService.Stepped:Connect(function(_, p15) -- line: 143
        -- upvalues: n1 (ref)
        n1 = p15
    end)

    return v25
end

function self.Reset(p16) -- line: 150
    -- upvalues: t1 (copy), CameraUtils (copy)
    local CurrentCamera = workspace.CurrentCamera
    local v26 = CurrentCamera and CurrentCamera.CameraSubject

    assert(CurrentCamera, "VRVehicleCamera initialization error")
    assert(v26)
    assert(v26:IsA("VehicleSeat"))
    p16.lastOrbitalDir = nil
    p16.wasInFirstPerson = nil

    local ConnectedParts = v26:GetConnectedParts(true)

    table.insert(ConnectedParts, v26)

    local v27, v28 = CameraUtils.getLooseBoundingSphere(ConnectedParts)

    p16.vehicleModel = v26:FindFirstAncestorOfClass("Model") or v26.Parent
    p16.assemblyRadius = math.max(v28, 5)
    p16.assemblyOffset = v26.CFrame:Inverse() * v27
    p16.gamepadZoomLevels = {}

    for _, v29 in t1 do
        table.insert(p16.gamepadZoomLevels, v29 * p16.headScale * p16.assemblyRadius / 10)
    end

    p16.lastCameraFocus = nil

    if not p16:IsInFirstPerson() then
        p16:SetCameraToSubjectDistance(p16.gamepadZoomLevels[#p16.gamepadZoomLevels])
    end

    p16.needsReset = false
end

function self._getThirdPersonLocalOffset(p17) -- line: 184
    -- upvalues: VehicleCameraConfig (copy)
    return p17.assemblyOffset + Vector3.new(0, p17.assemblyRadius * VehicleCameraConfig.verticalCenterOffset, 0)
end

function self._getFirstPersonLocalOffset(p18, p19) -- line: 188
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    if Character and Character.Parent then
        local Head = Character:FindFirstChild("Head")

        if Head and Head:IsA("BasePart") then
            return p19:Inverse() * Head.Position
        end
    end

    return p18:_getThirdPersonLocalOffset()
end

function self._vrOccludeVignette(p20, p21, p22, p23) -- line: 202
    -- upvalues: Lighting (copy), LocalPlayer (copy), findObstructions (copy)
    local v32 = math.atan2(p22.X, p22.Z)
    local v33 = CFrame.new(p21.Position + p22 * p23) * CFrame.Angles(0, v32, 0)
    local v34, v35 = findObstructions(v33, p21, p23, p20.vehicleModel)
    local VRFade = Lighting:FindFirstChild("VRFade")

    if not VRFade then
        VRFade = Instance.new("ColorCorrectionEffect")
        VRFade.Name = "VRFade"
        VRFade.Parent = Lighting
    end

    VRFade.Brightness = -v34

    if p20.lastOccludedParts then
        for _, v36 in p20.lastOccludedParts do
            v36.LocalTransparencyModifier = 0
        end
    end

    if #v35 > 0 then
        for _, v37 in v35 do
            v37.LocalTransparencyModifier = 1
        end

        p20:StartVREdgeBlur(LocalPlayer, true)
    end

    p20.lastOccludedParts = v35

    return v33
end

function self.Update(p24) -- line: 229
    -- upvalues: LocalPlayer (copy), n1 (ref)
    local v38 = n1

    n1 = 0
    p24:UpdateFadeFromBlack(v38)
    p24:UpdateEdgeBlur(LocalPlayer, v38)

    local v39, v40 = p24:_updateStepRotation(v38)

    return v39, v40
end

function self._updateStepRotation(p25, p26) -- line: 241
    -- upvalues: CameraInput (copy), mapClamp (copy), VehicleCameraConfig (copy), vrOccludeDisplace (copy)
    local SubjectCFrame = p25:GetSubjectCFrame()
    local CameraToSubjectDistance = p25:GetCameraToSubjectDistance()
    local v41 = mapClamp(CameraToSubjectDistance, 0.5, p25.assemblyRadius, 1, 0)
    local v42 = SubjectCFrame * p25:_getThirdPersonLocalOffset():Lerp(p25:_getFirstPersonLocalOffset(SubjectCFrame), v41)
    local v43 = CFrame.new(v42 + Vector3.new(0, p25:GetCameraHeight(), 0))

    if p25.needsReset or p25.recentered then
        p25.lastOrbitalDir = nil
        p25.needsReset = false
        p25.recentered = false
    end

    local lastOrbitalDir = p25.lastOrbitalDir

    if not lastOrbitalDir then
        lastOrbitalDir = (SubjectCFrame.LookVector * Vector3.new(-1, 0, -1)).Unit
        p25:StartFadeFromBlack()
    end

    local v44 = (p25:GetSubjectVelocity() * Vector3.new(1, 0, 1)).Magnitude > 2

    if v44 then
        CameraInput.getRotation(p26)
    else
        local v45 = p25:getRotation(p26)

        if math.abs(v45) > 0 then
            lastOrbitalDir = (CFrame.Angles(0, -v45, 0) * CFrame.new(lastOrbitalDir)).Position.Unit
            p25.lastRotateTime = os.clock()
        end
    end

    local v46

    if p25:IsInFirstPerson() then
        if not p25.wasInFirstPerson or v44 then
            lastOrbitalDir = (SubjectCFrame.LookVector * Vector3.new(-1, 0, -1)).Unit
            p25.wasInFirstPerson = true
        end

        local v49 = math.atan2(-SubjectCFrame.LookVector.X, -SubjectCFrame.LookVector.Z)

        if p25.lastVehicleYaw then
            local v50 = (v49 - p25.lastVehicleYaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793

            if math.abs(v50) > 0.001 then
                lastOrbitalDir = (CFrame.Angles(0, v50, 0) * CFrame.new(lastOrbitalDir)).Position.Unit
            end
        end

        p25.lastVehicleYaw = v49

        local v51 = math.atan2(lastOrbitalDir.X, lastOrbitalDir.Z)

        v46 = CFrame.new(v43.Position + lastOrbitalDir * CameraToSubjectDistance) * CFrame.Angles(0, v51, 0)
    else
        p25.wasInFirstPerson = false
        p25.lastVehicleYaw = nil

        local v52 = p25.lastRotateTime and os.clock() - p25.lastRotateTime < VehicleCameraConfig.autocorrectDelay

        if v44 and not v52 then
            local Unit = (SubjectCFrame.LookVector * Vector3.new(-1, 0, -1)).Unit
            local v55 = math.acos((math.clamp(lastOrbitalDir:Dot(Unit), -1, 1)))
            local SubjectRotVelocity = p25:GetSubjectRotVelocity()
            local v57 = math.abs((SubjectCFrame.YVector:Dot(SubjectRotVelocity)))

            lastOrbitalDir = lastOrbitalDir:Lerp(Unit, (math.min(0.01 + v55 / 3.141592653589793 * 0.05 + v57 * 0.02, 0.15)))
        end

        v46 = vrOccludeDisplace(v43, lastOrbitalDir, CameraToSubjectDistance, p25.vehicleModel)
    end

    p25.lastOrbitalDir = lastOrbitalDir

    return v46, v46 * CFrame.new(0, 0, -CameraToSubjectDistance)
end

return self


// ============================================
// END OF: VRVehicleCamera (1).luau
// ============================================

// ============================================
// FILE: VRVehicleCamera.luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\VRVehicleCamera.luau
// SIZE: 10776 bytes
// ============================================
-- https://lua.expert

local t1 = {
    0, 30
}
local VRBaseCamera = require(script.Parent:WaitForChild("VRBaseCamera"))
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VRService = game:GetService("VRService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local mapClamp = CameraUtils.mapClamp
local VehicleCameraConfig = require(script.Parent:WaitForChild("VehicleCamera"):FindFirstChild("VehicleCameraConfig"))
local v1 = RaycastParams.new()

v1.FilterType = Enum.RaycastFilterType.Exclude
v1.IgnoreWater = true

local function yawVelocity(p1, p2) -- line: 36
    return (math.abs((p2.YVector:Dot(p1))))
end

local function computeCameraCFrame(p3, p4, p5) -- line: 40
    local v3 = math.atan2(p4.X, p4.Z)

    return CFrame.new(p3.Position + p4 * p5) * CFrame.Angles(0, v3, 0)
end

local function vrOccludeDisplace(p6, p7, p8, p9) -- line: 45
    -- upvalues: LocalPlayer (copy), v1 (copy)
    local v4 = math.atan2(p7.X, p7.Z)
    local v5 = CFrame.new(p6.Position + p7 * p8) * CFrame.Angles(0, v4, 0)
    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera then
        local Position = p6.Position
        local v6 = (v5.Position - Position) * Vector3.new(1, 0, 1)
        local Magnitude = v6.Magnitude

        if not (Magnitude < 0.5) then
            local t2 = {
                CurrentCamera
            }

            if p9 then
                table.insert(t2, p9)
            end

            local v7 = LocalPlayer and LocalPlayer.Character

            if v7 then
                table.insert(t2, v7)
            end

            v1.FilterDescendantsInstances = t2

            local Unit = v6.Unit
            local v8 = workspace:Raycast(Position, v6, v1)

            if v8 and v8.Normal:Dot(Unit) < 0 then
                local v9 = (v8.Position - Position).Magnitude - 0.5

                if v9 < Magnitude then
                    local v10 = math.max(v9, 0.5)

                    return CFrame.new(p6.Position + Unit * v10) * v5.Rotation
                end
            end
        end
    end

    return v5
end

local v11 = OverlapParams.new()

v11.FilterType = Enum.RaycastFilterType.Exclude

local function findObstructions(p10, p11, p12, p13) -- line: 81
    -- upvalues: VRService (copy), LocalPlayer (copy), v1 (copy), v11 (copy)
    local CurrentCamera = workspace.CurrentCamera

    if CurrentCamera then
        local Position = p11.Position
        local UserCFrame = VRService:GetUserCFrame(Enum.UserCFrame.Head)
        local HeadScale = CurrentCamera.HeadScale
        local v12 = p10 * (CFrame.new(UserCFrame.Position * HeadScale) * UserCFrame.Rotation)
        local v13 = v12.Position - Position
        local Magnitude = v13.Magnitude

        if not (Magnitude < 0.5) then
            local t3 = {
                CurrentCamera
            }

            if p13 then
                table.insert(t3, p13)
            end

            local v14 = LocalPlayer and LocalPlayer.Character

            if v14 then
                table.insert(t3, v14)
            end

            v1.FilterDescendantsInstances = t3

            local v15 = workspace:Raycast(Position, v13, v1)

            if v15 then
                local Magnitude2 = (v15.Position - Position).Magnitude

                if Magnitude2 < Magnitude then
                    local LookVector = v12.LookVector
                    local v19 = math.max(math.clamp((1 - -v13.Unit:Dot(LookVector)) / 0.1339745962155613, 0, 1), 1 - Magnitude2 / p12, 0.15)
                    local Position = v15.Position
                    local Position2 = v12.Position
                    local v20 = (Position + Position2) / 2
                    local v21 = Vector3.new(2, 2, (Position2 - Position).Magnitude)
                    local v22 = CFrame.lookAt(v20, Position2)

                    v11.FilterDescendantsInstances = t3

                    return v19, (workspace:GetPartBoundsInBox(v22, v21, v11))
                end
            end
        end
    end

    return 0, {}
end

local n1 = 0.016666666666666666
local self = setmetatable({}, VRBaseCamera)

self.__index = self

function self.new() -- line: 133
    -- upvalues: VRBaseCamera (copy), RunService (copy), n1 (ref), self (copy)
    local v25 = setmetatable(VRBaseCamera.new(), self)

    v25.skipOcclusion = true
    v25:Reset()

    if v25.thirdPersonOptionChanged then
        v25.thirdPersonOptionChanged:Disconnect()
        v25.thirdPersonOptionChanged = nil
    end

    RunService.Stepped:Connect(function(_, p15) -- line: 143
        -- upvalues: n1 (ref)
        n1 = p15
    end)

    return v25
end

function self.Reset(p16) -- line: 150
    -- upvalues: t1 (copy), CameraUtils (copy)
    local CurrentCamera = workspace.CurrentCamera
    local v26 = CurrentCamera and CurrentCamera.CameraSubject

    assert(CurrentCamera, "VRVehicleCamera initialization error")
    assert(v26)
    assert(v26:IsA("VehicleSeat"))
    p16.lastOrbitalDir = nil
    p16.wasInFirstPerson = nil

    local ConnectedParts = v26:GetConnectedParts(true)

    table.insert(ConnectedParts, v26)

    local v27, v28 = CameraUtils.getLooseBoundingSphere(ConnectedParts)

    p16.vehicleModel = v26:FindFirstAncestorOfClass("Model") or v26.Parent
    p16.assemblyRadius = math.max(v28, 5)
    p16.assemblyOffset = v26.CFrame:Inverse() * v27
    p16.gamepadZoomLevels = {}

    for _, v29 in t1 do
        table.insert(p16.gamepadZoomLevels, v29 * p16.headScale * p16.assemblyRadius / 10)
    end

    p16.lastCameraFocus = nil

    if not p16:IsInFirstPerson() then
        p16:SetCameraToSubjectDistance(p16.gamepadZoomLevels[#p16.gamepadZoomLevels])
    end

    p16.needsReset = false
end

function self._getThirdPersonLocalOffset(p17) -- line: 184
    -- upvalues: VehicleCameraConfig (copy)
    return p17.assemblyOffset + Vector3.new(0, p17.assemblyRadius * VehicleCameraConfig.verticalCenterOffset, 0)
end

function self._getFirstPersonLocalOffset(p18, p19) -- line: 188
    -- upvalues: LocalPlayer (copy)
    local Character = LocalPlayer.Character

    if Character and Character.Parent then
        local Head = Character:FindFirstChild("Head")

        if Head and Head:IsA("BasePart") then
            return p19:Inverse() * Head.Position
        end
    end

    return p18:_getThirdPersonLocalOffset()
end

function self._vrOccludeVignette(p20, p21, p22, p23) -- line: 202
    -- upvalues: Lighting (copy), LocalPlayer (copy), findObstructions (copy)
    local v32 = math.atan2(p22.X, p22.Z)
    local v33 = CFrame.new(p21.Position + p22 * p23) * CFrame.Angles(0, v32, 0)
    local v34, v35 = findObstructions(v33, p21, p23, p20.vehicleModel)
    local VRFade = Lighting:FindFirstChild("VRFade")

    if not VRFade then
        VRFade = Instance.new("ColorCorrectionEffect")
        VRFade.Name = "VRFade"
        VRFade.Parent = Lighting
    end

    VRFade.Brightness = -v34

    if p20.lastOccludedParts then
        for _, v36 in p20.lastOccludedParts do
            v36.LocalTransparencyModifier = 0
        end
    end

    if #v35 > 0 then
        for _, v37 in v35 do
            v37.LocalTransparencyModifier = 1
        end

        p20:StartVREdgeBlur(LocalPlayer, true)
    end

    p20.lastOccludedParts = v35

    return v33
end

function self.Update(p24) -- line: 229
    -- upvalues: LocalPlayer (copy), n1 (ref)
    local v38 = n1

    n1 = 0
    p24:UpdateFadeFromBlack(v38)
    p24:UpdateEdgeBlur(LocalPlayer, v38)

    local v39, v40 = p24:_updateStepRotation(v38)

    return v39, v40
end

function self._updateStepRotation(p25, p26) -- line: 241
    -- upvalues: CameraInput (copy), mapClamp (copy), VehicleCameraConfig (copy), vrOccludeDisplace (copy)
    local SubjectCFrame = p25:GetSubjectCFrame()
    local CameraToSubjectDistance = p25:GetCameraToSubjectDistance()
    local v41 = mapClamp(CameraToSubjectDistance, 0.5, p25.assemblyRadius, 1, 0)
    local v42 = SubjectCFrame * p25:_getThirdPersonLocalOffset():Lerp(p25:_getFirstPersonLocalOffset(SubjectCFrame), v41)
    local v43 = CFrame.new(v42 + Vector3.new(0, p25:GetCameraHeight(), 0))

    if p25.needsReset or p25.recentered then
        p25.lastOrbitalDir = nil
        p25.needsReset = false
        p25.recentered = false
    end

    local lastOrbitalDir = p25.lastOrbitalDir

    if not lastOrbitalDir then
        lastOrbitalDir = (SubjectCFrame.LookVector * Vector3.new(-1, 0, -1)).Unit
        p25:StartFadeFromBlack()
    end

    local v44 = (p25:GetSubjectVelocity() * Vector3.new(1, 0, 1)).Magnitude > 2

    if v44 then
        CameraInput.getRotation(p26)
    else
        local v45 = p25:getRotation(p26)

        if math.abs(v45) > 0 then
            lastOrbitalDir = (CFrame.Angles(0, -v45, 0) * CFrame.new(lastOrbitalDir)).Position.Unit
            p25.lastRotateTime = os.clock()
        end
    end

    local v46

    if p25:IsInFirstPerson() then
        if not p25.wasInFirstPerson or v44 then
            lastOrbitalDir = (SubjectCFrame.LookVector * Vector3.new(-1, 0, -1)).Unit
            p25.wasInFirstPerson = true
        end

        local v49 = math.atan2(-SubjectCFrame.LookVector.X, -SubjectCFrame.LookVector.Z)

        if p25.lastVehicleYaw then
            local v50 = (v49 - p25.lastVehicleYaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793

            if math.abs(v50) > 0.001 then
                lastOrbitalDir = (CFrame.Angles(0, v50, 0) * CFrame.new(lastOrbitalDir)).Position.Unit
            end
        end

        p25.lastVehicleYaw = v49

        local v51 = math.atan2(lastOrbitalDir.X, lastOrbitalDir.Z)

        v46 = CFrame.new(v43.Position + lastOrbitalDir * CameraToSubjectDistance) * CFrame.Angles(0, v51, 0)
    else
        p25.wasInFirstPerson = false
        p25.lastVehicleYaw = nil

        local v52 = p25.lastRotateTime and os.clock() - p25.lastRotateTime < VehicleCameraConfig.autocorrectDelay

        if v44 and not v52 then
            local Unit = (SubjectCFrame.LookVector * Vector3.new(-1, 0, -1)).Unit
            local v55 = math.acos((math.clamp(lastOrbitalDir:Dot(Unit), -1, 1)))
            local SubjectRotVelocity = p25:GetSubjectRotVelocity()
            local v57 = math.abs((SubjectCFrame.YVector:Dot(SubjectRotVelocity)))

            lastOrbitalDir = lastOrbitalDir:Lerp(Unit, (math.min(0.01 + v55 / 3.141592653589793 * 0.05 + v57 * 0.02, 0.15)))
        end

        v46 = vrOccludeDisplace(v43, lastOrbitalDir, CameraToSubjectDistance, p25.vehicleModel)
    end

    p25.lastOrbitalDir = lastOrbitalDir

    return v46, v46 * CFrame.new(0, 0, -CameraToSubjectDistance)
end

return self


// ============================================
// END OF: VRVehicleCamera.luau
// ============================================

// ============================================
// FILE: WalkoutController (1).luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\WalkoutController (1).luau
// SIZE: 26254 bytes
// ============================================
-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Boxing = ReplicatedStorage:WaitForChild("Boxing")
local Walkouts = require(Boxing:WaitForChild("Walkouts"))
local BoxingSettings = require(Boxing:WaitForChild("BoxingSettings"))
local MenuState = require(Boxing:WaitForChild("MenuState"))
local WalkoutRemote = Boxing:WaitForChild("WalkoutRemote")
local Entrance = Walkouts.Entrance
local v1 = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Bold)
local v2 = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
local t1 = {
    Red = Color3.fromRGB(214, 38, 46),
    Blue = Color3.fromRGB(44, 108, 232)
}
local v3 = Color3.fromRGB(245, 242, 236)
local v4 = Color3.fromRGB(190, 186, 180)

local function new(p1, p2, p3) -- line: 35
    local v5 = Instance.new(p1)

    for v6, v7 in p2 do
        v5[v6] = v7
    end

    v5.Parent = p3

    return v5
end

local t2 = {
    Name = "WalkoutGui",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 70,
    Enabled = false
}
local ScreenGui = Instance.new("ScreenGui")

for v8, v9 in t2 do
    ScreenGui[v8] = v9
end

ScreenGui.Parent = PlayerGui

local t3 = {
    Name = "Top",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.new(0, 0, 0),
    Size = UDim2.fromScale(1, 0)
}
local Frame = Instance.new("Frame")

for v10, v11 in t3 do
    Frame[v10] = v11
end

Frame.Parent = ScreenGui

local t4 = {
    Name = "Bottom",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.new(0, 0, 0),
    AnchorPoint = Vector2.new(0, 1),
    Position = UDim2.fromScale(0, 1),
    Size = UDim2.fromScale(1, 0)
}
local Frame2 = Instance.new("Frame")

for v12, v13 in t4 do
    Frame2[v12] = v13
end

Frame2.Parent = ScreenGui

local t5 = {}
local UIScale = Instance.new("UIScale")

for v14, v15 in t5 do
    UIScale[v14] = v15
end

UIScale.Parent = ScreenGui

local v16 = UDim2.new(0, 60, 0.86, 0)
local v17 = UDim2.new(0, -700, 0.86, 0)
local t6 = {
    Name = "Card",
    BackgroundTransparency = 0.18,
    BorderSizePixel = 0,
    AnchorPoint = Vector2.new(0, 1),
    Position = v17,
    Size = UDim2.fromOffset(620, 168),
    BackgroundColor3 = Color3.fromRGB(12, 12, 14)
}
local Frame3 = Instance.new("Frame")

for v18, v19 in t6 do
    Frame3[v18] = v19
end

Frame3.Parent = ScreenGui

local t7 = {
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.75, 0.15),
        NumberSequenceKeypoint.new(1, 1)
    })
}
local UIGradient = Instance.new("UIGradient")

for v20, v21 in t7 do
    UIGradient[v20] = v21
end

UIGradient.Parent = Frame3

local t8 = {
    Name = "Strip",
    BorderSizePixel = 0,
    Size = UDim2.new(0, 10, 1, 0),
    BackgroundColor3 = t1.Red
}
local Frame4 = Instance.new("Frame")

for v22, v23 in t8 do
    Frame4[v22] = v23
end

Frame4.Parent = Frame3

local t9 = {
    Name = "Corner",
    BackgroundTransparency = 1,
    TextSize = 16,
    Text = "",
    Position = UDim2.fromOffset(30, 10),
    Size = UDim2.new(1, -40, 0, 22),
    FontFace = v2,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = t1.Red
}
local TextLabel = Instance.new("TextLabel")

for v24, v25 in t9 do
    TextLabel[v24] = v25
end

TextLabel.Parent = Frame3

local t10 = {
    Name = "BoxerName",
    BackgroundTransparency = 1,
    TextSize = 56,
    Text = "",
    Position = UDim2.fromOffset(28, 30),
    Size = UDim2.new(1, -40, 0, 60),
    FontFace = v1,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = v3,
    TextTruncate = Enum.TextTruncate.AtEnd
}
local TextLabel2 = Instance.new("TextLabel")

for v26, v27 in t10 do
    TextLabel2[v26] = v27
end

TextLabel2.Parent = Frame3

local t11 = {
    Thickness = 2,
    Color = Color3.new(0, 0, 0)
}
local UIStroke = Instance.new("UIStroke")

for v28, v29 in t11 do
    UIStroke[v28] = v29
end

UIStroke.Parent = TextLabel2

local t12 = {
    Name = "Details",
    BackgroundTransparency = 1,
    TextSize = 18,
    Text = "",
    Position = UDim2.fromOffset(30, 92),
    Size = UDim2.new(1, -40, 0, 24),
    FontFace = v2,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = v4
}
local TextLabel3 = Instance.new("TextLabel")

for v30, v31 in t12 do
    TextLabel3[v30] = v31
end

TextLabel3.Parent = Frame3

local t13 = {
    Name = "Song",
    BackgroundTransparency = 1,
    TextSize = 19,
    RichText = true,
    Text = "",
    Position = UDim2.fromOffset(30, 124),
    Size = UDim2.new(1, -40, 0, 26),
    FontFace = v2,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = v3
}
local TextLabel4 = Instance.new("TextLabel")

for v32, v33 in t13 do
    TextLabel4[v32] = v33
end

TextLabel4.Parent = Frame3

local t14 = {
    Name = "Versus",
    BackgroundTransparency = 1,
    TextSize = 58,
    RichText = true,
    TextTransparency = 1,
    Text = "",
    AnchorPoint = Vector2.new(0.5, 1),
    Position = UDim2.new(0.5, 0, 0.88, 0),
    Size = UDim2.fromOffset(1200, 70),
    FontFace = v1,
    TextColor3 = v3
}
local TextLabel5 = Instance.new("TextLabel")

for v34, v35 in t14 do
    TextLabel5[v34] = v35
end

TextLabel5.Parent = ScreenGui

local t15 = {
    Thickness = 2.5,
    Transparency = 1,
    Color = Color3.new(0, 0, 0)
}
local UIStroke2 = Instance.new("UIStroke")

for v36, v37 in t15 do
    UIStroke2[v36] = v37
end

UIStroke2.Parent = TextLabel5

local t16 = {
    Name = "Skip",
    BackgroundTransparency = 1,
    TextSize = 14,
    TextTransparency = 0.25,
    Text = "PRESS ANY KEY TO SKIP",
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -24, 1, -14),
    Size = UDim2.fromOffset(360, 22),
    FontFace = v2,
    TextXAlignment = Enum.TextXAlignment.Right,
    TextColor3 = v4
}
local TextLabel6 = Instance.new("TextLabel")

for v38, v39 in t16 do
    TextLabel6[v38] = v39
end

TextLabel6.Parent = ScreenGui

if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    TextLabel6.Text = "TAP TO SKIP"
end

local function rescale() -- line: 69
    -- upvalues: UIScale (copy)
    UIScale.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 1000, 0.55, 1.3)
end

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(rescale)
UIScale.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 1000, 0.55, 1.3)

local function upper(p4) -- line: 75
    return string.upper((tostring(p4 or "")))
end

local function escape(p5) -- line: 79
    return (tostring(p5):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function hex(p6) -- line: 83
    return string.format("#%02X%02X%02X", math.floor(p6.R * 255), math.floor(p6.G * 255), (math.floor(p6.B * 255)))
end

local function showCard(p7) -- line: 87
    -- upvalues: TweenService (copy), Walkouts (copy), t1 (copy), v3 (copy), v16 (copy), v17 (copy), Frame3 (copy), Frame4 (copy), TextLabel (copy), TextLabel2 (copy), TextLabel3 (copy), TextLabel4 (copy), upper (copy)
    local v48 = t1[p7.Side] or v3

    Frame4.BackgroundColor3 = v48
    TextLabel.TextColor3 = v48

    local Side = p7.Side

    TextLabel.Text = string.upper((tostring(Side or ""))) .. " CORNER"

    local Name = p7.Name

    TextLabel2.Text = string.upper((tostring(Name or "")))

    local t17 = {}
    local t18 = {
        p7.Rank,
        p7.Class,
        if p7.Record then p7.Record .. " (W-L-D)" else nil
    }

    for _, v52 in t18 do
        if v52 and v52 ~= "" then
            table.insert(t17, upper(v52))
        end
    end

    TextLabel3.Text = table.concat(t17, "   Â·   ")

    if p7.Song then
        local format = string.format
        local Name = p7.Song.Name
        local v55 = tostring((string.upper((tostring(Name or ""))))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
        local v56 = Walkouts.RarityColor(p7.Song.Rarity)
        local v62 = string.format("#%02X%02X%02X", math.floor(v56.R * 255), math.floor(v56.G * 255), (math.floor(v56.B * 255)))
        local Rarity = p7.Song.Rarity

        TextLabel4.Text = format("WALKOUT: %s  <font color=\"%s\">%s</font>", v55, v62, (tostring((string.upper((tostring(Rarity or ""))))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")))
    else
        TextLabel4.Text = "<font color=\"#9A968F\">NO WALKOUT SONG</font>"
    end

    Frame3.Position = v17
    TweenService:Create(Frame3, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = v16
    }):Play()
end

local function hideCard() -- line: 109
    -- upvalues: TweenService (copy), v17 (copy), Frame3 (copy)
    TweenService:Create(Frame3, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = v17
    }):Play()
end

local t19
local v65 = false

local function fadeSound(p8, p9) -- line: 117
    -- upvalues: TweenService (copy)
    if not p8 then
        return
    end

    local tween = TweenService:Create(p8, TweenInfo.new(p9 or 0.6), {
        Volume = 0
    })

    tween.Completed:Once(function() -- line: 122
        -- upvalues: p8 (copy)
        p8:Destroy()
    end)
    tween:Play()
end

local function stopScene() -- line: 128
    -- upvalues: TweenService (copy), LocalPlayer (copy), MenuState (copy), Entrance (copy), ScreenGui (copy), Frame (copy), Frame2 (copy), TextLabel5 (copy), UIStroke2 (copy), hideCard (copy), t19 (ref), fadeSound (copy)
    local t20 = t19

    if not t20 then
        return
    end

    t19 = nil

    local function v66() -- line: 134
        -- upvalues: t20 (copy), TweenService (copy), Entrance (copy), ScreenGui (copy), Frame (copy), Frame2 (copy), TextLabel5 (copy), UIStroke2 (copy), hideCard (copy), t19 (ref), fadeSound (copy)
        fadeSound(t20.Song, Entrance.SongFade or 0.8)

        if t20.Light then
            t20.Light:Destroy()
        end

        TweenService:Create(Frame, TweenInfo.new(0.3), {
            Size = UDim2.fromScale(1, 0)
        }):Play()
        TweenService:Create(Frame2, TweenInfo.new(0.3), {
            Size = UDim2.fromScale(1, 0)
        }):Play()
        hideCard()
        TextLabel5.TextTransparency = 1
        UIStroke2.Transparency = 1
        task.delay(0.35, function() -- line: 143
            -- upvalues: ScreenGui (copy), t19 (ref)
            if not t19 then
                ScreenGui.Enabled = false
            end
        end)

        for v67 in t20.Hidden do
            if v67.Parent then
                v67.Enabled = true
            end
        end
    end

    pcall(v66)

    local CurrentCamera = workspace.CurrentCamera

    if t20.TookCamera then
        CurrentCamera.CameraType = Enum.CameraType.Custom
        CurrentCamera.FieldOfView = t20.Saved.FOV

        local v68 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

        if v68 then
            CurrentCamera.CameraSubject = v68
        end
    end

    if t20.Opened then
        MenuState.Close("Walkout")
    end

    LocalPlayer:SetAttribute("WalkoutPlaying", nil)
end

local function startScene() -- line: 169
    -- upvalues: TweenService (copy), LocalPlayer (copy), PlayerGui (copy), MenuState (copy), ScreenGui (copy), Frame (copy), Frame2 (copy), t19 (ref)
    if t19 then
        return t19
    end

    local Character = LocalPlayer.Character

    if LocalPlayer:GetAttribute("InFrontMenu") or Character and Character:GetAttribute("InCreator") then
        return nil
    end

    local CurrentCamera = workspace.CurrentCamera
    local t21 = {
        Angle = 0,
        Saved = {
            FOV = CurrentCamera.FieldOfView
        },
        Hidden = {},
        Deadline = os.clock() + 40
    }

    t21.Opened = MenuState.Open("Walkout")
    t21.TookCamera = t21.Opened
    t19 = t21

    if t21.TookCamera then
        for _, child in PlayerGui:GetChildren() do
            if child:IsA("ScreenGui") and child ~= ScreenGui and child.Enabled and child.Name ~= "TouchGui" then
                t21.Hidden[child] = true
                child.Enabled = false
            end
        end

        ScreenGui.Enabled = true
        TweenService:Create(Frame, TweenInfo.new(0.4), {
            Size = UDim2.fromScale(1, 0.09)
        }):Play()
        TweenService:Create(Frame2, TweenInfo.new(0.4), {
            Size = UDim2.fromScale(1, 0.09)
        }):Play()
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        CurrentCamera.FieldOfView = 50
        t21.StartedAt = os.clock()
    end

    return t21
end

local function crowd() -- line: 202
    -- upvalues: SoundService (copy), Entrance (copy)
    if Entrance.CrowdSound then
        local t22 = {
            Name = "WalkoutCrowd",
            SoundId = "rbxassetid://" .. tostring(Entrance.CrowdSound),
            Volume = Entrance.CrowdVolume or 0.3,
            SoundGroup = SoundService:FindFirstChild("BoxingMaster")
        }
        local Sound = Instance.new("Sound")

        for v69, v70 in t22 do
            Sound[v69] = v70
        end

        Sound.Parent = SoundService
        Sound:Play()
        task.delay(12, function() -- line: 208
            -- upvalues: Sound (copy)
            Sound:Destroy()
        end)
    end
end

local function smoke(p10) -- line: 213
    if not p10 then
        return
    end

    local t23 = {
        Name = "WalkoutSmoke",
        Anchored = true,
        CanCollide = false,
        CanQuery = false,
        CanTouch = false,
        Transparency = 1,
        Size = Vector3.new(4, 1, 4),
        CFrame = p10
    }
    local _workspace = workspace
    local Part = Instance.new("Part")

    for v71, v72 in t23 do
        Part[v71] = v72
    end

    Part.Parent = _workspace

    local t24 = {
        Texture = "rbxasset://textures/particles/smoke_main.dds",
        Rate = 0,
        LightEmission = 0.15,
        Acceleration = Vector3.new(0, 1.5, 0),
        Drag = 1.5,
        Lifetime = NumberRange.new(1.6, 2.8),
        Speed = NumberRange.new(2, 6),
        SpreadAngle = Vector2.new(180, 30),
        Color = ColorSequence.new(Color3.fromRGB(220, 220, 228)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 2.5),
            NumberSequenceKeypoint.new(1, 8)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.45),
            NumberSequenceKeypoint.new(1, 1)
        })
    }
    local ParticleEmitter = Instance.new("ParticleEmitter")

    for v73, v74 in t24 do
        ParticleEmitter[v73] = v74
    end

    ParticleEmitter.Parent = Part
    ParticleEmitter:Emit(36)
    task.delay(4, function() -- line: 226
        -- upvalues: Part (copy)
        Part:Destroy()
    end)
end

local function spotlight(p11) -- line: 231
    if p11.Light then
        return
    end

    local t25 = {
        Name = "WalkoutLight",
        Anchored = true,
        CanCollide = false,
        CanQuery = false,
        CanTouch = false,
        Transparency = 1,
        Size = Vector3.new(1, 1, 1)
    }
    local _workspace = workspace
    local Part = Instance.new("Part")

    for v75, v76 in t25 do
        Part[v75] = v76
    end

    Part.Parent = _workspace

    local t26 = {
        Brightness = 7,
        Range = 30,
        Angle = 46,
        Shadows = false,
        Face = Enum.NormalId.Bottom,
        Color = Color3.fromRGB(255, 240, 222)
    }
    local SpotLight = Instance.new("SpotLight")

    for v77, v78 in t26 do
        SpotLight[v77] = v78
    end

    SpotLight.Parent = Part
    p11.Light = Part
end

local function playSong(p12, p13) -- line: 240
    -- upvalues: SoundService (copy), TweenService (copy), LocalPlayer (copy), BoxingSettings (copy), Entrance (copy), fadeSound (copy)
    fadeSound(p12.Song, 0.5)
    p12.Song = nil

    if not p13 or not p13.Song or BoxingSettings.Get("WalkoutSongs") == false then
        return
    end

    local t27 = {
        Name = "WalkoutSong",
        Volume = 0,
        SoundId = "rbxassetid://" .. tostring(p13.Song.Sound),
        SoundGroup = SoundService:FindFirstChild("BoxingMusic")
    }
    local Sound2 = Instance.new("Sound")

    for v79, v80 in t27 do
        Sound2[v79] = v80
    end

    Sound2.Parent = SoundService
    Sound2:Play()
    TweenService:Create(Sound2, TweenInfo.new(0.5), {
        Volume = Entrance.SongVolume or 0.8
    }):Play()
    p12.Song = Sound2
    LocalPlayer:SetAttribute("WalkoutPlaying", true)
end

local function flat(p14) -- line: 254
    local v81 = p14 * Vector3.new(1, 0, 1)

    if v81.Magnitude > 0.05 then
        return v81.Unit
    end

    return (Vector3.new(0, 0, 1))
end

local v82 = RaycastParams.new()

v82.FilterType = Enum.RaycastFilterType.Exclude

local function clear(p15, p16) -- line: 262
    -- upvalues: Players (copy), ScreenGui (copy), v82 (copy)
    local t28 = {
        ScreenGui
    }

    for _, player in Players:GetPlayers() do
        if player.Character then
            table.insert(t28, player.Character)
        end
    end

    v82.FilterDescendantsInstances = t28

    local v83 = workspace:Raycast(p15, p16 - p15, v82)

    if v83 then
        return v83.Position + (p15 - p16).Unit * 0.6
    end

    return p16
end

local function cameraStep(p17) -- line: 277
    -- upvalues: t19 (ref), stopScene (copy), clear (copy)
    local t29 = t19

    if t29 and t29.TookCamera then
        if os.clock() > t29.Deadline then
            stopScene()
        else
            local CurrentCamera = workspace.CurrentCamera

            CurrentCamera.CameraType = Enum.CameraType.Scriptable

            local v84

            if t29.Mode == "Walker" and t29.Walker and t29.Walker.Parent then
                local HumanoidRootPart = t29.Walker:FindFirstChild("HumanoidRootPart")
                local v85 = t29.Walker:FindFirstChild("Head") or HumanoidRootPart

                if HumanoidRootPart and v85 then
                    local v86 = HumanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
                    local v87 = if v86.Magnitude > 0.05 then v86.Unit else Vector3.new(0, 0, 1)
                    local v88 = v87:Cross((Vector3.new(0, 1, 0)))
                    local v89 = os.clock() - (t29.WalkerAt or os.clock())

                    if v89 < (t29.Data.Hold or 1.8) then
                        local v91 = math.clamp(v89 / (t29.Data.Hold or 1.8), 0, 1)
                        local v92 = v85.Position + v87 * (6.2 - v91 * 1.8) + v88 * 0.8 + Vector3.new(0, 0.35, 0)

                        v84 = CFrame.lookAt(clear(v85.Position, v92), v85.Position + Vector3.new(0, 0.1, 0))

                        if not t29.Placed then
                            t29.Placed = true
                            CurrentCamera.CFrame = v84
                        end
                    else
                        local v93 = HumanoidRootPart.Position + v87 * 10 + v88 * 2.2 + Vector3.new(0, 2.8, 0)

                        v84 = CFrame.lookAt(clear(HumanoidRootPart.Position + Vector3.new(0, 2, 0), v93), HumanoidRootPart.Position + Vector3.new(0, 1.3, 0))
                    end

                    if t29.Light then
                        t29.Light.CFrame = CFrame.new(v85.Position + Vector3.new(0, 14, 0))
                    end
                end
            elseif t29.Mode == "FaceOff" and t29.Data then
                local Red = t29.Data.Red and t29.Data.Red.Character and t29.Data.Red.Character:FindFirstChild("HumanoidRootPart")
                local Blue = t29.Data.Blue and t29.Data.Blue.Character and t29.Data.Blue.Character:FindFirstChild("HumanoidRootPart")
                local v94 = if not Red or not Blue then t29.Data.Centre else (Red.Position + Blue.Position) / 2
                local v95 = if not Red or not Blue then 30 else ((Blue.Position - Red.Position) * Vector3.new(1, 0, 1)).Magnitude
                local v96

                if not Red or not Blue then
                    v96 = Vector3.new(1, 0, 0)
                else
                    local v97 = (Blue.Position - Red.Position) * Vector3.new(1, 0, 1)

                    v96 = if v97.Magnitude > 0.05 then v97.Unit else Vector3.new(0, 0, 1)
                end

                local ViewportSize = CurrentCamera.ViewportSize
                local v98 = if ViewportSize.Y > 0 then ViewportSize.X / ViewportSize.Y else 1.7777777777777777
                local v99 = v95 / 2 + 6
                local v100 = v99 / (0.4663076581549986 * v98)
                local v101 = v94 + Vector3.new(0, 2.5, 0)

                if not t29.FaceSide then
                    local n1 = 1
                    local n2 = -1

                    for _, v102 in { 1, -1 } do
                        local Magnitude = (clear(v101, v101 + v96:Cross((Vector3.new(0, 1, 0))) * v102 * v100 + Vector3.new(0, v100 * 0.3, 0)) - v101).Magnitude

                        if n2 < Magnitude then
                            n2 = Magnitude
                            n1 = v102
                        end
                    end

                    t29.FaceSide = n1
                    t29.Angle = 0
                end

                t29.Angle = math.min(t29.Angle + p17 * 0.035, 0.16)

                local v109 = clear(v101, v101 + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), t29.Angle) * (v96:Cross((Vector3.new(0, 1, 0))) * t29.FaceSide) * v100 + Vector3.new(0, v100 * 0.3, 0))
                local v112 = math.deg(math.atan(v99 / (math.max((v109 - v101).Magnitude, 4) * v98)) * 2)

                CurrentCamera.FieldOfView = CurrentCamera.FieldOfView + (math.clamp(v112, 40, 90) - CurrentCamera.FieldOfView) * (1 - math.exp(-p17 * 4))
                v84 = CFrame.lookAt(v109, v101)

                if t29.Light then
                    t29.Light.CFrame = CFrame.new(v94 + Vector3.new(0, 18, 0))
                end
            end

            if v84 then
                CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(v84, 1 - math.exp(-p17 * 4))
            end
        end
    end
end

RunService:BindToRenderStep("WalkoutCamera", Enum.RenderPriority.Camera.Value + 2, function(p18) -- line: 356
    -- upvalues: stopScene (copy), cameraStep (copy)
    local ok, result = pcall(cameraStep, p18)

    if not ok then
        warn("[WalkoutController] " .. tostring(result))
        stopScene()
    end
end)
UserInputService.InputBegan:Connect(function(p19, p20) -- line: 365
    -- upvalues: t19 (ref), v65 (ref), stopScene (copy)
    local t30 = t19

    if not p20 and t30 and t30.TookCamera and not (os.clock() - (t30.StartedAt or 0) < 0.8) then
        local UserInputType = p19.UserInputType

        if UserInputType == Enum.UserInputType.Keyboard or UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch or p19.KeyCode == Enum.KeyCode.ButtonA or p19.KeyCode == Enum.KeyCode.ButtonB then
            v65 = true
            stopScene()
        end
    end
end)
WalkoutRemote.OnClientEvent:Connect(function(p21, p22) -- line: 379
    -- upvalues: TweenService (copy), t1 (copy), TextLabel5 (copy), UIStroke2 (copy), showCard (copy), hideCard (copy), v65 (ref), stopScene (copy), startScene (copy), crowd (copy), smoke (copy), spotlight (copy), playSong (copy)
    if p21 == "End" then
        v65 = false
        stopScene()
    else
        if p21 == "Walker" or p21 == "FaceOff" then
            v65 = false
        end

        if not v65 and type(p22) == "table" then
            if p21 == "Begin" then
                startScene()
            elseif p21 == "Walker" then
                local v117 = startScene()

                if not v117 then
                    return
                end

                local v118 = p22.Info or {}

                v117.Mode = "Walker"
                v117.Data = p22
                v117.Walker = v118.Character
                v117.WalkerAt = os.clock()
                v117.Placed = false
                v117.Deadline = os.clock() + (p22.Hold or 2) + (p22.Walk or 9) + 12
                playSong(v117, v118)
                crowd()
                smoke(p22.Spawn)

                if v117.TookCamera then
                    spotlight(v117)
                    showCard(v118)
                end
            elseif p21 == "FaceOff" then
                local v119 = startScene()

                if not v119 then
                    return
                end

                v119.Mode = "FaceOff"
                v119.Data = p22
                v119.Deadline = os.clock() + 12

                if v119.TookCamera then
                    hideCard()

                    local v120 = p22.Red or {}
                    local v121 = p22.Blue or {}
                    local format = string.format
                    local Red = t1.Red
                    local v127 = string.format("#%02X%02X%02X", math.floor(Red.R * 255), math.floor(Red.G * 255), (math.floor(Red.B * 255)))
                    local Name = v120.Name
                    local v130 = tostring((string.upper((tostring(Name or ""))))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                    local Blue = t1.Blue
                    local v136 = string.format("#%02X%02X%02X", math.floor(Blue.R * 255), math.floor(Blue.G * 255), (math.floor(Blue.B * 255)))
                    local Name2 = v121.Name

                    TextLabel5.Text = format("<font color=\"%s\">%s</font>   VS   <font color=\"%s\">%s</font>", v127, v130, v136, (tostring((string.upper((tostring(Name2 or ""))))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")))
                    TweenService:Create(TextLabel5, TweenInfo.new(0.4), {
                        TextTransparency = 0
                    }):Play()
                    TweenService:Create(UIStroke2, TweenInfo.new(0.4), {
                        Transparency = 0
                    }):Play()
                end
            end
        end
    end
end)
LocalPlayer.CharacterAdded:Connect(function() -- line: 434
    -- upvalues: t19 (ref), stopScene (copy)
    if t19 then
        stopScene()
    end
end)


// ============================================
// END OF: WalkoutController (1).luau
// ============================================

// ============================================
// FILE: WalkoutController (2).luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\WalkoutController (2).luau
// SIZE: 26254 bytes
// ============================================
-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Boxing = ReplicatedStorage:WaitForChild("Boxing")
local Walkouts = require(Boxing:WaitForChild("Walkouts"))
local BoxingSettings = require(Boxing:WaitForChild("BoxingSettings"))
local MenuState = require(Boxing:WaitForChild("MenuState"))
local WalkoutRemote = Boxing:WaitForChild("WalkoutRemote")
local Entrance = Walkouts.Entrance
local v1 = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Bold)
local v2 = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
local t1 = {
    Red = Color3.fromRGB(214, 38, 46),
    Blue = Color3.fromRGB(44, 108, 232)
}
local v3 = Color3.fromRGB(245, 242, 236)
local v4 = Color3.fromRGB(190, 186, 180)

local function new(p1, p2, p3) -- line: 35
    local v5 = Instance.new(p1)

    for v6, v7 in p2 do
        v5[v6] = v7
    end

    v5.Parent = p3

    return v5
end

local t2 = {
    Name = "WalkoutGui",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 70,
    Enabled = false
}
local ScreenGui = Instance.new("ScreenGui")

for v8, v9 in t2 do
    ScreenGui[v8] = v9
end

ScreenGui.Parent = PlayerGui

local t3 = {
    Name = "Top",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.new(0, 0, 0),
    Size = UDim2.fromScale(1, 0)
}
local Frame = Instance.new("Frame")

for v10, v11 in t3 do
    Frame[v10] = v11
end

Frame.Parent = ScreenGui

local t4 = {
    Name = "Bottom",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.new(0, 0, 0),
    AnchorPoint = Vector2.new(0, 1),
    Position = UDim2.fromScale(0, 1),
    Size = UDim2.fromScale(1, 0)
}
local Frame2 = Instance.new("Frame")

for v12, v13 in t4 do
    Frame2[v12] = v13
end

Frame2.Parent = ScreenGui

local t5 = {}
local UIScale = Instance.new("UIScale")

for v14, v15 in t5 do
    UIScale[v14] = v15
end

UIScale.Parent = ScreenGui

local v16 = UDim2.new(0, 60, 0.86, 0)
local v17 = UDim2.new(0, -700, 0.86, 0)
local t6 = {
    Name = "Card",
    BackgroundTransparency = 0.18,
    BorderSizePixel = 0,
    AnchorPoint = Vector2.new(0, 1),
    Position = v17,
    Size = UDim2.fromOffset(620, 168),
    BackgroundColor3 = Color3.fromRGB(12, 12, 14)
}
local Frame3 = Instance.new("Frame")

for v18, v19 in t6 do
    Frame3[v18] = v19
end

Frame3.Parent = ScreenGui

local t7 = {
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.75, 0.15),
        NumberSequenceKeypoint.new(1, 1)
    })
}
local UIGradient = Instance.new("UIGradient")

for v20, v21 in t7 do
    UIGradient[v20] = v21
end

UIGradient.Parent = Frame3

local t8 = {
    Name = "Strip",
    BorderSizePixel = 0,
    Size = UDim2.new(0, 10, 1, 0),
    BackgroundColor3 = t1.Red
}
local Frame4 = Instance.new("Frame")

for v22, v23 in t8 do
    Frame4[v22] = v23
end

Frame4.Parent = Frame3

local t9 = {
    Name = "Corner",
    BackgroundTransparency = 1,
    TextSize = 16,
    Text = "",
    Position = UDim2.fromOffset(30, 10),
    Size = UDim2.new(1, -40, 0, 22),
    FontFace = v2,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = t1.Red
}
local TextLabel = Instance.new("TextLabel")

for v24, v25 in t9 do
    TextLabel[v24] = v25
end

TextLabel.Parent = Frame3

local t10 = {
    Name = "BoxerName",
    BackgroundTransparency = 1,
    TextSize = 56,
    Text = "",
    Position = UDim2.fromOffset(28, 30),
    Size = UDim2.new(1, -40, 0, 60),
    FontFace = v1,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = v3,
    TextTruncate = Enum.TextTruncate.AtEnd
}
local TextLabel2 = Instance.new("TextLabel")

for v26, v27 in t10 do
    TextLabel2[v26] = v27
end

TextLabel2.Parent = Frame3

local t11 = {
    Thickness = 2,
    Color = Color3.new(0, 0, 0)
}
local UIStroke = Instance.new("UIStroke")

for v28, v29 in t11 do
    UIStroke[v28] = v29
end

UIStroke.Parent = TextLabel2

local t12 = {
    Name = "Details",
    BackgroundTransparency = 1,
    TextSize = 18,
    Text = "",
    Position = UDim2.fromOffset(30, 92),
    Size = UDim2.new(1, -40, 0, 24),
    FontFace = v2,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = v4
}
local TextLabel3 = Instance.new("TextLabel")

for v30, v31 in t12 do
    TextLabel3[v30] = v31
end

TextLabel3.Parent = Frame3

local t13 = {
    Name = "Song",
    BackgroundTransparency = 1,
    TextSize = 19,
    RichText = true,
    Text = "",
    Position = UDim2.fromOffset(30, 124),
    Size = UDim2.new(1, -40, 0, 26),
    FontFace = v2,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = v3
}
local TextLabel4 = Instance.new("TextLabel")

for v32, v33 in t13 do
    TextLabel4[v32] = v33
end

TextLabel4.Parent = Frame3

local t14 = {
    Name = "Versus",
    BackgroundTransparency = 1,
    TextSize = 58,
    RichText = true,
    TextTransparency = 1,
    Text = "",
    AnchorPoint = Vector2.new(0.5, 1),
    Position = UDim2.new(0.5, 0, 0.88, 0),
    Size = UDim2.fromOffset(1200, 70),
    FontFace = v1,
    TextColor3 = v3
}
local TextLabel5 = Instance.new("TextLabel")

for v34, v35 in t14 do
    TextLabel5[v34] = v35
end

TextLabel5.Parent = ScreenGui

local t15 = {
    Thickness = 2.5,
    Transparency = 1,
    Color = Color3.new(0, 0, 0)
}
local UIStroke2 = Instance.new("UIStroke")

for v36, v37 in t15 do
    UIStroke2[v36] = v37
end

UIStroke2.Parent = TextLabel5

local t16 = {
    Name = "Skip",
    BackgroundTransparency = 1,
    TextSize = 14,
    TextTransparency = 0.25,
    Text = "PRESS ANY KEY TO SKIP",
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -24, 1, -14),
    Size = UDim2.fromOffset(360, 22),
    FontFace = v2,
    TextXAlignment = Enum.TextXAlignment.Right,
    TextColor3 = v4
}
local TextLabel6 = Instance.new("TextLabel")

for v38, v39 in t16 do
    TextLabel6[v38] = v39
end

TextLabel6.Parent = ScreenGui

if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    TextLabel6.Text = "TAP TO SKIP"
end

local function rescale() -- line: 69
    -- upvalues: UIScale (copy)
    UIScale.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 1000, 0.55, 1.3)
end

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(rescale)
UIScale.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 1000, 0.55, 1.3)

local function upper(p4) -- line: 75
    return string.upper((tostring(p4 or "")))
end

local function escape(p5) -- line: 79
    return (tostring(p5):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function hex(p6) -- line: 83
    return string.format("#%02X%02X%02X", math.floor(p6.R * 255), math.floor(p6.G * 255), (math.floor(p6.B * 255)))
end

local function showCard(p7) -- line: 87
    -- upvalues: TweenService (copy), Walkouts (copy), t1 (copy), v3 (copy), v16 (copy), v17 (copy), Frame3 (copy), Frame4 (copy), TextLabel (copy), TextLabel2 (copy), TextLabel3 (copy), TextLabel4 (copy), upper (copy)
    local v48 = t1[p7.Side] or v3

    Frame4.BackgroundColor3 = v48
    TextLabel.TextColor3 = v48

    local Side = p7.Side

    TextLabel.Text = string.upper((tostring(Side or ""))) .. " CORNER"

    local Name = p7.Name

    TextLabel2.Text = string.upper((tostring(Name or "")))

    local t17 = {}
    local t18 = {
        p7.Rank,
        p7.Class,
        if p7.Record then p7.Record .. " (W-L-D)" else nil
    }

    for _, v52 in t18 do
        if v52 and v52 ~= "" then
            table.insert(t17, upper(v52))
        end
    end

    TextLabel3.Text = table.concat(t17, "   Â·   ")

    if p7.Song then
        local format = string.format
        local Name = p7.Song.Name
        local v55 = tostring((string.upper((tostring(Name or ""))))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
        local v56 = Walkouts.RarityColor(p7.Song.Rarity)
        local v62 = string.format("#%02X%02X%02X", math.floor(v56.R * 255), math.floor(v56.G * 255), (math.floor(v56.B * 255)))
        local Rarity = p7.Song.Rarity

        TextLabel4.Text = format("WALKOUT: %s  <font color=\"%s\">%s</font>", v55, v62, (tostring((string.upper((tostring(Rarity or ""))))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")))
    else
        TextLabel4.Text = "<font color=\"#9A968F\">NO WALKOUT SONG</font>"
    end

    Frame3.Position = v17
    TweenService:Create(Frame3, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = v16
    }):Play()
end

local function hideCard() -- line: 109
    -- upvalues: TweenService (copy), v17 (copy), Frame3 (copy)
    TweenService:Create(Frame3, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = v17
    }):Play()
end

local t19
local v65 = false

local function fadeSound(p8, p9) -- line: 117
    -- upvalues: TweenService (copy)
    if not p8 then
        return
    end

    local tween = TweenService:Create(p8, TweenInfo.new(p9 or 0.6), {
        Volume = 0
    })

    tween.Completed:Once(function() -- line: 122
        -- upvalues: p8 (copy)
        p8:Destroy()
    end)
    tween:Play()
end

local function stopScene() -- line: 128
    -- upvalues: TweenService (copy), LocalPlayer (copy), MenuState (copy), Entrance (copy), ScreenGui (copy), Frame (copy), Frame2 (copy), TextLabel5 (copy), UIStroke2 (copy), hideCard (copy), t19 (ref), fadeSound (copy)
    local t20 = t19

    if not t20 then
        return
    end

    t19 = nil

    local function v66() -- line: 134
        -- upvalues: t20 (copy), TweenService (copy), Entrance (copy), ScreenGui (copy), Frame (copy), Frame2 (copy), TextLabel5 (copy), UIStroke2 (copy), hideCard (copy), t19 (ref), fadeSound (copy)
        fadeSound(t20.Song, Entrance.SongFade or 0.8)

        if t20.Light then
            t20.Light:Destroy()
        end

        TweenService:Create(Frame, TweenInfo.new(0.3), {
            Size = UDim2.fromScale(1, 0)
        }):Play()
        TweenService:Create(Frame2, TweenInfo.new(0.3), {
            Size = UDim2.fromScale(1, 0)
        }):Play()
        hideCard()
        TextLabel5.TextTransparency = 1
        UIStroke2.Transparency = 1
        task.delay(0.35, function() -- line: 143
            -- upvalues: ScreenGui (copy), t19 (ref)
            if not t19 then
                ScreenGui.Enabled = false
            end
        end)

        for v67 in t20.Hidden do
            if v67.Parent then
                v67.Enabled = true
            end
        end
    end

    pcall(v66)

    local CurrentCamera = workspace.CurrentCamera

    if t20.TookCamera then
        CurrentCamera.CameraType = Enum.CameraType.Custom
        CurrentCamera.FieldOfView = t20.Saved.FOV

        local v68 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

        if v68 then
            CurrentCamera.CameraSubject = v68
        end
    end

    if t20.Opened then
        MenuState.Close("Walkout")
    end

    LocalPlayer:SetAttribute("WalkoutPlaying", nil)
end

local function startScene() -- line: 169
    -- upvalues: TweenService (copy), LocalPlayer (copy), PlayerGui (copy), MenuState (copy), ScreenGui (copy), Frame (copy), Frame2 (copy), t19 (ref)
    if t19 then
        return t19
    end

    local Character = LocalPlayer.Character

    if LocalPlayer:GetAttribute("InFrontMenu") or Character and Character:GetAttribute("InCreator") then
        return nil
    end

    local CurrentCamera = workspace.CurrentCamera
    local t21 = {
        Angle = 0,
        Saved = {
            FOV = CurrentCamera.FieldOfView
        },
        Hidden = {},
        Deadline = os.clock() + 40
    }

    t21.Opened = MenuState.Open("Walkout")
    t21.TookCamera = t21.Opened
    t19 = t21

    if t21.TookCamera then
        for _, child in PlayerGui:GetChildren() do
            if child:IsA("ScreenGui") and child ~= ScreenGui and child.Enabled and child.Name ~= "TouchGui" then
                t21.Hidden[child] = true
                child.Enabled = false
            end
        end

        ScreenGui.Enabled = true
        TweenService:Create(Frame, TweenInfo.new(0.4), {
            Size = UDim2.fromScale(1, 0.09)
        }):Play()
        TweenService:Create(Frame2, TweenInfo.new(0.4), {
            Size = UDim2.fromScale(1, 0.09)
        }):Play()
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        CurrentCamera.FieldOfView = 50
        t21.StartedAt = os.clock()
    end

    return t21
end

local function crowd() -- line: 202
    -- upvalues: SoundService (copy), Entrance (copy)
    if Entrance.CrowdSound then
        local t22 = {
            Name = "WalkoutCrowd",
            SoundId = "rbxassetid://" .. tostring(Entrance.CrowdSound),
            Volume = Entrance.CrowdVolume or 0.3,
            SoundGroup = SoundService:FindFirstChild("BoxingMaster")
        }
        local Sound = Instance.new("Sound")

        for v69, v70 in t22 do
            Sound[v69] = v70
        end

        Sound.Parent = SoundService
        Sound:Play()
        task.delay(12, function() -- line: 208
            -- upvalues: Sound (copy)
            Sound:Destroy()
        end)
    end
end

local function smoke(p10) -- line: 213
    if not p10 then
        return
    end

    local t23 = {
        Name = "WalkoutSmoke",
        Anchored = true,
        CanCollide = false,
        CanQuery = false,
        CanTouch = false,
        Transparency = 1,
        Size = Vector3.new(4, 1, 4),
        CFrame = p10
    }
    local _workspace = workspace
    local Part = Instance.new("Part")

    for v71, v72 in t23 do
        Part[v71] = v72
    end

    Part.Parent = _workspace

    local t24 = {
        Texture = "rbxasset://textures/particles/smoke_main.dds",
        Rate = 0,
        LightEmission = 0.15,
        Acceleration = Vector3.new(0, 1.5, 0),
        Drag = 1.5,
        Lifetime = NumberRange.new(1.6, 2.8),
        Speed = NumberRange.new(2, 6),
        SpreadAngle = Vector2.new(180, 30),
        Color = ColorSequence.new(Color3.fromRGB(220, 220, 228)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 2.5),
            NumberSequenceKeypoint.new(1, 8)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.45),
            NumberSequenceKeypoint.new(1, 1)
        })
    }
    local ParticleEmitter = Instance.new("ParticleEmitter")

    for v73, v74 in t24 do
        ParticleEmitter[v73] = v74
    end

    ParticleEmitter.Parent = Part
    ParticleEmitter:Emit(36)
    task.delay(4, function() -- line: 226
        -- upvalues: Part (copy)
        Part:Destroy()
    end)
end

local function spotlight(p11) -- line: 231
    if p11.Light then
        return
    end

    local t25 = {
        Name = "WalkoutLight",
        Anchored = true,
        CanCollide = false,
        CanQuery = false,
        CanTouch = false,
        Transparency = 1,
        Size = Vector3.new(1, 1, 1)
    }
    local _workspace = workspace
    local Part = Instance.new("Part")

    for v75, v76 in t25 do
        Part[v75] = v76
    end

    Part.Parent = _workspace

    local t26 = {
        Brightness = 7,
        Range = 30,
        Angle = 46,
        Shadows = false,
        Face = Enum.NormalId.Bottom,
        Color = Color3.fromRGB(255, 240, 222)
    }
    local SpotLight = Instance.new("SpotLight")

    for v77, v78 in t26 do
        SpotLight[v77] = v78
    end

    SpotLight.Parent = Part
    p11.Light = Part
end

local function playSong(p12, p13) -- line: 240
    -- upvalues: SoundService (copy), TweenService (copy), LocalPlayer (copy), BoxingSettings (copy), Entrance (copy), fadeSound (copy)
    fadeSound(p12.Song, 0.5)
    p12.Song = nil

    if not p13 or not p13.Song or BoxingSettings.Get("WalkoutSongs") == false then
        return
    end

    local t27 = {
        Name = "WalkoutSong",
        Volume = 0,
        SoundId = "rbxassetid://" .. tostring(p13.Song.Sound),
        SoundGroup = SoundService:FindFirstChild("BoxingMusic")
    }
    local Sound2 = Instance.new("Sound")

    for v79, v80 in t27 do
        Sound2[v79] = v80
    end

    Sound2.Parent = SoundService
    Sound2:Play()
    TweenService:Create(Sound2, TweenInfo.new(0.5), {
        Volume = Entrance.SongVolume or 0.8
    }):Play()
    p12.Song = Sound2
    LocalPlayer:SetAttribute("WalkoutPlaying", true)
end

local function flat(p14) -- line: 254
    local v81 = p14 * Vector3.new(1, 0, 1)

    if v81.Magnitude > 0.05 then
        return v81.Unit
    end

    return (Vector3.new(0, 0, 1))
end

local v82 = RaycastParams.new()

v82.FilterType = Enum.RaycastFilterType.Exclude

local function clear(p15, p16) -- line: 262
    -- upvalues: Players (copy), ScreenGui (copy), v82 (copy)
    local t28 = {
        ScreenGui
    }

    for _, player in Players:GetPlayers() do
        if player.Character then
            table.insert(t28, player.Character)
        end
    end

    v82.FilterDescendantsInstances = t28

    local v83 = workspace:Raycast(p15, p16 - p15, v82)

    if v83 then
        return v83.Position + (p15 - p16).Unit * 0.6
    end

    return p16
end

local function cameraStep(p17) -- line: 277
    -- upvalues: t19 (ref), stopScene (copy), clear (copy)
    local t29 = t19

    if t29 and t29.TookCamera then
        if os.clock() > t29.Deadline then
            stopScene()
        else
            local CurrentCamera = workspace.CurrentCamera

            CurrentCamera.CameraType = Enum.CameraType.Scriptable

            local v84

            if t29.Mode == "Walker" and t29.Walker and t29.Walker.Parent then
                local HumanoidRootPart = t29.Walker:FindFirstChild("HumanoidRootPart")
                local v85 = t29.Walker:FindFirstChild("Head") or HumanoidRootPart

                if HumanoidRootPart and v85 then
                    local v86 = HumanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
                    local v87 = if v86.Magnitude > 0.05 then v86.Unit else Vector3.new(0, 0, 1)
                    local v88 = v87:Cross((Vector3.new(0, 1, 0)))
                    local v89 = os.clock() - (t29.WalkerAt or os.clock())

                    if v89 < (t29.Data.Hold or 1.8) then
                        local v91 = math.clamp(v89 / (t29.Data.Hold or 1.8), 0, 1)
                        local v92 = v85.Position + v87 * (6.2 - v91 * 1.8) + v88 * 0.8 + Vector3.new(0, 0.35, 0)

                        v84 = CFrame.lookAt(clear(v85.Position, v92), v85.Position + Vector3.new(0, 0.1, 0))

                        if not t29.Placed then
                            t29.Placed = true
                            CurrentCamera.CFrame = v84
                        end
                    else
                        local v93 = HumanoidRootPart.Position + v87 * 10 + v88 * 2.2 + Vector3.new(0, 2.8, 0)

                        v84 = CFrame.lookAt(clear(HumanoidRootPart.Position + Vector3.new(0, 2, 0), v93), HumanoidRootPart.Position + Vector3.new(0, 1.3, 0))
                    end

                    if t29.Light then
                        t29.Light.CFrame = CFrame.new(v85.Position + Vector3.new(0, 14, 0))
                    end
                end
            elseif t29.Mode == "FaceOff" and t29.Data then
                local Red = t29.Data.Red and t29.Data.Red.Character and t29.Data.Red.Character:FindFirstChild("HumanoidRootPart")
                local Blue = t29.Data.Blue and t29.Data.Blue.Character and t29.Data.Blue.Character:FindFirstChild("HumanoidRootPart")
                local v94 = if not Red or not Blue then t29.Data.Centre else (Red.Position + Blue.Position) / 2
                local v95 = if not Red or not Blue then 30 else ((Blue.Position - Red.Position) * Vector3.new(1, 0, 1)).Magnitude
                local v96

                if not Red or not Blue then
                    v96 = Vector3.new(1, 0, 0)
                else
                    local v97 = (Blue.Position - Red.Position) * Vector3.new(1, 0, 1)

                    v96 = if v97.Magnitude > 0.05 then v97.Unit else Vector3.new(0, 0, 1)
                end

                local ViewportSize = CurrentCamera.ViewportSize
                local v98 = if ViewportSize.Y > 0 then ViewportSize.X / ViewportSize.Y else 1.7777777777777777
                local v99 = v95 / 2 + 6
                local v100 = v99 / (0.4663076581549986 * v98)
                local v101 = v94 + Vector3.new(0, 2.5, 0)

                if not t29.FaceSide then
                    local n1 = 1
                    local n2 = -1

                    for _, v102 in { 1, -1 } do
                        local Magnitude = (clear(v101, v101 + v96:Cross((Vector3.new(0, 1, 0))) * v102 * v100 + Vector3.new(0, v100 * 0.3, 0)) - v101).Magnitude

                        if n2 < Magnitude then
                            n2 = Magnitude
                            n1 = v102
                        end
                    end

                    t29.FaceSide = n1
                    t29.Angle = 0
                end

                t29.Angle = math.min(t29.Angle + p17 * 0.035, 0.16)

                local v109 = clear(v101, v101 + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), t29.Angle) * (v96:Cross((Vector3.new(0, 1, 0))) * t29.FaceSide) * v100 + Vector3.new(0, v100 * 0.3, 0))
                local v112 = math.deg(math.atan(v99 / (math.max((v109 - v101).Magnitude, 4) * v98)) * 2)

                CurrentCamera.FieldOfView = CurrentCamera.FieldOfView + (math.clamp(v112, 40, 90) - CurrentCamera.FieldOfView) * (1 - math.exp(-p17 * 4))
                v84 = CFrame.lookAt(v109, v101)

                if t29.Light then
                    t29.Light.CFrame = CFrame.new(v94 + Vector3.new(0, 18, 0))
                end
            end

            if v84 then
                CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(v84, 1 - math.exp(-p17 * 4))
            end
        end
    end
end

RunService:BindToRenderStep("WalkoutCamera", Enum.RenderPriority.Camera.Value + 2, function(p18) -- line: 356
    -- upvalues: stopScene (copy), cameraStep (copy)
    local ok, result = pcall(cameraStep, p18)

    if not ok then
        warn("[WalkoutController] " .. tostring(result))
        stopScene()
    end
end)
UserInputService.InputBegan:Connect(function(p19, p20) -- line: 365
    -- upvalues: t19 (ref), v65 (ref), stopScene (copy)
    local t30 = t19

    if not p20 and t30 and t30.TookCamera and not (os.clock() - (t30.StartedAt or 0) < 0.8) then
        local UserInputType = p19.UserInputType

        if UserInputType == Enum.UserInputType.Keyboard or UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch or p19.KeyCode == Enum.KeyCode.ButtonA or p19.KeyCode == Enum.KeyCode.ButtonB then
            v65 = true
            stopScene()
        end
    end
end)
WalkoutRemote.OnClientEvent:Connect(function(p21, p22) -- line: 379
    -- upvalues: TweenService (copy), t1 (copy), TextLabel5 (copy), UIStroke2 (copy), showCard (copy), hideCard (copy), v65 (ref), stopScene (copy), startScene (copy), crowd (copy), smoke (copy), spotlight (copy), playSong (copy)
    if p21 == "End" then
        v65 = false
        stopScene()
    else
        if p21 == "Walker" or p21 == "FaceOff" then
            v65 = false
        end

        if not v65 and type(p22) == "table" then
            if p21 == "Begin" then
                startScene()
            elseif p21 == "Walker" then
                local v117 = startScene()

                if not v117 then
                    return
                end

                local v118 = p22.Info or {}

                v117.Mode = "Walker"
                v117.Data = p22
                v117.Walker = v118.Character
                v117.WalkerAt = os.clock()
                v117.Placed = false
                v117.Deadline = os.clock() + (p22.Hold or 2) + (p22.Walk or 9) + 12
                playSong(v117, v118)
                crowd()
                smoke(p22.Spawn)

                if v117.TookCamera then
                    spotlight(v117)
                    showCard(v118)
                end
            elseif p21 == "FaceOff" then
                local v119 = startScene()

                if not v119 then
                    return
                end

                v119.Mode = "FaceOff"
                v119.Data = p22
                v119.Deadline = os.clock() + 12

                if v119.TookCamera then
                    hideCard()

                    local v120 = p22.Red or {}
                    local v121 = p22.Blue or {}
                    local format = string.format
                    local Red = t1.Red
                    local v127 = string.format("#%02X%02X%02X", math.floor(Red.R * 255), math.floor(Red.G * 255), (math.floor(Red.B * 255)))
                    local Name = v120.Name
                    local v130 = tostring((string.upper((tostring(Name or ""))))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                    local Blue = t1.Blue
                    local v136 = string.format("#%02X%02X%02X", math.floor(Blue.R * 255), math.floor(Blue.G * 255), (math.floor(Blue.B * 255)))
                    local Name2 = v121.Name

                    TextLabel5.Text = format("<font color=\"%s\">%s</font>   VS   <font color=\"%s\">%s</font>", v127, v130, v136, (tostring((string.upper((tostring(Name2 or ""))))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")))
                    TweenService:Create(TextLabel5, TweenInfo.new(0.4), {
                        TextTransparency = 0
                    }):Play()
                    TweenService:Create(UIStroke2, TweenInfo.new(0.4), {
                        Transparency = 0
                    }):Play()
                end
            end
        end
    end
end)
LocalPlayer.CharacterAdded:Connect(function() -- line: 434
    -- upvalues: t19 (ref), stopScene (copy)
    if t19 then
        stopScene()
    end
end)


// ============================================
// END OF: WalkoutController (2).luau
// ============================================

// ============================================
// FILE: WalkoutController.luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\WalkoutController.luau
// SIZE: 26254 bytes
// ============================================
-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Boxing = ReplicatedStorage:WaitForChild("Boxing")
local Walkouts = require(Boxing:WaitForChild("Walkouts"))
local BoxingSettings = require(Boxing:WaitForChild("BoxingSettings"))
local MenuState = require(Boxing:WaitForChild("MenuState"))
local WalkoutRemote = Boxing:WaitForChild("WalkoutRemote")
local Entrance = Walkouts.Entrance
local v1 = Font.new("rbxasset://fonts/families/Oswald.json", Enum.FontWeight.Bold)
local v2 = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
local t1 = {
    Red = Color3.fromRGB(214, 38, 46),
    Blue = Color3.fromRGB(44, 108, 232)
}
local v3 = Color3.fromRGB(245, 242, 236)
local v4 = Color3.fromRGB(190, 186, 180)

local function new(p1, p2, p3) -- line: 35
    local v5 = Instance.new(p1)

    for v6, v7 in p2 do
        v5[v6] = v7
    end

    v5.Parent = p3

    return v5
end

local t2 = {
    Name = "WalkoutGui",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 70,
    Enabled = false
}
local ScreenGui = Instance.new("ScreenGui")

for v8, v9 in t2 do
    ScreenGui[v8] = v9
end

ScreenGui.Parent = PlayerGui

local t3 = {
    Name = "Top",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.new(0, 0, 0),
    Size = UDim2.fromScale(1, 0)
}
local Frame = Instance.new("Frame")

for v10, v11 in t3 do
    Frame[v10] = v11
end

Frame.Parent = ScreenGui

local t4 = {
    Name = "Bottom",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.new(0, 0, 0),
    AnchorPoint = Vector2.new(0, 1),
    Position = UDim2.fromScale(0, 1),
    Size = UDim2.fromScale(1, 0)
}
local Frame2 = Instance.new("Frame")

for v12, v13 in t4 do
    Frame2[v12] = v13
end

Frame2.Parent = ScreenGui

local t5 = {}
local UIScale = Instance.new("UIScale")

for v14, v15 in t5 do
    UIScale[v14] = v15
end

UIScale.Parent = ScreenGui

local v16 = UDim2.new(0, 60, 0.86, 0)
local v17 = UDim2.new(0, -700, 0.86, 0)
local t6 = {
    Name = "Card",
    BackgroundTransparency = 0.18,
    BorderSizePixel = 0,
    AnchorPoint = Vector2.new(0, 1),
    Position = v17,
    Size = UDim2.fromOffset(620, 168),
    BackgroundColor3 = Color3.fromRGB(12, 12, 14)
}
local Frame3 = Instance.new("Frame")

for v18, v19 in t6 do
    Frame3[v18] = v19
end

Frame3.Parent = ScreenGui

local t7 = {
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.75, 0.15),
        NumberSequenceKeypoint.new(1, 1)
    })
}
local UIGradient = Instance.new("UIGradient")

for v20, v21 in t7 do
    UIGradient[v20] = v21
end

UIGradient.Parent = Frame3

local t8 = {
    Name = "Strip",
    BorderSizePixel = 0,
    Size = UDim2.new(0, 10, 1, 0),
    BackgroundColor3 = t1.Red
}
local Frame4 = Instance.new("Frame")

for v22, v23 in t8 do
    Frame4[v22] = v23
end

Frame4.Parent = Frame3

local t9 = {
    Name = "Corner",
    BackgroundTransparency = 1,
    TextSize = 16,
    Text = "",
    Position = UDim2.fromOffset(30, 10),
    Size = UDim2.new(1, -40, 0, 22),
    FontFace = v2,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = t1.Red
}
local TextLabel = Instance.new("TextLabel")

for v24, v25 in t9 do
    TextLabel[v24] = v25
end

TextLabel.Parent = Frame3

local t10 = {
    Name = "BoxerName",
    BackgroundTransparency = 1,
    TextSize = 56,
    Text = "",
    Position = UDim2.fromOffset(28, 30),
    Size = UDim2.new(1, -40, 0, 60),
    FontFace = v1,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = v3,
    TextTruncate = Enum.TextTruncate.AtEnd
}
local TextLabel2 = Instance.new("TextLabel")

for v26, v27 in t10 do
    TextLabel2[v26] = v27
end

TextLabel2.Parent = Frame3

local t11 = {
    Thickness = 2,
    Color = Color3.new(0, 0, 0)
}
local UIStroke = Instance.new("UIStroke")

for v28, v29 in t11 do
    UIStroke[v28] = v29
end

UIStroke.Parent = TextLabel2

local t12 = {
    Name = "Details",
    BackgroundTransparency = 1,
    TextSize = 18,
    Text = "",
    Position = UDim2.fromOffset(30, 92),
    Size = UDim2.new(1, -40, 0, 24),
    FontFace = v2,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = v4
}
local TextLabel3 = Instance.new("TextLabel")

for v30, v31 in t12 do
    TextLabel3[v30] = v31
end

TextLabel3.Parent = Frame3

local t13 = {
    Name = "Song",
    BackgroundTransparency = 1,
    TextSize = 19,
    RichText = true,
    Text = "",
    Position = UDim2.fromOffset(30, 124),
    Size = UDim2.new(1, -40, 0, 26),
    FontFace = v2,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = v3
}
local TextLabel4 = Instance.new("TextLabel")

for v32, v33 in t13 do
    TextLabel4[v32] = v33
end

TextLabel4.Parent = Frame3

local t14 = {
    Name = "Versus",
    BackgroundTransparency = 1,
    TextSize = 58,
    RichText = true,
    TextTransparency = 1,
    Text = "",
    AnchorPoint = Vector2.new(0.5, 1),
    Position = UDim2.new(0.5, 0, 0.88, 0),
    Size = UDim2.fromOffset(1200, 70),
    FontFace = v1,
    TextColor3 = v3
}
local TextLabel5 = Instance.new("TextLabel")

for v34, v35 in t14 do
    TextLabel5[v34] = v35
end

TextLabel5.Parent = ScreenGui

local t15 = {
    Thickness = 2.5,
    Transparency = 1,
    Color = Color3.new(0, 0, 0)
}
local UIStroke2 = Instance.new("UIStroke")

for v36, v37 in t15 do
    UIStroke2[v36] = v37
end

UIStroke2.Parent = TextLabel5

local t16 = {
    Name = "Skip",
    BackgroundTransparency = 1,
    TextSize = 14,
    TextTransparency = 0.25,
    Text = "PRESS ANY KEY TO SKIP",
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -24, 1, -14),
    Size = UDim2.fromOffset(360, 22),
    FontFace = v2,
    TextXAlignment = Enum.TextXAlignment.Right,
    TextColor3 = v4
}
local TextLabel6 = Instance.new("TextLabel")

for v38, v39 in t16 do
    TextLabel6[v38] = v39
end

TextLabel6.Parent = ScreenGui

if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    TextLabel6.Text = "TAP TO SKIP"
end

local function rescale() -- line: 69
    -- upvalues: UIScale (copy)
    UIScale.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 1000, 0.55, 1.3)
end

workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(rescale)
UIScale.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 1000, 0.55, 1.3)

local function upper(p4) -- line: 75
    return string.upper((tostring(p4 or "")))
end

local function escape(p5) -- line: 79
    return (tostring(p5):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function hex(p6) -- line: 83
    return string.format("#%02X%02X%02X", math.floor(p6.R * 255), math.floor(p6.G * 255), (math.floor(p6.B * 255)))
end

local function showCard(p7) -- line: 87
    -- upvalues: TweenService (copy), Walkouts (copy), t1 (copy), v3 (copy), v16 (copy), v17 (copy), Frame3 (copy), Frame4 (copy), TextLabel (copy), TextLabel2 (copy), TextLabel3 (copy), TextLabel4 (copy), upper (copy)
    local v48 = t1[p7.Side] or v3

    Frame4.BackgroundColor3 = v48
    TextLabel.TextColor3 = v48

    local Side = p7.Side

    TextLabel.Text = string.upper((tostring(Side or ""))) .. " CORNER"

    local Name = p7.Name

    TextLabel2.Text = string.upper((tostring(Name or "")))

    local t17 = {}
    local t18 = {
        p7.Rank,
        p7.Class,
        if p7.Record then p7.Record .. " (W-L-D)" else nil
    }

    for _, v52 in t18 do
        if v52 and v52 ~= "" then
            table.insert(t17, upper(v52))
        end
    end

    TextLabel3.Text = table.concat(t17, "   Â·   ")

    if p7.Song then
        local format = string.format
        local Name = p7.Song.Name
        local v55 = tostring((string.upper((tostring(Name or ""))))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
        local v56 = Walkouts.RarityColor(p7.Song.Rarity)
        local v62 = string.format("#%02X%02X%02X", math.floor(v56.R * 255), math.floor(v56.G * 255), (math.floor(v56.B * 255)))
        local Rarity = p7.Song.Rarity

        TextLabel4.Text = format("WALKOUT: %s  <font color=\"%s\">%s</font>", v55, v62, (tostring((string.upper((tostring(Rarity or ""))))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")))
    else
        TextLabel4.Text = "<font color=\"#9A968F\">NO WALKOUT SONG</font>"
    end

    Frame3.Position = v17
    TweenService:Create(Frame3, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = v16
    }):Play()
end

local function hideCard() -- line: 109
    -- upvalues: TweenService (copy), v17 (copy), Frame3 (copy)
    TweenService:Create(Frame3, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = v17
    }):Play()
end

local t19
local v65 = false

local function fadeSound(p8, p9) -- line: 117
    -- upvalues: TweenService (copy)
    if not p8 then
        return
    end

    local tween = TweenService:Create(p8, TweenInfo.new(p9 or 0.6), {
        Volume = 0
    })

    tween.Completed:Once(function() -- line: 122
        -- upvalues: p8 (copy)
        p8:Destroy()
    end)
    tween:Play()
end

local function stopScene() -- line: 128
    -- upvalues: TweenService (copy), LocalPlayer (copy), MenuState (copy), Entrance (copy), ScreenGui (copy), Frame (copy), Frame2 (copy), TextLabel5 (copy), UIStroke2 (copy), hideCard (copy), t19 (ref), fadeSound (copy)
    local t20 = t19

    if not t20 then
        return
    end

    t19 = nil

    local function v66() -- line: 134
        -- upvalues: t20 (copy), TweenService (copy), Entrance (copy), ScreenGui (copy), Frame (copy), Frame2 (copy), TextLabel5 (copy), UIStroke2 (copy), hideCard (copy), t19 (ref), fadeSound (copy)
        fadeSound(t20.Song, Entrance.SongFade or 0.8)

        if t20.Light then
            t20.Light:Destroy()
        end

        TweenService:Create(Frame, TweenInfo.new(0.3), {
            Size = UDim2.fromScale(1, 0)
        }):Play()
        TweenService:Create(Frame2, TweenInfo.new(0.3), {
            Size = UDim2.fromScale(1, 0)
        }):Play()
        hideCard()
        TextLabel5.TextTransparency = 1
        UIStroke2.Transparency = 1
        task.delay(0.35, function() -- line: 143
            -- upvalues: ScreenGui (copy), t19 (ref)
            if not t19 then
                ScreenGui.Enabled = false
            end
        end)

        for v67 in t20.Hidden do
            if v67.Parent then
                v67.Enabled = true
            end
        end
    end

    pcall(v66)

    local CurrentCamera = workspace.CurrentCamera

    if t20.TookCamera then
        CurrentCamera.CameraType = Enum.CameraType.Custom
        CurrentCamera.FieldOfView = t20.Saved.FOV

        local v68 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

        if v68 then
            CurrentCamera.CameraSubject = v68
        end
    end

    if t20.Opened then
        MenuState.Close("Walkout")
    end

    LocalPlayer:SetAttribute("WalkoutPlaying", nil)
end

local function startScene() -- line: 169
    -- upvalues: TweenService (copy), LocalPlayer (copy), PlayerGui (copy), MenuState (copy), ScreenGui (copy), Frame (copy), Frame2 (copy), t19 (ref)
    if t19 then
        return t19
    end

    local Character = LocalPlayer.Character

    if LocalPlayer:GetAttribute("InFrontMenu") or Character and Character:GetAttribute("InCreator") then
        return nil
    end

    local CurrentCamera = workspace.CurrentCamera
    local t21 = {
        Angle = 0,
        Saved = {
            FOV = CurrentCamera.FieldOfView
        },
        Hidden = {},
        Deadline = os.clock() + 40
    }

    t21.Opened = MenuState.Open("Walkout")
    t21.TookCamera = t21.Opened
    t19 = t21

    if t21.TookCamera then
        for _, child in PlayerGui:GetChildren() do
            if child:IsA("ScreenGui") and child ~= ScreenGui and child.Enabled and child.Name ~= "TouchGui" then
                t21.Hidden[child] = true
                child.Enabled = false
            end
        end

        ScreenGui.Enabled = true
        TweenService:Create(Frame, TweenInfo.new(0.4), {
            Size = UDim2.fromScale(1, 0.09)
        }):Play()
        TweenService:Create(Frame2, TweenInfo.new(0.4), {
            Size = UDim2.fromScale(1, 0.09)
        }):Play()
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
        CurrentCamera.FieldOfView = 50
        t21.StartedAt = os.clock()
    end

    return t21
end

local function crowd() -- line: 202
    -- upvalues: SoundService (copy), Entrance (copy)
    if Entrance.CrowdSound then
        local t22 = {
            Name = "WalkoutCrowd",
            SoundId = "rbxassetid://" .. tostring(Entrance.CrowdSound),
            Volume = Entrance.CrowdVolume or 0.3,
            SoundGroup = SoundService:FindFirstChild("BoxingMaster")
        }
        local Sound = Instance.new("Sound")

        for v69, v70 in t22 do
            Sound[v69] = v70
        end

        Sound.Parent = SoundService
        Sound:Play()
        task.delay(12, function() -- line: 208
            -- upvalues: Sound (copy)
            Sound:Destroy()
        end)
    end
end

local function smoke(p10) -- line: 213
    if not p10 then
        return
    end

    local t23 = {
        Name = "WalkoutSmoke",
        Anchored = true,
        CanCollide = false,
        CanQuery = false,
        CanTouch = false,
        Transparency = 1,
        Size = Vector3.new(4, 1, 4),
        CFrame = p10
    }
    local _workspace = workspace
    local Part = Instance.new("Part")

    for v71, v72 in t23 do
        Part[v71] = v72
    end

    Part.Parent = _workspace

    local t24 = {
        Texture = "rbxasset://textures/particles/smoke_main.dds",
        Rate = 0,
        LightEmission = 0.15,
        Acceleration = Vector3.new(0, 1.5, 0),
        Drag = 1.5,
        Lifetime = NumberRange.new(1.6, 2.8),
        Speed = NumberRange.new(2, 6),
        SpreadAngle = Vector2.new(180, 30),
        Color = ColorSequence.new(Color3.fromRGB(220, 220, 228)),
        Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 2.5),
            NumberSequenceKeypoint.new(1, 8)
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.45),
            NumberSequenceKeypoint.new(1, 1)
        })
    }
    local ParticleEmitter = Instance.new("ParticleEmitter")

    for v73, v74 in t24 do
        ParticleEmitter[v73] = v74
    end

    ParticleEmitter.Parent = Part
    ParticleEmitter:Emit(36)
    task.delay(4, function() -- line: 226
        -- upvalues: Part (copy)
        Part:Destroy()
    end)
end

local function spotlight(p11) -- line: 231
    if p11.Light then
        return
    end

    local t25 = {
        Name = "WalkoutLight",
        Anchored = true,
        CanCollide = false,
        CanQuery = false,
        CanTouch = false,
        Transparency = 1,
        Size = Vector3.new(1, 1, 1)
    }
    local _workspace = workspace
    local Part = Instance.new("Part")

    for v75, v76 in t25 do
        Part[v75] = v76
    end

    Part.Parent = _workspace

    local t26 = {
        Brightness = 7,
        Range = 30,
        Angle = 46,
        Shadows = false,
        Face = Enum.NormalId.Bottom,
        Color = Color3.fromRGB(255, 240, 222)
    }
    local SpotLight = Instance.new("SpotLight")

    for v77, v78 in t26 do
        SpotLight[v77] = v78
    end

    SpotLight.Parent = Part
    p11.Light = Part
end

local function playSong(p12, p13) -- line: 240
    -- upvalues: SoundService (copy), TweenService (copy), LocalPlayer (copy), BoxingSettings (copy), Entrance (copy), fadeSound (copy)
    fadeSound(p12.Song, 0.5)
    p12.Song = nil

    if not p13 or not p13.Song or BoxingSettings.Get("WalkoutSongs") == false then
        return
    end

    local t27 = {
        Name = "WalkoutSong",
        Volume = 0,
        SoundId = "rbxassetid://" .. tostring(p13.Song.Sound),
        SoundGroup = SoundService:FindFirstChild("BoxingMusic")
    }
    local Sound2 = Instance.new("Sound")

    for v79, v80 in t27 do
        Sound2[v79] = v80
    end

    Sound2.Parent = SoundService
    Sound2:Play()
    TweenService:Create(Sound2, TweenInfo.new(0.5), {
        Volume = Entrance.SongVolume or 0.8
    }):Play()
    p12.Song = Sound2
    LocalPlayer:SetAttribute("WalkoutPlaying", true)
end

local function flat(p14) -- line: 254
    local v81 = p14 * Vector3.new(1, 0, 1)

    if v81.Magnitude > 0.05 then
        return v81.Unit
    end

    return (Vector3.new(0, 0, 1))
end

local v82 = RaycastParams.new()

v82.FilterType = Enum.RaycastFilterType.Exclude

local function clear(p15, p16) -- line: 262
    -- upvalues: Players (copy), ScreenGui (copy), v82 (copy)
    local t28 = {
        ScreenGui
    }

    for _, player in Players:GetPlayers() do
        if player.Character then
            table.insert(t28, player.Character)
        end
    end

    v82.FilterDescendantsInstances = t28

    local v83 = workspace:Raycast(p15, p16 - p15, v82)

    if v83 then
        return v83.Position + (p15 - p16).Unit * 0.6
    end

    return p16
end

local function cameraStep(p17) -- line: 277
    -- upvalues: t19 (ref), stopScene (copy), clear (copy)
    local t29 = t19

    if t29 and t29.TookCamera then
        if os.clock() > t29.Deadline then
            stopScene()
        else
            local CurrentCamera = workspace.CurrentCamera

            CurrentCamera.CameraType = Enum.CameraType.Scriptable

            local v84

            if t29.Mode == "Walker" and t29.Walker and t29.Walker.Parent then
                local HumanoidRootPart = t29.Walker:FindFirstChild("HumanoidRootPart")
                local v85 = t29.Walker:FindFirstChild("Head") or HumanoidRootPart

                if HumanoidRootPart and v85 then
                    local v86 = HumanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
                    local v87 = if v86.Magnitude > 0.05 then v86.Unit else Vector3.new(0, 0, 1)
                    local v88 = v87:Cross((Vector3.new(0, 1, 0)))
                    local v89 = os.clock() - (t29.WalkerAt or os.clock())

                    if v89 < (t29.Data.Hold or 1.8) then
                        local v91 = math.clamp(v89 / (t29.Data.Hold or 1.8), 0, 1)
                        local v92 = v85.Position + v87 * (6.2 - v91 * 1.8) + v88 * 0.8 + Vector3.new(0, 0.35, 0)

                        v84 = CFrame.lookAt(clear(v85.Position, v92), v85.Position + Vector3.new(0, 0.1, 0))

                        if not t29.Placed then
                            t29.Placed = true
                            CurrentCamera.CFrame = v84
                        end
                    else
                        local v93 = HumanoidRootPart.Position + v87 * 10 + v88 * 2.2 + Vector3.new(0, 2.8, 0)

                        v84 = CFrame.lookAt(clear(HumanoidRootPart.Position + Vector3.new(0, 2, 0), v93), HumanoidRootPart.Position + Vector3.new(0, 1.3, 0))
                    end

                    if t29.Light then
                        t29.Light.CFrame = CFrame.new(v85.Position + Vector3.new(0, 14, 0))
                    end
                end
            elseif t29.Mode == "FaceOff" and t29.Data then
                local Red = t29.Data.Red and t29.Data.Red.Character and t29.Data.Red.Character:FindFirstChild("HumanoidRootPart")
                local Blue = t29.Data.Blue and t29.Data.Blue.Character and t29.Data.Blue.Character:FindFirstChild("HumanoidRootPart")
                local v94 = if not Red or not Blue then t29.Data.Centre else (Red.Position + Blue.Position) / 2
                local v95 = if not Red or not Blue then 30 else ((Blue.Position - Red.Position) * Vector3.new(1, 0, 1)).Magnitude
                local v96

                if not Red or not Blue then
                    v96 = Vector3.new(1, 0, 0)
                else
                    local v97 = (Blue.Position - Red.Position) * Vector3.new(1, 0, 1)

                    v96 = if v97.Magnitude > 0.05 then v97.Unit else Vector3.new(0, 0, 1)
                end

                local ViewportSize = CurrentCamera.ViewportSize
                local v98 = if ViewportSize.Y > 0 then ViewportSize.X / ViewportSize.Y else 1.7777777777777777
                local v99 = v95 / 2 + 6
                local v100 = v99 / (0.4663076581549986 * v98)
                local v101 = v94 + Vector3.new(0, 2.5, 0)

                if not t29.FaceSide then
                    local n1 = 1
                    local n2 = -1

                    for _, v102 in { 1, -1 } do
                        local Magnitude = (clear(v101, v101 + v96:Cross((Vector3.new(0, 1, 0))) * v102 * v100 + Vector3.new(0, v100 * 0.3, 0)) - v101).Magnitude

                        if n2 < Magnitude then
                            n2 = Magnitude
                            n1 = v102
                        end
                    end

                    t29.FaceSide = n1
                    t29.Angle = 0
                end

                t29.Angle = math.min(t29.Angle + p17 * 0.035, 0.16)

                local v109 = clear(v101, v101 + CFrame.fromAxisAngle(Vector3.new(0, 1, 0), t29.Angle) * (v96:Cross((Vector3.new(0, 1, 0))) * t29.FaceSide) * v100 + Vector3.new(0, v100 * 0.3, 0))
                local v112 = math.deg(math.atan(v99 / (math.max((v109 - v101).Magnitude, 4) * v98)) * 2)

                CurrentCamera.FieldOfView = CurrentCamera.FieldOfView + (math.clamp(v112, 40, 90) - CurrentCamera.FieldOfView) * (1 - math.exp(-p17 * 4))
                v84 = CFrame.lookAt(v109, v101)

                if t29.Light then
                    t29.Light.CFrame = CFrame.new(v94 + Vector3.new(0, 18, 0))
                end
            end

            if v84 then
                CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(v84, 1 - math.exp(-p17 * 4))
            end
        end
    end
end

RunService:BindToRenderStep("WalkoutCamera", Enum.RenderPriority.Camera.Value + 2, function(p18) -- line: 356
    -- upvalues: stopScene (copy), cameraStep (copy)
    local ok, result = pcall(cameraStep, p18)

    if not ok then
        warn("[WalkoutController] " .. tostring(result))
        stopScene()
    end
end)
UserInputService.InputBegan:Connect(function(p19, p20) -- line: 365
    -- upvalues: t19 (ref), v65 (ref), stopScene (copy)
    local t30 = t19

    if not p20 and t30 and t30.TookCamera and not (os.clock() - (t30.StartedAt or 0) < 0.8) then
        local UserInputType = p19.UserInputType

        if UserInputType == Enum.UserInputType.Keyboard or UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch or p19.KeyCode == Enum.KeyCode.ButtonA or p19.KeyCode == Enum.KeyCode.ButtonB then
            v65 = true
            stopScene()
        end
    end
end)
WalkoutRemote.OnClientEvent:Connect(function(p21, p22) -- line: 379
    -- upvalues: TweenService (copy), t1 (copy), TextLabel5 (copy), UIStroke2 (copy), showCard (copy), hideCard (copy), v65 (ref), stopScene (copy), startScene (copy), crowd (copy), smoke (copy), spotlight (copy), playSong (copy)
    if p21 == "End" then
        v65 = false
        stopScene()
    else
        if p21 == "Walker" or p21 == "FaceOff" then
            v65 = false
        end

        if not v65 and type(p22) == "table" then
            if p21 == "Begin" then
                startScene()
            elseif p21 == "Walker" then
                local v117 = startScene()

                if not v117 then
                    return
                end

                local v118 = p22.Info or {}

                v117.Mode = "Walker"
                v117.Data = p22
                v117.Walker = v118.Character
                v117.WalkerAt = os.clock()
                v117.Placed = false
                v117.Deadline = os.clock() + (p22.Hold or 2) + (p22.Walk or 9) + 12
                playSong(v117, v118)
                crowd()
                smoke(p22.Spawn)

                if v117.TookCamera then
                    spotlight(v117)
                    showCard(v118)
                end
            elseif p21 == "FaceOff" then
                local v119 = startScene()

                if not v119 then
                    return
                end

                v119.Mode = "FaceOff"
                v119.Data = p22
                v119.Deadline = os.clock() + 12

                if v119.TookCamera then
                    hideCard()

                    local v120 = p22.Red or {}
                    local v121 = p22.Blue or {}
                    local format = string.format
                    local Red = t1.Red
                    local v127 = string.format("#%02X%02X%02X", math.floor(Red.R * 255), math.floor(Red.G * 255), (math.floor(Red.B * 255)))
                    local Name = v120.Name
                    local v130 = tostring((string.upper((tostring(Name or ""))))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
                    local Blue = t1.Blue
                    local v136 = string.format("#%02X%02X%02X", math.floor(Blue.R * 255), math.floor(Blue.G * 255), (math.floor(Blue.B * 255)))
                    local Name2 = v121.Name

                    TextLabel5.Text = format("<font color=\"%s\">%s</font>   VS   <font color=\"%s\">%s</font>", v127, v130, v136, (tostring((string.upper((tostring(Name2 or ""))))):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")))
                    TweenService:Create(TextLabel5, TweenInfo.new(0.4), {
                        TextTransparency = 0
                    }):Play()
                    TweenService:Create(UIStroke2, TweenInfo.new(0.4), {
                        Transparency = 0
                    }):Play()
                end
            end
        end
    end
end)
LocalPlayer.CharacterAdded:Connect(function() -- line: 434
    -- upvalues: t19 (ref), stopScene (copy)
    if t19 then
        stopScene()
    end
end)


// ============================================
// END OF: WalkoutController.luau
// ============================================

// ============================================
// FILE: Walkouts (1).luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\Walkouts (1).luau
// SIZE: 2406 bytes
// ============================================
-- https://lua.expert

local t1 = {
    Songs = {
        {
            Id = "Makunouchi",
            Name = "Makunouchi Walkout",
            Sound = 94429103791429,
            Rarity = "Common",
            Weight = 35
        },
        {
            Id = "Canelo",
            Name = "Canelo Walkout",
            Sound = 111345800862054,
            Rarity = "Rare",
            Weight = 30
        },
        {
            Id = "Martinez",
            Name = "Martinez Walkout",
            Sound = 112864368564637,
            Rarity = "Epic",
            Weight = 20
        },
        {
            Id = "Mike",
            Name = "Mike Walkout",
            Sound = 75710064610726,
            Rarity = "Legendary",
            Weight = 15
        }
    },
    Rarities = {
        Common = {
            Order = 1,
            Color = Color3.fromRGB(196, 196, 204)
        },
        Rare = {
            Order = 2,
            Color = Color3.fromRGB(90, 160, 255)
        },
        Epic = {
            Order = 3,
            Color = Color3.fromRGB(186, 102, 255)
        },
        Legendary = {
            Order = 4,
            Color = Color3.fromRGB(255, 198, 64)
        }
    },
    PreviewSeconds = 12,
    Entrance = {
        Enabled = true,
        Hall = "KorakuenHall",
        RedSpawn = "redrankedspawn",
        BlueSpawn = "bluerankedspawn",
        IntroHold = 1.8,
        WalkSpeed = 15,
        MaxWalk = 9,
        CornerHold = 0.6,
        FaceOff = 2.6,
        HallRadius = 260,
        SongVolume = 0.8,
        SongFade = 0.8,
        CrowdSound = 9120975204,
        CrowdVolume = 0.3
    }
}
local t2 = {}

for v1, v2 in t1.Songs do
    v2.Index = v1
    t2[v2.Id] = v2
end

function t1.Get(p1) -- line: 56
    -- upvalues: t2 (copy)
    return if type(p1) == "string" then t2[p1] else nil
end

function t1.RarityColor(p2) -- line: 60
    -- upvalues: t1 (copy)
    local v3 = t1.Rarities[p2]

    if v3 then
        return v3.Color
    end

    return (Color3.new(1, 1, 1))
end

function t1.OddsText() -- line: 66
    -- upvalues: t1 (copy)
    local n1 = 0

    for _, v4 in t1.Songs do
        n1 += v4.Weight or 1
    end

    local t3 = {}

    for _, v5 in t1.Songs do
        table.insert(t3, string.format("%s %d%%", string.upper(v5.Rarity), (math.floor((v5.Weight or 1) / n1 * 100 + 0.5))))
    end

    return table.concat(t3, "  Â·  ")
end

return t1


// ============================================
// END OF: Walkouts (1).luau
// ============================================

// ============================================
// FILE: Walkouts.luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\Walkouts.luau
// SIZE: 2406 bytes
// ============================================
-- https://lua.expert

local t1 = {
    Songs = {
        {
            Id = "Makunouchi",
            Name = "Makunouchi Walkout",
            Sound = 94429103791429,
            Rarity = "Common",
            Weight = 35
        },
        {
            Id = "Canelo",
            Name = "Canelo Walkout",
            Sound = 111345800862054,
            Rarity = "Rare",
            Weight = 30
        },
        {
            Id = "Martinez",
            Name = "Martinez Walkout",
            Sound = 112864368564637,
            Rarity = "Epic",
            Weight = 20
        },
        {
            Id = "Mike",
            Name = "Mike Walkout",
            Sound = 75710064610726,
            Rarity = "Legendary",
            Weight = 15
        }
    },
    Rarities = {
        Common = {
            Order = 1,
            Color = Color3.fromRGB(196, 196, 204)
        },
        Rare = {
            Order = 2,
            Color = Color3.fromRGB(90, 160, 255)
        },
        Epic = {
            Order = 3,
            Color = Color3.fromRGB(186, 102, 255)
        },
        Legendary = {
            Order = 4,
            Color = Color3.fromRGB(255, 198, 64)
        }
    },
    PreviewSeconds = 12,
    Entrance = {
        Enabled = true,
        Hall = "KorakuenHall",
        RedSpawn = "redrankedspawn",
        BlueSpawn = "bluerankedspawn",
        IntroHold = 1.8,
        WalkSpeed = 15,
        MaxWalk = 9,
        CornerHold = 0.6,
        FaceOff = 2.6,
        HallRadius = 260,
        SongVolume = 0.8,
        SongFade = 0.8,
        CrowdSound = 9120975204,
        CrowdVolume = 0.3
    }
}
local t2 = {}

for v1, v2 in t1.Songs do
    v2.Index = v1
    t2[v2.Id] = v2
end

function t1.Get(p1) -- line: 56
    -- upvalues: t2 (copy)
    return if type(p1) == "string" then t2[p1] else nil
end

function t1.RarityColor(p2) -- line: 60
    -- upvalues: t1 (copy)
    local v3 = t1.Rarities[p2]

    if v3 then
        return v3.Color
    end

    return (Color3.new(1, 1, 1))
end

function t1.OddsText() -- line: 66
    -- upvalues: t1 (copy)
    local n1 = 0

    for _, v4 in t1.Songs do
        n1 += v4.Weight or 1
    end

    local t3 = {}

    for _, v5 in t1.Songs do
        table.insert(t3, string.format("%s %d%%", string.upper(v5.Rarity), (math.floor((v5.Weight or 1) / n1 * 100 + 0.5))))
    end

    return table.concat(t3, "  Â·  ")
end

return t1


// ============================================
// END OF: Walkouts.luau
// ============================================

// ============================================
// FILE: WeighScaleController (1).luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\WeighScaleController (1).luau
// SIZE: 21651 bytes
// ============================================
-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local WeightUnits = require(game:GetService("ReplicatedStorage"):WaitForChild("Boxing"):WaitForChild("WeightUnits"))
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Boxing = ReplicatedStorage:WaitForChild("Boxing")
local BlenderMesh = require(Boxing:WaitForChild("BlenderMesh"))
local WeighScaleMesh = require(Boxing:WaitForChild("WeighScaleMesh"))
local MangaTransition = require(Boxing:WaitForChild("MangaTransition"))
local WeighRemote = Boxing:WaitForChild("WeighRemote")
local LocalPlayer = Players.LocalPlayer
local v1 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy, Enum.FontStyle.Italic)
local v2 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
local v3 = Color3.fromRGB(200, 28, 34)
local v4 = Color3.fromRGB(244, 242, 236)

local function sound(p1, p2) -- line: 37
    local Sound = Instance.new("Sound")

    Sound.SoundId = p1
    Sound.Volume = p2 or 0.6

    return Sound
end

local sounds = workspace:FindFirstChild("sounds")
local ClockTick = if sounds then sounds:FindFirstChild("ClockTick") else nil

if not sounds or not ClockTick then
    ClockTick = Instance.new("Sound")
    ClockTick.SoundId = "rbxassetid://4556286113"
    ClockTick.Volume = 0.4
end

local v5 = if sounds then sounds:FindFirstChild("Heavy Blow") else nil

if not sounds or not v5 then
    v5 = Instance.new("Sound")
    v5.SoundId = "rbxassetid://5102882084"
    v5.Volume = 0.8
end

local Sound = Instance.new("Sound")

Sound.SoundId = "rbxassetid://9125531715"
Sound.Volume = 0.7
Sound.Parent = script

local function dress(p3) -- line: 51
    -- upvalues: BlenderMesh (copy), WeighScaleMesh (copy)
    local v6 = true

    for _, v7 in { "Steel", "Body" } do
        local v8 = p3:FindFirstChild(v7 .. "Mesh")

        if not (v8 and BlenderMesh.Apply(v8, WeighScaleMesh[v7])) then
            v6 = false
        end
    end

    if v6 then
        for _, v9 in { "Steel", "Body" } do
            p3[v9 .. "Mesh"].Transparency = 0
        end

        for _, v10 in { "Platform", "Column", "Head" } do
            local v11 = p3:FindFirstChild(v10)

            if v11 then
                v11.LocalTransparencyModifier = 1
                v11.Transparency = 1
            end
        end
    end
end

local t1 = {}

local function showReading(p4) -- line: 75
    -- upvalues: WeightUnits (copy), t1 (copy)
    local Screen = p4:FindFirstChild("Screen") and p4.Screen:FindFirstChild("Display") and p4.Screen.Display:FindFirstChild("Backlight")

    if not Screen then
        return
    end

    local Digits, Stable = Screen.Digits, Screen.Stable
    local ReadingKg = p4:GetAttribute("ReadingKg")
    local ReadingAt = p4:GetAttribute("ReadingAt")
    local t2 = {}

    t1[p4] = t2

    if not ReadingKg or not ReadingAt then
        Digits.Text = "0.0"
    else
        task.spawn(function() -- line: 88
            -- upvalues: p4 (copy), Digits (copy), Stable (copy), ReadingKg (copy), ReadingAt (copy), t2 (copy), WeightUnits (copy), t1 (copy)
            while true do
                if t1[p4] == t2 then
                    local v12 = workspace:GetServerTimeNow() - ReadingAt

                    if v12 < 2.75 then
                        Digits.Text = "0.0"
                        Stable.TextTransparency = 1
                        task.wait(0.05)
                        continue
                    end

                    if v12 < 4 then
                        local v13 = (v12 - 2.75) / 1.25
                        local v14 = ReadingKg * (1 - (1 - v13) ^ 3) + (1 - v13) * 3 * (math.random() - 0.5)

                        Digits.Text = WeightUnits.Number((math.max(0, v14)))
                        task.wait(0.05)
                        continue
                    end

                    if not (v12 < 9) then
                        break
                    end

                    Digits.Text = WeightUnits.Number(ReadingKg)

                    local v15 = v12 - 2.75 - 1.25
                    local v16 = if not (v15 < 0.6) then 0 elseif math.floor(v15 / 0.15) % 2 == 1 then 1 else 0

                    Stable.TextTransparency = v16
                    task.wait(0.05)
                    continue
                end

                return
            end

            Digits.Text = "0.0"
            Stable.TextTransparency = 1
        end)
    end
end

local function setUp(p5) -- line: 114
    -- upvalues: dress (copy), showReading (copy)
    if p5:GetAttribute("WeighSetUp") then
        return
    end

    p5:SetAttribute("WeighSetUp", true)
    task.spawn(dress, p5)
    p5:GetAttributeChangedSignal("ReadingAt"):Connect(function() -- line: 120
        -- upvalues: p5 (copy), showReading (copy)
        showReading(p5)
    end)
    showReading(p5)
end

for _, v18 in CollectionService:GetTagged("WeighScale") do
    setUp(v18)
end

CollectionService:GetInstanceAddedSignal("WeighScale"):Connect(setUp)

local function new(p6, p7, p8) -- line: 132
    local v19 = Instance.new(p6)

    for v20, v21 in p7 do
        v19[v20] = v21
    end

    v19.Parent = p8

    return v19
end

local v22 = false

local function weighIn(p9) -- line: 142
    -- upvalues: WeightUnits (copy), RunService (copy), SoundService (copy), TweenService (copy), MangaTransition (copy), LocalPlayer (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), ClockTick (ref), v5 (ref), Sound (copy), v22 (ref)
    local Scale = p9.Scale
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local CurrentCamera, CameraType, FieldOfView, v23, v24

    if v22 then
        v24 = true
    elseif Scale and Scale.Parent and HumanoidRootPart then
        v22 = true
        CurrentCamera = workspace.CurrentCamera
        CameraType = CurrentCamera.CameraType
        FieldOfView = CurrentCamera.FieldOfView
        v23 = Scale:FindFirstChild("WeighPrompt", true)

        if v23 then
            v23.Enabled = false
        end

        v24 = false
    else
        v24 = true
    end

    if v24 then
        return
    end

    local Pivot = Scale:GetPivot()
    local v25 = -Pivot.LookVector
    local RightVector, PivotPosition = Pivot.RightVector, Pivot.Position
    local Screen = Scale:FindFirstChild("Screen")
    local v27 = os.clock() - math.max(0, workspace:GetServerTimeNow() - p9.StartAt)
    local t3 = {
        Name = "WeighIn",
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        DisplayOrder = 86
    }
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local ScreenGui = Instance.new("ScreenGui")

    for v28, v29 in t3 do
        ScreenGui[v28] = v29
    end

    ScreenGui.Parent = PlayerGui

    local t4 = {
        BorderSizePixel = 0,
        ZIndex = 5,
        BackgroundColor3 = Color3.new(0, 0, 0),
        Size = UDim2.fromScale(1, 0)
    }
    local Frame = Instance.new("Frame")

    for v30, v31 in t4 do
        Frame[v30] = v31
    end

    Frame.Parent = ScreenGui

    local t5 = {
        BorderSizePixel = 0,
        ZIndex = 5,
        BackgroundColor3 = Color3.new(0, 0, 0),
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0, 1),
        Size = UDim2.fromScale(1, 0)
    }
    local Frame2 = Instance.new("Frame")

    for v32, v33 in t5 do
        Frame2[v32] = v33
    end

    Frame2.Parent = ScreenGui

    for _, v34 in { Frame, Frame2 } do
        TweenService:Create(v34, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(1, 0.11)
        }):Play()
    end

    local t6 = {
        BackgroundTransparency = 1,
        ZIndex = 6,
        Position = UDim2.new(0, 36, 0.11, 14),
        Size = UDim2.fromOffset(620, 34)
    }
    local Frame3 = Instance.new("Frame")

    for v35, v36 in t6 do
        Frame3[v35] = v36
    end

    Frame3.Parent = ScreenGui

    local t7 = {
        BorderSizePixel = 0,
        TextSize = 20,
        Text = "â— LIVE",
        ZIndex = 6,
        BackgroundColor3 = v3,
        Size = UDim2.fromOffset(92, 34),
        FontFace = v1,
        TextColor3 = v4
    }
    local TextLabel = Instance.new("TextLabel")

    for v37, v38 in t7 do
        TextLabel[v37] = v38
    end

    TextLabel.Parent = Frame3

    local t8 = {
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        TextSize = 18,
        ZIndex = 6,
        BackgroundColor3 = Color3.fromRGB(14, 14, 16),
        Position = UDim2.fromOffset(92, 0),
        Size = UDim2.fromOffset(500, 34),
        FontFace = v2,
        TextColor3 = v4,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "   OFFICIAL WEIGH-IN  Â·  " .. string.upper(p9.Location ~= "" and p9.Location or "HAJIME")
    }
    local TextLabel2 = Instance.new("TextLabel")

    for v39, v40 in t8 do
        TextLabel2[v39] = v40
    end

    TextLabel2.Parent = Frame3
    task.spawn(function() -- line: 180
        -- upvalues: ScreenGui (copy), TextLabel (copy)
        while ScreenGui.Parent do
            TextLabel.Text = math.floor(os.clock() * 2) % 2 == 0 and "â— LIVE" or "   LIVE"
            task.wait(0.25)
        end
    end)

    local t9 = {}

    for _, child in LocalPlayer.PlayerGui:GetChildren() do
        if child:IsA("ScreenGui") and child ~= ScreenGui and child.Enabled and child.Name ~= "TouchGui" then
            child.Enabled = false
            table.insert(t9, child)
        end
    end

    CurrentCamera.CameraType = Enum.CameraType.Scriptable

    local n1 = 0
    local v42 = false
    local v43 = false

    local function chest() -- line: 200
        -- upvalues: PivotPosition (copy), HumanoidRootPart (copy)
        return (if HumanoidRootPart.Parent then HumanoidRootPart.Position else PivotPosition + Vector3.new(0, 3, 0)) + Vector3.new(0, 0.9, 0)
    end

    RunService:BindToRenderStep("WeighInCamera", Enum.RenderPriority.Camera.Value + 1, function() -- line: 203
        -- upvalues: p9 (copy), Character (copy), CurrentCamera (ref), CameraType (ref), FieldOfView (ref), v23 (ref), Pivot (copy), v25 (copy), RightVector (copy), PivotPosition (copy), Screen (copy), v27 (ref), ScreenGui (copy), Frame (copy), Frame2 (copy), t9 (copy), n1 (ref), v42 (ref), v43 (ref), HumanoidRootPart (copy), WeightUnits (copy), RunService (copy), SoundService (copy), TweenService (copy), MangaTransition (copy), LocalPlayer (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), ClockTick (ref), v5 (ref), Sound (copy), v22 (ref)
        local v45 = os.clock() - v27
        local v46 = RunService:IsStudio() and LocalPlayer:GetAttribute("WeighDebugT")

        if type(v46) == "number" then
            v27 = os.clock() - v46
        else
            v46 = v45
        end

        if v46 < 2.6 then
            local v48 = math.rad(-50 + 100 * (v46 / 2.6))
            local v49 = PivotPosition + (v25 * math.cos(v48) + RightVector * math.sin(v48)).Unit * (9.8 - 0.9 * v46 / 2.6) + Vector3.new(0, 1.9, 0)

            CurrentCamera.FieldOfView = 55

            local lookAt = CFrame.lookAt
            local v50 = if HumanoidRootPart.Parent then HumanoidRootPart.Position else PivotPosition + Vector3.new(0, 3, 0)

            CurrentCamera.CFrame = lookAt(v49, v50 + Vector3.new(0, 0.9, 0))
        elseif v46 < 4.5 then
            local v51 = if Screen then Screen.CFrame else Pivot * CFrame.new(0, 5, -0.8)
            local v52 = (v46 - 2.6) / 1.9
            local v53 = v51.Position + v51.LookVector * (1.9 - 0.5 * v52) + v51.RightVector * 1.3 + v51.UpVector * 0.55

            CurrentCamera.FieldOfView = 46
            CurrentCamera.CFrame = CFrame.lookAt(v53, v51.Position)
        else
            local v56 = PivotPosition + v25 * (9.6 - math.min(1, (v46 - 4.5) / 2.0999999999999996) * 1.1) + RightVector * 1.6 + Vector3.new(0, 2.4, 0)

            CurrentCamera.FieldOfView = 58

            local lookAt = CFrame.lookAt
            local v57 = if HumanoidRootPart.Parent then HumanoidRootPart.Position else PivotPosition + Vector3.new(0, 3, 0)

            CurrentCamera.CFrame = lookAt(v56, v57 + Vector3.new(0, 0.9, 0) + Vector3.new(0, 0.3, 0))
        end

        if not (v46 >= 2.75 and v46 < 4) then
            if v46 >= 4 and not v42 then
                v42 = true
                SoundService:PlayLocalSound(Sound)
            end
        else
            local v59 = math.floor((v46 - 2.75) / 0.09)

            if n1 < v59 then
                n1 = v59
                SoundService:PlayLocalSound(ClockTick)
            end
        end

        if Character.Parent then
            for _, descendant in Character:GetDescendants() do
                if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" then
                    descendant.LocalTransparencyModifier = 0
                end
            end
        end

        if v46 >= 4.5 and not v43 then
            v43 = true
            task.spawn(function() -- line: 253
                -- upvalues: p9 (copy), CurrentCamera (ref), ScreenGui (copy), WeightUnits (copy), SoundService (copy), TweenService (copy), MangaTransition (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (ref)
                local t10 = {
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Size = UDim2.fromScale(1, 1)
                }
                local Frame = Instance.new("Frame")

                for v60, v61 in t10 do
                    Frame[v60] = v61
                end

                Frame.Parent = ScreenGui
                TweenService:Create(Frame, TweenInfo.new(0.3), {
                    BackgroundTransparency = 1
                }):Play()

                local SpeedLines = MangaTransition.SpeedLines
                local new = Color3.new

                pcall(SpeedLines, ScreenGui, 1.9, new(1, 1, 1))
                SoundService:PlayLocalSound(v5)

                local t11 = {
                    BackgroundTransparency = 1,
                    ZIndex = 7,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.73),
                    Size = UDim2.fromOffset(900, 260)
                }
                local Frame2 = Instance.new("Frame")

                for v62, v63 in t11 do
                    Frame2[v62] = v63
                end

                Frame2.Parent = ScreenGui

                local t12 = {
                    Scale = 1.7
                }
                local UIScale = Instance.new("UIScale")

                for v64, v65 in t12 do
                    UIScale[v64] = v65
                end

                UIScale.Parent = Frame2

                local t13 = {
                    BackgroundTransparency = 1,
                    TextSize = 140,
                    ZIndex = 8,
                    Size = UDim2.new(1, 0, 0, 150),
                    FontFace = v1,
                    TextColor3 = v4,
                    Text = WeightUnits.Upper(p9.Kg)
                }
                local TextLabel = Instance.new("TextLabel")

                for v66, v67 in t13 do
                    TextLabel[v66] = v67
                end

                TextLabel.Parent = Frame2

                local t14 = {
                    Thickness = 5,
                    Color = Color3.new(0, 0, 0)
                }
                local UIStroke = Instance.new("UIStroke")

                for v68, v69 in t14 do
                    UIStroke[v68] = v69
                end

                UIStroke.Parent = TextLabel

                local t15 = {
                    BorderSizePixel = 0,
                    Rotation = -2,
                    ZIndex = 8,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 150),
                    Size = UDim2.fromOffset(560, 64),
                    BackgroundColor3 = if p9.Amateur then Color3.fromRGB(58, 58, 64) else v3
                }
                local Frame3 = Instance.new("Frame")

                for v70, v71 in t15 do
                    Frame3[v70] = v71
                end

                Frame3.Parent = Frame2

                local t16 = {
                    Thickness = 3,
                    Color = Color3.new(0, 0, 0)
                }
                local UIStroke2 = Instance.new("UIStroke")

                for v72, v73 in t16 do
                    UIStroke2[v72] = v73
                end

                UIStroke2.Parent = Frame3

                local t17 = {
                    BackgroundTransparency = 1,
                    TextSize = 46,
                    ZIndex = 9,
                    Size = UDim2.fromScale(1, 1),
                    FontFace = v1,
                    TextColor3 = v4,
                    Text = string.upper(p9.Class)
                }
                local TextLabel2 = Instance.new("TextLabel")

                for v74, v75 in t17 do
                    TextLabel2[v74] = v75
                end

                TextLabel2.Parent = Frame3

                local t18 = {
                    Thickness = 2,
                    Color = Color3.new(0, 0, 0)
                }
                local UIStroke3 = Instance.new("UIStroke")

                for v76, v77 in t18 do
                    UIStroke3[v76] = v77
                end

                UIStroke3.Parent = TextLabel2

                local t19 = {
                    BackgroundTransparency = 1,
                    TextSize = 24,
                    ZIndex = 8,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 222),
                    Size = UDim2.fromOffset(800, 30),
                    FontFace = v2,
                    TextColor3 = v4,
                    Text = if p9.Amateur then "No weight class yet  Â·  Lightweight starts at " .. WeightUnits.Format(61, 0) else WeightUnits.Number(p9.Min, 0) .. " - " .. WeightUnits.Format(p9.Max, 0)
                }
                local TextLabel3 = Instance.new("TextLabel")

                for v78, v79 in t19 do
                    TextLabel3[v78] = v79
                end

                TextLabel3.Parent = Frame2

                local t20 = {
                    Thickness = 2,
                    Color = Color3.new(0, 0, 0)
                }
                local UIStroke4 = Instance.new("UIStroke")

                for v80, v81 in t20 do
                    UIStroke4[v80] = v81
                end

                UIStroke4.Parent = TextLabel3

                local v83 = math.clamp(CurrentCamera.ViewportSize.Y / 1080, 0.55, 1.4)

                TweenService:Create(UIScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Scale = v83
                }):Play()
                Frame3.Size = UDim2.fromOffset(0, 64)
                task.wait(0.18)
                TweenService:Create(Frame3, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.fromOffset(560, 64)
                }):Play()
            end)
        end

        if not (v46 >= 6.6) then
            return
        end

        RunService:UnbindFromRenderStep("WeighInCamera")
        task.spawn(function() -- line: 293
            -- upvalues: ScreenGui (copy), Frame (copy), Frame2 (copy), TweenService (copy)
            for _, descendant in ScreenGui:GetDescendants() do
                if descendant:IsA("TextLabel") then
                    TweenService:Create(descendant, TweenInfo.new(0.25), {
                        TextTransparency = 1,
                        TextStrokeTransparency = 1
                    }):Play()
                elseif descendant:IsA("UIStroke") then
                    TweenService:Create(descendant, TweenInfo.new(0.25), {
                        Transparency = 1
                    }):Play()
                end

                if descendant:IsA("Frame") and descendant ~= Frame and descendant ~= Frame2 and descendant.BackgroundTransparency < 1 then
                    TweenService:Create(descendant, TweenInfo.new(0.25), {
                        BackgroundTransparency = 1
                    }):Play()
                end
            end

            for _, v84 in { Frame, Frame2 } do
                TweenService:Create(v84, TweenInfo.new(0.3), {
                    Size = UDim2.fromScale(1, 0)
                }):Play()
            end

            task.wait(0.32)
            ScreenGui:Destroy()
        end)

        if HumanoidRootPart.Parent then
            local v85 = PivotPosition + v25 * 11 + Vector3.new(0, 5, 0)

            CurrentCamera.CFrame = CFrame.lookAt(v85, HumanoidRootPart.Position + Vector3.new(0, 1, 0))
        end

        local Custom = CameraType == Enum.CameraType.Scriptable and Enum.CameraType.Custom or CameraType

        CurrentCamera.CameraType = Custom
        CurrentCamera.FieldOfView = FieldOfView

        for _, v86 in t9 do
            if v86.Parent then
                v86.Enabled = true
            end
        end

        if v23 then
            v23.Enabled = true
        end

        v22 = false
    end)
end

WeighRemote.OnClientEvent:Connect(function(p10, p11) -- line: 331
    -- upvalues: weighIn (copy)
    if p10 == "WeighIn" and type(p11) == "table" then
        weighIn(p11)
    end
end)


// ============================================
// END OF: WeighScaleController (1).luau
// ============================================

// ============================================
// FILE: WeighScaleController (2).luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\WeighScaleController (2).luau
// SIZE: 21651 bytes
// ============================================
-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local WeightUnits = require(game:GetService("ReplicatedStorage"):WaitForChild("Boxing"):WaitForChild("WeightUnits"))
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Boxing = ReplicatedStorage:WaitForChild("Boxing")
local BlenderMesh = require(Boxing:WaitForChild("BlenderMesh"))
local WeighScaleMesh = require(Boxing:WaitForChild("WeighScaleMesh"))
local MangaTransition = require(Boxing:WaitForChild("MangaTransition"))
local WeighRemote = Boxing:WaitForChild("WeighRemote")
local LocalPlayer = Players.LocalPlayer
local v1 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy, Enum.FontStyle.Italic)
local v2 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
local v3 = Color3.fromRGB(200, 28, 34)
local v4 = Color3.fromRGB(244, 242, 236)

local function sound(p1, p2) -- line: 37
    local Sound = Instance.new("Sound")

    Sound.SoundId = p1
    Sound.Volume = p2 or 0.6

    return Sound
end

local sounds = workspace:FindFirstChild("sounds")
local ClockTick = if sounds then sounds:FindFirstChild("ClockTick") else nil

if not sounds or not ClockTick then
    ClockTick = Instance.new("Sound")
    ClockTick.SoundId = "rbxassetid://4556286113"
    ClockTick.Volume = 0.4
end

local v5 = if sounds then sounds:FindFirstChild("Heavy Blow") else nil

if not sounds or not v5 then
    v5 = Instance.new("Sound")
    v5.SoundId = "rbxassetid://5102882084"
    v5.Volume = 0.8
end

local Sound = Instance.new("Sound")

Sound.SoundId = "rbxassetid://9125531715"
Sound.Volume = 0.7
Sound.Parent = script

local function dress(p3) -- line: 51
    -- upvalues: BlenderMesh (copy), WeighScaleMesh (copy)
    local v6 = true

    for _, v7 in { "Steel", "Body" } do
        local v8 = p3:FindFirstChild(v7 .. "Mesh")

        if not (v8 and BlenderMesh.Apply(v8, WeighScaleMesh[v7])) then
            v6 = false
        end
    end

    if v6 then
        for _, v9 in { "Steel", "Body" } do
            p3[v9 .. "Mesh"].Transparency = 0
        end

        for _, v10 in { "Platform", "Column", "Head" } do
            local v11 = p3:FindFirstChild(v10)

            if v11 then
                v11.LocalTransparencyModifier = 1
                v11.Transparency = 1
            end
        end
    end
end

local t1 = {}

local function showReading(p4) -- line: 75
    -- upvalues: WeightUnits (copy), t1 (copy)
    local Screen = p4:FindFirstChild("Screen") and p4.Screen:FindFirstChild("Display") and p4.Screen.Display:FindFirstChild("Backlight")

    if not Screen then
        return
    end

    local Digits, Stable = Screen.Digits, Screen.Stable
    local ReadingKg = p4:GetAttribute("ReadingKg")
    local ReadingAt = p4:GetAttribute("ReadingAt")
    local t2 = {}

    t1[p4] = t2

    if not ReadingKg or not ReadingAt then
        Digits.Text = "0.0"
    else
        task.spawn(function() -- line: 88
            -- upvalues: p4 (copy), Digits (copy), Stable (copy), ReadingKg (copy), ReadingAt (copy), t2 (copy), WeightUnits (copy), t1 (copy)
            while true do
                if t1[p4] == t2 then
                    local v12 = workspace:GetServerTimeNow() - ReadingAt

                    if v12 < 2.75 then
                        Digits.Text = "0.0"
                        Stable.TextTransparency = 1
                        task.wait(0.05)
                        continue
                    end

                    if v12 < 4 then
                        local v13 = (v12 - 2.75) / 1.25
                        local v14 = ReadingKg * (1 - (1 - v13) ^ 3) + (1 - v13) * 3 * (math.random() - 0.5)

                        Digits.Text = WeightUnits.Number((math.max(0, v14)))
                        task.wait(0.05)
                        continue
                    end

                    if not (v12 < 9) then
                        break
                    end

                    Digits.Text = WeightUnits.Number(ReadingKg)

                    local v15 = v12 - 2.75 - 1.25
                    local v16 = if not (v15 < 0.6) then 0 elseif math.floor(v15 / 0.15) % 2 == 1 then 1 else 0

                    Stable.TextTransparency = v16
                    task.wait(0.05)
                    continue
                end

                return
            end

            Digits.Text = "0.0"
            Stable.TextTransparency = 1
        end)
    end
end

local function setUp(p5) -- line: 114
    -- upvalues: dress (copy), showReading (copy)
    if p5:GetAttribute("WeighSetUp") then
        return
    end

    p5:SetAttribute("WeighSetUp", true)
    task.spawn(dress, p5)
    p5:GetAttributeChangedSignal("ReadingAt"):Connect(function() -- line: 120
        -- upvalues: p5 (copy), showReading (copy)
        showReading(p5)
    end)
    showReading(p5)
end

for _, v18 in CollectionService:GetTagged("WeighScale") do
    setUp(v18)
end

CollectionService:GetInstanceAddedSignal("WeighScale"):Connect(setUp)

local function new(p6, p7, p8) -- line: 132
    local v19 = Instance.new(p6)

    for v20, v21 in p7 do
        v19[v20] = v21
    end

    v19.Parent = p8

    return v19
end

local v22 = false

local function weighIn(p9) -- line: 142
    -- upvalues: WeightUnits (copy), RunService (copy), SoundService (copy), TweenService (copy), MangaTransition (copy), LocalPlayer (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), ClockTick (ref), v5 (ref), Sound (copy), v22 (ref)
    local Scale = p9.Scale
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local CurrentCamera, CameraType, FieldOfView, v23, v24

    if v22 then
        v24 = true
    elseif Scale and Scale.Parent and HumanoidRootPart then
        v22 = true
        CurrentCamera = workspace.CurrentCamera
        CameraType = CurrentCamera.CameraType
        FieldOfView = CurrentCamera.FieldOfView
        v23 = Scale:FindFirstChild("WeighPrompt", true)

        if v23 then
            v23.Enabled = false
        end

        v24 = false
    else
        v24 = true
    end

    if v24 then
        return
    end

    local Pivot = Scale:GetPivot()
    local v25 = -Pivot.LookVector
    local RightVector, PivotPosition = Pivot.RightVector, Pivot.Position
    local Screen = Scale:FindFirstChild("Screen")
    local v27 = os.clock() - math.max(0, workspace:GetServerTimeNow() - p9.StartAt)
    local t3 = {
        Name = "WeighIn",
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        DisplayOrder = 86
    }
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local ScreenGui = Instance.new("ScreenGui")

    for v28, v29 in t3 do
        ScreenGui[v28] = v29
    end

    ScreenGui.Parent = PlayerGui

    local t4 = {
        BorderSizePixel = 0,
        ZIndex = 5,
        BackgroundColor3 = Color3.new(0, 0, 0),
        Size = UDim2.fromScale(1, 0)
    }
    local Frame = Instance.new("Frame")

    for v30, v31 in t4 do
        Frame[v30] = v31
    end

    Frame.Parent = ScreenGui

    local t5 = {
        BorderSizePixel = 0,
        ZIndex = 5,
        BackgroundColor3 = Color3.new(0, 0, 0),
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0, 1),
        Size = UDim2.fromScale(1, 0)
    }
    local Frame2 = Instance.new("Frame")

    for v32, v33 in t5 do
        Frame2[v32] = v33
    end

    Frame2.Parent = ScreenGui

    for _, v34 in { Frame, Frame2 } do
        TweenService:Create(v34, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(1, 0.11)
        }):Play()
    end

    local t6 = {
        BackgroundTransparency = 1,
        ZIndex = 6,
        Position = UDim2.new(0, 36, 0.11, 14),
        Size = UDim2.fromOffset(620, 34)
    }
    local Frame3 = Instance.new("Frame")

    for v35, v36 in t6 do
        Frame3[v35] = v36
    end

    Frame3.Parent = ScreenGui

    local t7 = {
        BorderSizePixel = 0,
        TextSize = 20,
        Text = "â— LIVE",
        ZIndex = 6,
        BackgroundColor3 = v3,
        Size = UDim2.fromOffset(92, 34),
        FontFace = v1,
        TextColor3 = v4
    }
    local TextLabel = Instance.new("TextLabel")

    for v37, v38 in t7 do
        TextLabel[v37] = v38
    end

    TextLabel.Parent = Frame3

    local t8 = {
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        TextSize = 18,
        ZIndex = 6,
        BackgroundColor3 = Color3.fromRGB(14, 14, 16),
        Position = UDim2.fromOffset(92, 0),
        Size = UDim2.fromOffset(500, 34),
        FontFace = v2,
        TextColor3 = v4,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "   OFFICIAL WEIGH-IN  Â·  " .. string.upper(p9.Location ~= "" and p9.Location or "HAJIME")
    }
    local TextLabel2 = Instance.new("TextLabel")

    for v39, v40 in t8 do
        TextLabel2[v39] = v40
    end

    TextLabel2.Parent = Frame3
    task.spawn(function() -- line: 180
        -- upvalues: ScreenGui (copy), TextLabel (copy)
        while ScreenGui.Parent do
            TextLabel.Text = math.floor(os.clock() * 2) % 2 == 0 and "â— LIVE" or "   LIVE"
            task.wait(0.25)
        end
    end)

    local t9 = {}

    for _, child in LocalPlayer.PlayerGui:GetChildren() do
        if child:IsA("ScreenGui") and child ~= ScreenGui and child.Enabled and child.Name ~= "TouchGui" then
            child.Enabled = false
            table.insert(t9, child)
        end
    end

    CurrentCamera.CameraType = Enum.CameraType.Scriptable

    local n1 = 0
    local v42 = false
    local v43 = false

    local function chest() -- line: 200
        -- upvalues: PivotPosition (copy), HumanoidRootPart (copy)
        return (if HumanoidRootPart.Parent then HumanoidRootPart.Position else PivotPosition + Vector3.new(0, 3, 0)) + Vector3.new(0, 0.9, 0)
    end

    RunService:BindToRenderStep("WeighInCamera", Enum.RenderPriority.Camera.Value + 1, function() -- line: 203
        -- upvalues: p9 (copy), Character (copy), CurrentCamera (ref), CameraType (ref), FieldOfView (ref), v23 (ref), Pivot (copy), v25 (copy), RightVector (copy), PivotPosition (copy), Screen (copy), v27 (ref), ScreenGui (copy), Frame (copy), Frame2 (copy), t9 (copy), n1 (ref), v42 (ref), v43 (ref), HumanoidRootPart (copy), WeightUnits (copy), RunService (copy), SoundService (copy), TweenService (copy), MangaTransition (copy), LocalPlayer (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), ClockTick (ref), v5 (ref), Sound (copy), v22 (ref)
        local v45 = os.clock() - v27
        local v46 = RunService:IsStudio() and LocalPlayer:GetAttribute("WeighDebugT")

        if type(v46) == "number" then
            v27 = os.clock() - v46
        else
            v46 = v45
        end

        if v46 < 2.6 then
            local v48 = math.rad(-50 + 100 * (v46 / 2.6))
            local v49 = PivotPosition + (v25 * math.cos(v48) + RightVector * math.sin(v48)).Unit * (9.8 - 0.9 * v46 / 2.6) + Vector3.new(0, 1.9, 0)

            CurrentCamera.FieldOfView = 55

            local lookAt = CFrame.lookAt
            local v50 = if HumanoidRootPart.Parent then HumanoidRootPart.Position else PivotPosition + Vector3.new(0, 3, 0)

            CurrentCamera.CFrame = lookAt(v49, v50 + Vector3.new(0, 0.9, 0))
        elseif v46 < 4.5 then
            local v51 = if Screen then Screen.CFrame else Pivot * CFrame.new(0, 5, -0.8)
            local v52 = (v46 - 2.6) / 1.9
            local v53 = v51.Position + v51.LookVector * (1.9 - 0.5 * v52) + v51.RightVector * 1.3 + v51.UpVector * 0.55

            CurrentCamera.FieldOfView = 46
            CurrentCamera.CFrame = CFrame.lookAt(v53, v51.Position)
        else
            local v56 = PivotPosition + v25 * (9.6 - math.min(1, (v46 - 4.5) / 2.0999999999999996) * 1.1) + RightVector * 1.6 + Vector3.new(0, 2.4, 0)

            CurrentCamera.FieldOfView = 58

            local lookAt = CFrame.lookAt
            local v57 = if HumanoidRootPart.Parent then HumanoidRootPart.Position else PivotPosition + Vector3.new(0, 3, 0)

            CurrentCamera.CFrame = lookAt(v56, v57 + Vector3.new(0, 0.9, 0) + Vector3.new(0, 0.3, 0))
        end

        if not (v46 >= 2.75 and v46 < 4) then
            if v46 >= 4 and not v42 then
                v42 = true
                SoundService:PlayLocalSound(Sound)
            end
        else
            local v59 = math.floor((v46 - 2.75) / 0.09)

            if n1 < v59 then
                n1 = v59
                SoundService:PlayLocalSound(ClockTick)
            end
        end

        if Character.Parent then
            for _, descendant in Character:GetDescendants() do
                if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" then
                    descendant.LocalTransparencyModifier = 0
                end
            end
        end

        if v46 >= 4.5 and not v43 then
            v43 = true
            task.spawn(function() -- line: 253
                -- upvalues: p9 (copy), CurrentCamera (ref), ScreenGui (copy), WeightUnits (copy), SoundService (copy), TweenService (copy), MangaTransition (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (ref)
                local t10 = {
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Size = UDim2.fromScale(1, 1)
                }
                local Frame = Instance.new("Frame")

                for v60, v61 in t10 do
                    Frame[v60] = v61
                end

                Frame.Parent = ScreenGui
                TweenService:Create(Frame, TweenInfo.new(0.3), {
                    BackgroundTransparency = 1
                }):Play()

                local SpeedLines = MangaTransition.SpeedLines
                local new = Color3.new

                pcall(SpeedLines, ScreenGui, 1.9, new(1, 1, 1))
                SoundService:PlayLocalSound(v5)

                local t11 = {
                    BackgroundTransparency = 1,
                    ZIndex = 7,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.73),
                    Size = UDim2.fromOffset(900, 260)
                }
                local Frame2 = Instance.new("Frame")

                for v62, v63 in t11 do
                    Frame2[v62] = v63
                end

                Frame2.Parent = ScreenGui

                local t12 = {
                    Scale = 1.7
                }
                local UIScale = Instance.new("UIScale")

                for v64, v65 in t12 do
                    UIScale[v64] = v65
                end

                UIScale.Parent = Frame2

                local t13 = {
                    BackgroundTransparency = 1,
                    TextSize = 140,
                    ZIndex = 8,
                    Size = UDim2.new(1, 0, 0, 150),
                    FontFace = v1,
                    TextColor3 = v4,
                    Text = WeightUnits.Upper(p9.Kg)
                }
                local TextLabel = Instance.new("TextLabel")

                for v66, v67 in t13 do
                    TextLabel[v66] = v67
                end

                TextLabel.Parent = Frame2

                local t14 = {
                    Thickness = 5,
                    Color = Color3.new(0, 0, 0)
                }
                local UIStroke = Instance.new("UIStroke")

                for v68, v69 in t14 do
                    UIStroke[v68] = v69
                end

                UIStroke.Parent = TextLabel

                local t15 = {
                    BorderSizePixel = 0,
                    Rotation = -2,
                    ZIndex = 8,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 150),
                    Size = UDim2.fromOffset(560, 64),
                    BackgroundColor3 = if p9.Amateur then Color3.fromRGB(58, 58, 64) else v3
                }
                local Frame3 = Instance.new("Frame")

                for v70, v71 in t15 do
                    Frame3[v70] = v71
                end

                Frame3.Parent = Frame2

                local t16 = {
                    Thickness = 3,
                    Color = Color3.new(0, 0, 0)
                }
                local UIStroke2 = Instance.new("UIStroke")

                for v72, v73 in t16 do
                    UIStroke2[v72] = v73
                end

                UIStroke2.Parent = Frame3

                local t17 = {
                    BackgroundTransparency = 1,
                    TextSize = 46,
                    ZIndex = 9,
                    Size = UDim2.fromScale(1, 1),
                    FontFace = v1,
                    TextColor3 = v4,
                    Text = string.upper(p9.Class)
                }
                local TextLabel2 = Instance.new("TextLabel")

                for v74, v75 in t17 do
                    TextLabel2[v74] = v75
                end

                TextLabel2.Parent = Frame3

                local t18 = {
                    Thickness = 2,
                    Color = Color3.new(0, 0, 0)
                }
                local UIStroke3 = Instance.new("UIStroke")

                for v76, v77 in t18 do
                    UIStroke3[v76] = v77
                end

                UIStroke3.Parent = TextLabel2

                local t19 = {
                    BackgroundTransparency = 1,
                    TextSize = 24,
                    ZIndex = 8,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 222),
                    Size = UDim2.fromOffset(800, 30),
                    FontFace = v2,
                    TextColor3 = v4,
                    Text = if p9.Amateur then "No weight class yet  Â·  Lightweight starts at " .. WeightUnits.Format(61, 0) else WeightUnits.Number(p9.Min, 0) .. " - " .. WeightUnits.Format(p9.Max, 0)
                }
                local TextLabel3 = Instance.new("TextLabel")

                for v78, v79 in t19 do
                    TextLabel3[v78] = v79
                end

                TextLabel3.Parent = Frame2

                local t20 = {
                    Thickness = 2,
                    Color = Color3.new(0, 0, 0)
                }
                local UIStroke4 = Instance.new("UIStroke")

                for v80, v81 in t20 do
                    UIStroke4[v80] = v81
                end

                UIStroke4.Parent = TextLabel3

                local v83 = math.clamp(CurrentCamera.ViewportSize.Y / 1080, 0.55, 1.4)

                TweenService:Create(UIScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Scale = v83
                }):Play()
                Frame3.Size = UDim2.fromOffset(0, 64)
                task.wait(0.18)
                TweenService:Create(Frame3, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.fromOffset(560, 64)
                }):Play()
            end)
        end

        if not (v46 >= 6.6) then
            return
        end

        RunService:UnbindFromRenderStep("WeighInCamera")
        task.spawn(function() -- line: 293
            -- upvalues: ScreenGui (copy), Frame (copy), Frame2 (copy), TweenService (copy)
            for _, descendant in ScreenGui:GetDescendants() do
                if descendant:IsA("TextLabel") then
                    TweenService:Create(descendant, TweenInfo.new(0.25), {
                        TextTransparency = 1,
                        TextStrokeTransparency = 1
                    }):Play()
                elseif descendant:IsA("UIStroke") then
                    TweenService:Create(descendant, TweenInfo.new(0.25), {
                        Transparency = 1
                    }):Play()
                end

                if descendant:IsA("Frame") and descendant ~= Frame and descendant ~= Frame2 and descendant.BackgroundTransparency < 1 then
                    TweenService:Create(descendant, TweenInfo.new(0.25), {
                        BackgroundTransparency = 1
                    }):Play()
                end
            end

            for _, v84 in { Frame, Frame2 } do
                TweenService:Create(v84, TweenInfo.new(0.3), {
                    Size = UDim2.fromScale(1, 0)
                }):Play()
            end

            task.wait(0.32)
            ScreenGui:Destroy()
        end)

        if HumanoidRootPart.Parent then
            local v85 = PivotPosition + v25 * 11 + Vector3.new(0, 5, 0)

            CurrentCamera.CFrame = CFrame.lookAt(v85, HumanoidRootPart.Position + Vector3.new(0, 1, 0))
        end

        local Custom = CameraType == Enum.CameraType.Scriptable and Enum.CameraType.Custom or CameraType

        CurrentCamera.CameraType = Custom
        CurrentCamera.FieldOfView = FieldOfView

        for _, v86 in t9 do
            if v86.Parent then
                v86.Enabled = true
            end
        end

        if v23 then
            v23.Enabled = true
        end

        v22 = false
    end)
end

WeighRemote.OnClientEvent:Connect(function(p10, p11) -- line: 331
    -- upvalues: weighIn (copy)
    if p10 == "WeighIn" and type(p11) == "table" then
        weighIn(p11)
    end
end)


// ============================================
// END OF: WeighScaleController (2).luau
// ============================================

// ============================================
// FILE: WeighScaleController.luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\WeighScaleController.luau
// SIZE: 21651 bytes
// ============================================
-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local WeightUnits = require(game:GetService("ReplicatedStorage"):WaitForChild("Boxing"):WaitForChild("WeightUnits"))
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Boxing = ReplicatedStorage:WaitForChild("Boxing")
local BlenderMesh = require(Boxing:WaitForChild("BlenderMesh"))
local WeighScaleMesh = require(Boxing:WaitForChild("WeighScaleMesh"))
local MangaTransition = require(Boxing:WaitForChild("MangaTransition"))
local WeighRemote = Boxing:WaitForChild("WeighRemote")
local LocalPlayer = Players.LocalPlayer
local v1 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Heavy, Enum.FontStyle.Italic)
local v2 = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
local v3 = Color3.fromRGB(200, 28, 34)
local v4 = Color3.fromRGB(244, 242, 236)

local function sound(p1, p2) -- line: 37
    local Sound = Instance.new("Sound")

    Sound.SoundId = p1
    Sound.Volume = p2 or 0.6

    return Sound
end

local sounds = workspace:FindFirstChild("sounds")
local ClockTick = if sounds then sounds:FindFirstChild("ClockTick") else nil

if not sounds or not ClockTick then
    ClockTick = Instance.new("Sound")
    ClockTick.SoundId = "rbxassetid://4556286113"
    ClockTick.Volume = 0.4
end

local v5 = if sounds then sounds:FindFirstChild("Heavy Blow") else nil

if not sounds or not v5 then
    v5 = Instance.new("Sound")
    v5.SoundId = "rbxassetid://5102882084"
    v5.Volume = 0.8
end

local Sound = Instance.new("Sound")

Sound.SoundId = "rbxassetid://9125531715"
Sound.Volume = 0.7
Sound.Parent = script

local function dress(p3) -- line: 51
    -- upvalues: BlenderMesh (copy), WeighScaleMesh (copy)
    local v6 = true

    for _, v7 in { "Steel", "Body" } do
        local v8 = p3:FindFirstChild(v7 .. "Mesh")

        if not (v8 and BlenderMesh.Apply(v8, WeighScaleMesh[v7])) then
            v6 = false
        end
    end

    if v6 then
        for _, v9 in { "Steel", "Body" } do
            p3[v9 .. "Mesh"].Transparency = 0
        end

        for _, v10 in { "Platform", "Column", "Head" } do
            local v11 = p3:FindFirstChild(v10)

            if v11 then
                v11.LocalTransparencyModifier = 1
                v11.Transparency = 1
            end
        end
    end
end

local t1 = {}

local function showReading(p4) -- line: 75
    -- upvalues: WeightUnits (copy), t1 (copy)
    local Screen = p4:FindFirstChild("Screen") and p4.Screen:FindFirstChild("Display") and p4.Screen.Display:FindFirstChild("Backlight")

    if not Screen then
        return
    end

    local Digits, Stable = Screen.Digits, Screen.Stable
    local ReadingKg = p4:GetAttribute("ReadingKg")
    local ReadingAt = p4:GetAttribute("ReadingAt")
    local t2 = {}

    t1[p4] = t2

    if not ReadingKg or not ReadingAt then
        Digits.Text = "0.0"
    else
        task.spawn(function() -- line: 88
            -- upvalues: p4 (copy), Digits (copy), Stable (copy), ReadingKg (copy), ReadingAt (copy), t2 (copy), WeightUnits (copy), t1 (copy)
            while true do
                if t1[p4] == t2 then
                    local v12 = workspace:GetServerTimeNow() - ReadingAt

                    if v12 < 2.75 then
                        Digits.Text = "0.0"
                        Stable.TextTransparency = 1
                        task.wait(0.05)
                        continue
                    end

                    if v12 < 4 then
                        local v13 = (v12 - 2.75) / 1.25
                        local v14 = ReadingKg * (1 - (1 - v13) ^ 3) + (1 - v13) * 3 * (math.random() - 0.5)

                        Digits.Text = WeightUnits.Number((math.max(0, v14)))
                        task.wait(0.05)
                        continue
                    end

                    if not (v12 < 9) then
                        break
                    end

                    Digits.Text = WeightUnits.Number(ReadingKg)

                    local v15 = v12 - 2.75 - 1.25
                    local v16 = if not (v15 < 0.6) then 0 elseif math.floor(v15 / 0.15) % 2 == 1 then 1 else 0

                    Stable.TextTransparency = v16
                    task.wait(0.05)
                    continue
                end

                return
            end

            Digits.Text = "0.0"
            Stable.TextTransparency = 1
        end)
    end
end

local function setUp(p5) -- line: 114
    -- upvalues: dress (copy), showReading (copy)
    if p5:GetAttribute("WeighSetUp") then
        return
    end

    p5:SetAttribute("WeighSetUp", true)
    task.spawn(dress, p5)
    p5:GetAttributeChangedSignal("ReadingAt"):Connect(function() -- line: 120
        -- upvalues: p5 (copy), showReading (copy)
        showReading(p5)
    end)
    showReading(p5)
end

for _, v18 in CollectionService:GetTagged("WeighScale") do
    setUp(v18)
end

CollectionService:GetInstanceAddedSignal("WeighScale"):Connect(setUp)

local function new(p6, p7, p8) -- line: 132
    local v19 = Instance.new(p6)

    for v20, v21 in p7 do
        v19[v20] = v21
    end

    v19.Parent = p8

    return v19
end

local v22 = false

local function weighIn(p9) -- line: 142
    -- upvalues: WeightUnits (copy), RunService (copy), SoundService (copy), TweenService (copy), MangaTransition (copy), LocalPlayer (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), ClockTick (ref), v5 (ref), Sound (copy), v22 (ref)
    local Scale = p9.Scale
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
    local CurrentCamera, CameraType, FieldOfView, v23, v24

    if v22 then
        v24 = true
    elseif Scale and Scale.Parent and HumanoidRootPart then
        v22 = true
        CurrentCamera = workspace.CurrentCamera
        CameraType = CurrentCamera.CameraType
        FieldOfView = CurrentCamera.FieldOfView
        v23 = Scale:FindFirstChild("WeighPrompt", true)

        if v23 then
            v23.Enabled = false
        end

        v24 = false
    else
        v24 = true
    end

    if v24 then
        return
    end

    local Pivot = Scale:GetPivot()
    local v25 = -Pivot.LookVector
    local RightVector, PivotPosition = Pivot.RightVector, Pivot.Position
    local Screen = Scale:FindFirstChild("Screen")
    local v27 = os.clock() - math.max(0, workspace:GetServerTimeNow() - p9.StartAt)
    local t3 = {
        Name = "WeighIn",
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        DisplayOrder = 86
    }
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local ScreenGui = Instance.new("ScreenGui")

    for v28, v29 in t3 do
        ScreenGui[v28] = v29
    end

    ScreenGui.Parent = PlayerGui

    local t4 = {
        BorderSizePixel = 0,
        ZIndex = 5,
        BackgroundColor3 = Color3.new(0, 0, 0),
        Size = UDim2.fromScale(1, 0)
    }
    local Frame = Instance.new("Frame")

    for v30, v31 in t4 do
        Frame[v30] = v31
    end

    Frame.Parent = ScreenGui

    local t5 = {
        BorderSizePixel = 0,
        ZIndex = 5,
        BackgroundColor3 = Color3.new(0, 0, 0),
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0, 1),
        Size = UDim2.fromScale(1, 0)
    }
    local Frame2 = Instance.new("Frame")

    for v32, v33 in t5 do
        Frame2[v32] = v33
    end

    Frame2.Parent = ScreenGui

    for _, v34 in { Frame, Frame2 } do
        TweenService:Create(v34, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromScale(1, 0.11)
        }):Play()
    end

    local t6 = {
        BackgroundTransparency = 1,
        ZIndex = 6,
        Position = UDim2.new(0, 36, 0.11, 14),
        Size = UDim2.fromOffset(620, 34)
    }
    local Frame3 = Instance.new("Frame")

    for v35, v36 in t6 do
        Frame3[v35] = v36
    end

    Frame3.Parent = ScreenGui

    local t7 = {
        BorderSizePixel = 0,
        TextSize = 20,
        Text = "â— LIVE",
        ZIndex = 6,
        BackgroundColor3 = v3,
        Size = UDim2.fromOffset(92, 34),
        FontFace = v1,
        TextColor3 = v4
    }
    local TextLabel = Instance.new("TextLabel")

    for v37, v38 in t7 do
        TextLabel[v37] = v38
    end

    TextLabel.Parent = Frame3

    local t8 = {
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        TextSize = 18,
        ZIndex = 6,
        BackgroundColor3 = Color3.fromRGB(14, 14, 16),
        Position = UDim2.fromOffset(92, 0),
        Size = UDim2.fromOffset(500, 34),
        FontFace = v2,
        TextColor3 = v4,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "   OFFICIAL WEIGH-IN  Â·  " .. string.upper(p9.Location ~= "" and p9.Location or "HAJIME")
    }
    local TextLabel2 = Instance.new("TextLabel")

    for v39, v40 in t8 do
        TextLabel2[v39] = v40
    end

    TextLabel2.Parent = Frame3
    task.spawn(function() -- line: 180
        -- upvalues: ScreenGui (copy), TextLabel (copy)
        while ScreenGui.Parent do
            TextLabel.Text = math.floor(os.clock() * 2) % 2 == 0 and "â— LIVE" or "   LIVE"
            task.wait(0.25)
        end
    end)

    local t9 = {}

    for _, child in LocalPlayer.PlayerGui:GetChildren() do
        if child:IsA("ScreenGui") and child ~= ScreenGui and child.Enabled and child.Name ~= "TouchGui" then
            child.Enabled = false
            table.insert(t9, child)
        end
    end

    CurrentCamera.CameraType = Enum.CameraType.Scriptable

    local n1 = 0
    local v42 = false
    local v43 = false

    local function chest() -- line: 200
        -- upvalues: PivotPosition (copy), HumanoidRootPart (copy)
        return (if HumanoidRootPart.Parent then HumanoidRootPart.Position else PivotPosition + Vector3.new(0, 3, 0)) + Vector3.new(0, 0.9, 0)
    end

    RunService:BindToRenderStep("WeighInCamera", Enum.RenderPriority.Camera.Value + 1, function() -- line: 203
        -- upvalues: p9 (copy), Character (copy), CurrentCamera (ref), CameraType (ref), FieldOfView (ref), v23 (ref), Pivot (copy), v25 (copy), RightVector (copy), PivotPosition (copy), Screen (copy), v27 (ref), ScreenGui (copy), Frame (copy), Frame2 (copy), t9 (copy), n1 (ref), v42 (ref), v43 (ref), HumanoidRootPart (copy), WeightUnits (copy), RunService (copy), SoundService (copy), TweenService (copy), MangaTransition (copy), LocalPlayer (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), ClockTick (ref), v5 (ref), Sound (copy), v22 (ref)
        local v45 = os.clock() - v27
        local v46 = RunService:IsStudio() and LocalPlayer:GetAttribute("WeighDebugT")

        if type(v46) == "number" then
            v27 = os.clock() - v46
        else
            v46 = v45
        end

        if v46 < 2.6 then
            local v48 = math.rad(-50 + 100 * (v46 / 2.6))
            local v49 = PivotPosition + (v25 * math.cos(v48) + RightVector * math.sin(v48)).Unit * (9.8 - 0.9 * v46 / 2.6) + Vector3.new(0, 1.9, 0)

            CurrentCamera.FieldOfView = 55

            local lookAt = CFrame.lookAt
            local v50 = if HumanoidRootPart.Parent then HumanoidRootPart.Position else PivotPosition + Vector3.new(0, 3, 0)

            CurrentCamera.CFrame = lookAt(v49, v50 + Vector3.new(0, 0.9, 0))
        elseif v46 < 4.5 then
            local v51 = if Screen then Screen.CFrame else Pivot * CFrame.new(0, 5, -0.8)
            local v52 = (v46 - 2.6) / 1.9
            local v53 = v51.Position + v51.LookVector * (1.9 - 0.5 * v52) + v51.RightVector * 1.3 + v51.UpVector * 0.55

            CurrentCamera.FieldOfView = 46
            CurrentCamera.CFrame = CFrame.lookAt(v53, v51.Position)
        else
            local v56 = PivotPosition + v25 * (9.6 - math.min(1, (v46 - 4.5) / 2.0999999999999996) * 1.1) + RightVector * 1.6 + Vector3.new(0, 2.4, 0)

            CurrentCamera.FieldOfView = 58

            local lookAt = CFrame.lookAt
            local v57 = if HumanoidRootPart.Parent then HumanoidRootPart.Position else PivotPosition + Vector3.new(0, 3, 0)

            CurrentCamera.CFrame = lookAt(v56, v57 + Vector3.new(0, 0.9, 0) + Vector3.new(0, 0.3, 0))
        end

        if not (v46 >= 2.75 and v46 < 4) then
            if v46 >= 4 and not v42 then
                v42 = true
                SoundService:PlayLocalSound(Sound)
            end
        else
            local v59 = math.floor((v46 - 2.75) / 0.09)

            if n1 < v59 then
                n1 = v59
                SoundService:PlayLocalSound(ClockTick)
            end
        end

        if Character.Parent then
            for _, descendant in Character:GetDescendants() do
                if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" then
                    descendant.LocalTransparencyModifier = 0
                end
            end
        end

        if v46 >= 4.5 and not v43 then
            v43 = true
            task.spawn(function() -- line: 253
                -- upvalues: p9 (copy), CurrentCamera (ref), ScreenGui (copy), WeightUnits (copy), SoundService (copy), TweenService (copy), MangaTransition (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (ref)
                local t10 = {
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Size = UDim2.fromScale(1, 1)
                }
                local Frame = Instance.new("Frame")

                for v60, v61 in t10 do
                    Frame[v60] = v61
                end

                Frame.Parent = ScreenGui
                TweenService:Create(Frame, TweenInfo.new(0.3), {
                    BackgroundTransparency = 1
                }):Play()

                local SpeedLines = MangaTransition.SpeedLines
                local new = Color3.new

                pcall(SpeedLines, ScreenGui, 1.9, new(1, 1, 1))
                SoundService:PlayLocalSound(v5)

                local t11 = {
                    BackgroundTransparency = 1,
                    ZIndex = 7,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.73),
                    Size = UDim2.fromOffset(900, 260)
                }
                local Frame2 = Instance.new("Frame")

                for v62, v63 in t11 do
                    Frame2[v62] = v63
                end

                Frame2.Parent = ScreenGui

                local t12 = {
                    Scale = 1.7
                }
                local UIScale = Instance.new("UIScale")

                for v64, v65 in t12 do
                    UIScale[v64] = v65
                end

                UIScale.Parent = Frame2

                local t13 = {
                    BackgroundTransparency = 1,
                    TextSize = 140,
                    ZIndex = 8,
                    Size = UDim2.new(1, 0, 0, 150),
                    FontFace = v1,
                    TextColor3 = v4,
                    Text = WeightUnits.Upper(p9.Kg)
                }
                local TextLabel = Instance.new("TextLabel")

                for v66, v67 in t13 do
                    TextLabel[v66] = v67
                end

                TextLabel.Parent = Frame2

                local t14 = {
                    Thickness = 5,
                    Color = Color3.new(0, 0, 0)
                }
                local UIStroke = Instance.new("UIStroke")

                for v68, v69 in t14 do
                    UIStroke[v68] = v69
                end

                UIStroke.Parent = TextLabel

                local t15 = {
                    BorderSizePixel = 0,
                    Rotation = -2,
                    ZIndex = 8,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 150),
                    Size = UDim2.fromOffset(560, 64),
                    BackgroundColor3 = if p9.Amateur then Color3.fromRGB(58, 58, 64) else v3
                }
                local Frame3 = Instance.new("Frame")

                for v70, v71 in t15 do
                    Frame3[v70] = v71
                end

                Frame3.Parent = Frame2

                local t16 = {
                    Thickness = 3,
                    Color = Color3.new(0, 0, 0)
                }
                local UIStroke2 = Instance.new("UIStroke")

                for v72, v73 in t16 do
                    UIStroke2[v72] = v73
                end

                UIStroke2.Parent = Frame3

                local t17 = {
                    BackgroundTransparency = 1,
                    TextSize = 46,
                    ZIndex = 9,
                    Size = UDim2.fromScale(1, 1),
                    FontFace = v1,
                    TextColor3 = v4,
                    Text = string.upper(p9.Class)
                }
                local TextLabel2 = Instance.new("TextLabel")

                for v74, v75 in t17 do
                    TextLabel2[v74] = v75
                end

                TextLabel2.Parent = Frame3

                local t18 = {
                    Thickness = 2,
                    Color = Color3.new(0, 0, 0)
                }
                local UIStroke3 = Instance.new("UIStroke")

                for v76, v77 in t18 do
                    UIStroke3[v76] = v77
                end

                UIStroke3.Parent = TextLabel2

                local t19 = {
                    BackgroundTransparency = 1,
                    TextSize = 24,
                    ZIndex = 8,
                    AnchorPoint = Vector2.new(0.5, 0),
                    Position = UDim2.new(0.5, 0, 0, 222),
                    Size = UDim2.fromOffset(800, 30),
                    FontFace = v2,
                    TextColor3 = v4,
                    Text = if p9.Amateur then "No weight class yet  Â·  Lightweight starts at " .. WeightUnits.Format(61, 0) else WeightUnits.Number(p9.Min, 0) .. " - " .. WeightUnits.Format(p9.Max, 0)
                }
                local TextLabel3 = Instance.new("TextLabel")

                for v78, v79 in t19 do
                    TextLabel3[v78] = v79
                end

                TextLabel3.Parent = Frame2

                local t20 = {
                    Thickness = 2,
                    Color = Color3.new(0, 0, 0)
                }
                local UIStroke4 = Instance.new("UIStroke")

                for v80, v81 in t20 do
                    UIStroke4[v80] = v81
                end

                UIStroke4.Parent = TextLabel3

                local v83 = math.clamp(CurrentCamera.ViewportSize.Y / 1080, 0.55, 1.4)

                TweenService:Create(UIScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Scale = v83
                }):Play()
                Frame3.Size = UDim2.fromOffset(0, 64)
                task.wait(0.18)
                TweenService:Create(Frame3, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.fromOffset(560, 64)
                }):Play()
            end)
        end

        if not (v46 >= 6.6) then
            return
        end

        RunService:UnbindFromRenderStep("WeighInCamera")
        task.spawn(function() -- line: 293
            -- upvalues: ScreenGui (copy), Frame (copy), Frame2 (copy), TweenService (copy)
            for _, descendant in ScreenGui:GetDescendants() do
                if descendant:IsA("TextLabel") then
                    TweenService:Create(descendant, TweenInfo.new(0.25), {
                        TextTransparency = 1,
                        TextStrokeTransparency = 1
                    }):Play()
                elseif descendant:IsA("UIStroke") then
                    TweenService:Create(descendant, TweenInfo.new(0.25), {
                        Transparency = 1
                    }):Play()
                end

                if descendant:IsA("Frame") and descendant ~= Frame and descendant ~= Frame2 and descendant.BackgroundTransparency < 1 then
                    TweenService:Create(descendant, TweenInfo.new(0.25), {
                        BackgroundTransparency = 1
                    }):Play()
                end
            end

            for _, v84 in { Frame, Frame2 } do
                TweenService:Create(v84, TweenInfo.new(0.3), {
                    Size = UDim2.fromScale(1, 0)
                }):Play()
            end

            task.wait(0.32)
            ScreenGui:Destroy()
        end)

        if HumanoidRootPart.Parent then
            local v85 = PivotPosition + v25 * 11 + Vector3.new(0, 5, 0)

            CurrentCamera.CFrame = CFrame.lookAt(v85, HumanoidRootPart.Position + Vector3.new(0, 1, 0))
        end

        local Custom = CameraType == Enum.CameraType.Scriptable and Enum.CameraType.Custom or CameraType

        CurrentCamera.CameraType = Custom
        CurrentCamera.FieldOfView = FieldOfView

        for _, v86 in t9 do
            if v86.Parent then
                v86.Enabled = true
            end
        end

        if v23 then
            v23.Enabled = true
        end

        v22 = false
    end)
end

WeighRemote.OnClientEvent:Connect(function(p10, p11) -- line: 331
    -- upvalues: weighIn (copy)
    if p10 == "WeighIn" and type(p11) == "table" then
        weighIn(p11)
    end
end)


// ============================================
// END OF: WeighScaleController.luau
// ============================================

// ============================================
// FILE: WeighScaleMesh (1).luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\WeighScaleMesh (1).luau
// SIZE: 17800 bytes
// ============================================
-- https://lua.expert

return {
    Steel = {
        Vertices = 176,
        Triangles = 328,
        Size = Vector3.new(3.2, 4.27, 2.6),
        Centre = Vector3.new(0, 2.215, 0),
        Data = "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VABVAFMAVgBXAFMAWABZAFoAWwBcAFoAXQBeAFoAXwAoADoANgAqADkAOgAvAC4AKwAxAC0ALgA9ADUAMgA/ADQANQA7AEMAQAA8AEIAQwBSADgAVgA4AFUAVgA9AFsAQQBbAEAAQQBXAF8AXABfAFUAXgBSAEgARABUAEcASABLAF0AWQBNAFwAXQBJAFEATgBKAFAAUQAoAEYALABGACsALABLADMATwAzAE4ATwBSACgANgA0ADkALQBOACsASQA9AEsAWQBAAFUAOwBcAEcAVwAoACwAKQArAC4AKQAtACoAKQAvADMAMAAyADUAMAA0ADEAMAA2ADoANwA5ADwANwA7ADgANwA9AEEAPgBAAEMAPgBCAD8APgBEAEgARQBHAEoARQBJAEYARQBLAE8ATABOAFEATABQAE0ATABSAFYAUwBVAFgAUwBXAFQAUwBZAF0AWgBcAF8AWgBeAFsAWgAoACoAOgAqAC0AOQAvADEALgAxADQALQA9AD8ANQA/AEIANAA7ADwAQwA8ADkAQgBSADYAOAA4ADsAVQA9AFkAWwBbAF4AQABXAFgAXwBfAFgAVQBSAFQASABUAFcARwBLAE0AXQBNAFAAXABJAEoAUQBKAEcAUAAoAEQARgBGAEkAKwBLADIAMwAzAC8ATgBSAEQAKAA0AEIAOQBOAC8AKwA9ADIASwBAAF4AVQBcAFAARwBgAGEAYgBjAGQAYQBlAGYAZABnAGgAZgBpAGoAaABrAGwAagBtAG4AbABvAHAAbgBtAGkAZQBxAHIAcABzAGIAcgBmAGoAbgBgAGMAYQBjAGUAZABlAGcAZgBnAGkAaABpAGsAagBrAG0AbABtAG8AbgBvAHEAcABlAGMAYABgAHMAcQBxAG8AbQBtAGsAaQBpAGcAZQBlAGAAcQBxAG0AZQBxAHMAcgBzAGAAYgByAGIAYQBhAGQAZgBmAGgAagBqAGwAbgBuAHAAZgBwAHIAZgByAGEAZgB0AHUAdgB3AHgAdQB5AHoAeAB7AHwAegB9AH4AfAB/AIAAfgCBAIIAgACDAIQAggCBAH0AeQCFAIYAhACHAHYAhgB6AH4AggB0AHcAdQB3AHkAeAB5AHsAegB7AH0AfAB9AH8AfgB/AIEAgACBAIMAggCDAIUAhAB5AHcAdAB0AIcAhQCFAIMAgQCBAH8AfQB9AHsAeQB5AHQAhQCFAIEAeQCFAIcAhgCHAHQAdgCGAHYAdQB1AHgAegB6AHwAfgB+AIAAggCCAIQAegCEAIYAegCGAHUAegCIAIkAigCLAIwAiQCNAI4AjACPAJAAjgCRAJIAkACTAJQAkgCVAJYAlACXAJgAlgCVAJEAjQCZAJoAmACbAIoAmgCOAJIAlgCIAIsAiQCLAI0AjACNAI8AjgCPAJEAkACRAJMAkgCTAJUAlACVAJcAlgCXAJkAmACNAIsAiACIAJsAmQCZAJcAlQCVAJMAkQCRAI8AjQCNAIgAmQCZAJUAjQCZAJsAmgCbAIgAigCaAIoAiQCJAIwAjgCOAJAAkgCSAJQAlgCWAJgAjgCYAJoAjgCaAIkAjgCcAJ0AngCfAKAAnQChAKIAoACjAKQAogClAKYApACnAKgApgCpAKoAqACrAKwAqgCpAKUAoQCtAK4ArACvAJ4ArgCiAKYAqgCcAJ8AnQCfAKEAoAChAKMAogCjAKUApAClAKcApgCnAKkAqACpAKsAqgCrAK0ArAChAJ8AnACcAK8ArQCtAKsAqQCpAKcApQClAKMAoQChAJwArQCtAKkAoQCtAK8ArgCvAJwAngCuAJ4AnQCdAKAAogCiAKQApgCmAKgAqgCqAKwAogCsAK4AogCuAJ0AogABAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB",
        Palette = { { 0.62, 0.63, 0.64 } }
    },
    Body = {
        Vertices = 456,
        Triangles = 848,
        Size = Vector3.new(2.98, 5.161301, 2.52),
        Centre = Vector3.new(0, 2.580651, -0.07),
        Data = "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TorI1AwDTopF1gAA4oxF1gwDToqx3wwD4ow03gwDToo03gAAAAAAAAAAAAABAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQECAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQYGBgYGBgYGAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAAABAAIAAwAEAAEABQAGAAQABwACAAYABAACAAEAAwAHAAUAAAADAAEAAwAFAAQABQAHAAYABwAAAAIABAAGAAIAAwAAAAcACAAJAAoACwAMAA0ADgAPABAAEQASABMAFAAVABYAFwAYABkAGgAbABwAHQAeAB8ACAAPAA4ACwAKAAkAEQANAAwAEAATABIADgAbABoAHQASABEAHAAfAB4AGgAVABQAFwAeAB0AFgAZABgAFAAJAAgADAAYABcAGgAIAA4ADQAPAAoAGAAJABYAEQAXAB0AEgAbABAAHgAVABwACAAKAA8ACwANAAoAEQATAA0AEAAPABMADgAQABsAHQAfABIAHAAbAB8AGgAcABUAFwAZAB4AFgAVABkAFAAWAAkADAALABgAGgAUAAgADQATAA8AGAALAAkAEQAMABcAEgAfABsAHgAZABUAIAAhACIAIwAkACUAJgAnACgAKQAqACsALAAtAC4ALwAwADEAMgAzADQANQA2ADcAIAAnACYAIwAiACEAKQAlACQAKAArACoAJgAzADIANQAqACkANAA3ADYAMgAtACwALwA2ADUALgAxADAALAAhACAAJAAwAC8AMgAgACYAJQAnACIAMAAhAC4AKQAvADUAKgAzACgANgAtADQAIAAiACcAIwAlACIAKQArACUAKAAnACsAJgAoADMANQA3ACoANAAzADcAMgA0AC0ALwAxADYALgAtADEALAAuACEAJAAjADAAMgAsACAAJQArACcAMAAjACEAKQAkAC8AKgA3ADMANgAxAC0AOAA5ADoAOwA8AD0APgA/AEAAQQBCAEMARABFAEYARwBIAEkASgBLAEwATQBOAE8AOAA/AD4AOwA6ADkAQQA9ADwAQABDAEIAPgBLAEoATQBCAEEATABPAE4ASgBFAEQARwBOAE0ARgBJAEgARAA5ADgAPABIAEcASgA4AD4APQA/ADoASAA5AEYAQQBHAE0AQgBLAEAATgBFAEwAOAA6AD8AOwA9ADoAQQBDAD0AQAA/AEMAPgBAAEsATQBPAEIATABLAE8ASgBMAEUARwBJAE4ARgBFAEkARABGADkAPAA7AEgASgBEADgAPQBDAD8ASAA7ADkAQQA8AEcAQgBPAEsATgBJAEUAUABRAFIAUwBUAFEAVQBWAFQAVwBYAFYAWQBaAFgAWwBcAFoAXQBeAFwAXwBgAF4AYQBiAGAAYwBkAGIAZQBmAGQAZwBoAGYAaQBqAGgAawBsAGoAZQBdAFUAbQBuAGwAbwBSAG4AXgBmAG4AUABTAFEAUwBVAFQAVQBXAFYAVwBZAFgAWQBbAFoAWwBdAFwAXQBfAF4AXwBhAGAAYQBjAGIAYwBlAGQAZQBnAGYAZwBpAGgAaQBrAGoAawBtAGwAVQBTAFAAUABvAFUAbwBtAFUAbQBrAGUAawBpAGUAaQBnAGUAZQBjAF0AYwBhAF0AYQBfAF0AXQBbAFkAWQBXAF0AVwBVAF0AVQBtAGUAbQBvAG4AbwBQAFIAbgBSAFEAUQBUAFYAVgBYAFoAWgBcAF4AXgBgAGIAYgBkAGYAZgBoAGoAagBsAG4AbgBRAFYAVgBaAF4AXgBiAGYAZgBqAG4AbgBWAF4AcABxAHIAcwB0AHEAdQB2AHQAdwB4AHYAeQB6AHgAewB8AHoAfQB+AHwAfwCAAH4AgQCCAIAAgwCEAIIAhQCGAIQAhwCIAIYAiQCKAIgAiwCMAIoAhQB9AHUAjQCOAIwAjwByAI4AfgCGAI4AcABzAHEAcwB1AHQAdQB3AHYAdwB5AHgAeQB7AHoAewB9AHwAfQB/AH4AfwCBAIAAgQCDAIIAgwCFAIQAhQCHAIYAhwCJAIgAiQCLAIoAiwCNAIwAdQBzAHAAcACPAHUAjwCNAHUAjQCLAIUAiwCJAIUAiQCHAIUAhQCDAH0AgwCBAH0AgQB/AH0AfQB7AHkAeQB3AH0AdwB1AH0AdQCNAIUAjQCPAI4AjwBwAHIAjgByAHEAcQB0AHYAdgB4AHoAegB8AH4AfgCAAIIAggCEAIYAhgCIAIoAigCMAI4AjgBxAHYAdgB6AH4AfgCCAIYAhgCKAI4AjgB2AH4AkACRAJIAkwCUAJEAlQCWAJQAlwCYAJYAmQCaAJgAmwCcAJoAnQCeAJwAnwCgAJ4AoQCiAKAAowCkAKIApQCmAKQApwCoAKYAqQCqAKgAqwCsAKoApQCdAJUArQCuAKwArwCSAK4AngCmAK4AkACTAJEAkwCVAJQAlQCXAJYAlwCZAJgAmQCbAJoAmwCdAJwAnQCfAJ4AnwChAKAAoQCjAKIAowClAKQApQCnAKYApwCpAKgAqQCrAKoAqwCtAKwAlQCTAJAAkACvAJUArwCtAJUArQCrAKUAqwCpAKUAqQCnAKUApQCjAJ0AowChAJ0AoQCfAJ0AnQCbAJkAmQCXAJ0AlwCVAJ0AlQCtAKUArQCvAK4ArwCQAJIArgCSAJEAkQCUAJYAlgCYAJoAmgCcAJ4AngCgAKIAogCkAKYApgCoAKoAqgCsAK4ArgCRAJYAlgCaAJ4AngCiAKYApgCqAK4ArgCWAJ4AsACxALIAswC0ALEAtQC2ALQAtwC4ALYAuQC6ALgAuwC8ALoAvQC+ALwAvwDAAL4AwQDCAMAAwwDEAMIAxQDGAMQAxwDIAMYAyQDKAMgAywDMAMoAxQC9ALUAzQDOAMwAzwCyAM4AvgDGAM4AsACzALEAswC1ALQAtQC3ALYAtwC5ALgAuQC7ALoAuwC9ALwAvQC/AL4AvwDBAMAAwQDDAMIAwwDFAMQAxQDHAMYAxwDJAMgAyQDLAMoAywDNAMwAtQCzALAAsADPALUAzwDNALUAzQDLAMUAywDJAMUAyQDHAMUAxQDDAL0AwwDBAL0AwQC/AL0AvQC7ALkAuQC3AL0AtwC1AL0AtQDNAMUAzQDPAM4AzwCwALIAzgCyALEAsQC0ALYAtgC4ALoAugC8AL4AvgDAAMIAwgDEAMYAxgDIAMoAygDMAM4AzgCxALYAtgC6AL4AvgDCAMYAxgDKAM4AzgC2AL4A0ADRANIA0ADTANQA1QDWANcA2ADTANUA2QDYANoA0QDbANkA1ADTANsA3ADdAN4A3wDgANwA4QDfAOIA4wDkAOEA5QDjAOYA3QDnAOUA4ADkAOcA6ADpAOoA6wDsAOgA7QDrAO4A7wDwAO0A8QDvAPIA8QDsAPMA7ADwAPMA9AD1APYA9AD3APgA+QD6APsA/AD3APkA/QD8AP4A9QD/AP0A+AD3AP8AAAEBAQIBAwEEAQABBQEDAQYBBwEIAQUBCQEHAQoBCQEEAQsBBAEIAQsBDAENAQ4BDAEPARABEQESARMBFAEPAREBFQEUARYBDQEXARUBEAEPARcBGAEZARoBGAEbARwBHQEeAR8BIAEbAR0BIQEgASIBGQEjASEBHAEbASMBJAElASYBJwEoASQBKQEnASoBKwEsASkBLQErAS4BLQEoAS8BKAEsAS8B0gDoAOoA0QDrAOgA2QDuAOsA3gDVANcA3QDYANUA5QDaANgA9gDhAOIA9QDjAOEA/QDmAOMA8gD5APsA7wD8APkA7QD+APwAGgHpABgB6QAeARgB8QAfAR4B9gAlAfQAJQH6APQALQH7APoAIgEpASoBIAErASkBHQEuASsBGgEAAQIBGQEDAQABIQEGAQMBDgEkASYBDQEnASQBFQEqAScBCgERARMBBwEUAREBBQEWARQB0gABAdAAAQHWANAACQHXANYADgHfAAwB3wASAQwB3AATARIBGgHSAOoA5gDuANoAEwHXAAoB9gAOASYB+wAfAfIAKgEGASIB0ADUANEA0ADWANMA1QDTANYA2ADbANMA2QDbANgA0QDUANsA3ADgAN0A3wDkAOAA4QDkAN8A4wDnAOQA5QDnAOMA3QDgAOcA6ADsAOkA6wDwAOwA7QDwAOsA7wDzAPAA8QDzAO8A8QDpAOwA9AD4APUA9AD6APcA+QD3APoA/AD/APcA/QD/APwA9QD4AP8AAAEEAQEBAwEIAQQBBQEIAQMBBwELAQgBCQELAQcBCQEBAQQBDAEQAQ0BDAESAQ8BEQEPARIBFAEXAQ8BFQEXARQBDQEQARcBGAEcARkBGAEeARsBHQEbAR4BIAEjARsBIQEjASABGQEcASMBJAEoASUBJwEsASgBKQEsAScBKwEvASwBLQEvASsBLQElASgB0gDRAOgA0QDZAOsA2QDaAO4A3gDdANUA3QDlANgA5QDmANoA9gD1AOEA9QD9AOMA/QD+AOYA8gDvAPkA7wDtAPwA7QDuAP4AGgHqAOkA6QDxAB4B8QDyAB8B9gAmASUBJQEtAfoALQEuAfsAIgEgASkBIAEdASsBHQEfAS4BGgEZAQABGQEhAQMBIQEiAQYBDgENASQBDQEVAScBFQEWASoBCgEHAREBBwEFARQBBQEGARYB0gACAQEBAQEJAdYACQEKAdcADgHiAN8A3wDcABIB3ADeABMBGgECAdIA5gD+AO4AEwHeANcA9gDiAA4B+wAuAR8BKgEWAQYBMAExATIBMwE0ATUBNgE3ATgBOQE6ATsBPAE9AT4BPwFAAUEBQgFDAUQBRQFGAUcBMAE3ATYBMQE1ATIBOQE1ATQBOgE3ATsBNgFDAUIBRQE6ATkBRgFDAUcBQgE9ATwBPwFGAUUBQAE9AUEBPAExATABNAFAAT8BQgEwATYBNQE3ATIBQAExAT4BOQE/AUUBOgFDATgBRgE9AUQBMAEyATcBMQEzATUBOQE7ATUBOgE4ATcBNgE4AUMBRQFHAToBRgFEAUMBQgFEAT0BPwFBAUYBQAE+AT0BPAE+ATEBNAEzAUABQgE8ATABNQE7ATcBQAEzATEBOQE0AT8BOgFHAUMBRgFBAT0BSAFJAUoBSwFMAU0BTgFPAVABUQFSAVMBVAFVAVYBVwFYAVkBWgFbAVwBXQFeAV8BSAFPAU4BSQFNAUoBUQFNAUwBUgFPAVMBTgFbAVoBXQFSAVEBXgFbAV8BWgFVAVQBVwFeAV0BWAFVAVkBVAFJAUgBTAFYAVcBWgFIAU4BTQFPAUoBWAFJAVYBUQFXAV0BUgFbAVABXgFVAVwBSAFKAU8BSQFLAU0BUQFTAU0BUgFQAU8BTgFQAVsBXQFfAVIBXgFcAVsBWgFcAVUBVwFZAV4BWAFWAVUBVAFWAUkBTAFLAVgBWgFUAUgBTQFTAU8BWAFLAUkBUQFMAVcBUgFfAVsBXgFZAVUBYAFhAWIBYwFkAWUBZgFnAWgBaQFqAWsBbAFtAW4BbwFwAXEBcgFzAXQBdQF2AXcBYAFnAWYBYQFlAWIBaQFlAWQBagFnAWsBZgFzAXIBdQFqAWkBdgFzAXcBcgFtAWwBbwF2AXUBcAFtAXEBbAFhAWABZAFwAW8BcgFgAWYBZQFnAWIBcAFhAW4BaQFvAXUBagFzAWgBdgFtAXQBYAFiAWcBYQFjAWUBaQFrAWUBagFoAWcBZgFoAXMBdQF3AWoBdgF0AXMBcgF0AW0BbwFxAXYBcAFuAW0BbAFuAWEBZAFjAXABcgFsAWABZQFrAWcBcAFjAWEBaQFkAW8BagF3AXMBdgFxAW0BeAF5AXoBewF8AX0BfgF/AYABgQGCAYMBhAGFAYYBhwGIAYkBigGLAYwBjQGOAY8BeAF/AX4BeQF9AXoBgQF9AXwBggF/AYMBfgGLAYoBjQGCAYEBjgGLAY8BigGFAYQBhwGOAY0BiAGFAYkBhAF5AXgBfAGIAYcBigF4AX4BfQF/AXoBiAF5AYYBgQGHAY0BggGLAYABjgGFAYwBeAF6AX8BeQF7AX0BgQGDAX0BggGAAX8BfgGAAYsBjQGPAYIBjgGMAYsBigGMAYUBhwGJAY4BiAGGAYUBhAGGAXkBfAF7AYgBigGEAXgBfQGDAX8BiAF7AXkBgQF8AYcBggGPAYsBjgGJAYUBkAGRAZIBkwGUAZUBlgGXAZgBmQGaAZsBnAGdAZ4BnwGgAaEBogGjAaQBpQGmAacBkAGXAZYBkQGVAZIBmQGVAZQBmgGXAZsBlgGjAaIBpQGaAZkBpgGjAacBogGdAZwBnwGmAaUBoAGdAaEBnAGRAZABlAGgAZ8BogGQAZYBlQGXAZIBoAGRAZ4BmQGfAaUBmgGjAZgBpgGdAaQBkAGSAZcBkQGTAZUBmQGbAZUBmgGYAZcBlgGYAaMBpQGnAZoBpgGkAaMBogGkAZ0BnwGhAaYBoAGeAZ0BnAGeAZEBlAGTAaABogGcAZABlQGbAZcBoAGTAZEBmQGUAZ8BmgGnAaMBpgGhAZ0BqAGpAaoBqwGsAakBrQGuAawBrwGqAa4BrAGqAakBqwGvAa0BqAGrAakBqwGtAawBrQGvAa4BrwGoAaoBrAGuAaoBqwGoAa8BsAGxAbIBswG0AbUBtgG3AbgBuQG6AbsBvAG9Ab4BvwHAAcEBwgHDAcQBxQHGAccBsAG3AbYBswGyAbEBuQG1AbQBuAG7AboBtgHDAcIBxQG6AbkBxAHHAcYBwgG9AbwBvwHGAcUBvgHBAcABvAGxAbABtAHAAb8BwgGwAbYBtQG3AbIBwAGxAb4BuQG/AcUBugHDAbgBxgG9AcQBsAGyAbcBswG1AbIBuQG7AbUBuAG3AbsBtgG4AcMBxQHHAboBxAHDAccBwgHEAb0BvwHBAcYBvgG9AcEBvAG+AbEBtAGzAcABwgG8AbABtQG7AbcBwAGzAbEBuQG0Ab8BugHHAcMBxgHBAb0BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
        Palette = {
            { 0.05, 0.055, 0.06 },
            { 0.035, 0.036, 0.04 },
            { 0.012, 0.012, 0.012 },
            { 0.16, 0.17, 0.18 },
            { 0.3, 0.31, 0.33 },
            { 0.05, 0.4, 0.1 },
            { 0.1, 0.32, 0.08 }
        }
    },
    Lcd = {
        Centre = Vector3.new(0, 4.980337, -0.807593),
        Normal = Vector3.new(0, 0.374607, 0.927184),
        Up = Vector3.new(0, 0.927184, -0.374607),
        Size = Vector2.new(0.84, 0.24)
    }
}


// ============================================
// END OF: WeighScaleMesh (1).luau
// ============================================

// ============================================
// FILE: WeighScaleMesh.luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\WeighScaleMesh.luau
// SIZE: 17800 bytes
// ============================================
-- https://lua.expert

return {
    Steel = {
        Vertices = 176,
        Triangles = 328,
        Size = Vector3.new(3.2, 4.27, 2.6),
        Centre = Vector3.new(0, 2.215, 0),
        Data = "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VABVAFMAVgBXAFMAWABZAFoAWwBcAFoAXQBeAFoAXwAoADoANgAqADkAOgAvAC4AKwAxAC0ALgA9ADUAMgA/ADQANQA7AEMAQAA8AEIAQwBSADgAVgA4AFUAVgA9AFsAQQBbAEAAQQBXAF8AXABfAFUAXgBSAEgARABUAEcASABLAF0AWQBNAFwAXQBJAFEATgBKAFAAUQAoAEYALABGACsALABLADMATwAzAE4ATwBSACgANgA0ADkALQBOACsASQA9AEsAWQBAAFUAOwBcAEcAVwAoACwAKQArAC4AKQAtACoAKQAvADMAMAAyADUAMAA0ADEAMAA2ADoANwA5ADwANwA7ADgANwA9AEEAPgBAAEMAPgBCAD8APgBEAEgARQBHAEoARQBJAEYARQBLAE8ATABOAFEATABQAE0ATABSAFYAUwBVAFgAUwBXAFQAUwBZAF0AWgBcAF8AWgBeAFsAWgAoACoAOgAqAC0AOQAvADEALgAxADQALQA9AD8ANQA/AEIANAA7ADwAQwA8ADkAQgBSADYAOAA4ADsAVQA9AFkAWwBbAF4AQABXAFgAXwBfAFgAVQBSAFQASABUAFcARwBLAE0AXQBNAFAAXABJAEoAUQBKAEcAUAAoAEQARgBGAEkAKwBLADIAMwAzAC8ATgBSAEQAKAA0AEIAOQBOAC8AKwA9ADIASwBAAF4AVQBcAFAARwBgAGEAYgBjAGQAYQBlAGYAZABnAGgAZgBpAGoAaABrAGwAagBtAG4AbABvAHAAbgBtAGkAZQBxAHIAcABzAGIAcgBmAGoAbgBgAGMAYQBjAGUAZABlAGcAZgBnAGkAaABpAGsAagBrAG0AbABtAG8AbgBvAHEAcABlAGMAYABgAHMAcQBxAG8AbQBtAGsAaQBpAGcAZQBlAGAAcQBxAG0AZQBxAHMAcgBzAGAAYgByAGIAYQBhAGQAZgBmAGgAagBqAGwAbgBuAHAAZgBwAHIAZgByAGEAZgB0AHUAdgB3AHgAdQB5AHoAeAB7AHwAegB9AH4AfAB/AIAAfgCBAIIAgACDAIQAggCBAH0AeQCFAIYAhACHAHYAhgB6AH4AggB0AHcAdQB3AHkAeAB5AHsAegB7AH0AfAB9AH8AfgB/AIEAgACBAIMAggCDAIUAhAB5AHcAdAB0AIcAhQCFAIMAgQCBAH8AfQB9AHsAeQB5AHQAhQCFAIEAeQCFAIcAhgCHAHQAdgCGAHYAdQB1AHgAegB6AHwAfgB+AIAAggCCAIQAegCEAIYAegCGAHUAegCIAIkAigCLAIwAiQCNAI4AjACPAJAAjgCRAJIAkACTAJQAkgCVAJYAlACXAJgAlgCVAJEAjQCZAJoAmACbAIoAmgCOAJIAlgCIAIsAiQCLAI0AjACNAI8AjgCPAJEAkACRAJMAkgCTAJUAlACVAJcAlgCXAJkAmACNAIsAiACIAJsAmQCZAJcAlQCVAJMAkQCRAI8AjQCNAIgAmQCZAJUAjQCZAJsAmgCbAIgAigCaAIoAiQCJAIwAjgCOAJAAkgCSAJQAlgCWAJgAjgCYAJoAjgCaAIkAjgCcAJ0AngCfAKAAnQChAKIAoACjAKQAogClAKYApACnAKgApgCpAKoAqACrAKwAqgCpAKUAoQCtAK4ArACvAJ4ArgCiAKYAqgCcAJ8AnQCfAKEAoAChAKMAogCjAKUApAClAKcApgCnAKkAqACpAKsAqgCrAK0ArAChAJ8AnACcAK8ArQCtAKsAqQCpAKcApQClAKMAoQChAJwArQCtAKkAoQCtAK8ArgCvAJwAngCuAJ4AnQCdAKAAogCiAKQApgCmAKgAqgCqAKwAogCsAK4AogCuAJ0AogABAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEB",
        Palette = { { 0.62, 0.63, 0.64 } }
    },
    Body = {
        Vertices = 456,
        Triangles = 848,
        Size = Vector3.new(2.98, 5.161301, 2.52),
        Centre = Vector3.new(0, 2.580651, -0.07),
        Data = "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TorI1AwDTopF1gAA4oxF1gwDToqx3wwD4ow03gwDToo03gAAAAAAAAAAAAABAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQECAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQYGBgYGBgYGAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAAABAAIAAwAEAAEABQAGAAQABwACAAYABAACAAEAAwAHAAUAAAADAAEAAwAFAAQABQAHAAYABwAAAAIABAAGAAIAAwAAAAcACAAJAAoACwAMAA0ADgAPABAAEQASABMAFAAVABYAFwAYABkAGgAbABwAHQAeAB8ACAAPAA4ACwAKAAkAEQANAAwAEAATABIADgAbABoAHQASABEAHAAfAB4AGgAVABQAFwAeAB0AFgAZABgAFAAJAAgADAAYABcAGgAIAA4ADQAPAAoAGAAJABYAEQAXAB0AEgAbABAAHgAVABwACAAKAA8ACwANAAoAEQATAA0AEAAPABMADgAQABsAHQAfABIAHAAbAB8AGgAcABUAFwAZAB4AFgAVABkAFAAWAAkADAALABgAGgAUAAgADQATAA8AGAALAAkAEQAMABcAEgAfABsAHgAZABUAIAAhACIAIwAkACUAJgAnACgAKQAqACsALAAtAC4ALwAwADEAMgAzADQANQA2ADcAIAAnACYAIwAiACEAKQAlACQAKAArACoAJgAzADIANQAqACkANAA3ADYAMgAtACwALwA2ADUALgAxADAALAAhACAAJAAwAC8AMgAgACYAJQAnACIAMAAhAC4AKQAvADUAKgAzACgANgAtADQAIAAiACcAIwAlACIAKQArACUAKAAnACsAJgAoADMANQA3ACoANAAzADcAMgA0AC0ALwAxADYALgAtADEALAAuACEAJAAjADAAMgAsACAAJQArACcAMAAjACEAKQAkAC8AKgA3ADMANgAxAC0AOAA5ADoAOwA8AD0APgA/AEAAQQBCAEMARABFAEYARwBIAEkASgBLAEwATQBOAE8AOAA/AD4AOwA6ADkAQQA9ADwAQABDAEIAPgBLAEoATQBCAEEATABPAE4ASgBFAEQARwBOAE0ARgBJAEgARAA5ADgAPABIAEcASgA4AD4APQA/ADoASAA5AEYAQQBHAE0AQgBLAEAATgBFAEwAOAA6AD8AOwA9ADoAQQBDAD0AQAA/AEMAPgBAAEsATQBPAEIATABLAE8ASgBMAEUARwBJAE4ARgBFAEkARABGADkAPAA7AEgASgBEADgAPQBDAD8ASAA7ADkAQQA8AEcAQgBPAEsATgBJAEUAUABRAFIAUwBUAFEAVQBWAFQAVwBYAFYAWQBaAFgAWwBcAFoAXQBeAFwAXwBgAF4AYQBiAGAAYwBkAGIAZQBmAGQAZwBoAGYAaQBqAGgAawBsAGoAZQBdAFUAbQBuAGwAbwBSAG4AXgBmAG4AUABTAFEAUwBVAFQAVQBXAFYAVwBZAFgAWQBbAFoAWwBdAFwAXQBfAF4AXwBhAGAAYQBjAGIAYwBlAGQAZQBnAGYAZwBpAGgAaQBrAGoAawBtAGwAVQBTAFAAUABvAFUAbwBtAFUAbQBrAGUAawBpAGUAaQBnAGUAZQBjAF0AYwBhAF0AYQBfAF0AXQBbAFkAWQBXAF0AVwBVAF0AVQBtAGUAbQBvAG4AbwBQAFIAbgBSAFEAUQBUAFYAVgBYAFoAWgBcAF4AXgBgAGIAYgBkAGYAZgBoAGoAagBsAG4AbgBRAFYAVgBaAF4AXgBiAGYAZgBqAG4AbgBWAF4AcABxAHIAcwB0AHEAdQB2AHQAdwB4AHYAeQB6AHgAewB8AHoAfQB+AHwAfwCAAH4AgQCCAIAAgwCEAIIAhQCGAIQAhwCIAIYAiQCKAIgAiwCMAIoAhQB9AHUAjQCOAIwAjwByAI4AfgCGAI4AcABzAHEAcwB1AHQAdQB3AHYAdwB5AHgAeQB7AHoAewB9AHwAfQB/AH4AfwCBAIAAgQCDAIIAgwCFAIQAhQCHAIYAhwCJAIgAiQCLAIoAiwCNAIwAdQBzAHAAcACPAHUAjwCNAHUAjQCLAIUAiwCJAIUAiQCHAIUAhQCDAH0AgwCBAH0AgQB/AH0AfQB7AHkAeQB3AH0AdwB1AH0AdQCNAIUAjQCPAI4AjwBwAHIAjgByAHEAcQB0AHYAdgB4AHoAegB8AH4AfgCAAIIAggCEAIYAhgCIAIoAigCMAI4AjgBxAHYAdgB6AH4AfgCCAIYAhgCKAI4AjgB2AH4AkACRAJIAkwCUAJEAlQCWAJQAlwCYAJYAmQCaAJgAmwCcAJoAnQCeAJwAnwCgAJ4AoQCiAKAAowCkAKIApQCmAKQApwCoAKYAqQCqAKgAqwCsAKoApQCdAJUArQCuAKwArwCSAK4AngCmAK4AkACTAJEAkwCVAJQAlQCXAJYAlwCZAJgAmQCbAJoAmwCdAJwAnQCfAJ4AnwChAKAAoQCjAKIAowClAKQApQCnAKYApwCpAKgAqQCrAKoAqwCtAKwAlQCTAJAAkACvAJUArwCtAJUArQCrAKUAqwCpAKUAqQCnAKUApQCjAJ0AowChAJ0AoQCfAJ0AnQCbAJkAmQCXAJ0AlwCVAJ0AlQCtAKUArQCvAK4ArwCQAJIArgCSAJEAkQCUAJYAlgCYAJoAmgCcAJ4AngCgAKIAogCkAKYApgCoAKoAqgCsAK4ArgCRAJYAlgCaAJ4AngCiAKYApgCqAK4ArgCWAJ4AsACxALIAswC0ALEAtQC2ALQAtwC4ALYAuQC6ALgAuwC8ALoAvQC+ALwAvwDAAL4AwQDCAMAAwwDEAMIAxQDGAMQAxwDIAMYAyQDKAMgAywDMAMoAxQC9ALUAzQDOAMwAzwCyAM4AvgDGAM4AsACzALEAswC1ALQAtQC3ALYAtwC5ALgAuQC7ALoAuwC9ALwAvQC/AL4AvwDBAMAAwQDDAMIAwwDFAMQAxQDHAMYAxwDJAMgAyQDLAMoAywDNAMwAtQCzALAAsADPALUAzwDNALUAzQDLAMUAywDJAMUAyQDHAMUAxQDDAL0AwwDBAL0AwQC/AL0AvQC7ALkAuQC3AL0AtwC1AL0AtQDNAMUAzQDPAM4AzwCwALIAzgCyALEAsQC0ALYAtgC4ALoAugC8AL4AvgDAAMIAwgDEAMYAxgDIAMoAygDMAM4AzgCxALYAtgC6AL4AvgDCAMYAxgDKAM4AzgC2AL4A0ADRANIA0ADTANQA1QDWANcA2ADTANUA2QDYANoA0QDbANkA1ADTANsA3ADdAN4A3wDgANwA4QDfAOIA4wDkAOEA5QDjAOYA3QDnAOUA4ADkAOcA6ADpAOoA6wDsAOgA7QDrAO4A7wDwAO0A8QDvAPIA8QDsAPMA7ADwAPMA9AD1APYA9AD3APgA+QD6APsA/AD3APkA/QD8AP4A9QD/AP0A+AD3AP8AAAEBAQIBAwEEAQABBQEDAQYBBwEIAQUBCQEHAQoBCQEEAQsBBAEIAQsBDAENAQ4BDAEPARABEQESARMBFAEPAREBFQEUARYBDQEXARUBEAEPARcBGAEZARoBGAEbARwBHQEeAR8BIAEbAR0BIQEgASIBGQEjASEBHAEbASMBJAElASYBJwEoASQBKQEnASoBKwEsASkBLQErAS4BLQEoAS8BKAEsAS8B0gDoAOoA0QDrAOgA2QDuAOsA3gDVANcA3QDYANUA5QDaANgA9gDhAOIA9QDjAOEA/QDmAOMA8gD5APsA7wD8APkA7QD+APwAGgHpABgB6QAeARgB8QAfAR4B9gAlAfQAJQH6APQALQH7APoAIgEpASoBIAErASkBHQEuASsBGgEAAQIBGQEDAQABIQEGAQMBDgEkASYBDQEnASQBFQEqAScBCgERARMBBwEUAREBBQEWARQB0gABAdAAAQHWANAACQHXANYADgHfAAwB3wASAQwB3AATARIBGgHSAOoA5gDuANoAEwHXAAoB9gAOASYB+wAfAfIAKgEGASIB0ADUANEA0ADWANMA1QDTANYA2ADbANMA2QDbANgA0QDUANsA3ADgAN0A3wDkAOAA4QDkAN8A4wDnAOQA5QDnAOMA3QDgAOcA6ADsAOkA6wDwAOwA7QDwAOsA7wDzAPAA8QDzAO8A8QDpAOwA9AD4APUA9AD6APcA+QD3APoA/AD/APcA/QD/APwA9QD4AP8AAAEEAQEBAwEIAQQBBQEIAQMBBwELAQgBCQELAQcBCQEBAQQBDAEQAQ0BDAESAQ8BEQEPARIBFAEXAQ8BFQEXARQBDQEQARcBGAEcARkBGAEeARsBHQEbAR4BIAEjARsBIQEjASABGQEcASMBJAEoASUBJwEsASgBKQEsAScBKwEvASwBLQEvASsBLQElASgB0gDRAOgA0QDZAOsA2QDaAO4A3gDdANUA3QDlANgA5QDmANoA9gD1AOEA9QD9AOMA/QD+AOYA8gDvAPkA7wDtAPwA7QDuAP4AGgHqAOkA6QDxAB4B8QDyAB8B9gAmASUBJQEtAfoALQEuAfsAIgEgASkBIAEdASsBHQEfAS4BGgEZAQABGQEhAQMBIQEiAQYBDgENASQBDQEVAScBFQEWASoBCgEHAREBBwEFARQBBQEGARYB0gACAQEBAQEJAdYACQEKAdcADgHiAN8A3wDcABIB3ADeABMBGgECAdIA5gD+AO4AEwHeANcA9gDiAA4B+wAuAR8BKgEWAQYBMAExATIBMwE0ATUBNgE3ATgBOQE6ATsBPAE9AT4BPwFAAUEBQgFDAUQBRQFGAUcBMAE3ATYBMQE1ATIBOQE1ATQBOgE3ATsBNgFDAUIBRQE6ATkBRgFDAUcBQgE9ATwBPwFGAUUBQAE9AUEBPAExATABNAFAAT8BQgEwATYBNQE3ATIBQAExAT4BOQE/AUUBOgFDATgBRgE9AUQBMAEyATcBMQEzATUBOQE7ATUBOgE4ATcBNgE4AUMBRQFHAToBRgFEAUMBQgFEAT0BPwFBAUYBQAE+AT0BPAE+ATEBNAEzAUABQgE8ATABNQE7ATcBQAEzATEBOQE0AT8BOgFHAUMBRgFBAT0BSAFJAUoBSwFMAU0BTgFPAVABUQFSAVMBVAFVAVYBVwFYAVkBWgFbAVwBXQFeAV8BSAFPAU4BSQFNAUoBUQFNAUwBUgFPAVMBTgFbAVoBXQFSAVEBXgFbAV8BWgFVAVQBVwFeAV0BWAFVAVkBVAFJAUgBTAFYAVcBWgFIAU4BTQFPAUoBWAFJAVYBUQFXAV0BUgFbAVABXgFVAVwBSAFKAU8BSQFLAU0BUQFTAU0BUgFQAU8BTgFQAVsBXQFfAVIBXgFcAVsBWgFcAVUBVwFZAV4BWAFWAVUBVAFWAUkBTAFLAVgBWgFUAUgBTQFTAU8BWAFLAUkBUQFMAVcBUgFfAVsBXgFZAVUBYAFhAWIBYwFkAWUBZgFnAWgBaQFqAWsBbAFtAW4BbwFwAXEBcgFzAXQBdQF2AXcBYAFnAWYBYQFlAWIBaQFlAWQBagFnAWsBZgFzAXIBdQFqAWkBdgFzAXcBcgFtAWwBbwF2AXUBcAFtAXEBbAFhAWABZAFwAW8BcgFgAWYBZQFnAWIBcAFhAW4BaQFvAXUBagFzAWgBdgFtAXQBYAFiAWcBYQFjAWUBaQFrAWUBagFoAWcBZgFoAXMBdQF3AWoBdgF0AXMBcgF0AW0BbwFxAXYBcAFuAW0BbAFuAWEBZAFjAXABcgFsAWABZQFrAWcBcAFjAWEBaQFkAW8BagF3AXMBdgFxAW0BeAF5AXoBewF8AX0BfgF/AYABgQGCAYMBhAGFAYYBhwGIAYkBigGLAYwBjQGOAY8BeAF/AX4BeQF9AXoBgQF9AXwBggF/AYMBfgGLAYoBjQGCAYEBjgGLAY8BigGFAYQBhwGOAY0BiAGFAYkBhAF5AXgBfAGIAYcBigF4AX4BfQF/AXoBiAF5AYYBgQGHAY0BggGLAYABjgGFAYwBeAF6AX8BeQF7AX0BgQGDAX0BggGAAX8BfgGAAYsBjQGPAYIBjgGMAYsBigGMAYUBhwGJAY4BiAGGAYUBhAGGAXkBfAF7AYgBigGEAXgBfQGDAX8BiAF7AXkBgQF8AYcBggGPAYsBjgGJAYUBkAGRAZIBkwGUAZUBlgGXAZgBmQGaAZsBnAGdAZ4BnwGgAaEBogGjAaQBpQGmAacBkAGXAZYBkQGVAZIBmQGVAZQBmgGXAZsBlgGjAaIBpQGaAZkBpgGjAacBogGdAZwBnwGmAaUBoAGdAaEBnAGRAZABlAGgAZ8BogGQAZYBlQGXAZIBoAGRAZ4BmQGfAaUBmgGjAZgBpgGdAaQBkAGSAZcBkQGTAZUBmQGbAZUBmgGYAZcBlgGYAaMBpQGnAZoBpgGkAaMBogGkAZ0BnwGhAaYBoAGeAZ0BnAGeAZEBlAGTAaABogGcAZABlQGbAZcBoAGTAZEBmQGUAZ8BmgGnAaMBpgGhAZ0BqAGpAaoBqwGsAakBrQGuAawBrwGqAa4BrAGqAakBqwGvAa0BqAGrAakBqwGtAawBrQGvAa4BrwGoAaoBrAGuAaoBqwGoAa8BsAGxAbIBswG0AbUBtgG3AbgBuQG6AbsBvAG9Ab4BvwHAAcEBwgHDAcQBxQHGAccBsAG3AbYBswGyAbEBuQG1AbQBuAG7AboBtgHDAcIBxQG6AbkBxAHHAcYBwgG9AbwBvwHGAcUBvgHBAcABvAGxAbABtAHAAb8BwgGwAbYBtQG3AbIBwAGxAb4BuQG/AcUBugHDAbgBxgG9AcQBsAGyAbcBswG1AbIBuQG7AbUBuAG3AbsBtgG4AcMBxQHHAboBxAHDAccBwgHEAb0BvwHBAcYBvgG9AcEBvAG+AbEBtAGzAcABwgG8AbABtQG7AbcBwAGzAbEBuQG0Ab8BugHHAcMBxgHBAb0BAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=",
        Palette = {
            { 0.05, 0.055, 0.06 },
            { 0.035, 0.036, 0.04 },
            { 0.012, 0.012, 0.012 },
            { 0.16, 0.17, 0.18 },
            { 0.3, 0.31, 0.33 },
            { 0.05, 0.4, 0.1 },
            { 0.1, 0.32, 0.08 }
        }
    },
    Lcd = {
        Centre = Vector3.new(0, 4.980337, -0.807593),
        Normal = Vector3.new(0, 0.374607, 0.927184),
        Up = Vector3.new(0, 0.927184, -0.374607),
        Size = Vector2.new(0.84, 0.24)
    }
}


// ============================================
// END OF: WeighScaleMesh.luau
// ============================================

// ============================================
// FILE: WeightClass (1).luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\WeightClass (1).luau
// SIZE: 1678 bytes
// ============================================
-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats = require(ReplicatedStorage:WaitForChild("Boxing"):WaitForChild("BoxingConfig")).Stats
local t1 = {
    Start = 50,
    PerPoint = 1.1,
    Max = 94,
    Classes = {
        {
            Name = "Amateur",
            Min = 50,
            Max = 61,
            Amateur = true
        },
        {
            Name = "Lightweight",
            Min = 61,
            Max = 71
        },
        {
            Name = "Middleweight",
            Min = 71,
            Max = 83,
            MaxIncluded = true
        },
        {
            Name = "Cruiserweight",
            Min = 83,
            Max = 94
        }
    },
    Points = function(p1) -- Points | line: 27
        -- upvalues: Stats (copy)
        local n1 = 0

        for _, v1 in Stats.Names do
            n1 += math.floor((tonumber(p1:GetAttribute("Stat_" .. v1)) or 0) + 1E-06)
        end

        return (math.min(n1, Stats.PointCap or 40))
    end
}

function t1.Kg(p2) -- line: 35
    -- upvalues: t1 (copy)
    local v5 = tonumber(p2:GetAttribute("BodyWeight"))

    if v5 then
        return math.floor(v5 * 10 + 0.5) / 10
    end

    return math.floor(math.min(t1.Max, t1.Start + t1.PerPoint * t1.Points(p2)) * 10 + 0.5) / 10
end

function t1.Of(p3) -- line: 47
    -- upvalues: t1 (copy)
    local v9 = if type(p3) == "number" then math.floor(p3 * 10 + 0.5) / 10 else t1.Kg(p3)

    for v11, v12 in t1.Classes do
        if v9 < v12.Max or v12.MaxIncluded and v9 <= v12.Max or v11 == #t1.Classes then
            return v12, v11, v9
        end
    end

    return t1.Classes[1], 1, v9
end

return t1


// ============================================
// END OF: WeightClass (1).luau
// ============================================

// ============================================
// FILE: WeightClass.luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\WeightClass.luau
// SIZE: 1678 bytes
// ============================================
-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats = require(ReplicatedStorage:WaitForChild("Boxing"):WaitForChild("BoxingConfig")).Stats
local t1 = {
    Start = 50,
    PerPoint = 1.1,
    Max = 94,
    Classes = {
        {
            Name = "Amateur",
            Min = 50,
            Max = 61,
            Amateur = true
        },
        {
            Name = "Lightweight",
            Min = 61,
            Max = 71
        },
        {
            Name = "Middleweight",
            Min = 71,
            Max = 83,
            MaxIncluded = true
        },
        {
            Name = "Cruiserweight",
            Min = 83,
            Max = 94
        }
    },
    Points = function(p1) -- Points | line: 27
        -- upvalues: Stats (copy)
        local n1 = 0

        for _, v1 in Stats.Names do
            n1 += math.floor((tonumber(p1:GetAttribute("Stat_" .. v1)) or 0) + 1E-06)
        end

        return (math.min(n1, Stats.PointCap or 40))
    end
}

function t1.Kg(p2) -- line: 35
    -- upvalues: t1 (copy)
    local v5 = tonumber(p2:GetAttribute("BodyWeight"))

    if v5 then
        return math.floor(v5 * 10 + 0.5) / 10
    end

    return math.floor(math.min(t1.Max, t1.Start + t1.PerPoint * t1.Points(p2)) * 10 + 0.5) / 10
end

function t1.Of(p3) -- line: 47
    -- upvalues: t1 (copy)
    local v9 = if type(p3) == "number" then math.floor(p3 * 10 + 0.5) / 10 else t1.Kg(p3)

    for v11, v12 in t1.Classes do
        if v9 < v12.Max or v12.MaxIncluded and v9 <= v12.Max or v11 == #t1.Classes then
            return v12, v11, v9
        end
    end

    return t1.Classes[1], 1, v9
end

return t1


// ============================================
// END OF: WeightClass.luau
// ============================================

// ============================================
// FILE: WeightUnits (1).luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\WeightUnits (1).luau
// SIZE: 2017 bytes
// ============================================
-- https://lua.expert

local t1 = {}
local result

local function settings() -- line: 13
    -- upvalues: result (ref)
    if not game:GetService("RunService"):IsClient() then
        return nil
    end

    if result == nil then
        local _require = require
        local Parent = script.Parent
        local ok, result2 = pcall(_require, Parent:WaitForChild("BoxingSettings"))

        if not ok then
            result2 = false
        end

        result = result2
    end

    return result or nil
end

function t1.Pounds() -- line: 24
    -- upvalues: settings (copy)
    local v1 = settings()

    local function v2() -- line: 26
        -- upvalues: v1 (copy)
        return v1 and v1.Get("WeightInPounds")
    end

    local ok, result = pcall(v2)

    return ok and result == true
end

function t1.Unit() -- line: 32
    -- upvalues: t1 (copy)
    if t1.Pounds() then
        return "lbs"
    end

    return "kg"
end

function t1.Number(p1, p2) -- line: 36
    -- upvalues: t1 (copy)
    local v3 = tonumber(p1) or 0

    if t1.Pounds() then
        v3 *= 2.20462
    end

    return string.format("%." .. tostring(p2 or 1) .. "f", v3)
end

function t1.Format(p3, p4) -- line: 42
    -- upvalues: t1 (copy)
    return t1.Number(p3, p4) .. " " .. t1.Unit()
end

function t1.Upper(p5, p6) -- line: 46
    -- upvalues: t1 (copy)
    return string.upper(t1.Format(p5, p6))
end

local BindableEvent = Instance.new("BindableEvent")

t1.Changed = BindableEvent.Event
task.spawn(function() -- line: 52
    -- upvalues: settings (copy), BindableEvent (copy)
    local v5 = settings()

    if v5 and v5.Changed then
        local function v6() -- line: 55
            -- upvalues: v5 (copy), BindableEvent (copy)
            v5.Changed:Connect(function(p7) -- line: 56
                -- upvalues: BindableEvent (copy)
                if p7 == nil or p7 == "WeightInPounds" then
                    BindableEvent:Fire()
                end
            end)
        end

        pcall(v6)
    end
end)

return t1


// ============================================
// END OF: WeightUnits (1).luau
// ============================================

// ============================================
// FILE: WeightUnits.luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\WeightUnits.luau
// SIZE: 2017 bytes
// ============================================
-- https://lua.expert

local t1 = {}
local result

local function settings() -- line: 13
    -- upvalues: result (ref)
    if not game:GetService("RunService"):IsClient() then
        return nil
    end

    if result == nil then
        local _require = require
        local Parent = script.Parent
        local ok, result2 = pcall(_require, Parent:WaitForChild("BoxingSettings"))

        if not ok then
            result2 = false
        end

        result = result2
    end

    return result or nil
end

function t1.Pounds() -- line: 24
    -- upvalues: settings (copy)
    local v1 = settings()

    local function v2() -- line: 26
        -- upvalues: v1 (copy)
        return v1 and v1.Get("WeightInPounds")
    end

    local ok, result = pcall(v2)

    return ok and result == true
end

function t1.Unit() -- line: 32
    -- upvalues: t1 (copy)
    if t1.Pounds() then
        return "lbs"
    end

    return "kg"
end

function t1.Number(p1, p2) -- line: 36
    -- upvalues: t1 (copy)
    local v3 = tonumber(p1) or 0

    if t1.Pounds() then
        v3 *= 2.20462
    end

    return string.format("%." .. tostring(p2 or 1) .. "f", v3)
end

function t1.Format(p3, p4) -- line: 42
    -- upvalues: t1 (copy)
    return t1.Number(p3, p4) .. " " .. t1.Unit()
end

function t1.Upper(p5, p6) -- line: 46
    -- upvalues: t1 (copy)
    return string.upper(t1.Format(p5, p6))
end

local BindableEvent = Instance.new("BindableEvent")

t1.Changed = BindableEvent.Event
task.spawn(function() -- line: 52
    -- upvalues: settings (copy), BindableEvent (copy)
    local v5 = settings()

    if v5 and v5.Changed then
        local function v6() -- line: 55
            -- upvalues: v5 (copy), BindableEvent (copy)
            v5.Changed:Connect(function(p7) -- line: 56
                -- upvalues: BindableEvent (copy)
                if p7 == nil or p7 == "WeightInPounds" then
                    BindableEvent:Fire()
                end
            end)
        end

        pcall(v6)
    end
end)

return t1


// ============================================
// END OF: WeightUnits.luau
// ============================================

// ============================================
// FILE: WindLines (1).luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\WindLines (1).luau
// SIZE: 4475 bytes
// ============================================
-- https://lua.expert

local RunService = game:GetService("RunService")
local Terrain = workspace:FindFirstChildOfClass("Terrain")
local t1 = {}
local t2 = {
    UpdateQueue = table.create(10)
}

function t2.Init(_, p2) -- line: 11
    -- upvalues: RunService (copy), Terrain (copy), t2 (copy)
    t2.Lifetime = p2.Lifetime or 3
    t2.Direction = p2.Direction or Vector3.new(1, 0, 0)
    t2.Speed = p2.Speed or 6

    if t2.UpdateConnection then
        t2.UpdateConnection:Disconnect()
        t2.UpdateConnection = nil
    end

    for _, v1 in ipairs(t2.UpdateQueue) do
        v1.Attachment0:Destroy()
        v1.Attachment1:Destroy()
        v1.Trail:Destroy()
    end

    table.clear(t2.UpdateQueue)

    if Terrain then
        for _, child in Terrain:GetChildren() do
            if child.Name == "WindLine" and child:IsA("Attachment") then
                child:Destroy()
            end
        end
    end

    t2.LastSpawned = os.clock()

    local v2 = 1 / (p2.SpawnRate or 25)

    t2.UpdateConnection = RunService.Heartbeat:Connect(function() -- line: 42
        -- upvalues: v2 (copy), t2 (copy)
        local elapsed = os.clock()

        if elapsed - t2.LastSpawned > v2 then
            t2:Create()
            t2.LastSpawned = elapsed
        end

        debug.profilebegin("Wind Lines")

        local UpdateQueue = t2.UpdateQueue

        for i = #UpdateQueue, 1, -1 do
            local v3 = UpdateQueue[i]
            local v4 = elapsed - v3.StartClock

            if v3.Lifetime <= v4 then
                v3.Attachment0:Destroy()
                v3.Attachment1:Destroy()
                v3.Trail:Destroy()

                local v5 = #UpdateQueue

                UpdateQueue[i] = UpdateQueue[v5]
                UpdateQueue[v5] = nil
            else
                v3.Trail.MaxLength = 20 - 20 * (v4 / v3.Lifetime)

                local v7 = math.sin((elapsed + v3.Seed) * (v3.Speed * 0.2))
                local v12 = v3.Position + v3.Unit * (v3.Speed * v4) + Vector3.new(v7 * 0.5, v7 * 0.8, v7 * 0.5)

                v3.Attachment0.Position = v12
                v3.Attachment1.Position = v12 + Vector3.new(0, 0.1, 0)
            end
        end

        debug.profileend()
    end)
end

function t2.Cleanup(_) -- line: 89
    -- upvalues: t2 (copy)
    if t2.UpdateConnection then
        t2.UpdateConnection:Disconnect()
        t2.UpdateConnection = nil
    end

    for _, v13 in ipairs(t2.UpdateQueue) do
        v13.Attachment0:Destroy()
        v13.Attachment1:Destroy()
        v13.Trail:Destroy()
    end

    table.clear(t2.UpdateQueue)
end

function t2.Create(_, p5) -- line: 105
    -- upvalues: Terrain (copy), t1 (copy), t2 (copy)
    debug.profilebegin("Add Wind Line")
    p5 = p5 or t1

    local v15 = p5.Lifetime or t2.Lifetime
    local Position = p5.Position

    if not Position then
        Position = workspace.CurrentCamera.CFrame * CFrame.Angles(math.rad((math.random(-30, 70))), math.rad((math.random(-80, 80))), 0) * CFrame.new(0, 0, math.random(200, 600) * -0.1).Position
    end

    local v19 = p5.Direction or t2.Direction
    local v20 = p5.Speed or t2.Speed

    if v20 <= 0 then
        return
    end

    local Attachment = Instance.new("Attachment")
    local Attachment2 = Instance.new("Attachment")

    Attachment.Name = "WindLine"
    Attachment2.Name = "WindLine"

    local Trail = Instance.new("Trail")

    Trail.Attachment0 = Attachment
    Trail.Attachment1 = Attachment2
    Trail.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(0.2, 1),
        NumberSequenceKeypoint.new(0.8, 1),
        NumberSequenceKeypoint.new(1, 0.3)
    })
    Trail.Transparency = NumberSequence.new(0.7)
    Trail.FaceCamera = true
    Trail.Parent = Attachment
    Attachment.WorldPosition = Position
    Attachment2.WorldPosition = Position + Vector3.new(0, 0.1, 0)

    local t3 = {
        Attachment0 = Attachment,
        Attachment1 = Attachment2,
        Trail = Trail,
        Lifetime = v15 + math.random(-10, 10) * 0.1,
        Position = Position,
        Direction = v19,
        Unit = if v19.Magnitude > 1E-06 then v19.Unit else Vector3.new(0, 0, -1),
        Speed = v20 + math.random(-10, 10) * 0.1,
        StartClock = os.clock(),
        Seed = math.random(1, 1000) * 0.1
    }

    t2.UpdateQueue[#t2.UpdateQueue + 1] = t3
    Attachment.Parent = Terrain
    Attachment2.Parent = Terrain
    debug.profileend()
end

return t2


// ============================================
// END OF: WindLines (1).luau
// ============================================

// ============================================
// FILE: WindLines (2).luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\WindLines (2).luau
// SIZE: 4475 bytes
// ============================================
-- https://lua.expert

local RunService = game:GetService("RunService")
local Terrain = workspace:FindFirstChildOfClass("Terrain")
local t1 = {}
local t2 = {
    UpdateQueue = table.create(10)
}

function t2.Init(_, p2) -- line: 11
    -- upvalues: RunService (copy), Terrain (copy), t2 (copy)
    t2.Lifetime = p2.Lifetime or 3
    t2.Direction = p2.Direction or Vector3.new(1, 0, 0)
    t2.Speed = p2.Speed or 6

    if t2.UpdateConnection then
        t2.UpdateConnection:Disconnect()
        t2.UpdateConnection = nil
    end

    for _, v1 in ipairs(t2.UpdateQueue) do
        v1.Attachment0:Destroy()
        v1.Attachment1:Destroy()
        v1.Trail:Destroy()
    end

    table.clear(t2.UpdateQueue)

    if Terrain then
        for _, child in Terrain:GetChildren() do
            if child.Name == "WindLine" and child:IsA("Attachment") then
                child:Destroy()
            end
        end
    end

    t2.LastSpawned = os.clock()

    local v2 = 1 / (p2.SpawnRate or 25)

    t2.UpdateConnection = RunService.Heartbeat:Connect(function() -- line: 42
        -- upvalues: v2 (copy), t2 (copy)
        local elapsed = os.clock()

        if elapsed - t2.LastSpawned > v2 then
            t2:Create()
            t2.LastSpawned = elapsed
        end

        debug.profilebegin("Wind Lines")

        local UpdateQueue = t2.UpdateQueue

        for i = #UpdateQueue, 1, -1 do
            local v3 = UpdateQueue[i]
            local v4 = elapsed - v3.StartClock

            if v3.Lifetime <= v4 then
                v3.Attachment0:Destroy()
                v3.Attachment1:Destroy()
                v3.Trail:Destroy()

                local v5 = #UpdateQueue

                UpdateQueue[i] = UpdateQueue[v5]
                UpdateQueue[v5] = nil
            else
                v3.Trail.MaxLength = 20 - 20 * (v4 / v3.Lifetime)

                local v7 = math.sin((elapsed + v3.Seed) * (v3.Speed * 0.2))
                local v12 = v3.Position + v3.Unit * (v3.Speed * v4) + Vector3.new(v7 * 0.5, v7 * 0.8, v7 * 0.5)

                v3.Attachment0.Position = v12
                v3.Attachment1.Position = v12 + Vector3.new(0, 0.1, 0)
            end
        end

        debug.profileend()
    end)
end

function t2.Cleanup(_) -- line: 89
    -- upvalues: t2 (copy)
    if t2.UpdateConnection then
        t2.UpdateConnection:Disconnect()
        t2.UpdateConnection = nil
    end

    for _, v13 in ipairs(t2.UpdateQueue) do
        v13.Attachment0:Destroy()
        v13.Attachment1:Destroy()
        v13.Trail:Destroy()
    end

    table.clear(t2.UpdateQueue)
end

function t2.Create(_, p5) -- line: 105
    -- upvalues: Terrain (copy), t1 (copy), t2 (copy)
    debug.profilebegin("Add Wind Line")
    p5 = p5 or t1

    local v15 = p5.Lifetime or t2.Lifetime
    local Position = p5.Position

    if not Position then
        Position = workspace.CurrentCamera.CFrame * CFrame.Angles(math.rad((math.random(-30, 70))), math.rad((math.random(-80, 80))), 0) * CFrame.new(0, 0, math.random(200, 600) * -0.1).Position
    end

    local v19 = p5.Direction or t2.Direction
    local v20 = p5.Speed or t2.Speed

    if v20 <= 0 then
        return
    end

    local Attachment = Instance.new("Attachment")
    local Attachment2 = Instance.new("Attachment")

    Attachment.Name = "WindLine"
    Attachment2.Name = "WindLine"

    local Trail = Instance.new("Trail")

    Trail.Attachment0 = Attachment
    Trail.Attachment1 = Attachment2
    Trail.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(0.2, 1),
        NumberSequenceKeypoint.new(0.8, 1),
        NumberSequenceKeypoint.new(1, 0.3)
    })
    Trail.Transparency = NumberSequence.new(0.7)
    Trail.FaceCamera = true
    Trail.Parent = Attachment
    Attachment.WorldPosition = Position
    Attachment2.WorldPosition = Position + Vector3.new(0, 0.1, 0)

    local t3 = {
        Attachment0 = Attachment,
        Attachment1 = Attachment2,
        Trail = Trail,
        Lifetime = v15 + math.random(-10, 10) * 0.1,
        Position = Position,
        Direction = v19,
        Unit = if v19.Magnitude > 1E-06 then v19.Unit else Vector3.new(0, 0, -1),
        Speed = v20 + math.random(-10, 10) * 0.1,
        StartClock = os.clock(),
        Seed = math.random(1, 1000) * 0.1
    }

    t2.UpdateQueue[#t2.UpdateQueue + 1] = t3
    Attachment.Parent = Terrain
    Attachment2.Parent = Terrain
    debug.profileend()
end

return t2


// ============================================
// END OF: WindLines (2).luau
// ============================================

// ============================================
// FILE: WindLines.luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\WindLines.luau
// SIZE: 4475 bytes
// ============================================
-- https://lua.expert

local RunService = game:GetService("RunService")
local Terrain = workspace:FindFirstChildOfClass("Terrain")
local t1 = {}
local t2 = {
    UpdateQueue = table.create(10)
}

function t2.Init(_, p2) -- line: 11
    -- upvalues: RunService (copy), Terrain (copy), t2 (copy)
    t2.Lifetime = p2.Lifetime or 3
    t2.Direction = p2.Direction or Vector3.new(1, 0, 0)
    t2.Speed = p2.Speed or 6

    if t2.UpdateConnection then
        t2.UpdateConnection:Disconnect()
        t2.UpdateConnection = nil
    end

    for _, v1 in ipairs(t2.UpdateQueue) do
        v1.Attachment0:Destroy()
        v1.Attachment1:Destroy()
        v1.Trail:Destroy()
    end

    table.clear(t2.UpdateQueue)

    if Terrain then
        for _, child in Terrain:GetChildren() do
            if child.Name == "WindLine" and child:IsA("Attachment") then
                child:Destroy()
            end
        end
    end

    t2.LastSpawned = os.clock()

    local v2 = 1 / (p2.SpawnRate or 25)

    t2.UpdateConnection = RunService.Heartbeat:Connect(function() -- line: 42
        -- upvalues: v2 (copy), t2 (copy)
        local elapsed = os.clock()

        if elapsed - t2.LastSpawned > v2 then
            t2:Create()
            t2.LastSpawned = elapsed
        end

        debug.profilebegin("Wind Lines")

        local UpdateQueue = t2.UpdateQueue

        for i = #UpdateQueue, 1, -1 do
            local v3 = UpdateQueue[i]
            local v4 = elapsed - v3.StartClock

            if v3.Lifetime <= v4 then
                v3.Attachment0:Destroy()
                v3.Attachment1:Destroy()
                v3.Trail:Destroy()

                local v5 = #UpdateQueue

                UpdateQueue[i] = UpdateQueue[v5]
                UpdateQueue[v5] = nil
            else
                v3.Trail.MaxLength = 20 - 20 * (v4 / v3.Lifetime)

                local v7 = math.sin((elapsed + v3.Seed) * (v3.Speed * 0.2))
                local v12 = v3.Position + v3.Unit * (v3.Speed * v4) + Vector3.new(v7 * 0.5, v7 * 0.8, v7 * 0.5)

                v3.Attachment0.Position = v12
                v3.Attachment1.Position = v12 + Vector3.new(0, 0.1, 0)
            end
        end

        debug.profileend()
    end)
end

function t2.Cleanup(_) -- line: 89
    -- upvalues: t2 (copy)
    if t2.UpdateConnection then
        t2.UpdateConnection:Disconnect()
        t2.UpdateConnection = nil
    end

    for _, v13 in ipairs(t2.UpdateQueue) do
        v13.Attachment0:Destroy()
        v13.Attachment1:Destroy()
        v13.Trail:Destroy()
    end

    table.clear(t2.UpdateQueue)
end

function t2.Create(_, p5) -- line: 105
    -- upvalues: Terrain (copy), t1 (copy), t2 (copy)
    debug.profilebegin("Add Wind Line")
    p5 = p5 or t1

    local v15 = p5.Lifetime or t2.Lifetime
    local Position = p5.Position

    if not Position then
        Position = workspace.CurrentCamera.CFrame * CFrame.Angles(math.rad((math.random(-30, 70))), math.rad((math.random(-80, 80))), 0) * CFrame.new(0, 0, math.random(200, 600) * -0.1).Position
    end

    local v19 = p5.Direction or t2.Direction
    local v20 = p5.Speed or t2.Speed

    if v20 <= 0 then
        return
    end

    local Attachment = Instance.new("Attachment")
    local Attachment2 = Instance.new("Attachment")

    Attachment.Name = "WindLine"
    Attachment2.Name = "WindLine"

    local Trail = Instance.new("Trail")

    Trail.Attachment0 = Attachment
    Trail.Attachment1 = Attachment2
    Trail.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(0.2, 1),
        NumberSequenceKeypoint.new(0.8, 1),
        NumberSequenceKeypoint.new(1, 0.3)
    })
    Trail.Transparency = NumberSequence.new(0.7)
    Trail.FaceCamera = true
    Trail.Parent = Attachment
    Attachment.WorldPosition = Position
    Attachment2.WorldPosition = Position + Vector3.new(0, 0.1, 0)

    local t3 = {
        Attachment0 = Attachment,
        Attachment1 = Attachment2,
        Trail = Trail,
        Lifetime = v15 + math.random(-10, 10) * 0.1,
        Position = Position,
        Direction = v19,
        Unit = if v19.Magnitude > 1E-06 then v19.Unit else Vector3.new(0, 0, -1),
        Speed = v20 + math.random(-10, 10) * 0.1,
        StartClock = os.clock(),
        Seed = math.random(1, 1000) * 0.1
    }

    t2.UpdateQueue[#t2.UpdateQueue + 1] = t3
    Attachment.Parent = Terrain
    Attachment2.Parent = Terrain
    debug.profileend()
end

return t2


// ============================================
// END OF: WindLines.luau
// ============================================

// ============================================
// FILE: WorldController (1).luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\WorldController (1).luau
// SIZE: 12279 bytes
// ============================================
-- https://lua.expert

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Boxing = ReplicatedStorage:WaitForChild("Boxing")
local BoxingConfig = require(Boxing:WaitForChild("BoxingConfig"))
local BoxingSettings = require(Boxing:WaitForChild("BoxingSettings"))
local World = BoxingConfig.World
local LocalPlayer = Players.LocalPlayer

local function lerp(p1, p2, p3) -- line: 26
    return p1 + (p2 - p1) * p3
end

local function smooth(p4) -- line: 29
    local v1 = math.clamp(p4, 0, 1)

    return v1 * v1 * (3 - 2 * v1)
end

local v2 = World.DayMinutes * 60
local v3 = World.NightMinutes * 60
local v4 = World.Sunset - World.Sunrise
local v5 = 24 - v4

local function clockNow() -- line: 38
    -- upvalues: World (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy)
    local WorldCycleStart = workspace:GetAttribute("WorldCycleStart")

    if type(WorldCycleStart) ~= "number" then
        return World.StartClock or 12
    end

    local v6 = (workspace:GetServerTimeNow() - WorldCycleStart) % (v2 + v3)

    if v6 < v2 then
        return World.Sunrise + v6 / v2 * v4
    end

    return (World.Sunset + (v6 - v2) / v3 * v5) % 24
end

local function daylight(p5) -- line: 51
    -- upvalues: World (copy)
    local v7 = World.Twilight or 1
    local v9 = math.clamp((p5 - (World.Sunrise - v7)) / (2 * v7), 0, 1)
    local v10 = v9 * v9 * (3 - 2 * v9)
    local v12 = math.clamp((p5 - (World.Sunset - v7)) / (2 * v7), 0, 1)

    return (math.min(v10, 1 - v12 * v12 * (3 - 2 * v12)))
end

local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
local SunRaysEffect = Lighting:FindFirstChildOfClass("SunRaysEffect")
local Clouds = workspace.Terrain:FindFirstChildOfClass("Clouds")
local t1 = {
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
    EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
    AtmosphereColor = Atmosphere and Atmosphere.Color,
    AtmosphereDecay = Atmosphere and Atmosphere.Decay,
    AtmosphereDensity = Atmosphere and Atmosphere.Density,
    AtmosphereHaze = Atmosphere and Atmosphere.Haze,
    AtmosphereGlare = Atmosphere and Atmosphere.Glare,
    SunRays = SunRaysEffect and SunRaysEffect.Intensity,
    CloudCover = Clouds and Clouds.Cover,
    CloudDensity = Clouds and Clouds.Density,
    CloudColor = Clouds and Clouds.Color
}
local Night, Rain = World.Night, World.Rain
local v14 = Color3.fromRGB(128, 132, 140)
local v15 = Lighting:FindFirstChild("WorldGrade") or Instance.new("ColorCorrectionEffect")

v15.Name = "WorldGrade"
v15.Parent = Lighting

local function rainTarget() -- line: 87
    if workspace:GetAttribute("WeatherRain") then
        return 1
    end

    return 0
end

local WeatherSince = workspace:GetAttribute("WeatherSince")
local v19 = math.clamp((if type(WeatherSince) == "number" then workspace:GetServerTimeNow() - WeatherSince else 1e999) / math.max(World.RainFade or 20, 0.1), 0, 1)
local v20 = if (if workspace:GetAttribute("WeatherRain") then 1 else 0) == 1 then v19 else 1 - v19

local function applyLook(p6, p7) -- line: 97
    -- upvalues: Lighting (copy), Atmosphere (copy), SunRaysEffect (copy), Clouds (copy), t1 (copy), Night (copy), Rain (copy), v14 (copy), v15 (copy)
    local v21 = 1 - p6
    local Brightness = t1.Brightness

    Lighting.Brightness = (Brightness + (Night.Brightness - Brightness) * v21) * (1 + (Rain.Brightness - 1) * p7)

    local v22 = t1.Ambient:Lerp(Night.Ambient, v21)
    local v23 = t1.OutdoorAmbient:Lerp(Night.OutdoorAmbient, v21)

    Lighting.Ambient = v22:Lerp(v14:Lerp(v22, 0.5), p7 * Rain.AmbientGrey * 2)
    Lighting.OutdoorAmbient = v23:Lerp(v14:Lerp(v23, 0.5), p7 * Rain.AmbientGrey * 2)

    local EnvironmentDiffuseScale = t1.EnvironmentDiffuseScale

    Lighting.EnvironmentDiffuseScale = EnvironmentDiffuseScale + (Night.EnvironmentDiffuseScale - EnvironmentDiffuseScale) * v21

    local EnvironmentSpecularScale = t1.EnvironmentSpecularScale

    Lighting.EnvironmentSpecularScale = EnvironmentSpecularScale + (Night.EnvironmentSpecularScale - EnvironmentSpecularScale) * v21

    if Atmosphere then
        Atmosphere.Color = t1.AtmosphereColor:Lerp(Night.AtmosphereColor, v21):Lerp(Rain.AtmosphereColor:Lerp(Night.AtmosphereColor, v21 * 0.7), p7 * 0.6)
        Atmosphere.Decay = t1.AtmosphereDecay:Lerp(Night.AtmosphereDecay, v21)

        local AtmosphereDensity = t1.AtmosphereDensity

        Atmosphere.Density = AtmosphereDensity + (Night.AtmosphereDensity - AtmosphereDensity) * v21 + Rain.AtmosphereDensity * p7

        local AtmosphereHaze = t1.AtmosphereHaze

        Atmosphere.Haze = AtmosphereHaze + (Night.AtmosphereHaze - AtmosphereHaze) * v21 + Rain.AtmosphereHaze * p7

        local AtmosphereGlare = t1.AtmosphereGlare

        Atmosphere.Glare = (AtmosphereGlare + (Night.AtmosphereGlare - AtmosphereGlare) * v21) * (1 - p7)
    end

    if SunRaysEffect then
        local SunRays = t1.SunRays

        SunRaysEffect.Intensity = (SunRays + (Night.SunRays - SunRays) * v21) * (1 - p7)
    end

    if Clouds then
        local CloudCover = t1.CloudCover

        Clouds.Cover = CloudCover + (Rain.CloudCover - CloudCover) * p7

        local CloudDensity = t1.CloudDensity

        Clouds.Density = CloudDensity + (Rain.CloudDensity - CloudDensity) * p7
        Clouds.Color = t1.CloudColor:Lerp(Night.CloudColor, v21):Lerp(Rain.CloudColor:Lerp(Night.CloudColor, v21), p7)
    end

    v15.TintColor = Color3.new(1, 1, 1):Lerp(Night.Tint, v21)
    v15.Saturation = Night.Saturation * v21 + Rain.Saturation * p7
    v15.Brightness = Rain.BrightnessShift * p7
end

local CurrentCamera = workspace.CurrentCamera
local RainAsset = Boxing:WaitForChild("RainAsset")
local Folder = Instance.new("Folder")

Folder.Name = "WorldRain"

local function rainPart(p8, p9) -- line: 132
    -- upvalues: Folder (copy)
    local Part = Instance.new("Part")

    Part.Name = p8
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(200, p9, 200)
    Part.Parent = Folder

    return Part
end

local Part = Instance.new("Part")

Part.Name = "RainSky"
Part.Anchored = true
Part.CanCollide = false
Part.CanQuery = false
Part.CanTouch = false
Part.CastShadow = false
Part.Transparency = 1
Part.Size = Vector3.new(200, 3.5, 200)
Part.Parent = Folder

local Part2 = Instance.new("Part")

Part2.Name = "RainFloor"
Part2.Anchored = true
Part2.CanCollide = false
Part2.CanQuery = false
Part2.CanTouch = false
Part2.CastShadow = false
Part2.Transparency = 1
Part2.Size = Vector3.new(200, 1, 200)
Part2.Parent = Folder

local clone = RainAsset:WaitForChild("Streaks"):Clone()

clone.Parent = Part

local clone2 = RainAsset:WaitForChild("Splashes"):Clone()

clone2.Parent = Part2
clone.Rate = 0
clone2.Rate = 0
clone.Enabled = true
clone2.Enabled = true
Folder.Parent = workspace

local Sound = Instance.new("Sound")

Sound.Name = "WorldRainSound"
Sound.Looped = true
Sound.Volume = 0
Sound.SoundId = World.RainSound or ""
Sound.SoundGroup = SoundService:FindFirstChild("BoxingMaster")
Sound.Parent = SoundService

local v25 = RaycastParams.new()

v25.FilterType = Enum.RaycastFilterType.Exclude
v25.IgnoreWater = true

local function solid(p10) -- line: 162
    local Terrain = p10:IsA("Terrain")

    if not Terrain then
        Terrain = p10:IsA("BasePart")

        if Terrain then
            Terrain = p10.Transparency < 0.9 and p10.Material ~= Enum.Material.Glass and p10.Material ~= Enum.Material.ForceField
        end
    end

    return Terrain
end

local function castSolid(p11, p12) -- line: 167
    -- upvalues: Players (copy), Folder (copy), v25 (copy)
    local t2 = {
        Folder
    }

    for _, player in Players:GetPlayers() do
        if player.Character then
            table.insert(t2, player.Character)
        end
    end

    for _ = 1, 8 do
        v25.FilterDescendantsInstances = t2

        local v26 = workspace:Raycast(p11, p12, v25)
        local v27 = false

        if v26 then
            local Instance = v26.Instance
            local Terrain = Instance:IsA("Terrain")

            if not Terrain then
                Terrain = Instance:IsA("BasePart")

                if Terrain then
                    Terrain = Instance.Transparency < 0.9 and Instance.Material ~= Enum.Material.Glass and Instance.Material ~= Enum.Material.ForceField
                end
            end

            v27 = not Terrain
        end

        if not v27 then
            return v26
        end

        table.insert(t2, v26.Instance)
    end

    return nil
end

local v28 = false
local n1 = 0
local v29

local function updateRain(p13) -- line: 186
    -- upvalues: BoxingSettings (copy), World (copy), LocalPlayer (copy), v20 (ref), CurrentCamera (ref), Part (copy), Part2 (copy), clone (copy), clone2 (copy), Sound (copy), castSolid (copy), v28 (ref), n1 (ref), v29 (ref)
    local v30 = if workspace:GetAttribute("WeatherRain") then 1 else 0
    local v32 = p13 / math.max(World.RainFade or 20, 0.1)

    v20 = if v20 < v30 then math.min(v30, v20 + v32) else math.max(v30, v20 - v32)

    local CFramePosition = CurrentCamera.CFrame.Position
    local elapsed = os.clock()

    if v20 > 0.001 and n1 <= elapsed then
        n1 = elapsed + 0.4
        v28 = castSolid(CFramePosition, (Vector3.new(0, World.IndoorCheck or 140, 0))) ~= nil

        local v36 = castSolid(CFramePosition + Vector3.new(0, 2, 0), (Vector3.new(0, -400, 0)))

        v29 = if v36 then v36.Position.Y else CFramePosition.Y - 10
    end

    Part.CFrame = CFrame.new(CFramePosition.X, CFramePosition.Y + (World.RainHeight or 95), CFramePosition.Z)
    Part2.CFrame = CFrame.new(CFramePosition.X, (v29 or CFramePosition.Y - 10) + 0.5, CFramePosition.Z)

    local Character = LocalPlayer.Character
    local v38 = Character and Character:GetAttribute("Sparring") ~= nil
    local v39 = 0

    if BoxingSettings.Get("Rain") ~= false and BoxingSettings.Get("LowGraphics") ~= true and not v28 then
        local v40 = v20

        v39 = v40 * (if v38 then World.FightRate or 0.4 else 1)
    end

    clone.Rate = (World.StreakRate or 260) * v39
    clone2.Rate = (World.SplashRate or 110) * v39

    local v41 = v20
    local v42 = v41 * (if v28 then World.RainIndoorVolume or 0.2 else World.RainVolume or 0.6)

    if not (v42 > 0.005) or Sound.SoundId == "" then
        if Sound.IsPlaying then
            Sound:Stop()
        end
    else
        if not Sound.IsPlaying then
            Sound:Play()
        end

        Sound.Volume = v42
    end
end

local n2 = (-1e999)
local UserInputService = game:GetService("UserInputService")

local function lookEvery() -- line: 222
    -- upvalues: BoxingSettings (copy), World (copy), UserInputService (copy)
    local v44 = BoxingSettings.Get("LowGraphics") == true or UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    return (math.max(World.UpdateEvery or 0.1, if v44 then 2 else 1))
end

RunService.RenderStepped:Connect(function(p14) -- line: 226
    -- upvalues: Lighting (copy), BoxingSettings (copy), World (copy), clockNow (copy), v20 (ref), applyLook (copy), CurrentCamera (ref), updateRain (copy), n2 (ref), UserInputService (copy)
    CurrentCamera = workspace.CurrentCamera
    updateRain((math.min(p14, 0.1)))

    local elapsed = os.clock()
    local v47 = elapsed - n2
    local v48 = BoxingSettings.Get("LowGraphics") == true or UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    if not (math.max(World.UpdateEvery or 0.1, if v48 then 2 else 1) <= v47) then
        return
    end

    n2 = elapsed

    local v51 = clockNow()

    Lighting.ClockTime = v51

    local v52 = World.Twilight or 1
    local v54 = math.clamp((v51 - (World.Sunrise - v52)) / (2 * v52), 0, 1)
    local v55 = v54 * v54 * (3 - 2 * v54)
    local v57 = math.clamp((v51 - (World.Sunset - v52)) / (2 * v52), 0, 1)

    applyLook(math.min(v55, 1 - v57 * v57 * (3 - 2 * v57)), v20)
end)


// ============================================
// END OF: WorldController (1).luau
// ============================================

// ============================================
// FILE: WorldController (2).luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\WorldController (2).luau
// SIZE: 12279 bytes
// ============================================
-- https://lua.expert

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Boxing = ReplicatedStorage:WaitForChild("Boxing")
local BoxingConfig = require(Boxing:WaitForChild("BoxingConfig"))
local BoxingSettings = require(Boxing:WaitForChild("BoxingSettings"))
local World = BoxingConfig.World
local LocalPlayer = Players.LocalPlayer

local function lerp(p1, p2, p3) -- line: 26
    return p1 + (p2 - p1) * p3
end

local function smooth(p4) -- line: 29
    local v1 = math.clamp(p4, 0, 1)

    return v1 * v1 * (3 - 2 * v1)
end

local v2 = World.DayMinutes * 60
local v3 = World.NightMinutes * 60
local v4 = World.Sunset - World.Sunrise
local v5 = 24 - v4

local function clockNow() -- line: 38
    -- upvalues: World (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy)
    local WorldCycleStart = workspace:GetAttribute("WorldCycleStart")

    if type(WorldCycleStart) ~= "number" then
        return World.StartClock or 12
    end

    local v6 = (workspace:GetServerTimeNow() - WorldCycleStart) % (v2 + v3)

    if v6 < v2 then
        return World.Sunrise + v6 / v2 * v4
    end

    return (World.Sunset + (v6 - v2) / v3 * v5) % 24
end

local function daylight(p5) -- line: 51
    -- upvalues: World (copy)
    local v7 = World.Twilight or 1
    local v9 = math.clamp((p5 - (World.Sunrise - v7)) / (2 * v7), 0, 1)
    local v10 = v9 * v9 * (3 - 2 * v9)
    local v12 = math.clamp((p5 - (World.Sunset - v7)) / (2 * v7), 0, 1)

    return (math.min(v10, 1 - v12 * v12 * (3 - 2 * v12)))
end

local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
local SunRaysEffect = Lighting:FindFirstChildOfClass("SunRaysEffect")
local Clouds = workspace.Terrain:FindFirstChildOfClass("Clouds")
local t1 = {
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
    EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
    AtmosphereColor = Atmosphere and Atmosphere.Color,
    AtmosphereDecay = Atmosphere and Atmosphere.Decay,
    AtmosphereDensity = Atmosphere and Atmosphere.Density,
    AtmosphereHaze = Atmosphere and Atmosphere.Haze,
    AtmosphereGlare = Atmosphere and Atmosphere.Glare,
    SunRays = SunRaysEffect and SunRaysEffect.Intensity,
    CloudCover = Clouds and Clouds.Cover,
    CloudDensity = Clouds and Clouds.Density,
    CloudColor = Clouds and Clouds.Color
}
local Night, Rain = World.Night, World.Rain
local v14 = Color3.fromRGB(128, 132, 140)
local v15 = Lighting:FindFirstChild("WorldGrade") or Instance.new("ColorCorrectionEffect")

v15.Name = "WorldGrade"
v15.Parent = Lighting

local function rainTarget() -- line: 87
    if workspace:GetAttribute("WeatherRain") then
        return 1
    end

    return 0
end

local WeatherSince = workspace:GetAttribute("WeatherSince")
local v19 = math.clamp((if type(WeatherSince) == "number" then workspace:GetServerTimeNow() - WeatherSince else 1e999) / math.max(World.RainFade or 20, 0.1), 0, 1)
local v20 = if (if workspace:GetAttribute("WeatherRain") then 1 else 0) == 1 then v19 else 1 - v19

local function applyLook(p6, p7) -- line: 97
    -- upvalues: Lighting (copy), Atmosphere (copy), SunRaysEffect (copy), Clouds (copy), t1 (copy), Night (copy), Rain (copy), v14 (copy), v15 (copy)
    local v21 = 1 - p6
    local Brightness = t1.Brightness

    Lighting.Brightness = (Brightness + (Night.Brightness - Brightness) * v21) * (1 + (Rain.Brightness - 1) * p7)

    local v22 = t1.Ambient:Lerp(Night.Ambient, v21)
    local v23 = t1.OutdoorAmbient:Lerp(Night.OutdoorAmbient, v21)

    Lighting.Ambient = v22:Lerp(v14:Lerp(v22, 0.5), p7 * Rain.AmbientGrey * 2)
    Lighting.OutdoorAmbient = v23:Lerp(v14:Lerp(v23, 0.5), p7 * Rain.AmbientGrey * 2)

    local EnvironmentDiffuseScale = t1.EnvironmentDiffuseScale

    Lighting.EnvironmentDiffuseScale = EnvironmentDiffuseScale + (Night.EnvironmentDiffuseScale - EnvironmentDiffuseScale) * v21

    local EnvironmentSpecularScale = t1.EnvironmentSpecularScale

    Lighting.EnvironmentSpecularScale = EnvironmentSpecularScale + (Night.EnvironmentSpecularScale - EnvironmentSpecularScale) * v21

    if Atmosphere then
        Atmosphere.Color = t1.AtmosphereColor:Lerp(Night.AtmosphereColor, v21):Lerp(Rain.AtmosphereColor:Lerp(Night.AtmosphereColor, v21 * 0.7), p7 * 0.6)
        Atmosphere.Decay = t1.AtmosphereDecay:Lerp(Night.AtmosphereDecay, v21)

        local AtmosphereDensity = t1.AtmosphereDensity

        Atmosphere.Density = AtmosphereDensity + (Night.AtmosphereDensity - AtmosphereDensity) * v21 + Rain.AtmosphereDensity * p7

        local AtmosphereHaze = t1.AtmosphereHaze

        Atmosphere.Haze = AtmosphereHaze + (Night.AtmosphereHaze - AtmosphereHaze) * v21 + Rain.AtmosphereHaze * p7

        local AtmosphereGlare = t1.AtmosphereGlare

        Atmosphere.Glare = (AtmosphereGlare + (Night.AtmosphereGlare - AtmosphereGlare) * v21) * (1 - p7)
    end

    if SunRaysEffect then
        local SunRays = t1.SunRays

        SunRaysEffect.Intensity = (SunRays + (Night.SunRays - SunRays) * v21) * (1 - p7)
    end

    if Clouds then
        local CloudCover = t1.CloudCover

        Clouds.Cover = CloudCover + (Rain.CloudCover - CloudCover) * p7

        local CloudDensity = t1.CloudDensity

        Clouds.Density = CloudDensity + (Rain.CloudDensity - CloudDensity) * p7
        Clouds.Color = t1.CloudColor:Lerp(Night.CloudColor, v21):Lerp(Rain.CloudColor:Lerp(Night.CloudColor, v21), p7)
    end

    v15.TintColor = Color3.new(1, 1, 1):Lerp(Night.Tint, v21)
    v15.Saturation = Night.Saturation * v21 + Rain.Saturation * p7
    v15.Brightness = Rain.BrightnessShift * p7
end

local CurrentCamera = workspace.CurrentCamera
local RainAsset = Boxing:WaitForChild("RainAsset")
local Folder = Instance.new("Folder")

Folder.Name = "WorldRain"

local function rainPart(p8, p9) -- line: 132
    -- upvalues: Folder (copy)
    local Part = Instance.new("Part")

    Part.Name = p8
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(200, p9, 200)
    Part.Parent = Folder

    return Part
end

local Part = Instance.new("Part")

Part.Name = "RainSky"
Part.Anchored = true
Part.CanCollide = false
Part.CanQuery = false
Part.CanTouch = false
Part.CastShadow = false
Part.Transparency = 1
Part.Size = Vector3.new(200, 3.5, 200)
Part.Parent = Folder

local Part2 = Instance.new("Part")

Part2.Name = "RainFloor"
Part2.Anchored = true
Part2.CanCollide = false
Part2.CanQuery = false
Part2.CanTouch = false
Part2.CastShadow = false
Part2.Transparency = 1
Part2.Size = Vector3.new(200, 1, 200)
Part2.Parent = Folder

local clone = RainAsset:WaitForChild("Streaks"):Clone()

clone.Parent = Part

local clone2 = RainAsset:WaitForChild("Splashes"):Clone()

clone2.Parent = Part2
clone.Rate = 0
clone2.Rate = 0
clone.Enabled = true
clone2.Enabled = true
Folder.Parent = workspace

local Sound = Instance.new("Sound")

Sound.Name = "WorldRainSound"
Sound.Looped = true
Sound.Volume = 0
Sound.SoundId = World.RainSound or ""
Sound.SoundGroup = SoundService:FindFirstChild("BoxingMaster")
Sound.Parent = SoundService

local v25 = RaycastParams.new()

v25.FilterType = Enum.RaycastFilterType.Exclude
v25.IgnoreWater = true

local function solid(p10) -- line: 162
    local Terrain = p10:IsA("Terrain")

    if not Terrain then
        Terrain = p10:IsA("BasePart")

        if Terrain then
            Terrain = p10.Transparency < 0.9 and p10.Material ~= Enum.Material.Glass and p10.Material ~= Enum.Material.ForceField
        end
    end

    return Terrain
end

local function castSolid(p11, p12) -- line: 167
    -- upvalues: Players (copy), Folder (copy), v25 (copy)
    local t2 = {
        Folder
    }

    for _, player in Players:GetPlayers() do
        if player.Character then
            table.insert(t2, player.Character)
        end
    end

    for _ = 1, 8 do
        v25.FilterDescendantsInstances = t2

        local v26 = workspace:Raycast(p11, p12, v25)
        local v27 = false

        if v26 then
            local Instance = v26.Instance
            local Terrain = Instance:IsA("Terrain")

            if not Terrain then
                Terrain = Instance:IsA("BasePart")

                if Terrain then
                    Terrain = Instance.Transparency < 0.9 and Instance.Material ~= Enum.Material.Glass and Instance.Material ~= Enum.Material.ForceField
                end
            end

            v27 = not Terrain
        end

        if not v27 then
            return v26
        end

        table.insert(t2, v26.Instance)
    end

    return nil
end

local v28 = false
local n1 = 0
local v29

local function updateRain(p13) -- line: 186
    -- upvalues: BoxingSettings (copy), World (copy), LocalPlayer (copy), v20 (ref), CurrentCamera (ref), Part (copy), Part2 (copy), clone (copy), clone2 (copy), Sound (copy), castSolid (copy), v28 (ref), n1 (ref), v29 (ref)
    local v30 = if workspace:GetAttribute("WeatherRain") then 1 else 0
    local v32 = p13 / math.max(World.RainFade or 20, 0.1)

    v20 = if v20 < v30 then math.min(v30, v20 + v32) else math.max(v30, v20 - v32)

    local CFramePosition = CurrentCamera.CFrame.Position
    local elapsed = os.clock()

    if v20 > 0.001 and n1 <= elapsed then
        n1 = elapsed + 0.4
        v28 = castSolid(CFramePosition, (Vector3.new(0, World.IndoorCheck or 140, 0))) ~= nil

        local v36 = castSolid(CFramePosition + Vector3.new(0, 2, 0), (Vector3.new(0, -400, 0)))

        v29 = if v36 then v36.Position.Y else CFramePosition.Y - 10
    end

    Part.CFrame = CFrame.new(CFramePosition.X, CFramePosition.Y + (World.RainHeight or 95), CFramePosition.Z)
    Part2.CFrame = CFrame.new(CFramePosition.X, (v29 or CFramePosition.Y - 10) + 0.5, CFramePosition.Z)

    local Character = LocalPlayer.Character
    local v38 = Character and Character:GetAttribute("Sparring") ~= nil
    local v39 = 0

    if BoxingSettings.Get("Rain") ~= false and BoxingSettings.Get("LowGraphics") ~= true and not v28 then
        local v40 = v20

        v39 = v40 * (if v38 then World.FightRate or 0.4 else 1)
    end

    clone.Rate = (World.StreakRate or 260) * v39
    clone2.Rate = (World.SplashRate or 110) * v39

    local v41 = v20
    local v42 = v41 * (if v28 then World.RainIndoorVolume or 0.2 else World.RainVolume or 0.6)

    if not (v42 > 0.005) or Sound.SoundId == "" then
        if Sound.IsPlaying then
            Sound:Stop()
        end
    else
        if not Sound.IsPlaying then
            Sound:Play()
        end

        Sound.Volume = v42
    end
end

local n2 = (-1e999)
local UserInputService = game:GetService("UserInputService")

local function lookEvery() -- line: 222
    -- upvalues: BoxingSettings (copy), World (copy), UserInputService (copy)
    local v44 = BoxingSettings.Get("LowGraphics") == true or UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    return (math.max(World.UpdateEvery or 0.1, if v44 then 2 else 1))
end

RunService.RenderStepped:Connect(function(p14) -- line: 226
    -- upvalues: Lighting (copy), BoxingSettings (copy), World (copy), clockNow (copy), v20 (ref), applyLook (copy), CurrentCamera (ref), updateRain (copy), n2 (ref), UserInputService (copy)
    CurrentCamera = workspace.CurrentCamera
    updateRain((math.min(p14, 0.1)))

    local elapsed = os.clock()
    local v47 = elapsed - n2
    local v48 = BoxingSettings.Get("LowGraphics") == true or UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    if not (math.max(World.UpdateEvery or 0.1, if v48 then 2 else 1) <= v47) then
        return
    end

    n2 = elapsed

    local v51 = clockNow()

    Lighting.ClockTime = v51

    local v52 = World.Twilight or 1
    local v54 = math.clamp((v51 - (World.Sunrise - v52)) / (2 * v52), 0, 1)
    local v55 = v54 * v54 * (3 - 2 * v54)
    local v57 = math.clamp((v51 - (World.Sunset - v52)) / (2 * v52), 0, 1)

    applyLook(math.min(v55, 1 - v57 * v57 * (3 - 2 * v57)), v20)
end)


// ============================================
// END OF: WorldController (2).luau
// ============================================

// ============================================
// FILE: WorldController.luau
// PATH: C:\Users\h\Downloads\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\scripts-Hajime-Rising-ALPHA-suspendedinwater-20261101T155746Z\WorldController.luau
// SIZE: 12279 bytes
// ============================================
-- https://lua.expert

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Boxing = ReplicatedStorage:WaitForChild("Boxing")
local BoxingConfig = require(Boxing:WaitForChild("BoxingConfig"))
local BoxingSettings = require(Boxing:WaitForChild("BoxingSettings"))
local World = BoxingConfig.World
local LocalPlayer = Players.LocalPlayer

local function lerp(p1, p2, p3) -- line: 26
    return p1 + (p2 - p1) * p3
end

local function smooth(p4) -- line: 29
    local v1 = math.clamp(p4, 0, 1)

    return v1 * v1 * (3 - 2 * v1)
end

local v2 = World.DayMinutes * 60
local v3 = World.NightMinutes * 60
local v4 = World.Sunset - World.Sunrise
local v5 = 24 - v4

local function clockNow() -- line: 38
    -- upvalues: World (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy)
    local WorldCycleStart = workspace:GetAttribute("WorldCycleStart")

    if type(WorldCycleStart) ~= "number" then
        return World.StartClock or 12
    end

    local v6 = (workspace:GetServerTimeNow() - WorldCycleStart) % (v2 + v3)

    if v6 < v2 then
        return World.Sunrise + v6 / v2 * v4
    end

    return (World.Sunset + (v6 - v2) / v3 * v5) % 24
end

local function daylight(p5) -- line: 51
    -- upvalues: World (copy)
    local v7 = World.Twilight or 1
    local v9 = math.clamp((p5 - (World.Sunrise - v7)) / (2 * v7), 0, 1)
    local v10 = v9 * v9 * (3 - 2 * v9)
    local v12 = math.clamp((p5 - (World.Sunset - v7)) / (2 * v7), 0, 1)

    return (math.min(v10, 1 - v12 * v12 * (3 - 2 * v12)))
end

local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
local SunRaysEffect = Lighting:FindFirstChildOfClass("SunRaysEffect")
local Clouds = workspace.Terrain:FindFirstChildOfClass("Clouds")
local t1 = {
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
    EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
    AtmosphereColor = Atmosphere and Atmosphere.Color,
    AtmosphereDecay = Atmosphere and Atmosphere.Decay,
    AtmosphereDensity = Atmosphere and Atmosphere.Density,
    AtmosphereHaze = Atmosphere and Atmosphere.Haze,
    AtmosphereGlare = Atmosphere and Atmosphere.Glare,
    SunRays = SunRaysEffect and SunRaysEffect.Intensity,
    CloudCover = Clouds and Clouds.Cover,
    CloudDensity = Clouds and Clouds.Density,
    CloudColor = Clouds and Clouds.Color
}
local Night, Rain = World.Night, World.Rain
local v14 = Color3.fromRGB(128, 132, 140)
local v15 = Lighting:FindFirstChild("WorldGrade") or Instance.new("ColorCorrectionEffect")

v15.Name = "WorldGrade"
v15.Parent = Lighting

local function rainTarget() -- line: 87
    if workspace:GetAttribute("WeatherRain") then
        return 1
    end

    return 0
end

local WeatherSince = workspace:GetAttribute("WeatherSince")
local v19 = math.clamp((if type(WeatherSince) == "number" then workspace:GetServerTimeNow() - WeatherSince else 1e999) / math.max(World.RainFade or 20, 0.1), 0, 1)
local v20 = if (if workspace:GetAttribute("WeatherRain") then 1 else 0) == 1 then v19 else 1 - v19

local function applyLook(p6, p7) -- line: 97
    -- upvalues: Lighting (copy), Atmosphere (copy), SunRaysEffect (copy), Clouds (copy), t1 (copy), Night (copy), Rain (copy), v14 (copy), v15 (copy)
    local v21 = 1 - p6
    local Brightness = t1.Brightness

    Lighting.Brightness = (Brightness + (Night.Brightness - Brightness) * v21) * (1 + (Rain.Brightness - 1) * p7)

    local v22 = t1.Ambient:Lerp(Night.Ambient, v21)
    local v23 = t1.OutdoorAmbient:Lerp(Night.OutdoorAmbient, v21)

    Lighting.Ambient = v22:Lerp(v14:Lerp(v22, 0.5), p7 * Rain.AmbientGrey * 2)
    Lighting.OutdoorAmbient = v23:Lerp(v14:Lerp(v23, 0.5), p7 * Rain.AmbientGrey * 2)

    local EnvironmentDiffuseScale = t1.EnvironmentDiffuseScale

    Lighting.EnvironmentDiffuseScale = EnvironmentDiffuseScale + (Night.EnvironmentDiffuseScale - EnvironmentDiffuseScale) * v21

    local EnvironmentSpecularScale = t1.EnvironmentSpecularScale

    Lighting.EnvironmentSpecularScale = EnvironmentSpecularScale + (Night.EnvironmentSpecularScale - EnvironmentSpecularScale) * v21

    if Atmosphere then
        Atmosphere.Color = t1.AtmosphereColor:Lerp(Night.AtmosphereColor, v21):Lerp(Rain.AtmosphereColor:Lerp(Night.AtmosphereColor, v21 * 0.7), p7 * 0.6)
        Atmosphere.Decay = t1.AtmosphereDecay:Lerp(Night.AtmosphereDecay, v21)

        local AtmosphereDensity = t1.AtmosphereDensity

        Atmosphere.Density = AtmosphereDensity + (Night.AtmosphereDensity - AtmosphereDensity) * v21 + Rain.AtmosphereDensity * p7

        local AtmosphereHaze = t1.AtmosphereHaze

        Atmosphere.Haze = AtmosphereHaze + (Night.AtmosphereHaze - AtmosphereHaze) * v21 + Rain.AtmosphereHaze * p7

        local AtmosphereGlare = t1.AtmosphereGlare

        Atmosphere.Glare = (AtmosphereGlare + (Night.AtmosphereGlare - AtmosphereGlare) * v21) * (1 - p7)
    end

    if SunRaysEffect then
        local SunRays = t1.SunRays

        SunRaysEffect.Intensity = (SunRays + (Night.SunRays - SunRays) * v21) * (1 - p7)
    end

    if Clouds then
        local CloudCover = t1.CloudCover

        Clouds.Cover = CloudCover + (Rain.CloudCover - CloudCover) * p7

        local CloudDensity = t1.CloudDensity

        Clouds.Density = CloudDensity + (Rain.CloudDensity - CloudDensity) * p7
        Clouds.Color = t1.CloudColor:Lerp(Night.CloudColor, v21):Lerp(Rain.CloudColor:Lerp(Night.CloudColor, v21), p7)
    end

    v15.TintColor = Color3.new(1, 1, 1):Lerp(Night.Tint, v21)
    v15.Saturation = Night.Saturation * v21 + Rain.Saturation * p7
    v15.Brightness = Rain.BrightnessShift * p7
end

local CurrentCamera = workspace.CurrentCamera
local RainAsset = Boxing:WaitForChild("RainAsset")
local Folder = Instance.new("Folder")

Folder.Name = "WorldRain"

local function rainPart(p8, p9) -- line: 132
    -- upvalues: Folder (copy)
    local Part = Instance.new("Part")

    Part.Name = p8
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Size = Vector3.new(200, p9, 200)
    Part.Parent = Folder

    return Part
end

local Part = Instance.new("Part")

Part.Name = "RainSky"
Part.Anchored = true
Part.CanCollide = false
Part.CanQuery = false
Part.CanTouch = false
Part.CastShadow = false
Part.Transparency = 1
Part.Size = Vector3.new(200, 3.5, 200)
Part.Parent = Folder

local Part2 = Instance.new("Part")

Part2.Name = "RainFloor"
Part2.Anchored = true
Part2.CanCollide = false
Part2.CanQuery = false
Part2.CanTouch = false
Part2.CastShadow = false
Part2.Transparency = 1
Part2.Size = Vector3.new(200, 1, 200)
Part2.Parent = Folder

local clone = RainAsset:WaitForChild("Streaks"):Clone()

clone.Parent = Part

local clone2 = RainAsset:WaitForChild("Splashes"):Clone()

clone2.Parent = Part2
clone.Rate = 0
clone2.Rate = 0
clone.Enabled = true
clone2.Enabled = true
Folder.Parent = workspace

local Sound = Instance.new("Sound")

Sound.Name = "WorldRainSound"
Sound.Looped = true
Sound.Volume = 0
Sound.SoundId = World.RainSound or ""
Sound.SoundGroup = SoundService:FindFirstChild("BoxingMaster")
Sound.Parent = SoundService

local v25 = RaycastParams.new()

v25.FilterType = Enum.RaycastFilterType.Exclude
v25.IgnoreWater = true

local function solid(p10) -- line: 162
    local Terrain = p10:IsA("Terrain")

    if not Terrain then
        Terrain = p10:IsA("BasePart")

        if Terrain then
            Terrain = p10.Transparency < 0.9 and p10.Material ~= Enum.Material.Glass and p10.Material ~= Enum.Material.ForceField
        end
    end

    return Terrain
end

local function castSolid(p11, p12) -- line: 167
    -- upvalues: Players (copy), Folder (copy), v25 (copy)
    local t2 = {
        Folder
    }

    for _, player in Players:GetPlayers() do
        if player.Character then
            table.insert(t2, player.Character)
        end
    end

    for _ = 1, 8 do
        v25.FilterDescendantsInstances = t2

        local v26 = workspace:Raycast(p11, p12, v25)
        local v27 = false

        if v26 then
            local Instance = v26.Instance
            local Terrain = Instance:IsA("Terrain")

            if not Terrain then
                Terrain = Instance:IsA("BasePart")

                if Terrain then
                    Terrain = Instance.Transparency < 0.9 and Instance.Material ~= Enum.Material.Glass and Instance.Material ~= Enum.Material.ForceField
                end
            end

            v27 = not Terrain
        end

        if not v27 then
            return v26
        end

        table.insert(t2, v26.Instance)
    end

    return nil
end

local v28 = false
local n1 = 0
local v29

local function updateRain(p13) -- line: 186
    -- upvalues: BoxingSettings (copy), World (copy), LocalPlayer (copy), v20 (ref), CurrentCamera (ref), Part (copy), Part2 (copy), clone (copy), clone2 (copy), Sound (copy), castSolid (copy), v28 (ref), n1 (ref), v29 (ref)
    local v30 = if workspace:GetAttribute("WeatherRain") then 1 else 0
    local v32 = p13 / math.max(World.RainFade or 20, 0.1)

    v20 = if v20 < v30 then math.min(v30, v20 + v32) else math.max(v30, v20 - v32)

    local CFramePosition = CurrentCamera.CFrame.Position
    local elapsed = os.clock()

    if v20 > 0.001 and n1 <= elapsed then
        n1 = elapsed + 0.4
        v28 = castSolid(CFramePosition, (Vector3.new(0, World.IndoorCheck or 140, 0))) ~= nil

        local v36 = castSolid(CFramePosition + Vector3.new(0, 2, 0), (Vector3.new(0, -400, 0)))

        v29 = if v36 then v36.Position.Y else CFramePosition.Y - 10
    end

    Part.CFrame = CFrame.new(CFramePosition.X, CFramePosition.Y + (World.RainHeight or 95), CFramePosition.Z)
    Part2.CFrame = CFrame.new(CFramePosition.X, (v29 or CFramePosition.Y - 10) + 0.5, CFramePosition.Z)

    local Character = LocalPlayer.Character
    local v38 = Character and Character:GetAttribute("Sparring") ~= nil
    local v39 = 0

    if BoxingSettings.Get("Rain") ~= false and BoxingSettings.Get("LowGraphics") ~= true and not v28 then
        local v40 = v20

        v39 = v40 * (if v38 then World.FightRate or 0.4 else 1)
    end

    clone.Rate = (World.StreakRate or 260) * v39
    clone2.Rate = (World.SplashRate or 110) * v39

    local v41 = v20
    local v42 = v41 * (if v28 then World.RainIndoorVolume or 0.2 else World.RainVolume or 0.6)

    if not (v42 > 0.005) or Sound.SoundId == "" then
        if Sound.IsPlaying then
            Sound:Stop()
        end
    else
        if not Sound.IsPlaying then
            Sound:Play()
        end

        Sound.Volume = v42
    end
end

local n2 = (-1e999)
local UserInputService = game:GetService("UserInputService")

local function lookEvery() -- line: 222
    -- upvalues: BoxingSettings (copy), World (copy), UserInputService (copy)
    local v44 = BoxingSettings.Get("LowGraphics") == true or UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    return (math.max(World.UpdateEvery or 0.1, if v44 then 2 else 1))
end

RunService.RenderStepped:Connect(function(p14) -- line: 226
    -- upvalues: Lighting (copy), BoxingSettings (copy), World (copy), clockNow (copy), v20 (ref), applyLook (copy), CurrentCamera (ref), updateRain (copy), n2 (ref), UserInputService (copy)
    CurrentCamera = workspace.CurrentCamera
    updateRain((math.min(p14, 0.1)))

    local elapsed = os.clock()
    local v47 = elapsed - n2
    local v48 = BoxingSettings.Get("LowGraphics") == true or UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    if not (math.max(World.UpdateEvery or 0.1, if v48 then 2 else 1) <= v47) then
        return
    end

    n2 = elapsed

    local v51 = clockNow()

    Lighting.ClockTime = v51

    local v52 = World.Twilight or 1
    local v54 = math.clamp((v51 - (World.Sunrise - v52)) / (2 * v52), 0, 1)
    local v55 = v54 * v54 * (3 - 2 * v54)
    local v57 = math.clamp((v51 - (World.Sunset - v52)) / (2 * v52), 0, 1)

    applyLook(math.min(v55, 1 - v57 * v57 * (3 - 2 * v57)), v20)
end)


// ============================================
// END OF: WorldController.luau
// ============================================

