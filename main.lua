--// Lemon Empire Hub v2.3 - Исправленный Auto Fruit + Цвет
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Настройка цвета (светло-синий)
Rayfield.Theme = {
    Default = Color3.fromRGB(30, 30, 50),
    TextColor = Color3.fromRGB(220, 240, 255),
    MainColor = Color3.fromRGB(40, 80, 160),      -- Основной синий
    AccentColor = Color3.fromRGB(80, 160, 255),   -- Светло-синий акцент
}

local Window = Rayfield:CreateWindow({
    Name = "🍋 Lemon Empire Hub v2.3",
    LoadingTitle = "Lemon Empire",
    LoadingSubtitle = "Исправления",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("Основное", 4483362458)
local FarmTab = Window:CreateTab("Фарм", 4483362458)

local userTycoon = workspace:FindFirstChild("Tycoon2")

local AutoBuy = false
local AutoSell = false
local AutoFruit = false

-- Auto Buy без Decoration
local function buyAllNoDecoration()
    local purchases = userTycoon and userTycoon:FindFirstChild("Purchases")
    if not purchases then return end
    for _, obj in ipairs(purchases:GetDescendants()) do
        if obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("decoration") or name:find("decor") or name:find("skin") then continue end
            if obj:GetAttribute("Shown") and not obj:GetAttribute("Purchased") then
                local purchase = obj:FindFirstChild("Purchase")
                if purchase then pcall(function() purchase:InvokeServer() end) end
            end
        end
    end
end

-- Auto Sell
task.spawn(function()
    while true do
        task.wait(0.2)
        if AutoSell then
            pcall(function()
                local sell = userTycoon and userTycoon:FindFirstChild("Sell", true)
                if sell and sell:FindFirstChildOfClass("ClickDetector") then
                    fireclickdetector(sell:FindFirstChildOfClass("ClickDetector"))
                end
            end)
        end
    end
end)

-- Улучшенный Auto Fruit
task.spawn(function()
    while true do
        task.wait(0.3)
        if AutoFruit then
            for _, tree in ipairs(workspace:GetDescendants()) do
                if tree.Name == "LemonTree" or tree.Name:find("Tree") then
                    for _, fruit in ipairs(tree:GetDescendants()) do
                        if fruit.Name == "Fruit" and fruit:FindFirstChild("ClickPart") then
                            local cd = fruit.ClickPart:FindFirstChildOfClass("ClickDetector")
                            if cd then
                                pcall(function() fireclickdetector(cd) end)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- GUI
MainTab:CreateToggle({Name = "🔄 Auto Buy (без Decoration)", CurrentValue = false, Callback = function(v) AutoBuy = v end})
MainTab:CreateToggle({Name = "💰 Auto Sell", CurrentValue = false, Callback = function(v) AutoSell = v end})
FarmTab:CreateToggle({Name = "🍋 Auto Fruit (Сбор лимонов)", CurrentValue = false, Callback = function(v) AutoFruit = v end})

Rayfield:Notify({Title = "✅ v2.3 Загружено", Content = "Цвет изменён + Auto Fruit улучшен", Duration = 6})
