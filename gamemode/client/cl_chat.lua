surface.CreateFont( "SCS_ChatFont", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 26,
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
	outline = false,
} )

surface.CreateFont( "SCS_ChatTypingFont", {
	font = "Arial", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 26,
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
	outline = false,
} )
--[[
local rtBox = nil
local isOpen = false
local messages = messages or ""
local notifyRTBox = nil

function ChatNotify()
	if isOpen then return end
	surface.PlaySound("ui/buttonrollover.wav")
	
	local notifyFrame = vgui.Create("DNotify")
	notifyFrame:SetPos(15, ScrH() / 2)
	notifyFrame:SetSize(450, 500)

	local notifyRTBox = vgui.Create("DLabel", notifyFrame)
	notifyRTBox:SetPos(15, 0)
	notifyRTBox:SetSize(450, 100)
	notifyRTBox:SetFont("SCS_ChatFont")
	notifyRTBox:SetText(messages)
	notifyRTBox:SizeToContents()

	notifyFrame:AddItem(notifyRTBox, 6)
end

function OpenChat(chatMessages)
	isOpen = true
	local chatFrame = vgui.Create("DFrame")
	chatFrame:SetSize(950, 500)
	chatFrame:SetPos(0, ScrH() / 2)
	chatFrame:MakePopup()
	chatFrame:SetTitle("")
	chatFrame:SetDraggable(false)
	chatFrame:ShowCloseButton(false)
	chatFrame.OnClose = function(self)
		self:Remove()
		isOpen = false
	end
	chatFrame.Paint = function() return end
	
	local chatPanel = vgui.Create("DPanel", chatFrame)
	chatPanel:SetSize(850, 500)
	
	chatPanel.Paint = function(self, w, h)
		surface.SetDrawColor(Color(0, 0, 0, 175))
		surface.DrawRect(0, 0, w, h)
	end
		
	rtBox = vgui.Create("DLabel", chatPanel)
	rtBox:SetPos(0, ScrH() / 2)
	rtBox:SetSize(450, 400)
	rtBox:SetFont("SCS_ChatFont")
	rtBox:SetText(chatMessages)
	rtBox:SizeToContents()
	
	local chatEntry = vgui.Create("DTextEntry", chatFrame)
	chatEntry:SetPos(15, 400)
	chatEntry:SetSize(450, 65)
	chatEntry:RequestFocus()
	chatEntry:SetCursorColor(Color(30, 30, 30, 255))
	chatEntry:SetFont("SCS_ChatTypingFont")
	chatEntry.OnEnter = function(self)
		if self:GetText() != "" then
			net.Start("SCS_ChatSendMessage")
				net.WriteString(self:GetText())
			net.SendToServer()
			self:SetText("")
		end
		chatFrame:Close()
	end
	
	local chatScrollPanel = vgui.Create("DScrollPanel", chatFrame)
	chatScrollPanel:Dock(FILL)
	chatScrollPanel:AddItem(chatPanel)
	
end

hook.Add( "HUDShouldDraw", "RemoveDefaultChat", function( name )
	if name == "CHudChat" then
		return false
	end
end)

net.Receive("SCS_ChatReceiveMessage", function()
	local chatMsg = net.ReadString()
	local sender = net.ReadEntity()
	
	messages = messages .. "\n" ..sender:Name() .. ": " .. chatMsg
	if isOpen then
		rtBox:SetText(messages)
		rtBox:SizeToContents()
	else
		ChatNotify()
	end
end)

hook.Add( "PlayerBindPress", "SCSOverrideChat", function( ply, bind, pressed )
	if bind == "messagemode" and not isOpen then
		OpenChat(messages)
		return true
	elseif isOpen then
		return false
	end
	
	return
end)

==]]