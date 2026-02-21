-- NCT FULL MENU STYLE
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "NCT_Hub"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 340, 0, 260)
Main.Position = UDim2.new(0.05,0,0.3,0)
Main.BackgroundColor3 = Color3.fromRGB(10,10,10)
Main.BorderColor3 = Color3.fromRGB(255,120,170)
Main.BorderSizePixel = 2

-- DRAG
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- TITLE
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1
Title.Text = "NCT - Blox Fruits Hub"
Title.TextColor3 = Color3.fromRGB(255,120,170)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- MINIMIZE
local Mini = Instance.new("TextButton", Main)
Mini.Size = UDim2.new(0,30,0,30)
Mini.Position = UDim2.new(1,-30,0,0)
Mini.Text = "-"
Mini.BackgroundTransparency = 1
Mini.TextColor3 = Color3.fromRGB(255,120,170)

local minimized = false
Mini.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,v in pairs(Main:GetChildren()) do
        if v ~= Title and v ~= Mini then
            v.Visible = not minimized
        end
    end
end)

-- BUTTON MAKER
local function makeBtn(text,color,y)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9,0,0,35)
    b.Position = UDim2.new(0.05,0,0,y)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    return b
end

local Start = makeBtn("START HUNT", Color3.fromRGB(0,200,0), 40)
local Stop = makeBtn("STOP", Color3.fromRGB(200,0,0), 85)
local Hop = makeBtn("HOP SERVER", Color3.fromRGB(0,120,200), 130)
local ESP = makeBtn("ESP PLAYER", Color3.fromRGB(200,0,200), 175)

-- LOGIC
local hunting = false
local espOn = false

Start.MouseButton1Click:Connect(function()
    hunting = true
end)

Stop.MouseButton1Click:Connect(function()
    hunting = false
end)

Hop.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId)
end)

-- CLOSEST PLAYER
local function getClosest()
    local closest,dist=nil,math.huge
    for _,p in pairs(Players:GetPlayers()) do
        if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d=(p.Character.HumanoidRootPart.Position-LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if d<dist then
                dist=d
                closest=p
            end
        end
    end
    return closest
end

-- ESP
local highlight
ESP.MouseButton1Click:Connect(function()
    espOn = not espOn
    if highlight then highlight:Destroy() end
    
    if espOn then
        local target = getClosest()
        if target and target.Character then
            highlight = Instance.new("Highlight", target.Character)
            highlight.FillColor = Color3.fromRGB(255,0,255)
        end
    end
end)
