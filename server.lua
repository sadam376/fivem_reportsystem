local reporters = {}
local report = true

RegisterCommand(Config.ReportCommand, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    reporters[xPlayer.source] = true
    if args[1] then
        local message = string.sub(rawCommand, 8)
        local xAll = ESX.GetPlayers()
        for i=1, #xAll, 1 do
            local xTarget = ESX.GetPlayerFromId(xAll[i])
            if xTarget.getGroup() ~= "user" then
                if xPlayer.source ~= xTarget.source then
                    if report == true then
                        TriggerClientEvent('chat:addMessage',  xTarget.source,  {
                            template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #ff0000; border-radius: 10px;"><i class="fas fa-question-circle" style="font-size: medium;"></i>  <span style="font-weight: 600;">Jelentés tőle: <span style="color: red; font-weight:600 ;">'..GetPlayerName(xPlayer.source)..'</span> (^3'..xPlayer.source..'^0) (^3'..xPlayer.getName()..'^0)  <span style="font-weight: 600;">  <br><i class="fas fa-comment-dots"></i> Üzenet: </span> <span style="color: #ff9100;">'..message..'</span></div>', 
                            args = { playerName, args, source }
                        }) 
                    end
                end
            end
        end
        TriggerClientEvent('chat:addMessage',  xPlayer.source,  {
            template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw;  background-color:#2b2b2b; border: 2.2px solid #00ffa6; border-radius: 10px;"><i class="fas fa-info-circle" style="font-size: medium;"></i>  <span style="font-weight: 600; color: #00ffa6;">Sikeresen</span> elküldted a segítségkérést! (^3'..message..'^0)</div>', 
            args = { playerName, args, source }
        }) 
    else
        TriggerClientEvent('chat:addMessage',  xPlayer.source,  {
            template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw;  background-color:#2b2b2b; border: 2.2px solid #c20000; border-radius: 10px;"><i class="fas fa-exclamation-circle" style="font-size: medium;"></i> <span style="color: white;"><span style="font-weight:600 ; color: red;">Sikertelen</span> segítségkérés! <span style="font-weight:600 ;">Hiba:</span> <span style="color: orange;">Helytelen használat</span></div>', 
            args = { playerName, args, source }
        }) 
    end
end,false)


RegisterCommand(Config.ToggleReport, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        if report == true then
            report = false
            TriggerClientEvent('chat:addMessage',  xPlayer.source,  {
                template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw;  background-color:#2b2b2b; border: 2.2px solid #c20000; border-radius: 10px;"><i class="fas fa-comment-slash" style="font-size: medium;"></i> <span style="color: white;"> A jelentések láthatósága: <span style="font-weight:600 ; color: red;">kikapcsolva</span></div>', 
                args = { playerName, args, source }
            }) 
        else
            report = true
            TriggerClientEvent('chat:addMessage',  xPlayer.source,  {
                template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw;  background-color:#2b2b2b; border: 2.2px solid #00d62e; border-radius: 10px;"><i class="fas fa-comment-dots" style="font-size: medium;"></i> <span style="color: white;"> A jelentések láthatósága: <span style="font-weight:600 ; color: #00d62e;">bekapcsolva</span></div>', 
                args = { playerName, args, source }
            }) 
        end
    end
end)

RegisterCommand(Config.ReplyCommand, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(args[1])
    local message = string.sub(rawCommand, 5)
    local xAll = ESX.GetPlayers()

    if xPlayer.getGroup() ~= 'user' then
        if args[1] then
            if args[2] then 
                if reporters[xTarget.source] then

                    --Player
                    TriggerClientEvent('chat:addMessage',  xTarget.source,  {
                        template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #00ddff; border-radius: 10px;"><i class="fas fa-envelope" style="font-size: medium;"></i> <span style="color: #00ddff; font-weight:600 ;">'..GetPlayerName(xPlayer.source)..'</span> (^3'..xPlayer.source..'^0) válaszolt  a jelentésedre.  <span style="font-weight: 600;">Válasz:</span> <span style="color: orange; font-weight:600 ;">'..message..'</span></div>', 
                        args = { playerName, args, source }
                    }) 

                    --Admin
                    if Config.ShowReplyMessageForAdmin then
                        TriggerClientEvent('chat:addMessage',  xPlayer.source,  {
                            template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #00ddff; border-radius: 10px;"><i class="fas fa-envelope" style="font-size: medium;"></i> Sikeresen válaszoltál <span style="color: #00ddff; font-weight:600 ;">'..GetPlayerName(xTarget.source)..'</span> (^3'..xTarget.source..'^0) jelentésére.  <span style="font-weight: 600;">Válaszod:</span> <span style="color: orange; font-weight:600 ;">'..message..'</span></div>', 
                            args = { playerName, args, source }
                        }) 
                    else
                        TriggerClientEvent('chat:addMessage',  xPlayer.source,  {
                            template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #00d62e; border-radius: 10px;"><i class="fas fa-envelope" style="font-size: medium;"></i> Sikeresen válaszoltál <span style="color: #00ddff; font-weight:600 ;">'..GetPlayerName(xTarget.source)..'</span> (^3'..xTarget.source..'^0) jelentésére.</div>', 
                            args = { playerName, args, source }
                        }) 
                    end

                    for i=1, #xAll, 1 do
                        local Admins = ESX.GetPlayerFromId(xAll[i])
                        if Admins.getGroup() ~= "user" then
                            if xPlayer.source ~= xTarget.source then
                                if report == true then
                                    if Config.ShowReplyMessageForAdmins then
                                        TriggerClientEvent('chat:addMessage',  Admins.source,  {
                                            template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; width: 450px; background-color:#2b2b2b; border: 2.2px solid #00d62e; border-radius: 10px;"><i class="fas fa-user-edit" style="font-size: medium;"></i> <span style="color: #00ff48; font-weight:600 ;">'..GetPlayerName(xPlayer.source)..'</span> (^3'..xPlayer.source..'^0) válaszolt  <span style="color: #00aaff; font-weight:600 ;">'..GetPlayerName(xTarget.source)..'</span> (^3'..xTarget.source..'^0) jelentésére.   (Válasza: <span style="color: orange; font-weight:600 ;">'..message..'</span>)</div>', 
                                            args = { playerName, args, source }
                                        })
                                    else
                                        TriggerClientEvent('chat:addMessage',  Admins.source,  {
                                            template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #00d62e; border-radius: 10px;"><i class="fas fa-user-edit" style="font-size: medium;"></i> <span style="color: #00ff48; font-weight:600 ;">'..GetPlayerName(xPlayer.source)..'</span> (^3'..xPlayer.source..'^0) válaszolt  <span style="color: #00aaff; font-weight:600 ;">'..GetPlayerName(xTarget.source)..'</span> (^3'..xTarget.source..'^0) jelentésére.</div>', 
                                            args = { playerName, args, source }
                                        })
                                    end 
                                end
                            end
                        end
                    end
                else
                    TriggerClientEvent('chat:addMessage',  xPlayer.source,  {
                        template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #c20000; border-radius: 10px;"><i class="fas fa-exclamation-circle" style="font-size: medium;"></i> <span style="color: white;"><span style="font-weight:600 ; color: red;">Sikertelen</span> válasz! <span style="font-weight:600 ;">Hiba:</span> <span style="color: orange;">A játékos nem kért segítséget</span></div>', 
                        args = { playerName, args, source }
                    }) 
                end
            else
                TriggerClientEvent('chat:addMessage',  xPlayer.source,  {
                    template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw;  background-color:#2b2b2b; border: 2.2px solid #c20000; border-radius: 10px;"><i class="fas fa-exclamation-circle" style="font-size: medium;"></i> <span style="color: white;"><span style="font-weight:600 ; color: red;">Sikertelen</span> válasz! <span style="font-weight:600 ;">Hiba:</span> <span style="color: orange;">Az üzenet nincsen megadva</span></div>', 
                    args = { playerName, args, source }
                }) 
            end
        else

            TriggerClientEvent('chat:addMessage',  xPlayer.source,  {
                template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #c20000; border-radius: 10px;"><i class="fas fa-exclamation-circle" style="font-size: medium;"></i> <span style="color: white;"><span style="font-weight:600 ; color: red;">Sikertelen</span> válasz! <span style="font-weight:600 ;">Hiba:</span> <span style="color: orange;">A játékos (ID) nincsen megadva</span></div>', 
                args = { playerName, args, source }
            }) 
        end
    end
end)


RegisterCommand("reportclose", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(args[1])
    if args[1] then
        reporters[xTarget.source] = false
        TriggerClientEvent('chat:addMessage',  xTarget.source,  {
            template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #00ddff; border-radius: 10px;"><i class="fas fa-envelope" style="font-size: medium;"></i> <span style="color: #00ddff; font-weight:600 ;">'..GetPlayerName(xPlayer.source)..'</span> (^3'..xPlayer.source..'^0) válaszolt  a jelentésedre.  <span style="font-weight: 600;">Válasz:</span> <span style="color: orange; font-weight:600 ;">'..message..'</span></div>', 
            args = { playerName, args, source }
        }) 
        TriggerClientEvent('chat:addMessage',  xPlayer.source,  {
            template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #00ddff; border-radius: 10px;"><i class="fas fa-envelope" style="font-size: medium;"></i> <span style="color: #00ddff; font-weight:600 ;">'..GetPlayerName(xPlayer.source)..'</span> (^3'..xPlayer.source..'^0) válaszolt  a jelentésedre.  <span style="font-weight: 600;">Válasz:</span> <span style="color: orange; font-weight:600 ;">'..message..'</span></div>', 
            args = { playerName, args, source }
        }) 
    else
        TriggerClientEvent('chat:addMessage',  xPlayer.source,  {
            template = '<div style="padding: 0.4vw 0.5vw; font-size: 15px; margin: 0.5vw; background-color:#2b2b2b; border: 2.2px solid #c20000; border-radius: 10px;"><i class="fas fa-exclamation-circle" style="font-size: medium;"></i> <span style="color: white;"><span style="font-weight:600 ; color: red;">Sikertelen</span> válasz! <span style="font-weight:600 ;">Hiba:</span> <span style="color: orange;">A játékos (ID) nincsen megadva</span></div>', 
            args = { playerName, args, source }
        }) 
     end
end)
