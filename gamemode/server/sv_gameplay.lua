local teams = {
	["Blue"] = false,
	["Red"] = false,
	["Green"] = false,
	["Yellow"] = false
}

local serverVoteTable = {}

local musicPlayer

--Set up initial setup
function SetUpGame()
	local SetdefeatedTeams = ents.FindByName("defeated_teams_counter")[1]
	SetdefeatedTeams:SetKeyValue("max", 1)
	
	local luaRun = ents.FindByName("assign_team_lua")[1]
	
	local redAssignTrigger = ents.FindByName("red_assign_trigger")[1]
	local blueAssignTrigger = ents.FindByName("blue_assign_trigger")[1]
	local yellowAssignTrigger = ents.FindByName("yellow_assign_trigger")[1]
	local greenAssignTrigger = ents.FindByName("green_assign_trigger")[1]
	local resetTrigger = ents.FindByName("resetteam_teleport")[1]
	
	redAssignTrigger:Fire("AddOutput", "OnStartTouch assign_team_lua:RunPassedCode:hook.Run('RedAssign'):0:-1")
	blueAssignTrigger:Fire("AddOutput", "OnStartTouch assign_team_lua:RunPassedCode:hook.Run('BlueAssign'):0:-1")
	yellowAssignTrigger:Fire("AddOutput", "OnStartTouch assign_team_lua:RunPassedCode:hook.Run('YellowAssign'):0:-1")
	greenAssignTrigger:Fire("AddOutput", "OnStartTouch assign_team_lua:RunPassedCode:hook.Run('GreenAssign'):0:-1")
	greenAssignTrigger:Fire("AddOutput", "OnStartTouch assign_team_lua:RunPassedCode:hook.Run('GreenAssign'):0:-1")
	resetTrigger:Fire("AddOutput", "OnStartTouch assign_team_lua:RunPassedCode:hook.Run('ResetTeam'):0:-1")
	
end

--Begins Votes on clients
function BeginVote()
	for k, v in pairs(player.GetAll()) do
		v:ChatPrint("Beginning vote in 10 seconds")
	end
	timer.Simple(10, function()
		net.Start("SCS_Vote")
		net.Broadcast()
	end)
	serverVoteTable = {
		["TwoTeams"] = 0,
		["FourTeams"] = 0,
		["StartFivePoints"] = 0,
		["StartNintyPoints"] = 0,
		["ThreeWinLimit"] = 0,
		["SixWinLimit"] = 0,
		["NineWinLimit"] = 0,
		["TwelveWinLimit"] = 0
	}
	timer.Simple(42, function() EndVote() end)
end

function EndVote()
	net.Start("SCS_EndVote")
	net.Broadcast()
	DisplayVotes(serverVoteTable)
end

function DisplayVotes(votes)
	local failedVote = false
	for k, v in pairs(player.GetAll()) do
		v:ChatPrint("Vote Results")
		v:ChatPrint("------------")
		if votes["TwoTeams"] > votes["FourTeams"] then
			v:ChatPrint("Teams: Two")
			teams["Blue"] = true
			teams["Red"] = true
			teams["Green"] = false
			teams["Yellow"] = false
		elseif votes["TwoTeams"] < votes["FourTeams"] then
			v:ChatPrint("Teams: Four")
			teams["Blue"] = true
			teams["Red"] = true
			teams["Green"] = true
			teams["Yellow"] = true
		else
			failedVote = true
			v:ChatPrint("ERROR: Tie between 2 and 4 teams")
		end
		v:ChatPrint("------------")
	end
	
	local mainDoor = ents.FindByName("teamselect_door")[1]
	mainDoor:Fire("Open")
	
	local blueDoor = ents.FindByName("blueteam_door")[1]
	local redDoor = ents.FindByName("redteam_door")[1]
	local greenDoor = ents.FindByName("greenteam_door")[1]
	local yellowDoor = ents.FindByName("yellowteam_door")[1]
	
	if failedVote then return end
	
	if teams["Blue"] and teams["Red"] then
		blueDoor:Fire("Open")
		redDoor:Fire("Open")
	end
	
	if teams["Green"] and teams["Yellow"] then
		greenDoor:Fire("Open")
		yellowDoor:Fire("Open")
	end
	local maxCount = 0
	for k, t in pairs(teams) do
		if t then
			maxCount = maxCount + 1
		end
	end
	
	local teamCounter = ents.FindByName("teams_ready_counter")[1]
	teamCounter:SetKeyValue("max", maxCount)
	
end

net.Receive("SCS_ReceiveClientVote", function(len, ply)
	local clientTable = net.ReadTable()
	
	serverVoteTable["TwoTeams"] = serverVoteTable["TwoTeams"] + clientTable["TwoTeams"]
	serverVoteTable["FourTeams"] = serverVoteTable["FourTeams"] + clientTable["FourTeams"]
end)

--Begin the Fight
function BeginFight()
	defeatedTeams = 0
	room = 1
	local music = math.random(1, 10)
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
	if music == 10 then
		musicPlayer = ents.FindByName("scs_battlemusic_10")[1]
	else
		musicPlayer = ents.FindByName("scs_battlemusic_0" .. music)[1]
	end
	
	musicPlayer:Fire("PlaySound")
	
	timer.Simple(3, function()
		if teams["Blue"] then
			local blueSpawner = ents.FindByName("battleroom_0" .. room .. "_blue_spawner")[1]
			blueSpawner:SetKeyValue("StartDisabled", 0)
			blueSpawner:SetKeyValue("NPCType", "npc_zombie")
			blueSpawner:SetKeyValue("MaxLiveChildren", 2)
			blueSpawner:Fire("Spawn")
		end
		
		if teams["Red"] then
			local redSpawner = ents.FindByName("battleroom_0" .. room .. "_red_spawner")[1]
			redSpawner:SetKeyValue("StartDisabled", 0)
			redSpawner:SetKeyValue("NPCType", "npc_zombie")
			redSpawner:SetKeyValue("MaxLiveChildren", 2)
			redSpawner:Fire("Spawn")
		end
		
		if teams["Green"] then
			local greenSpawner = ents.FindByName("battleroom_0" .. room .. "_green_spawner")[1]
			greenSpawner:SetKeyValue("StartDisabled", 0)
			greenSpawner:SetKeyValue("NPCType", "monster_zombie_scientist")
			greenSpawner:Fire("Spawn")
		end
		
		if teams["Yellow"] then
			local yellowSpawner = ents.FindByName("battleroom_0" .. room .. "_yellow_spawner")[1]
			yellowSpawner:SetKeyValue("StartDisabled", 0)
			yellowSpawner:SetKeyValue("NPCType", "monster_zombie_scientist")
			yellowSpawner:Fire("Spawn")
		end	
	end)
end

--When opposing teams NPC's are dead, end the fight
function EndFight()
	local winningTeam
	musicPlayer:Fire("StopSound")
	for k, v in pairs(player.GetAll()) do
		if v:Team() == TEAM_BLUE then
			local bluePos = ents.FindByName("blueteam_teledest")[1]:GetPos()
			v:SetPos(bluePos)
		elseif v:Team() == TEAM_RED then
			local redPos = ents.FindByName("redteam_teledest")[1]:GetPos()
			v:SetPos(redPos)
		elseif v:Team() == TEAM_GREEN then
			local greenPos = ents.FindByName("greenteam_teledest")[1]:GetPos()
			v:SetPos(greenPos)
		elseif v:Team() == TEAM_YELLOW then
			local yellowPos = ents.FindByName("yellowteam_teledest")[1]:GetPos()
			v:SetPos(yellowPos)
		end
	end
	
	for k, n in pairs(ents.FindByClass("npc_*")) do
		winningTeam = n.Team
		n:Remove()
	end
	
	if winningTeam == TEAM_BLUE then
		ents.FindByName("blue_win_text")[1]:Fire("Display")
		ents.FindByName("blue_won_sound")[1]:Fire("PlaySound")
	elseif winningTeam == TEAM_RED then
		ents.FindByName("red_win_text")[1]:Fire("Display")
		ents.FindByName("red_won_sound")[1]:Fire("PlaySound")
	elseif winningTeam == TEAM_GREEN then
		ents.FindByName("green_win_text")[1]:Fire("Display")
		ents.FindByName("green_won_sound")[1]:Fire("PlaySound")
	elseif winningTeam == TEAM_YELLOW then
		ents.FindByName("yellow_win_text")[1]:Fire("Display")
		ents.FindByName("yellow_won_sound")[1]:Fire("PlaySound")
	else
		
	end
	
end

--Admin Binds SHOULD DELETE WHEN FINISHED
function GM:ShowHelp(ply)
	if not ply:IsAdmin() then return end
	maxDefeated = 1
	teams["Blue"] = true
	teams["Red"] = true
	--teams["Green"] = true
	--teams["Yellow"] = true
	BeginFight()
end

function GM:ShowTeam(ply)
	if not ply:IsAdmin() then return end
	EndFight()
end

--Assign Teams
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

hook.Add("ResetTeam", "PlyResetTeam", function()
	local activator, caller = ACTIVATOR, CALLER
	AssignTeam(activator, 5)
end )

--Set up game on Post Map or Cleanup
hook.Add("InitPostEntity", "SetUp", function()
	SetUpGame()
end)

hook.Add("PostCleanupMap", "SetUp", function()
	SetUpGame()
end)

