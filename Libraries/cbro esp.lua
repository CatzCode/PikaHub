local lplr = game.Players.LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local CurrentCamera = workspace.CurrentCamera
local worldToViewportPoint = CurrentCamera.worldToViewportPoint
local mouse = game.Players.LocalPlayer:GetMouse()
local UserInput = game:GetService("UserInputService")

getgenv().PikaESPSettings = {
    Box = false,
    Name = false,
    Tracers = false
}

local function PikaESP(v)
    local BoxOutline = Drawing.new("Square")
    BoxOutline.Visible = false
    BoxOutline.Color = Color3.new(0,0,0)
    BoxOutline.Thickness = 3
    BoxOutline.Transparency = 1
    BoxOutline.Filled = false

    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.new(1,1,1)
    Box.Thickness = 1
    Box.Transparency = 1
    Box.Filled = false

    local HealthBarOutline = Drawing.new("Square")
    HealthBarOutline.Thickness = 3
    HealthBarOutline.Filled = false
    HealthBarOutline.Color = Color3.new(0,0,0)
    HealthBarOutline.Transparency = 1
    HealthBarOutline.Visible = false

    local HealthBar = Drawing.new("Square")
    HealthBar.Thickness = 1
    HealthBar.Filled = false
    HealthBar.Transparency = 1
    HealthBar.Visible = false
    
    local Tracer = Drawing.new("Line")
    Tracer.Visible = false
    Tracer.Color = Color3.new(1,1,1)
    Tracer.Thickness = 1
    Tracer.Transparency = 1
    
    local Name = Drawing.new("Text")
    Name.Transparency = 1
    Name.Visible = false
    Name.Color = Color3.new(1,1,1)
    Name.Size = 12
    Name.Center = true
    Name.Outline = true
    Name.Font = 2

    local Gun = Drawing.new("Text")
    Gun.Transparency = 1
    Gun.Visible = false
    Gun.Color = Color3.new(1,1,1)
    Gun.Size = 12
    Gun.Center = true
    Gun.Outline = true
    Gun.Font = 2

    game:GetService("RunService").RenderStepped:Connect(function()
        if v.Character ~= nil and v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v ~= lplr and v.Character.Humanoid.Health > 0 then
            local Vector, onScreen = camera:worldToViewportPoint(v.Character.HumanoidRootPart.Position)
            local Distance = (CurrentCamera.CFrame.p - v.Character.HumanoidRootPart.Position).Magnitude
            local RootPart = v.Character.HumanoidRootPart
            local Head = v.Character.Head
            local RootPosition, RootVis = worldToViewportPoint(CurrentCamera, RootPart.Position)
            local HeadPosition = worldToViewportPoint(CurrentCamera, Head.Position + Vector3.new(0,0.5,0))
            local LegPosition = worldToViewportPoint(CurrentCamera, RootPart.Position - Vector3.new(0,3,0))

            if onScreen then
                if PikaESPSettings.Box then
                    BoxOutline.Size = Vector2.new(2500 / RootPosition.Z, HeadPosition.Y - LegPosition.Y)
                    BoxOutline.Position = Vector2.new(RootPosition.X - BoxOutline.Size.X / 2, RootPosition.Y - BoxOutline.Size.Y / 2)
                    BoxOutline.Visible = true
    
                    Box.Size = Vector2.new(2500 / RootPosition.Z, HeadPosition.Y - LegPosition.Y)
                    Box.Position = Vector2.new(RootPosition.X - Box.Size.X / 2, RootPosition.Y - Box.Size.Y / 2)
                    Box.Visible = true
                        
                    HealthBarOutline.Size = Vector2.new(2, HeadPosition.Y - LegPosition.Y)
                    HealthBarOutline.Position = BoxOutline.Position - Vector2.new(6,0)
                    HealthBarOutline.Visible = true
    
                    HealthBar.Size = Vector2.new(2, (HeadPosition.Y - LegPosition.Y) / (v.Character.Humanoid.MaxHealth / math.clamp(v.Character.Humanoid.Health, 0,v.Character.Humanoid.MaxHealth)))
                    HealthBar.Position = Vector2.new(Box.Position.X - 6, Box.Position.Y + (1 / HealthBar.Size.Y))
                    HealthBar.Color = Color3.fromRGB(255 - 255 / (v.Character.Humanoid.MaxHealth / v.Character.Humanoid.Health), 255 / (v.Character.Humanoid.MaxHealth / v.Character.Humanoid.Health), 0)
                    HealthBar.Visible = true
                        
                    if v.TeamColor == lplr.TeamColor then
                        HealthBarOutline.Visible = false
                        BoxOutline.Visible = false
                        Box.Visible = false
                        HealthBar.Visible = false
                    end
                else
                    BoxOutline.Visible = false
                    Box.Visible = false
                    HealthBarOutline.Visible = false
                    HealthBar.Visible = false
                end
                if PikaESPSettings.Tracers then
                    Tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 1)
                    Tracer.To = Vector2.new(Vector.X, Vector.Y)
                    Tracer.Visible = true
                        
                    if v.TeamColor == lplr.TeamColor then
                        Tracer.Visible = false
                    end
                else
                    Tracer.Visible = false
                end
                if PikaESPSettings.Name then
                    Name.Text = tostring(v.Name)
                    Name.Position = Vector2.new(workspace.Camera:WorldToViewportPoint(v.Character.Head.Position).X, workspace.Camera:WorldToViewportPoint(v.Character.Head.Position).Y - 30)
                    Name.Visible = true

                    Gun.Text = tostring(v.Character.EquippedTool.Value)
                    Gun.Position = Vector2.new(LegPosition.X, LegPosition.Y + 10)
                    Gun.Visible = true
                        
                    if v.TeamColor == lplr.TeamColor then
                        Name.Visible = false
                        Gun.Visible = false
                    end
                else
                    Name.Visible = false
                end
            else
                BoxOutline.Visible = false
                Box.Visible = false
                HealthBarOutline.Visible = false
                HealthBar.Visible = false
                Tracer.Visible = false
                Name.Visible = false
                Gun.Visible = false
            end
        else
            BoxOutline.Visible = false
            Box.Visible = false
            HealthBarOutline.Visible = false
            HealthBar.Visible = false
            Tracer.Visible = false
            Name.Visible = false
            Gun.Visible = false
        end
    end)
end

for i,v in pairs(game.Players:GetChildren()) do
    PikaESP(v)
end

game.Players.PlayerAdded:Connect(function(v)
    PikaESP(v)
end)
