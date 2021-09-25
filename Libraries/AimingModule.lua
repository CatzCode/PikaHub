-- Global --

getgenv().AimingModule = {
    AimAssist = false,
    Smoothing = 1,
    Aiming = false,
    SilentAim = true,
    VisibleCheck = true,
    ShowFOV = true,
    FOVFilled = false,
    FOVSize = 100,
    FOVRound = 50,
    FOVColor = Color3.fromRGB(98, 32, 193),
    FOVTransparency = 0.5
}

-- Variables --

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalP = Players.LocalPlayer
local Mouse = LocalP:GetMouse()
local RS = game:GetService("RunService")
local currentCamera = game:GetService("Workspace").CurrentCamera
local UserInput = game:GetService("UserInputService")
local worldToViewportPoint = currentCamera.worldToViewportPoint
local Lighting = game:GetService("Lighting")
local StoredMag = nil

function m_nearest(x, y)
    local target = nil
    local dist = math.huge

    for i, v in pairs(Players:GetPlayers()) do
        if v.Name ~= LocalP.Name then
            if IsAlive(v) then
                local screen = currentCamera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                local mousedist = (Vector2.new(x, y) - Vector2.new(screen.X, screen.Y)).magnitude

                if mousedist < dist then
                    target = v
                    dist = mousedist
                    storedmagnitude = mousedist
                end
            end
        end
    end

    return target
end

function IsAlive(Target)
    if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") ~= nil and Target.Character:FindFirstChild("Head") ~= nil and Target.Character:FindFirstChild("Humanoid") ~= nil and Target.Character.Humanoid.Health > 0 then
        return true
    end
    return false
end

function IsVisible(Position, Ignores)
    return #currentCamera:GetPartsObscuringTarget({LocalP.Character.Head.Position, Position}, Ignores) == 0 and true or false
end

function DoCheck(Target)
    if IsAlive(Target) then
        local Character = Target.Character
        local KOd = Character:WaitForChild("BodyEffects")["K.O"].Value
        local Grabbed = Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil

        if (KOd and Grabbed) then
            return false
        end

        return true
    end
end

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Radius = 400
FOVCircle.NumSides = 12
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Visible = false
FOVCircle.Transparency = 0.5

RS.Heartbeat:Connect(function()
    if AimingModule.AimAssist and AimingModule.Aiming then
        local m_n = m_nearest(Mouse.X, Mouse.Y)
        if (not AimingModule.VisCheck or IsVisible(m_n.Character.Head.Position, {m_n.Character, LocalP.Character, currentCamera}) == true) and storedmagnitude ~= nil and (not AimingModule.ShowFOV or AimingModule.FOVSize > StoredMag) then
            local pos = currentCamera:WorldToScreenPoint(m_n.Character.Head.Position)
            local vis = currentCamera:WorldToScreenPoint(m_n.Character.Head.Position)
            local mouseloc = currentCamera:WorldToScreenPoint(Mouse.Hit.p)
            local endpos = Vector2.new((pos.X - mouseloc.X) / AimingModule.Smoothing, (pos.Y - mouseloc.Y) / AimingModule.Smoothing)
            if vis then
                mousemoverel(endpos.X, endpos.Y)
            end
        end
    end
    if AimingModule.ShowFOV then
        FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
        FOVCircle.Thickness = 2
        FOVCircle.NumSides = AimingModule.FOVRound
        FOVCircle.Radius = AimingModule.FOVSize
        FOVCircle.Color = AimingModule.FOVColor
        FOVCircle.Filled = AimingModule.FOVFilled
        FOVCircle.Transparency = AimingModule.FOVTransparency
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end
end)

local __index2 = nil
__index2 = hookmetamethod(game, "__index", function(t, k)
    if t == Mouse and tostring(k) == "Hit" then
        local m_n = m_nearest(Mouse.X, Mouse.Y)
        if DoCheck(m_n) and (not AimingModule.VisCheck or IsVisible(m_n.Character.Head.Position, {m_n.Character, LocalP.Character, currentCamera}) == true) and AimingModule.SilentAim and StoredMag ~= nil and (not AimingModule.ShowFOV or AimingModule.FOVSize > StoredMag) then
            local tpart = m_n.Character.Head
            local tHit = tpart.CFrame + (tpart.Velocity * 0.165)
            return (k == "Hit" and tHit or tpart)
        end
    end

    return __index2(t, k)
end)
