redTeam = false
blueTeam = false
greenTeam = false
yellowTeam = false

function SetUpGame()
	local luaRun = ents.FindByName("assign_team_lua")[1]
	local redAssignTrigger = ents.FindByName("red_assign_trigger")[1]
	local blueAssignTrigger = ents.FindByName("blue_assign_trigger")[1]
	local yellowAssignTrigger = ents.FindByName("yellow_assign_trigger")[1]
	local greenAssignTrigger = ents.FindByName("green_assign_trigger")[1]
	
	redAssignTrigger:Fire("AddOutput", "OnStartTouch assign_team_lua:RunPassedCode:hook.Run('RedAssign'):0:-1")
	blueAssignTrigger:Fire("AddOutput", "OnStartTouch assign_team_lua:RunPassedCode:hook.Run('BlueAssign'):0:-1")
	yellowAssignTrigger:Fire("AddOutput", "OnStartTouch assign_team_lua:RunPassedCode:hook.Run('YellowAssign'):0:-1")
	greenAssignTrigger:Fire("AddOutput", "OnStartTouch assign_team_lua:RunPassedCode:hook.Run('GreenAssign'):0:-1")
	
end

function BeginVote()
	local openDoor = ents.FindByName("teamselect_door")[1]
	openDoor:Fire("Open")
	
	local blueSelectDoor = ents.FindByName("blueteam_door")[1]
	local redSelectDoor = ents.FindByName("redteam_door")[1]
	local yellowSelectDoor = ents.FindByName("yellowteam_door")[1]
	local greenSelectDoor = ents.FindByName("greenteam_door")[1]
	
	blueSelectDoor:Fire("Open")
	redSelectDoor:Fire("Open")
	--yellowSelectDoor:Fire("Open")
	--greenSelectDoor:Fire("Open")
	local teamReadyCounter = ents.FindByName("teams_ready_counter")[1]
	teamReadyCounter:SetKeyValue("max", 2)
end


function BeginFight()
	local room = math.random(1, 1)
	local music = math.random(1, 1)
	for k, v in pairs(player.GetAll()) do
		if v:Team() == TEAM_BLUE then
			local bluePos = ents.FindByName("battleroom_0" .. room .. "_blue_telepos")[1]:GetPos()
			v:SetPos(bluePos)
		elseif v:Team() == TEAM_RED then
			local redPos = ents.FindByName("battleroom_0" .. room .. "_red_telepos")[1]:GetPos()
			v:SetPos(redPos)
		elseif v:Team() == TEAM_GREEN then
			local greenPos = ents.FindByName("battleroom_0" .. room .. "_green_telepos")[1]:GetPos()
			v:SetPos(greenPos)
		elseif v:Team() == TEAM_YELLOW then
			local yellowPos = ents.FindByName("battleroom_0" .. room .. "_yellow_telepos")[1]:GetPos()
			v:SetPos(yellowPos)
		end
	end
	
	local stopDefaultMusic = ents.FindByName("scs_music")[1]
	stopDefaultMusic:Fire("StopSound")
end

function EndFight()
	
end

function GM:ShowHelp(ply)
	
end

function GM:ShowTeam(ply)
	
end

hook.Add("BlueAssign", "PlyAssignBlue", function()
	local activator, caller = ACTIVATOR, CALLER
	AssignTeam(activator, 1)
end )

hook.Add("RedAssign", "PlyAssignRed", function()
	local activator, caller = ACTIVATOR, CALLER
	AssignTeam(activator, 2)
end )

hook.Add("YellowAssign", "PlyAssignBlue", function()
	local activator, caller = ACTIVATOR, CALLER
	AssignTeam(activator, 3)
end )

hook.Add("GreenAssign", "PlyAssignRed", function()
	local activator, caller = ACTIVATOR, CALLER
	AssignTeam(activator, 4)
end )

hook.Add("InitPostEntity", "SetUp", function()
	SetUpGame()
end)

hook.Add("PostCleanupMap", "SetUp", function()
	SetUpGame()
end)

