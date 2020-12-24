net.Receive("SCS_PlayerJoined", function()
	local ply = net.ReadString()
	LocalPlayer():ChatPrint(ply .. " has joined the session")
end)

net.Receive("SCS_PlayerLeft", function()
	local ply = net.ReadString()
	LocalPlayer():ChatPrint(ply .. " has left the session")
end)