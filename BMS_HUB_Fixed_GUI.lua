
-- BMS HUB - Corrigido e otimizado
-- Criado por BMSZIN

if getgenv().ScriptExecute then 
    print("Aviso: Script já foi executado anteriormente.")
else
    getgenv().ScriptExecute = true
    print("Script iniciado com sucesso!")
end

repeat task.wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer  

if game.CoreGui:FindFirstChild("BMS HUB") then
    game.CoreGui:FindFirstChild("BMS HUB"):Destroy()
end  

local Notify = function(message)
    print(message)
end

local instance = {obj = {}}
local object = instance.obj

function instance.new(class, properties)
    local inst = Instance.new(class)
    for property, value in next, properties do
        inst[property] = value
    end
    table.insert(instance.obj, inst)
    return inst
end

-- GUI Principal
object.BMSHub = instance.new("ScreenGui", {
    Name = "BMS HUB";
    Parent = game.CoreGui;
})

object.Main = instance.new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5);
    BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    BorderSizePixel = 2;
    Position = UDim2.new(0.5, 0, 0.5, 0);
    Size = UDim2.new(0, 400, 0, 300);
    Name = "Main";
    Parent = object.BMSHub;
})

object.Title = instance.new("TextLabel", {
    BackgroundTransparency = 1;
    Text = "BMS HUB - Carregado";
    Font = Enum.Font.SourceSansBold;
    TextColor3 = Color3.fromRGB(255, 255, 255);
    TextSize = 20;
    Size = UDim2.new(1, 0, 0, 30);
    Position = UDim2.new(0, 0, 0, 10);
    Parent = object.Main;
})

object.Notify = instance.new("TextLabel", {
    BackgroundTransparency = 1;
    Text = "Script iniciado com sucesso!";
    Font = Enum.Font.SourceSans;
    TextColor3 = Color3.fromRGB(150, 255, 150);
    TextSize = 16;
    Size = UDim2.new(1, 0, 0, 30);
    Position = UDim2.new(0, 0, 0, 50);
    Parent = object.Main;
})

Notify("BMS HUB Loaded Successfully!")
print("BMS HUB carregado com sucesso!")
