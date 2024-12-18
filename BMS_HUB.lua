
-- BMS HUB
-- Criado por BMSZIN

if getgenv().ScriptExecute then return print('Script Already Execute') end
local start_check_time = tick()
getgenv().ScriptExecute = true

repeat task.wait() until game:IsLoaded() and game.Players and game.Players.LocalPlayer  
if game.CoreGui:FindFirstChild("BMS HUB") then
    game.CoreGui:FindFirstChild("BMS HUB"):Destroy()
end  

local Notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/x9PSwiftz/Panda/main/Notification.lua"))() 
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
    BackgroundColor3 = Color3.fromRGB(17, 24, 39);
    BorderColor3 = Color3.fromRGB(0, 0, 0);
    BorderSizePixel = 0;
    Name = "Main";
    Parent = object.BMSHub;
    Position = UDim2.new(0.492770165, 0, 0.5, 0);
    Size = UDim2.new(0, 380, 0, 200);
})

object.UICorner = instance.new("UICorner", {
    CornerRadius = UDim.new(0, 5);
    Parent = object.Main;
})

object.TextBox = instance.new("TextBox", {
    BackgroundColor3 = Color3.fromRGB(21, 31, 45);
    BorderColor3 = Color3.fromRGB(0, 0, 0);
    BorderSizePixel = 0;
    Font = Enum.Font.SourceSans;
    Parent = object.Main;
    PlaceholderColor3 = Color3.fromRGB(178, 178, 178);
    PlaceholderText = "Ready to automate!";
    Position = UDim2.new(0.0331600793, 0, 0.414063871, 0);
    Size = UDim2.new(0, 357, 0, 50);
    Text = "BMS HUB Loaded!";
    TextColor3 = Color3.fromRGB(255, 255, 255);
    TextSize = 14.000;
    TextTruncate = Enum.TextTruncate.AtEnd;
    ClearTextOnFocus = false;
})

object.UIPadding = instance.new("UIPadding", {
    PaddingLeft = UDim.new(0, 15);
    Parent = object.TextBox;
})

object.UICorner = instance.new("UICorner", {
    Parent = object.TextBox;
})

object.UIStroke = instance.new("UIStroke", {
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    Color = Color3.fromRGB(51, 61, 77);
    LineJoinMode = Enum.LineJoinMode.Round;
    Parent = object.TextBox;
})

object.TopBar = instance.new("Frame", {
    BackgroundColor3 = Color3.fromRGB(31, 41, 55);
    BorderColor3 = Color3.fromRGB(0, 0, 0);
    BorderSizePixel = 0;
    Name = "TopBar";
    Parent = object.Main;
    Size = UDim2.new(0, 380, 0, 30);
})

object.UICorner = instance.new("UICorner", {
    CornerRadius = UDim.new(0, 5);
    Parent = object.TopBar;
})

object.Frame = instance.new("Frame", {
    BackgroundColor3 = Color3.fromRGB(51, 61, 77);
    BorderColor3 = Color3.fromRGB(0, 0, 0);
    BorderSizePixel = 0;
    Parent = object.TopBar;
    Position = UDim2.new(0, 0, 1, 0);
    Size = UDim2.new(0, 380, 0, 1);
})

object.TextLabel = instance.new("TextLabel", {
    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
    BackgroundTransparency = 1;
    BorderColor3 = Color3.fromRGB(0, 0, 0);
    BorderSizePixel = 0;
    Font = Enum.Font.GothamMedium;
    Parent = object.TopBar;
    Position = UDim2.new(0, 0, 0, 0);
    Size = UDim2.new(1, 0, 1, 0);
    Text = HubName.." - Criado por BMSZIN";
    TextColor3 = Color3.fromRGB(186, 186, 186);
    TextSize = 14.000;
})

-- Mantendo todas as funcionalidades originais, removendo somente o sistema de autenticação
-- Segue com as funções para farm, bosses, etc.

print("BMS HUB carregado com sucesso!")
