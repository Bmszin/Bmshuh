local function AutoCDK()
  local Cursed, DoorProgress = WaitPart(Map, "Turtle", "Cursed")
  
  local function MasterySwords()
    local TushitaM, YamaM = ItemMastery("Tushita"), ItemMastery("Yama")
    
    if TushitaM and TushitaM < 350 then
      if not VerifyTool("Tushita") then
        FireRemote("LoadItem", "Tushita")
      end
    elseif YamaM and YamaM < 350 then
      if not VerifyTool("Yama") then
        FireRemote("LoadItem", "Yama")
      end
    else
      return false
    end;EquipToolTip("Sword")
    
    local Enemie = GetEnemies({"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"})
    if Enemie then
      PlayerTP(Enemie.HumanoidRootPart.CFrame + getgenv().FarmPos)
      pcall(function()ActiveHaki()BringNPC(Enemie, true)end)
    else
      PlayerTP(CFrame.new(-9513, 164, 5786))
    end
    return true
  end
  
  local function IndentifyQuest()
    if VerifyItem("Cursed Dual Katana") then return {"Finished"} end -- Virefica se o jogador possui a CDK
    if MasterySwords() then return {"MasterySwords"} end -- Verifica a maestria da Yama e a Tushita
    
    local Door = Cursed:FindFirstChild("Breakable")
    if Door and Door.CanCollide then
      local Prog = FireRemote("CDKQuest", "OpenDoor")
      if type(Prog) == "string" and Prog == "opened" then
        return {"OpenDoor"}
      else
        Door.CanCollide = false
      end
    end -- Verifica se a porta estÃ¡ aberta
    
    local Count = GetMaterial("Alucard Fragment") -- Pega a quantidade de material atual
    
    if Count == 6 then -- Verifica se Ã© a ultima missÃ£o
      return {"FinalQuest"}
    elseif Count == 0 then
      FireRemote("CDKQuest", "Progress", "Evil")FireRemote("CDKQuest", "StartTrial", "Evil")
      return {"Yama", 1} -- Retorna a primeira missÃ£o
    elseif Map:FindFirstChild("HellDimension") then
      return {"Yama", 3} -- Retorna a dimensÃ£o da Yama
    elseif Map:FindFirstChild("HeavenlyDimension") then
      return {"Tushita", 3} -- Retorna a dimensÃ£o da Tushita
    elseif Player:FindFirstChild("QuestHaze") then
      return {"Yama", 2} -- Retorna a nÃ©voa da miseria
    end
    
    local Progress = FireRemote("CDKQuest", "Progress")
    local Good = Progress.Good
    local Evil = Progress.Evil
    
    if Evil and Evil >= 0 and Evil < 3 then
      FireRemote("CDKQuest", "Progress", "Evil")FireRemote("CDKQuest", "StartTrial", "Evil")
      if Evil == 0 then
        return {"Yama", 1}
      elseif Evil == 1 then
        return {"Yama", 2}
      elseif Evil == 2 then
        return {"Yama", 3}
      end
    elseif Good and Good >= 0 and Good < 3 then
      FireRemote("CDKQuest", "Progress", "Good")FireRemote("CDKQuest", "StartTrial", "Good")
      if Good == 0 then
        return {"Tushita", 1}
      elseif Good == 1 then
        return {"Tushita", 2}
      elseif Good == 2 then
        return {"Tushita", 3}
      end
    end
  end
  
  local function KillHazeEnemies()
    local QuestHaze = Player:FindFirstChild("QuestHaze")
    if QuestHaze then
      local Nearest, Enemie = math.huge
      for _,v in pairs(QuestHaze:GetChildren()) do
        if v.Value > 0 then
          local plrPP = Player.Character and Player.Character.PrimaryPart
          local EnemiePos = v:GetAttribute("Position")
          if v.Name == "Dragon Crew Warrior" then EnemiePos = Vector3.new(6431, 51, -1043)end
          if plrPP and EnemiePos and (EnemiePos - plrPP.Position).Magnitude <= Nearest then
            Nearest, Enemie = (EnemiePos - plrPP.Position).Magnitude, ({Name = v.Name, Position = EnemiePos})
          end
        end
      end
      
      if Enemie then
        local Enemies = GetEnemies({Enemie.Name})
        if Enemies and Enemies:FindFirstChild("HumanoidRootPart") then
          PlayerTP(Enemies.HumanoidRootPart.CFrame + getgenv().FarmPos)
          pcall(function()ActiveHaki()EquipTool()BringNPC(Enemies)end)
        else
          if Enemie.Position then
            PlayerTP(CFrame.new(Enemie.Position))
          end
        end;getgenv().CursedDualKatana = true
      else
        getgenv().CursedDualKatana = false
      end
    end
  end
  
  local function GetTorch(Dimension)
    if Dimension then
      local Torch1 = Dimension:FindFirstChild("Torch1")
      local Torch2 = Dimension:FindFirstChild("Torch2")
      local Torch3 = Dimension:FindFirstChild("Torch3")
      
      if Torch1 and Torch1:FindFirstChild("ProximityPrompt") then
        if Torch1.ProximityPrompt.Enabled then
          return Torch1
        end
      end
      if Torch2 and Torch2:FindFirstChild("ProximityPrompt") then
        if Torch2.ProximityPrompt.Enabled then
          return Torch2
        end
      end
      if Torch3 and Torch3:FindFirstChild("ProximityPrompt") then
        if Torch3.ProximityPrompt.Enabled then
          return Torch3
        end
      end
      return Dimension:FindFirstChild("Exit")
    end
  end
  
  local function InvokeSoulReaper()
    local HellDimension = Map:FindFirstChild("HellDimension")
    if HellDimension then
      local plrPP = Player.Character and Player.Character.PrimaryPart
      if plrPP and (plrPP.Position - HellDimension.WorldPivot.p).Magnitude < 2500 then
        local Enemies = GetEnemies({"Hell's Messenger", "Cursed Skeleton"}, 2500)
        local Torch = GetTorch(HellDimension)
        
        if Enemies then
          PlayerTP(Enemies.HumanoidRootPart.CFrame + getgenv().FarmPos)
          pcall(function()ActiveHaki()EquipTool()BringNPC(Enemies, true)end)
        elseif Torch then
          PlayerTP(Torch.CFrame)
          if (plrPP.Position - Torch.Position).Magnitude < 10 then
            if Torch:FindFirstChild("ProximityPrompt") and fireproximityprompt then
              fireproximityprompt(Torch.ProximityPrompt)task.wait(0.5)
            end
          end
        end;getgenv().CursedDualKatana = true
      else
        getgenv().CursedDualKatana = false
      end
    else
      local SoulReaper = GetEnemies({"Soul Reaper"})
      
      if SoulReaper and SoulReaper:FindFirstChild("HumanoidRootPart") then
        PlayerTP(SoulReaper.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0))DisableTools()
      elseif VerifyTool("Hallow Essence") then
        EquipToolName("Hallow Essence")
        pcall(function()PlayerTP(Map["Haunted Castle"].Summoner.Detection.CFrame)end)
      else
        if GetMaterial("Bones") >= 50 then
          FireRemote("Bones", "Buy", 1, 1)
        end
        local Enemie = GetEnemies({"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posessed Mummy"})
        if Enemie then
          PlayerTP(Enemie.HumanoidRootPart.CFrame + getgenv().FarmPos)
          pcall(function()ActiveHaki()EquipTool()BringNPC(Enemie, true)end)
        else
          PlayerTP(CFrame.new(-9513, 164, 5786))
        end
      end;getgenv().CursedDualKatana = true
    end
  end
  
  local function DieGhost()
    if not VerifyTool("Yama") then
      FireRemote("LoadItem", "Yama")
    else
      local NPC = GetEnemies({"Forest Pirate"})EquipToolName("Yama")
      
      if NPC and NPC:FindFirstChild("HumanoidRootPart") then
        PlayerTP(NPC.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2))
      else
        PlayerTP(CFrame.new(-13350, 332, -7645))
      end;getgenv().CursedDualKatana = true
    end
  end
  
  local function GetPirateRaidNPC()
    for _,npc in pairs(Enemies:GetChildren()) do
      if npc.Name ~= "rip_indra True Form" and IsAlive(npc) then
        if npc.PrimaryPart and (npc.PrimaryPart.Position - Vector3.new(-5556, 314, -2988)).Magnitude < 700 then
          return npc
        end
      end
    end
  end
  
  local function PirateRaid()
    if VerifyRaidPirate(true) then
      local Enemie = GetPirateRaidNPC()
      
      if Enemie and Enemie:FindFirstChild("HumanoidRootPart") then
        PlayerTP(Enemie.HumanoidRootPart.CFrame + getgenv().FarmPos)
        pcall(function()ActiveHaki()EquipTool()BringNPC(Enemie, true)end)
      else
        PlayerTP(CFrame.new(-5556, 314, -2988))
      end;getgenv().CursedDualKatana = true
    else
      getgenv().CursedDualKatana = false
    end
  end
  
  local function BigMoon()
    local HeavenlyDimension = Map:FindFirstChild("HeavenlyDimension")
    if HeavenlyDimension then
      local plrPP = Player.Character and Player.Character.PrimaryPart
      if plrPP and (plrPP.Position - HeavenlyDimension.WorldPivot.p).Magnitude < 2500 then
        local Enemies = GetEnemies({"Heaven's Guardian", "Cursed Skeleton"}, 2500)
        local Torch = GetTorch(HeavenlyDimension)
        
        if Enemies then
          PlayerTP(Enemies.HumanoidRootPart.CFrame + getgenv().FarmPos)
          pcall(function()ActiveHaki()EquipTool()BringNPC(Enemies, true)end)
        elseif Torch then
          PlayerTP(Torch.CFrame)
          if (plrPP.Position - Torch.Position).Magnitude < 10 then
            if Torch:FindFirstChild("ProximityPrompt") and fireproximityprompt then
              fireproximityprompt(Torch.ProximityPrompt)task.wait(0.5)
            end
          end
        end;getgenv().CursedDualKatana = true
      else
        getgenv().CursedDualKatana = false
      end
    else
      local Boss = GetEnemies({"Cake Queen"})
      
      if Boss and Boss:FindFirstChild("HumanoidRootPart") then
        PlayerTP(Boss.HumanoidRootPart.CFrame + getgenv().FarmPos)
        pcall(function()ActiveHaki()EquipTool()end)
      else
        PlayerTP(CFrame.new(-710, 382, -11150))
      end;getgenv().CursedDualKatana = true
    end
  end
  
  local Boat1, Boat2, Boat3
  local function TalkBoatsDealer()
    local plrPP = Player.Character and Player.Character.PrimaryPart
    local BoatDealer = NPCS:FindFirstChild("Luxury Boat Dealer")
    
    if plrPP then
      if not Boat1 then
        PlayerTP(CFrame.new(-9550, 21, 4638))getgenv().CursedDualKatana = true
        if BoatDealer and (plrPP.Position - Vector3.new(-9550, 21, 4638)).Magnitude < 5 then
          FireRemote("CDKQuest", "BoatQuest", BoatDealer)FireRemote("CDKQuest", "BoatQuest", BoatDealer, "Check")task.wait(1)Boat1 = true
        end
      elseif not Boat2 then
        PlayerTP(CFrame.new(-9531, 7, -8376))getgenv().CursedDualKatana = true
        if BoatDealer and (plrPP.Position - Vector3.new(-9531, 7, -8376)).Magnitude < 5 then
          FireRemote("CDKQuest", "BoatQuest", BoatDealer)FireRemote("CDKQuest", "BoatQuest", BoatDealer, "Check")task.wait(1)Boat2 = true
        end
      elseif not Boat3 then
        PlayerTP(CFrame.new(-4602, 16, -2880))getgenv().CursedDualKatana = true
        if BoatDealer and (plrPP.Position - Vector3.new(-4602, 16, -2880)).Magnitude < 5 then
          FireRemote("CDKQuest", "BoatQuest", BoatDealer)FireRemote("CDKQuest", "BoatQuest", BoatDealer, "Check")task.wait(1)Boat3 = true
        end
      else
        getgenv().CursedDualKatana = false
      end
    end
  end
  
  task.spawn(function()
    while getgenv().AutoCDK do task.wait()
      local Quest = IndentifyQuest()
      if Quest then
        getgenv().CurrentQuest = Quest
      end
    end
  end)
  
  while getgenv().AutoCDK do task.wait()
    if MyLevel.Value >= 2200 then
      local Quest = CurrentQuest
      if Quest then
        if Quest[1] == "Finished" then
          getgenv().CursedDualKatana = false
        elseif Quest[1] == "MasterySwords" then
          getgenv().CursedDualKatana = true
        elseif Quest[1] == "OpenDoor" then
          local plrPP = Player.Character and Player.Character.PrimaryPart
          if plrPP and (plrPP.Position - Vector3.new(-12131, 578, -6707)).Magnitude < 5 then
            FireRemote("CDKQuest", "OpenDoor")FireRemote("CDKQuest", "OpenDoor", true)
          else
            PlayerTP(CFrame.new(-12131, 578, -6707))getgenv().CursedDualKatana = true
          end
        elseif Quest[1] == "FinalQuest" then
          if not VerifyTool("Tushita") and not VerifyTool("Yama") then
            FireRemote("LoadItem", "Tushita")
          else
            if VerifyNPC("Cursed Skeleton Boss") then
              local Enemie = GetEnemies({"Cursed Skeleton Boss"})
              if Enemie and Enemie:FindFirstChild("HumanoidRootPart") then
                PlayerTP(Enemie.HumanoidRootPart.CFrame + getgenv().FarmPos)
                pcall(function()ActiveHaki()end)
              end;EquipToolTip("Sword")
            else
              local Pedestal1 = Cursed:FindFirstChild("Pedestal1")
              local Pedestal2 = Cursed:FindFirstChild("Pedestal2")
              local Pedestal3 = Cursed:FindFirstChild("Pedestal3")
              
              local Pedestal, Prompt
              if Pedestal3 and Pedestal3:FindFirstChild("ProximityPrompt") then
                if Pedestal3.ProximityPrompt.Enabled then
                  Pedestal, Prompt = Pedestal3, Pedestal3.ProximityPrompt
                end
              end
              if Pedestal2 and Pedestal2:FindFirstChild("ProximityPrompt") then
                if Pedestal2.ProximityPrompt.Enabled then
                  Pedestal, Prompt = Pedestal2, Pedestal2.ProximityPrompt
                end
              end
              if Pedestal1 and Pedestal1:FindFirstChild("ProximityPrompt") then
                if Pedestal1.ProximityPrompt.Enabled then
                  Pedestal, Prompt = Pedestal1, Pedestal1.ProximityPrompt
                end
              end
              
              if DialogVisible() then
                VirtualUser:ClickButton1(Vector2.new(1e4, 1e4))
              else
                if Pedestal then
                  local plrPP = Player.Character and Player.Character.PrimaryPart
                  if plrPP and (plrPP.Position - Pedestal.Position).Magnitude < 10 then
                    if Prompt and fireproximityprompt then
                      fireproximityprompt(Prompt)task.wait(0.5)
                    end
                  else
                    PlayerTP(Pedestal.CFrame)
                  end
                else
                  PlayerTP(CFrame.new(-12344, 603, -6551))
                end
              end
            end
          end;getgenv().CursedDualKatana = true
        elseif Quest[1] == "Tushita" then
          getgenv().ClickRequest = true
          if Quest[2] == 1 then
            TalkBoatsDealer()
          elseif Quest[2] == 2 then
            PirateRaid()
          else BigMoon() end
        elseif Quest[1] == "Yama" then
          if Quest[2] == 1 then
            DieGhost()getgenv().ClickRequest = false
          elseif Quest[2] == 2 then
            KillHazeEnemies()getgenv().ClickRequest = true
          else InvokeSoulReaper() end
        else
          getgenv().CursedDualKatana = false
        end
      end
    else
      getgenv().CursedDualKatana = false
    end
  end
  
  getgenv().ClickRequest = true
  getgenv().CursedDualKatana = false
end
