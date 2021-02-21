surface.CreateFont( "Timer_Font", {
	font = "Arial",
	extended = false,
	size = 126,
	weight = 250,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

net.Receive("SCS_PlayerJoined", function()
	local ply = net.ReadString()
	LocalPlayer():ChatPrint(ply .. " has joined the session")
end)

net.Receive("SCS_PlayerLeft", function()
	local ply = net.ReadString()
	LocalPlayer():ChatPrint(ply .. " has left the session")
end)

hook.Add("HUDPaint", "SCS_Timer", function()
	if timer.Exists("SCS_Vote_ClientTimer") then
		surface.SetFont( "Timer_Font" )
		surface.SetTextColor( 255, 255, 255 )
		surface.SetTextPos( ScrW() / 2.4, ScrH() / 8 ) 
		surface.DrawText("Time Left: " ..tostring(math.Round(timer.TimeLeft("SCS_Vote_ClientTimer"))))
		
		if timer.TimeLeft("SCS_Vote_ClientTimer") <= 5 and not timer.Exists("Timer_Blip") then
			timer.Create("Timer_Blip", 1, 5, function()
				surface.PlaySound("buttons/blip1.wav")
			end)
		end
	end
end)

concommand.Add("scs_classic", function(ply, cmd, args)
	if GetConVar("gsrchud_enabled"):GetInt() == 0 then
		ply:ConCommand("gsrchud_enabled 1")
	else
		ply:ConCommand("gsrchud_enabled 0")
	end
	ply:ConCommand("gsrchud_death_screen_enabled 0")
	ply:ConCommand("gsrchud_theme Sven Co-op")
end)