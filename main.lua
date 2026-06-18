--// phimkok Hub v3.0 - Sell Lemons
-- Created by phimkok

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Light Blue Theme
Rayfield.Theme = {
    Default = Color3.fromRGB(20, 25, 45),
    TextColor = Color3.fromRGB(230, 245, 255),
    MainColor = Color3.fromRGB(35, 75, 155),
    AccentColor = Color3.fromRGB(70, 150, 255),
}

local Window = Rayfield:CreateWindow({
    Name = "phimkok Hub - Sell Lemons",
    LoadingTitle = "phimkok Hub",
    LoadingSubtitle = "v3.0 | Custom Build",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)
local FarmTab = Window:CreateTab("Farm", 4483362458)

local userTycoon = workspace:FindFirstChild("Tycoon2")

local AutoBuy = false
local AutoUpgrade = false
local AutoFruit = false
local AutoRebirth = false
local AutoEvolve = false

-- Auto Buy without Decoration
local function buyAllNoDecoration()
    local purchases = userTycoon and userTycoon:FindFirstChild("Purchases")
    if not purchases then return end
    for _, obj in ipairs(purchases:GetDescendants()) do
        if obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("decoration") or name:find("decor") or name:find("skin") then 
                continue 
            end
            if obj:GetAttribute("Shown") and not obj:GetAttribute("Purchased") then
                local purchase = obj:FindFirstChild("Purchase")
                if purchase then 
                    pcall(function() purchase:InvokeServer() end) 
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if AutoBuy then pcall(buyAllNoDecoration) end
    end
end)

-- Improved Auto Fruit
task.spawn(function()
    while true do
        task.wait(0.25)
        if AutoFruit then
            for _, tree in ipairs(workspace:GetDescendants()) do
                if tree.Name == "LemonTree" then
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

-- Toggles
MainTab:CreateToggle({
    Name = "Auto Buy (No Decoration)",
    CurrentValue = false,
    Callback = function(v) AutoBuy = v end
})

MainTab:CreateToggle({
    Name = "Auto Upgrade",
    CurrentValue = false,
    Callback = function(v) AutoUpgrade = v end
})

FarmTab:CreateToggle({
    Name = "Auto Fruit",
    CurrentValue = false,
    Callback = function(v) AutoFruit = v end
})

MainTab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Callback = function(v) AutoRebirth = v end
})

MainTab:CreateToggle({
    Name = "Auto Evolve",
    CurrentValue = false,
    Callback = function(v) AutoEvolve = v end
})

Rayfield:Notify({
    Title = "phimkok Hub Loaded",
    Content = "Welcome! Enjoy the script.",
    Duration = 5
})
