local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local UserInputService = game:GetService("UserInputService")

local TweenService = game:GetService("TweenService")

local workspace = game:GetService("Workspace")



local player = Players.LocalPlayer

local camera = workspace.CurrentCamera



--// GUI

local screenGui = Instance.new("ScreenGui", game.CoreGui)

screenGui.ResetOnSpawn = false



local mainFrame = Instance.new("Frame", screenGui)

mainFrame.Size = UDim2.new(0, 220, 0, 170)

mainFrame.Position = UDim2.new(0.5, -110, 0.5, -85)

mainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)

mainFrame.BorderSizePixel = 0 



Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,15)



-- BORDE ANIMADO

local stroke = Instance.new("UIStroke", mainFrame)

stroke.Thickness = 2

stroke.Color = Color3.fromRGB(0,255,150)



-- FONDO GRADIENTE

local gradient = Instance.new("UIGradient", mainFrame)

gradient.Color = ColorSequence.new{

ColorSequenceKeypoint.new(0, Color3.fromRGB(25,25,25)),

ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,10))

}



--// TITLE BAR

local titleBar = Instance.new("Frame", mainFrame)

titleBar.Size = UDim2.new(1,0,0,60)

titleBar.BackgroundTransparency = 1



local title = Instance.new("TextLabel", titleBar)

title.Size = UDim2.new(1,0,0,30)

title.BackgroundTransparency = 1

title.Text = "AsierScripts👨‍💻"

title.Font = Enum.Font.GothamBold

title.TextSize = 18

title.TextColor3 = Color3.fromRGB(0,255,150)



local subtitle = Instance.new("TextLabel", titleBar)

subtitle.Size = UDim2.new(1,0,0,25)

subtitle.Position = UDim2.new(0,0,0,30)

subtitle.BackgroundTransparency = 1

subtitle.Text = "anh.pro.mod"

subtitle.Font = Enum.Font.Gotham

subtitle.TextSize = 14

subtitle.TextColor3 = Color3.fromRGB(0,255,150)



-- ANIMACIÓN BORDE + SUBTÍTULO

task.spawn(function()

while true do


-- Verde oscuro

TweenService:Create(

stroke,

TweenInfo.new(1.5, Enum.EasingStyle.Linear),

{Color = Color3.fromRGB(0,120,60)}

):Play()



TweenService:Create(

subtitle,

TweenInfo.new(1.5, Enum.EasingStyle.Linear),

{TextColor3 = Color3.fromRGB(0,120,60)}

):Play()



task.wait(1.5)



-- Verde claro

TweenService:Create(

stroke,

TweenInfo.new(1.5, Enum.EasingStyle.Linear),

{Color = Color3.fromRGB(0,255,150)}

):Play()



TweenService:Create(

subtitle,

TweenInfo.new(1.5, Enum.EasingStyle.Linear),

{TextColor3 = Color3.fromRGB(0,255,150)}

):Play()



task.wait(1.5)

end

end)



--// GODMODE BUTTON

local godmodeBtn = Instance.new("TextButton", mainFrame)

godmodeBtn.Size = UDim2.new(0.85,0,0,45)

godmodeBtn.Position = UDim2.new(0.075,0,0,95)

godmodeBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)

godmodeBtn.TextColor3 = Color3.new(1,1,1)

godmodeBtn.Font = Enum.Font.GothamSemibold

godmodeBtn.TextSize = 15

godmodeBtn.Text = "Godmode: OFF"

godmodeBtn.BorderSizePixel = 0

Instance.new("UICorner", godmodeBtn).CornerRadius = UDim.new(0,12)



-- Click animation

godmodeBtn.MouseButton1Down:Connect(function()

TweenService:Create(godmodeBtn, TweenInfo.new(0.1),

{Size = godmodeBtn.Size - UDim2.new(0,5,0,5)}):Play()

end)



godmodeBtn.MouseButton1Up:Connect(function()

TweenService:Create(godmodeBtn, TweenInfo.new(0.1),

{Size = UDim2.new(0.85,0,0,45)}):Play()

end)



----------------------------------------------------------------

-- DRAG PC + MOVIL

----------------------------------------------------------------

local dragging = false

local dragStart, startPos



titleBar.InputBegan:Connect(function(input)

if input.UserInputType == Enum.UserInputType.MouseButton1

or input.UserInputType == Enum.UserInputType.Touch then


dragging = true

dragStart = input.Position

startPos = mainFrame.Position


input.Changed:Connect(function()

if input.UserInputState == Enum.UserInputState.End then

dragging = false

end

end)

end

end)



UserInputService.InputChanged:Connect(function(input)

if dragging and (

input.UserInputType == Enum.UserInputType.MouseMovement

or input.UserInputType == Enum.UserInputType.Touch

) then


local delta = input.Position - dragStart


mainFrame.Position = UDim2.new(

startPos.X.Scale,

startPos.X.Offset + delta.X,

startPos.Y.Scale,

startPos.Y.Offset + delta.Y

)

end

end)



----------------------------------------------------------------

-- GODMODE SYSTEM

----------------------------------------------------------------

local isGodmode = false

local ghostClone = nil

local connection = nil

local noclipConn = nil



local function cleanup()

isGodmode = false

godmodeBtn.Text = "Godmode: OFF"

godmodeBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)



if connection then connection:Disconnect() connection = nil end

if noclipConn then noclipConn:Disconnect() noclipConn = nil end



local char = player.Character

if char then

local root = char:FindFirstChild("HumanoidRootPart")

local hum = char:FindFirstChild("Humanoid")



for _, v in pairs(char:GetDescendants()) do

if v:IsA("BasePart") then

v.CanCollide = true

v.AssemblyLinearVelocity = Vector3.zero

end

end



if ghostClone and root then

root.CFrame = ghostClone.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)

end



if hum then

hum.PlatformStand = false

hum:ChangeState(Enum.HumanoidStateType.Landed)

camera.CameraSubject = hum

end

end



if ghostClone then ghostClone:Destroy() ghostClone = nil end

end



godmodeBtn.MouseButton1Click:Connect(function()

isGodmode = not isGodmode



local char = player.Character

if not char then return end

local root = char:FindFirstChild("HumanoidRootPart")

local hum = char:FindFirstChild("Humanoid")



if isGodmode and root and hum then



godmodeBtn.Text = "Godmode: ON"

godmodeBtn.BackgroundColor3 = Color3.fromRGB(0,180,0)



char.Archivable = true

ghostClone = char:Clone()

ghostClone.Parent = workspace

char.Archivable = false



for _, v in pairs(ghostClone:GetDescendants()) do

if v:IsA("BasePart") then

v.Transparency = 0.5

v.CanCollide = true

end

end



hum.PlatformStand = true

camera.CameraSubject = ghostClone.Humanoid



noclipConn = RunService.Stepped:Connect(function()

if isGodmode and char then

for _, v in pairs(char:GetDescendants()) do

if v:IsA("BasePart") then

v.CanCollide = false

end

end

end

end)



connection = RunService.Heartbeat:Connect(function()

if ghostClone and char:FindFirstChild("HumanoidRootPart") then

ghostClone.Humanoid:Move(hum.MoveDirection)

ghostClone.Humanoid.Jump = hum.Jump

root.CFrame = ghostClone.HumanoidRootPart.CFrame * CFrame.new(0, -10, 0)

root.AssemblyLinearVelocity = Vector3.zero

else

cleanup()

end

end)



else

cleanup()

end

end)
