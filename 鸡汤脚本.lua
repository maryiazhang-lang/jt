-- 鸡汤脚本 - 纯白背景 + 脚本中心折叠菜单（五开关），手机优化
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- 创建主 ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "鸡汤脚本"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- ========== 主窗口（纯白背景，初始高度 120） ==========
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 120)          -- 初始收起高度
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -60) -- 居中（高度一半）
mainFrame.BackgroundColor3 = Color3.new(1, 1, 1)    -- 纯白
mainFrame.BackgroundTransparency = 0                -- 不透明
mainFrame.Parent = screenGui
mainFrame.ClipsDescendants = true

-- 圆角（可选）
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- 边框（让白色窗口可见）
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(200, 200, 200)
stroke.Thickness = 1
stroke.Parent = mainFrame

-- ========== 标题（黑色文字） ==========
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🍲 鸡汤脚本"
title.TextColor3 = Color3.new(0, 0, 0)              -- 黑色
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- ========== 缩小按钮（—） ==========
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -40, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.new(0, 0, 0)
minimizeBtn.TextScaled = true
minimizeBtn.Font = Enum.Font.GothamBold
local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeBtn
minimizeBtn.Parent = mainFrame

-- ========== “脚本中心”按钮（灰色背景，黑色文字） ==========
local centerBtn = Instance.new("TextButton")
centerBtn.Size = UDim2.new(0.8, 0, 0, 40)
centerBtn.Position = UDim2.new(0.1, 0, 0.45, 0)     -- 在标题下方
centerBtn.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
centerBtn.Text = "📂 脚本中心"
centerBtn.TextColor3 = Color3.new(0, 0, 0)
centerBtn.TextScaled = true
centerBtn.Font = Enum.Font.GothamSemibold
local centerCorner = Instance.new("UICorner")
centerCorner.CornerRadius = UDim.new(0, 8)
centerCorner.Parent = centerBtn
centerBtn.Parent = mainFrame

-- ========== 列表容器（存放五个功能按钮，初始隐藏） ==========
local listContainer = Instance.new("Frame")
listContainer.Size = UDim2.new(1, 0, 1, -90)        -- 填满标题+中心按钮下方的空间
listContainer.Position = UDim2.new(0, 0, 0, 90)      -- 从 Y=90 开始
listContainer.BackgroundTransparency = 1
listContainer.Visible = false
listContainer.Parent = mainFrame
listContainer.ClipsDescendants = true

-- ========== 五个功能按钮（放在容器内） ==========
local buttons = {}
local buttonData = {
    { text = "🥚 偷一个蛋", color = Color3.fromRGB(50, 180, 230), y = 0.05, script = "https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/Fn-stealanegg.lua" },
    { text = "⚫ 黑白脚本", color = Color3.fromRGB(100, 100, 100), y = 0.23, script = "https://raw.githubusercontent.com/tfcygvunbind/Apple/main/黑白脚本加载器" },
    { text = "🌙 夜脚本", color = Color3.fromRGB(30, 50, 130), y = 0.41, script = "https://raw.githubusercontent.com/ylt410/roblox-Script/refs/heads/main/yejiaoben" },
    { text = "🤖 Rob脚本", color = Color3.fromRGB(200, 80, 30), y = 0.59, script = "https://raw.githubusercontent.com/idrobsc/rob_script/refs/heads/main/rob.v4" },
    { text = "❌ XK脚本", color = Color3.fromRGB(160, 50, 200), y = 0.77, script = "https://raw.githubusercontent.com/SyndromeXph/XK-Script/refs/heads/main/XoneK-Loader.luau" }
}

for i, data in ipairs(buttonData) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 40)              -- 高度 40
    btn.Position = UDim2.new(0.1, 0, data.y, 0)
    btn.BackgroundColor3 = data.color
    btn.Text = data.text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    btn.Parent = listContainer
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

-- ========== 脚本中心展开/收起 ==========
local isExpanded = false
local function toggleList()
    isExpanded = not isExpanded
    if isExpanded then
        mainFrame.Size = UDim2.new(0, 320, 0, 400)
        listContainer.Visible = true
        centerBtn.Text = "📂 脚本中心 ▲"
    else
        mainFrame.Size = UDim2.new(0, 320, 0, 120)
        listContainer.Visible = false
        centerBtn.Text = "📂 脚本中心 ▼"
    end
end

centerBtn.MouseButton1Click:Connect(toggleList)

-- ========== 缩小 / 展开 ==========
local function minimize()
    mainFrame.Visible = false
    miniIcon.Visible = true
end

local function expand()
    mainFrame.Visible = true
    miniIcon.Visible = false
    -- 展开时保持当前折叠状态（不自动展开列表）
end

minimizeBtn.MouseButton1Click:Connect(minimize)

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

-- ========== 小鸡图标拖拽（支持触屏） ==========
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

-- ========== 主窗口拖拽（支持触屏） ==========
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