local blueNPCs = 0
local redNPCs = 0
local greenNPCs = 0
local yellowNPCs = 0

defeated = 0

function GM:OnEntityCreated(ent)
	--If not an npc, do nothing
	if not ent:IsNPC() then return end
	--Set the NPC team to the appropriate player team
	timer.Simple(0.1, function() 
	
		if not ent:GetName() then return end
		--If the NPC is part of the player team, set a local variable in the ent
		if ent:GetName() == "Blue" then
			ent:SetColor(Color(0, 0, 240, 255))
			ent.Team = TEAM_BLUE
			blueNPCs = blueNPCs + 1
		elseif ent:GetName() == "Red" then
			ent:SetColor(Color(240, 0, 0, 255))
			ent.Team = TEAM_RED
			redNPCs = redNPCs + 1
		elseif ent:GetName() == "Green" then
			ent:SetColor(Color(255, 250, 0, 255))
			ent.Team = TEAM_GREEN
			greenNPCs = greenNPCs + 1
		elseif ent:GetName() == "Yellow" then
			ent:SetColor(Color(0, 255, 65, 255))
			ent.Team = TEAM_YELLOW
			yellowNPCs = yellowNPCs + 1
		end
	end)
	
	timer.Simple(0.2, function() 
		--If the NPC is part of the team, set their relationship
		for k, v in pairs(player.GetAll()) do
			if v:Team() == ent.Team then
				ent:AddEntityRelationship(v, D_LI, 99 )
			else
				ent:AddEntityRelationship(v, D_NU, 99 )
			end
		end
		
		for i, n in pairs(ents.FindByClass("monster_*")) do
			if n.Team == ent.Team then
				ent:AddEntityRelationship(n, D_LI, 99 )
			else
				ent:AddEntityRelationship(n, D_HT, 99 )
			end
		end
		
		for i, h in pairs(ents.FindByClass("npc_*")) do
			if h.Team == ent.Team then
				ent:AddEntityRelationship(h, D_LI, 99 )
			else
				ent:AddEntityRelationship(h, D_HT, 99 )
			end
		end
	end)
	timer.Create("NPCPatrolTime", 6, 0, function()
		--ent:SetSchedule(SCHED_COMBAT_PATROL)
	end)
end


hook.Add("OnNPCKilled", "TeamNPCKilled", function(npc, attacker, inflictor)
	if not npc:IsNPC() then return end
	
	if npc.Team == TEAM_BLUE then
		blueNPCs = blueNPCs - 1
		if blueNPCs <= 0 then
			ents.FindByName("defeated_teams_counter")[1]:Fire("Add", "1")
			ents.FindByName("blue_defeated_text")[1]:Fire("Display")
			ents.FindByName("blue_defeated_sound")[1]:Fire("PlaySound")
		end
	end
	
	if npc.Team == TEAM_RED then
		redNPCs = redNPCs - 1
		if redNPCs <= 0 then
			ents.FindByName("defeated_teams_counter")[1]:Fire("Add", "1")
			ents.FindByName("red_defeated_text")[1]:Fire("Display")
			ents.FindByName("red_defeated_sound")[1]:Fire("PlaySound")
		end
	end
	
	if npc.Team == TEAM_YELLOW then
		yellowNPCs = yellowNPCs - 1
		if yellowNPCs <= 0 then
			ents.FindByName("defeated_teams_counter")[1]:Fire("Add", "1")
			ents.FindByName("yellow_defeated_text")[1]:Fire("Display")
			ents.FindByName("yellow_defeated_sound")[1]:Fire("PlaySound")
		end
	end
	
	if npc.Team == TEAM_GREEN then
		greenNPCs = greenNPCs - 1
		if greenNPCs <= 0 then
			ents.FindByName("defeated_teams_counter")[1]:Fire("Add", "1")
			ents.FindByName("green_defeated_text")[1]:Fire("Display")
			ents.FindByName("green_defeated_sound")[1]:Fire("PlaySound")
		end
	end
end)