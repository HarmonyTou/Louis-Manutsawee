local modimport = modimport
GLOBAL.setfenv(1, GLOBAL)

modimport("postinit/entityscript")
-- modimport("postinit/recipe")

local postinit = {
    prefabs = {
        "nightmarefissure",
        "trap",
        "winter_tree",
        "world",
        "humanmeat",
        "sacred_chest",
        "world_network",
        "gravestone",
    },
    stategraphs = {
        "SGwilson",
        "SGwilson_client",
    },
    components = {
        "eater",
        "sanity",
        "sanity_replica",
        "grogginess",
        "equippable",
        "wisecracker",
        "combat",
        "cursable",
        "trader",
        "trap",
        "curseditem",
    },
    widgets = {
        "skinspuppet",
    },
    multipleprefabs = {
        "tradable",
        "eater",
    },
}

for k, v in pairs(postinit) do
    for i = 1, #v do
        modimport("postinit/reignofgiants/" .. k .. "/" .. postinit[k][i])
    end
end
