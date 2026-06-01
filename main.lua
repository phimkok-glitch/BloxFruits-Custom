task.wait(2)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")

local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
local Window = Library:CreateWindow({
    Title = "BF v1.1",
    Center = true,
    AutoShow = true,
    Size = UDim2.new(0, 320, 0, 400), -- под телефон
})

local Tabs = {
    Farm     = Window:AddTab("Фарм"),
    Combat   = Window:AddTab("Combat"),
    Visuals  = Window:AddTab("ESP"),
    Settings = Window:AddTab("Настр")
}

local Settings = {
    AutoFarm   = false,
    AutoQuest  = false,
    AutoParry  = false,
    ESPPlayers = false,
}

local AutoFarmToggle  = Tabs.Farm:AddToggle("AutoFarmToggle",   {Title = "Автофарм",   Default = false, Callback = function(v) Settings.AutoFarm   = v end})
local AutoQuestToggle = Tabs.Farm:AddToggle("AutoQuestToggle",  {Title = "Auto Quest", Default = false, Callback = function(v) Settings.AutoQuest  = v end})
local AutoParryToggle = Tabs.Combat:AddToggle("AutoParryToggle",{Title = "Auto Parry", Default = false, Callback = function(v) Settings.AutoParry  = v end})
local ESPToggle       = Tabs.Visuals:AddToggle("ESPPlayersToggle",{Title = "ESP",      Default = false, Callback = function(v) Settings.ESPPlayers = v end})

print("✅ BF v1.1 загружен!")

local ESPTable = {}

local QuestList = {
    {Level = 0,    QuestName = "BanditQuest1",            QuestID = 1},
    {Level = 10,   QuestName = "JungleQuest",             QuestID = 1},
    {Level = 15,   QuestName = "BuggyQuest1",             QuestID = 1},
    {Level = 30,   QuestName = "PirateVillageQuest",      QuestID = 1},
    {Level = 40,   QuestName = "DesertQuest",             QuestID = 1},
    {Level = 60,   QuestName = "SnowQuest",               QuestID = 1},
    {Level = 75,   QuestName = "MarineQuest2",            QuestID = 1},
    {Level = 90,   QuestName = "SkylandsQuest",           QuestID = 1},
    {Level = 100,  QuestName = "FishmanQuest",            QuestID = 1},
    {Level = 120,  QuestName = "GodQuest",                QuestID = 1},
    {Level = 700,  QuestName = "Area1Quest",              QuestID = 1},
    {Level = 725,  QuestName = "Area2Quest",              QuestID = 1},
    {Level = 775,  QuestName = "ZombieQuest",             QuestID = 1},
    {Level = 875,  QuestName = "SnowMountainQuest",       QuestID = 1},
    {Level = 925,  QuestName = "IceSideQuest",            QuestID = 1},
    {Level = 1000, QuestName = "ColdIslandQuest",         QuestID = 1},
    {Level = 1100, QuestName = "MagmaQuest",              QuestID = 1},
    {Level = 1175, QuestName = "FountainQuest",           QuestID = 1},
    {Level = 1250, QuestName = "ShipQuest1",              QuestID = 1},
    {Level = 1350, QuestName = "ShipQuest2",              QuestID = 1},
    {Level = 1425, QuestName = "ForgottenQuest",          QuestID = 1},
    {Level = 1500, QuestName = "PirateMillionaireQuest",  QuestID = 1},
    {Level = 1575, QuestName = "DragonCrewWarriorQuest",  QuestID = 1},
    {Level = 1700, QuestName = "MarineCommodoreQuest",    QuestID = 1},
    {Level = 1775, QuestName = "FishmanRaiderQuest",      QuestID = 1},
    {Level = 1975, QuestName = "HauntedQuest",            QuestID = 1},
    {Level = 2075, QuestName = "SeaOfTreatsQuest",        QuestID = 1},
    {Level = 2450, QuestName = "TikiOutpostQuest",        QuestID = 1},
    {Level = 2600, QuestName = "SubmergedIslandQuest",    QuestID = 1},
}

task.spawn(function()
    while task.wait(2) do
        if not Settings.AutoQuest then continue end
        pcall(function()
            local level = 0
            pcall(function() level = LocalPlayer.Data.Level.Value end)
            local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
            if mainGui and mainGui:FindFirstChild("Quest") and not mainGui.Quest.Visible then
                local bestQuest = nil
                for _, quest in ipairs(QuestList) do
                    if level >= quest.Level then bestQuest = quest end
                end
                if bestQuest then
                    CommF:InvokeServer("StartQuest", bestQuest.QuestName, bestQuest.QuestID)
                end
            end
        end)
    end
end)

task.spawn(function()
    while true do
        if not Settings.AutoFarm then task.wait(1) continue end
        pcall(function()
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then task.wait(1) return end
            local root = char.HumanoidRootPart
            local target, minDist = nil, math.huge
            local enemyFolders = {}
            if Workspace:FindFirstChild("Enemies") then table.insert(enemyFolders, Workspace.Enemies) end
            for _, folder in pairs(Workspace:GetChildren()) do
                if folder.Name:find("Enemy") or folder.Name:find("Mob") then
                    table.insert(enemyFolders, folder)
                end
            end
            for _, folder in ipairs(enemyFolders) do
                for _, mob in ipairs(folder:GetChildren()) do
                    local hum = mob:FindFirstChild("Humanoid")
                    local hrp = mob:FindFirstChild("HumanoidRootPart")
                    if hum and hum.Health > 0 and hrp then
                        local dist = (hrp.Position - root.Position).Magnitude
                        if dist < minDist and dist < 250 then
                            minDist = dist
                            target = mob
                        end
                    end
                end
            end
            if target and target:FindFirstChild("HumanoidRootPart") then
                root.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 6, 7)
                VirtualInputManager:SendMouseButtonEvent(500, 300, 0, true, game, 1)
                task.wait(0.03)
                VirtualInputManager:SendMouseButtonEvent(500, 300, 0, false, game, 1)
            end
        end)
        task.wait(0.3 + math.random() * 0.3)
    end
end)

task.spawn(function()
    while task.wait(0.07) do
        if not Settings.AutoParry then continue end
        pcall(function()
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local enemiesFolder = Workspace:FindFirstChild("Enemies")
            if not enemiesFolder then return end
            for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                local hrp = enemy:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - char.HumanoidRootPart.Position).Magnitude < 15 then
                    if keypress then
                        keypress(0x46)
                        task.wait(0.028)
                        keyrelease(0x46)
                    end
                    break
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if Settings.ESPPlayers then
            local myChar = LocalPlayer.Character
            if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then continue end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr == LocalPlayer then continue end
                local char = plr.Character
                if char and char:FindFirstChild("Head") and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                    if ESPTable[plr] and not ESPTable[plr].Parent then ESPTable[plr] = nil end
                    if not ESPTable[plr] then
                        local bg = Instance.new("BillboardGui")
                        bg.Adornee = char.Head
                        bg.Size = UDim2.new(0, 200, 0, 70)
                        bg.StudsOffset = Vector3.new(0, 4, 0)
                        bg.AlwaysOnTop = true
                        bg.Parent = char.Head
                        local label = Instance.new("TextLabel", bg)
                        label.Size = UDim2.new(1,0,1,0)
                        label.BackgroundTransparency = 1
                        label.TextScaled = true
                        label.Font = Enum.Font.GothamBold
                        label.TextColor3 = Color3.fromRGB(255, 70, 70)
                        ESPTable[plr] = bg
                    end
                    local dist = math.floor((char.HumanoidRootPart.Position - myChar.HumanoidRootPart.Position).Magnitude)
                    ESPTable[plr].TextLabel.Text = string.format("%s\nHP: %d/%d\nDist: %dm", plr.Name, math.floor(char.Humanoid.Health), math.floor(char.Humanoid.MaxHealth), dist)
                end
            end
        else
            for _, gui in pairs(ESPTable) do if gui and gui.Parent then gui:Destroy() end end
            ESPTable = {}
        end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if ESPTable[plr] then ESPTable[plr]:Destroy() ESPTable[plr] = nil end
end)
