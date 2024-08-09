ESX = exports["es_extended"]:getSharedObject()

local DraggedPlayerped
local isDragged = false

Surrender = function(data)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local npc_Coords = GetEntityCoords(data.entity)
    
    local npc_distance = #(playerCoords - npc_Coords)
    if npc_distance <= Config.takeHostageDistance then
        ClearPedSecondaryTask(data.entity)
        DetachEntity(data.entity, true, false)
        RequestAnimDict("random@arrests@busted")
        while not HasAnimDictLoaded("random@arrests@busted") do
            Citizen.Wait(100)
        end
        TaskPlayAnim(data.entity, 'random@arrests@busted', 'idle_a', 2.0, 2.0,-1, 1, 0, false, false, false)
        FreezeEntityPosition(data.entity, true) 
    else
        notify({des = 'Target NPC is too far away.', status ='error'}) 
    end
end

Surrender5 = function(data)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local npc_Coords = GetEntityCoords(data.entity)
    
    local npc_distance = #(playerCoords - npc_Coords)
    if npc_distance <= Config.takeHostageDistance then
        ClearPedSecondaryTask(data.entity)
        DetachEntity(data.entity, true, false)
        RequestAnimDict("random@arrests")
        while not HasAnimDictLoaded("random@arrests") do
            Citizen.Wait(100)
        end
        TaskPlayAnim(data.entity, 'random@arrests', 'kneeling_arrest_idle', 2.0, 2.0,-1, 1, 0, false, false, false)
        FreezeEntityPosition(data.entity, true) 
    else
        notify({des = 'Target NPC is too far away.', status ='error'}) 
    end
end

releaseHostage = function()
    local playerPed = PlayerPedId()
    local targetPed = DraggedPlayerped
    if IsEntityAttachedToEntity(playerPed,targetPed) then
        ClearPedSecondaryTask(playerPed)
        DetachEntity(targetPed, true, false)
        RequestAnimDict("reaction@shove")
        while not HasAnimDictLoaded("reaction@shove") do
            Citizen.Wait(100)
        end
        TaskPlayAnim(targetPed, "reaction@shove", "shoved_back", 8.0, -8.0, -1, 0, 0, false, false, false)
        TaskPlayAnim(playerPed, "reaction@shove", "shove_var_a", 8.0, -8.0, -1, 168, 0, false, false, false)
        Wait(1000)
        ClearPedSecondaryTask(targetPed)
        lib.requestAnimDict('missminuteman_1ig_2', 1000)
        TaskPlayAnim(targetPed, 'missminuteman_1ig_2', 'handsup_base', 8.0, 8.0, -1, 1, 0, false, false, false)
        SetBlockingOfNonTemporaryEvents(npc, true)
    end
end

releasefully = function(data)
    local playerPed = PlayerPedId()
    local targetPed = data.entity
    if not IsEntityAttached(targetPed) then
        FreezeEntityPosition(targetPed, false) 
        ClearPedTasksImmediately(targetPed) 
        ClearPedTasks(targetPed)
        SetBlockingOfNonTemporaryEvents(targetPed, false)
        --DetachEntity(targetPed, true, false)
        --ClearPedSecondaryTask(targetPed)
        Wait(500)
        lib.requestAnimDict('missminuteman_1ig_2', 1000)
        TaskPlayAnim(targetPed, 'missminuteman_1ig_2', 'handsup_base', 8.0, 8.0, -1, 50, 0, false, false, false)
    end
end

takeHostage = function(data)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local targetPed = data.entity
    local npc_Coords = GetEntityCoords(data.entity)
    
    local npc_distance = #(playerCoords - npc_Coords)
    if npc_distance <= Config.takeHostageDistance then
        if IsPedArmed(playerPed,4) then
            RequestAnimDict("anim@gangops@hostage@")
            while not HasAnimDictLoaded("anim@gangops@hostage@") do
                Citizen.Wait(100)
            end
            isDragged = true
            FreezeEntityPosition(data.entity, false) 
            AttachEntityToEntity(targetPed, playerPed, 11816, -0.3, 0.1, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 1, true)
            Citizen.CreateThread(function()
                while isDragged do
                    if DoesEntityExist(targetPed) and not IsPedDeadOrDying(cache.ped, true) then
                        
                        if not IsEntityPlayingAnim(targetPed, 'anim@gangops@hostage@', 'victim_idle',1) then 
                            TaskPlayAnim(targetPed, 'anim@gangops@hostage@', 'victim_idle', 2.0, 2.0, -1, 1, 0, false, false, false)
                        end
                        if not IsEntityPlayingAnim(playerPed, "anim@gangops@hostage@", "perp_idle",51) then
                            TaskPlayAnim(playerPed, "anim@gangops@hostage@", "perp_idle", 8.0, -8.0, -1, 51, 0, false, false, false)
                        end
                    else
                        DetachEntity(cache.ped, true, false)
                        isDragged = false
                        DraggedPlayerped = 0
                        lib.hideTextUI()
                    end
                    Wait(10)
                end
            end)            
            --SetBlockingOfNonTemporaryEvents(targetPed, true)
            --SetEntityInvincible(targetPed, true)
            DraggedPlayerped = data.entity
		    
		    lib.showTextUI('[G] - Release From gun point')
        else
            notify({des = 'You need to equip a Weapon to take a hostage.', status ='error'})
        end
    else
        notify({des = 'Target NPC is too far away.', status ='error'}) 
    end
end
lib.addKeybind({
    name = 'NPC_Hostage_undrag',
    description = 'Release Hostage',
    defaultKey = 'G',
    onPressed = function(self)
        if not isDragged then return end 
        isDragged = false
        releaseHostage()
		DraggedPlayerped = 0
		
        lib.hideTextUI()
    end,
})
NPC_hostage_menu = function(data)
    lib.registerContext({
        id = 'npc_hostage_menu',
        title = 'NPC Interact',
        options = {
            {
                title = 'Surrender',
                icon = 'fa-solid fa-person-praying',
                iconColor = '#da0101',
                description = 'SURRENDER',
                onSelect = function()
                    Surrender(data)
                end
            },
            {
                title = 'Surrender 5',
                icon = 'fa-solid fa-person-praying',
                iconColor = '#da0101',
                description = 'Surrender 5',
                onSelect = function()
                    Surrender5(data)
                end
            },
            {
                title = 'TAKE HOSTAGE',
                icon = 'fa-solid fa-handshake-angle',
                iconColor = '#da0101',
                description = 'TAKE',
                onSelect = function()
                    takeHostage(data)
                end
    
            },
            
            {
                title = 'RELEASE HOSTAGE',
                icon = 'fa-solid fa-gun',
                iconColor = '#da0101',
                description = 'RELEASE',
                onSelect = function()
                    releasefully(data)
                end
    
            },
        }
    })
    lib.showContext('npc_hostage_menu')
end

exports.ox_target:addModel(Config.npcModels, {
    icon = 'fa-solid fa-handshake',
    label = 'Interact NPC',
    distance = 2.0,
    canInteract = function(entity, distance, coords, name, bone)
        return not IsEntityDead(entity) and not IsEntityAttached(entity)
    end,
    onSelect = function(data)
        NPC_hostage_menu(data)
    end
})


-- Function that handles the actual spawning of the ped, etc
npc_spawn_Ped = function()
    RequestModel(Config.npc_Ped.model)
    while not HasModelLoaded(Config.npc_Ped.model) do
        Wait(500)
    end
    npc_Ped = CreatePed(0, Config.npc_Ped.model, Config.npc_Ped.location, Config.npc_Ped.heading, false, true)
    FreezeEntityPosition(npc_Ped, true)
    SetBlockingOfNonTemporaryEvents(npc_Ped, true)
    SetEntityInvincible(npc_Ped, true)
    TaskStartScenarioInPlace(npc_Ped, Config.npc_Ped.scenario, 0, true) ----- ANIMATION OF THE PED
end

local function onEnterped(self)
    npc_spawn_Ped()
    exports.ox_target:addLocalEntity(npc_Ped, {
        name = 'npc_trigger_Ped',
        icon = self.target_icon,
        label = self.target_label,
        distance = 2,
        canInteract = function(entity, coords, distance)
            return IsPedOnFoot(cache.ped) and not IsPlayerDead(cache.ped)
        end,
        onSelect = function()
            if exports['NX_framework']:isPlayerNearby() then return end
            local status = lib.callback.await('NX_npchostage:spawnnpc', false)
            if status then
                local pedModel = Config.npcModels[math.random(1, #Config.npcModels)]
                RequestModel(pedModel)
                while not HasModelLoaded(pedModel) do
                    Wait(500)
                end
                local npc = CreatePed(0, pedModel, Config.hostage_npc_loc, true, true)
                --SetEntityAsMissionEntity(npc, true, true)
                --TaskStartScenarioInPlace(npc, "WORLD_HUMAN_SMOKE", 0, true)
                --FreezeEntityPosition(npc, true)
                SetBlockingOfNonTemporaryEvents(npc, true)
                --SetEntityInvincible(npc, true)
            end
            --if check then lib.callback.await('NX_npc:sendtodiscord', false,source) end
        end
    })
end

-- Deletes the mission start ped when player exits the defined area
local function onExitped(self)
    exports.ox_target:removeLocalEntity(npc_Ped, nil)
    DeleteEntity(npc_Ped)
end
 
local points = lib.points.new({
    coords = Config.npc_Ped.location,
    heading = Config.npc_Ped.heading,
    distance = Config.npc_Ped.distance,
    model = Config.npc_Ped.model,
    scenario = Config.npc_Ped.scenario,
    target_label = Config.npc_Ped.target_label,
	target_icon = Config.npc_Ped.target_icon,
    onEnter = onEnterped,
    onExit = onExitped,
})


