local playerCooldown = 0

net.Receive("SCS_ChatSendMessage", function(len, ply)
	local chatMessage = net.ReadString()
	net.Start("SCS_ChatReceiveMessage")
		net.WriteString(chatMessage)
		net.WriteEntity(ply)
	net.Broadcast()
end)

gameevent.Listen( "player_connect" )
hook.Add("player_connect", "SCSPlayerJoined", function(data)
	if playerCooldown > CurTime() then return end
	playerCooldown = 5 + CurTime()
	local joinSound = ents.FindByName("newplayer_sound")[1]
	joinSound:Fire("PlaySound")
end)

gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", "SCSPlayerLeft", function( data )
	if playerCooldown > CurTime() then return end
	playerCooldown = 5 + CurTime()
	local leaveSound = ents.FindByName("playerleft_sound")[1]
	leaveSound:Fire("PlaySound")
	net.Start("SCS_PlayerLeft")
		net.WriteString(data.name)
	net.Broadcast()
end)

