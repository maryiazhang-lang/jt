-- 鸡汤脚本 - 五开关版（偷一个蛋、黑白脚本、夜脚本、Rob脚本、XK脚本），手机优化
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- 创建主 ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "鸡汤脚本"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- ========== 主窗口（高度 400，容纳五个按钮） ==========
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 400)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)  -- 居中调整
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 140, 50)
mainFrame.BackgroundTransparency = 0.25
mainFrame.Parent = screenGui
mainFrame.ClipsDescendants = true

-- 圆角
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- 标题
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🍲 鸡汤脚本"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- ========== 缩小按钮 ==========
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -40, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBold
local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeBtn
minimizeBtn.Parent = mainFrame

-- ========== 小图标（缩小时显示） ==========
local miniIcon = Instance.new("TextButton")
miniIcon.Size = UDim2.new(0, 55, 0, 55)
miniIcon.Position = UDim2.new(0, 10, 1, -70)
miniIcon.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
miniIcon.Text = "🐔"
miniIcon.TextScaled = true
miniIcon.Visible = false
miniIcon.Parent = screenGui
local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(1, 0)
iconCorner.Parent = miniIcon
local iconStroke = Instance.new("UIStroke")
iconStroke.Color = Color3.new(1, 1, 1)
iconStroke.Thickness = 2
iconStroke.Parent = miniIcon

-- ========== 五个功能按钮（颜色各异） ==========
local buttons = {}
local buttonData = {
    { text = "🥚 偷一个蛋", color = Color3.fromRGB(50, 180, 230), y = 0.12, script = "https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/Fn-stealanegg.lua" },
    { text = "⚫ 黑白脚本", color = Color3.fromRGB(100, 100, 100), y = 0.30, script = "https://raw.githubusercontent.com/tfcygvunbind/Apple/main/黑白脚本加载器" },
    { text = "🌙 夜脚本", color = Color3.fromRGB(30, 50, 130), y = 0.48, script = "https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/yejiaoben" },
    { text = "🤖 Rob脚本", color = Color3.fromRGB(200, 80, 30), y = 0.66, script = "https://raw.githubusercontent.com/idrobsc/rob_script/refs/heads/main/rob.v4" },
    { text = "❌ XK脚本", color = Color3.fromRGB(160, 50, 200), y = 0.84, script = "https://raw.githubusercontent.com/SyndromeXph/XK-Script/refs/heads/main/XoneK-Loader.luau" }  -- 紫色
}

for i, data in ipairs(buttonData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 45)
    btn.Position = UDim2.new(0.1, 0, data.y, 0)
    btn.BackgroundColor3 = data.color
    btn.Text = data.text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn
    btn.Parent = mainFrame
    buttons[#buttons + 1] = { btn = btn, script = data.script, name = data.text:gsub("[%p%w]","") }
end

-- ========== 执行函数 ==========
local function executeScript(url, scriptName)
    task.spawn(function()
        local success, err = pcall(function()
            local result = loadstring(game:HttpGet(url))
            if result then result() else warn("脚本加载失败: " .. url) end
        end)
        if not success then
            warn("执行 [" .. scriptName .. "] 出错: " .. tostring(err))
            local hint = Instance.new("Hint")
            hint.Text = "❌ 脚本失败: " .. scriptName
            hint.Parent = game:GetService("Workspace")
            task.wait(3)
            hint:Destroy()
        else
            local hint = Instance.new("Hint")
            hint.Text = "✅ " .. scriptName .. " 已执行"
            hint.Parent = game:GetService("Workspace")
            task.wait(2)
            hint:Destroy()
        end
    end)
end

-- 绑定按钮点击
for _, item in ipairs(buttons) do
    item.btn.MouseButton1Click:Connect(function()
        executeScript(item.script, item.name)
    end)
end

-- ========== 缩小 / 展开 ==========
local function minimize()
    mainFrame.Visible = false
    miniIcon.Visible = true
end

local function expand()
    mainFrame.Visible = true
    miniIcon.Visible = false
end

minimizeBtn.MouseButton1Click:Connect(minimize)

-- ========== 小鸡图标拖拽（优化） ==========
local iconDragging = false
local iconDragStart = nil
local iconStartPos = nil
local isDragged = false

miniIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        iconDragging = true
        iconDragStart = input.Position
        iconStartPos = miniIcon.Position
        isDragged = false
    end
end)

miniIcon.InputChanged:Connect(function(input)
    if iconDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - iconDragStart
        if delta.Magnitude > 3 then
            isDragged = true
        end
        miniIcon.Position = UDim2.new(
            iconStartPos.X.Scale,
            iconStartPos.X.Offset + delta.X,
            iconStartPos.Y.Scale,
            iconStartPos.Y.Offset + delta.Y
        )
    end
end)

miniIcon.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        iconDragging = false
        if not isDragged then
            expand()
        end
    end
end)

-- ========== 主窗口拖拽（优化） ==========
local dragging = false
local dragStartPos = nil
local startFramePos = nil

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStartPos = input.Position
        startFramePos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartPos
        mainFrame.Position = UDim2.new(
            startFramePos.X.Scale,
            startFramePos.X.Offset + delta.X,
            startFramePos.Y.Scale,
            startFramePos.Y.Offset + delta.Y
        )
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)