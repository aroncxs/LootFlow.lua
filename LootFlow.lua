local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local TweenService = game:GetService("TweenService")
local isActive = false  -- Controle do estado do autofarm
local farmSpeed = 20  -- Velocidade padrão do Tween
local coinsCollected = 0

-- Função para mover o jogador suavemente até uma posição usando Tween
local function tweenTo(position)
    if humanoidRootPart then
        local distance = (humanoidRootPart.Position - position).Magnitude
        local duration = math.max(distance / farmSpeed, 0.2)  -- Duração mínima de 0.2 segundos

        -- Configurações do Tween
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local goal = {CFrame = CFrame.new(position)}  -- Mover diretamente para a posição da CoinVisual
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)
        tween:Play()

        -- Espera o Tween terminar antes de prosseguir
        tween.Completed:Wait()
    else
        warn("HumanoidRootPart não encontrado.")
    end
end

-- Função principal para coletar moedas
local function collectCoins()
    while isActive do  -- Verifica se o script está ativo
        local nearestCoin = nil
        local shortestDistance = math.huge  -- Distância mínima

        -- Encontra a CoinVisual mais próxima
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "CoinVisual" and obj:IsA("BasePart") and obj.Parent then
                local distance = (humanoidRootPart.Position - obj.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestCoin = obj
                end
            end
        end

        -- Se encontrar uma moeda, faz o Tween até ela
        if nearestCoin then
            tweenTo(nearestCoin.Position)  -- Move suavemente até a CoinVisual
            nearestCoin:Destroy()  -- Remove a moeda assim que o jogador chega a ela
            coinsCollected = coinsCollected + 1 -- Atualiza o contador de moedas

            -- Atualiza o valor das moedas coletadas na GUI
            local coinLabel = player.PlayerGui:FindFirstChild("AutoFarmGUI"):FindFirstChild("CoinLabel")
            if coinLabel then
                coinLabel.Text = "Coins: " .. coinsCollected
            end

            -- Verifica se o Map existe
            if workspace:FindFirstChild("Map") then
                -- Teleporta para um SpawnLocation aleatório
                local spawnLocations = {}
                for _, spawn in pairs(workspace:GetChildren()) do
                    if spawn:IsA("SpawnLocation") then
                        table.insert(spawnLocations, spawn)  -- Adiciona os SpawnLocations a uma lista
                    end
                end

                if #spawnLocations > 0 then
                    local randomSpawn = spawnLocations[math.random(1, #spawnLocations)]
                    humanoidRootPart.CFrame = randomSpawn.CFrame  -- Teleporta para um SpawnLocation aleatório
                end
            end
        else
            wait(0.5)  -- Espera antes de tentar novamente
        end

        wait(0.1)  -- Atraso para evitar loops excessivos
    end
end

-- Função para criar a GUI
local function createGUI()
    local screenGui = Instance.new("ScreenGui", player.PlayerGui)
    screenGui.Name = "AutoFarmGUI"

    local frame = Instance.new("Frame", screenGui)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Cor de fundo
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0.02, 0, 0.02, 0) -- Posição no cantinho
    frame.Size = UDim2.new(0, 250, 0, 150) -- Tamanho do Frame

    -- Label para exibir a quantidade de moedas
    local coinLabel = Instance.new("TextLabel", frame)
    coinLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    coinLabel.BackgroundTransparency = 1
    coinLabel.Position = UDim2.new(0.1, 0, 0.1, 0)
    coinLabel.Size = UDim2.new(0, 180, 0, 50)
    coinLabel.Text = "Coins: " .. coinsCollected
    coinLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    coinLabel.TextScaled = true
    coinLabel.Name = "CoinLabel" -- Nome para referência futura

    -- Label para o status do AutoFarm
    local statusLabel = Instance.new("TextLabel", frame)
    statusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Position = UDim2.new(0.1, 0, 0.3, 0)
    statusLabel.Size = UDim2.new(0, 180, 0, 50)
    statusLabel.Text = "AutoFarm: Disabled"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.TextScaled = true
    statusLabel.Name = "StatusLabel" -- Nome para referência futura

    -- Botão para ativar/desativar o autofarm
    local toggleButton = Instance.new("TextButton", frame)
    toggleButton.Size = UDim2.new(0.8, 0, 0, 50)
    toggleButton.Position = UDim2.new(0.1, 0, 0.5, 0)
    toggleButton.Text = "Toggle AutoFarm"
    toggleButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

    -- Campo para Farm Speed
    local farmSpeedInput = Instance.new("TextBox", frame)
    farmSpeedInput.Size = UDim2.new(0.8, 0, 0, 30)
    farmSpeedInput.Position = UDim2.new(0.1, 0, 0.7, 0)
    farmSpeedInput.Text = tostring(farmSpeed)
    farmSpeedInput.BackgroundColor3 = Color3.fromRGB(173, 216, 230) -- Azul pastel

    -- Label para exibir a velocidade do Farm
    local farmSpeedLabel = Instance.new("TextLabel", frame)
    farmSpeedLabel.Size = UDim2.new(0.8, 0, 0, 30)
    farmSpeedLabel.Position = UDim2.new(0.1, 0, 0.85, 0)
    farmSpeedLabel.Text = "Farm Speed: " .. farmSpeed
    farmSpeedLabel.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

    toggleButton.MouseButton1Click:Connect(function()
        isActive = not isActive
        statusLabel.Text = "AutoFarm: " .. (isActive and "Enabled" or "Disabled")
        toggleButton.BackgroundColor3 = isActive and Color3.fromRGB(144, 238, 144) or Color3.fromRGB(255, 99, 71)  -- Verde pastel se ativado, vermelho pastel se desativado

        if isActive then
            collectCoins()  -- Inicia a coleta
        end
    end)

    -- Atualiza a velocidade do Farm quando o campo é alterado
    farmSpeedInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local newSpeed = tonumber(farmSpeedInput.Text)
            if newSpeed and newSpeed >= 20 and newSpeed <= 35 then
                farmSpeed = newSpeed
                farmSpeedLabel.Text = "Farm Speed: " .. farmSpeed
            else
                farmSpeedInput.Text = tostring(farmSpeed)  -- Reverte para a velocidade padrão se inválido
            end
        end
    end)
end

-- Cria a GUI
createGUI()

-- Mantém a GUI ativa após a morte do jogador
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
end)
