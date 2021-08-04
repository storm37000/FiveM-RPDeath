RegisterCommand("respawn", function(source, args)
	TriggerClientEvent('RPD:allowRespawn', source)
end)
RegisterCommand("toggleDeath", function(source, args)
	TriggerClientEvent('RPD:toggleDeath', source)
end)
RegisterCommand("revive", function(from, args)
	if (args[1] ~= nil and IsPlayerAceAllowed(from, "reviveothers")) then
		local playerID = tonumber(args[1])

		if(playerID == nil or playerID == 0 or GetPlayerName(playerID) == nil) then
			TriggerClientEvent('chatMessage', from, "RPDeath", {200,0,0} , "Invalid PlayerID")
			return
		end

		TriggerClientEvent('RPD:allowRevive', playerID, from)

		TriggerClientEvent('chatMessage', from, "RPDeath", {200,0,0} , "Player revived")
	else
		TriggerClientEvent('RPD:allowRevive', from, from)
	end
end)