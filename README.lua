local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- [[ สร้าง UI หน้าต่างโง่ๆ ของมึง ]]
local sg = Instance.new("ScreenGui", player.PlayerGui)
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 250, 0, 100)
frame.Position = UDim2.new(0.5, -125, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, 0, 1, 0)
status.TextColor3 = Color3.fromRGB(255, 255, 0)
status.Text = "เริ่มทำงาน..."
status.TextSize = 18

-- [[ โค้ดบินต้นฉบับมึง ]]
function FlyTo(TargetCFrame)
    local ch = player.Character
    local hp = ch and ch:FindFirstChild("HumanoidRootPart")
    if not hp then return end
    local Distance = (hp.Position - TargetCFrame.Position).Magnitude
    local Speed = 300
    local info = TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hp, info, {CFrame = TargetCFrame})
    tween:Play()
    return tween
end

-- [[ โค้ดถืออาวุธต้นฉบับมึง ]]
local function EQ()
    local tool = player.Backpack:FindFirstChild("Combat")
    if tool then
        player.Character.Humanoid:EquipTool(tool)
    end
end

-- [[ ลูปหลัก ]]
task.spawn(function()
    while true do
        task.wait(0.5)
        
        -- ถ้าตัวละครตาย ให้ข้ามไปก่อน
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            continue
        end

        local hp = player.Character.HumanoidRootPart
        local lv = player.Data.Level.Value
        local nm, Qu, TP, mu

        -- [[ ฟังก์ชันเช็กเลเวลแบบดิบๆ ]]
        if lv <= 14 then
            nm = "Bandit"
            Qu = "BanditQuest1"
            TP = CFrame.new(1059, 16, 1551)
            mu = 1
        elseif lv <= 59 then
            nm = "Monkey"
            Qu = "JungleQuest"
            TP = CFrame.new(-1598, 35, 153)
            mu = 1
        else
            nm = "Snow Bandit"
            Qu = "SnowQuest1"
            TP = CFrame.new(1385, 15, -1322)
            mu = 1
        end

        [span_2](start_span)EQ() -- ถืออาวุธ[span_2](end_span)
        
        -- อัปสเตตัส
        pcall(function()
            if player.Data.StatsPoints.Value > 0 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Melee", 1)
            end
        end)

        -- เช็กว่ามีเควสมั้ย
        if player.PlayerGui.Main:FindFirstChild("Quest") and not player.PlayerGui.Main.Quest.Visible then
            status.Text = "กำลังไปรับเควส: " .. Qu
            local tw = FlyTo(TP)
            if tw then tw.Completed:Wait() end
            task.wait(1)
            
            -- รับเควสด้วยโค้ดเดิมของมึงเป๊ะๆ
            local args = {"StartQuest", Qu, mu}
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
        else
            status.Text = "กำลังกระทืบ: " .. nm
            for _,v in pairs(workspace.Enemies:GetChildren()) do
                local roo = v:FindFirstChild("HumanoidRootPart")
                local hm = v:FindFirstChildOfClass("Humanoid")
                
                if roo and hm and hm.Health > 0 and v.Name == nm then
                    repeat
                        task.wait()
                        -- โจมตี
                        game:GetService("ReplicatedStorage").Remotes.Validator:FireServer("RegisterAttack", 0)
                        -- วาร์ปไปบนหัว (โค้ดเดิมมึง)
                        if player.Character:FindFirstChild("HumanoidRootPart") then
                            [span_3](start_span)player.Character.HumanoidRootPart.CFrame = roo.CFrame * CFrame.new(0, 7, 0)[span_3](end_span)
                        end
                    until hm.Health <= 0 or not player.PlayerGui.Main.Quest.Visible
                end
            end
        end
    end
end)
