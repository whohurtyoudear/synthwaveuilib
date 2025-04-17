-- ModernSynthUI Library
-- Created by Claude

local ModernSynthUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")

-- Modern Color Scheme
local THEME = {
    Primary = Color3.fromRGB(32, 33, 36),      -- Dark background
    Secondary = Color3.fromRGB(47, 48, 52),    -- Lighter background
    Accent = Color3.fromRGB(138, 180, 255),    -- Blue accent
    Text = Color3.fromRGB(255, 255, 255),      -- White text
    TextDark = Color3.fromRGB(200, 200, 200),  -- Darker text
    Success = Color3.fromRGB(72, 199, 142),    -- Green
    Warning = Color3.fromRGB(255, 184, 76),    -- Orange
    Error = Color3.fromRGB(255, 75, 75),       -- Red
    Highlight = Color3.fromRGB(58, 59, 64),    -- Hover highlight
}

-- Constants
local TWEEN_SPEED = 0.2
local CORNER_RADIUS = UDim.new(0, 8)
local FONT = Enum.Font.GothamMedium
local FONT_BOLD = Enum.Font.GothamBold

-- Utility Functions
local function CreateElement(class, properties)
    local element = Instance.new(class)
    for property, value in pairs(properties) do
        element[property] = value
    end
    return element
end

local function CreateCorner(parent)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = CORNER_RADIUS
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or THEME.Secondary
    stroke.Thickness = 1
    stroke.Parent = parent
    return stroke
end

-- Notification System
function ModernSynthUI:Notify(title, message, notifType, duration)
    duration = duration or 5
    local NotifGui = CreateElement("ScreenGui", {
        Name = "ModernSynthNotification",
        Parent = game.CoreGui
    })

    local NotifFrame = CreateElement("Frame", {
        Name = "NotifFrame",
        Parent = NotifGui,
        BackgroundColor3 = THEME.Secondary,
        Position = UDim2.new(1, 20, 0.8, 0),
        Size = UDim2.new(0, 300, 0, 80),
        BackgroundTransparency = 0.1
    })
    CreateCorner(NotifFrame)
    
    local NotifColor = CreateElement("Frame", {
        Name = "NotifColor",
        Parent = NotifFrame,
        BackgroundColor3 = THEME[notifType or "Accent"],
        Size = UDim2.new(0, 4, 1, 0),
        Position = UDim2.new(0, 0, 0, 0)
    })
    CreateCorner(NotifColor)

    local NotifContent = CreateElement("Frame", {
        Name = "NotifContent",
        Parent = NotifFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -20, 1, 0)
    })

    local NotifTitle = CreateElement("TextLabel", {
        Name = "NotifTitle",
        Parent = NotifContent,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 10),
        Size = UDim2.new(1, 0, 0, 20),
        Font = FONT_BOLD,
        Text = title,
        TextColor3 = THEME.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local NotifMessage = CreateElement("TextLabel", {
        Name = "NotifMessage",
        Parent = NotifContent,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 35),
        Size = UDim2.new(1, 0, 0, 35),
        Font = FONT,
        Text = message,
        TextColor3 = THEME.TextDark,
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    })

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
function ModernSynthUI:CreateWindow(title)
    local Window = {}
    
    -- Main GUI
    local ScreenGui = CreateElement("ScreenGui", {
        Name = "ModernSynthUI",
        Parent = game.CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local MainFrame = CreateElement("Frame", {
        Name = "MainFrame",
        Parent = ScreenGui,
        BackgroundColor3 = THEME.Primary,
        Position = UDim2.new(0.5, -350, 0.5, -200),
        Size = UDim2.new(0, 700, 0, 400),
        ClipsDescendants = true
    })
    CreateCorner(MainFrame)
    
    local SideBar = CreateElement("Frame", {
        Name = "SideBar",
        Parent = MainFrame,
        BackgroundColor3 = THEME.Secondary,
        Size = UDim2.new(0, 60, 1, 0),
        Position = UDim2.new(0, 0, 0, 0)
    })
    CreateCorner(SideBar)

    local ContentFrame = CreateElement("Frame", {
        Name = "ContentFrame",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 70, 0, 10),
        Size = UDim2.new(1, -80, 1, -20)
    })

    -- Create Homepage
    local HomePage = CreateElement("Frame", {
        Name = "HomePage",
        Parent = ContentFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Visible = true
    })

    -- Player Avatar
    local AvatarFrame = CreateElement("Frame", {
        Name = "AvatarFrame",
        Parent = HomePage,
        BackgroundColor3 = THEME.Secondary,
        Size = UDim2.new(0, 180, 0, 180),
        Position = UDim2.new(0, 10, 0, 10)
    })
    CreateCorner(AvatarFrame)

    local AvatarImage = CreateElement("ImageLabel", {
        Name = "AvatarImage",
        Parent = AvatarFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        Image = Players:GetUserThumbnailAsync(
            LocalPlayer.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size420x420
        )
    })
    CreateCorner(AvatarImage)

    -- Player Info
    local InfoFrame = CreateElement("Frame", {
        Name = "InfoFrame",
        Parent = HomePage,
        BackgroundColor3 = THEME.Secondary,
        Size = UDim2.new(1, -210, 0, 180),
        Position = UDim2.new(0, 200, 0, 10)
    })
    CreateCorner(InfoFrame)

    local PlayerName = CreateElement("TextLabel", {
        Name = "PlayerName",
        Parent = InfoFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 15),
        Size = UDim2.new(1, -30, 0, 25),
        Font = FONT_BOLD,
        Text = "@" .. LocalPlayer.Name,
        TextColor3 = THEME.Text,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local GameName = CreateElement("TextLabel", {
        Name = "GameName",
        Parent = InfoFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 45),
        Size = UDim2.new(1, -30, 0, 20),
        Font = FONT,
        Text = "Loading game info...",
        TextColor3 = THEME.TextDark,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Get game name
    pcall(function()
        local gameInfo = MarketplaceService:GetProductInfo(game.PlaceId)
        GameName.Text = gameInfo.Name
    end)

    -- Navigation Buttons
    local NavButtons = {}
    local CurrentPage = HomePage

    local function CreateNavButton(icon, position)
        local NavButton = CreateElement("ImageButton", {
            Name = "NavButton",
            Parent = SideBar,
            BackgroundColor3 = THEME.Highlight,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, position),
            Size = UDim2.new(0, 40, 0, 40),
            Image = icon
        })
        CreateCorner(NavButton)
        return NavButton
    end

    -- Home Button
    local HomeButton = CreateNavButton("rbxassetid://7733960981", 10)
    HomeButton.BackgroundTransparency = 0

    -- Add more navigation buttons here...

    -- Make window draggable
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function updateDrag(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    MainFrame.InputBegan:Connect(function(input)
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

    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)

    -- Window Methods
    function Window:AddPage(title, icon)
        local Page = CreateElement("ScrollingFrame", {
            Name = title .. "Page",
            Parent = ContentFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = THEME.Accent,
            Visible = false
        })

        local NavButton = CreateNavButton(icon, 60 + #NavButtons * 50)
        table.insert(NavButtons, NavButton)

        NavButton.MouseButton1Click:Connect(function()
            CurrentPage.Visible = false
            Page.Visible = true
            CurrentPage = Page

            for _, btn in ipairs(NavButtons) do
                btn.BackgroundTransparency = 1
            end
            NavButton.BackgroundTransparency = 0
        end)

        return Page
    end

        -- Window Methods (continued)
    function Window:AddButton(parent, text, callback)
        local Button = CreateElement("TextButton", {
            Name = "Button",
            Parent = parent,
            BackgroundColor3 = THEME.Secondary,
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 0, (#parent:GetChildren() - 1) * 50 + 10),
            Font = FONT,
            Text = text,
            TextColor3 = THEME.Text,
            TextSize = 14,
            AutoButtonColor = false
        })
        CreateCorner(Button)
        
        -- Hover Effect
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = THEME.Highlight
            }):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {
                BackgroundColor3 = THEME.Secondary
            }):Play()
        end)
        
        Button.MouseButton1Click:Connect(function()
            callback()
            -- Click effect
            TweenService:Create(Button, TweenInfo.new(0.1), {
                BackgroundColor3 = THEME.Accent
            }):Play()
            wait(0.1)
            TweenService:Create(Button, TweenInfo.new(0.1), {
                BackgroundColor3 = THEME.Secondary
            }):Play()
        end)
        
        return Button
    end
    
    function Window:AddToggle(parent, text, default, callback)
        local ToggleFrame = CreateElement("Frame", {
            Name = "ToggleFrame",
            Parent = parent,
            BackgroundColor3 = THEME.Secondary,
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 0, (#parent:GetChildren() - 1) * 50 + 10)
        })
        CreateCorner(ToggleFrame)
        
        local ToggleLabel = CreateElement("TextLabel", {
            Name = "ToggleLabel",
            Parent = ToggleFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 0),
            Size = UDim2.new(1, -65, 1, 0),
            Font = FONT,
            Text = text,
            TextColor3 = THEME.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local ToggleButton = CreateElement("Frame", {
            Name = "ToggleButton",
            Parent = ToggleFrame,
            BackgroundColor3 = default and THEME.Accent or THEME.Highlight,
            Position = UDim2.new(1, -50, 0.5, -10),
            Size = UDim2.new(0, 35, 0, 20),
            BackgroundTransparency = 0
        })
        CreateCorner(ToggleButton)
        
        local ToggleCircle = CreateElement("Frame", {
            Name = "ToggleCircle",
            Parent = ToggleButton,
            BackgroundColor3 = THEME.Text,
            Position = UDim2.new(default and 1 or 0, default and -18 or 2, 0.5, -8),
            Size = UDim2.new(0, 16, 0, 16),
            BackgroundTransparency = 0
        })
        CreateCorner(ToggleCircle)
        
        local toggled = default
        
        local function updateToggle()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(toggled and 1 or 0, toggled and -18 or 2, 0.5, -8)
            }):Play()
            
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                BackgroundColor3 = toggled and THEME.Accent or THEME.Highlight
            }):Play()
            
            callback(toggled)
        end
        
        ToggleButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                toggled = not toggled
                updateToggle()
            end
        end)
        
        -- Hover Effect
        ToggleFrame.MouseEnter:Connect(function()
            if not toggled then
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = THEME.Secondary
                }):Play()
            end
        end)
        
        ToggleFrame.MouseLeave:Connect(function()
            if not toggled then
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = THEME.Highlight
                }):Play()
            end
        end)
        
        return ToggleFrame
    end
    
    function Window:AddSlider(parent, text, min, max, default, callback)
        local SliderFrame = CreateElement("Frame", {
            Name = "SliderFrame",
            Parent = parent,
            BackgroundColor3 = THEME.Secondary,
            Size = UDim2.new(1, -20, 0, 50),
            Position = UDim2.new(0, 10, 0, (#parent:GetChildren() - 1) * 60 + 10)
        })
        CreateCorner(SliderFrame)
        
        local SliderLabel = CreateElement("TextLabel", {
            Name = "SliderLabel",
            Parent = SliderFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 15, 0, 5),
            Size = UDim2.new(1, -30, 0, 20),
            Font = FONT,
            Text = text,
            TextColor3 = THEME.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local SliderValue = CreateElement("TextLabel", {
            Name = "SliderValue",
            Parent = SliderFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -50, 0, 5),
            Size = UDim2.new(0, 35, 0, 20),
            Font = FONT,
            Text = tostring(default),
            TextColor3 = THEME.TextDark,
            TextSize = 14
        })
        
        local SliderBar = CreateElement("Frame", {
            Name = "SliderBar",
            Parent = SliderFrame,
            BackgroundColor3 = THEME.Highlight,
            Position = UDim2.new(0, 15, 0, 35),
            Size = UDim2.new(1, -30, 0, 4)
        })
        CreateCorner(SliderBar)
        
        local SliderFill = CreateElement("Frame", {
            Name = "SliderFill",
            Parent = SliderBar,
            BackgroundColor3 = THEME.Accent,
            Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        })
        CreateCorner(SliderFill)
        
        local SliderKnob = CreateElement("Frame", {
            Name = "SliderKnob",
            Parent = SliderFill,
            BackgroundColor3 = THEME.Accent,
            Position = UDim2.new(1, -6, 0.5, -6),
            Size = UDim2.new(0, 12, 0, 12),
            ZIndex = 2
        })
        CreateCorner(SliderKnob)
        
        local function updateSlider(input)
            local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * pos)
            
            TweenService:Create(SliderFill, TweenInfo.new(0.1), {
                Size = UDim2.new(pos, 0, 1, 0)
            }):Play()
            
            SliderValue.Text = tostring(value)
            callback(value)
        end
        
        SliderBar.InputBegan:Connect(function(input)
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
    
    function Window:AddDropdown(parent, text, options, callback)
        local DropdownFrame = CreateElement("Frame", {
            Name = "DropdownFrame",
            Parent = parent,
            BackgroundColor3 = THEME.Secondary,
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 0, (#parent:GetChildren() - 1) * 50 + 10),
            ClipsDescendants = true
        })
        CreateCorner(DropdownFrame)
        
        local DropdownButton = CreateElement("TextButton", {
            Name = "DropdownButton",
            Parent = DropdownFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 40),
            Font = FONT,
            Text = text,
            TextColor3 = THEME.Text,
            TextSize = 14
        })
        
        local DropdownIcon = CreateElement("ImageLabel", {
            Name = "DropdownIcon",
            Parent = DropdownButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -35, 0.5, -8),
            Size = UDim2.new(0, 16, 0, 16),
            Image = "rbxassetid://7072706796",
            ImageColor3 = THEME.TextDark
        })
        
        local OptionsList = CreateElement("Frame", {
            Name = "OptionsList",
            Parent = DropdownFrame,
            BackgroundColor3 = THEME.Secondary,
            Position = UDim2.new(0, 0, 0, 40),
            Size = UDim2.new(1, 0, 0, #options * 30),
            Visible = false
        })
        CreateCorner(OptionsList)
        
        local dropped = false
        
        local function toggleDropdown()
            dropped = not dropped
            DropdownFrame:TweenSize(
                dropped and UDim2.new(1, -20, 0, 40 + #options * 30) or UDim2.new(1, -20, 0, 40),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quart,
                0.2,
                true
            )
            TweenService:Create(DropdownIcon, TweenInfo.new(0.2), {
                Rotation = dropped and 180 or 0
            }):Play()
            OptionsList.Visible = dropped
        end
        
        DropdownButton.MouseButton1Click:Connect(toggleDropdown)
        
        for i, option in ipairs(options) do
            local OptionButton = CreateElement("TextButton", {
                Name = "OptionButton",
                Parent = OptionsList,
                BackgroundColor3 = THEME.Secondary,
                Size = UDim2.new(1, 0, 0, 30),
                Position = UDim2.new(0, 0, 0, (i-1) * 30),
                Font = FONT,
                Text = option,
                TextColor3 = THEME.TextDark,
                TextSize = 14,
                AutoButtonColor = false
            })
            
            OptionButton.MouseEnter:Connect(function()
                TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = THEME.Highlight
                }):Play()
            end)
            
            OptionButton.MouseLeave:Connect(function()
                TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = THEME.Secondary
                }):Play()
            end)
            
            OptionButton.MouseButton1Click:Connect(function()
                DropdownButton.Text = text .. ": " .. option
                toggleDropdown()
                callback(option)
            end)
        end
        
        return DropdownFrame
    end

    -- Add Tab system
    function Window:AddTab(text)
        local Tab = {}
        
        local TabPage = CreateElement("ScrollingFrame", {
            Name = "TabPage",
            Parent = ContentFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = THEME.Accent,
            Visible = false
        })
        
        function Tab:AddButton(text, callback)
            return Window:AddButton(TabPage, text, callback)
        end
        
        function Tab:AddToggle(text, default, callback)
            return Window:AddToggle(TabPage, text, default, callback)
        end
        
        function Tab:AddSlider(text, min, max, default, callback)
            return Window:AddSlider(TabPage, text, min, max, default, callback)
        end
        
        function Tab:AddDropdown(text, options, callback)
            return Window:AddDropdown(TabPage, text, options, callback)
        end
        
        return Tab
    end

    return Window
end

return ModernSynthUI
