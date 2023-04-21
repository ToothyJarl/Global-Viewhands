-- ;
-- ;  Written by ToothyJarl :: 4/11/2023
-- ;

-- Utilities

function setTableString(table)
    local newTable = {}

    for k, v in pairs(table) do
        newTable[tostring(k)] = v
    end

    return newTable
end

-- Config

local viewhandsConfigPath = "players2/default/globalViewhandsConfig.json"

local defaultViewhandsConfig = {
    mode = "global",
    viewhand = "globalViewhands_h1_sas_ct_mp_camo",
    maps = {
        {
            mapname = "killhouse", -- F.N.G
            setViewhand = "globalViewhands_black_kit"
        },
        {
            mapname = "cargoship", -- Crew Expendable
            setViewhand = "globalViewhands_black_kit_wet"
        },
        {
            mapname = "coup", -- The Coup ( cutscene )
            setViewhand = "globalViewhands_base_viewhands"
        },
        {
            mapname = "blackout", -- Blackout
            setViewhand = "globalViewhands_sas_woodland"
        },
        {
            mapname = "armada", -- Charlie Don't Surf
            setViewhand = "globalViewhands_base_viewhands"
        },
        {
            mapname = "bog_a", -- The Bog
            setViewhand = "globalViewhands_base_viewhands"
        },
        {
            mapname = "hunted", -- Hunted
            setViewhand = "globalViewhands_sas_woodland"
        },
        {
            mapname = "ac130", -- Hunted
            setViewhand = "globalViewhands_base_viewhands"
        },
        {
            mapname = "bog_b", -- War Pig
            setViewhand = "globalViewhands_base_viewhands"
        },
        {
            mapname = "airlift", -- Shock and Awe
            setViewhand = "globalViewhands_base_viewhands"
        },
        {
            mapname = "aftermath", -- Aftermath ( cutscene )
            setViewhand = "globalViewhands_base_viewhands"
        },
        {
            mapname = "village_assault", -- Safehouse
            setViewhand = "globalViewhands_sas_woodland"
        },
        {
            mapname = "scoutsniper", -- All Ghillied Up
            setViewhand = "globalViewhands_marine_sniper"
        },
        {
            mapname = "sniperescape", -- One Shot, One Kill
            setViewhand = "globalViewhands_marine_sniper"
        },
        {
            mapname = "village_defend", -- Heat
            setViewhand = "globalViewhands_sas_woodland"
        },
        {
            mapname = "ambush", -- The Sins of The Father
            setViewhand = "globalViewhands_sas_woodland"
        },
        {
            mapname = "icbm", -- Ultimatum
            setViewhand = "globalViewhands_sas_woodland"
        },
        {
            mapname = "launchfacility_a", -- All In
            setViewhand = "globalViewhands_sas_woodland"
        },
        {
            mapname = "launchfacility_b", -- No Fighting In the War Room
            setViewhand = "globalViewhands_sas_woodland"
        },
        {
            mapname = "jeepride", -- Game Over
            setViewhand = "globalViewhands_sas_woodland"
        },
        {
            mapname = "airplane", -- Mile High Club
            setViewhand = "globalViewhands_black_kit"
        }
    }
}

if (not io.fileexists(viewhandsConfigPath)) then
    defaultViewhandsConfig.maps = setTableString(defaultViewhandsConfig.maps)
    local defaultJsonConfig = json.encode(defaultViewhandsConfig)
    io.writefile(viewhandsConfigPath, defaultJsonConfig, false)
end

configFunctions = {}

configFunctions.readConfig = function ()
    return json.decode(io.readfile(viewhandsConfigPath))
end

configFunctions.loadConfigToDvars = function ()
    local configData = configFunctions.readConfig()

    for k, v in pairs(configData.maps) do
        Engine.SetDvarFromString("globalViewhands_" .. v.mapname, v.setViewhand)
    end    

    Engine.SetDvarFromString( "globalViewhandsMode", configData.mode )
    Engine.SetDvarFromString( "globalViewhands_global", configData.viewhand )
end

configFunctions.setMapViewhand = function(map, viewhand)
    local configData = configFunctions.readConfig()

    for k, v in pairs(configData.maps) do
        if v.mapname == map then
            v.setViewhand = viewhand
            break
        end
    end

    io.writefile(viewhandsConfigPath, json.encode(configData), false)
end

configFunctions.setGlobalViewhand = function(viewhand)
    local configData = configFunctions.readConfig()

    configData.viewhand = viewhand

    io.writefile(viewhandsConfigPath, json.encode(configData), false)
end

configFunctions.setMode = function(mode)
    local configData = configFunctions.readConfig()

    configData.mode = mode

    io.writefile(viewhandsConfigPath, json.encode(configData), false)
end

configFunctions.resetConfig = function()
    defaultViewhandsConfig.maps = setTableString(defaultViewhandsConfig.maps)
    local defaultJsonConfig = json.encode(defaultViewhandsConfig)
    io.writefile(viewhandsConfigPath, defaultJsonConfig, false)
end

configFunctions.loadConfigToDvars()

return configFunctions