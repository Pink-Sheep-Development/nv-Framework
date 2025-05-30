local firstTick = false
local ShowLoadingScreen = false
local spawnPos = vector3(-1037.6, -2737.8, 20.1693) -- LSIA

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(0, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    if onScreen then
        DrawText(_x, _y)
    end
end

AddEventHandler('onClientGameTypeStart', function()
    exports.spawnmanager:setAutoSpawnCallback(function()
        exports.spawnmanager:spawnPlayer({x = spawnPos.x, y = spawnPos.y, z = spawnPos.z - 1.0, model = 'mp_m_freemode_01'})
    end)

    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
end)

Citizen.CreateThread(function()
    if not firstTick then
        while not NetworkIsGameInProgress() and IsPlayerPlaying(PlayerId()) do
            Wait(800)
        end

        if not IsPlayerSwitchInProgress() then
            SetEntityVisible(PlayerPedId(), false, 0)
            SwitchOutPlayer(PlayerPedId(), 32, 1)
            Wait(3000)

            showLoadingPromt("PCARD_JOIN_GAME", 8000)
            Wait(1000)
            TriggerServerEvent("nv_core:GetInventory")
        end

        RequestModel("mp_m_freemode_01")
        while not HasModelLoaded("mp_m_freemode_01") do Wait(10) end
        SetPlayerModel(PlayerId(), "mp_m_freemode_01")

        for k, v in pairs(Config.weapons or {}) do
            GiveWeaponToPed(PlayerPedId(), v, -1, false, false)
        end

        Wait(5000)

        SwitchInPlayer(PlayerPedId())
        SetEntityVisible(PlayerPedId(), true, 0)
        Wait(5000)

        TriggerServerEvent('nv_core:LoadPlayer')
        exports.spawnmanager:setAutoSpawn(false)
        Wait(2000)
        SetPlayerScores(1, 2000, 1, 1000, 1)
        TriggerServerEvent('nv_ammunation:LoadPlayer')
        firstTick = true

        playerID = PlayerId()
        playerName = GetPlayerName(playerID)
        playerPed = PlayerPedId()
    end

    local ipls = {
        'facelobby', 'farm', 'farmint', 'farm_lod', 'farm_props',
        'des_farmhouse', 'post_hiest_unload', 'v_tunnel_hole',
        'rc12b_default', 'refit_unload'
    }

    for k, v in pairs(ipls) do
        if not IsIplActive(v) then
            RequestIpl(v)
        end
    end

    while true do
        Wait(10)
        if firstTick then
            if IsPedDead then
                deathscale = RequestDeathScreen()
                if IsControlJustPressed(0, 24) then
                    DoScreenFadeOut(500)
                    while not IsScreenFadedOut() do
                        HideHudAndRadarThisFrame()
                        Wait(500)
                    end

                    local Px, Py, Pz = table.unpack(GetEntityCoords(playerPed))
                    success, vec3 = GetSafeCoordForPed(Px, Py, Pz, false, 28)
                    heading = 0

                    if success then
                        x, y, z = table.unpack(vec3)
                    else
                        x, y, z = spawnPos.x, spawnPos.y, spawnPos.z
                    end

                    NetworkResurrectLocalPlayer(x, y, z - 1.0, 0.0, true, false)
                    ClearPedBloodDamage(playerPed)
                    ClearPedWetness(playerPed)
                    StopScreenEffect("DeathFailOut")

                    SetScaleformMovieAsNoLongerNeeded(deathscale)
                    SetScaleformMovieAsNoLongerNeeded(Instructional)

                    TriggerServerEvent('nv_ammunation:LoadPlayer')
                    Wait(800)
                    DoScreenFadeIn(500)
                    locksound = false
                end
            else
                if IsControlJustPressed(0, 20) then
                    ShowHudComponentThisFrame(3)
                    ShowHudComponentThisFrame(4)

                    if not HasHudScaleformLoaded(19) then
                        RequestHudScaleform(19)
                        Wait(10)
                    end

                    BeginScaleformMovieMethodHudComponent(19, "SHOW")
                    EndScaleformMovieMethodReturn()
                end
            end

            -- Show Welcome Text
            local coords = GetEntityCoords(PlayerPedId())
            DrawText3D(coords.x, coords.y, coords.z + 1.5, "~b~Welcome to Nova Framework~s~\nYour journey begins now...")
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(300)
        if firstTick then
            playerPed = PlayerPedId()
            IsPedDead = GetEntityHealth(playerPed) <= 0
        end
    end
end)
