Config = {}

notify = function(data)	
	lib.notify({                              --ex -- notify({des = '',status =''})
		title = 'Nexus Roleplay',
		description = data.des,
    type = data.status,
		position = 'top',
    duration = 6000,
		
	})
end

/* Trigger ped */
Config.npc_Ped = {
    model = 's_m_m_highsec_01',
    scenario = 'WORLD_HUMAN_GUARD_STAND',
    location = vector3(792.2132, 538.1448, 124.9203),
    heading =  173.9453,
    distance = 40.0,
    target_label = 'Get Hostage for 10,000',
	target_icon = 'fa-solid fa-user',
}

Config.npcModels = {
    's_m_m_prisguard_01', 
    's_m_m_security_01',
    's_m_y_swat_01'
}

Config.takeHostageDistance = 2.0

Config.gethostage_item = 'black_money'
Config.gethostage_item_count = 5000     
Config.gethostage_cooldown = 10
Config.hostage_npc_loc = vector4(793.3670, 537.5455, 125.9203, 133.4089)

Config.DiscordWebhook = ''

Config.Webhooks = {
    Locale = {
        ['robberyProcess'] = '⌛ Robbery started...',
        ['robberyFinished'] = '✅ NPC Created',
        ['robberyCanceled'] = '❌ Robbery Canceled..',
    },

    -- To change a webhook color you need to set the decimal value of a color, you can use this website to do that - https://www.mathsisfun.com/hexadecimal-decimal-colors.html
    Colors = {
        ['robberyProcess'] = 3145631, 
        ['robberyFinished'] = 3093151,
        ['robberyCanceled'] = 16711680,
    }
}