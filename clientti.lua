local cJ = false
local unjail = false
local JailLocation = {x = 1642.98, y = 2529.96, z = 45.56}
local JailBlip     = {x = 1854.00, y = 2622.00, z = 45.00}


Citizen.CreateThread(function()
	Citizen.Wait(math.random(15000,60000))
	TriggerServerEvent('esx_jailer:checkJail')
end)

RegisterNetEvent("esx_jailer:jail")
AddEventHandler("esx_jailer:jail", function(jailTime)
	if cJ == true then
		return
	end
	local pP = GetPlayerPed(-1)
	if DoesEntityExist(pP) then
		
		Citizen.CreateThread(function()
			local playerOldLoc = GetEntityCoords(pP, true)
			TriggerEvent('skinchanger:getSkin', function(skin)
				if skin.sex == 0 then
					local clothesSkin = {
						['tshirt_1'] = 15, ['tshirt_2'] = 0,
						['torso_1'] = 146, ['torso_2'] = 0,
						['decals_1'] = 0, ['decals_2'] = 0,
						['arms'] = 0,
						['pants_1'] = 3, ['pants_2'] = 7,
						['shoes_1'] = 12, ['shoes_2'] = 12,
						['chain_1'] = 50, ['chain_2'] = 0
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				else
					local clothesSkin = {
						['tshirt_1'] = 3, ['tshirt_2'] = 0,
						['torso_1'] = 38, ['torso_2'] = 3,
						['decals_1'] = 0, ['decals_2'] = 0,
						['arms'] = 2,
						['pants_1'] = 3, ['pants_2'] = 15,
						['shoes_1'] = 66, ['shoes_2'] = 5,
						['chain_1'] = 0, ['chain_2'] = 2
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				end
				local playerPed = GetPlayerPed(-1)
				ClearPedBloodDamage(playerPed)
				ResetPedVisibleDamage(playerPed)
				ClearPedLastWeaponDamage(playerPed)
				ResetPedMovementClipset(playerPed, 0)
			end)
			SetEntityCoords(pP, JailLocation.x, JailLocation.y, JailLocation.z)
			cJ = true
			unjail = false
			while jailTime > 0 and not unjail do
				pP = GetPlayerPed(-1)
				RemoveAllPedWeapons(pP, true)
				SetEntityInvincible(pP, true)
				if IsPedInAnyVehicle(pP, false) then
					ClearPedTasksImmediately(pP)
				end
				if jailTime % 30 == 0 then
					TriggerEvent('chatMessage', 'Tuomari', 'Sinulla on vielä ' .. round(jailTime / 60).. ' päivää edessä ennen vapautusta')
					TriggerServerEvent('esx_jailer:updateRemaining', jailTime)
				end
				Citizen.Wait(500)
				local pL = GetEntityCoords(pP, true)
				local D = Vdist(JailLocation.x, JailLocation.y, JailLocation.z, pL['x'], pL['y'], pL['z'])
				if D > 6 then
					SetEntityCoords(pP, JailLocation.x, JailLocation.y, JailLocation.z)
					TriggerEvent('chatMessage', 'Tuomari', 'Et pysty karkaamaan vankilasta!')
				end
				jailTime = jailTime - 0.5
			end
			-- jail time served
			TriggerServerEvent('esx_jailer:unjailTime', -1)
			SetEntityCoords(pP, JailBlip.x, JailBlip.y, JailBlip.z)
			cJ = false
			SetEntityInvincible(pP, false)
			TriggerEvent('skinchanger:getSkin', function(skin)
				if skin.sex == 0 then
					local clothesSkin = {
						['tshirt_1'] = 15, ['tshirt_2'] = 0,
						['torso_1'] = 146, ['torso_2'] = 0,
						['decals_1'] = 0, ['decals_2'] = 0,
						['arms'] = 0,
						['pants_1'] = 3, ['pants_2'] = 7,
						['shoes_1'] = 12, ['shoes_2'] = 12,
						['chain_1'] = 50, ['chain_2'] = 0
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				else
					local clothesSkin = {
						['tshirt_1'] = 3, ['tshirt_2'] = 0,
						['torso_1'] = 38, ['torso_2'] = 3,
						['decals_1'] = 0, ['decals_2'] = 0,
						['arms'] = 2,
						['pants_1'] = 3, ['pants_2'] = 15,
						['shoes_1'] = 66, ['shoes_2'] = 5,
						['chain_1'] = 0, ['chain_2'] = 2
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				end
			end)
		end)
	end
end)

RegisterNetEvent("esx_jailer:unjail")
AddEventHandler("esx_jailer:unjail", function(source)
	unjail = true
end)



-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(JailBlip.x, JailBlip.y, JailBlip.z)
	SetBlipSprite(blip, 237)
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.8)
	SetBlipColour(blip, 2)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Vankila')
	EndTextCommandSetBlipName(blip)
end)

function round(x)
  return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end