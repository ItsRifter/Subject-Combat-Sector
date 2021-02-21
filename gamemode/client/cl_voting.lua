--Fonts
surface.CreateFont( "MakeVote_Font", {
	font = "Arial",
	extended = false,
	size = 72,
	weight = 500,
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
	outline = true,
})

surface.CreateFont( "VoteSelection_Font", {
	font = "Arial",
	extended = false,
	size = 32,
	weight = 500,
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
	outline = true,
})
surface.CreateFont( "VoteSelection_Numbers_Font", {
	font = "Arial",
	extended = false,
	size = 48,
	weight = 500,
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
	outline = true,
})

surface.CreateFont( "VoteSubmit_Font", {
	font = "Arial",
	extended = false,
	size = 32,
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


--Client voting table
local voteTable = {
	["TwoTeams"] = 0,
	["FourTeams"] = 0,
	["StartFivePoints"] = 0,
	["StartNintyPoints"] = 0,
	["ThreeWinLimit"] = 0,
	["SixWinLimit"] = 0,
	["NineWinLimit"] = 0,
	["TwelveWinLimit"] = 0,
}

function Panic()
	if IsValid(voteFrame) then
		voteFrame:Close()
	end
end

--Shows the VGUI voting stuff
function BeginClientVoting()
	if not LocalPlayer().voteTable then
		LocalPlayer().voteTable = voteTable
	end
	
	voteFrame = vgui.Create("DFrame")
	voteFrame:SetSize(800, 1000)
	voteFrame:SetDraggable(false)
	voteFrame:ShowCloseButton(false)
	voteFrame:MakePopup()
	voteFrame:SetTitle("")
	voteFrame:Center()
	voteFrame.Paint = function(self, w, h)
		draw.RoundedBox(16, 0, 0, w, h, Color(0, 0, 0, 255))
		
		draw.RoundedBox(16, 5, 5, w / 1.01, h / 1.01, Color(75, 75, 75, 255))
	end
	
	local makeVoteLabel = vgui.Create("DLabel", voteFrame)
	makeVoteLabel:SetPos(voteFrame:GetWide() / 7.5, voteFrame:GetTall() / 10)
	makeVoteLabel:SetText("MAKE YOUR VOTE")
	makeVoteLabel:SetFont("MakeVote_Font")
	makeVoteLabel:SizeToContents()
	
	local makeTeamsLabel = vgui.Create("DLabel", voteFrame)
	makeTeamsLabel:SetPos(60, 300)
	makeTeamsLabel:SetText("Select Team Limit")
	makeTeamsLabel:SetFont("VoteSelection_Font")
	makeTeamsLabel:SizeToContents()
	
	voteCheckBoxTwoTeams = vgui.Create("DCheckBox", voteFrame)
	voteCheckBoxTwoTeams:SetSize(75, 75)
	voteCheckBoxTwoTeams:SetPos(50, 350)
	voteCheckBoxTwoTeams.OnChange = function(value)
		if voteCheckFourTeams:GetChecked() then
			voteCheckFourTeams:SetChecked(false)
			LocalPlayer().voteTable["TwoTeams"] = 1
			LocalPlayer().voteTable["FourTeams"] = 0
		else
			LocalPlayer().voteTable["TwoTeams"] = 1
			LocalPlayer().voteTable["FourTeams"] = 0
		end
	end
	
	local voteTwoTeamsLabel = vgui.Create("DLabel", voteFrame)
	voteTwoTeamsLabel:SetPos(75, 425)
	voteTwoTeamsLabel:SetText("2")
	voteTwoTeamsLabel:SetFont("VoteSelection_Numbers_Font")
	voteTwoTeamsLabel:SizeToContents()
	
	voteCheckFourTeams = vgui.Create("DCheckBox", voteFrame)
	voteCheckFourTeams:SetSize(75, 75)
	voteCheckFourTeams:SetPos(200, 350)
	voteCheckFourTeams.OnChange = function(value)
		if voteCheckBoxTwoTeams:GetChecked() then
			voteCheckBoxTwoTeams:SetChecked(false)
			LocalPlayer().voteTable["TwoTeams"] = 0
			LocalPlayer().voteTable["FourTeams"] = 1
		else
			LocalPlayer().voteTable["TwoTeams"] = 0
			LocalPlayer().voteTable["FourTeams"] = 1
		end
	end
	
	local voteFourTeamsLabel = vgui.Create("DLabel", voteFrame)
	voteFourTeamsLabel:SetPos(225, 425)
	voteFourTeamsLabel:SetText("4")
	voteFourTeamsLabel:SetFont("VoteSelection_Numbers_Font")
	voteFourTeamsLabel:SizeToContents()
	
	local voteButtonSend = vgui.Create("DButton", voteFrame)
	voteButtonSend:SetSize(200, 100)
	voteButtonSend:SetText("Submit Vote")
	voteButtonSend:SetFont("VoteSubmit_Font")
	voteButtonSend:SetPos(voteFrame:GetWide() / 2.6, 750)
	voteButtonSend.DoClick = function(self)
		voteFrame:Close()
		net.Start("SCS_ReceiveClientVote")
			net.WriteTable(LocalPlayer().voteTable)
		net.SendToServer()
	end
end

--Receive the server's broadcast
net.Receive("SCS_Vote", function()
	BeginClientVoting()
	timer.Create("SCS_Vote_ClientTimer", 30, 1, function() if IsValid(voteFrame) then voteFrame:Close()end end)
end)

net.Receive("SCS_EndVote", function()
	if IsValid(voteFrame) then
		voteFrame:Close()
	end
end)


net.Receive("SCS_VotePanic", function()
	Panic()
end)