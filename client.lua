RegisterNetEvent('RPD:allowRespawn')
RegisterNetEvent('RPD:allowRevive') 
RegisterNetEvent('RPD:toggleDeath')

--local reviveWaitPeriod = 1 -- How many seconds to wait before allowing player to revive themselves
local RPDeathEnabled = true  -- Is RPDeath enabled by default? (/toggleDeath changes this value.)

local function ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end


-- Turn off automatic respawn here instead of updating FiveM file.
AddEventHandler('onClientMapStart', function()
	Citizen.Trace("RPDeath: Disabling autospawn...")
	--exports.spawnmanager:spawnPlayer() -- Ensure player spawns into server.
	Citizen.Wait(2500)
	exports.spawnmanager:setAutoSpawn(false)
	Citizen.Trace("RPDeath: Autospawn disabled!")
end)


local allowRespawn = false
local allowRevive = false
--local diedTime = nil
local notif = false


AddEventHandler('RPD:allowRespawn', function(from)
	ShowNotification("Respawned")
	allowRespawn = true
end)


AddEventHandler('RPD:allowRevive', function(from)
	if(not IsEntityDead(GetPlayerPed(-1)))then
		-- You are alive, do nothing.
		return
	end

	-- Trying to revive themselves?
--	if(GetPlayerServerId(PlayerId()) == from and diedTime ~= nil)then
--		local waitPeriod = diedTime + (reviveWaitPeriod * 1000)
--		if(GetGameTimer() < waitPeriod)then
--			local seconds = math.ceil((waitPeriod - GetGameTimer()) / 1000)
--			local message = ""
--			if(seconds > 60)then
--				local minutes = math.floor((seconds / 60))
--				seconds = math.ceil(seconds-(minutes*60))
--				message = minutes.." minutes "
--			end
--			message = message..seconds.." seconds"
--			TriggerEvent('chatMessage', "RPDeath", {200,0,0}, "You must wait before reviving yourself, you have ^5"..message.."^0 remaining.")
--			return		
--		end
--	end

	-- Revive the player.
	ShowNotification("Revived")
	allowRevive = true
end)

AddEventHandler('RPD:toggleDeath', function(from)
	RPDeathEnabled = not RPDeathEnabled
	if (RPDeathEnabled) then
		TriggerEvent('chatMessage', "RPDeath", {200,0,0}, "RPDeath enabled.")
	else
		TriggerEvent('chatMessage', "RPDeath", {200,0,0}, "RPDeath disabled.")
		allowRespawn = false
		allowRevive = false
		notif = false
	end
end)


local function revivePed(ped)
	local playerPos = GetEntityCoords(ped, true)

	NetworkResurrectLocalPlayer(playerPos, true, true, false)
	SetPlayerInvincible(ped, false)
	ClearPedBloodDamage(ped)
end

--local respawnCount = 0

--createSpawnPoint(-448, -448, -340, -329, 35.5, 0) -- Mount Zonah
--createSpawnPoint(372, 375, -596, -594, 30.0, 0)   -- Pillbox Hill
--createSpawnPoint(335, 340, -1400, -1390, 34.0, 0) -- Central Los Santos
--createSpawnPoint(1850, 1854, 3700, 3704, 35.0, 0) -- Sandy Shores
--createSpawnPoint(-247, -245, 6328, 6332, 33.5, 0) -- Paleto
--createSpawnPoint(1152, 1156, -1525, -1521, 34.9, 0) -- St. Fiacre

Citizen.CreateThread(function()
	local playerIndex = NetworkGetPlayerIndex(-1) or 0

	while true do
		Wait(500)
		local ped = GetPlayerPed(-1)
		
		if (RPDeathEnabled) then

			if (IsEntityDead(ped)) then
				--if(diedTime == nil)then
				--	diedTime = GetGameTimer()
				--end

				SetPlayerInvincible(ped, true)
				SetEntityHealth(ped, 1)

				if not notif then
					notif = true
					Citizen.CreateThread(function()
						while IsEntityDead(GetPlayerPed(-1)) do
							ShowNotification("You are dead, say /revive to respawn at your death location, or say /respawn to respawn elsewhere.")
							Wait(5000)
						end
					end)
				end
				
				if (allowRespawn) then
					notif = false
					exports.spawnmanager:spawnPlayer()
			  		allowRespawn = false
			  		--diedTime = nil
					--respawnCount = respawnCount + 1

				elseif (allowRevive) then
					notif = false
					revivePed(ped)
					allowRevive = false	
		  			--diedTime = nil
				end
--			else
--		  		allowRespawn = false
--		  		allowRevive = false	
		  		--diedTime = nil		
--				Wait(0)
			end
		end
	end
end)