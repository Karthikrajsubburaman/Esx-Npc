ESX = exports["es_extended"]:getSharedObject()

local onCooldown = {}

lib.callback.register('NX_npchostage:spawnnpc', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cid = xPlayer.identifier
    
    if (onCooldown[cid] == nil) or ((os.time() - onCooldown[cid]) > Config.gethostage_cooldown * 60) then
        

        if exports.ox_inventory:GetItem(source, Config.gethostage_item, nil, true) >= Config.gethostage_item_count then
            
            exports.ox_inventory:RemoveItem(source, Config.gethostage_item, Config.gethostage_item_count)

            onCooldown[cid] = os.time()
            SendToDiscord(source,'robberyFinished')
            return true
        else
            
            TriggerClientEvent('ox_lib:notify', source, {type = 'inform', title = 'NPC Spawner', position = 'top',description = 'You do not have the required item to spawn NPCs.'})
            return false
        end
    else
        TriggerClientEvent('ox_lib:notify', source, {type = 'inform', title = 'NPC Spawner', position = 'top',description = 'NPC spawning is on cooldown.'})
        return false
    end
    
end)





SendToDiscord = function(sourceid,TYPE)  -- robberyProcess  robberyFinished

	local source = ESX.GetPlayerFromId(sourceid)
    local source_discord = GetPlayerIdentifierByType(sourceid, 'discord')
	local source_discord_id = source_discord:gsub("discord:", "")
	local source_license = GetPlayerIdentifierByType(sourceid, 'license')
	local source_license_id = source_license:gsub("license:", "")
	
	local String_format = '\n\n**Player Information:**\nName: %s\nIdentifier: %s```%s```\nDiscord: <@%s>```%s```\nLicense: `%s`'
	local message = String_format:format(source.getName(), GetPlayerName(sourceid), source.identifier,source_discord_id,source_discord_id,source_license_id)
	local embed = {
		{
            ["color"] = Config.Webhooks.Colors[TYPE],
            ["author"] = {
                ["icon_url"] = 'https://cdn.discordapp.com/attachments/1019968751619293194/1192369234622300281/NX_gold.png',
                ["name"] = 'Nexus NPC Spawn - Logs',
            },
			["title"] = '**'.. Config.Webhooks.Locale[TYPE] ..'**',
			["description"] = message,
            ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S'),
		    ["footer"] = {
		        ["text"] = "Chan Scripts",
                ["icon_url"] = 'https://cdn.discordapp.com/attachments/1112335008678563960/1112383696771756113/1.png'
		    },
		}
	}
	PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({username = "Nexus Log", embeds = embed}), { ['Content-Type'] = 'application/json' })
end