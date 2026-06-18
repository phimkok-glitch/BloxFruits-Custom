--// Lemon Empire Hub v2.1 - Auto Buy без Decoration
-- Custom для Sell Lemons

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🍋 Lemon Empire Hub v2.1",
    LoadingTitle = "Lemon Empire",
    LoadingSubtitle = "phimkok",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("Основное", 4483362458)
local FarmTab = Window:CreateTab("Фарм", 4483362458)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Найти твой Tycoon
local userTycoon = workspace:FindFirstChild("Tycoon2")

local AutoBuy = false
local AutoUpgrade = false
local AutoFruit = false
local AutoRebirth = false
local AutoEvolve = false

-- Auto Buy без Decoration
local function buyAllNoDecoration()
    local purchases = userTycoon and userTycoon:FindFirstChild("Purchases")
    if not purchases then return end

    for _, obj in ipairs(purchases:GetDescendants()) do
        if obj:IsA("Model") then
            local name = obj.Name:lower()
            
            -- Пропускаем декорации
            if name:find("decoration") or name:find("decor") or name:find("skin") or name:find("effect") or name:find("theme") then
                continue
            end

            local shown = obj:GetAttribute("Shown")
            local purchased = obj:GetAttribute("Purchased")
            
            if shown == true and purchased ~= true then
                local purchase = obj:FindFirstChild("Purchase")
                if purchase and purchase:IsA("RemoteFunction") then
                    pcall(function() purchase:InvokeServer() end)
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if AutoBuy then
            pcall(buyAllNoDecoration)
        end
    end
end)

-- GUI
MainTab:CreateToggle({
    Name = "🔄 Auto Buy (Всё кроме Decoration)",
    CurrentValue = false,
    Callback = function(v) AutoBuy = v end
})

MainTab:CreateToggle({
    Name = "⬆ Auto Upgrade",
    CurrentValue = false,
    Callback = function(v) AutoUpgrade = v end
})

FarmTab:CreateToggle({
    Name = "🍋 Auto Fruit",
    CurrentValue = false,
    Callback = function(v) AutoFruit = v end
})

MainTab:CreateToggle({
    Name = "♻ Auto Rebirth",
    CurrentValue = false,
    Callback = function(v) AutoRebirth = v end
})

MainTab:CreateToggle({
    Name = "🌟 Auto Evolve",
    CurrentValue = false,
    Callback = function(v) AutoEvolve = v end
})

Rayfield:Notify({
    Title = "✅ Успешно загружено",
    Content = "Lemon Empire Hub v2.1\nAuto Buy без Decoration активирован!",
    Duration = 6
})
