-- Enhanced Synthwave UI Library
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Create main Library module with all necessary properties
local Library = {
    Elements = {},
    Windows = {},
    Theme = {
        Primary = Color3.fromRGB(255, 65, 125),
        Secondary = Color3.fromRGB(41, 21, 61),
        Background = Color3.fromRGB(22, 12, 46),
        TextColor = Color3.fromRGB(255, 255, 255),
        AccentColor = Color3.fromRGB(120, 220, 255),
        DarkContrast = Color3.fromRGB(15, 8, 31),
        LightContrast = Color3.fromRGB(33, 17, 52),
        ToggleOn = Color3.fromRGB(255, 65, 125),
        ToggleOff = Color3.fromRGB(41, 21, 61),
        Gradient1 = Color3.fromRGB(255, 0, 255),
        Gradient2 = Color3.fromRGB(0, 255, 255),
        ErrorColor = Color3.fromRGB(255, 0, 0),
        SuccessColor = Color3.fromRGB(0, 255, 0)
    },
    Settings = {
        AnimationDuration = 0.3,
        EasingStyle = Enum.EasingStyle.Quart,
        EasingDirection = Enum.EasingDirection.Out,
        NotificationDuration = 3,
        BlurEffect = true,
        TooltipsEnabled = true,
        SoundEffects = true,
        MinimizeKeybind = Enum.KeyCode.RightControl
    },
    Fonts = {
        Regular = Enum.Font.Gotham,
        Bold = Enum.Font.GothamBold,
        SemiBold = Enum.Font.GothamSemibold,
        Light = Enum.Font.GothamLight
    }
}

-- Utility Functions
local function CreateTween(instance, properties, duration, style, direction)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(
            duration or Library.Settings.AnimationDuration,
            style or Library.Settings.EasingStyle,
            direction or Library.Settings.EasingDirection
        ),
        properties
    )
    return tween
end

local function CreateElement(elementType, properties)
    local element = Instance.new(elementType)
    for property, value in pairs(properties) do
        element[property] = value
    end
    return element
end

-- Enhanced Notification System
function Library:CreateNotification(title, text, notificationType, duration)
    local NotificationGui = CreateElement("ScreenGui", {
        Name = "EnhancedNotification",
        Parent = CoreGui
    })
    
    local NotificationFrame = CreateElement("Frame", {
        Name = "NotificationFrame",
        BackgroundColor3 = Library.Theme.Background,
        Position = UDim2.new(1, 20, 0.8, 0),
        Size = UDim2.new(0, 300, 0, 100),
        Parent = NotificationGui
    })
    
    -- Add gradient and glow effect
    local UIGradient = CreateElement("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.Theme.Gradient1),
            ColorSequenceKeypoint.new(1, Library.Theme.Gradient2)
        }),
        Rotation = 45,
        Parent = NotificationFrame
    })
    
    local UIStroke = CreateElement("UIStroke", {
        Color = notificationType == "error" and Library.Theme.ErrorColor or 
                notificationType == "success" and Library.Theme.SuccessColor or
                Library.Theme.Primary,
        Thickness = 2,
        Parent = NotificationFrame
    })
    
    local Corner = CreateElement("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = NotificationFrame
    })
    
    -- Icon based on notification type
    local Icon = CreateElement("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(0, 24, 0, 24),
        Image = notificationType == "error" and "rbxassetid://6031071057" or
                notificationType == "success" and "rbxassetid://6031071053" or
                "rbxassetid://6031071050",
        Parent = NotificationFrame
    })
    
    local TitleLabel = CreateElement("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 44, 0, 10),
        Size = UDim2.new(1, -54, 0, 24),
        Font = Library.Fonts.Bold,
        Text = title,
        TextColor3 = Library.Theme.TextColor,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = NotificationFrame
    })
    
    local TextLabel = CreateElement("TextLabel", {
        Name = "Text",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 44),
        Size = UDim2.new(1, -20, 0, 46),
        Font = Library.Fonts.Regular,
        Text = text,
        TextColor3 = Library.Theme.TextColor,
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = NotificationFrame
    })
    
    -- Progress bar
    local ProgressBar = CreateElement("Frame", {
        Name = "ProgressBar",
        BackgroundColor3 = Library.Theme.Primary,
        Position = UDim2.new(0, 0, 1, -2),
        Size = UDim2.new(1, 0, 0, 2),
        Parent = NotificationFrame
    })
    
    -- Animations
    local appearTween = CreateTween(NotificationFrame, {
        Position = UDim2.new(1, -320, 0.8, 0)
    })
    
    local disappearTween = CreateTween(NotificationFrame, {
        Position = UDim2.new(1, 20, 0.8, 0)
    })
    
    local progressTween = CreateTween(ProgressBar, {
        Size = UDim2.new(0, 0, 0, 2)
    }, duration or Library.Settings.NotificationDuration)
    
    -- Play sound effect if enabled
    if Library.Settings.SoundEffects then
        local sound = Instance.new("Sound")
        sound.SoundId = notificationType == "error" and "rbxassetid://6031071076" or
                      notificationType == "success" and "rbxassetid://6031071073" or
                      "rbxassetid://6031071070"
        sound.Volume = 0.5
        sound.Parent = NotificationFrame
        sound:Play()
    end
    
    appearTween:Play()
    progressTween:Play()
    
    task.delay(duration or Library.Settings.NotificationDuration, function()
        disappearTween:Play()
        disappearTween.Completed:Connect(function()
            NotificationGui:Destroy()
        end)
    end)
end

-- Enhanced Window Creation with Homepage
function Library:CreateWindow(title, config)
    config = config or {}
    
    local Window = {
        Tabs = {},
        TabCount = 0,
        Toggled = true,
        CurrentTab = nil
    }
    
    -- Main GUI Elements with Blur Effect
    local ScreenGui = CreateElement("ScreenGui", {
        Name = "EnhancedSynthwaveUI",
        Parent = CoreGui
    })
    
    if Library.Settings.BlurEffect then
        local blur = Instance.new("BlurEffect")
        blur.Size = 0
        blur.Parent = game:GetService("Lighting")
        
        CreateTween(blur, {Size = 10}):Play()
        
        ScreenGui:GetPropertyChangedSignal("Parent"):Connect(function()
            if not ScreenGui.Parent then
                CreateTween(blur, {Size = 0}):Play()
                game:GetService("Debris"):AddItem(blur, 0.5)
            end
        end)
    end
    
    -- Main Frame with enhanced design
    local MainFrame = CreateElement("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = Library.Theme.Background,
        Position = UDim2.new(0.5, -400, 0.5, -250),
        Size = UDim2.new(0, 800, 0, 500),
        Parent = ScreenGui
    })
    
    local MainCorner = CreateElement("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = MainFrame
    })
    
    -- Add gradient and glow effects
    local MainGradient = CreateElement("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.Theme.Background),
            ColorSequenceKeypoint.new(1, Library.Theme.DarkContrast)
        }),
        Rotation = 45,
        Parent = MainFrame
    })
    
    local GlowEffect = CreateElement("ImageLabel", {
        Name = "Glow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = 0,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Library.Theme.Primary,
        ImageTransparency = 0.6,
        Parent = MainFrame
    })
    
    -- Top Bar with enhanced design
    local TopBar = CreateElement("Frame", {
        Name = "TopBar",
        BackgroundColor3 = Library.Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = MainFrame
    })
    
    local TopBarCorner = CreateElement("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = TopBar
    })
    
    local TopBarGradient = CreateElement("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.Theme.Secondary),
            ColorSequenceKeypoint.new(1, Library.Theme.DarkContrast)
        }),
        Rotation = 90,
        Parent = TopBar
    })
    
    -- Title with icon
    local TitleContainer = CreateElement("Frame", {
        Name = "TitleContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0, 200, 1, 0),
        Parent = TopBar
    })
    
    local Icon = CreateElement("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.5, -15),
        Size = UDim2.new(0, 30, 0, 30),
        Image = config.icon or "rbxassetid://6031280882",
        Parent = TitleContainer
    })
    
    local TitleLabel = CreateElement("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 40, 0, 0),
        Size = UDim2.new(1, -40, 1, 0),
        Font = Library.Fonts.Bold,
        Text = title,
        TextColor3 = Library.Theme.TextColor,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TitleContainer
    })
    
    -- Window Controls
    local Controls = CreateElement("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -100, 0, 0),
        Size = UDim2.new(0, 90, 1, 0),
        Parent = TopBar
    })
    
    local MinimizeButton = CreateElement("ImageButton", {
        Name = "Minimize",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.5, -15),
        Size = UDim2.new(0, 30, 0, 30),
        Image = "rbxassetid://6031082533",
        Parent = Controls
    })
    
    local CloseButton = CreateElement("ImageButton", {
        Name = "Close",
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 0.5, -15),
        Size = UDim2.new(0, 30, 0, 30),
        Image = "rbxassetid://6031094678",
        Parent = Controls
    })
    
    -- Tab Container
    local TabContainer = CreateElement("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = Library.Theme.Secondary,
        Position = UDim2.new(0, 10, 0, 50),
        Size = UDim2.new(0, 130, 1, -60),
        Parent = MainFrame
    })
    
    local TabContainerCorner = CreateElement("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = TabContainer
    })
    
    local TabScroll = CreateElement("ScrollingFrame", {
        Name = "TabScroll",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 5, 0, 5),
        Size = UDim2.new(1, -10, 1, -10),
        ScrollBarThickness = 3,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Parent = TabContainer
    })
    
    local TabList = CreateElement("UIListLayout", {
        Padding = UDim.new(0, 5),
        Parent = TabScroll
    })
    
    -- Content Container
    local ContentContainer = CreateElement("Frame", {
        Name = "ContentContainer",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 150, 0, 50),
        Size = UDim2.new(1, -160, 1, -60),
        Parent = MainFrame
    })

    -- Add drag functionality
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Toggle visibility with keybind
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Library.Settings.MinimizeKeybind then
            Window.Toggled = not Window.Toggled
            MainFrame.Visible = Window.Toggled
        end
    end)
    
    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Minimize button functionality
    MinimizeButton.MouseButton1Click:Connect(function()
        Window.Toggled = not Window.Toggled
        ContentContainer.Visible = Window.Toggled
        TabContainer.Visible = Window.Toggled
        
        -- Resize window when minimized
        if Window.Toggled then
            CreateTween(MainFrame, {Size = UDim2.new(0, 800, 0, 500)}):Play()
        else
            CreateTween(MainFrame, {Size = UDim2.new(0, 800, 0, 40)}):Play()
        end
    end)
    
    -- Tab creation function
    function Window:CreateTab(name, icon)
        local Tab = {
            Name = name,
            Sections = {},
            Visible = false
        }
        
        -- Create tab button
        local TabButton = CreateElement("Frame", {
            Name = name .. "Tab",
            BackgroundColor3 = Library.Theme.DarkContrast,
            Size = UDim2.new(1, 0, 0, 40),
            Parent = TabScroll
        })
        
        local TabButtonCorner = CreateElement("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = TabButton
        })
        
        local TabIcon = CreateElement("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0.5, -10),
            Size = UDim2.new(0, 20, 0, 20),
            Image = icon or "rbxassetid://6034319900", -- Default icon
            Parent = TabButton
        })
        
        local TabName = CreateElement("TextLabel", {
            Name = "Name",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 40, 0, 0),
            Size = UDim2.new(1, -40, 1, 0),
            Font = Library.Fonts.Regular,
            Text = name,
            TextColor3 = Library.Theme.TextColor,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabButton
        })
        
        -- Create content frame for this tab
        local TabContent = CreateElement("ScrollingFrame", {
            Name = name .. "Content",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 3,
            Visible = false,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Parent = ContentContainer
        })
        
        local TabContentList = CreateElement("UIListLayout", {
            Padding = UDim.new(0, 10),
            Parent = TabContent
        })
        
        -- Update canvas size when elements are added
        TabContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentList.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab selection logic
        TabButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                -- Hide all other tabs and show this one
                for _, tab in pairs(Window.Tabs) do
                    tab.Visible = false
                    tab.TabContent.Visible = false
                    tab.TabButton.BackgroundColor3 = Library.Theme.DarkContrast
                end
                
                Tab.Visible = true
                TabContent.Visible = true
                TabButton.BackgroundColor3 = Library.Theme.Primary
                
                Window.CurrentTab = Tab
            end
        end)
        
        -- Section creation function
        function Tab:CreateSection(name)
            local Section = {
                Name = name,
                Elements = {}
            }
            
            local SectionContainer = CreateElement("Frame", {
                Name = name .. "Section",
                BackgroundColor3 = Library.Theme.LightContrast,
                Size = UDim2.new(1, -20, 0, 40), -- Initial size, will expand as elements are added
                Parent = TabContent
            })
            
            local SectionCorner = CreateElement("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = SectionContainer
            })
            
            local SectionTitle = CreateElement("TextLabel", {
                Name = "Title",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 0),
                Size = UDim2.new(1, -20, 0, 30),
                Font = Library.Fonts.Bold,
                Text = name,
                TextColor3 = Library.Theme.TextColor,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SectionContainer
            })
            
            local SectionContent = CreateElement("Frame", {
                Name = "Content",
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 30),
                Size = UDim2.new(1, -20, 0, 0), -- Will be resized as elements are added
                Parent = SectionContainer
            })
            
            local SectionList = CreateElement("UIListLayout", {
                Padding = UDim.new(0, 10),
                Parent = SectionContent
            })
            
            -- Update section size when elements are added
            SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionContent.Size = UDim2.new(1, -20, 0, SectionList.AbsoluteContentSize.Y)
                SectionContainer.Size = UDim2.new(1, -20, 0, SectionList.AbsoluteContentSize.Y + 40) -- +40 for the title
            end)
            
            -- Button Element
            function Section:CreateButton(text, callback)
                callback = callback or function() end
                
                local Button = CreateElement("Frame", {
                    Name = text .. "Button",
                    BackgroundColor3 = Library.Theme.Secondary,
                    Size = UDim2.new(1, 0, 0, 35),
                    Parent = SectionContent
                })
                
                local ButtonCorner = CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = Button
                })
                
                local ButtonLabel = CreateElement("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -20, 1, 0),
                    Font = Library.Fonts.Regular,
                    Text = text,
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    Parent = Button
                })
                
                -- Click effect
                Button.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        -- Ripple effect
                        CreateTween(Button, {BackgroundColor3 = Library.Theme.Primary}):Play()
                        
                        if Library.Settings.SoundEffects then
                            local sound = Instance.new("Sound")
                            sound.SoundId = "rbxassetid://6031090203"
                            sound.Volume = 0.2
                            sound.Parent = Button
                            sound:Play()
                            game:GetService("Debris"):AddItem(sound, 1)
                        end
                        
                        task.spawn(callback)
                        
                        task.delay(0.2, function()
                            CreateTween(Button, {BackgroundColor3 = Library.Theme.Secondary}):Play()
                        end)
                    end
                end)
                
                return Button
            end
            
            -- Toggle Element
            function Section:CreateToggle(text, default, callback)
                default = default or false
                callback = callback or function() end
                
                local Toggle = {
                    Value = default,
                    Text = text
                }
                
                local ToggleFrame = CreateElement("Frame", {
                    Name = text .. "Toggle",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 35),
                    Parent = SectionContent
                })
                
                local ToggleLabel = CreateElement("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -50, 1, 0),
                    Font = Library.Fonts.Regular,
                    Text = text,
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ToggleFrame
                })
                
                local ToggleButton = CreateElement("Frame", {
                    Name = "Button",
                    BackgroundColor3 = default and Library.Theme.ToggleOn or Library.Theme.ToggleOff,
                    Position = UDim2.new(1, -35, 0.5, -10),
                    Size = UDim2.new(0, 40, 0, 20),
                    Parent = ToggleFrame
                })
                
                local ToggleButtonCorner = CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 10),
                    Parent = ToggleButton
                })
                
                local ToggleIndicator = CreateElement("Frame", {
                    Name = "Indicator",
                    BackgroundColor3 = Library.Theme.TextColor,
                    Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                    Size = UDim2.new(0, 16, 0, 16),
                    Parent = ToggleButton
                })
                
                local ToggleIndicatorCorner = CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 8),
                    Parent = ToggleIndicator
                })
                
                -- Toggle logic
                ToggleFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Toggle.Value = not Toggle.Value
                        
                        if Library.Settings.SoundEffects then
                            local sound = Instance.new("Sound")
                            sound.SoundId = "rbxassetid://6031091000"
                            sound.Volume = 0.2
                            sound.Parent = ToggleFrame
                            sound:Play()
                            game:GetService("Debris"):AddItem(sound, 1)
                        end
                        
                        if Toggle.Value then
                            CreateTween(ToggleButton, {BackgroundColor3 = Library.Theme.ToggleOn}):Play()
                            CreateTween(ToggleIndicator, {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
                        else
                            CreateTween(ToggleButton, {BackgroundColor3 = Library.Theme.ToggleOff}):Play()
                            CreateTween(ToggleIndicator, {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                        end
                        
                        task.spawn(function()
                            callback(Toggle.Value)
                        end)
                    end
                end)
                
                function Toggle:Set(value)
                    Toggle.Value = value
                    
                    if Toggle.Value then
                        CreateTween(ToggleButton, {BackgroundColor3 = Library.Theme.ToggleOn}):Play()
                        CreateTween(ToggleIndicator, {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
                    else
                        CreateTween(ToggleButton, {BackgroundColor3 = Library.Theme.ToggleOff}):Play()
                        CreateTween(ToggleIndicator, {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                    end
                    
                    task.spawn(function()
                        callback(Toggle.Value)
                    end)
                end
                
                return Toggle
            end
            
            -- Slider Element
            function Section:CreateSlider(text, min, max, default, callback)
                min = min or 0
                max = max or 100
                default = default or min
                callback = callback or function() end
                
                local Slider = {
                    Value = default,
                    Min = min,
                    Max = max,
                    Text = text
                }
                
                local SliderFrame = CreateElement("Frame", {
                    Name = text .. "Slider",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 50),
                    Parent = SectionContent
                })
                
                local SliderLabel = CreateElement("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -20, 0, 20),
                    Font = Library.Fonts.Regular,
                    Text = text .. ": " .. default,
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = SliderFrame
                })
                
                local SliderBackground = CreateElement("Frame", {
                    Name = "Background",
                    BackgroundColor3 = Library.Theme.Secondary,
                    Position = UDim2.new(0, 10, 0, 25),
                    Size = UDim2.new(1, -20, 0, 10),
                    Parent = SliderFrame
                })
                
                local SliderBackgroundCorner = CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 5),
                    Parent = SliderBackground
                })
                
                local SliderFill = CreateElement("Frame", {
                    Name = "Fill",
                    BackgroundColor3 = Library.Theme.Primary,
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                    Parent = SliderBackground
                })
                
                local SliderFillCorner = CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 5),
                    Parent = SliderFill
                })
                
                local SliderIndicator = CreateElement("Frame", {
                    Name = "Indicator",
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Library.Theme.TextColor,
                    Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0),
                    Size = UDim2.new(0, 15, 0, 15),
                    ZIndex = 2,
                    Parent = SliderBackground
                })
                
                local SliderIndicatorCorner = CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 7.5),
                    Parent = SliderIndicator
                })
                
                -- Slider functionality
                local dragging = false
                
                SliderBackground.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        
                        if Library.Settings.SoundEffects then
                            local sound = Instance.new("Sound")
                            sound.SoundId = "rbxassetid://6031094676"
                            sound.Volume = 0.2
                            sound.Parent = SliderFrame
                            sound:Play()
                            game:GetService("Debris"):AddItem(sound, 1)
                        end
                        
                        -- Update slider right away
                        local relativePosition = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
                        local value = math.floor(min + (max - min) * relativePosition)
                        
                        Slider.Value = value
                        SliderLabel.Text = text .. ": " .. value
                        SliderFill.Size = UDim2.new(relativePosition, 0, 1, 0)
                        SliderIndicator.Position = UDim2.new(relativePosition, 0, 0.5, 0)
                        
                        task.spawn(function()
                            callback(value)
                        end)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        -- Calculate the relative position of the mouse on the slider
                        local relativePosition = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
                        local value = math.floor(min + (max - min) * relativePosition)
                        
                        Slider.Value = value
                        SliderLabel.Text = text .. ": " .. value
                        SliderFill.Size = UDim2.new(relativePosition, 0, 1, 0)
                        SliderIndicator.Position = UDim2.new(relativePosition, 0, 0.5, 0)
                        
                        task.spawn(function()
                            callback(value)
                        end)
                    end
                end)
                
                function Slider:Set(value)
                    value = math.clamp(value, min, max)
                    Slider.Value = value
                    
                    local relativePosition = (value - min) / (max - min)
                    SliderLabel.Text = text .. ": " .. value
                    SliderFill.Size = UDim2.new(relativePosition, 0, 1, 0)
                    SliderIndicator.Position = UDim2.new(relativePosition, 0, 0.5, 0)
                    
                    task.spawn(function()
                        callback(value)
                    end)
                end
                
                return Slider
            end
            
            -- Dropdown Element
            function Section:CreateDropdown(text, options, default, callback)
                options = options or {}
                callback = callback or function() end
                
                local Dropdown = {
                    Value = default,
                    Options = options,
                    Text = text,
                    Opened = false
                }
                
                local DropdownFrame = CreateElement("Frame", {
                    Name = text .. "Dropdown",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 35),
                    ClipsDescendants = true,
                    Parent = SectionContent
                })
                
                local DropdownButton = CreateElement("Frame", {
                    Name = "Button",
                    BackgroundColor3 = Library.Theme.Secondary,
                    Size = UDim2.new(1, 0, 0, 35),
                    Parent = DropdownFrame
                })
                
                local DropdownButtonCorner = CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = DropdownButton
                })
                
                local DropdownLabel = CreateElement("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -40, 1, 0),
                    Font = Library.Fonts.Regular,
                    Text = text .. ": " .. (default or "None"),
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = DropdownButton
                })
                
                local DropdownArrow = CreateElement("ImageLabel", {
                    Name = "Arrow",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -30, 0.5, -10),
                    Size = UDim2.new(0, 20, 0, 20),
                    Image = "rbxassetid://6031094670",
                    Parent = DropdownButton
                })
                
                local DropdownContent = CreateElement("Frame", {
                    Name = "Content",
                    BackgroundColor3 = Library.Theme.LightContrast,
                    Position = UDim2.new(0, 0, 0, 40),
                    Size = UDim2.new(1, 0, 0, #options * 25),
                    Visible = false,
                    ZIndex = 3,
                    Parent = DropdownFrame
                })
                
                local DropdownContentCorner = CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = DropdownContent
                })
                
                local DropdownOptionList = CreateElement("UIListLayout", {
                    Padding = UDim.new(0, 5),
                    Parent = DropdownContent
                })
                
                -- Add options
                for i, option in ipairs(options) do
                    local OptionButton = CreateElement("TextButton", {
                        Name = option,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 20),
                        Font = Library.Fonts.Regular,
                        Text = option,
                        TextColor3 = Library.Theme.TextColor,
                        TextSize = 14,
                        ZIndex = 3,
                        Parent = DropdownContent
                    })
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        Dropdown.Value = option
                        DropdownLabel.Text = text .. ": " .. option
                        
                        if Library.Settings.SoundEffects then
                            local sound = Instance.new("Sound")
                            sound.SoundId = "rbxassetid://6031091001"
                            sound.Volume = 0.2
                            sound.Parent = DropdownFrame
                            sound:Play()
                            game:GetService("Debris"):AddItem(sound, 1)
                        end
                        
                        -- Close the dropdown
                        Dropdown.Opened = false
                        CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35)}):Play()
                        CreateTween(DropdownArrow, {Rotation = 0}):Play()
                        task.delay(0.2, function()
                            DropdownContent.Visible = false
                        end)
                        
                        task.spawn(function()
                            callback(option)
                        end)
                    end)
                end
                
                -- Dropdown toggle
                DropdownButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Dropdown.Opened = not Dropdown.Opened
                        
                        if Library.Settings.SoundEffects then
                            local sound = Instance.new("Sound")
                            sound.SoundId = "rbxassetid://6031091002"
                            sound.Volume = 0.2
                            sound.Parent = DropdownFrame
                            sound:Play()
                            game:GetService("Debris"):AddItem(sound, 1)
                        end
                        
                        if Dropdown.Opened then
                            DropdownContent.Visible = true
                            CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35 + DropdownContent.Size.Y.Offset + 5)}):Play()
                            CreateTween(DropdownArrow, {Rotation = 180}):Play()
                        else
                            CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35)}):Play()
                            CreateTween(DropdownArrow, {Rotation = 0}):Play()
                            task.delay(0.2, function()
                                DropdownContent.Visible = false
                            end)
                        end
                    end
                end)
                
                function Dropdown:Set(option)
                    if table.find(options, option) then
                        Dropdown.Value = option
                        DropdownLabel.Text = text .. ": " .. option
                        
                        task.spawn(function()
                            callback(option)
                        end)
                    end
                end
                
                function Dropdown:Refresh(newOptions, keepValue)
                    options = newOptions
                    Dropdown.Options = newOptions
                    
                    -- Clear existing options
                    for _, child in pairs(DropdownContent:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    -- Update dropdown content size
                    DropdownContent.Size = UDim2.new(1, 0, 0, #newOptions * 25)
                    
                    -- Add new options
                    for i, option in ipairs(newOptions) do
                        local OptionButton = CreateElement("TextButton", {
                            Name = option,
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, 0, 20),
                            Font = Library.Fonts.Regular,
                            Text = option,
                            TextColor3 = Library.Theme.TextColor,
                            TextSize = 14,
                            ZIndex = 3,
                            Parent = DropdownContent
                        })
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            Dropdown.Value = option
                            DropdownLabel.Text = text .. ": " .. option
                            
                            if Library.Settings.SoundEffects then
                                local sound = Instance.new("Sound")
                                sound.SoundId = "rbxassetid://6031091001"
                                sound.Volume = 0.2
                                sound.Parent = DropdownFrame
                                sound:Play()
                                game:GetService("Debris"):AddItem(sound, 1)
                            end
                            
                            -- Close the dropdown
                            Dropdown.Opened = false
                            CreateTween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 35)}):Play()
                            CreateTween(DropdownArrow, {Rotation = 0}):Play()
                            task.delay(0.2, function()
                                DropdownContent.Visible = false
                            end)
                            
                            task.spawn(function()
                                callback(option)
                            end)
                        end)
                    end
                    
                    -- Update value if needed
                    if not keepValue or not table.find(newOptions, Dropdown.Value) then
                        Dropdown.Value = newOptions[1] or "None"
                        DropdownLabel.Text = text .. ": " .. (newOptions[1] or "None")
                    end
                end
                
                return Dropdown
            end
            
            -- TextBox Element
            function Section:CreateTextBox(text, placeholder, callback)
                placeholder = placeholder or ""
                callback = callback or function() end
                
                local TextBox = {
                    Value = "",
                    Text = text
                }
                
                local TextBoxFrame = CreateElement("Frame", {
                    Name = text .. "TextBox",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 35),
                    Parent = SectionContent
                })
                
                local TextBoxLabel = CreateElement("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -20, 0, 20),
                    Font = Library.Fonts.Regular,
                    Text = text,
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = TextBoxFrame
                })
                
                local TextBoxContainer = CreateElement("Frame", {
                    Name = "Container",
                    BackgroundColor3 = Library.Theme.Secondary,
                    Position = UDim2.new(0, 10, 0, 20),
                    Size = UDim2.new(1, -20, 0, 25),
                    Parent = TextBoxFrame
                })
                
                local TextBoxContainerCorner = CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = TextBoxContainer
                })
                
                local TextInput = CreateElement("TextBox", {
                    Name = "Input",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -20, 1, 0),
                    Font = Library.Fonts.Regular,
                    PlaceholderText = placeholder,
                    Text = "",
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = TextBoxContainer
                })
                
                -- TextBox functionality
                TextInput.FocusLost:Connect(function(enterPressed)
                    TextBox.Value = TextInput.Text
                    
                    if Library.Settings.SoundEffects then
                        local sound = Instance.new("Sound")
                        sound.SoundId = "rbxassetid://6031090203"
                        sound.Volume = 0.2
                        sound.Parent = TextBoxFrame
                        sound:Play()
                        game:GetService("Debris"):AddItem(sound, 1)
                    end
                    
                    if enterPressed then
                        task.spawn(function()
                            callback(TextInput.Text)
                        end)
                    end
                end)
                
                function TextBox:Set(value)
                    TextBox.Value = value
                    TextInput.Text = value
                    
                    task.spawn(function()
                        callback(value)
                    end)
                end
                
                return TextBox
            end
            
            -- ColorPicker Element
            function Section:CreateColorPicker(text, default, callback)
                default = default or Color3.fromRGB(255, 255, 255)
                callback = callback or function() end
                
                local ColorPicker = {
                    Value = default,
                    Text = text,
                    Opened = false
                }
                
                local ColorPickerFrame = CreateElement("Frame", {
                    Name = text .. "ColorPicker",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 35),
                    ClipsDescendants = true,
                    Parent = SectionContent
                })
                
                local ColorPickerButton = CreateElement("Frame", {
                    Name = "Button",
                    BackgroundColor3 = Library.Theme.Secondary,
                    Size = UDim2.new(1, 0, 0, 35),
                    Parent = ColorPickerFrame
                })
                
                local ColorPickerButtonCorner = CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = ColorPickerButton
                })
                
                local ColorPickerLabel = CreateElement("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -60, 1, 0),
                    Font = Library.Fonts.Regular,
                    Text = text,
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = ColorPickerButton
                })
                
                local ColorDisplay = CreateElement("Frame", {
                    Name = "ColorDisplay",
                    BackgroundColor3 = default,
                    Position = UDim2.new(1, -50, 0.5, -10),
                    Size = UDim2.new(0, 40, 0, 20),
                    Parent = ColorPickerButton
                })
                
                local ColorDisplayCorner = CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = ColorDisplay
                })
                
                -- Color picker panel
                local ColorPickerPanel = CreateElement("Frame", {
                    Name = "Panel",
                    BackgroundColor3 = Library.Theme.LightContrast,
                    Position = UDim2.new(0, 0, 0, 40),
                    Size = UDim2.new(1, 0, 0, 150),
                    Visible = false,
                    ZIndex = 3,
                    Parent = ColorPickerFrame
                })
                
                local ColorPickerPanelCorner = CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = ColorPickerPanel
                })
                
                -- RGB sliders
                local RSlider = CreateElement("Frame", {
                    Name = "RedSlider",
                    BackgroundColor3 = Color3.fromRGB(200, 0, 0),
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, -20, 0, 20),
                    ZIndex = 3,
                    Parent = ColorPickerPanel
                })
                
                local RSliderCorner = CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = RSlider
                })
                
                local RIndicator = CreateElement("Frame", {
                    Name = "Indicator",
                    BackgroundColor3 = Library.Theme.TextColor,
                    Position = UDim2.new(default.R, 0, 0.5, 0),
                    Size = UDim2.new(0, 5, 1, 0),
                    ZIndex = 4,
                    Parent = RSlider
                })
                
                local GSlider = CreateElement("Frame", {
                    Name = "GreenSlider",
                    BackgroundColor3 = Color3.fromRGB(0, 200, 0),
                    Position = UDim2.new(0, 10, 0, 40),
                    Size = UDim2.new(1, -20, 0, 20),
                    ZIndex = 3,
                    Parent = ColorPickerPanel
                })
                
                local GSliderCorner = CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = GSlider
                })
                
                local GIndicator = CreateElement("Frame", {
                    Name = "Indicator",
                    BackgroundColor3 = Library.Theme.TextColor,
                    Position = UDim2.new(default.G, 0, 0.5, 0),
                    Size = UDim2.new(0, 5, 1, 0),
                    ZIndex = 4,
                    Parent = GSlider
                })
                
                local BSlider = CreateElement("Frame", {
                    Name = "BlueSlider",
                    BackgroundColor3 = Color3.fromRGB(0, 0, 200),
                    Position = UDim2.new(0, 10, 0, 70),
                    Size = UDim2.new(1, -20, 0, 20),
                    ZIndex = 3,
                    Parent = ColorPickerPanel
                })
                
                local BSliderCorner = CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = BSlider
                })
                
                local BIndicator = CreateElement("Frame", {
                    Name = "Indicator",
                    BackgroundColor3 = Library.Theme.TextColor,
                    Position = UDim2.new(default.B, 0, 0.5, 0),
                    Size = UDim2.new(0, 5, 1, 0),
                    ZIndex = 4,
                    Parent = BSlider
                })
                
                -- RGB Value Display
                local RGBDisplay = CreateElement("TextLabel", {
                    Name = "RGBDisplay",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 100),
                    Size = UDim2.new(1, -20, 0, 20),
                    Font = Library.Fonts.Regular,
                    Text = "RGB: " .. math.floor(default.R * 255) .. ", " .. math.floor(default.G * 255) .. ", " .. math.floor(default.B * 255),
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    ZIndex = 3,
                    Parent = ColorPickerPanel
                })
                
                -- Apply button
                local ApplyButton = CreateElement("TextButton", {
                    Name = "Apply",
                    BackgroundColor3 = Library.Theme.Primary,
                    Position = UDim2.new(0, 10, 0, 120),
                    Size = UDim2.new(1, -20, 0, 20),
                    Font = Library.Fonts.Regular,
                    Text = "Apply",
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    ZIndex = 3,
                    Parent = ColorPickerPanel
                })
                
                local ApplyButtonCorner = CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = ApplyButton
                })
                
                -- Function to update color
                local function UpdateColor()
                    local r = RIndicator.Position.X.Scale
                    local g = GIndicator.Position.X.Scale
                    local b = BIndicator.Position.X.Scale
                    
                    local color = Color3.fromRGB(r * 255, g * 255, b * 255)
                    ColorDisplay.BackgroundColor3 = color
                    ColorPicker.Value = color
                    
                    RGBDisplay.Text = "RGB: " .. math.floor(r * 255) .. ", " .. math.floor(g * 255) .. ", " .. math.floor(b * 255)
                    
                    return color
                end
                
                -- Slider functionality
                local function SetupSlider(slider, indicator)
                    local dragging = false
                    
                    slider.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                            
                            -- Update indicator position right away
                            local relativePosition = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                            indicator.Position = UDim2.new(relativePosition, 0, 0.5, 0)
                            
                            UpdateColor()
                        end
                    end)
                    
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                        end
                    end)
                    
                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            local relativePosition = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                            indicator.Position = UDim2.new(relativePosition, 0, 0.5, 0)
                            
                            UpdateColor()
                        end
                    end)
                end
                
                SetupSlider(RSlider, RIndicator)
                SetupSlider(GSlider, GIndicator)
                SetupSlider(BSlider, BIndicator)
                
                -- Apply button functionality
                ApplyButton.MouseButton1Click:Connect(function()
                    ColorPicker.Opened = false
                    CreateTween(ColorPickerFrame, {Size = UDim2.new(1, 0, 0, 35)}):Play()
                    task.delay(0.2, function()
                        ColorPickerPanel.Visible = false
                    end)
                    
                    if Library.Settings.SoundEffects then
                        local sound = Instance.new("Sound")
                        sound.SoundId = "rbxassetid://6031090203"
                        sound.Volume = 0.2
                        sound.Parent = ColorPickerFrame
                        sound:Play()
                        game:GetService("Debris"):AddItem(sound, 1)
                    end
                    
                    task.spawn(function()
                        callback(ColorPicker.Value)
                    end)
                end)
                
                -- Toggle color picker
                ColorPickerButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        ColorPicker.Opened = not ColorPicker.Opened
                        
                        if Library.Settings.SoundEffects then
                            local sound = Instance.new("Sound")
                            sound.SoundId = "rbxassetid://6031091003"
                            sound.Volume = 0.2
                            sound.Parent = ColorPickerFrame
                            sound:Play()
                            game:GetService("Debris"):AddItem(sound, 1)
                        end
                        
                        if ColorPicker.Opened then
                            ColorPickerPanel.Visible = true
                            CreateTween(ColorPickerFrame, {Size = UDim2.new(1, 0, 0, 35 + ColorPickerPanel.Size.Y.Offset + 5)}):Play()
                        else
                            CreateTween(ColorPickerFrame, {Size = UDim2.new(1, 0, 0, 35)}):Play()
                            task.delay(0.2, function()
                                ColorPickerPanel.Visible = false
                            end)
                        end
                    end
                end)
                
                function ColorPicker:Set(color)
                    ColorPicker.Value = color
                    ColorDisplay.BackgroundColor3 = color
                    
                    RIndicator.Position = UDim2.new(color.R, 0, 0.5, 0)
                    GIndicator.Position = UDim2.new(color.G, 0, 0.5, 0)
                    BIndicator.Position = UDim2.new(color.B, 0, 0.5, 0)
                    
                    RGBDisplay.Text = "RGB: " .. math.floor(color.R * 255) .. ", " .. math.floor(color.G * 255) .. ", " .. math.floor(color.B * 255)
                    
                    task.spawn(function()
                        callback(color)
                    end)
                end
                
                return ColorPicker
            end
            
            -- Label Element
            function Section:CreateLabel(text)
                local Label = {
                    Text = text
                }
                
                local LabelFrame = CreateElement("Frame", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25),
                    Parent = SectionContent
                })
                
                local LabelText = CreateElement("TextLabel", {
                    Name = "Text",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -20, 1, 0),
                    Font = Library.Fonts.Regular,
                    Text = text,
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = LabelFrame
                })
                
                function Label:Set(newText)
                    Label.Text = newText
                    LabelText.Text = newText
                end
                
                return Label
            end
            
            -- Keybind Element
            function Section:CreateKeybind(text, default, callback)
                default = default or Enum.KeyCode.Unknown
                callback = callback or function() end
                
                local Keybind = {
                    Value = default,
                    Text = text,
                    Editing = false
                }
                
                local KeybindFrame = CreateElement("Frame", {
                    Name = text .. "Keybind",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 35),
                    Parent = SectionContent
                })
                
                local KeybindLabel = CreateElement("TextLabel", {
                    Name = "Label",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -120, 1, 0),
                    Font = Library.Fonts.Regular,
                    Text = text,
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = KeybindFrame
                })
                
                local KeybindButton = CreateElement("Frame", {
                    Name = "Button",
                    BackgroundColor3 = Library.Theme.Secondary,
                    Position = UDim2.new(1, -110, 0.5, -15),
                    Size = UDim2.new(0, 100, 0, 30),
                    Parent = KeybindFrame
                })
                
                local KeybindButtonCorner = CreateElement("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = KeybindButton
                })
                
                local KeybindText = CreateElement("TextLabel", {
                    Name = "Text",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Font = Library.Fonts.Regular,
                    Text = default.Name,
                    TextColor3 = Library.Theme.TextColor,
                    TextSize = 14,
                    Parent = KeybindButton
                })
                
                -- Keybind functionality
                KeybindButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if Keybind.Editing then return end
                        
                        Keybind.Editing = true
                        KeybindText.Text = "..."
                        
                        if Library.Settings.SoundEffects then
                            local sound = Instance.new("Sound")
                            sound.SoundId = "rbxassetid://6031090203"
                            sound.Volume = 0.2
                            sound.Parent = KeybindFrame
                            sound:Play()
                            game:GetService("Debris"):AddItem(sound, 1)
                        end
                    end
                end)
                
                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        if Keybind.Editing then
                            -- Set new keybind
                            Keybind.Value = input.KeyCode
                            Keybind.Editing = false
                            KeybindText.Text = input.KeyCode.Name
                            
                            if Library.Settings.SoundEffects then
                                local sound = Instance.new("Sound")
                                sound.SoundId = "rbxassetid://6031090203"
                                sound.Volume = 0.2
                                sound.Parent = KeybindFrame
                                sound:Play()
                                game:GetService("Debris"):AddItem(sound, 1)
                            end
                        elseif input.KeyCode == Keybind.Value then
                            -- Trigger callback when key is pressed
                            task.spawn(function()
                                callback(Keybind.Value)
                            end)
                        end
                    end
                end)
                
                function Keybind:Set(key)
                    Keybind.Value = key
                    KeybindText.Text = key.Name
                end
                
                return Keybind
            end
            
            -- Add the section to the tab's sections table
            Tab.Sections[name] = Section
            
            return Section
        end
        
        -- Add to window tabs
        Window.Tabs[name] = Tab
        Window.TabCount = Window.TabCount + 1
        Tab.TabButton = TabButton
        Tab.TabContent = TabContent
        
        -- Set as current tab if this is the first tab
        if Window.TabCount == 1 then
            Tab.Visible = true
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Library.Theme.Primary
            Window.CurrentTab = Tab
        end
        
        return Tab
    end
    
    -- Add Window to Library's window list
    table.insert(Library.Windows, Window)
    return Window
end

-- Library Functions
function Library:SetTheme(theme)
    for key, value in pairs(theme) do
        if Library.Theme[key] then
            Library.Theme[key] = value
        end
    end
    
    -- Update existing UI elements
    for _, window in pairs(Library.Windows) do
        -- Update window theme
        -- (You would need to add code to update all UI elements)
    end
end

function Library:SetSettings(settings)
    for key, value in pairs(settings) do
        if Library.Settings[key] ~= nil then
            Library.Settings[key] = value
        end
    end
end

-- Initialize library
if not isfolder("SynthwaveUI") then
    makefolder("SynthwaveUI")
    makefolder("SynthwaveUI/configs")
end

-- Make Library accessible globally
_G.Library = Library

return Library
