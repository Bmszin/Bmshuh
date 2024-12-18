if getgenv().BMS_HUB_LOADED then
    return print("[BMS HUB] Script já executado!")
end

getgenv().BMS_HUB_LOADED = true

-- Módulo principal do script
local BMS = {}
BMS.Config = {
    HubName = "BMS HUB",
    Version = "1.0.0",
}

-- Função para criar interface gráfica
function BMS:CreateUI()
    local ScreenGui = Instance.new("ScreenGui")
    local MainFrame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local StartButton = Instance.new("TextButton")

    -- Configurações básicas
    ScreenGui.Name = "BMS_HUB_UI"
    ScreenGui.Parent = game.CoreGui

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 400, 0, 200)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.Active = true -- Torna o frame interativo
    MainFrame.Draggable = true -- Permite arrastar o frame

    Title.Name = "Title"
    Title.Parent = MainFrame
    Title.Size = UDim2.new(1, 0, 0.3, 0)
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.Text = "BMS HUB"
    Title.TextSize = 24
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1

    StartButton.Name = "StartButton"
    StartButton.Parent = MainFrame
    StartButton.Size = UDim2.new(0.6, 0, 0.2, 0)
    StartButton.Position = UDim2.new(0.2, 0, 0.5, 0)
    StartButton.Text = "Iniciar Auto Farm"
    StartButton.BackgroundColor3 = Color3.fromRGB(20, 120, 20)
    StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)

    StartButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        BMS:AutoFarm()
    end)

    -- Tornar movível no mobile
    self:EnableMobileDragging(MainFrame)
end

-- Sistema para arrastar em mobile
function BMS:EnableMobileDragging(frame)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)
end

-- Função de Auto Farm
function BMS:AutoFarm()
    local Player = game.Players.LocalPlayer
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    print("[BMS HUB] Auto Farm iniciado!")

    -- Configurações iniciais
    local FarmConfig = {
        TargetMob = "Bandit [Lv. 5]", -- Nome do inimigo a ser farmado
        QuestName = "BanditQuest1",   -- Nome da quest
        QuestLevel = 1               -- Nível da quest
    }

    -- Função para pegar a quest
    local function GetQuest()
        print("[BMS HUB] Pegando quest...")
        game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", FarmConfig.QuestName, FarmConfig.QuestLevel)
    end

    -- Função para atacar inimigos
    local function AttackEnemy(enemy)
        print("[BMS HUB] Atacando: " .. enemy.Name)
        repeat
            task.wait()
            HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            pcall(function()
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0))
            end)
        until not enemy or not enemy:FindFirstChild("Humanoid") or enemy.Humanoid.Health <= 0
    end

    -- Loop principal
    while true do
        task.wait(0.1)

        -- Garantir que o jogador tenha a quest ativa
        if not Player.PlayerGui.Main:FindFirstChild("Quest") then
            GetQuest()
        end

        -- Encontrar inimigos
        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
            if enemy.Name == FarmConfig.TargetMob and enemy:FindFirstChild("HumanoidRootPart") then
                AttackEnemy(enemy)
                break
            end
        end
    end
end

-- Inicialização do script
BMS:CreateUI()
