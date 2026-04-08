-- [[ WORM-SEGAGA 4.3 : THE UNSTOPPABLE MASTERPIECE ]] --
-- [[ CREATED FOR MASTER: ไอลิง (THE SUPREME MONKEY) 🐒 ]] --

-- ล้างระบบเก่าก่อนรันใหม่ (แก้บั๊กเปิดซ้ำไม่ได้)
if _G.WormLoaded then 
    _G.Settings.AutoFarm = false 
    _G.WormLoaded = false 
    print("Re-Loading Script... 😈")
end
_G.WormLoaded = true

-- [[ 📂 CONFIGURATION ]] --
_G.Settings = {
    AutoFarm = true,
    AutoStats = true,
    FastAttack = true,
    MobMagnet = true,
    AutoEquip = true,
    AutoStoreFruit = true,
    AutoRaid = false,
    TweenSpeed = 350, -- ปรับให้เสถียรขึ้นกันหลุด
    WeaponToUse = "Melee", -- "Melee" / "Sword"
    StatPriority = {"Melee", "Defense", "Sword"}
}

-- [[ 📂 DATABASE: 1-2800 (พิกัดนรก) ]] --
local WorldData = {
    ["Sea1"] = {
        {Level = 0, Quest = "BanditQuest1", Monster = "Bandit", Pos = CFrame.new(1059, 16, 1547)},
        {Level = 15, Quest = "MonkeyQuest1", Monster = "Monkey", Pos = CFrame.new(-1598, 37, 153)},
        {Level = 30, Quest = "MonkeyQuest1", Monster = "Gorilla", Pos = CFrame.new(-1205, 11, -512)},
        {Level = 120, Quest = "SnowQuest", Monster = "Snow Bandit", Pos = CFrame.new(1387, 87, -1298)},
        {Level = 700, Quest = "FountainQuest", Monster = "Galley Captain", Pos = CFrame.new(5649, 39, 4936)}
    },
    ["Sea2"] = {
        {Level = 700, Quest = "Area1Quest", Monster = "Raider", Pos = CFrame.new(-424, 73, 1836)},
        {Level = 1000, Quest = "ZombieQuest", Monster = "Zombie", Pos = CFrame.new(-5422, 13, 1500)},
        {Level = 1425, Quest = "ForgottenQuest", Monster = "Water Artisan", Pos = CFrame.new(-3400, 236, -10300)}
    },
    ["Sea3"] = {
        {Level = 1500, Quest = "PortTownQuest", Monster = "Pirate Millionaire", Pos = CFrame.new(-290, 7, 5328)},
        {Level = 2500, Quest = "TikiQuest", Monster = "Sun-kissed Warrior", Pos = CFrame.new(-16200, 10, 500)}
    }
}

-- [[ 🛠️ DARK ENGINE: FUNCTIONS ]] --
local function DarkTween(Pos)
    local Character = game.Players.LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    pcall(function()
        local Dist = (Pos.p - Character.HumanoidRootPart.Position).Magnitude
        game:GetService("TweenService"):Create(Character.HumanoidRootPart, TweenInfo.new(Dist/_G.Settings.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = Pos}):Play()
    end)
end

local function GetCurrentSea()
    local ID = game.PlaceId
    if ID == 2753915549 then return "Sea1" elseif ID == 4442272183 then return "Sea2" else return "Sea3" end
end

local function UltimateAttack(Target)
    if _G.Settings.FastAttack then
        local Net = game:GetService("ReplicatedStorage").Modules.Net
        Net["RE/RegisterAttack"]:FireServer(0)
        Net["RE/RegisterHit"]:FireServer(Target, {})
    end
end

-- [[ 📈 AUTO STATS: แก้บั๊กไม่ทำงาน ]] --
task.spawn(function()
    while _G.WormLoaded do
        task.wait(0.5)
        if _G.Settings.AutoStats then
            pcall(function()
                local Points = game.Players.LocalPlayer.Data.StatsPoints.Value
                if Points > 0 then
                    for _, StatName in ipairs(_G.Settings.StatPriority) do
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", StatName, Points)
                    end
                end
            end)
        end
    end
end)

-- [[ 🎒 AUTO FRUIT: เก็บและยัดใส่คลัง ]] --
task.spawn(function()
    while _G.WormLoaded do
        task.wait(2)
        pcall(function()
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Tool") and v:FindFirstChild("Handle") then
                    _G.PauseFarm = true
                    DarkTween(v.Handle.CFrame)
                    task.wait(0.5)
                    local FruitName = v:GetAttribute("FruitName") or v.Name
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StoreFruit", FruitName, v)
                    _G.PauseFarm = false
                end
            end
        end)
    end
end)

-- [[ 🐒 MAIN FARM: แก้บั๊กฟาร์มไม่วิ่ง ]] --
task.spawn(function()
    while _G.WormLoaded do
        task.wait(0.1)
        if _G.Settings.AutoFarm and not _G.PauseFarm then
            pcall(function()
                local MyLvl = game.Players.LocalPlayer.Data.Level.Value
                local Sea = GetCurrentSea()
                local Best;
                
                -- หาเควสที่เหมาะกับเวลที่สุด
                for _, v in ipairs(WorldData[Sea]) do
                    if MyLvl >= v.Level then Best = v end
                end

                if Best then
                    local QuestGui = game.Players.LocalPlayer.PlayerGui.Main.Quest
                    if not QuestGui.Visible then
                        -- บินไปรับเควส
                        DarkTween(Best.Pos)
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", Best.Quest, 1)
                    else
                        -- ถืออาวุธ
                        if _G.Settings.AutoEquip then
                            local p = game.Players.LocalPlayer
                            local tool = p.Backpack:FindFirstChild(_G.Settings.WeaponToUse) or p.Character:FindFirstChild(_G.Settings.WeaponToUse)
                            if tool then p.Character.Humanoid:EquipTool(tool) end
                        end
                        
                        -- ตีมอน
                        local FoundMonster = false
                        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                            if enemy.Name == Best.Monster and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                FoundMonster = true
                                repeat
                                    task.wait()
                                    if _G.Settings.MobMagnet then
                                        enemy.HumanoidRootPart.CanCollide = false
                                        enemy.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                                    end
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                                    UltimateAttack(enemy.HumanoidRootPart)
                                until enemy.Humanoid.Health <= 0 or not QuestGui.Visible or not _G.Settings.AutoFarm
                            end
                        end
                        
                        -- ถ้ามอนยังไม่เกิด ให้บินรอจุดรับเควส (กันค้าง)
                        if not FoundMonster then
                            DarkTween(Best.Pos * CFrame.new(0, 25, 0))
                        end
                    end
                end
            end)
        end
    end
end)

-- Anti-AFK
for _, v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do v:Disable() end

print("😈 WORM-SEGAGA 4.3 FIXED! MASTER ไอลิง! พร้อมถล่มเซิร์ฟแล้วครับ! 🐒🥊🔥")
