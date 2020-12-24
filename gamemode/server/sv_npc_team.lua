function GM:OnEntityCreated(ent)
	--If not an npc, do nothing
	if not ent:IsNPC() then return end
	--Set the NPC team to the appropriate player team

	local team = ent:GetKeyValues()
	if not team then return end
	
	--If the NPC is part of the player team, set a local variable in the ent
	if table.HasValue(ent:GetKeyValues(), "Blue") then
		ent:SetKeyValue("squadname", "Blue")
		ent:SetColor(Color(0, 0, 240, 255))
		ent.Team = TEAM_BLUE
	elseif table.HasValue(ent:GetKeyValues(), "Red") then
		ent:SetKeyValue("squadname", "Red")
		ent:SetColor(Color(240, 0, 0, 255))
		ent.Team = TEAM_RED
	elseif table.HasValue(ent:GetKeyValues(), "Green") then
		ent:SetKeyValue("squadname", "Green")
		ent:SetColor(Color(255, 250, 0, 255))
		ent.Team = TEAM_GREEN
	elseif table.HasValue(ent:GetKeyValues(), "Yellow") then
		ent:SetKeyValue("squadname", "Yellow")
		ent:SetColor(Color(0, 255, 65, 255))
		ent.Team = TEAM_YELLOW
	end
	
	--If the NPC is part of the team, set their relationship
	for k, v in pairs(player.GetAll()) do
		if v:Team() == ent.Team then
			ent:AddEntityRelationship(v, D_LI, 99 )
		end
	end
	
	for i, n in pairs(ents.FindByClass("npc_*")) do
		if n.Team == ent.Team then
			ent:AddEntityRelationship(n, D_LI, 99 )
			n:AddEntityRelationship(ent, D_LI, 99 )
		else
			ent:AddEntityRelationship(n, D_HT, 99 )
			n:AddEntityRelationship(ent, D_HT, 99 )
		end
 	end
	
end