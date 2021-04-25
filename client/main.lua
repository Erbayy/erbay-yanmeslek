ESX = nil


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local menuOpen = false
local wasOpen = false

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function playAnim(animDict, animName, duration)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do Citizen.Wait(0) end
	TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
	RemoveAnimDict(animDict)
end

Citizen.CreateThread(function()
    while true do
        local ms = 2000
        local player = PlayerPedId()
        local playercoords = GetEntityCoords(player)
        if GetDistanceBetweenCoords(playercoords, Config.Toplamabolgesiuzum.x, Config.Toplamabolgesiuzum.y, Config.Toplamabolgesiuzum.z, true) < 5 then
            ms = 0
            DrawText3D(Config.Toplamabolgesiuzum.x, Config.Toplamabolgesiuzum.y, Config.Toplamabolgesiuzum.z , 'Üzüm Toplamak için ~g~E~s~ Basınız')
            if IsControlJustReleased(0, 38) then
                exports["pogressBar"]:drawBar(Config.toplamasuresiuzum,"Üzüm topluyorsun..")
                playAnim("creatures@rottweiler@tricks@", "petting_franklin",Config.toplamasuresiuzum)
                Citizen.Wait(Config.toplamasuresiuzum)
                TriggerServerEvent('erbay-yanmeslek:itemekleuzum')
            end
        end
        if GetDistanceBetweenCoords(playercoords, Config.Islemebolgesiuzum.x, Config.Islemebolgesiuzum.y, Config.Islemebolgesiuzum.z, true) < 5 then
            ms = 0
            DrawText3D(Config.Islemebolgesiuzum.x, Config.Islemebolgesiuzum.y, Config.Islemebolgesiuzum.z , 'Üzüm islemek için ~g~E~s~ Basınız')
            if IsControlJustReleased(0, 38) then
                exports["pogressBar"]:drawBar(Config.islemesuresiuzum,"Üzüm işliyorsun..")
                playAnim("gestures@f@standing@casual", "gesture_point",Config.islemesuresiuzum)
                Citizen.Wait(Config.islemesuresiuzum)
                TriggerServerEvent('erbay-yanmeslek:itemceviruzum')
            end
        end
        if GetDistanceBetweenCoords(playercoords, Config.Islemebolgesiportakal.x, Config.Islemebolgesiportakal.y, Config.Islemebolgesiportakal.z, true) < 5 then
            ms = 0
            DrawText3D(Config.Islemebolgesiportakal.x, Config.Islemebolgesiportakal.y, Config.Islemebolgesiportakal.z , 'Portakal islemek için ~g~E~s~ basınız')
            if IsControlJustReleased(0, 38) then
                exports["pogressBar"]:drawBar(Config.islemesuresiportakal,"Portakal işliyorsun..")
                playAnim("creatures@rottweiler@tricks@", "petting_franklin",Config.islemesuresiportakal)
                Citizen.Wait(Config.islemesuresiportakal)
                TriggerServerEvent('erbay-yanmeslek:itemcevirportakal')
            end
        end
        Citizen.Wait(ms)
    end
end)


Citizen.CreateThread(function()
    while true do
    local player = PlayerPedId()
    local playercoords = GetEntityCoords(player)
	local ms = 2000
		for i=1, #Config.Portakaltoplama, 1 do
			if GetDistanceBetweenCoords(playercoords, Config.Portakaltoplama[i].x, Config.Portakaltoplama[i].y, Config.Portakaltoplama[i].z, true) < 5 then
                ms = 0
                DrawText3D(Config.Portakaltoplama[i].x, Config.Portakaltoplama[i].y, Config.Portakaltoplama[i].z, "Portakal toplamak için ~g~[E] ~w~ basınız")
                if IsControlJustReleased(0, 38) then
                    exports["pogressBar"]:drawBar(Config.toplamasuresiportakal,"Portakal toplanıyor..")
                    playAnim("random@mugging5", "001445_01_gangintimidation_1_female_idle_b",Config.toplamasuresiportakal)
                    Citizen.Wait(Config.toplamasuresiportakal)
                    TriggerServerEvent('erbay-yanmeslek:itemekleportakal')
                end
            end
        end
		Citizen.Wait(ms)
    end
end)

Citizen.CreateThread(function()
    while true do
    local ped = PlayerPedId()
    local ms = 2000
            if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.Satmabolgesi.x, Config.Satmabolgesi.y, Config.Satmabolgesi.z, true) < 5 then
                ms = 0
                DrawText3D(Config.Satmabolgesi.x, Config.Satmabolgesi.y, Config.Satmabolgesi.z + 2, " Toptanci ile gorusmek icin ~g~[E] ~w~ basiniz. ")
                    if IsControlJustReleased(1, 51) then 
                        OpenShop()          
            end
        end
        Citizen.Wait(ms)
    end
end)

function OpenShop()
	ESX.UI.Menu.CloseAll()
	local elements = {}
	menuOpen = true

	for k, v in pairs(ESX.GetPlayerData().inventory) do
		local price = Config.Items[v.name]

		if price and v.count > 0 then
			table.insert(elements, {
				label = ('%s - <span style="color:green;">%s</span>'):format(v.label, (ESX.Math.GroupDigits(price)..'$')),
				name = v.name,
				price = price,

				-- menu properties
				type = 'slider',
				value = v.count,
				min = 1,
				max = v.count
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop', {
		title    = 'Toptancı',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('erbay-yanmeslek:Itemsat', data.current.name, data.current.value)
	end, function(data, menu)
		menu.close()
		menuOpen = false
	end)
end


Citizen.CreateThread(function()

    if Config.Toplamabolgesiuzumblip == true then

    local blip = AddBlipForCoord(Config.Toplamabolgesiuzum.x, Config.Toplamabolgesiuzum.y, Config.Toplamabolgesiuzum.z)

    
    SetBlipSprite (blip, 233)
    SetBlipDisplay(blip, 4)
    SetBlipScale  (blip, 0.7)
    SetBlipColour (blip, 27)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Üzüm Toplama')
    EndTextCommandSetBlipName(blip)   

    end


end)


Citizen.CreateThread(function()

    if Config.Islemebolgesiuzumblip == true then

		local blip = AddBlipForCoord(Config.Islemebolgesiuzum.x, Config.Islemebolgesiuzum.y, Config.Islemebolgesiuzum.z)

		SetBlipSprite (blip, 233)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.7)
		SetBlipColour (blip, 27)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Üzüm İşleme')
		EndTextCommandSetBlipName(blip)

    end

end)


Citizen.CreateThread(function()
    
    if Config.Portakaltoplamablip == true then

        for i=1, #Config.Portakaltoplama, 1 do

		    local blip = AddBlipForCoord(Config.Portakaltoplama[i].x, Config.Portakaltoplama[i].y, Config.Portakaltoplama[i].z)

		    SetBlipSprite (blip, 233)
		    SetBlipDisplay(blip, 4)
		    SetBlipScale  (blip, 0.4)
		    SetBlipColour (blip, 5)
		    SetBlipAsShortRange(blip, true)

		    BeginTextCommandSetBlipName("STRING")
		    AddTextComponentString('Portakal Toplama')
		    EndTextCommandSetBlipName(blip)
	
        end

    end

end)


Citizen.CreateThread(function()

    if Config.Portakalislemeblip == true then

        local blip = AddBlipForCoord(Config.Islemebolgesiportakal.x, Config.Islemebolgesiportakal.y, Config.Islemebolgesiportakal.z)

        SetBlipSprite (blip, 233)
        SetBlipDisplay(blip, 4)
        SetBlipScale  (blip, 0.7)
        SetBlipColour (blip, 5)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Portakal İşleme')
    EndTextCommandSetBlipName(blip)

    end

end)


Citizen.CreateThread(function()

    if Config.Saticiblip == true then


		local blip = AddBlipForCoord(Config.Satmabolgesi.x, Config.Satmabolgesi.y, Config.Satmabolgesi.z)

		SetBlipSprite (blip, 365)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.7)
		SetBlipColour (blip, 0)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Toptancı')
		EndTextCommandSetBlipName(blip)

    end

end)



Citizen.CreateThread(function()
    if Config.Saticinpc == true then
        RequestModel(Config.Saticinpcmodel)
        while not HasModelLoaded(Config.Saticinpcmodel) do
            Wait(1)
        end
    
        erbay = CreatePed(1, Config.Saticinpcmodel, Config.Satmabolgesi.x, Config.Satmabolgesi.y, Config.Satmabolgesi.z, Config.Satmabolgesi.h, false, true)
        SetBlockingOfNonTemporaryEvents(erbay, true)
        SetPedDiesWhenInjured(erbay, false)
        SetPedCanPlayAmbientAnims(erbay, true)
        SetPedCanRagdollFromPlayerImpact(erbay, false)
        SetEntityInvincible(erbay, true)
        FreezeEntityPosition(erbay, true)
        TaskStartScenarioInPlace(erbay, "WORLD_HUMAN_CLIPBOARD", 0, true);
    end
end)







   

