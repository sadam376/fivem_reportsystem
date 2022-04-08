--Functions
function Discord(name, message)
    local embed = {
        {
            ["title"] = "**".. name .."**",
            ["descri    ption"] = message,
        }
    }
    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

--Report
local report = true
local reporters = {}


RegisterCommand(Config.Report, function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	if args[1] then
	reporters[xPlayer.source] = true
        local message = string.sub(rawCommand, 8)
		local xAll = ESX.GetPlayers()
		for i = 1, #xAll, 1 do
			local xTarget = ESX.GetPlayerFromId(xAll[i])
			if xTarget.getGroup() ~= "user" then
				if xPlayer.source ~= xTarget.source then
                    if report == true then
                        TriggerClientEvent('chat:addMessage',  xTarget.source,  {template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #ff0000; border-radius: 10px;"><i class="fas fa-question-circle" style="font-size: medium;"></i>  <span style="font-weight: 600;">Jelentés tőle: <span style="color: red; font-weight:600 ;">'..GetPlayerName(xPlayer.source)..'</span> (^3'..xPlayer.source..'^0) (^3'..xPlayer.getName()..'^0)  <span style="font-weight: 600;">  <br><i class="fas fa-comment-dots"></i> Üzenet: </span> <span style="color: #ff9100;">'..message..'</span></div>', }) 
                    end
				end
			end
		end
        Discord("Új jelentés", "``"..GetPlayerName(xPlayer.source).." ("..xPlayer.source..")`` segítséget kért!```Üzenet: "..message.."```")
		TriggerClientEvent("chat:addMessage", xPlayer.source, {template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw;  background-color:#2b2b2b; border: 2.2px solid #00ffa6; border-radius: 10px;"><i class="fas fa-info-circle" style="font-size: medium;"></i>  <span style="font-weight: 600; color: #00ffa6;">Sikeresen</span> elküldted jelentésed! (Üzeneted: ^3'.. message..'^0)</div>',})
	else
		TriggerClientEvent("chat:addMessage", xPlayer.source, {template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw;  background-color:#2b2b2b; border: 2.2px solid #c20000; border-radius: 10px;"><i class="fas fa-exclamation-circle" style="font-size: medium;"></i> <span style="color: white;"><span style="font-weight:600 ; color: red;">Sikertelen</span> segítségkérés! <span style="font-weight:600 ;">Hiba:</span> <span style="color: orange;">Helytelen használat</span></div>',})
	end
end, false)

--Toggle report
RegisterCommand(Config.ToggleReport, function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getGroup() ~= "user" then
		if report  then
			report = false
			TriggerClientEvent("chat:addMessage", xPlayer.source, {template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw;  background-color:#2b2b2b; border: 2.2px solid #c20000; border-radius: 10px;"><i class="fas fa-comment-slash" style="font-size: medium;"></i> <span style="color: white;"> A jelentések láthatósága: <span style="font-weight:600 ; color: red;">kikapcsolva</span></div>',})
		else
			report = true
			TriggerClientEvent("chat:addMessage", xPlayer.source, {template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw;  background-color:#2b2b2b; border: 2.2px solid #00d62e; border-radius: 10px;"><i class="fas fa-comment-dots" style="font-size: medium;"></i> <span style="color: white;"> A jelentések láthatósága: <span style="font-weight:600 ; color: #00d62e;">bekapcsolva</span></div>',})
		end
	end
end)

--Reply
RegisterCommand(Config.Reply, function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(args[1])
	local message = string.sub(rawCommand, 7)
	local xAll = ESX.GetPlayers()
    
	if xPlayer.getGroup() ~= "user" then
		if args[1] then
			if args[2] then
				if reporters[xTarget.source] then
					TriggerClientEvent("chat:addMessage", xTarget.source, {template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #00ddff; border-radius: 10px;"><i class="fas fa-envelope" style="font-size: medium;"></i> <span style="color: #00ddff; font-weight:600 ;">'.. GetPlayerName(xPlayer.source).. "</span> (^3".. xPlayer.source.. '^0) válaszolt  a jelentésedre.  <span style="font-weight: 600;">Válasz:</span> <span style="color: orange; font-weight:600 ;">'.. message.. "</span></div>",})
					TriggerClientEvent("chat:addMessage", xPlayer.source, {template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #00ddff; border-radius: 10px;"><i class="fas fa-envelope" style="font-size: medium;"></i> Sikeresen válaszoltál <span style="color: #00ddff; font-weight:600 ;">'.. GetPlayerName(xTarget.source).. "</span> (^3".. xTarget.source.. '^0) jelentésére.  <span style="font-weight: 600;">Válaszod:</span> <span style="color: orange; font-weight:600 ;">'.. message.. "</span></div>",})
                    Discord("Admin válasz", "``"..GetPlayerName(xPlayer.source).." ("..xPlayer.source..")`` Admin válaszolt ``"..GetPlayerName(xTarget.source).." ("..xTarget.source..")`` jelentésére! ```Üzenet: "..message.."```")

					for i = 1, #xAll, 1 do
						local Admins = ESX.GetPlayerFromId(xAll[i])
						if Admins.getGroup() ~= "user" then
							if xPlayer.source ~= xTarget.source then
								if report == true then
                                    TriggerClientEvent("chat:addMessage", Admins.source, { template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #00d62e; border-radius: 10px;"><i class="fas fa-user-edit" style="font-size: medium;"></i> <span style="color: #00ff48; font-weight:600 ;">'.. GetPlayerName(xPlayer.source).. "</span> (^3".. xPlayer.source .. '^0) válaszolt  <span style="color: #00aaff; font-weight:600 ;">'.. GetPlayerName(xTarget.source).. "</span> (^3".. xTarget.source.. '^0) jelentésére.   (Válasza: <span style="color: orange; font-weight:600 ;">'.. message.. "</span>)</div>",})
								end
							end
						end
					end
				else
					TriggerClientEvent("chat:addMessage", xPlayer.source, {template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #c20000; border-radius: 10px;"><i class="fas fa-exclamation-circle" style="font-size: medium;"></i> <span style="color: white;"><span style="font-weight:600 ; color: red;">Sikertelen</span> válasz! <span style="font-weight:600 ;">Hiba:</span> <span style="color: orange;">A játékos nem kért segítséget</span></div>',})
				end
			else
				TriggerClientEvent("chat:addMessage", xPlayer.source, {template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw;  background-color:#2b2b2b; border: 2.2px solid #c20000; border-radius: 10px;"><i class="fas fa-exclamation-circle" style="font-size: medium;"></i> <span style="color: white;"><span style="font-weight:600 ; color: red;">Sikertelen</span> válasz! <span style="font-weight:600 ;">Hiba:</span> <span style="color: orange;">Az üzenet nincsen megadva</span></div>',})
			end
		else
			TriggerClientEvent("chat:addMessage", xPlayer.source, {template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #c20000; border-radius: 10px;"><i class="fas fa-exclamation-circle" style="font-size: medium;"></i> <span style="color: white;"><span style="font-weight:600 ; color: red;">Sikertelen</span> válasz! <span style="font-weight:600 ;">Hiba:</span> <span style="color: orange;">A játékos (ID) nincsen megadva</span></div>',})
		end
	end
end)


--Report close
RegisterCommand(Config.CloseReport, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(args[1])
    local xAll = ESX.GetPlayers()
    if args[1] then
        if  reporters[xTarget.source] then
            reporters[xTarget.source] = false
            TriggerClientEvent('chat:addMessage',  xTarget.source,  {template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #00ddff; border-radius: 10px;"><i class="fas fa-envelope" style="font-size: medium;"></i> <span style="color: #00ddff; font-weight:600 ;">'..GetPlayerName(xPlayer.source)..'</span> (^3'..xPlayer.source..'^0) bezárta a jelentésedet.</div>', }) 
            TriggerClientEvent('chat:addMessage',  xPlayer.source,  {template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #00ddff; border-radius: 10px;"><i class="fas fa-envelope" style="font-size: medium;"></i> <span style="color: #00ddff; font-weight:600 ;">'..GetPlayerName(xTarget.source)..'</span> (^3'..xTarget.source..'^0) játékos jelentése be lett zárva.</div>', }) 
            Discord("Jelentés bezárása", "``"..GetPlayerName(xPlayer.source).." ("..xPlayer.source..")`` bezárta ``"..GetPlayerName(xTarget.source).." ("..xTarget.source..")`` jelentését!")
            for i=1, #xAll, 1 do
                local Admins = ESX.GetPlayerFromId(xAll[i])
                if Admins.getGroup() ~= "user" then
                    if xPlayer.source ~= xTarget.source then
                        TriggerClientEvent('chat:addMessage',  Admins.source,  {template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #00d62e; border-radius: 10px;"><i class="fas fa-user-edit" style="font-size: medium;"></i> <span style="color: #00ff48; font-weight:600 ;">'..GetPlayerName(xPlayer.source)..'</span> (^3'..xPlayer.source..'^0) bezárta  <span style="color: #00aaff; font-weight:600 ;">'..GetPlayerName(xTarget.source)..'</span> (^3'..xTarget.source..'^0) jelentését.</div>', })
                    end
                end
            end
        else
            TriggerClientEvent('chat:addMessage',  xPlayer.source,  {template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #c20000; border-radius: 10px;"><i class="fas fa-exclamation-circle" style="font-size: medium;"></i> <span style="color: white;"><span style="font-weight:600 ; color: red;">Sikertelen</span> bezárás! <span style="font-weight:600 ;">Hiba:</span> <span style="color: orange;">Ez a játékos nem kért segítséget</span></div>', }) 
        end
    else
        TriggerClientEvent('chat:addMessage',  xPlayer.source,  {template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #c20000; border-radius: 10px;"><i class="fas fa-exclamation-circle" style="font-size: medium;"></i> <span style="color: white;"><span style="font-weight:600 ; color: red;">Sikertelen</span> bezárás! <span style="font-weight:600 ;">Hiba:</span> <span style="color: orange;">A játékos (ID) nincsen megadva</span></div>', }) 
    end
end)