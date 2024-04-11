loadstring(readfile("skheet/ui.lua"))()




local camera = utility.services.workspace.CurrentCamera;
local mouse = utility.services.players.LocalPlayer:GetMouse();
local localplayer = utility.services.players.LocalPlayer;
local humanoid = localplayer.Character.Humanoid;


local settings = {
    weapon_chams = {
        enabled = false,
        transparency = 1,
        material = "ForceField",
        color = Color3.fromRGB(255, 255, 255)
    }
}


local window = library:window({tabs = 5, size = UDim2.new(0, 550, 0, 500)})
local rage = window:tab({image = images.rage})
local antiaim = window:tab({image = images.antiaim, size = UDim2.new(0, 42, 0, 34)})
local visuals = window:tab({image = images.visuals, size = UDim2.new(0, 47, 0, 47)})
local misc = window:tab({image = images.misc, size = UDim2.new(0, 40, 0, 38)})
local settings = window:tab({image = images.settings})

local Utility = {}
local PlayerDrawings = {}

local Camera = workspace.Camera
local Players = game.Players
local LocalPlayer = Players.LocalPlayer
local RunService = game.RunService

do -- visuals
    local esp = visuals:section({name = "Player ESP", size = UDim2.new(1, 0, 0, 301)}) do
        esp:keybind({name = "Activation Type", flag = "esp key", mode = "Always"})
        esp:toggle({name = "Enabled", flag = "esp enabled"})
        esp:toggle({name = "Bounding Box", flag = "esp box"}):colorpicker({flag = "esp box color", default = Color3.new(1, 1, 1)})
        esp:toggle({name = "Health Bar", flag = "esp health bar"}):colorpicker({flag = "esp health bar color", default = Color3.fromRGB(0, 255, 0)})
        esp:toggle({name = "Health Number", flag = "esp health number"}):colorpicker({flag = "esp health number color", default = Color3.fromRGB(255, 255, 255)})
        esp:toggle({name = "Name", flag = "esp name"}):colorpicker({flag = "esp name color", default = Color3.new(1, 1, 1)})
        esp:toggle({name = "Weapon text", flag = "esp weapon"}):colorpicker({flag = "esp weapon color", default = Color3.new(1, 1, 1)})
        esp:toggle({name = "Distance", flag = "esp distance"}):colorpicker({flag = "esp distance color", default = Color3.new(1, 1, 1)})
        esp:toggle({name = "Visible", flag = "esp vis"}):colorpicker({flag = "esp vis color", default = Color3.new(1, 1, 1)})
        esp:toggle({name = "Skeleton", flag = "esp skeleton"}):colorpicker({flag = "esp skeleton color", default = Color3.new(1, 1, 1)})
        esp:toggle({name = "Out of FOV arrow", flag = "esp fov"}):colorpicker({flag = "esp fov color", default = Color3.new(1, 1, 1)})
        esp:slider({name = "Out of FOV size", flag = "esp fov size", min = 0, max = 30, default = 13})
        esp:slider({name = "Out of FOV position", flag = "esp fov pos", min = 0, max = Camera.ViewportSize.X, default = Camera.ViewportSize.X / 4})
    end

    local settings = visuals:section({name = "ESP Settings", size = UDim2.new(1, 0, 0, 314), side = "right"}) do
        settings:slider({min = 0, max = 90, name = "Max HP visiblity cap", flag = "esp hp"})
        settings:toggle({name = "Teammates", flag = "esp team", state = true})
        settings:dropdown({options = {"UI", "System", "Plex", "Monospace"}, default = "Plex", name = "Font", flag = "esp font"})
        settings:slider({min = 1, max = 50, name = "Font size", flag = "esp size", default = 13})
        settings:dropdown({options = {"Normal", "UPPERCASE", "lowercase"}, default = "Normal", name = "Font case", flag = "esp case"})
        settings:dropdown({options = {"UI", "System", "Plex", "Monospace"}, default = "Plex", name = "Flag font", flag = "esp flag font"})
        settings:slider({min = 1, max = 50, name = "Flag font size", flag = "esp flag size", default = 13})
        settings:dropdown({options = {"Normal", "UPPERCASE", "lowercase"}, default = "Normal", name = "Flag font case", flag = "esp flag case"})
    end
end

do -- misc
    local selfstuff = misc:section({name = "Viewmodel", size = UDim2.new(1, 0, 0, 301)}) do
        selfstuff:toggle({name = "Viewmodel Chams", callback = function(Value) settings.weapon_chams.enabled = Value end}):colorpicker({default = Color3.new(1, 1, 1), callback = function(Value) settings.weapon_chams.color = Value end})
        selfstuff:slider({min = 1, max = 100, name = "Transparency", default = 1, callback = function(Value) settings.weapon_chams.transparency = Value / 100 end})
        selfstuff:dropdown({options = {"ForceField", "Neon", "CrackedLava", "Glass"}, default = "ForceField", name = "Material", callback = function(Value) settings.weapon_chams.material = Value end})




    end
end

do -- settings
    local presets = settings:section({name = "Presets"}) do
        local configs_list = presets:dropdown({name = "", list = true, scrollable = true, size = 120})
        local current_list = {}
        local function update_config_list()
            local list = {}
            for idx, file in ipairs(listfiles(library.folder .. "/configs")) do
                local file_name = file:gsub(library.folder .. "/configs\\", ""):gsub(".cfg", "")
                list[#list + 1] = file_name
            end
        
            local is_new = #list ~= #current_list
            if not is_new then
                for idx, file in ipairs(list) do
                    if file ~= current_list[idx] then
                        is_new = true
                        break
                    end
                end
            end
        
            if is_new then
                current_list = list
                configs_list:refresh(list)
            end
        end

        update_config_list()
        presets:textbox({placeholder = "Preset Name", flag = "cfg_name"})
        presets:button({name = "Load", callback = function()
            if isfile(library.folder .. "/configs/"..library.flags.cfg_name .. ".cfg") then
                library:load_config(library.folder .. "/configs/"..library.flags.cfg_name .. ".cfg")
            end
        end})
        presets:button({name = "Save", callback = function()
            writefile(library.folder .. "/configs/"..library.flags.cfg_name .. ".cfg", window:get_config())

            update_config_list()
        end})
        presets:button({name = "Delete", callback = function()
            if isfile(library.folder .. "/configs/"..library.flags.cfg_name .. ".cfg") then
                delfile(library.folder .. "/configs/"..library.flags.cfg_name .. ".cfg")
            end

            update_config_list()
        end})
        presets:button({name = "Reset", callback = function()
            if isfile(library.folder .. "/configs/"..library.flags.cfg_name .. ".cfg") then
                writefile(library.folder .. "/configs/"..library.flags.cfg_name .. ".cfg", "")
            end

            update_config_list()
        end})
        presets:button({name = "Refresh", callback = function()
            update_config_list()
        end})
    end
end





local armsFolder = v:FindFirstChild("Arms")
local weaponFolder = v:FindFirstChild("Weapon")

if settings.local_chams.enabled and armsFolder then
    for _, arm in ipairs(armsFolder:GetChildren()) do
        if arm:IsA("MeshPart") and (arm.Name == "LeftArm" or arm.Name == "RightArm") then
            arm.Material = settings.local_chams.material
            if settings.local_chams.material == "ForceField" then
                arm.TextureID = "rbxassetid://9305457875"
            else
                arm.TextureID = ""
            end
            arm.Color = settings.local_chams.color
            arm.Transparency = settings.local_chams.transparency
        end
    end
end
if settings.weapon_chams.enabled and weaponFolder then
    for _, weaponPart in ipairs(weaponFolder:GetChildren()) do
        if weaponPart:IsA("MeshPart") then
            if settings.weapon_chams.material == "ForceField" then
                weaponPart.TextureID = "rbxassetid://9305457875"
            else
                weaponPart.TextureID = ""
            end
            if weaponPart.Transparency ~= 1 then
                weaponPart.Material = settings.weapon_chams.material
                weaponPart.Color = settings.weapon_chams.color
                weaponPart.Transparency = settings.weapon_chams.transparency
            end   
        end
    end
end
end
end







do -- functions
    function Utility.BoundingBox(torso)
        local vTop = torso.Position + (torso.CFrame.UpVector * 1.8) + Camera.CFrame.UpVector
        local vBottom = torso.Position - (torso.CFrame.UpVector * 2.5) - Camera.CFrame.UpVector
    
        local top, topIsRendered = Camera:WorldToViewportPoint(vTop)
        local bottom, bottomIsRendered = Camera:WorldToViewportPoint(vBottom)
    
        local _width = math.max(math.floor(math.abs(top.x - bottom.x)), 3)
        local _height = math.max(math.floor(math.max(math.abs(bottom.y - top.y), _width / 2)), 3)
        local boxSize = Vector2.new(math.floor(math.max(_height / 1.5, _width)), _height)
        local boxPosition = Vector2.new(math.floor(top.x * 0.5 + bottom.x * 0.5 - boxSize.x * 0.5), math.floor(math.min(top.y, bottom.y)))
    
        return boxSize, boxPosition
    end

    function Utility.isAlive(player)
        local boolean = false

        if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.Humanoid.Health ~= 0 then 
            boolean = true
        end

        return boolean
    end

    function Utility.validEsp(player)
        local boolean = false

        if Utility.isAlive(player) and player ~= LocalPlayer and (library.flags["esp team"] and player ~= LocalPlayer.Team) and library.flags["esp key"] and library.flags["esp enabled"] then
            boolean = true
        end

        return boolean
    end

    Utility.Cache = {
        Line = {
            Thickness = 1,
            Color = Color3.fromRGB(0, 255, 0),
            Transparency = 1,
        },
        Text = {
            Size = 13,
            Center = true,
            Outline = true,
            Font = 2,
            Color = Color3.fromRGB(255, 255, 255),
            Transparency = 1,
        },
        Square = {
            Thickness = 1,
            Color = Color3.fromRGB(255, 255, 255),
            Filled = false,
            Transparency = 1,
        },
        Circle = {
            Filled = false,
            NumSides = 30,
            Thickness = 0,
            Transparency = 1,
        },
        Triangle = {
            Color = Color3.fromRGB(255, 255, 255),
            Filled = true,
            Visible = false,
            Thickness = 1,
            Transparency = 1,
        },
        Image = {
            Transparency = 1,
            Visible = true,
            Data = game:HttpGet("https://i.imgur.com/2KZqAOV.png"),
        },
    }

    function Utility.New(data)
        local drawing = Drawing.new(data.type)
    
        for i, v in pairs(Utility.Cache[data.type]) do
            drawing[i] = v
        end
    
        if data.type == "Square" then
            if not data.filled then
                drawing.Filled = false
            elseif data.filled then
                drawing.Filled = true
            end
        end
    
        if data.zindex then
            drawing.ZIndex = data.zindex
        end

        drawing.ZIndex = -1
    
        if data.out then
            drawing.Color = Color3.new(0,0,0)
            drawing.Thickness = 3
        end

        table.insert(library.drawings, drawing)

        return drawing
    end

    function Utility.AddToPlayer(player)
        if not PlayerDrawings[player] then
            PlayerDrawings[player] = {
                Name = Utility.New({type = "Text"}),
                BoxOutline = Utility.New({type = "Square", out = true}),
                Box = Utility.New({type = "Square"}),
                Distance = Utility.New({type = "Text"}),
                Visible = Utility.New({type = "Text"}),
                HealthOutline = Utility.New({type = "Square", out = true}),
                Health = Utility.New({type = "Square"}),
                HealthNumber = Utility.New({type = "Text"}),
            }
        end
    end

    function Utility.RemovePlayer(player)
        if PlayerDrawings[player] then
            for _,v in pairs(PlayerDrawings[player]) do
                v:Remove()
                v = nil
            end

            PlayerDrawings[player] = nil
        end
    end

    function Utility.IsVisible(position, ignore)
        return #Camera:GetPartsObscuringTarget({ position }, ignore) == 0;
    end

    function Utility.upperString(str)
        return (str:gsub("^%l", string.upper))
    end

    function Utility.GetCase(text, case)
        if string.lower(case) == "normal" then
            local t_table = string.split(string.lower(text), " ")
            local Name = ""
            for _,v in pairs(t_table) do
                if _ ~= 1 then
                    Name = Name .. " " .. Utility.upperString(v)
                else
                    Name = Name .. Utility.upperString(v)
                end
            end

            return Name
        elseif string.lower(case) == "uppercase" then
            return string.upper(text)
        elseif string.lower(case) == "lowercase" then
            return string.lower(text)
        end
    end
end

for _,v in pairs(Players:GetPlayers()) do
    Utility.AddToPlayer(v)
end

table.insert(library.connections, Players.PlayerAdded:Connect(Utility.AddToPlayer))

table.insert(library.connections, Players.PlayerRemoving:Connect(Utility.RemovePlayer))

utility.connect(RunService.RenderStepped, function()
    for _,v in pairs(game.Players:GetPlayers()) do
        local Drawings = PlayerDrawings[v]

        if Drawings then
            if Utility.validEsp(v) then
                local Character = v.Character
                local HumanoidRootPart = Character.HumanoidRootPart
                local Humanoid = Character.Humanoid

                for _,v in pairs(Drawings) do
                    v.Visible = false
                end

                local Pos, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart.Position)

                if OnScreen and library ~= nil then
                    local BoxSize, BoxPos = Utility.BoundingBox(HumanoidRootPart)
                    local Name = Drawings.Name
                    local Box = Drawings.Box
                    local BoxOutline = Drawings.BoxOutline
                    local Distance = Drawings.Distance
                    local Visible = Drawings.Visible
                    local HealthOutline = Drawings.HealthOutline
                    local Health = Drawings.Health
                    local HealthNumber = Drawings.HealthNumber
                    local bot_y_pos = 0
                    local left_y_pos = 0

                    local function createFlag(side, obj, text, flag)
                        if side:lower() == "bottom" then
                            obj.Visible = true
                            obj.Color = library.flags["esp " .. flag .. " color"]
                            obj.Transparency = library.flags["esp " .. flag .. " color"].a
                            obj.Size = library.flags["esp size"]
                            obj.Font = Drawing.Fonts[library.flags["esp font"]]
                            obj.Center = true
                            obj.Position = Vector2.new(BoxPos.X + (BoxSize.X / 2), BoxPos.Y + BoxSize.Y + 2 + bot_y_pos)
                            obj.Text = Utility.GetCase(text, library.flags["esp case"])

                            bot_y_pos += obj.TextBounds.Y + 2
                        elseif side:lower() == "left" then
                            obj.Visible = true
                            obj.Color = library.flags["esp " .. flag .. " color"]
                            obj.Transparency = library.flags["esp " .. flag .. " color"].a
                            obj.Size = library.flags["esp flag size"]
                            obj.Font = Drawing.Fonts[library.flags["esp flag font"]]
                            obj.Position = Vector2.new(BoxPos.X + BoxSize.X + 3, (BoxPos.Y - 3) + left_y_pos)
                            obj.Center = false
                            obj.Text = Utility.GetCase(text, library.flags["esp flag case"])

                            left_y_pos += obj.TextBounds.Y + 2
                        end
                    end

                    if library.flags["esp name"] then
                        Name.Visible = true
                        Name.Color = library.flags["esp name color"]
                        Name.Transparency = library.flags["esp name color"].a
                        Name.Size = library.flags["esp size"]
                        Name.Font = Drawing.Fonts[library.flags["esp font"]]
                        Name.Center = true
                        Name.Position = Vector2.new(BoxPos.X + (BoxSize.X / 2), BoxPos.Y - Name.TextBounds.Y - 2)
                        Name.Text = Utility.GetCase(v.Name, library.flags["esp case"])
                    end

                    if library.flags["esp box"] then
                        BoxOutline.Position = BoxPos
                        BoxOutline.Size = BoxSize
                        BoxOutline.Visible = true
                        BoxOutline.Transparency = library.flags["esp box color"].a - 0.4

                        Box.Position = BoxPos
                        Box.Size = BoxSize
                        Box.Color = library.flags["esp box color"]
                        Box.Transparency = library.flags["esp box color"].a
                        Box.Visible = true
                    end

                    if library.flags["esp distance"] then
                        createFlag("Bottom", Distance, math.ceil((LocalPlayer:DistanceFromCharacter(HumanoidRootPart.Position) * 5) / 30.48) .. " ft", "distance")
                    end

                    if library.flags["esp vis"] and Utility.IsVisible(HumanoidRootPart.Position, {Camera, LocalPlayer.Character}) then
                        createFlag("Left", Visible, "visible", "vis")
                    end

                    if library.flags["esp health bar"] then
                        Health.Size = Vector2.new(2, (BoxSize.Y) * (Humanoid.Health / Humanoid.MaxHealth))
                        Health.Position = Vector2.new(BoxPos.X - 6, (BoxPos.Y + BoxSize.Y) - Health.Size.Y)
                        Health.Filled = true
                        Health.Visible = true
                        Health.Color = library.flags["esp health bar color"] 
                        Health.Transparency = library.flags["esp health bar color"].a

                        HealthOutline.Visible = true
                        HealthOutline.Position = Vector2.new(BoxPos.X - 7, BoxPos.Y - 1)
                        HealthOutline.Size = Vector2.new(4, BoxSize.Y + 2)
                        HealthOutline.Transparency = library.flags["esp health bar color"].a - 0.4
                        HealthOutline.Filled = true
                    end

                    if library.flags["esp health number"] then
                        HealthNumber.Visible = true
                        HealthNumber.Color = library.flags["esp health number color"]
                        HealthNumber.Transparency = library.flags["esp health number color"].a
                        HealthNumber.Size = library.flags["esp size"]
                        HealthNumber.Font = Drawing.Fonts[library.flags["esp font"]]
                        HealthNumber.Center = library.flags["esp health bar"] and true or false
                        HealthNumber.Text = tostring(math.round(Humanoid.Health))

                        if library.flags["esp health bar"] then
                            HealthNumber.Position = Vector2.new(BoxPos.X - 6, ((BoxPos.Y + BoxSize.Y) - Health.Size.Y) - HealthNumber.TextBounds.Y / 2)
                        else
                            HealthNumber.Position = Vector2.new(BoxPos.X - HealthNumber.TextBounds.X - 3, (BoxPos.Y - 3))
                        end 
                    end
                end
            else
                for _,v in pairs(Drawings) do
                    v.Visible = false
                end
            end
        end
    end
end)

visuals:show()

library:setpos()