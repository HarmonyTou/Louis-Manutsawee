local SpawnUtil = require("utils/spawnutil")
local CreateLight = SpawnUtil.CreateLight

local ATTACK_MODE = {
    Boss = function(inst)

    end,
    Player = function(inst)

    end,
}

local function CalculateLandPoint(pt, radius)
    radius = radius or 8
    if pt ~= nil then
        if not TheWorld.Map:IsAboveGroundAtPoint(pt.x, pt.y, pt.z) then
            pt = FindNearbyLand(pt, 1) or pt
        end
        local offset = FindWalkableOffset(pt, math.random() * 2 * PI, radius, 12, true, true, NoHoles)
        if offset ~= nil then
            offset.x = offset.x + pt.x
            offset.z = offset.z + pt.z
            return offset
        end
    end
end

local function IsPantsu(item)
    return item ~= nil and item.components.inventoryitem ~= nil and item:HasTag("pantsu") or false
end

local function ReleaseLight(inst, bool)
    local honey = inst:TheHoney()
    if honey ~= nil then
        if honey.momo_light == nil and inst.momo_light == nil then
            honey.momo_light = CreateLight(bool)
            honey.momo_light.Follower:FollowSymbol(honey.GUID)
            inst.momo_light = CreateLight(bool)
            inst.momo_light.Follower:FollowSymbol(inst.GUID)
        end
    end
end

local function ToggleLight(inst, phase)
    local bool_var = (phase == "night") or false
    local honey = inst:TheHoney()
    if honey ~= nil then
        if honey.momo_light ~= nil and inst.momo_light ~= nil then
            honey.momo_light.Light:Enable(bool_var)
            inst.momo_light.Light:Enable(bool_var)
        elseif bool_var then
            inst:ReleaseLight(bool_var)
        end
        if bool_var then
            inst:PushEvent("releaselight", {phase = phase})
        end
    end
end

local function RemoveLight(inst)
    local honey = inst:TheHoney()
    if honey ~= nil then
        if honey.momo_light ~= nil and inst.momo_light ~= nil then
            honey.momo_light:Remove()
            inst.momo_light:Remove()
        end
    end
end

local function FindItemInInventory(inst, item)
    if inst.components.inventory ~= nil then
        return inst.components.inventory:FindItem(function(inst)
            return (checkstring(item) and inst:HasTag(item)) or (checkentity(item) and (item.prefab == item)) or nil
        end)
    end
end

local function MomoSay(inst, str, fn)
    if checkstring(str) then
        local str_table = STRINGS.MOMO.DIALOGUE[string.upper(str)]
        for i = 1, #str_table do
            inst:DoTaskInTime(i * 3, function(inst)
                inst.components.talker:Say(str_table[i])
                if fn ~= nil and i == #str_table then
                    fn(inst)
                end
            end)
        end
    end
end

local function TheHoney(inst)
    -- Only save userid and use LookupPlayerInstByUserID to get data from networking.lua
    if inst.honey == nil and inst.honey_userid ~= nil then
        inst.honey = LookupPlayerInstByUserID(inst.honey_userid)
    end
    return inst.honey
end

local function ChargeEffects(inst, time)
    local x, y, z = inst.Transform:GetWorldPosition()
    for i = 0, 2 do
        inst:DoTaskInTime(time, function()
            local battlesong_instant_taunt_fx = SpawnPrefab("battlesong_instant_taunt_fx")
            battlesong_instant_taunt_fx.Transform:SetPosition(x, y, z)
            time = i + 0.5
        end)
    end

    local thunderbird_fx_idle = SpawnPrefab("thunderbird_fx_idle")
    thunderbird_fx_idle.Transform:SetPosition(x, y, z)

    inst:DoTaskInTime(3, function()
        local battlesong_instant_taunt_fx = SpawnPrefab("thunderbird_fx_shoot")
        battlesong_instant_taunt_fx.Transform:SetPosition(x, y, z)
    end)
end

local function ReleaseLightFx(inst)
    local fx = SpawnPrefab("fx_book_light_upgraded")
    local x, y, z = inst.Transform:GetWorldPosition()
    fx.Transform:SetScale(.9, 2.5, 1)
    fx.Transform:SetPosition(x, y, z)
end

local function Equip(inst, item, inventory)
    if checkstring(item) then
        local equip = inst:FindItemInInventory(item)
        if equip ~= nil then
            inventory:Equip(equip)
        end
    end
end

local function Unequip(equip_type, inventory)
    local equip = inventory:GetEquippedItem(EQUIPSLOTS[equip_type])

    if equip ~= nil then
        inventory:Unequip(equip)
        inventory:GiveItem(equip)
    end
end

local function SwitchEquip(inst, item, equip_type)
    local inventory = inst.components.inventory
    if inventory ~= nil and checkstring(item) then
        -- first take off the item in your hand and equip it with a new equip
        Unequip(equip_type, inventory)

        Equip(inst, item, inventory)
    end
end

local function OnSleepIn(inst)
    if inst._sleepinghandsitem ~= nil then
        inst._sleepinghandsitem:Show()
        inst.components.inventory:GiveItem(inst._sleepinghandsitem)
    end
    if inst._sleepingactiveitem ~= nil then
        inst.components.inventory:GiveItem(inst._sleepingactiveitem)
    end

    inst._sleepinghandsitem = inst.components.inventory:Unequip(EQUIPSLOTS.HANDS)
    if inst._sleepinghandsitem ~= nil then
        inst._sleepinghandsitem:Hide()
    end
    inst._sleepingactiveitem = inst.components.inventory:GetActiveItem()
    if inst._sleepingactiveitem ~= nil then
        inst.components.inventory:SetActiveItem(nil)
    end
end

local function OnWakeUp(inst)
    if inst._sleepinghandsitem ~= nil then
        inst._sleepinghandsitem:Show()
        inst.components.inventory:Equip(inst._sleepinghandsitem)
        inst._sleepinghandsitem = nil
    end
    if inst._sleepingactiveitem ~= nil then
        inst.components.inventory:GiveActiveItem(inst._sleepingactiveitem)
        inst._sleepingactiveitem = nil
    end
end

local function SpawnStartingItems(inst, items)
    if items ~= nil and #items > 0 and inst.components.inventory ~= nil then
        if inst.components.inventory:GetNumSlots() > 0 then
            for k, v in pairs(items) do
                for _ = 1, v do
                    local item = SpawnPrefab(k)
                    inst.components.inventory:GiveItem(item)
                end
            end
        end
    end
end

local SwitchAttackMode = function(inst, mode)
    if checkstring(mode) and ATTACK_MODE[mode] then
        inst.attack_mode = mode
        ATTACK_MODE[mode](inst)
    end
end

local AddAttackMode = function(modename, fn)
    ATTACK_MODE[modename] = fn
end

return {
    publicfn = {
        TheHoney = TheHoney,
        ChargeEffects = ChargeEffects,
        ReleaseLightFx = ReleaseLightFx,
        MomoSay = MomoSay,
        IsPantsu = IsPantsu,
        FindItemInInventory = FindItemInInventory,
        SwitchEquip = SwitchEquip,
        OnSleepIn = OnSleepIn,
        OnWakeUp = OnWakeUp,
        ReleaseLight = ReleaseLight,
        ToggleLight = ToggleLight,
        RemoveLight = RemoveLight,
        CalculateLandPoint = CalculateLandPoint,
    },

    privatefn = {
        SpawnStartingItems = SpawnStartingItems,
        SwitchAttackMode = SwitchAttackMode,
        AddAttackMode = AddAttackMode,
    },
}
