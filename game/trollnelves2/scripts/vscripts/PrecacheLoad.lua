if PrecacheLoad == nil then
  print ( '[[TROLLNELVES2] Performing pre-load precache PRECACHE.lua' )
  PrecacheLoad = {}
end

local particle_folders = {
  "particles/buildinghelper",
    "particles/econ",
    "particles/msg_fx",
    "particles/my_new",
}

local function PrecacheEverythingFromTable( context, kvtable)
    for key, value in pairs(kvtable) do
        if type(value) == "table" then
            --Ignore those preloaded units
            if not string.find(key, "npc_precache_") then
              PrecacheEverythingFromTable( context, value )
            end
        else
            --if string.find(value, "vpcf") then
            --    PrecacheResource( "particle", value, context)
            --end
            --if string.find(value, "vmdl") then
            --    PrecacheResource( "model", value, context)
            --end
            if string.find(value, "vsndevts") and  value ~= "tower.fire" then
                PrecacheResource( "soundfile", value, context)
            end
        end
    end
end

function PrecacheEverythingFromKV( context )
    local kv_files = {
        "scripts/npc/npc_abilities_custom.txt",
        "scripts/npc/npc_units_custom.txt",
        "scripts/npc/npc_items_custom.txt",
    }
    for _, kv in pairs(kv_files) do
        local kvs = LoadKeyValues(kv)
        if kvs then
            PrecacheEverythingFromTable( context, kvs)
        end
    end
end



function PrecacheLoad:PrecacheLoad (context)
    DebugPrint("[TROLLNELVES2] Performing pre-load precache PRECACHE.lua")
    PrecacheEverythingFromKV(context)

  -- for _, p in pairs(particle_folders) do
  --     PrecacheResource("particle_folder", p, context)
  -- end

    local heroeskv = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
    for hero, _ in pairs(heroeskv) do
        PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_"..string.sub(hero,15)..".vsndevts", context )
    end
end
