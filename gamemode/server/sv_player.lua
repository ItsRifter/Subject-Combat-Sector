TEAM_BLUE = 1
team.SetUp(TEAM_BLUE, "Blue Team", Color(0, 0, 240, 255))

TEAM_RED = 2
team.SetUp(TEAM_RED, "Red Team", Color(240, 0, 0, 255))

TEAM_YELLOW = 3
team.SetUp(TEAM_YELLOW, "Yellow Team", Color(255, 250, 0, 255))

TEAM_GREEN = 4
team.SetUp(TEAM_GREEN, "Green Team", Color(0, 255, 65, 255))

TEAM_DEFAULT = 5
team.SetUp(TEAM_DEFAULT, "No Team", Color(255, 255, 255, 255))

function GM:PlayerInitialSpawn(ply)
	ply:SetTeam(TEAM_DEFAULT)
	ply:SetModel("models/player/SGG/hev_helmet.mdl")
end

function GM:PlayerSpawn(ply)
	SetTeamColour(ply, ply:Team())
	ply:SetupHands()
	ply:SetCustomCollisionCheck(true)
end

function SetTeamColour(ply, team)
	if team == TEAM_BLUE then
		ply:SetPlayerColor(Vector(0, 0, 0.8))
	elseif team == TEAM_RED then
		ply:SetPlayerColor(Vector(1, 0, 0))
	elseif team == TEAM_YELLOW then
		ply:SetPlayerColor(Vector(1, 1, 0))
	elseif team == TEAM_GREEN then
		ply:SetPlayerColor(Vector(0, 1, 0))
	else
		ply:SetPlayerColor(Vector(1, 1, 1))
	end
end

function AssignTeam(ply, team)
	ply:SetTeam(team)
	SetTeamColour(ply, team)
	ply:SetupHands()
end

function GM:ShouldCollide( ply1, ply2 )
	if (ply1:IsPlayer() and ply2:IsPlayer()) and (ply1:Team() == ply2:Team() or ply2:Team() == ply1:Team()) then
		return false
	end
	
	return true
end

hook.Add("EntityTakeDamage", "TeamFriendly", function(ply, dmgInfo)
	local attacker = dmgInfo:GetAttacker()
	if (attacker:IsPlayer() and ply:IsPlayer()) and (attacker:Team() == ply:Team()) then
		dmgInfo:SetDamage(0)
		return
	end
	
	if attacker:GetClass() == "func_physbox" then
		dmgInfo:SetDamage(0)
		return
	end
end)

concommand.Add("scs_setteam", function(ply, cmd, args)
	if not ply:IsAdmin() then return end
	local colour = tostring(args[1])
	
	if string.find(colour, "blue") then
		ply:SetTeam(TEAM_BLUE)
	elseif string.find(colour, "red") then
		ply:SetTeam(TEAM_RED)
	elseif string.find(colour, "yellow") then
		ply:SetTeam(TEAM_YELLOW)
	elseif string.find(colour, "green") then
		ply:SetTeam(TEAM_GREEN)
	else
		ply:SetTeam(TEAM_DEFAULT)
	end
	
	ply:Spawn()
end)
