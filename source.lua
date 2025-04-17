-- SynthwaveUI Library with Notifications
-- Created by Claude
local SynthwaveUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Constants
local TWEEN_SPEED = 0.2
local SYNTHWAVE_COLORS = {
    Background = Color3.fromRGB(20, 14, 45),
    Accent = Color3.fromRGB(250, 84, 255),
    Secondary = Color3.fromRGB(43, 217, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Border = Color3.fromRGB(126, 0, 250),
    Success = Color3.fromRGB(0, 255, 128),
    Warning = Color3.fromRGB(255, 183, 0),
    Error = Color3.fromRGB(255, 0, 68)
}

-- Notification System
function SynthwaveUI:Notify(title, message, notifType, duration)
    duration = duration or 5
    local NotifGui = Instance.new("ScreenGui")
    local NotifFrame = Instance.new("Frame")
    local NotifTitle = Instance.new("TextLabel")
    local NotifMessage = Instance.new("TextLabel")
    local NotifBar = Instance.new("Frame")
    
    NotifGui.Name = "SynthwaveNotification"
    NotifGui.Parent = game.CoreGui
    
    NotifFrame.Name = "NotifFrame"
    NotifFrame.Parent = NotifGui
    NotifFrame.BackgroundColor3 = SYNTHWAVE_COLORS.Background
    NotifFrame.BorderColor3 = SYNTHWAVE_COLORS.Border
    NotifFrame.Position = UDim2.new(1, 20, 0.8, 0)
    NotifFrame.Size = UDim2.new(0, 300, 0, 80)
    NotifFrame.ClipsDescendants = true
    
    NotifTitle.Name = "NotifTitle"
    NotifTitle.Parent = NotifFrame
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Position = UDim2.new(0, 10, 0, 5)
    NotifTitle.Size = UDim2.new(1, -20, 0, 25)
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.Text = title
    NotifTitle.TextColor3 = SYNTHWAVE_COLORS.Text
    NotifTitle.TextSize = 16
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    NotifMessage.Name = "NotifMessage"
    NotifMessage.Parent = NotifFrame
    NotifMessage.BackgroundTransparency = 1
    NotifMessage.Position = UDim2.new(0, 10, 0, 30)
    NotifMessage.Size = UDim2.new(1, -20, 1, -40)
    NotifMessage.Font = Enum.Font.Gotham
    NotifMessage.Text = message
    NotifMessage.TextColor3 = SYNTHWAVE_COLORS.Text
    NotifMessage.TextSize = 14
    NotifMessage.TextWrapped = true
    NotifMessage.TextXAlignment = Enum.TextXAlignment.Left
    NotifMessage.TextYAlignment = Enum.TextYAlignment.Top
    
    NotifBar.Name = "NotifBar"
    NotifBar.Parent = NotifFrame
    NotifBar.BackgroundColor3 = SYNTHWAVE_COLORS[notifType or "Accent"]
    NotifBar.BorderSizePixel = 0
    NotifBar.Position = UDim2.new(0, 0, 1, -2)
    NotifBar.Size = UDim2.new(1, 0, 0, 2)
    
    -- Animate notification
    local function animateNotif()
        NotifFrame:TweenPosition(
            UDim2.new(1, -320, 0.8, 0),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quart,
            0.4,
            true
        )
        wait(duration)
        NotifFrame:TweenPosition(
            UDim2.new(1, 20, 0.8, 0),
            Enum.EasingDirection.In,
            Enum.EasingStyle.Quart,
            0.4,
            true
        )
        wait(0.4)
        NotifGui:Destroy()
    end
    
    coroutine.wrap(animateNotif)()
end

-- Create main window
function SynthwaveUI:CreateWindow(title)
    local Window = {}
    
    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local TopBar = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local CloseButton = Instance.new("TextButton")
    local MinimizeButton = Instance.new("TextButton")
    local ContentFrame = Instance.new("ScrollingFrame")
    
    ScreenGui.Name = "SynthwaveUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = SYNTHWAVE_COLORS.Background
    MainFrame.BorderColor3 = SYNTHWAVE_COLORS.Border
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.ClipsDescendants = true
    
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = SYNTHWAVE_COLORS.Accent
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = SYNTHWAVE_COLORS.Text
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.Size = UDim2.new(0, 30, 1, 0)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = SYNTHWAVE_COLORS.Text
    CloseButton.TextSize = 16
    
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TopBar
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
    MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = SYNTHWAVE_COLORS.Text
    MinimizeButton.TextSize = 16
    
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 0, 0, 30)
    ContentFrame.Size = UDim2.new(1, 0, 1, -30)
    ContentFrame.ScrollBarThickness = 4
    ContentFrame.ScrollBarImageColor3 = SYNTHWAVE_COLORS.Secondary
    
    -- Make window draggable
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function updateDrag(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)
    
    -- Close and minimize functionality
    local minimized = false
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        local targetSize = minimized and UDim2.new(1, 0, 0, 30) or UDim2.new(1, 0, 1, -30)
        TweenService:Create(ContentFrame, TweenInfo.new(TWEEN_SPEED), {Size = targetSize}):Play()
    end)
    
    -- Element creation functions
    function Window:AddButton(text, callback)
        local Button = Instance.new("TextButton")
        Button.Name = "Button"
        Button.Parent = ContentFrame
        Button.BackgroundColor3 = SYNTHWAVE_COLORS.Secondary
        Button.Size = UDim2.new(0.9, 0, 0, 30)
        Button.Position = UDim2.new(0.05, 0, 0, #ContentFrame:GetChildren() * 40)
        Button.Font = Enum.Font.GothamSemibold
        Button.Text = text
        Button.TextColor3 = SYNTHWAVE_COLORS.Text
        Button.TextSize = 14
        
        Button.MouseButton1Click:Connect(callback)
        return Button
    end
    
    function Window:AddToggle(text, default, callback)
        local ToggleFrame = Instance.new("Frame")
        local ToggleButton = Instance.new("TextButton")
        local ToggleIndicator = Instance.new("Frame")
        local ToggleLabel = Instance.new("TextLabel")
        
        ToggleFrame.Name = "ToggleFrame"
        ToggleFrame.Parent = ContentFrame
        ToggleFrame.BackgroundTransparency = 1
        ToggleFrame.Size = UDim2.new(0.9, 0, 0, 30)
        ToggleFrame.Position = UDim2.new(0.05, 0, 0, #ContentFrame:GetChildren() * 40)
        
        ToggleButton.Name = "ToggleButton"
        ToggleButton.Parent = ToggleFrame
        ToggleButton.BackgroundColor3 = SYNTHWAVE_COLORS.Secondary
        ToggleButton.Size = UDim2.new(0, 30, 0, 30)
        ToggleButton.Position = UDim2.new(0, 0, 0, 0)
        
        ToggleIndicator.Name = "ToggleIndicator"
        ToggleIndicator.Parent = ToggleButton
        ToggleIndicator.BackgroundColor3 = default and SYNTHWAVE_COLORS.Accent or SYNTHWAVE_COLORS.Background
        ToggleIndicator.Size = UDim2.new(0.6, 0, 0.6, 0)
        ToggleIndicator.Position = UDim2.new(0.2, 0, 0.2, 0)
        
        ToggleLabel.Name = "ToggleLabel"
        ToggleLabel.Parent = ToggleFrame
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Position = UDim2.new(0, 40, 0, 0)
        ToggleLabel.Size = UDim2.new(1, -40, 1, 0)
        ToggleLabel.Font = Enum.Font.GothamSemibold
        ToggleLabel.Text = text
        ToggleLabel.TextColor3 = SYNTHWAVE_COLORS.Text
        ToggleLabel.TextSize = 14
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local toggled = default
        
        ToggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            TweenService:Create(ToggleIndicator, TweenInfo.new(TWEEN_SPEED), {
                BackgroundColor3 = toggled and SYNTHWAVE_COLORS.Accent or SYNTHWAVE_COLORS.Background
            }):Play()
            callback(toggled)
        end)
        
        return ToggleFrame
    end
    
    function Window:AddSlider(text, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        local SliderLabel = Instance.new("TextLabel")
        local SliderBackground = Instance.new("Frame")
        local SliderFill = Instance.new("Frame")
        local SliderValue = Instance.new("TextLabel")
        
        SliderFrame.Name = "SliderFrame"
        SliderFrame.Parent = ContentFrame
        SliderFrame.BackgroundTransparency = 1
        SliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
        SliderFrame.Position = UDim2.new(0.05, 0, 0, #ContentFrame:GetChildren() * 60)
        
        SliderLabel.Name = "SliderLabel"
        SliderLabel.Parent = SliderFrame
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.Size = UDim2.new(1, 0, 0, 20)
        SliderLabel.Font = Enum.Font.GothamSemibold
        SliderLabel.Text = text
        SliderLabel.TextColor3 = SYNTHWAVE_COLORS.Text
        SliderLabel.TextSize = 14
        SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        SliderBackground.Name = "SliderBackground"
        SliderBackground.Parent = SliderFrame
        SliderBackground.BackgroundColor3 = SYNTHWAVE_COLORS.Secondary
        SliderBackground.Position = UDim2.new(0, 0, 0, 25)
        SliderBackground.Size = UDim2.new(1, 0, 0, 5)
        
        SliderFill.Name = "SliderFill"
        SliderFill.Parent = SliderBackground
        SliderFill.BackgroundColor3 = SYNTHWAVE_COLORS.Accent
        SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        
        SliderValue.Name = "SliderValue"
        SliderValue.Parent = SliderFrame
        SliderValue.BackgroundTransparency = 1
        SliderValue.Position = UDim2.new(0, 0, 0, 35)
        SliderValue.Size = UDim2.new(1, 0, 0, 20)
        SliderValue.Font = Enum.Font.GothamSemibold
        SliderValue.Text = tostring(default)
        SliderValue.TextColor3 = SYNTHWAVE_COLORS.Text
        SliderValue.TextSize = 14
        
        local function updateSlider(input)
            local pos = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * pos)
            SliderFill.Size = UDim2.new(pos, 0, 1, 0)
            SliderValue.Text = tostring(value)
            callback(value)
        end
        
        SliderBackground.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                updateSlider(input)
                local connection
                connection = RunService.RenderStepped:Connect(function()
                    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                        updateSlider(input)
                    else
                        connection:Disconnect()
                    end
                end)
            end
        end)
        
        return SliderFrame
    end
    
    function Window:AddDropdown(text, options, callback)
        local DropdownFrame = Instance.new("Frame")
        local DropdownButton = Instance.new("TextButton")
        local DropdownList = Instance.new("ScrollingFrame")
        
        DropdownFrame.Name = "DropdownFrame"
        DropdownFrame.Parent = ContentFrame
        DropdownFrame.BackgroundTransparency = 1
        DropdownFrame.Size = UDim2.new(0.9, 0, 0, 30)
        DropdownFrame.Position = UDim2.new(0.05, 0, 0, #ContentFrame:GetChildren() * 40)
        
        DropdownButton.Name = "DropdownButton"
        DropdownButton.Parent = DropdownFrame
        DropdownButton.BackgroundColor3 = SYNTHWAVE_COLORS.Secondary
        DropdownButton.Size = UDim2.new(1, 0, 1, 0)
        DropdownButton.Font = Enum.Font.GothamSemibold
        DropdownButton.Text = text
        DropdownButton.TextColor3 = SYNTHWAVE_COLORS.Text
        DropdownButton.TextSize = 14
        
        DropdownList.Name = "DropdownList"
        DropdownList.Parent = DropdownFrame
        DropdownList.BackgroundColor3 = SYNTHWAVE_COLORS.Background
        DropdownList.BorderColor3 = SYNTHWAVE_COLORS.Border
        DropdownList.Position = UDim2.new(0, 0, 1, 0)
        DropdownList.Size = UDim2.new(1, 0, 0, 0)
        DropdownList.ScrollBarThickness = 4
        DropdownList.ScrollBarImageColor3 = SYNTHWAVE_COLORS.Secondary
        DropdownList.Visible = false
        
        local function createOption(optionText)
            local OptionButton = Instance.new("TextButton")
            OptionButton.Name = "OptionButton"
            OptionButton.Parent = DropdownList
            OptionButton.BackgroundColor3 = SYNTHWAVE_COLORS.Background
            OptionButton.Size = UDim2.new(1, 0, 0, 30)
            OptionButton.Position = UDim2.new(0, 0, 0, #DropdownList:GetChildren() * 30)
            OptionButton.Font = Enum.Font.GothamSemibold
            OptionButton.Text = optionText
            OptionButton.TextColor3 = SYNTHWAVE_COLORS.Text
            OptionButton.TextSize = 14
            
            OptionButton.MouseButton1Click:Connect(function()
                DropdownButton.Text = text .. ": " .. optionText
                DropdownList.Visible = false
                callback(optionText)
            end)
        end
        
        for _, option in ipairs(options) do
            createOption(option)
        end
        
        DropdownList.Size = UDim2.new(1, 0, 0, math.min(#options * 30, 150))
        
        local dropdownOpen = false
        
        DropdownButton.MouseButton1Click:Connect(function()
            dropdownOpen = not dropdownOpen
            DropdownList.Visible = dropdownOpen
        end)
        
        return DropdownFrame
    end
    
    return Window
end

return SynthwaveUI
