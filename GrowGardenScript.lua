-- Speed Hub X | Grow Garden

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Speed Hub X | Grow Garden", "Ocean")

-- Values
_G.autoFarm = true
_G.autoWater = true
_G.autoHarvest = true
_G.autoCollect = true

-- Main Tab
local MainTab = Window:MakeTab({
    Name = "Main Features",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Plant Helper Section
local PlantSection = MainTab:AddSection({
    Name = "Plant Management"
})

PlantSection:AddToggle({
    Name = "Auto Water Plants",
    Default = false,
    Callback = function(Value)
        _G.autoWater = Value
        while _G.autoWater and wait() do
            for _, plant in pairs(workspace:GetDescendants()) do
                if plant:IsA("Model") and plant.Name:find("Plant") then
                    local waterTool = game.Players.LocalPlayer.Backpack:FindFirstChild("WateringCan")
                    if waterTool then
                        waterTool.Parent = game.Players.LocalPlayer.Character
                        local args = {
                            [1] = plant
                        }   
                        game:GetService("ReplicatedStorage").WaterPlant:FireServer(unpack(args))
                    end
                end
            end
        end
    end
})

PlantSection:AddToggle({
    Name = "Auto Harvest",
    Default = false,
    Callback = function(Value)
        _G.autoHarvest = Value
        while _G.autoHarvest and wait() do
            for _, plant in pairs(workspace:GetDescendants()) do
                if plant:IsA("Model") and plant.Name:find("Grown") then
                    local harvestTool = game.Players.LocalPlayer.Backpack:FindFirstChild("Harvesting Tool")
                    if harvestTool then
                        harvestTool.Parent = game.Players.LocalPlayer.Character
                        local args = {
                            [1] = plant
                        }
                        game:GetService("ReplicatedStorage").HarvestPlant:FireServer(unpack(args))
                    end
                end
            end
        end
    end
})

PlantSection:AddToggle({
    Name = "Auto Plant",
    Default = false,
    Callback = function(Value)
        _G.autoPlant = Value
        while _G.autoPlant and wait() do
            local plot = workspace:FindFirstChild("EmptyPlot")
            if plot then
                local args = {
                    [1] = plot,
                    [2] = "Basic Seed" -- You can change this to other seed types
                }
                game:GetService("ReplicatedStorage").PlantSeed:FireServer(unpack(args))
            end
        end
    end
})

-- Shop Section
local ShopSection = MainTab:AddSection({
    Name = "Shop Features"
})

ShopSection:AddButton({
    Name = "Teleport to Shop",
    Callback = function()
        local shop = workspace:FindFirstChild("Shop")
        if shop then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = shop.CFrame
        end
    end
})

ShopSection:AddButton({
    Name = "Auto Buy Seeds",
    Callback = function()
        local args = {
            [1] = "Basic Seed",
            [2] = 1
        }
        game:GetService("ReplicatedStorage").PurchaseItem:FireServer(unpack(args))
    end
})

-- Player Section
local PlayerTab = Window:MakeTab({
    Name = "Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

PlayerTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 50,
    Default = 16,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end    
})

PlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Power",
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end    
})

-- Misc Tab
local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MiscTab:AddButton({
    Name = "Collect All Drops",
    Callback = function()
        for _, drop in pairs(workspace:GetDescendants()) do
            if drop:IsA("Model") and drop.Name:find("Drop") then
                game:GetService("ReplicatedStorage").CollectDrop:FireServer(drop)
            end
        end
    end
})

-- Main
local Main = Window:NewTab("Main")
local MainSection = Main:NewSection("Main Features")

MainSection:NewToggle("Auto Farm", "Auto farms for you", function(state)
    _G.autoFarm = state
    while _G.autoFarm and wait() do
        -- Auto Plant
        local plot = workspace:FindFirstChild("EmptyPlot")
        if plot then
            local args = {[1] = plot, [2] = "Basic Seed"}
            game:GetService("ReplicatedStorage").PlantSeed:FireServer(unpack(args))
        end
        
        -- Auto Water
        for _, plant in pairs(workspace:GetDescendants()) do
            if plant:IsA("Model") and plant.Name:find("Plant") then
                local args = {[1] = plant}
                game:GetService("ReplicatedStorage").WaterPlant:FireServer(unpack(args))
            end
        end
        
        -- Auto Harvest
        for _, plant in pairs(workspace:GetDescendants()) do
            if plant:IsA("Model") and plant.Name:find("Grown") then
                local args = {[1] = plant}
                game:GetService("ReplicatedStorage").HarvestPlant:FireServer(unpack(args))
            end
        end
        
        -- Auto Collect
        for _, drop in pairs(workspace:GetDescendants()) do
            if drop:IsA("Model") and drop.Name:find("Drop") then
                game:GetService("ReplicatedStorage").CollectDrop:FireServer(drop)
            end
        end
    end
end)

MainSection:NewButton("Teleport to Shop", "Teleports you to the shop", function()
    local shop = workspace:FindFirstChild("Shop")
    if shop then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = shop.CFrame
    end
end)

MainSection:NewButton("Auto Buy Seeds", "Buys basic seeds", function()
    local args = {[1] = "Basic Seed", [2] = 1}
    game:GetService("ReplicatedStorage").PurchaseItem:FireServer(unpack(args))
end)

-- Player
local Player = Window:NewTab("Player")
local PlayerSection = Player:NewSection("Player Settings")

PlayerSection:NewSlider("WalkSpeed", "Changes your walkspeed", 500, 16, function(v)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end)

PlayerSection:NewSlider("JumpPower", "Changes your jumppower", 500, 50, function(v)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
end)

-- Credits
local Credits = Window:NewTab("Credits")
local CreditsSection = Credits:NewSection("Credits")
CreditsSection:NewLabel("Modified by dieall")
CreditsSection:NewLabel("UI Library: Kavo UI")

-- Anti AFK
local VirtualUser = game:GetService('VirtualUser')
game:GetService('Players').LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
