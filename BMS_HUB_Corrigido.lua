
-- BMS HUB - Corrigido
-- Criado por BMSZIN

-- Removido bloqueio de execução duplicada
if getgenv().ScriptExecute then 
    print("Aviso: Script já foi executado anteriormente.")
else
    getgenv().ScriptExecute = true
    print("Script iniciado com sucesso!")
end

local start_check_time = tick()

repeat task.wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer  

if game.CoreGui:FindFirstChild("BMS HUB") then
    game.CoreGui:FindFirstChild("BMS HUB"):Destroy()
end  

-- Função alternativa para notificação, caso a URL falhe
local function loadNotify()
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/x9PSwiftz/Panda/main/Notification.lua"))()
    end)
    if success then
        return result
    else
        warn("Falha ao carregar o módulo de notificação. Prosseguindo sem ele.")
        return {Notify = function(...) print(...) end} -- Fallback simples
    end
end

local Notify = loadNotify()
local instance = {obj = {}}
local object = instance.obj

local HubName = "BMS HUB"
function instance.new(class, properties)
    local inst = Instance.new(class)
    for property, value in next, properties do
        inst[property] = value
    end
    table.insert(instance.obj, inst)
    return inst
end

object.BMSHub = instance.new("ScreenGui", {
    Name = "BMS HUB";
    Parent = game.CoreGui;
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
})

object.Main = instance.new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5);
    BackgroundColor3 = Color3.fromRGB(30, 30, 30);
    Position = UDim2.new(0.5, 0, 0.5, 0);
    Size = UDim2.new(0, 400, 0, 300);
    Name = "Main";
    Parent = object.BMSHub;
})

Notify.Notify("BMS HUB Loaded Successfully!")
print("BMS HUB carregado com sucesso!")
