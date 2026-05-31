print([[  
 __      __   _     _    __  __                  
 \ \    / /  (_)   | |  |  \/  |                 
  \ \  / /__  _  __| |  | \  / | ___ _ __  _   _ 
   \ \/ / _ \| |/ _` |  | |\/| |/ _ \ '_ \| | | |
    \  / (_) | | (_| |  | |  | |  __/ | | | |_| |
     \/ \___/|_|\__,_|  |_|  |_|\___|_| |_|\__,_|
                Made by Void Menu                          
]])

local function autoJoinDiscord()
    local success = pcall(function()
        if request then
            request({
                Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Origin"] = "https://discord.com"
                },
                Body = game:GetService("HttpService"):JSONEncode({
                    cmd = "INVITE_BROWSER",
                    args = {
                        code = "zDPUfasy3U"
                    },
                    nonce = tostring(math.random(1, 1000000))
                })
            })
        end
    end)
    
    if not success then
        setclipboard("https://discord.gg/zDPUfasy3U")
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Void Menu Discord";
            Text = "Discord invite copied! Paste it in your browser.";
            Duration = 5;
        })
    end
end

autoJoinDiscord()

local OrionLib = loadstring(game:HttpGet("https://void.eldarx.site/Void.Ui"))()

local Window = OrionLib:MakeWindow({
    Name = "Void Menu - Emergency Hamburg",
    SaveConfig = {
        Enabled = true,
        FolderName = "Void Menu",
        FileName = "EmergencyHamburg"
    }
})

Window:TabSection("Home")

local HomeTab = Window:MakeTab({ 
    Name = "Home", 
    Icon = "rbxassetid://73538445886439",
    PremiumOnly = false 
})

Window:TabSection("Combat")

local AimbotTab = Window:MakeTab({ 
    Name = "Aimbot", 
    Icon = "rbxassetid://98232288704820", 
    PremiumOnly = false 
})

Window:TabSection("Visuals")

local VisualsTab = Window:MakeTab({ 
    Name = "Visuals", 
    Icon = "rbxassetid://132069634751309",
    PremiumOnly = false 
})

local GraphicTab = Window:MakeTab({ 
    Name = "Graphics", 
    Icon = "rbxassetid://125373696632586",
    PremiumOnly = false 
})

Window:TabSection("Player")

local PlayerTab = Window:MakeTab({ 
    Name = "Player", 
    Icon = "rbxassetid://117259180607823",
    PremiumOnly = false 
})

local TrollingTab = Window:MakeTab({ 
    Name = "Trolling", 
    Icon = "rbxassetid://140097947197695", 
    PremiumOnly = false 
})

local AnimationTab = Window:MakeTab({
    Name = "Animation",
    Icon = "rbxassetid://107735713113844",
    PremiumOnly = false
})

Window:TabSection("Modification")

local VehicleTab = Window:MakeTab({ 
    Name = "Vehicle Mods", 
    Icon = "rbxassetid://9033642906", 
    PremiumOnly = false 
})

local WeaponTab = Window:MakeTab({ 
    Name = "Weapon Mods", 
    Icon = "rbxassetid://80964454894155",
    PremiumOnly = false 
})

local PoliceTab = Window:MakeTab({
    Name = "Police",
    Icon = "rbxassetid://73598603304502",
    PremiumOnly = false
})

Window:TabSection("Settings")

local TeleportTab = Window:MakeTab({ 
    Name = "Teleport", 
    Icon = "rbxassetid://6723742952",
    PremiumOnly = false 
})

local MiscTab = Window:MakeTab({ 
    Name = "Misc", 
    Icon = "rbxassetid://16149179345", 
    PremiumOnly = false 
})

Window:TabSection("Other")

local SocialTab = Window:MakeTab({
    Name = "Social",
    Icon = "rbxassetid://117281710784951",
    PremiumOnly = false
})

local InfoTab = Window:MakeTab({
    Name = "Info",
    Icon = "rbxassetid://7733956210",
    PremiumOnly = false
})

HomeTab:AddSection({ 
    Name = "Special" 
})

HomeTab:AddParagraph("Information", "More Features are Comming Soon")

HomeTab:AddButton({
    Name = "Download Game (Take Time)",
    Callback = function()
        saveinstance()
    end    
})

HomeTab:AddSection({ 
    Name = "Freecam" 
})

HomeTab:AddButton({
	Name = "Bypass Freecam",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/4JrUuEqn"))()
		game.StarterGui:SetCore("SendNotification", {
			Title = "Freecam",
			Text = "Freecam is Bypassed Press Shift + P to Enable Freecam",
			Duration = 10
		})
	end    
})

local pi    = math.pi
local abs   = math.abs
local clamp = math.clamp
local rad   = math.rad
local sign  = math.sign
local tan   = math.tan

local ContextActionService = game:GetService("ContextActionService")
local Players              = game:GetService("Players")
local RunService           = game:GetService("RunService")
local StarterGui           = game:GetService("StarterGui")
local UserInputService     = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end

local Camera = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    local newCamera = workspace.CurrentCamera
    if newCamera then Camera = newCamera end
end)

local TOGGLE_INPUT_PRIORITY = Enum.ContextActionPriority.Low.Value
local INPUT_PRIORITY        = Enum.ContextActionPriority.High.Value

local navSpeed = 1.0

local NAV_GAIN    = Vector3.new(1, 1, 1) * 64
local PAN_GAIN    = Vector2.new(0.75, 1) * 8
local FOV_GAIN    = 300
local PITCH_LIMIT = rad(90)

local cameraPos = Vector3.new()
local cameraRot = Vector2.new()
local cameraFov = 70

local Input = {} do
    local keyboard = {
        W=0, A=0, S=0, D=0, E=0, Q=0,
        U=0, H=0, J=0, K=0, I=0, Y=0,
        Up=0, Down=0,
    }
    local mouse = {
        Delta = Vector2.new(),
        MouseWheel = 0,
    }

    local NAV_SHIFT_MUL = 0.25

    function Input.Vel(dt)
        local kKeyboard = Vector3.new(
            keyboard.D - keyboard.A + keyboard.K - keyboard.H,
            keyboard.E - keyboard.Q + keyboard.I - keyboard.Y,
            keyboard.S - keyboard.W + keyboard.J - keyboard.U
        )
        local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
                   or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
        return kKeyboard * (navSpeed * (shift and NAV_SHIFT_MUL or 1))
    end

    function Input.Pan(dt)
        local PAN_MOUSE_SPEED = Vector2.new(1, 1) * (pi / 64)
        local kMouse = mouse.Delta * PAN_MOUSE_SPEED
        mouse.Delta = Vector2.new()
        return kMouse
    end

    function Input.Fov(dt)
        local kMouse = mouse.MouseWheel
        mouse.MouseWheel = 0
        return kMouse
    end

    do
        local function Keypress(action, state, input)
            keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
            return Enum.ContextActionResult.Sink
        end

        local function MousePan(action, state, input)
            local delta = input.Delta
            mouse.Delta = Vector2.new(-delta.y, -delta.x)
            return Enum.ContextActionResult.Sink
        end

        local function MouseWheel(action, state, input)
            mouse[input.UserInputType.Name] = -input.Position.z
            return Enum.ContextActionResult.Sink
        end

        local function Zero(t)
            for k, v in pairs(t) do t[k] = v * 0 end
        end

        function Input.StartCapture()
            ContextActionService:BindActionAtPriority("FreecamKeyboard", Keypress, false, INPUT_PRIORITY,
                Enum.KeyCode.W, Enum.KeyCode.U,
                Enum.KeyCode.A, Enum.KeyCode.H,
                Enum.KeyCode.S, Enum.KeyCode.J,
                Enum.KeyCode.D, Enum.KeyCode.K,
                Enum.KeyCode.E, Enum.KeyCode.I,
                Enum.KeyCode.Q, Enum.KeyCode.Y,
                Enum.KeyCode.Up, Enum.KeyCode.Down
            )
            ContextActionService:BindActionAtPriority("FreecamMousePan",   MousePan,   false, INPUT_PRIORITY, Enum.UserInputType.MouseMovement)
            ContextActionService:BindActionAtPriority("FreecamMouseWheel", MouseWheel, false, INPUT_PRIORITY, Enum.UserInputType.MouseWheel)
        end

        function Input.StopCapture()
            Zero(keyboard)
            Zero(mouse)
            ContextActionService:UnbindAction("FreecamKeyboard")
            ContextActionService:UnbindAction("FreecamMousePan")
            ContextActionService:UnbindAction("FreecamMouseWheel")
        end
    end
end

local function GetFocusDistance(cameraFrame)
    local znear   = 0.1
    local viewport = Camera.ViewportSize
    local projy   = 2 * tan(cameraFov / 2)
    local projx   = viewport.x / viewport.y * projy
    local fx, fy, fz = cameraFrame.rightVector, cameraFrame.upVector, cameraFrame.lookVector
    local minDist = 512
    for x = 0, 1, 0.5 do
        for y = 0, 1, 0.5 do
            local cx     = (x - 0.5) * projx
            local cy     = (y - 0.5) * projy
            local offset = fx * cx - fy * cy + fz
            local origin = cameraFrame.p + offset * znear
            local _, hit = workspace:FindPartOnRay(Ray.new(origin, offset.unit * minDist))
            local dist   = (hit - origin).magnitude
            if minDist > dist then minDist = dist end
        end
    end
    return minDist
end

local function StepFreecam(dt)
    local vel = Input.Vel(dt)
    local pan = Input.Pan(dt)
    local fov = Input.Fov(dt)

    local zoomFactor = math.sqrt(tan(rad(70 / 2)) / tan(rad(cameraFov / 2)))

    cameraFov = clamp(cameraFov + fov * FOV_GAIN * (dt / zoomFactor), 1, 120)
    cameraRot = cameraRot + pan * PAN_GAIN * (dt / zoomFactor)
    cameraRot = Vector2.new(clamp(cameraRot.x, -PITCH_LIMIT, PITCH_LIMIT), cameraRot.y % (2 * pi))

    local cameraCFrame = CFrame.new(cameraPos)
        * CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0)
        * CFrame.new(vel * NAV_GAIN * dt)

    cameraPos = cameraCFrame.p

    Camera.CFrame        = cameraCFrame
    Camera.Focus         = cameraCFrame * CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
    Camera.FieldOfView   = cameraFov
end

local PlayerState = {} do
    local mouseIconEnabled, cameraSubject, cameraType
    local cameraFocus, cameraCFrame, cameraFieldOfView
    local screenGuis = {}
    local coreGuis   = { Backpack=true, Chat=true, Health=true, PlayerList=true }
    local setCores   = { BadgesNotificationsActive=true, PointsNotificationsActive=true }

    function PlayerState.Push()
        for name in pairs(coreGuis) do
            coreGuis[name] = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType[name])
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[name], false)
        end
        for name in pairs(setCores) do
            setCores[name] = StarterGui:GetCore(name)
            StarterGui:SetCore(name, false)
        end
        local playergui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if playergui then
            for _, gui in pairs(playergui:GetChildren()) do
                if gui:IsA("ScreenGui") and gui.Enabled then
                    screenGuis[#screenGuis + 1] = gui
                    gui.Enabled = false
                end
            end
        end
        cameraFieldOfView    = Camera.FieldOfView
        Camera.FieldOfView   = 70
        cameraType           = Camera.CameraType
        Camera.CameraType    = Enum.CameraType.Custom
        cameraSubject        = Camera.CameraSubject
        Camera.CameraSubject = nil
        cameraCFrame         = Camera.CFrame
        cameraFocus          = Camera.Focus
        mouseIconEnabled     = UserInputService.MouseIconEnabled
        UserInputService.MouseIconEnabled = false
        UserInputService.MouseBehavior    = Enum.MouseBehavior.Default
    end

    function PlayerState.Pop()
        for name, isEnabled in pairs(coreGuis) do
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType[name], isEnabled)
        end
        for name, isEnabled in pairs(setCores) do
            StarterGui:SetCore(name, isEnabled)
        end
        for _, gui in pairs(screenGuis) do
            if gui.Parent then gui.Enabled = true end
        end
        screenGuis            = {}
        Camera.FieldOfView    = cameraFieldOfView
        Camera.CameraType     = cameraType
        Camera.CameraSubject  = cameraSubject
        Camera.CFrame         = cameraCFrame
        Camera.Focus          = cameraFocus
        UserInputService.MouseIconEnabled = mouseIconEnabled
        UserInputService.MouseBehavior    = Enum.MouseBehavior.Default
    end
end

local freecamEnabled = false

local function StartFreecam()
    local cf = Camera.CFrame
    cameraRot = Vector2.new(cf:toEulerAnglesYXZ())
    cameraPos = cf.p
    cameraFov = Camera.FieldOfView
    PlayerState.Push()
    RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
    Input.StartCapture()
end

local function StopFreecam()
    Input.StopCapture()
    RunService:UnbindFromRenderStep("Freecam")
    PlayerState.Pop()
end

local function ToggleFreecam()
    if freecamEnabled then
        StopFreecam()
    else
        StartFreecam()
    end
    freecamEnabled = not freecamEnabled
end

HomeTab:AddBind({
    Name = "Freecam Toggle",
    Default = Enum.KeyCode.P,
    Hold = false,
    Flag = "FreecamBind",
    Callback = function()
        ToggleFreecam()
    end,
})

HomeTab:AddSlider({
    Name = "Freecam Speed",
    Min = 0,
    Max = 400,
    Default = 100,
    Increment = 1,
    ValueName = "x",
    Flag = "FreecamSpeed",
    Callback = function(value)
        navSpeed = math.max(0.01, value / 100)
    end,
})

selectedPlayers = {}

local function getPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then 
            table.insert(names, player.Name)
        end
    end
    return names
end

local function setPlayerVisibility(playerName, isVisible)
    local player = Players:FindFirstChild(playerName)
    if player and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                if not isVisible then
                    part.Transparency = 1
                else
                    part.Transparency = 0
                end
            end
        end
    end
end

local PlayerDropdown = HomeTab:AddDropdown({
    Name = "Remove Player (out of workspace)",
    Default = "None",
    Options = getPlayerNames(),
    Callback = function(Value)
        if selectedPlayers[Value] then
            selectedPlayers[Value] = nil
            setPlayerVisibility(Value, true)
        else
            selectedPlayers[Value] = true
            setPlayerVisibility(Value, false)
        end
    end    
})

local function refreshDropdown()
    PlayerDropdown:Refresh(getPlayerNames(), true)
end

Players.PlayerAdded:Connect(refreshDropdown)
Players.PlayerRemoving:Connect(refreshDropdown)

local Settings = {
    Aimbot = {
        Enabled = false,
        Active = false,
        TeamCheck = false,
        KnockedCheck = false,
        PredictionEnabled = false,
        BasePrediction = 0.05,
        TargetPart = "Head",
        ShowFOV = false,
        Target = nil
    }
}

local AllSettings = {
    Aimbot = {
        FOV = 350,
        BasePrediction = 0.05,
        Mobile = false
    }
}

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.6
FOVCircle.NumSides = 100
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Radius = 350

function UpdateFOVPosition()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X * 0.5, Camera.ViewportSize.Y * 0.5)
end

function FindClosestTarget()
    local center = Vector2.new(Camera.ViewportSize.X * 0.5, Camera.ViewportSize.Y * 0.5)
    local closestDistance = math.huge
    local closestTarget = nil

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetPart = player.Character:FindFirstChild(Settings.Aimbot.TargetPart)
            if targetPart then
                if Settings.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then
                    continue
                end

                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if Settings.Aimbot.KnockedCheck and (not humanoid or humanoid.Health < 30) then
                    continue
                end

                local targetPos = targetPart.Position
                if Settings.Aimbot.PredictionEnabled then
                    local success, velocity = pcall(function()
                        return targetPart.AssemblyLinearVelocity
                    end)
                    if success and velocity then
                        targetPos = targetPos + velocity * Settings.Aimbot.BasePrediction
                    end
                end

                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if distance <= FOVCircle.Radius and distance < closestDistance then
                        closestDistance = distance
                        closestTarget = targetPart
                    end
                end
            end
        end
    end
    return closestTarget
end

RunService.RenderStepped:Connect(function()
    if Settings.Aimbot.ShowFOV then
        UpdateFOVPosition()
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end

    if Settings.Aimbot.Enabled and Settings.Aimbot.Active then
        if not Settings.Aimbot.Target or not Settings.Aimbot.Target.Parent then
            Settings.Aimbot.Target = FindClosestTarget()
        end

        if Settings.Aimbot.Target then
            local targetPos = Settings.Aimbot.Target.Position

            if Settings.Aimbot.PredictionEnabled then
                local success, velocity = pcall(function()
                    return Settings.Aimbot.Target.AssemblyLinearVelocity
                end)
                if success and velocity then
                    targetPos = targetPos + velocity * Settings.Aimbot.BasePrediction
                end
            end
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
        end
    end
end)

AimbotTab:AddSection({ 
    Name = "Aimbot Settings" 
})

AimbotTab:AddToggle({
    Name = "Aimbot",
    Default = false,
    Callback = function(Value)
        Settings.Aimbot.Enabled = Value
        if not Value then
            Settings.Aimbot.Active = false
            Settings.Aimbot.Target = nil
        end
    end    
})

AimbotTab:AddToggle({
    Name = "Show Aimbot FOV",
    Default = false,
    Callback = function(Value)
        Settings.Aimbot.ShowFOV = Value
    end
})

AimbotTab:AddToggle({
    Name = "Team Check",
    Default = false,
    Callback = function(Value)
        Settings.Aimbot.TeamCheck = Value
    end
})

AimbotTab:AddToggle({
    Name = "Knocked Check",
    Default = false,
    Callback = function(Value)
        Settings.Aimbot.KnockedCheck = Value
    end
})

AimbotTab:AddToggle({
    Name = "Prediction",
    Default = false,
    Callback = function(Value)
        Settings.Aimbot.PredictionEnabled = Value
    end
})

AimbotTab:AddSlider({
    Name = "Aimbot FOV Size",
    Min = 50,
    Max = 1000,
    Default = 150,
    Increment = 10,
    ValueName = "px",
    Callback = function(Value)
        FOVCircle.Radius = Value
        AllSettings.Aimbot.FOV = Value
    end
})

AimbotTab:AddDropdown({
    Name = "Target Part",
    Default = "Head",
    Options = {"Head", "HumanoidRootPart"},
    Callback = function(Value)
        Settings.Aimbot.TargetPart = Value
    end
})

AimbotTab:AddBind({
    Name = "Aimbot Keybind",
    Default = Enum.KeyCode.Y,
    Hold = false,
    Callback = function()
        if not Settings.Aimbot.Enabled then return end
        Settings.Aimbot.Active = not Settings.Aimbot.Active
        if Settings.Aimbot.Active then
            Settings.Aimbot.Target = FindClosestTarget()
        else
            Settings.Aimbot.Target = nil
        end
    end
})

usernameESP = false
healthESP = false
corneredESP = false
skeletonESP = false
teamColorESP = false
showEquipped = false
selfESP = false
ShowWanted = false
showDistance = false
renderRange = 1000

local ESP_Data = {}
local CoreGui = game:GetService("CoreGui")
local WantedPlayers = {}

local function isPlayerWanted(player)
    if WantedPlayers[player.UserId] == true then return true end
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        if player.Character.HumanoidRootPart:GetAttribute("IsWanted") == true then
            return true
        end
    end
    return false
end

function UpdateWantedPlayers(wantedTable)
    WantedPlayers = {}
    if type(wantedTable) == "table" then
        for k, v in pairs(wantedTable) do
            if type(k) == "number" and type(v) == "boolean" then
                WantedPlayers[k] = v
            elseif type(v) == "number" then
                WantedPlayers[v] = true
            end
        end
    end
    for player, e in pairs(ESP_Data) do
        e.IsWanted = isPlayerWanted(player)
    end
end

local EspGui = Instance.new("ScreenGui")
EspGui.Name = "Esp_Overlay"
EspGui.Parent = CoreGui
EspGui.IgnoreGuiInset = true
EspGui.ResetOnSpawn = false

local function createLine()
    local line = Instance.new("Frame")
    line.BackgroundColor3 = Color3.new(1, 1, 1)
    line.BorderSizePixel = 0
    line.ZIndex = 4
    line.Visible = false
    line.Parent = EspGui
    return line
end

local function hideAll(e)
    for _, l in pairs(e.Lines) do l.Visible = false end
    for _, l in pairs(e.Skeleton) do l.Visible = false end
    e.NameTag.Visible = false
    e.ItemTag.Visible = false
    e.WantedTag.Visible = false
    e.DistanceTag.Visible = false
    e.HealthBg.Visible = false
    e.TeamTag.Visible = false
    e.AdminTag.Visible = false
end

local function removeESP(player)
    local data = ESP_Data[player]
    if data then
        if data.CharConn then data.CharConn:Disconnect() end
        if data.WantedAddedConn then data.WantedAddedConn:Disconnect() end
        if data.WantedRemovedConn then data.WantedRemovedConn:Disconnect() end
        for _, v in pairs(data.Lines) do v:Destroy() end
        for _, v in pairs(data.Skeleton) do v:Destroy() end
        data.AdminTag:Destroy()
        data.WantedTag:Destroy()
        data.NameTag:Destroy()
        data.ItemTag:Destroy()
        data.TeamTag:Destroy()
        data.DistanceTag:Destroy()
        data.HealthBg:Destroy()
        ESP_Data[player] = nil
    end
end

local function setupPlayer(player)
    if ESP_Data[player] then return end
    local elements = {
        Lines = {
            TLH = createLine(), TLV = createLine(), TRH = createLine(), TRV = createLine(),
            BLH = createLine(), BLV = createLine(), BRH = createLine(), BRV = createLine()
        },
        Skeleton = {},
        AdminTag = Instance.new("TextLabel"),
        WantedTag = Instance.new("TextLabel"),
        NameTag = Instance.new("TextLabel"),
        ItemTag = Instance.new("TextLabel"),
        TeamTag = Instance.new("TextLabel"),
        DistanceTag = Instance.new("TextLabel"),
        HealthBg = Instance.new("Frame"),
        HealthBar = Instance.new("Frame"),
        CharConn = nil,
        WantedAddedConn = nil,
        WantedRemovedConn = nil,
        IsWanted = false
    }
    for i = 1, 15 do table.insert(elements.Skeleton, createLine()) end

    local function styleLabel(label)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
        label.Size = UDim2.new(0, 120, 0, 14)
        label.Parent = EspGui
        label.Visible = false
    end

    styleLabel(elements.AdminTag)
    styleLabel(elements.WantedTag)
    elements.WantedTag.RichText = true
    styleLabel(elements.NameTag)
    styleLabel(elements.ItemTag)
    styleLabel(elements.TeamTag)
    styleLabel(elements.DistanceTag)

    elements.HealthBg.BackgroundColor3 = Color3.new(0, 0, 0)
    elements.HealthBg.BackgroundTransparency = 0.5
    elements.HealthBg.BorderSizePixel = 0
    elements.HealthBg.Visible = false
    elements.HealthBg.Parent = EspGui
    elements.HealthBar.BackgroundColor3 = Color3.new(0, 1, 0)
    elements.HealthBar.BorderSizePixel = 0
    elements.HealthBar.Parent = elements.HealthBg

    elements.IsWanted = isPlayerWanted(player)

    elements.WantedAddedConn = player.ChildAdded:Connect(function(child)
        if child.Name == "Is_Wanted" then
            elements.IsWanted = true
        end
    end)
    elements.WantedRemovedConn = player.ChildRemoved:Connect(function(child)
        if child.Name == "Is_Wanted" then
            elements.IsWanted = false
        end
    end)

    elements.CharConn = player.CharacterAdded:Connect(function()
        hideAll(elements)
    end)

    ESP_Data[player] = elements
end

local function drawLine(line, p1, p2, thickness, color)
    local dist = (p1 - p2).Magnitude
    if dist < 0.01 then
        line.Visible = false
        return
    end
    line.Size = UDim2.new(0, dist, 0, thickness)
    line.Position = UDim2.new(0, (p1.X + p2.X) / 2 - dist / 2, 0, (p1.Y + p2.Y) / 2 - thickness / 2)
    line.Rotation = math.atan2(p2.Y - p1.Y, p2.X - p1.X) * (180 / math.pi)
    line.BackgroundColor3 = color or Color3.new(1, 1, 1)
    line.Visible = true
end

local function getTeamName(player)
    if player.Team then
        return player.Team.Name
    end
    return nil
end

local function updateESPVisuals()
    for player, e in pairs(ESP_Data) do
        if not player or not player.Parent then
            hideAll(e)
            continue
        end

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if (player == LocalPlayer and not selfESP) then
            hideAll(e)
            continue
        end

        if not hrp or not hum or hum.Health <= 0 then
            hideAll(e)
            continue
        end

        local distance = (Camera.CFrame.Position - hrp.Position).Magnitude
        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

        if not onScreen or distance > renderRange then
            hideAll(e)
            continue
        end

        e.IsWanted = isPlayerWanted(player)

        local statusColor = Color3.new(1, 1, 1)

        local teamColor = nil
        if teamColorESP and player.Team then
            teamColor = player.TeamColor.Color
        end
        local displayColor = teamColor or statusColor

        local factor = 1 / (distance * (Camera.FieldOfView / 70)) * 1000
        local w, h = 4 * factor, 6 * factor
        local x, y = pos.X, pos.Y
        local nameSize = math.clamp(factor * 0.4, 9, 14)
        local thick = math.clamp(factor * 0.15, 1, 2)

        local currentTopOffset = h / 2 + 2

        if teamColorESP then
            local teamName = getTeamName(player)
            if teamName then
                e.TeamTag.Visible = true
                e.TeamTag.Text = teamName
                e.TeamTag.TextColor3 = teamColor or statusColor
                e.TeamTag.TextSize = nameSize
                e.TeamTag.Size = UDim2.new(0, 120, 0, nameSize)
                e.TeamTag.Position = UDim2.new(0, x - 60, 0, y - currentTopOffset - nameSize)
                currentTopOffset = currentTopOffset + nameSize + 1
            else
                e.TeamTag.Visible = false
            end
        else
            e.TeamTag.Visible = false
        end

        if usernameESP then
            e.NameTag.Visible = true
            e.NameTag.Text = "@" .. player.Name
            e.NameTag.TextColor3 = displayColor
            e.NameTag.TextSize = nameSize
            e.NameTag.Size = UDim2.new(0, 120, 0, nameSize)
            e.NameTag.Position = UDim2.new(0, x - 60, 0, y - currentTopOffset - nameSize)
            currentTopOffset = currentTopOffset + nameSize + 1
        else
            e.NameTag.Visible = false
        end

        if showEquipped then
            local tool = char:FindFirstChildOfClass("Tool")
            e.ItemTag.Visible = true
            e.ItemTag.Text = tool and (tool.Name) or "Nothing"
            e.ItemTag.TextColor3 = statusColor
            e.ItemTag.TextSize = nameSize - 1
            e.ItemTag.Size = UDim2.new(0, 120, 0, nameSize)
            e.ItemTag.Position = UDim2.new(0, x - 60, 0, y - currentTopOffset - nameSize)
            currentTopOffset = currentTopOffset + nameSize + 1
        else
            e.ItemTag.Visible = false
        end

        local currentBottomOffset = h / 2 + 2

        if ShowWanted then
            e.WantedTag.Visible = true
            e.WantedTag.Font = Enum.Font.GothamBold
            e.WantedTag.TextSize = nameSize
            e.WantedTag.Size = UDim2.new(0, 120, 0, nameSize)
            e.WantedTag.Position = UDim2.new(0, x - 60, 0, y + currentBottomOffset)
            if e.IsWanted then
                e.WantedTag.Text = "<font color='#FFFF00'></font> <font color='#FF3232'>WANTED</font> <font color='#FFFF00'></font>"
            else
                e.WantedTag.Text = "<font color='#AAAAAA'>NOT WANTED</font>"
            end
            currentBottomOffset = currentBottomOffset + nameSize + 1
        else
            e.WantedTag.Visible = false
        end

        if showDistance then
            local distRounded = math.floor(distance + 0.5)
            e.DistanceTag.Visible = true
            e.DistanceTag.Text = distRounded .. " studs"
            e.DistanceTag.TextColor3 = Color3.fromRGB(180, 180, 255)
            e.DistanceTag.TextSize = nameSize - 1
            e.DistanceTag.Size = UDim2.new(0, 120, 0, nameSize)
            e.DistanceTag.Position = UDim2.new(0, x - 60, 0, y + currentBottomOffset)
            currentBottomOffset = currentBottomOffset + nameSize + 1
        else
            e.DistanceTag.Visible = false
        end

        if corneredESP then
            local edge = w / 4
            local function m(l, px, py, sx, sy)
                l.Position = UDim2.new(0, px, 0, py)
                l.Size = UDim2.new(0, sx, 0, sy)
                l.BackgroundColor3 = displayColor
                l.Visible = true
            end
            m(e.Lines.TLH, x - w/2,        y - h/2,        edge,  thick)
            m(e.Lines.TLV, x - w/2,        y - h/2,        thick, edge)
            m(e.Lines.TRH, x + w/2 - edge, y - h/2,        edge,  thick)
            m(e.Lines.TRV, x + w/2,        y - h/2,        thick, edge)
            m(e.Lines.BLH, x - w/2,        y + h/2,        edge,  thick)
            m(e.Lines.BLV, x - w/2,        y + h/2 - edge, thick, edge)
            m(e.Lines.BRH, x + w/2 - edge, y + h/2,        edge,  thick)
            m(e.Lines.BRV, x + w/2,        y + h/2 - edge, thick, edge)
        else
            for _, l in pairs(e.Lines) do l.Visible = false end
        end

        if skeletonESP then
            local isR15 = hum.RigType == Enum.HumanoidRigType.R15
            local rig = isR15 and {
                {"UpperTorso","Head"},{"UpperTorso","LowerTorso"},
                {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
                {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
                {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
                {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}
            } or {
                {"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},
                {"Torso","Left Leg"},{"Torso","Right Leg"}
            }

            for i, joints in ipairs(rig) do
                local p1 = char:FindFirstChild(joints[1])
                local p2 = char:FindFirstChild(joints[2])
                if p1 and p2 and p1:IsA("BasePart") and p2:IsA("BasePart") then
                    local vp1 = Camera:WorldToViewportPoint(p1.Position)
                    local vp2 = Camera:WorldToViewportPoint(p2.Position)
                    if vp1.Z > 0 and vp2.Z > 0 then
                        drawLine(e.Skeleton[i], Vector2.new(vp1.X, vp1.Y), Vector2.new(vp2.X, vp2.Y), 1.5, statusColor)
                    else
                        e.Skeleton[i].Visible = false
                    end
                else
                    if e.Skeleton[i] then e.Skeleton[i].Visible = false end
                end
            end
            for i = (#rig + 1), #e.Skeleton do
                e.Skeleton[i].Visible = false
            end
        else
            for _, l in pairs(e.Skeleton) do l.Visible = false end
        end

        if healthESP then
            local barW = math.clamp(factor * 0.1, 2, 4)
            local hp = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
            e.HealthBg.Position = UDim2.new(0, x - w/2 - (barW + 4), 0, y - h/2)
            e.HealthBg.Size = UDim2.new(0, barW, 0, h)
            e.HealthBar.Size = UDim2.new(1, 0, hp, 0)
            e.HealthBar.Position = UDim2.new(0, 0, 1 - hp, 0)
            e.HealthBar.BackgroundColor3 = Color3.fromHSV(hp * 0.3, 1, 1)
            e.HealthBg.Visible = true
        else
            e.HealthBg.Visible = false
        end
    end
end

VisualsTab:AddToggle({ Name = "Show Player Name",     Default = false, Callback = function(v) usernameESP   = v end })
VisualsTab:AddToggle({ Name = "Show Equipped Item",   Default = false, Callback = function(v) showEquipped  = v end })
VisualsTab:AddToggle({ Name = "Show Wanted Status",   Default = false, Callback = function(v) ShowWanted    = v end })
VisualsTab:AddToggle({ Name = "Show Player Distance", Default = false, Callback = function(v) showDistance  = v end })
VisualsTab:AddToggle({ Name = "Show Player Team",     Default = false, Callback = function(v) teamColorESP  = v end })
VisualsTab:AddToggle({ Name = "Show Player Health",   Default = false, Callback = function(v) healthESP     = v end })
VisualsTab:AddToggle({ Name = "Show Skeleton",        Default = false, Callback = function(v) skeletonESP   = v end })
VisualsTab:AddToggle({ Name = "Show Cornered Box",    Default = false, Callback = function(v) corneredESP   = v end })

VisualsTab:AddSection({ Name = "Visuals Customization" })
VisualsTab:AddSlider({ Name = "Render Range", Min = 0, Max = 3000, Default = 1000, Increment = 5, ValueName = "Studs", Callback = function(v) renderRange = v end })

RunService.RenderStepped:Connect(function()
    updateESPVisuals()
end)

Players.PlayerRemoving:Connect(removeESP)
Players.PlayerAdded:Connect(setupPlayer)
for _, p in ipairs(Players:GetPlayers()) do setupPlayer(p) end

GraphicTab:AddSection({
    Name = "World Graphics"
})

getgenv().Resolution = 100

game:GetService("RunService").RenderStepped:Connect(function()
    if getgenv().Resolution then
        Camera.CFrame = Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Resolution, 0, 0, 0, 1)
    end
end)

GraphicTab:AddSlider({
    Name = "Resolution Scale",
    Min = 20,
    Max = 100,
    Default = 100,
    Increment = 1,
    ValueName = "%",
    Callback = function(Value)
        getgenv().Resolution = Value / 100
    end
})

Lighting = game:GetService("Lighting")

originalSky = Lighting:FindFirstChildOfClass("Sky")

function removeSky()
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if sky then
        sky:Destroy()
    end
end

function restoreSky()
    if originalSky and not Lighting:FindFirstChildOfClass("Sky") then
        local newSky = originalSky:Clone()
        newSky.Parent = Lighting
    end
end

GraphicTab:AddToggle({
	Name = "Remove Atmosphere",
    Default = false,
    Callback = function(Value)
        if Value then
            removeSky()
        else
            restoreSky()
        end
    end    
})

LightingSettings = {
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	Brightness = Lighting.Brightness,
	ShadowSoftness = Lighting.ShadowSoftness,
	GlobalShadows = Lighting.GlobalShadows
}

function enableFullbright()
	Lighting.Ambient = Color3.fromRGB(255, 255, 255)
	Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
	Lighting.Brightness = 2
	Lighting.ShadowSoftness = 0
	Lighting.GlobalShadows = false
end

function disableFullbright()
	Lighting.Ambient = LightingSettings.Ambient
	Lighting.OutdoorAmbient = LightingSettings.OutdoorAmbient
	Lighting.Brightness = LightingSettings.Brightness
	Lighting.ShadowSoftness = LightingSettings.ShadowSoftness
	Lighting.GlobalShadows = LightingSettings.GlobalShadows
end

GraphicTab:AddToggle({
	Name = "Fullbright",
	Default = false,
	Callback = function(value)
		if value then
			enableFullbright()
		else
			disableFullbright()
		end
	end
})

GraphicTab:AddSection({
	Name = "Trail Options"
})

local currentTrails = {}
local attachments = {}

local function createTrail(arm)
    local att0 = Instance.new("Attachment", arm)
    att0.Position = Vector3.new(0, 0, 0)
    
    local att1 = Instance.new("Attachment", arm)
    att1.Position = Vector3.new(0, -1, 0)
    
    local trail = Instance.new("Trail")
    trail.Attachment0 = att0
    trail.Attachment1 = att1
    
    trail.Color = ColorSequence.new(selectedColor)
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0.3),
        NumberSequenceKeypoint.new(1, 1)
    })
    
    trail.Lifetime = 1.2
    trail.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(1, 0.2)
    })
    
    trail.LightEmission = 1
    trail.LightInfluence = 0
    trail.MinLength = 0.05
    trail.TextureMode = Enum.TextureMode.Stretch
    trail.Parent = arm
    
    return trail, att0, att1
end

GraphicTab:AddToggle({
    Name = "Player Trail",
    Default = false,
    Callback = function(Value)
        if Value then
            local char = game.Players.LocalPlayer.Character
            if char then
                if char:FindFirstChild("Left Arm") then
                    local trailLeft, att0Left, att1Left = createTrail(char["Left Arm"])
                    table.insert(currentTrails, trailLeft)
                    table.insert(attachments, att0Left)
                    table.insert(attachments, att1Left)
                elseif char:FindFirstChild("LeftUpperArm") then
                    local trailLeft, att0Left, att1Left = createTrail(char["LeftUpperArm"])
                    table.insert(currentTrails, trailLeft)
                    table.insert(attachments, att0Left)
                    table.insert(attachments, att1Left)
                end
                
                if char:FindFirstChild("Right Arm") then
                    local trailRight, att0Right, att1Right = createTrail(char["Right Arm"])
                    table.insert(currentTrails, trailRight)
                    table.insert(attachments, att0Right)
                    table.insert(attachments, att1Right)
                elseif char:FindFirstChild("RightUpperArm") then
                    local trailRight, att0Right, att1Right = createTrail(char["RightUpperArm"])
                    table.insert(currentTrails, trailRight)
                    table.insert(attachments, att0Right)
                    table.insert(attachments, att1Right)
                end
            end
        else
            for _, trail in pairs(currentTrails) do
                trail:Destroy()
            end
            for _, att in pairs(attachments) do
                att:Destroy()
            end
            currentTrails = {}
            attachments = {}
        end
    end    
})

GraphicTab:AddColorpicker({
	Name = "Trail Color",
	Default = selectedColor,
	Callback = function(Value)
        TrailColor = {Value.R * 255, Value.G * 255, Value.B * 255}
		selectedColor = Value
        for _, trail in pairs(currentTrails) do
            trail.Color = ColorSequence.new(selectedColor)
        end
	end	  
})

GraphicTab:AddSection({
	Name = "Ghost Options"
})

Players = game:GetService("Players")
RunService = game:GetService("RunService")
LocalPlayer = Players.LocalPlayer

STATE = "force" or "normal"
savedColors = {}
ghostColor = false
rainbowEnabled = false

function HSVToRGB(hue)
	return Color3.fromHSV(hue % 1, 1, 1)
end

function applyGhostColor(color)
	local character = LocalPlayer.Character
	if not character then return end

	for _, part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") and part.Transparency < 1 then
			if not savedColors[part] then
				savedColors[part] = {
					Color = part.Color,
					Material = part.Material
				}
			end
			part.Material = Enum.Material.ForceField
			part.Color = color
		end
	end
end

function restoreOriginalAppearance()
	local character = LocalPlayer.Character
	if not character then return end

	for _, part in pairs(character:GetDescendants()) do
		if part:IsA("BasePart") and savedColors[part] then
			part.Material = savedColors[part].Material
			part.Color = savedColors[part].Color
		end
	end

	savedColors = {}
end

GraphicTab:AddToggle({
	Name = "Player Ghost",
	Default = false,
	Callback = function(enabled)
		STATE = enabled and "force" or "normal"
		if enabled then
			applyGhostColor(ghostColor)
		else
			restoreOriginalAppearance()
		end
	end
})

GraphicTab:AddColorpicker({
	Name = "Ghost Color",
	Default = Color3.fromRGB(255, 255, 255),
	Callback = function(value)
		ghostColor = value
		if STATE == "force" and not rainbowEnabled then
			applyGhostColor(ghostColor)
		end
	end
})

GraphicTab:AddToggle({
	Name = "Rainbow Color",
	Default = false,
	Callback = function(enabled)
		rainbowEnabled = enabled
	end
})

RunService.RenderStepped:Connect(function()
	if STATE == "force" and rainbowEnabled then
		local hue = tick() % 5 / 5
		local rainbowColor = HSVToRGB(hue)
		applyGhostColor(rainbowColor)
	end
end)

GraphicTab:AddSection({
	Name = "Custom Sky"
})

Lighting = game:GetService("Lighting")
Sky = Lighting:FindFirstChildOfClass("Sky")

if not Sky then
	Sky = Instance.new("Sky")
	Sky.Parent = Lighting
end

SkyPresets = {
	["Standard"] = {
		SkyboxBk = "rbxasset://textures/sky/sky512_bk.tex",
		SkyboxDn = "rbxasset://textures/sky/sky512_dn.tex",
		SkyboxFt = "rbxasset://textures/sky/sky512_ft.tex",
		SkyboxLf = "rbxasset://textures/sky/sky512_lf.tex",
		SkyboxRt = "rbxasset://textures/sky/sky512_rt.tex",
		SkyboxUp = "rbxasset://textures/sky/sky512_up.tex",
		SunTextureId = "rbxasset://sky/sun.jpg",
		MoonTextureId = "rbxasset://sky/moon.jpg"
	},
	["Galaxy"] = {
		SkyboxBk = "http://www.roblox.com/asset/?id=159454299",
		SkyboxDn = "http://www.roblox.com/asset/?id=159454296",
		SkyboxFt = "http://www.roblox.com/asset/?id=159454293",
		SkyboxLf = "http://www.roblox.com/asset/?id=159454286",
		SkyboxRt = "http://www.roblox.com/asset/?id=159454300",
		SkyboxUp = "http://www.roblox.com/asset/?id=159454288",
		SunTextureId = "rbxasset://sky/sun.jpg",
		MoonTextureId = "rbxasset://sky/moon.jpg"
	},
	["Space"] = {
		SkyboxBk = "http://www.roblox.com/asset/?id=166509999",
		SkyboxDn = "http://www.roblox.com/asset/?id=166510057",
		SkyboxFt = "http://www.roblox.com/asset/?id=166510116",
		SkyboxLf = "http://www.roblox.com/asset/?id=166510092",
		SkyboxRt = "http://www.roblox.com/asset/?id=166510131",
		SkyboxUp = "http://www.roblox.com/asset/?id=166510114",
		SunTextureId = "rbxasset://sky/sun.jpg",
		MoonTextureId = "rbxasset://sky/moon.jpg"
	},
	["Universe"] = {
		SkyboxBk = "rbxassetid://15983968922",
		SkyboxDn = "rbxassetid://15983966825",
		SkyboxFt = "rbxassetid://15983965025",
		SkyboxLf = "rbxassetid://15983967420",
		SkyboxRt = "rbxassetid://15983966246",
		SkyboxUp = "rbxassetid://15983964246",
		SunTextureId = "rbxasset://sky/sun.jpg",
		MoonTextureId = "rbxasset://sky/moon.jpg"
	},
	["Aesthetic"] = {
		SkyboxBk = "rbxassetid://600830446",
		SkyboxDn = "rbxassetid://600831635",
		SkyboxFt = "rbxassetid://600832720",
		SkyboxLf = "rbxassetid://600886090",
		SkyboxRt = "rbxassetid://600833862",
		SkyboxUp = "rbxassetid://600835177",
		SunTextureId = "rbxasset://sky/sun.jpg",
		MoonTextureId = "rbxasset://sky/moon.jpg"
	},
	["Pink"] = {
		SkyboxBk = "rbxassetid://12635309703",
		SkyboxDn = "rbxassetid://12635311686",
		SkyboxFt = "rbxassetid://12635312870",
		SkyboxLf = "rbxassetid://12635313718",
		SkyboxRt = "rbxassetid://12635315817",
		SkyboxUp = "rbxassetid://12635316856",
		SunTextureId = "rbxasset://sky/sun.jpg",
		MoonTextureId = "rbxassetid://1345054856"
	}
}

function ApplySkybox(textures)
	for property, textureId in pairs(textures) do
		if Sky[property] then
			Sky[property] = textureId
		end
	end
end

GraphicTab:AddDropdown({
	Name = "Change Sky",
	Default = false,
	Options = {"Standard", "Galaxy", "Space", "Universe", "Aesthetic", "Pink"},
	Callback = function(selected)
		ApplySkybox(SkyPresets[selected])
	end    
})

PlayerTab:AddSection({
    Name = "Special"
})

EMOTE_ID        = "94292601332790"
STOP_ON_MOVE    = false
ALLOW_INVISIBLE = true
FADE_IN         = 0.1
FADE_OUT        = 0.1
WEIGHT          = 1
SPEED           = 1
TIME_POSITION   = 0

cloneref = (type(cloneref) == "function") and cloneref or function(...) return ... end
InvServices = setmetatable({}, { __index = function(_, n) return cloneref(game:GetService(n)) end })

RunService = InvServices.RunService
player     = game:GetService("Players").LocalPlayer

invCharacter = player.Character or player.CharacterAdded:Wait()
invHumanoid  = invCharacter:WaitForChild("Humanoid")

local CurrentTrack
lastPosition      = invCharacter.PrimaryPart and invCharacter.PrimaryPart.Position or Vector3.new()
originalCollisions = {}
invisibleEnabled  = false

local function saveCollisions()
    originalCollisions = {}
    for _, p in ipairs(invCharacter:GetDescendants()) do
        if p:IsA("BasePart") then 
            originalCollisions[p] = p.CanCollide 
        end
    end
end

local function disableCollisions()
    for _, p in ipairs(invCharacter:GetDescendants()) do
        if p:IsA("BasePart") then 
            p.CanCollide = false 
        end
    end
end

local function restoreCollisions()
    for p, state in pairs(originalCollisions) do
        if p and p.Parent then 
            p.CanCollide = state 
        end
    end
    originalCollisions = {}
end

local function startEmote()
    if CurrentTrack then CurrentTrack:Stop(0) end
    
    local id = tonumber(EMOTE_ID) or tonumber(string.match(EMOTE_ID, "%d+"))
    if not id then return end
    
    local animId = "rbxassetid://" .. id

    pcall(function()
        local objs = game:GetObjects(animId)
        if objs and #objs > 0 and objs[1]:IsA("Animation") then
            animId = objs[1].AnimationId
        end
    end)
    
    local anim = Instance.new("Animation")
    anim.AnimationId = animId
    
    local track = invHumanoid:LoadAnimation(anim)
    track.Priority = Enum.AnimationPriority.Action4
    track:Play(FADE_IN, WEIGHT == 0 and 0.001 or WEIGHT, SPEED)
    
    CurrentTrack = track
    CurrentTrack.TimePosition = math.clamp(TIME_POSITION, 0, 1) * CurrentTrack.Length
    
    if ALLOW_INVISIBLE then 
        saveCollisions() 
        disableCollisions() 
    end
end

local function stopEmote()
    if CurrentTrack then 
        CurrentTrack:Stop(FADE_OUT) 
        CurrentTrack = nil 
    end
    restoreCollisions()
end

player.CharacterAdded:Connect(function(c)
    invCharacter = c
    invHumanoid  = c:WaitForChild("Humanoid")
end)

RunService.RenderStepped:Connect(function()
    if not invisibleEnabled then return end
    
    if STOP_ON_MOVE and CurrentTrack and CurrentTrack.IsPlaying and invCharacter.PrimaryPart then
        local currentPos = invCharacter.PrimaryPart.Position
        if (currentPos - lastPosition).Magnitude > 0.1 then
            stopEmote()
            invisibleEnabled = false
        end
        lastPosition = currentPos
    end
end)

RunService.Stepped:Connect(function()
    if invisibleEnabled and ALLOW_INVISIBLE and invCharacter and invCharacter.Parent then
        disableCollisions()
    end
end)

PlayerTab:AddToggle({
    Name = "Invisible",
    Default = false,
    Callback = function(value)
        invisibleEnabled = value
        if value then 
            startEmote() 
        else 
            stopEmote() 
        end
    end,
})

local JesusMode = false
local Player = game.Players.LocalPlayer

local WaterFloor = Instance.new("Part")
WaterFloor.Name = "JesusPlatform"
WaterFloor.Size = Vector3.new(10, 1, 10)
WaterFloor.Transparency = 1
WaterFloor.Anchored = true
WaterFloor.CanCollide = false
WaterFloor.Parent = workspace

RunService.Heartbeat:Connect(function()
    if JesusMode and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local RootPart = Player.Character.HumanoidRootPart
        local CharacterPos = RootPart.Position
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = {Player.Character, WaterFloor}
        
        local ray = workspace:Raycast(CharacterPos, Vector3.new(0, -10, 0), raycastParams)
        
        if ray and ray.Material == Enum.Material.Water then
            WaterFloor.CanCollide = true
            WaterFloor.CFrame = CFrame.new(CharacterPos.X, ray.Position.Y, CharacterPos.Z)
        else
            WaterFloor.CanCollide = false
        end
    else
        WaterFloor.CanCollide = false
    end
end)

PlayerTab:AddToggle({
    Name = "Jesus Mode",
    Default = false,
    Callback = function(Value)
        JesusMode = Value
        if not Value then
            WaterFloor.CanCollide = false
        end
    end    
})

PlayerTab:AddSection({
    Name = "Noclip V2"
})

local EMOTE_ID        = "94292601332790"
local STOP_ON_MOVE    = false
local ALLOW_INVISIBLE = true
local FADE_IN         = 0.1
local FADE_OUT        = 0.1
local WEIGHT          = 1
local SPEED_ANIM      = 1
local TIME_POSITION   = 0

local UIS = game:GetService("UserInputService")
local CurrentTrack = nil
local originalCollisions = {}
local noclipEnabled = false
local noclipConnection = nil
local noclipSpeed = 115

local function saveCollisions(char)
    originalCollisions = {}
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then 
            originalCollisions[p] = p.CanCollide 
        end
    end
end

local function restoreCollisions()
    for p, state in pairs(originalCollisions) do
        if p and p.Parent then 
            p.CanCollide = state 
        end
    end
    originalCollisions = {}
end

local function startEmote(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if CurrentTrack then CurrentTrack:Stop(0) end
    
    local id = tonumber(EMOTE_ID) or tonumber(string.match(EMOTE_ID, "%d+"))
    if not id then return end
    
    local animId = "rbxassetid://" .. id
    pcall(function()
        local objs = game:GetObjects(animId)
        if objs and #objs > 0 and objs[1]:IsA("Animation") then
            animId = objs[1].AnimationId
        end
    end)
    
    local anim = Instance.new("Animation")
    anim.AnimationId = animId
    
    CurrentTrack = hum:LoadAnimation(anim)
    CurrentTrack.Priority = Enum.AnimationPriority.Action4
    CurrentTrack:Play(FADE_IN, WEIGHT == 0 and 0.001 or WEIGHT, SPEED_ANIM)
    CurrentTrack.TimePosition = math.clamp(TIME_POSITION, 0, 1) * CurrentTrack.Length
    
    if ALLOW_INVISIBLE then 
        saveCollisions(char) 
    end
end

local function stopEmote()
    if CurrentTrack then 
        CurrentTrack:Stop(FADE_OUT) 
        CurrentTrack = nil 
    end
    restoreCollisions()
end

local function setCharTransparency(char, transparency)
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then
            if v.Name ~= "HumanoidRootPart" then
                v.Transparency = transparency
            end
        end
    end
end

local function getCharacter()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
        return player.Character
    end
    return nil
end

local function toggleNoclip(state)
    noclipEnabled = state
    local char = getCharacter()
    
    if noclipConnection then 
        noclipConnection:Disconnect() 
        noclipConnection = nil
    end
    
    if noclipEnabled and char then
        startEmote(char)
        setCharTransparency(char, 0)

        noclipConnection = RunService.Stepped:Connect(function()
            if not noclipEnabled then return end
            local character = getCharacter()
            if not character then return end
            
            local hum = character.Humanoid
            local root = character.HumanoidRootPart
            local camera = workspace.CurrentCamera

            for _, v in pairs(character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end

            hum:ChangeState(Enum.HumanoidStateType.FallingDown)

            local moveDir = Vector3.new(0, 0, 0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
            
            if moveDir.Magnitude > 0 then
                root.CFrame = CFrame.new(root.Position, root.Position + moveDir)
                root.CFrame = root.CFrame + (moveDir.Unit * (noclipSpeed / 60))
            end

            if UIS:IsKeyDown(Enum.KeyCode.Space) then root.CFrame = root.CFrame * CFrame.new(0, 0.6, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then root.CFrame = root.CFrame * CFrame.new(0, -0.6, 0) end

            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end)
    else
        stopEmote()
        if char then
            setCharTransparency(char, 0)
            char.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end

local NoclipToggle = PlayerTab:AddToggle({
    Name = "Noclip V2",
    Default = false,
    Callback = function(Value)
        toggleNoclip(Value)
    end
})

PlayerTab:AddBind({
    Name = "Noclip Keybind",
    Default = Enum.KeyCode.H,
    Callback = function()
        NoclipToggle:Set(not noclipEnabled)
    end    
})

PlayerTab:AddSlider({
    Name = "Noclip Speed",
    Min = 5, 
    Max = 100, 
    Default = 30, 
    Increment = 1,
    Callback = function(v) 
        noclipSpeed = v 
    end
})

PlayerTab:AddSection({
    Name = "Player Speed Hack"
})

speedHackEnabled = false
speedHackStepSize = 0.1
local speedHackConnection

PlayerTab:AddToggle({
    Name = "Speed Hack",
    Default = false,
    Callback = function(Value)
        speedHackEnabled = Value
        if Value then
            speedHackConnection = RunService.Heartbeat:Connect(function()
                if speedHackEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    local character = LocalPlayer.Character
                    local humanoid = character:FindFirstChild("Humanoid")
                    local direction = humanoid.MoveDirection
                    if direction.Magnitude > 0 then
                        character:SetPrimaryPartCFrame(character.PrimaryPart.CFrame + direction.Unit * speedHackStepSize)
                    end
                end
            end)
        else
            if speedHackConnection then
                speedHackConnection:Disconnect()
                speedHackConnection = nil
            end
        end
    end
})

PlayerTab:AddBind({
    Name = "Speed Hack Keybind",
    Default = Enum.KeyCode.U,
    Hold = false,
    Callback = function()
        speedHackEnabled = not speedHackEnabled
        if speedHackEnabled then
            speedHackConnection = RunService.Heartbeat:Connect(function()
                if speedHackEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    local character = LocalPlayer.Character
                    local humanoid = character:FindFirstChild("Humanoid")
                    local direction = humanoid.MoveDirection
                    if direction.Magnitude > 0 then
                        character:SetPrimaryPartCFrame(character.PrimaryPart.CFrame + direction.Unit * speedHackStepSize)
                    end
                end
            end)
        else
            if speedHackConnection then
                speedHackConnection:Disconnect()
                speedHackConnection = nil
            end
        end
    end    
})

PlayerTab:AddSlider({
    Name = "Speed Hack Speed",
    Min = 0.1,
    Max = 0.3,
    Default = 0.1,
    Increment = 0.1,
    ValueName = "Speed",
    Callback = function(Value)
        speedHackStepSize = Value
    end    
})

PlayerTab:AddSection({
    Name = "Player Fly"
})

flyingSpeed = 20
isFlying = false
local attachment, alignPosition, alignOrientation
player = game:GetService("Players").LocalPlayer

function canFly()
	return player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("Humanoid").SeatPart == nil
end

function enableFly()
	if not canFly() then return false end

	local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
	local humanoid = player.Character:FindFirstChild("Humanoid")

	if attachment then attachment:Destroy() end
	if alignPosition then alignPosition:Destroy() end
	if alignOrientation then alignOrientation:Destroy() end

	attachment = Instance.new("Attachment")
	attachment.Parent = humanoidRootPart

	alignPosition = Instance.new("AlignPosition")
	alignPosition.Attachment0 = attachment
	alignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
	alignPosition.MaxForce = 5000
	alignPosition.Responsiveness = 45
	alignPosition.Parent = humanoidRootPart

	alignOrientation = Instance.new("AlignOrientation")
	alignOrientation.Attachment0 = attachment
	alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	alignOrientation.MaxTorque = 5000
	alignOrientation.Responsiveness = 45
	alignOrientation.Parent = humanoidRootPart

	humanoid.PlatformStand = true
	isFlying = true

	local lastPosition = humanoidRootPart.Position
	alignPosition.Position = lastPosition

	local function flyLoop()
		while isFlying and player.Character and humanoidRootPart and humanoid do
			local moveDirection = Vector3.new()
			local camCFrame = workspace.CurrentCamera.CFrame

			if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
				moveDirection += camCFrame.LookVector
			end
			if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
				moveDirection -= camCFrame.LookVector
			end
			if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
				moveDirection -= camCFrame.RightVector
			end
			if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
				moveDirection += camCFrame.RightVector
			end

			if moveDirection.Magnitude > 0 then
				moveDirection = moveDirection.Unit
				local newPosition = lastPosition + (moveDirection * flyingSpeed * game:GetService("RunService").Heartbeat:Wait())
				alignPosition.Position = newPosition
				lastPosition = newPosition
			end

			alignOrientation.CFrame = CFrame.new(Vector3.new(), camCFrame.LookVector)
			game:GetService("RunService").Heartbeat:Wait()
		end
	end

	spawn(flyLoop)
	return true
end

function disableFly()
	isFlying = false
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character:FindFirstChild("Humanoid").PlatformStand = false
	end
	if attachment then attachment:Destroy() end
	if alignPosition then alignPosition:Destroy() end
	if alignOrientation then alignOrientation:Destroy() end
end

local FlyToggle = PlayerTab:AddToggle({
    Name = "Player Fly",
    Default = false,
    Callback = function(Value)
        if Value then
            if not enableFly() then
                FlyToggle:Set(false)
            end
        else
            disableFly()
        end
    end    
})

PlayerTab:AddBind({
    Name = "Fly Keybind",
    Default = Enum.KeyCode.U,
    Hold = false,
    Callback = function()
        if isFlying then
            disableFly()
            FlyToggle:Set(false)
        else
            if enableFly() then
                FlyToggle:Set(true)
            else
                FlyToggle:Set(false)
            end
        end
    end    
})

PlayerTab:AddSlider({
    Name = "Fly Speed",
    Min = 5,
    Max = 100,
    Default = 20,
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        flyingSpeed = Value
    end    
})

player.CharacterAdded:Connect(function()
	if isFlying then
		task.wait(1)
		if FlyToggle.Value then
			enableFly()
		end
	end
end)

PlayerTab:AddSection({
    Name = "Other Settings"
})

local InfiniteJumpEnabled = false

game:GetService("UserInputService").JumpRequest:Connect(function()
	if InfiniteJumpEnabled then
		game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
	end
end)

PlayerTab:AddToggle({
	Name = "Infinite Jump",
	Default = false,
	Callback = function(Value)
		InfiniteJumpEnabled = Value
	end    
})

PlayerTab:AddToggle({
    Name = "NoClip",
    Default = false,
    Callback = function(v)
        _G.NoClip = v
        
        if _G.NoClip then
            spawn(function()
                while _G.NoClip do
                    for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then 
                            part.CanCollide = false 
                        end
                    end
                    task.wait()
                end
                
                for _, part in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then 
                        part.CanCollide = true 
                    end
                end
            end)
        end
    end
})

spinbotEnabled = false
spinbotSpeed = 25
local spinbotConnection

PlayerTab:AddToggle({
    Name = "Spinbot",
    Default = false,
    Callback = function(value)
        spinbotEnabled = value
        
        if spinbotEnabled then
            spinbotConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if spinbotEnabled then
                    local character = game.Players.LocalPlayer.Character
                    if character then
                        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart then
                            local currentCFrame = humanoidRootPart.CFrame
                            local newCFrame = currentCFrame * CFrame.Angles(0, math.rad(spinbotSpeed), 0)
                            humanoidRootPart.CFrame = newCFrame
                        end
                    end
                end
            end)
        else
            if spinbotConnection then
                spinbotConnection:Disconnect()
                spinbotConnection = nil
            end
        end
    end
})

PlayerTab:AddSlider({
    Name = "Spinbot Speed",
    Min = 1,
    Max = 100,
    Default = 25,
    Increment = 1,
    Suffix = " Speed",
    Callback = function(value)
        spinbotSpeed = value
    end
})

TrollingTab:AddSection({
    Name = "Fling"
})

PlayerService = game:GetService("Players")
RunService = game:GetService("RunService")
LocalPlayer = PlayerService.LocalPlayer
WalkFlingActive = false
WalkFlingTask = nil
VerticalVelocity = math.random(40, 60)

TrollingTab:AddToggle({
    Name = "Walk Fling",
    Default = false,
    Callback = function(Value)
        WalkFlingActive = Value
        
        if Value then
            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
            
            if humanoid then
                humanoid.Died:Connect(function()
                    WalkFlingActive = false
                    if WalkFlingTask then
                        task.cancel(WalkFlingTask)
                        WalkFlingTask = nil
                    end
                    
                    local hrp = character and character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for i = 1, 10 do
                            hrp.Velocity = hrp.Velocity * 0.2
                            RunService.Heartbeat:Wait()
                        end
                        hrp.Anchored = true
                        hrp.Velocity = Vector3.zero
                        task.wait(0.1)
                        hrp.Anchored = false
                        task.wait()
                        hrp.Velocity = Vector3.zero
                        task.wait()
                        hrp.Velocity = Vector3.zero
                    end
                    
                    OrionLib:MakeNotification({
                        Name = "Walk Fling",
                        Content = "Walk Fling Disabled",
                        Time = 5
                    })
                end)
            end
            
            WalkFlingTask = task.spawn(function()
                VerticalVelocity = math.random(40, 60)
                while WalkFlingActive do
                    local character = LocalPlayer.Character
                    
                    if not (character and character.HumanoidRootPart) then
                        task.wait()
                    else
                        local hrp = character.HumanoidRootPart
                        local currentVelocity = hrp.Velocity
                        
                        if currentVelocity.Magnitude > 0 then
                            hrp.Velocity = currentVelocity.Unit * 99999 + Vector3.new(math.random(50000, 100000), 99999999, math.random(50000, 100000))
                        else
                            hrp.Velocity = Vector3.new(math.random(50000, 100000), 99999999, math.random(50000, 100000))
                        end
                        
                        RunService.RenderStepped:Wait()
                        hrp.Velocity = currentVelocity
                        RunService.Stepped:Wait()
                        hrp.Velocity = currentVelocity + Vector3.new(0, VerticalVelocity, 0)
                        
                        VerticalVelocity = -VerticalVelocity
                        task.wait()
                    end
                end
            end)
        else
            if WalkFlingTask then
                task.cancel(WalkFlingTask)
                WalkFlingTask = nil
            end
            
            local character = LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                for i = 1, 10 do
                    hrp.Velocity = hrp.Velocity * 0.2
                    RunService.Heartbeat:Wait()
                end
                hrp.Anchored = true
                hrp.Velocity = Vector3.zero
                task.wait(0.1)
                hrp.Anchored = false
                task.wait()
                hrp.Velocity = Vector3.zero
                task.wait()
                hrp.Velocity = Vector3.zero
            end
        end
    end
})

TrollingTab:AddSection({
    Name = "Vehicle Trolling"
})

local mouse = Players.LocalPlayer:GetMouse()
local aktiv = false

TrollingTab:AddToggle({
    Name = "Enter Locked Vehicles (Left Mouse click)",
    Default = false,
    Callback = function(val)
        aktiv = val
    end
})

local function findVehicleModel(target)
    local vehiclesFolder = workspace:FindFirstChild("Vehicles")
    if not vehiclesFolder then return nil end

    local obj = target
    while obj do
        if obj.Parent == vehiclesFolder then
            return obj
        end
        obj = obj.Parent
    end
    return nil
end

mouse.Button1Down:Connect(function()
    if not aktiv then return end
    local target = mouse.Target
    if not target then return end

    local character = Players.LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end

    local model = findVehicleModel(target)
    if not model then return end

    local foundSeat = nil

    for _, obj in ipairs(model:GetDescendants()) do
        if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
            local name = obj.Name:lower()
            if name:find("beifahrer") or name:find("passenger") or name:find("copilot") then
                foundSeat = obj
                break
            end
        end
    end

    if not foundSeat then
        for _, obj in ipairs(model:GetDescendants()) do
            if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
                if not obj.Occupant then
                    foundSeat = obj
                    break
                end
            end
        end
    end

    if foundSeat then
        foundSeat.Locked = false
        hrp.CFrame = foundSeat.CFrame + Vector3.new(0, 3, 0)
        task.wait(0.15)
        foundSeat:Sit(humanoid)
    end
end)

jumpKey = Enum.KeyCode.L

function JumpVehicle()
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local vehiclesFolder = workspace:FindFirstChild("Vehicles")
	if not vehiclesFolder then return end

	local vehicle = vehiclesFolder:FindFirstChild(player.Name)
	if not vehicle or not vehicle:IsA("Model") then return end

	local seat = vehicle:FindFirstChild("DriveSeat") or vehicle:FindFirstChildWhichIsA("VehicleSeat")
	if not seat then return end

	if not vehicle.PrimaryPart then
		vehicle.PrimaryPart = seat
	end

	local body = vehicle.PrimaryPart
	body.AssemblyLinearVelocity = (body.CFrame.LookVector + Vector3.new(0, 1.4, 0)).Unit * jumpPower
	body.AssemblyAngularVelocity = Vector3.zero
end

TrollingTab:AddSlider({
	Name = "Jump Power",
	Min = 0,
	Max = 300,
	Default = 150,
	Increment = 10,
	ValueName = "Power",
	Callback = function(value)
		jumpPower = value
	end
})

TrollingTab:AddBind({
	Name = "Jump Keybind",
	Default = Enum.KeyCode.L,
	Hold = false,
	Callback = function(key)
		JumpVehicle()
	end
})

TrollingTab:AddButton({
	Name = "Jump Vehicle",
	Callback = JumpVehicle
})

LocalPlayer = game:GetService("Players").LocalPlayer

TrollingTab:AddButton({
    Name = "Vehicle Backflip",
    Callback = function()
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        
        if Humanoid and Humanoid.Sit and Humanoid.SeatPart and Humanoid.SeatPart.Name == "DriveSeat" then
            local Seat = Humanoid.SeatPart
            local VehicleModel = Seat.Parent
            
            if VehicleModel then
                local VehicleBody = VehicleModel.PrimaryPart or (VehicleModel:FindFirstChild("Body") and (VehicleModel.Body:FindFirstChild("Body") or VehicleModel.Body:FindFirstChild("Base")))
                
                if VehicleBody then
                    local IsElectricScooter = VehicleModel:GetAttribute("Model") == "Electric Scooter"
                    local RightVector = VehicleBody.CFrame.RightVector
                    
                    VehicleBody.AssemblyLinearVelocity = Vector3.new(VehicleBody.AssemblyLinearVelocity.X, 98, VehicleBody.AssemblyLinearVelocity.Z)
                    
                    task.wait(0.35)
                    
                    local FlipForce = IsElectricScooter and 45 or 35
                    VehicleBody.AssemblyAngularVelocity = RightVector * FlipForce
                end
            end
        else
            OrionLib:Notify({
                Title = "Error",
                Content = "Please get inside a vehicle (as driver) to permit action",
                Duration = 5,
                Image = "triangle-alert"
            })
        end
    end
})

TweenService = game:GetService("TweenService")
LocalPlayer = game.Players.LocalPlayer
Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
Humanoid = Character:WaitForChild("Humanoid")

VehicleCooldown = false
CurrentVehicle = nil

TrollingTab:AddButton({
    Name = "Boost Vehicle Into Air",
    Callback = function()
        if VehicleCooldown then
            OrionLib:Notify({
                Title = "Error!",
                Content = "You are on cooldown.",
                Duration = 5,
            })
            return
        end

        local Seat = Humanoid.SeatPart
        if Seat and Seat:IsA("VehicleSeat") or (Seat and Seat.Name == "DriveSeat") then
            CurrentVehicle = Seat.Parent
            local MassPart = CurrentVehicle.Body:FindFirstChild("Mass")

            if CurrentVehicle and MassPart then
                VehicleCooldown = true
                local Springs = {}
                local OriginalLengths = {}

                for _, Child in pairs(Seat:GetChildren()) do
                    if Child:IsA("SpringConstraint") and Child.Name:find("Spring") then
                        table.insert(Springs, Child)
                        OriginalLengths[Child] = Child.FreeLength
                    end
                end

                if #Springs ~= 0 then
                    local ChargeSound = Instance.new("Sound")
                    ChargeSound.SoundId = "rbxassetid://321962524"
                    ChargeSound.Parent = Seat
                    ChargeSound.Volume = 7

                    for i = 1, 3 do
                        ChargeSound:Play()
                        for _, Spring in pairs(Springs) do
                            TweenService:Create(Spring, TweenInfo.new(2.8, Enum.EasingStyle.Linear), {
                                FreeLength = 0.7
                            }):Play()
                        end
                        task.wait(1)
                    end

                    for _, Spring in pairs(Springs) do
                        TweenService:Create(Spring, TweenInfo.new(0.02, Enum.EasingStyle.Linear), {
                            FreeLength = 3
                        }):Play()
                    end

                    task.wait(0.25)

                    local LaunchSound = Instance.new("Sound")
                    LaunchSound.SoundId = "rbxassetid://262562442"
                    LaunchSound.Volume = 20
                    LaunchSound.Parent = MassPart
                    LaunchSound.PlayOnRemove = true
                    LaunchSound:Play()

                    task.wait(0.1)

                    local OldCFrame = MassPart.CFrame
                    MassPart.AssemblyLinearVelocity = Vector3.new(12, 0, 8)

                    MassPart.CFrame = CFrame.new(OldCFrame.Position.X, 100, OldCFrame.Position.Z)
                    MassPart.CFrame = CFrame.new(OldCFrame.Position.X, 3285, OldCFrame.Position.Z)

                    task.wait(1)

                    for _, Spring in pairs(Springs) do
                        Spring.FreeLength = OriginalLengths[Spring]
                    end

                    task.wait(5)
                    VehicleCooldown = false
                    ChargeSound:Destroy()
                    LaunchSound:Destroy()
                else
                    warn("No springs found!")
                end
            else
                OrionLib:Notify({
                    Title = "Error!",
                    Content = "Couldn't find PrimaryPart (Mass)",
                    Duration = 5,
                })
            end
        else
            OrionLib:Notify({
                Title = "Error",
                Content = "Please get inside a vehicle (as driver) to permit action",
                Duration = 5,
            })
        end
    end
})

local animations = {
    ["Helicopter"] = 95301257497525,
    ["Default Dance"] = 88455578674030,
    ["Sit"] = 97185364700038,
    ["Take The L"] = 78653596566468,
    ["Tank"] = 94915612757079,
    ["Vehicle"] = 108747312576405,
    ["Backflip"] = 131205329995035,
    ["Hover Board"] = 100663712757148,
    ["Skibidi Toilet"] = 127154705636043,
    ["Wedsnesday"] = 93497729736287,
    ["Frog"] = 87025086742503,
    ["Slickback"] = 74288964113793
}

LocalPlayer.CharacterAdded:Connect(LoadAnimations)

AnimationTab:AddSection({
    Name = "Emotes"
})

AnimationTab:AddDropdown({
    Name = "Select Animation",
    Default = "",
    Options = {"Helicopter", "Default Dance", "Sit", "Take The L", "Tank", "Vehicle", "Backflip", "Hover Board", "Skibidi Toilet", "Wednesday", "Frog", "Slickback" },
    Callback = function(value)
        selectedAnimation = value
    end
})

AnimationTab:AddToggle({
    Name = "Play Animation",
    Default = false,
    Callback = function(isOn)
        AnimationEnabled = isOn
        if isOn then
            if currentTrack then
                currentTrack:Stop()
            end
            local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local Humanoid = Character:WaitForChild("Humanoid")
            local Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. animations[selectedAnimation]
            currentTrack = Animator:LoadAnimation(anim)
            currentTrack:Play()
        else
            if currentTrack then
                currentTrack:Stop()
            end
        end
    end
})

AnimationTab:AddSection({
    Name = "Animations"
})

jerkOffActive = false
jerkOffAnimation = nil
animationTrack = nil

timePositionValue = 3
animationSpeedValue = 1

AnimationTab:AddToggle({
    Name = "Jerk Off Toggle",
    Default = false,
    Callback = function(Value)
        if Value then
            if jerkOffActive then
                return
            end
            
            jerkOffActive = true
            
            jerkOffAnimation = Instance.new("Animation")
            jerkOffAnimation.AnimationId = "rbxassetid://698251653"
            
            local player = game.Players.LocalPlayer
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            
            if humanoid then
                animationTrack = humanoid:LoadAnimation(jerkOffAnimation)
                
                task.spawn(function()
                    while jerkOffActive do
                        animationTrack:Play()
                        animationTrack:AdjustSpeed(animationSpeedValue)
                        animationTrack.TimePosition = timePositionValue
                        
                        task.wait(0.1)
                        
                        while animationTrack.TimePosition < timePositionValue do
                            task.wait(0.1)
                        end
                        
                        animationTrack:Stop()
                    end
                end)
            end
        else
            jerkOffActive = false
            
            if jerkOffAnimation and animationTrack then
                jerkOffAnimation:Destroy()
                animationTrack:Destroy()
                jerkOffAnimation = nil
                animationTrack = nil
            end
        end
    end    
})

AnimationTab:AddSlider({
    Name = "Jerk Off Time Position",
    Min = 0.1,
    Max = 0.6,
    Default = 3,
    Increment = 0.1,
    ValueName = "TimePosition",
    Callback = function(Value)
        timePositionValue = Value
    end    
})

AnimationTab:AddSlider({
    Name = "Jerk Off Speed",
    Min = 0.2,
    Max = 3.0,
    Default = 1,
    Increment = 0.1,
    ValueName = "Speed",
    Callback = function(Value)
        animationSpeedValue = Value
    end    
})

AnimationTab:AddSection({
    Name = "Emergency Hamburg"
})

AnimationTab:AddToggle({
    Name = "Fake Dead",
    Default = false,
    Callback = function(enabled)
        player = game.Players.LocalPlayer
        character = player.Character

        if character and character:FindFirstChild("HumanoidRootPart") then
            character:SetAttribute("Tased", enabled)
        end
    end
})

local CarFlySettings = {
    Enabled = false,
    Speed = 50,
    SafeFly = true,
    VehicleFling = false
}

local isFlightActive = false
local flightSpeedMultiplier = 1

local kmhToSpeed = 7.77
local flightSpeed = CarFlySettings.Speed * kmhToSpeed
local POSITION_LERP_ALPHA = 0.3
local ROTATION_LERP_ALPHA = 0.2
local lastCarPosition = nil
local lastCarLookVector = nil
local straightFlightStartTime = nil
local hasShiftedRight = false
local flingStartTime = 0
local FLING_DELAY = 0.6
local hasPerformedSingleExit = false
local singleExitCompleted = false
local singleExitTimerStarted = false
local safeFlyConnection = nil
local autoEnterConnection = nil
local lastForceEnterTime = 0
local FORCE_ENTER_COOLDOWN = 0.2
local MAX_ENTER_ATTEMPTS = 3
local currentEnterAttempts = 0
local isEnteringVehicle = false
local stablePosition = nil
local lastStableTime = tick()
local STABLE_POSITION_THRESHOLD = 5
local STABLE_TIME_REQUIRED = 0.5

local function enterVehicle()
    if not CarFlySettings.SafeFly or not CarFlySettings.Enabled then return false end
    if isEnteringVehicle then return false end
    
    isEnteringVehicle = true
    local success = false
    
    pcall(function()
        local vehicles = Workspace:FindFirstChild("Vehicles")
        if not vehicles then 
            isEnteringVehicle = false
            return false 
        end
        
        local vehicle = vehicles:FindFirstChild(LocalPlayer.Name)
        if vehicle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            local seat = vehicle:FindFirstChild("DriveSeat") or vehicle:FindFirstChildWhichIsA("VehicleSeat")
            
            if seat and humanoid then
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = seat.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.05)
                    humanoid.Sit = false
                    task.wait(0.05)
                    seat:Sit(humanoid)
                    task.wait(0.05)
                    if humanoid.SeatPart == seat then
                        success = true
                        currentEnterAttempts = 0
                        stablePosition = vehicle.PrimaryPart and vehicle.PrimaryPart.Position
                        lastStableTime = tick()
                    end
                end
            end
        end
    end)
    
    isEnteringVehicle = false
    return success
end

local function performSingleExit()
    if singleExitCompleted or not CarFlySettings.SafeFly or not CarFlySettings.Enabled or CarFlySettings.VehicleFling then
        return
    end
    
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum and hum.SeatPart and hum.SeatPart.Name == "DriveSeat" then
        hasPerformedSingleExit = true
        hum.Sit = false
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
        
        task.delay(0.5, function()
            if CarFlySettings.SafeFly and CarFlySettings.Enabled and not CarFlySettings.VehicleFling then
                enterVehicle()
                singleExitCompleted = true
            end
        end)
    end
end

local function monitorVehicle()
    if vehicleMonitorConnection then return end
    
    vehicleMonitorConnection = RunService.Heartbeat:Connect(function()
        if CarFlySettings.SafeFly and CarFlySettings.Enabled and not CarFlySettings.VehicleFling then
            local character = LocalPlayer.Character
            if not character then return end
            
            local humanoid = character:FindFirstChild("Humanoid")
            if not humanoid then return end
            
            local currentTime = tick()
            local seat = humanoid.SeatPart

            if seat and seat:IsA("VehicleSeat") then
                local vehicle = seat.Parent
                if vehicle and vehicle:IsA("Model") then
                    if vehicle.PrimaryPart then
                        local currentPos = vehicle.PrimaryPart.Position
                        if stablePosition then
                            local movement = (currentPos - stablePosition).Magnitude
                            if movement < STABLE_POSITION_THRESHOLD then
                                if (currentTime - lastStableTime) > STABLE_TIME_REQUIRED then
                                end
                            else
                                stablePosition = currentPos
                                lastStableTime = currentTime
                            end
                        else
                            stablePosition = currentPos
                            lastStableTime = currentTime
                        end
                    end

                    for _, part in pairs(vehicle:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.AssemblyLinearVelocity = Vector3.zero
                            part.AssemblyAngularVelocity = Vector3.zero
                        end
                    end
                end
            end

            if not seat or seat.Name ~= "DriveSeat" then
                if (currentTime - lastForceEnterTime) > FORCE_ENTER_COOLDOWN then
                    lastForceEnterTime = currentTime
                    currentEnterAttempts = currentEnterAttempts + 1
                    
                    if currentEnterAttempts <= MAX_ENTER_ATTEMPTS then
                        task.spawn(function()
                            enterVehicle()
                        end)
                    else
                        currentEnterAttempts = 0
                        task.wait(1)
                    end
                end
            else
                currentEnterAttempts = 0
            end
        end
    end)
end

local function startAutoEnter()
    if autoEnterConnection then return end
    
    autoEnterConnection = RunService.Heartbeat:Connect(function()
        if CarFlySettings.SafeFly and CarFlySettings.Enabled and not CarFlySettings.VehicleFling then
            local character = LocalPlayer.Character
            if not character then return end
            
            local humanoid = character:FindFirstChild("Humanoid")
            if not humanoid then return end

            if not humanoid.SeatPart or humanoid.SeatPart.Name ~= "DriveSeat" then
                local vehicles = Workspace:FindFirstChild("Vehicles")
                if vehicles then
                    local vehicle = vehicles:FindFirstChild(LocalPlayer.Name)
                    
                    if vehicle then
                        local seat = vehicle:FindFirstChild("DriveSeat") or vehicle:FindFirstChildWhichIsA("VehicleSeat")
                        if seat then
                            local hrp = character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local targetPos = seat.Position + Vector3.new(0, 3, 0)
                                local currentPos = hrp.Position
                                local distance = (targetPos - currentPos).Magnitude
                                
                                if distance > 10 then
                                    hrp.CFrame = CFrame.new(targetPos)
                                else
                                    hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(targetPos), 0.3)
                                end
                                
                                task.wait(0.05)
                                
                                if not humanoid.SeatPart then
                                    humanoid.Sit = false
                                    task.wait(0.05)
                                    seat:Sit(humanoid)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function stopAutoEnter()
    if autoEnterConnection then
        autoEnterConnection:Disconnect()
        autoEnterConnection = nil
    end
    if vehicleMonitorConnection then
        vehicleMonitorConnection:Disconnect()
        vehicleMonitorConnection = nil
    end
    currentEnterAttempts = 0
    isEnteringVehicle = false
    stablePosition = nil
end

local function startSafeFly()
    if safeFlyConnection then return end
    
    safeFlyConnection = RunService.Heartbeat:Connect(function()
        if CarFlySettings.SafeFly and CarFlySettings.Enabled and not CarFlySettings.VehicleFling then
            local character = LocalPlayer.Character
            if not character then return end
            
            local humanoid = character:FindFirstChild("Humanoid")
            if not humanoid then return end

            if humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat") then
                local seat = humanoid.SeatPart
                local vehicle = seat.Parent
                
                if vehicle and vehicle:IsA("Model") then
                    if vehicle.PrimaryPart then
                        local currentRot = vehicle.PrimaryPart.Orientation
                        if math.abs(currentRot.X) > 45 or math.abs(currentRot.Z) > 45 then
                            vehicle.PrimaryPart.Orientation = Vector3.new(0, currentRot.Y, 0)
                        end
                    end
                end
            end
        end
    end)
    
    monitorVehicle()
end

local function stopSafeFly()
    if safeFlyConnection then
        safeFlyConnection:Disconnect()
        safeFlyConnection = nil
    end
    stopAutoEnter()
    hasPerformedSingleExit = false
    singleExitCompleted = false
    singleExitTimerStarted = false
end

local function updateFlightState()
    if CarFlySettings.Enabled then
        startSafeFly()
        startAutoEnter()
    else
        stopSafeFly()
    end
end

local function turncaroff()
    local vehiclesFolder = Workspace:FindFirstChild("Vehicles")
    if vehiclesFolder then
        local playerVehicle = vehiclesFolder:FindFirstChild(LocalPlayer.Name)
        if playerVehicle and playerVehicle:IsA("Model") then
            playerVehicle:SetAttribute("IsOn", false)
            local humanoid = playerVehicle:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.MaxHealth = 500
                humanoid.Health = 500
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if CarFlySettings.VehicleFling then
        local c = LocalPlayer.Character
        if c then
            local h = c:FindFirstChildOfClass("Humanoid")
            if h and h.SeatPart and h:GetState() == Enum.HumanoidStateType.Seated then
                local currentTime = tick()
                if (currentTime - flingStartTime) >= FLING_DELAY then
                    local hrp = c:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, part in pairs(hrp:GetTouchingParts()) do
                            if part:IsA("BasePart") and part:IsDescendantOf(Workspace) and not part:IsDescendantOf(LocalPlayer) then
                                hrp.AssemblyLinearVelocity = -(part.Position - hrp.Position).Unit * 9999999
                                turncaroff()
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    local character = LocalPlayer.Character
    if CarFlySettings.VehicleFling then CarFlySettings.Enabled = true end
    
    if CarFlySettings.Enabled and character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.SeatPart and humanoid.SeatPart.Name == "DriveSeat" then
            local seat = humanoid.SeatPart
            local vehicle = seat.Parent
            if not vehicle.PrimaryPart then vehicle.PrimaryPart = seat end

            local lookVector = Camera.CFrame.LookVector
            local rightVector = Camera.CFrame.RightVector
            
            if not lastCarPosition then lastCarPosition = vehicle.PrimaryPart.Position end
            if not lastCarLookVector then lastCarLookVector = lookVector end

            local moveDirection = Vector3.new()

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + lookVector
            elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - lookVector
            end

            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - rightVector
            elseif UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + rightVector
            end

            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.E) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end

            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit
            end

            local speedMultiplier = flightSpeed / 100
            local targetPosition = vehicle.PrimaryPart.Position + (moveDirection * speedMultiplier)

            local smoothLerp = CarFlySettings.SafeFly and 0.2 or POSITION_LERP_ALPHA
            local newPosition = lastCarPosition:Lerp(targetPosition, smoothLerp)
            local smoothLookVector = lastCarLookVector:Lerp(lookVector, ROTATION_LERP_ALPHA)

            if moveDirection.Magnitude > 0 then
                local targetCFrame = CFrame.new(newPosition, newPosition + smoothLookVector)
                vehicle:SetPrimaryPartCFrame(targetCFrame)
            else
                local targetCFrame = CFrame.new(vehicle.PrimaryPart.Position, vehicle.PrimaryPart.Position + smoothLookVector)
                vehicle:SetPrimaryPartCFrame(targetCFrame)
            end
            
            lastCarPosition = newPosition
            lastCarLookVector = smoothLookVector

            if CarFlySettings.SafeFly then
                for _, part in pairs(vehicle:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.AssemblyLinearVelocity = Vector3.zero
                        part.AssemblyAngularVelocity = Vector3.zero
                    end
                end
            end
        else
            lastCarPosition = nil
            lastCarLookVector = nil
            straightFlightStartTime = nil
            hasShiftedRight = false
        end
    else
        lastCarPosition = nil
        lastCarLookVector = nil
        straightFlightStartTime = nil
        hasShiftedRight = false
    end
end)

VehicleTab:AddSection({
    Name = "Vehicle Features"
})

vehicleFlingEnabled = false
flingActive = false
flingStartTime = 0
FLING_DELAY = 0.6

RunService.Heartbeat:Connect(function()
    if vehicleFlingEnabled then
        local player = game.Players.LocalPlayer
        local c = player.Character
        if c then
            local h = c:FindFirstChildOfClass("Humanoid")
            if h and h.SeatPart and h:GetState() == Enum.HumanoidStateType.Seated then
                flingActive = true

                local currentTime = tick()
                if (currentTime - flingStartTime) >= FLING_DELAY then
                    local hrp = c:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, part in pairs(hrp:GetTouchingParts()) do
                            if part:IsA("BasePart") and part:IsDescendantOf(workspace) and not part:IsDescendantOf(player) then
                                hrp.AssemblyLinearVelocity = -(part.Position - hrp.Position).Unit * 9999999
                                turncaroff()
                                break
                            end
                        end
                    end
                end
            else
                flingActive = false
            end
        else
            flingActive = false
        end
    else
        flingActive = false
    end
end)

VehicleTab:AddToggle({
    Name = "Vehicle Fling (Only use if car fly is enabled)",
    Default = false,
    Callback = function(value)
        vehicleFlingEnabled = value
        if value then
            flightEnabled = true
            flingStartTime = tick()
            updateFlightState()
            startAutoEnter()
        else
            stopAutoEnter()
        end
    end
})

VehicleTab:AddToggle({
    Name = "Car Fly",
    Default = false,
    Callback = function(Value)
        CarFlySettings.Enabled = Value
        isFlightActive = CarFlySettings.Enabled
        flightSpeedMultiplier = (CarFlySettings.Speed / (UserInputService.TouchEnabled and 20 or 100)) / 10
        updateFlightState()
        if CarFlySettings.Enabled then
            startAutoEnter()
        else
            stopAutoEnter()
        end
    end
})

VehicleTab:AddBind({
    Name = "Car Fly Keybind",
    Default = Enum.KeyCode.X,
    Hold = false,
    Callback = function()
        CarFlySettings.Enabled = not CarFlySettings.Enabled
        isFlightActive = CarFlySettings.Enabled
        flightSpeedMultiplier = (CarFlySettings.Speed / (UserInputService.TouchEnabled and 20 or 100)) / 10
        updateFlightState()
        if CarFlySettings.Enabled then
            startAutoEnter()
        else
            stopAutoEnter()
        end
    end    
})

VehicleTab:AddSlider({
    Name = "Car Fly Speed",
    Min = 10,
    Max = 200,
    Default = 130,
    Increment = 10,
    ValueName = "Speed",
    Callback = function(Value)
        CarFlySettings.Speed = Value
        flightSpeed = Value * kmhToSpeed
        flightSpeedMultiplier = (Value / (UserInputService.TouchEnabled and 20 or 100)) / 10
    end    
})

Players.LocalPlayer.CharacterAdded:Connect(function(character)
    CarFlySettings.Enabled = false
    isFlightActive = false
    lastCarPosition = nil
    lastCarLookVector = nil
    hasPerformedSingleExit = false
    singleExitCompleted = false
    singleExitTimerStarted = false
    
    task.wait(1)
    updateFlightState()
    stopAutoEnter()
    
    if CarFlySettings.SafeFly and CarFlySettings.Enabled then
        startAutoEnter()
    end
end)

VehicleTab:AddSection({
    Name = "Duplicate"
})

VehicleTab:AddButton({
    Name = "Duplicate Current Car",
    Callback = function()
        local originalCar = workspace.Vehicles:FindFirstChild(LocalPlayer.Name)
        if not originalCar then
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "No Vehicle found!",
                Time = 3
            })
            return
        end

        local clone = originalCar:Clone()
        clone.Name = LocalPlayer.Name .. "Clone" .. math.random(1000, 9999)

        local offset = 10
        local newPosition = originalCar:GetPivot().Position + Vector3.new(offset, 0, 0)
        clone:PivotTo(CFrame.new(newPosition))
        clone.Parent = workspace.Vehicles

        OrionLib:MakeNotification({
            Name = "Success",
            Content = "From VentyDevs",
            Time = 3
        })
    end
})

VehicleTab:AddSection({
    Name = "Vehicle Customization"
})

local function setCarColor(selectedColor)
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end

    local vehicle = nil
    if char:FindFirstChild("Humanoid") and char.Humanoid.SeatPart then
        vehicle = char.Humanoid.SeatPart:FindFirstAncestorOfClass("Model")
    end

    if vehicle then
        for _, part in pairs(vehicle:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Name == "Body" or part.Name == "Paint" or part.Name == "Color" then
                    part.Color = selectedColor
                end
            end
        end
    end
end

VehicleTab:AddColorpicker({
    Name = "Change Vehicle Color",
    Callback = function(Value)
        setCarColor(Value)
    end      
})

local VehiclesFolder = workspace:WaitForChild("Vehicles") 
sliderMoved = false

VehicleTab:AddSlider({ 
    Name = "Vehicle Height",
    Min = 0.5,
    Max = 13,
    Default = 1,
    Increment = 0.1,
    ValueName = "",
    Callback = function(Value)
        if not sliderMoved then
            sliderMoved = true
            return
        end

        pcall(function()
            local vehicle = VehiclesFolder:FindFirstChild(LocalPlayer.Name)
            if not vehicle then return end

            local driveSeat = vehicle:FindFirstChild("DriveSeat", true)
            if not driveSeat then return end

            for _, v in pairs(driveSeat:GetChildren()) do
                if v:IsA("SpringConstraint") then
                    v.LimitsEnabled = true
                    v.MinLength = Value
                    v.MaxLength = Value
                elseif v:IsA("RopeConstraint") then
                    v.Length = Value
                end
            end
        end)
    end    
})

VehicleTab:AddSection({
    Name = "Vehicle Mods"
})

local isJumping = false
local jumpInterval = 1

VehicleTab:AddToggle({
    Name = "Maybach Jumping",
    Default = false,
    Callback = function(state)
        isJumping = state
        
        if isJumping then
            task.spawn(function()
                local toggleHeight = true
                
                while isJumping do
                    local character = player.Character
                    local humanoid = character and character:FindFirstChild("Humanoid")
                    local seat = humanoid and humanoid.SeatPart

                    if not seat or not seat:IsA("Seat") then 
                        isJumping = false
                        break 
                    end

                    local springs = {}
                    for _, child in pairs(seat:GetChildren()) do
                        if child:IsA("SpringConstraint") and child.Name:find("Spring") then
                            table.insert(springs, child)
                        end
                    end

                    local targetLength = toggleHeight and 2.6 or 1.65
                    toggleHeight = not toggleHeight

                    for _, spring in pairs(springs) do
                        TweenService:Create(spring, TweenInfo.new(jumpInterval, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                            FreeLength = targetLength
                        }):Play()
                    end

                    task.wait(jumpInterval)
                end
            end)
        end
    end
})

VehicleTab:AddSlider({
    Name = "Jump Speed",
    Min = 0.1,
    Max = 2,
    Default = 1,
    Increment = 0.01,
    ValueName = "sec",
    Callback = function(value)
        jumpInterval = value
    end
})

VehicleTab:AddSection({
    Name = "Drifting"
})

getgenv().DriftBoostData = getgenv().DriftBoostData or {}
driftData = getgenv().DriftBoostData

VehicleTab:AddToggle({
    Name = "Drift Boost",
    Default = false,
    Callback = function(enabled)
        if not driftData.init then
            driftData.changed = {}
            driftData.wheels = {}
            driftData.op = OverlapParams.new()
            driftData.op.FilterType = Enum.RaycastFilterType.Exclude
            driftData.init = true
        end

        if enabled then
            if not driftData.connection then
                driftData.connection = game:GetService("RunService").RenderStepped:Connect(function()
                    vehicle = workspace:FindFirstChildWhichIsA("Model")
                    if not vehicle then return end

                    basePart = vehicle.PrimaryPart or vehicle:FindFirstChildWhichIsA("BasePart")
                    if not basePart then return end

                    driftData.op.FilterDescendantsInstances = {vehicle}
                    nearbyParts = workspace:GetPartBoundsInRadius(basePart.Position, 13, driftData.op)

                    current = {}

                    for _, part in ipairs(nearbyParts) do
                        if part:IsA("BasePart") and not part:IsDescendantOf(vehicle) then
                            if not driftData.changed[part] then
                                driftData.changed[part] = part.Material
                                part.Material = Enum.Material.Ice
                            end
                            current[part] = true
                        end
                    end

                    for part, oldMat in pairs(driftData.changed) do
                        if not current[part] and part.Parent then
                            part.Material = oldMat
                            driftData.changed[part] = nil
                        end
                    end
                end)
            end
        else
            for part, oldMat in pairs(driftData.changed) do
                if part and part.Parent then
                    part.Material = oldMat
                end
            end
            driftData.changed = {}

            if driftData.connection then
                driftData.connection:Disconnect()
                driftData.connection = nil
            end
        end
    end
})

VehicleTab:AddSection({
    Name = "Special Mods"
})

VehicleTab:AddToggle({
    Name = "Vehicle Godmode",
    Default = false,
    Callback = function(Value)
        if Value then
            task.spawn(function()
                while Value do
                    pcall(function()
                        local vehiclesFolder = workspace:FindFirstChild("Vehicles")
                        if vehiclesFolder then
                            local playerVehicle = vehiclesFolder:FindFirstChild(LocalPlayer.Name)
                            if playerVehicle and playerVehicle:IsA("Model") then
                                if RemoteEvents.VehicleRemotes.Repair then
                                    SafeFireRemote(RemoteEvents.VehicleRemotes.Repair, playerVehicle)
                                end
                                playerVehicle:SetAttribute("IsOn", true)
                                playerVehicle:SetAttribute("currentHealth", 1000)
                                local humanoid = playerVehicle:FindFirstChildOfClass("Humanoid")
                                if humanoid then
                                    humanoid.MaxHealth = 1000
                                    humanoid.Health = 1000
                                end
                            end
                        end
                    end)
                    task.wait(2)
                end
            end)
        end
    end
})

VehicleTab:AddButton({
    Name = "Enter in own Car",
    Callback = function()
        local function ensurePlayerInVehicle()
            local vehicle = workspace.Vehicles:FindFirstChild(player.Name)  
            if vehicle then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid and not humanoid.SeatPart then 
                    local driveSeat = vehicle:FindFirstChild("DriveSeat")
                    if driveSeat then
                        driveSeat:Sit(humanoid)
                    end
                end
            end
        end
        ensurePlayerInVehicle()
    end
})

VehicleTab:AddButton({
    Name = "Bring own Car",
    Callback = function()
        player = game.Players.LocalPlayer
        character = player.Character or player.CharacterAdded:Wait()
        root = character:WaitForChild("HumanoidRootPart")
        humanoid = character:FindFirstChildWhichIsA("Humanoid")
        vehicle = nil

        vehiclesFolder = workspace:FindFirstChild("Vehicles")
        if vehiclesFolder then
            vehicle = vehiclesFolder:FindFirstChild(player.Name)
        end

        if not vehicle then
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v.Name:lower():find(player.Name:lower()) then
                    vehicle = v
                    break
                end
            end
        end

        if vehicle and vehicle:IsA("Model") then
            seat = vehicle:FindFirstChild("DriveSeat") or vehicle:FindFirstChildWhichIsA("VehicleSeat")
            if seat then
                if not vehicle.PrimaryPart then
                    vehicle.PrimaryPart = seat
                end
                vehicle:SetPrimaryPartCFrame(root.CFrame * CFrame.new(0, 3, -8))
                task.wait(0.2)
                if humanoid and not humanoid.SeatPart then
                    seat:Sit(humanoid)
                end
            end
        end
    end
})

VehicleTab:AddToggle({
    Name = "Infinite Fuel",
    Default = false,
    Callback = function(Value)
        fuelToggle = Value
        task.spawn(function()
            while task.wait() do
                if fuelToggle then
                    local vehiclesFolder = workspace:FindFirstChild("Vehicles")
                    if vehiclesFolder then
                        local playerVehicle = vehiclesFolder:FindFirstChild(LocalPlayer.Name)
                        if playerVehicle and playerVehicle:IsA("Model") then
                            playerVehicle:SetAttribute("currentFuel", math.huge)
                        end
                    end
                end
            end
        end)
    end
})

VehicleTab:AddTextbox({
    Name = "Numberplate Text",
    Default = "Void Menu",
    TextDisappear = false,
    Callback = function(txt)
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("SurfaceGui") and part.Parent:IsA("BasePart") then
                local dist = root and (part.Parent.Position - root.Position).Magnitude
                if dist and dist < 15 then
                    local label = part:FindFirstChildWhichIsA("TextLabel")
                    if label then label.Text = txt end
                end
            end
        end
    end
})

local opts = {"Default","V6 Engine","V8 Engine","V10 Engine","Electric Engine","Electric Engine 2","Funny Electric Engine","Mercedes AMG One Engine","Roblox Engine"}
local ids = {
    ["Default"] = {e = "rbxassetid://140685060", d = "rbxassetid://358130654", s = "rbxassetid://144126324"},
    ["V6 Engine"] = {e = "rbxassetid://113404171295712", d = "rbxassetid://2057815938", s = "rbxassetid://96066650287312"},
    ["V8 Engine"] = {e = "rbxassetid://7427073034", d = "rbxassetid://8144394164", s = "rbxassetid://96066650287312"},
    ["V10 Engine"] = {e = "rbxassetid://976645312", d = "rbxassetid://8144394631", s = "rbxassetid://96066650287312"},
    ["Electric Engine"] = {e = "rbxassetid://402899121", d = "rbxassetid://1160914875", s = "rbxassetid://268260239"},
    ["Electric Engine 2"] = {e = "rbxassetid://402899121", d = "rbxassetid://9070018398", s = "rbxassetid://268260239"},
    ["Funny Electric Engine"] = {e = "rbxassetid://402899121", d = "rbxassetid://139592319059397", s = "rbxassetid://268260239"},
    ["Mercedes AMG One Engine"] = {e = "rbxassetid://402899121", d = "rbxassetid://101796349615590", s = "rbxassetid://268260239"},
    ["Roblox Engine"] = {e = "rbxassetid://140685060", d = "rbxassetid://6948077542", s = "rbxassetid://144126324"}
}
local orig = {e={},d={},s={}}

for _,v in pairs(game:GetDescendants()) do
    if v:IsA("Sound") then
        local id = v.SoundId
        if id:match("140685060") then orig.e[v]=id
        elseif id:match("358130654") then orig.d[v]=id
        elseif id:match("144126324") then orig.s[v]=id
        else
            for _,data in pairs(ids) do
                if id:match(data.e:match("%d+")) then orig.e[v]=orig.e[v] or "rbxassetid://140685060" end
                if id:match(data.d:match("%d+")) then orig.d[v]=orig.d[v] or "rbxassetid://358130654" end
                if id:match(data.s:match("%d+")) then orig.s[v]=orig.s[v] or "rbxassetid://144126324" end
            end
        end
    end
end

game.DescendantAdded:Connect(function(v)
    if v:IsA("Sound") then
        local id = v.SoundId
        if id:match("140685060") then orig.e[v]=id
        elseif id:match("358130654") then orig.d[v]=id
        elseif id:match("144126324") then orig.s[v]=id end
    end
end)

VehicleTab:AddDropdown({
    Name = "Engine Sound",
    Default = "Default",
    Options = opts,
    Callback = function(sel)
        local data = ids[sel]
        if sel == "Default" then
            for snd,oid in pairs(orig.e) do if snd and snd.Parent then snd.SoundId=oid end end
            for snd,oid in pairs(orig.d) do if snd and snd.Parent then snd.SoundId=oid end end
            for snd,oid in pairs(orig.s) do if snd and snd.Parent then snd.SoundId=oid end end
        elseif data then
            for snd in pairs(orig.e) do if snd and snd.Parent then snd.SoundId=data.e end end
            for snd in pairs(orig.d) do if snd and snd.Parent then snd.SoundId=data.d end end
            for snd in pairs(orig.s) do if snd and snd.Parent then snd.SoundId=data.s end end
        end
    end
})

VehicleTab:AddSection({
    Name = "Vehicle Boost"
})

local function BoostVehicle()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local vehiclesFolder = workspace:FindFirstChild("Vehicles")
    if not vehiclesFolder then return end

    local vehicle = vehiclesFolder:FindFirstChild(player.Name)
    if not vehicle or not vehicle:IsA("Model") then return end

    local seat = vehicle:FindFirstChild("DriveSeat") or vehicle:FindFirstChildWhichIsA("VehicleSeat")
    if not seat then return end

    if not vehicle.PrimaryPart then
        vehicle.PrimaryPart = seat
    end

    local body = vehicle.PrimaryPart
    local forwardDirection = body.CFrame.LookVector
    body.AssemblyLinearVelocity = forwardDirection.Unit * boostPower
    body.AssemblyAngularVelocity = Vector3.zero
end

VehicleTab:AddSlider({
    Name = "Boost Power",
    Min = 100,
    Max = 2000,
    Default = 100,
    Increment = 50,
    ValueName = "Power",
    Callback = function(value)
        boostPower = value
    end
})

VehicleTab:AddBind({
    Name = "Boost Keybind",
    Default = Enum.KeyCode.I,
    Hold = false,
    Callback = function(key)
        boostKey = key
        BoostVehicle()
    end
})

VehicleTab:AddButton({
    Name = "Boost Vehicle",
    Callback = function()
        BoostVehicle()
    end
})

VehicleTab:AddSection({
    Name = "Performance"
})

VehicleTab:AddToggle({
    Name = "Grip Boost",
    Default = false,
    Callback = function(Value)
        if not getupvalues then
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Grip Boost doesnt Support Executer Like Xeno und Solara",
                Time = 5
            })
            return
        end
        getgenv().GripBoostData = getgenv().GripBoostData or {}
        
        if not getgenv().GripBoostData.isSet then
            local SteeringModule = nil
            
            pcall(function()
                SteeringModule = require(game:GetService("Players").LocalPlayer.PlayerScripts.Code.components.vehicle.carSteering)
            end)

            local SteeringClass = SteeringModule and SteeringModule.CarSteering

            if not (SteeringClass and SteeringClass.handleSteering) then
                OrionLib:MakeNotification({
                    Name = "Error",
                    Content = "Vehicle Module No Found",
                    Time = 3
                })
                return
            end

            local ConfigTable = nil
            for _, upvalue in pairs(getupvalues(SteeringClass.handleSteering)) do
                if type(upvalue) == "table" and upvalue.maxSteeringAngle and upvalue.steeringModifierSpeed then
                    ConfigTable = upvalue
                    break
                end
            end

            if not ConfigTable then return end

            getgenv().GripBoostData.ConfigReference = ConfigTable
            getgenv().GripBoostData.OriginalValues = {
                maxSteeringAngle = ConfigTable.maxSteeringAngle,
                steeringModifierSpeed = ConfigTable.steeringModifierSpeed,
                steeringSpeed = ConfigTable.steeringSpeed,
                steerBackMultiplier = ConfigTable.steerBackMultiplier,
                minSteer = ConfigTable.minSteer
            }
            getgenv().GripBoostData.isSet = true
        end

        local Config = getgenv().GripBoostData.ConfigReference
        local Original = getgenv().GripBoostData.OriginalValues

        if Config then
            if Value then
                Config.maxSteeringAngle = 15
                Config.steeringModifierSpeed = 20
                Config.steeringSpeed = 4
                Config.steerBackMultiplier = 2
                Config.minSteer = 0.07
            else
                Config.maxSteeringAngle = Original.maxSteeringAngle
                Config.steeringModifierSpeed = Original.steeringModifierSpeed
                Config.steeringSpeed = Original.steeringSpeed
                Config.steerBackMultiplier = Original.steerBackMultiplier
                Config.minSteer = Original.minSteer
            end
        end
    end    
})

local accelerationMultiplier = 1
local accelerationEnabled = false
local accelerationConnection = nil

local function getCurrentVehicle()
    local char = LocalPlayer.Character
    if not char then return nil end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if not humanoid or not humanoid.SeatPart then return nil end
    
    local seat = humanoid.SeatPart
    if seat:IsA("VehicleSeat") or seat.Name == "DriveSeat" then
        return seat.Parent
    end
    return nil
end

local function applySmartAcceleration()
    if accelerationConnection then accelerationConnection:Disconnect() end
    
    accelerationConnection = RunService.Heartbeat:Connect(function()
        if not accelerationEnabled then return end
        
        local vehicle = getCurrentVehicle()
        if not vehicle or not vehicle.PrimaryPart then return end
        
        local root = vehicle.PrimaryPart
        local velocity = root.AssemblyLinearVelocity
        local lookVector = root.CFrame.LookVector
        
        local isW = UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up)
        local isS = UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down)
        
        if velocity.Magnitude < 0.1 then return end
        local moveDir = velocity.Unit:Dot(lookVector)
        
        if velocity.Magnitude > 1 then
            if isW and moveDir > -0.2 then
                root.AssemblyLinearVelocity = velocity * (1 + (accelerationMultiplier - 1) * 0.015)
            elseif isS and moveDir < 0.2 then
                root.AssemblyLinearVelocity = velocity * (1 + (accelerationMultiplier - 1) * 0.015)
            end
        end
        
        if (isS and moveDir > 0.3) or (isW and moveDir < -0.3) then
            root.AssemblyLinearVelocity = velocity * 0.94
        end
    end)
end

VehicleTab:AddToggle({
    Name = "Acceleration Boost",
    Default = false,
    Callback = function(value)
        accelerationEnabled = value
        if value then 
            applySmartAcceleration() 
        else 
            if accelerationConnection then accelerationConnection:Disconnect() end 
        end
    end
})

VehicleTab:AddSlider({
    Name = "Acceleration Multiplier",
    Min = 1, 
    Max = 5, 
    Increment = 0.1, 
    Default = 1,
    ValueName = "x",
    Callback = function(value)
        accelerationMultiplier = value
    end
})

VehicleTab:AddSlider({
    Name = "Armor Level",
    Min = 0,
    Max = 6,
    Default = 0,
    Increment = 1,
    Callback = function(Value)
        local vehiclesFolder = workspace:FindFirstChild("Vehicles")
        if vehiclesFolder then
            local playerVehicle = vehiclesFolder:FindFirstChild(LocalPlayer.Name)
            if playerVehicle and playerVehicle:IsA("Model") then
                playerVehicle:SetAttribute("armorLevel", Value)
            end
        end
    end    
})

VehicleTab:AddSlider({
    Name = "Brakes Level",
    Min = 0,
    Max = 6,
    Default = 0,
    Increment = 1,
    Callback = function(Value)
        local vehiclesFolder = workspace:FindFirstChild("Vehicles")
        if vehiclesFolder then
            local playerVehicle = vehiclesFolder:FindFirstChild(LocalPlayer.Name)
            if playerVehicle and playerVehicle:IsA("Model") then
                playerVehicle:SetAttribute("brakesLevel", Value)
            end
        end
    end    
})

VehicleTab:AddSlider({
    Name = "Engine Level",
    Min = 0,
    Max = 6,
    Default = 0,
    Increment = 1,
    Callback = function(Value)
        local vehiclesFolder = workspace:FindFirstChild("Vehicles")
        if vehiclesFolder then
            local playerVehicle = vehiclesFolder:FindFirstChild(LocalPlayer.Name)
            if playerVehicle and playerVehicle:IsA("Model") then
                playerVehicle:SetAttribute("engineLevel", Value)
            end
        end
    end    
})

WeaponTab:AddSection({
    Name = "OG Sniper"
})
WeaponTab:AddToggle({
	Name = "OG Sniper (No Scope)",
	Default = false,
	Callback = function(state)
		_G.NoScopeActive = state
		if state then
			if noScopeConn then return end
			noScopeConn = game:GetService("RunService").Heartbeat:Connect(function()
				if not _G.NoScopeActive then 
					noScopeConn:Disconnect() 
					noScopeConn = nil 
					return 
				end
				
				local char = game.Players.LocalPlayer.Character
				local tool = char and char:FindFirstChild("Sniper")
				if tool then
					tool:SetAttribute("Scope", false)
				end
			end)
		end
	end    
})

local currentCooldown = 0.5

WeaponTab:AddSlider({
	Name = "(OG) Sniper Cooldown",
	Min = 0,
	Max = 3,
	Default = 0.5,
	Increment = 0.1,
	ValueName = "seconds",
	Callback = function(Value)
		currentCooldown = Value
		
		if Value <= 0 then
			if cooldownConn then
				cooldownConn:Disconnect()
				cooldownConn = nil
			end
			return
		end

		if not cooldownConn then
			cooldownConn = game:GetService("RunService").Heartbeat:Connect(function()
				local char = game.Players.LocalPlayer.Character
				local tool = char and char:FindFirstChild("Sniper")
				if tool then
					tool:SetAttribute("ShootDelay", currentCooldown)
				end
			end)
		end
	end    
})

WeaponTab:AddSection({
    Name = "Weapon Sounds"
})

local soundOptions = {
	"Default",
	"Ak47", 
	"M1911",
	"Glock",
	"MP40",
	"P90",
	"Brawl Stars",
	"Undertale"
}

local soundIds = {
	["Ak47"] = "rbxassetid://5910000043",
	["M1911"] = "rbxassetid://1136243671", 
	["Glock"] = "rbxassetid://6581933860",
	["MP40"] = "rbxassetid://103807799095792",
	["P90"] = "rbxassetid://87534588983395",
	["Brawl Stars"] = "rbxassetid://7380537613",
	["Undertale"] = "rbxassetid://438149153"
}

local originalSounds = {}
local soundObjects = {}

local function initializeSounds()
	for _, sound in pairs(game:GetDescendants()) do
		if sound:IsA("Sound") then
			local currentId = sound.SoundId
			if currentId == "rbxassetid://801226154" or currentId == "rbxassetid://801217802" then
				originalSounds[sound] = currentId
				soundObjects[sound] = true
			end
		end
	end
end

local function changeSounds(selectedSound)
	local newSoundId = soundIds[selectedSound]

	for sound, originalId in pairs(originalSounds) do
		if sound and sound.Parent then
			if selectedSound == "Default" then
				sound.SoundId = originalId
			else
				sound.SoundId = newSoundId
			end
		end
	end
end

initializeSounds()

WeaponTab:AddDropdown({
	Name = "Shoot Sound",
	Default = "Default",
	Options = soundOptions,
	Callback = function(selectedSound)
		changeSounds(selectedSound)
	end    
})

local hitSoundOptions = {
    "Default", "Minecraft", "Metal", "Bing", "Pong", "Skeet",
    "Rust", "Pick", "Bubble", "Neverlose", "Bell", "Allah Akbar"
}

local hitSoundIds = {
    ["Minecraft"]   = "rbxassetid://40145223",
    ["Metal"]       = "rbxassetid://3748776946",
    ["Bing"]        = "rbxassetid://6607204501",
    ["Pong"]        = "rbxassetid://9117374232",
    ["Skeet"]       = "rbxassetid://5633695679",
    ["Rust"]        = "rbxassetid://1255040462",
    ["Pick"]        = "rbxassetid://1347140027",
    ["Bubble"]      = "rbxassetid://119697580657161",
    ["Neverlose"]   = "rbxassetid://6604811799",
    ["Bell"]        = "rbxassetid://124010691633262",
    ["Allah Akbar"] = "rbxassetid://128063484534323"
}

local originalHitSounds = _G.originalHitSounds or {}
_G.originalHitSounds = originalHitSounds

local function ChangeHitSound(selectedSound)
    local newSoundId = hitSoundIds[selectedSound]
    for s, originalId in pairs(originalHitSounds) do
        if s and s.Parent then
            if selectedSound == "Default" then
                s.SoundId = originalId
            elseif newSoundId then
                s.SoundId = newSoundId
            end
        end
    end
end

WeaponTab:AddDropdown({
    Name = "Hit Sound",
    Default = "Default",
    Options = hitSoundOptions,
    Callback = function(sel)
        ChangeHitSound(sel)
    end
})

WeaponTab:AddSection({
    Name = "Weapon Customization"
})

local CrosshairSize = 25
local connections = {}

local function updateCrosshair(tool)
	if tool then
		tool:SetAttribute("CrosshairSize", CrosshairSize)
	end
end

local function setupToolListeners()
	local plr = game:GetService("Players").LocalPlayer

	for _, connection in pairs(connections) do
		connection:Disconnect()
	end
	connections = {}

	plr.CharacterAdded:Connect(function(character)
		connections.toolAdded = character.ChildAdded:Connect(function(child)
			if child:IsA("Tool") then
				updateCrosshair(child)
			end
		end)

		for _, tool in pairs(character:GetChildren()) do
			if tool:IsA("Tool") then
				updateCrosshair(tool)
			end
		end
	end)

	if plr.Character then
		for _, tool in pairs(plr.Character:GetChildren()) do
			if tool:IsA("Tool") then
				updateCrosshair(tool)
			end
		end

		connections.toolAdded = plr.Character.ChildAdded:Connect(function(child)
			if child:IsA("Tool") then
				updateCrosshair(child)
			end
		end)
	end
end

WeaponTab:AddSlider({
	Name = "Crosshair Size",
	Min = 0,
	Max = 25,
	Default = 25,
	Increment = 1,
	ValueName = "x",
	Callback = function(Value)
		CrosshairSize = Value
		local plr = game:GetService("Players").LocalPlayer
		if plr and plr.Character then
			for _, tool in pairs(plr.Character:GetChildren()) do
				if tool:IsA("Tool") then
					updateCrosshair(tool)
				end
			end
		end
	end    
})

setupToolListeners()

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
	task.wait(1)
	setupToolListeners()
end)

local aimFovConnection
local aimFovValue = 40

aimFovConnection = RunService.Heartbeat:Connect(function()
	local tool = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
	if tool then
		tool:SetAttribute("AimFieldOfView", aimFovValue)
	end
end)

WeaponTab:AddSlider({
	Name = "Aim FOV",
	Min = 30,
	Max = 120,
	Default = aimFovValue,
	Increment = 1,
	Callback = function(value)
		aimFovValue = value
	end
})

local ghostColor = Color3.fromRGB(0, 170, 255)
local rainbowEnabled = false
local enabled = false
local savedColors = {}
local targetParts = {"Body", "MeshPart", "Base1", "BrigherBlack", "BaseTop"}
local targetTools = {"Glock 17", "MP5", "M58B Shotgun", "M4 Carbine", "G36", "Sniper"}

local function isTargetTool(toolName)
	for _, name in ipairs(targetTools) do
		if toolName:lower():find(name:lower()) then
			return true
		end
	end
	return false
end

local function findTargetTools(character)
	local tools = {}

	if not character then return tools end

	for _, child in pairs(character:GetChildren()) do
		if child:IsA("Tool") and isTargetTool(child.Name) then
			table.insert(tools, child)
		end
	end

	local backpack = LocalPlayer:FindFirstChild("Backpack")
	if backpack then
		for _, tool in pairs(backpack:GetChildren()) do
			if tool:IsA("Tool") and isTargetTool(tool.Name) then
				table.insert(tools, tool)
			end
		end
	end

	return tools
end

function findTargetParts(tool)
	local parts = {}

	for _, partName in ipairs(targetParts) do
		local part = tool:FindFirstChild(partName)
		if part and part:IsA("BasePart") then
			table.insert(parts, part)
		end
	end

	for _, descendant in pairs(tool:GetDescendants()) do
		if descendant:IsA("BasePart") then
			for _, partName in ipairs(targetParts) do
				if descendant.Name:lower():find(partName:lower()) then
					table.insert(parts, descendant)
					break
				end
			end
		end
	end

	return parts
end

function applyColorToParts(parts, color)
	for _, part in ipairs(parts) do
		if not savedColors[part] then
			savedColors[part] = {
				Color = part.Color,
				Material = part.Material
			}
		end

		part.Color = color
		part.Material = Enum.Material.ForceField
	end
end

function restoreOriginalColor(parts)
	for _, part in ipairs(parts) do
		if savedColors[part] then
			part.Color = savedColors[part].Color
			part.Material = savedColors[part].Material
			savedColors[part] = nil
		end
	end
end

function checkAndApplyColor(color)
	if not enabled then return end

	local character = LocalPlayer.Character
	if not character then return end

	local tools = findTargetTools(character)
	for _, tool in ipairs(tools) do
		local parts = findTargetParts(tool)
		applyColorToParts(parts, color)
	end
end

function checkAndRestoreColor()
	local character = LocalPlayer.Character
	if not character then return end

	local tools = findTargetTools(character)
	for _, tool in ipairs(tools) do
		local parts = findTargetParts(tool)
		restoreOriginalColor(parts)
	end
end

local function toggleWeaponColors(state)
	enabled = state

	if enabled then
		if rainbowEnabled then
			startRainbow()
		else
			startContinuousCheck()
			checkAndApplyColor(ghostColor)
		end
	else
		if rainbowConnection then
			stopRainbow()
		end
		if checkConnection then
			checkConnection:Disconnect()
			checkConnection = nil
		end
		checkAndRestoreColor()
	end
end

WeaponTab:AddToggle({
	Name = "Weapon Color",
	Default = false,
	Callback = function(Value)
		toggleWeaponColors(Value)
	end
})

WeaponTab:AddColorpicker({
	Name = "Weapons Color Picker",
	Default = Color3.fromRGB(255, 255, 255),
	Callback = function(Value)
		ghostColor = Value
		if enabled and not rainbowEnabled then
			checkAndApplyColor(ghostColor)
		end
	end
})

local function onCharacterAdded(character)
	if enabled then
		wait(1)

		if rainbowEnabled then
			startRainbow()
		else
			startContinuousCheck()
			checkAndApplyColor(ghostColor)
		end
	end

	character.ChildAdded:Connect(function(child)
		if child:IsA("Tool") and isTargetTool(child.Name) and enabled then
			if not rainbowEnabled then
				checkAndApplyColor(ghostColor)
			end
		end
	end)
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
if LocalPlayer.Character then
	onCharacterAdded(LocalPlayer.Character)
end

PoliceTab:AddSection({
    Name = "Special"
})
TweenService = game:GetService("TweenService")
Workspace = game:GetService("Workspace")
LocalPlayer = game.Players.LocalPlayer

TeleportSpeed = 130

local function ensurePlayerInVehicle()
    if LocalPlayer and LocalPlayer.Character then
        local vehicle = Workspace.Vehicles:FindFirstChild(LocalPlayer.Name)
        if vehicle and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid and not humanoid.SeatPart then
                local driveSeat = vehicle:FindFirstChild("DriveSeat")
                if driveSeat then
                    driveSeat:Sit(humanoid)
                end
            end
        end
    end
end

local function flyVehicleTo(targetCFrame, callback)
    local vehicle = Workspace.Vehicles:FindFirstChild(LocalPlayer.Name)
    if not vehicle then return end

    local driveSeat = vehicle:FindFirstChild("DriveSeat")
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and driveSeat then
        if not humanoid.SeatPart then
            driveSeat:Sit(humanoid)
        end
    end

    if not vehicle.PrimaryPart then
        vehicle.PrimaryPart = vehicle:FindFirstChild("Mass", true)
    end

    local startPos = vehicle.PrimaryPart.Position
    local targetPos = targetCFrame.Position
    local flightHeight = -1

    local startFlightPos = Vector3.new(startPos.X, flightHeight, startPos.Z)
    vehicle:SetPrimaryPartCFrame(CFrame.new(startFlightPos))

    local flightTarget = Vector3.new(targetPos.X, flightHeight, targetPos.Z)
    local distance = (Vector3.new(startPos.X, 0, startPos.Z) - Vector3.new(flightTarget.X, 0, flightTarget.Z)).Magnitude
    local duration = distance / TeleportSpeed

    local info = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local CFrameValue = Instance.new("CFrameValue")
    CFrameValue.Value = vehicle:GetPrimaryPartCFrame()

    CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
        local currentPos = CFrameValue.Value.Position
        local fixedCFrame = CFrame.new(currentPos.X, flightHeight, currentPos.Z)
        vehicle:SetPrimaryPartCFrame(fixedCFrame)
        vehicle.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
    end)

    local tween = TweenService:Create(CFrameValue, info, { Value = CFrame.new(flightTarget) })
    tween:Play()

    tween.Completed:Connect(function()
        CFrameValue:Destroy()
        vehicle:SetPrimaryPartCFrame(targetCFrame)
        if callback then callback() end
    end)
end

local function teleportToLocation(coordinates, callback)
    ensurePlayerInVehicle()
    task.wait(0.5)
    flyVehicleTo(coordinates, callback)
end

PoliceTab:AddDropdown({
    Name = "Change Job",
    Default = "None",
    Options = {"Police"},
    Callback = function(selected)
        if selected == "Police" then
            teleportToLocation(CFrame.new(-1684, 5, 2794), function()
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Sit = false
                end
                task.wait(0.5)

                local args = { "Patrol Police" }
                game:GetService("ReplicatedStorage"):WaitForChild("GpP"):WaitForChild("60c32e48-fa09-4087-a2f4-1de7b3f270a5"):FireServer(unpack(args))

                OrionLib:MakeNotification({
                    Name = "Success",
                    Content = "Your now a Police Officer :)",
                    Time = 3
                })
            end)
        end
    end,
})

PoliceTab:AddSection({
    Name = "Police Features"
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

getgenv().AutoTaser = getgenv().AutoTaser or {
    Toggle = false,
    PredictionFactor = 0.22,
    MaxTargetDistance = 20,
    Remote = ReplicatedStorage.GpP["664bcd31-3ad5-470e-87db-ab2f85f6fa5c"]
}

local function isPlayerOnSeat(char)
    if not char then return false end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.Sit then return true end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and (hrp:FindFirstAncestorOfClass("VehicleSeat") or hrp:FindFirstAncestorOfClass("Seat")) then
        return true
    end

    return false
end

local function getBestTarget(myHRP)
    local bestTarget = nil
    local closestDistance = getgenv().AutoTaser.MaxTargetDistance
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local pChar = player.Character
            local pHrp = pChar and pChar:FindFirstChild("HumanoidRootPart")
            local pHum = pChar and pChar:FindFirstChildOfClass("Humanoid")

            if pHrp and pHum and pHrp:GetAttribute("IsWanted") == true then
                if pHum.Health > 30 and not isPlayerOnSeat(pChar) then
                    local distance = (myHRP.Position - pHrp.Position).Magnitude
                    
                    if distance < closestDistance then
                        closestDistance = distance
                        bestTarget = pHrp
                    end
                end
            end
        end
    end
    return bestTarget
end


PoliceTab:AddToggle({
    Name = "Auto Taser",
    Default = getgenv().AutoTaser.Toggle,
    Callback = function(Value)
        getgenv().AutoTaser.Toggle = Value
    end    
})

RunService.Heartbeat:Connect(function()
    if not getgenv().AutoTaser.Toggle then return end
    
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local taser = myChar and myChar:FindFirstChild("Taser")
    
    if not myHRP or not taser then return end

    local targetHrp = getBestTarget(myHRP)
    if not targetHrp then return end

    local velocity = targetHrp.AssemblyLinearVelocity or targetHrp.Velocity or Vector3.new(0, 0, 0)
    local predictedPos = targetHrp.Position + (velocity * getgenv().AutoTaser.PredictionFactor)
    local direction = (predictedPos - myHRP.Position).Unit
    
    getgenv().AutoTaser.Remote:FireServer(taser, predictedPos, direction)
end)

PoliceTab:AddSection({
    Name = "Anti Police"
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local AntiTaserEnabled = false

PoliceTab:AddToggle({
    Name = "Anti Taser",
    Default = false,
    Callback = function(state)
        AntiTaserEnabled = state
    end
})

RunService.Heartbeat:Connect(function()
    if AntiTaserEnabled then
        local char = localPlayer.Character
        if char then
            if char:GetAttribute("Tased") == true then
                char:SetAttribute("Tased", false)
            end
            
            local tasedValue = char:FindFirstChild("Tased") or char:FindFirstChild("IsTased")
            if tasedValue and tasedValue.Value == true then
                tasedValue.Value = false
            end
        end
    end
end)

PoliceTab:AddParagraph("Information for Police Tab", "More Features are Comming Soon")

TeleportTab:AddSection({
    Name = "Teleport Settings"
})

TeleportTab:AddSlider({
    Name = "Teleport Speed",
    Min = 130,
    Max = 175,
    Default = 50,
    Increment = 1,
    ValueName = "speed",
    Callback = function(Value)
        TeleportSpeed = Value
    end    
})

function ensurePlayerInVehicle()
    if LocalPlayer and LocalPlayer.Character then
        local vehicle = Workspace.Vehicles:FindFirstChild(LocalPlayer.Name)
        if vehicle and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid and not humanoid.SeatPart then
                local driveSeat = vehicle:FindFirstChild("DriveSeat")
                if driveSeat then
                    driveSeat:Sit(humanoid)
                end
            end
        end
    end
end

function tweenToCFrame(model, targetCFrame, duration, onComplete)
    local info = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local CFrameValue = Instance.new("CFrameValue")
    CFrameValue.Value = model:GetPrimaryPartCFrame()

    CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
        model:SetPrimaryPartCFrame(CFrameValue.Value)
        model.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
    end)

    local tween = TweenService:Create(CFrameValue, info, { Value = targetCFrame })
    tween:Play()
    tween.Completed:Connect(function()
        CFrameValue:Destroy()
        if onComplete then onComplete() end
    end)
end

function flyVehicleTo(targetCFrame, callback)
    local vehicle = Workspace.Vehicles:FindFirstChild(LocalPlayer.Name)
    if not vehicle then return end

    local driveSeat = vehicle:FindFirstChild("DriveSeat")
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid and driveSeat then
        if not humanoid.SeatPart then
            driveSeat:Sit(humanoid)
        end
    end

    if not vehicle.PrimaryPart then
        vehicle.PrimaryPart = vehicle:FindFirstChild("Mass", true)
    end

    local startPos = vehicle.PrimaryPart.Position
    local targetPos = targetCFrame.Position
    local flightHeight = -1

    local startFlightPos = Vector3.new(startPos.X, flightHeight, startPos.Z)
    vehicle:SetPrimaryPartCFrame(CFrame.new(startFlightPos))

    local flightTarget = Vector3.new(targetPos.X, flightHeight, targetPos.Z)
    local distance = (Vector3.new(startPos.X, 0, startPos.Z) - Vector3.new(flightTarget.X, 0, flightTarget.Z)).Magnitude
    local duration = distance / TeleportSpeed

    local info = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local CFrameValue = Instance.new("CFrameValue")
    CFrameValue.Value = vehicle:GetPrimaryPartCFrame()

    CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
        local currentPos = CFrameValue.Value.Position
        local fixedCFrame = CFrame.new(currentPos.X, flightHeight, currentPos.Z)
        vehicle:SetPrimaryPartCFrame(fixedCFrame)
        vehicle.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
    end)

    local tween = TweenService:Create(CFrameValue, info, { Value = CFrame.new(flightTarget) })
    tween:Play()

    tween.Completed:Connect(function()
        CFrameValue:Destroy()
        vehicle:SetPrimaryPartCFrame(targetCFrame)
        if callback then callback() end
    end)
end

local function teleportToLocation(coordinates)
    ensurePlayerInVehicle()
    task.wait(0.5)
    flyVehicleTo(coordinates)
end

TeleportTab:AddButton({
    Name = "Nearest Dealer",
    Callback = function()
        local function findNearestDealer()
            local nearestDealer = nil
            local closestDistance = math.huge

            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj.Name:lower():find("dealer") then
                    if obj.PrimaryPart then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - obj.PrimaryPart.Position).magnitude
                        if distance < closestDistance then
                            nearestDealer = obj
                            closestDistance = distance
                        end
                    end
                end
            end
            return nearestDealer
        end

        local dealer = findNearestDealer()
        if dealer then
            teleportToLocation(dealer.PrimaryPart.CFrame)
        end
    end
})

TeleportTab:AddButton({
    Name = "Nearest Smuggler",
    Callback = function()
        local function findNearestSmuggler()
            local nearestSmuggler = nil
            local closestDistance = math.huge

            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj.Name:lower():find("smuggler") then
                    if obj.PrimaryPart then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - obj.PrimaryPart.Position).magnitude
                        if distance < closestDistance then
                            nearestSmuggler = obj
                            closestDistance = distance
                        end
                    end
                end
            end
            return nearestSmuggler
        end

        local smuggler = findNearestSmuggler()
        if smuggler then
            teleportToLocation(smuggler.PrimaryPart.CFrame)
        end
    end
})

TeleportTab:AddButton({
    Name = "Nearest Vending Machine",
    Callback = function()
        local function findNearestVendingMachine()
            local nearestPart = nil
            local closestDistance = math.huge

            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and obj.Name == "Vending Machine" then
                    for _, part in pairs(obj:GetChildren()) do
                        if part:IsA("BasePart") and part.Name == "Light" then
                            local lightColor = part.Color
                            if lightColor == Color3.fromRGB(73, 147, 0) then
                                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - part.Position).magnitude
                                if distance < closestDistance then
                                    nearestPart = part
                                    closestDistance = distance
                                end
                            end
                        end
                    end
                end
            end
            return nearestPart
        end

        local vendingMachinePart = findNearestVendingMachine()
        if vendingMachinePart then
            teleportToLocation(vendingMachinePart.CFrame)
        end
    end
})

TeleportTab:AddSection({
    Name = "Select to teleport"
})

TeleportTab:AddDropdown({
    Name = "Robbable Places",
    Default = false,
    Save = false,
    Options = {"Gasn-Go", "Osso-Fuel", "Jewelry Store", "Bank", "Ares Tank", "Tool Shop", "Farm Shop", "Erwin Club", "Yellow Container", "Green Container"},
    Callback = function(Option)
        if Option then
            if Option == "Gasn-Go" then
                teleportToLocation(CFrame.new(-1566.311, 5.25, 3812.591))
            elseif Option == "Osso-Fuel" then
                teleportToLocation(CFrame.new(-33.184, 5.25, -748.875))
            elseif Option == "Jewelry Store" then
                teleportToLocation(CFrame.new(-413.255, 5.5, 3517.947))
            elseif Option == "Bank" then
                teleportToLocation(CFrame.new(-1188.809, 5.5, 3228.133))
            elseif Option == "Ares Tank" then
                teleportToLocation(CFrame.new(-858.118, 5.3, 1514.51))
            elseif Option == "Farm Shop" then
                teleportToLocation(CFrame.new(-896.206, 4.984, -1165.972))
            elseif Option == "Erwin Club" then
                teleportToLocation(CFrame.new(-1858.259, 5.25, 3023.394))
            elseif Option == "Yellow Container" then
                teleportToLocation(CFrame.new(1118.788, 28.696, 2335.582))
            elseif Option == "Green Container" then
                teleportToLocation(CFrame.new(1169.115, 28.696, 2153.111))
            elseif Option == "Tool Shop" then
                teleportToLocation(CFrame.new(-750.401, 5.25, 670.062))           
            end
        end
    end    
})

TeleportTab:AddDropdown({
    Name = "Usable Places",
    Default = false,
    Save = false,
    Options = {"Car Dealer", "Prison In", "Prison Out", "Hospital", "Parking Garage"},
    Callback = function(Option)
        if Option then
            if Option == "Car Dealer" then
                teleportToLocation(CFrame.new(-1421.418, 5.25, 941.061))
            elseif Option == "Prison In" then
                teleportToLocation(CFrame.new(-573.336, 5.088, 3061.913))
            elseif Option == "Prison Out" then
                teleportToLocation(CFrame.new(-580.354, 5.25, 2839.322))
            elseif Option == "Hospital" then
                teleportToLocation(CFrame.new(-284.98, 5.25, 1108.397))
            elseif Option == "Parking Garage" then
                teleportToLocation(CFrame.new(-1476.472900390625, -23.861671447753906, 3669.669677734375))
            end
        end
    end    
})

TeleportTab:AddDropdown({
    Name = "Work Places",
    Default = false,
    Save = false,
    Options = {"Hars", "Police Station", "Fire Station", "Truck Station", "Bus Station"},
    Callback = function(Option)
        if Option then
            if Option == "Hars" then
                teleportToLocation(CFrame.new(-126.326, 5.25, 431.344))
            elseif Option == "Police Station" then
                teleportToLocation(CFrame.new(-1684.459, 5.25, 2736.004))
            elseif Option == "Fire Station" then
                teleportToLocation(CFrame.new(-1026.58, 5.464, 3899.69))
            elseif Option == "Truck Station" then
                teleportToLocation(CFrame.new(710.446, 5.25, 1481.296))
            elseif Option == "Bus Station" then
                teleportToLocation(CFrame.new(-1676.292, 5.144, -1272.049))
            end
        end
    end    
})

TeleportTab:AddSection({
    Name = "Custom"
})

TeleportTab:AddTextbox({
    Callback = function(coords)
        local x, y, z = coords:match("(-?%d+%.?%d*),?%s*(-?%d+%.?%d*),?%s*(-?%d+%.?%d*)")
        if x and y and z then
            teleportToLocation(CFrame.new(tonumber(x), tonumber(y), tonumber(z)))
        else
            library:MakeNotification({
                Name = "Error",
                Content = "Invalid coordinates format. Use: X, Y, Z",
                Image = "rbxassetid://4384403532",
                Time = 3
            })
        end
    end,
    TextDisappear = false,
    Name = 'Custom Coords (X, Y, Z)',
    Default = '',
})

MiscTab:AddSection({
    Name = "Player"
})

MiscTab:AddToggle({
    Name = "Enable Custom Fov",
    Default = false,
    Callback = function(isEnabled)
        _G.FOVLockEnabled = isEnabled
        
        if isEnabled then
            if not fovConnection then
                fovConnection = game:GetService("RunService").RenderStepped:Connect(function()
                    if _G.FOVLockEnabled and (_G.LockedFOV and workspace.CurrentCamera.FieldOfView ~= _G.LockedFOV) then
                        workspace.CurrentCamera.FieldOfView = _G.LockedFOV
                    end
                end)
            end
        elseif fovConnection then
            fovConnection:Disconnect()
            fovConnection = nil
        end
    end
})

MiscTab:AddSlider({
    Name = "Field Of View",
    Min = 90,
    Max = 120,
    Default = 90,
    Suffix = "FOV",
    Save = true,
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
        _G.LockedFOV = value
    end
})

RunService = game:GetService("RunService")
Lighting = game:GetService("Lighting")
Terrain = game:GetService("Workspace").Terrain 

IsBoostEnabled = false
OriginalSettings = {
    QualityLevel = Enum.QualityLevel.Level10, 
    LightingTechnology = Lighting.Technology,
    GlobalShadows = Lighting.GlobalShadows,
    DiffuseScale = Lighting.EnvironmentDiffuseScale,
    SpecularScale = Lighting.EnvironmentSpecularScale,
    Textures = {},
    Water = {
        Size = Terrain.WaterWaveSize,
        Speed = Terrain.WaterWaveSpeed,
        Reflectance = Terrain.WaterReflectance,
        Transparency = Terrain.WaterTransparency
    },
    Decals = {},
    Particles = {},
    Explosions = {},
    Materials = {},
    Effects = {}
}

function ToggleFPSBoost(State)
    IsBoostEnabled = State
    
    if State then
        OriginalSettings.QualityLevel = settings().Rendering.QualityLevel
        OriginalSettings.LightingTechnology = Lighting.Technology
        OriginalSettings.GlobalShadows = Lighting.GlobalShadows

        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 0

        Lighting.Technology = Enum.Technology.Compatibility
        Lighting.GlobalShadows = false
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.FogEnd = 9e9
        
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

        for _, Item in pairs(game:GetDescendants()) do
            if Item:IsA("BasePart") then
                OriginalSettings.Materials[Item] = {Mat = Item.Material, Ref = Item.Reflectance}
                Item.Material = Enum.Material.Plastic
                Item.Reflectance = 0
            elseif Item:IsA("Decal") then
                OriginalSettings.Decals[Item] = Item.Transparency
                Item.Transparency = 1
            elseif Item:IsA("Texture") then
                OriginalSettings.Textures[Item] = Item.Texture
                Item.Texture = ""
            elseif Item:IsA("ParticleEmitter") or Item:IsA("Trail") then
                OriginalSettings.Particles[Item] = Item.Lifetime
                Item.Lifetime = NumberRange.new(0)
            elseif Item:IsA("Explosion") then
                OriginalSettings.Explosions[Item] = {Pres = Item.BlastPressure, Rad = Item.BlastRadius}
                Item.BlastPressure = 1
                Item.BlastRadius = 1
            end
        end

        for _, Effect in pairs(Lighting:GetDescendants()) do
            if Effect:IsA("PostProcessEffect") or Effect:IsA("BlurEffect") or Effect:IsA("BloomEffect") or Effect:IsA("DepthOfFieldEffect") then
                OriginalSettings.Effects[Effect] = Effect.Enabled
                Effect.Enabled = false
            end
        end

    else
        settings().Rendering.QualityLevel = OriginalSettings.QualityLevel
        Lighting.Technology = OriginalSettings.LightingTechnology
        Lighting.GlobalShadows = OriginalSettings.GlobalShadows
        
        Terrain.WaterWaveSize = OriginalSettings.Water.Size
        Terrain.WaterWaveSpeed = OriginalSettings.Water.Speed
        Terrain.WaterReflectance = OriginalSettings.Water.Reflectance
        Terrain.WaterTransparency = OriginalSettings.Water.Transparency
        
        for Part, Data in pairs(OriginalSettings.Materials) do
            if Part and Part.Parent then
                Part.Material = Data.Mat
                Part.Reflectance = Data.Ref
            end
        end
        
        for Decal, Trans in pairs(OriginalSettings.Decals) do
            if Decal and Decal.Parent then Decal.Transparency = Trans end
        end
        
        for Text, Asset in pairs(OriginalSettings.Textures) do
            if Text and Text.Parent then Text.Texture = Asset end
        end
        
        for Effect, Enabled in pairs(OriginalSettings.Effects) do
            if Effect and Effect.Parent then Effect.Enabled = Enabled end
        end
    end
end

workspace.DescendantAdded:Connect(function(NewItem)
    if IsBoostEnabled then
        task.spawn(function()
            RunService.RenderStepped:Wait()
            if NewItem:IsA("ForceField") or NewItem:IsA("Sparkles") or NewItem:IsA("Smoke") or NewItem:IsA("Fire") then
                NewItem:Destroy()
            end
        end)
    end
end)

MiscTab:AddToggle({
    Name = "FPS Boost",
    Default = false,
    Callback = function(Value)
        ToggleFPSBoost(Value)
    end    
})

MiscTab:AddButton({
	Name = "Infinite Yield",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	end
})

MiscTab:AddSection({
    Name = "Safety"
})

local selectedReviveMode = "Heal 100 HP and Stay in Hospital"

MiscTab:AddDropdown({
	Name = "Self Revive Mode",
	Options = {
		"Heal 100 HP and Stay in Hospital",
		"Heal 100 HP and get Back to Dead Position",
		"Heal 25 HP and get Back to Dead Position",
		"Heal 25 HP and Stay in Hospital"
	},
	Default = "Heal 100 HP and Stay in Hospital",
	Callback = function(selected)
		selectedReviveMode = selected
	end
})

local function doRevive(selectedMode)
	local TweenService = game:GetService("TweenService")
	local VirtualInputManager = game:GetService("VirtualInputManager")
	local FARMspeed = 170

	local targetHP = 100
	local returnToSpot = false

	if selectedMode == "Heal 100 HP and Stay in Hospital" then
		targetHP = 100
		returnToSpot = false
	elseif selectedMode == "Heal 100 HP and Get Back to Dead Position" then
		targetHP = 100
		returnToSpot = true
	elseif selectedMode == "Heal 25 HP and Get Back to Dead Position" then
		targetHP = 25
		returnToSpot = true
	elseif selectedMode == "Heal 25 HP and Stay in Hospital" then
		targetHP = 25
		returnToSpot = false
	end

	local startPosition = nil

	local function isPlayerDead()
		local player = game.Players.LocalPlayer
		if player and player.Character then
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				return humanoid.Health <= 24
			end
		end
		return false
	end

	local function showNotification(message)
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Void Menu",
			Text = message,
			Duration = 5
		})
	end

	local function ensurePlayerInVehicle()
		local player = game.Players.LocalPlayer
		if player and player.Character then
			local vehicle = workspace.Vehicles:FindFirstChild(player.Name)
			if vehicle and player.Character:FindFirstChild("Humanoid") then
				local humanoid = player.Character:FindFirstChild("Humanoid")
				if humanoid and not humanoid.SeatPart then
					local driveSeat = vehicle:FindFirstChild("DriveSeat")
					if driveSeat then
						driveSeat:Sit(humanoid)
					end
				end
			end
		end
	end

	local function flyVehicleTo(targetCFrame, callback)
		local player = game.Players.LocalPlayer
		local vehicle = workspace.Vehicles:FindFirstChild(player.Name)
		if not vehicle then return end

		local driveSeat = vehicle:FindFirstChild("DriveSeat")
		local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
		if humanoid and driveSeat then
			if not humanoid.SeatPart then
				driveSeat:Sit(humanoid)
			end
		end

		if not vehicle.PrimaryPart then
			vehicle.PrimaryPart = vehicle:FindFirstChild("Mass", true)
		end

		local startPos = vehicle.PrimaryPart.Position
		local targetPos = targetCFrame.Position
		local flightHeight = -1

		local startFlightPos = Vector3.new(startPos.X, flightHeight, startPos.Z)
		vehicle:SetPrimaryPartCFrame(CFrame.new(startFlightPos))

		local flightTarget = Vector3.new(targetPos.X, flightHeight, targetPos.Z)
		local distance = (Vector3.new(startPos.X, 0, startPos.Z) - Vector3.new(flightTarget.X, 0, flightTarget.Z)).Magnitude
		local duration = distance / FARMspeed

		local info = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
		local CFrameValue = Instance.new("CFrameValue")
		CFrameValue.Value = vehicle:GetPrimaryPartCFrame()

		CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
			local currentPos = CFrameValue.Value.Position
			local fixedCFrame = CFrame.new(currentPos.X, flightHeight, currentPos.Z)
			vehicle:SetPrimaryPartCFrame(fixedCFrame)
			vehicle.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
		end)

		local tween = TweenService:Create(CFrameValue, info, { Value = CFrame.new(flightTarget) })
		tween:Play()

		tween.Completed:Connect(function()
			CFrameValue:Destroy()
			vehicle:SetPrimaryPartCFrame(targetCFrame)
			if callback then callback() end
		end)
	end

	local function goToHospitalAndSit()
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()

		character:MoveTo(Vector3.new(-107.427, 7.648, 1073.643))
		wait(1)

		local buildings = workspace:FindFirstChild("Buildings")
		local hospital = buildings:FindFirstChild("Hospital")
		local bed = hospital:FindFirstChild("HospitalBed")
		local seat = bed:FindFirstChild("Seat")

		character:MoveTo(seat.Position + Vector3.new(0, 2, 0))
		wait(0.7)

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			seat:Sit(humanoid)
		end
	end

	local function pressSpace()
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
		wait(0.1)
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
		wait(0.2)
	end

	local function keepInBed()
		local player = game.Players.LocalPlayer
		local buildings = workspace:FindFirstChild("Buildings")
		if buildings then
			local hospital = buildings:FindFirstChild("Hospital")
			if hospital then
				local bed = hospital:FindFirstChild("HospitalBed")
				if bed then
					local seat = bed:FindFirstChild("Seat")
					local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
					if seat and humanoid and not humanoid.SeatPart then
						player.Character:MoveTo(seat.Position + Vector3.new(0, 2, 0))
						wait(0.2)
						seat:Sit(humanoid)
					end
				end
			end
		end
	end

	local player = game.Players.LocalPlayer

	if isPlayerDead() then
		startPosition = player.Character and player.Character.PrimaryPart and player.Character.PrimaryPart.CFrame or nil

		ensurePlayerInVehicle()
		wait(0.5)

		local hospitalCarPosition = CFrame.new(-89.70, 5.88, 1055.77)

		flyVehicleTo(hospitalCarPosition, function()
			wait(1)
			player.Character:MoveTo(Vector3.new(-107.427, 7.648, 1073.643))
			wait(0.5)
			goToHospitalAndSit()

			task.spawn(function()
				local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

				while humanoid and humanoid.Health < targetHP do
					wait(1)
					humanoid = player.Character:FindFirstChildOfClass("Humanoid")
					keepInBed()
				end

				pressSpace()
				showNotification("Heald to " .. targetHP .. " Hp")
				wait(0.5)

				if returnToSpot then
					ensurePlayerInVehicle()
					ensurePlayerInVehicle()
					wait(0.5)
					if startPosition then
						flyVehicleTo(startPosition, function()
							showNotification("Going back to deadpoint")
						end)
					end
				else
					showNotification("Stay in Hostpital")
				end
			end)
		end)
	end

	return isPlayerDead()
end

MiscTab:AddButton({
	Name = "Self Revive",
	Callback = function()
		local selectedMode = selectedReviveMode
		local player = game.Players.LocalPlayer
		local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

		if humanoid and humanoid.Health <= 25 then
			doRevive(selectedMode)
		else
			game:GetService("StarterGui"):SetCore("SendNotification", {
				Title = "Void Menu",
				Text = "You are not dead.",
				Duration = 5
			})
		end
	end
})

localPlayer = Players.LocalPlayer
character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
humanoid = character:WaitForChild("Humanoid")

MiscTab:AddButton({
    Name = "Kick Out Of Seat",
    Callback = function()
        humanoid.Sit = false
    end
})

MiscTab:AddToggle({
    Name = "Anti Falldamage",
    Default = false,
    Callback = function(state)
        if state then
            if noFallConnection then noFallConnection:Disconnect() end

            noFallConnection = RunService.Heartbeat:Connect(function()
                local character = LocalPlayer.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                
                if root and root.AssemblyLinearVelocity.Y < -35 then
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {character}
                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

                    local ray = workspace:Raycast(root.Position, Vector3.new(0, -15, 0), raycastParams)
                    
                    if ray then 
                        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z)
                    end
                end
            end)
        else
            if noFallConnection then
                noFallConnection:Disconnect()
                noFallConnection = nil
            end
        end
    end
})

MiscTab:AddSection({
    Name = "Other"
})

Players = game:GetService("Players")
UserInputService = game:GetService("UserInputService")

LocalPlayer = Players.LocalPlayer

MiscTab:AddButton({
    Name = "Reset Character",
    Callback = function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
    end
})

MiscTab:AddButton({
    Name = "Fake Ban",
    Callback = function()
        local Player = game:GetService("Players").LocalPlayer
        if Player then
            Player:Kick("Your Account got Banned Permanently\n Reason: Exploiting")
        else
            game:Shutdown() 
        end
    end    
})

MiscTab:AddSection({
    Name = "World"
})

antiVoidEnabled = false
checkInterval = 0.1

task.spawn(function()
    while task.wait(checkInterval) do
        if antiVoidEnabled then
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart

                if hrp.Position.Y < -2 then
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    hrp.CFrame = hrp.CFrame + Vector3.new(0, 10, 0)
                end
            end
        end
    end
end)

MiscTab:AddToggle({
    Name = "Anti-Void",
    Default = false,
    Callback = function(Value)
        antiVoidEnabled = Value
    end    
})

MiscTab:AddButton({
	Name = "Teleport to Void",
	Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local currentPos = player.Character.HumanoidRootPart.Position
            player.Character.HumanoidRootPart.CFrame = CFrame.new(currentPos.X, 0, currentPos.Z)
        end
	end    
})

MiscTab:AddToggle({
    Name = "Auto Reconnect",
    Default = false,
    Callback = function(Value)
        if Value then
            _G.AutoReconnect = true
            task.spawn(function()
                repeat task.wait() until game.CoreGui:FindFirstChild("RobloxPromptGui")
                
                queue_on_teleport([[
                    loadstring(game:HttpGet('loadstring(game:HttpGet("https://void.eldarx.site/Main.lua"))()'))()
                ]])
                
                local TeleportService = game:GetService("TeleportService")
                local PromptOverlay = game.CoreGui.RobloxPromptGui.promptOverlay
                
                PromptOverlay.ChildAdded:Connect(function(child)
                    if _G.AutoReconnect and child.Name == "ErrorPrompt" then
                        while _G.AutoReconnect do
                            pcall(function()
                                TeleportService:Teleport(game.PlaceId)
                            end)
                            task.wait(4)
                        end
                    end
                end)
            end)
        else
            _G.AutoReconnect = false
        end
    end
})

MiscTab:AddSection({
    Name = "Spectate"
})

SelectedPlayerName = ""
Viewing = false

local function getPlayerNames()
    local names = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    table.sort(names)
    return names
end

MiscTab:AddDropdown({
    Name = "Select Player to View",
    Default = "",
    Options = getPlayerNames(),
    Callback = function(Value)
        SelectedPlayerName = Value
    end    
})

MiscTab:AddButton({
    Name = "Refresh Player List",
    Callback = function()
        PlayerDropdown:Refresh(getPlayerNames(), true)
    end    
})

MiscTab:AddToggle({
    Name = "Watch Player",
    Default = false,
    Callback = function(Value)
        Viewing = Value
        
        if not Viewing then
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            LocalPlayer.ReplicationFocus = nil
        end
    end    
})

game:GetService("RunService").RenderStepped:Connect(function()
    if Viewing and SelectedPlayerName ~= "" then
        local targetPlayer = game.Players:FindFirstChild(SelectedPlayerName)

        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = targetPlayer.Character.HumanoidRootPart
            local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")

            LocalPlayer.ReplicationFocus = targetRoot
            Camera.CameraSubject = targetHumanoid
        else
            Viewing = false
            
            WatchToggle:Set(false)
            
            Camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            LocalPlayer.ReplicationFocus = nil
            
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Player is not in Range.",
                Time = 5
            })
        end
    end
end)

MiscTab:AddSection({
    Name = "Gui"
})
MiscTab:AddButton({
    Name = 'Destroy UI',
    Callback = function()
        local success = pcall(function() 
            library:Destroy() 
        end)
        if not success then
            library:MakeNotification({
                Name = "Error",
                Content = "Failed to destroy UI",
                Image = "rbxassetid://4384403532",
                Time = 3
            })
        end
    end,
})

SocialTab:AddSection({
    Name = "Social Media"
})

SocialTab:AddParagraph("TikTok", "You can Follow us on TikTok with this Name or the Button down : @voidmenu.erlc")

SocialTab:AddButton({
    Name = "Copy TikTok Link",
    Callback = function()
        setclipboard("https://www.tiktok.com/@voidmenu.erlc")
        OrionLib:MakeNotification({
            Name = "Success",
            Content = "Link copied to clipboard!",
            Time = 3
        })
    end
})  

SocialTab:AddSection({
    Name = "Rscripts"
})

SocialTab:AddParagraph("Rscripts", "You can leave a like and an Follow on our Rscripts")

SocialTab:AddButton({
    Name = "Copy Rscript Link",
    Callback = function()
        setclipboard("https://rscripts.net/@Void_Menu")
        OrionLib:MakeNotification({
            Name = "Success",
            Content = "Link Copied to clipboard",
            Time = 3
        })
    end
})

InfoTab:AddSection({
    Name = "Developer Information"
})

InfoTab:AddParagraph("Developed by", "Trojaner\n But we have also contributor like Phil from MoonHub or Eldar from EldarX")

InfoTab:AddSection({
    Name = "Information"
})

InfoTab:AddParagraph("About Void", "Void is an Projekt from Trojaner (the Main Developer) he decidet do make an own projekt to troll some servers")

InfoTab:AddParagraph("Our Current Version", "V-2")

OrionLib:Init()
