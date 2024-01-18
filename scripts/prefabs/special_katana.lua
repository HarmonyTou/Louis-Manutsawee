local MakeKatana = require "prefabs/katana_def"

local shusui_assets = {
    Asset("ANIM", "anim/shusui.zip"),
    Asset("ANIM", "anim/Sshusui.zip"),
    Asset("ANIM", "anim/swap_shusui.zip"),
    Asset("ANIM", "anim/swap_Sshusui.zip"),
    Asset("ANIM", "anim/sc_shusui.zip"),
    Asset("ANIM", "anim/sc_shusui2.zip"),
}

local mortalblade_assets = {
	Asset("ANIM", "anim/mortalblade.zip"),
	Asset("ANIM", "anim/Smortalblade.zip"),
	Asset("ANIM", "anim/swap_mortalblade.zip"),
	Asset("ANIM", "anim/swap_Smortalblade.zip"),
	Asset("ANIM", "anim/sc_mortalblade.zip"),
	Asset("ANIM", "anim/sc_mortalblade2.zip"),
}

local function TryStartFx(inst, owner)
	owner = owner
		or inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner
		or nil

	if owner == nil then
		return
	end

	if inst._vfx_fx_inst == nil then
		inst._vfx_fx_inst = SpawnPrefab("pocketwatch_weapon_fx")
		inst._vfx_fx_inst.entity:AddFollower()
		inst._vfx_fx_inst.entity:SetParent(owner.entity)
		inst._vfx_fx_inst.Follower:FollowSymbol(owner.GUID, "swap_object", 15, 0, 0)
	end
end

local function StopFx(inst)
	if inst._vfx_fx_inst ~= nil then
		inst._vfx_fx_inst:Remove()
		inst._vfx_fx_inst = nil
	end
end

local shadow_fx = {"wanda_attack_shadowweapon_old_fx", "wanda_attack_pocketwatch_old_fx", "hitsparks_fx"}
local CANT_TAGS = {"player", "INLIMBO", "structure", "companion", "abigial", "birds", "prey", "wall" ,"boat", "bird"}

local shusui_onattack = function(inst, owner, target)
    local radius = 6
    local x, y, z = owner.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, radius, nil, CANT_TAGS)

    for _, v in pairs(ents) do
        if v ~= nil and v:IsValid() and v.components.health ~= nil and not v.components.health:IsDead() then
            local shadowfx = SpawnPrefab(shadow_fx[2])
            shadowfx.Transform:SetScale(2, 2, 2)
            shadowfx.Transform:SetPosition(v:GetPosition():Get())

            if v ~= target then
				v.components.health:DoDelta(-20)
			end
        end
    end
end

local hitsparks_fx_colouroverride = {1, 0, 0}
local mortalblade_onattack = function(inst, owner, target)
    if inst.IsShadow(target) then
		target.components.combat:GetAttacked(owner, inst.components.weapon.damage * 10)
	end

    local shadowfx
    local radius = 10
    local x, y, z = owner.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, radius, nil, CANT_TAGS)

    local spark = SpawnPrefab("hitsparks_fx")
    spark:Setup(owner, target, nil, hitsparks_fx_colouroverride)
    -- 将hitsparks_fx的black值设置为true
    spark.black:set(true)

    for _, v in pairs(ents) do
        if v ~= nil and v:IsValid() and v.components.health ~= nil and not v.components.health:IsDead() then
            if math.random(1, 2) == 1 then
                shadowfx = SpawnPrefab(shadow_fx[math.random(1,2)])
            else
                shadowfx = SpawnPrefab(shadow_fx[math.random(1,2)])
            end
            if shadowfx.prefab == "hitsparks_fx" then
                spark:Setup(owner, target, nil, hitsparks_fx_colouroverride)
                -- 将hitsparks_fx的black值设置为true
                spark.black:set(true)
            end
            shadowfx.Transform:SetScale(3, 3, 3)
			shadowfx.Transform:SetPosition(v:GetPosition():Get())
            inst.SoundEmitter:PlaySound("dontstarve/common/nightmareAddFuel")

            if v ~= target then
				v.components.health:DoDelta(-TUNING.KATANA.TRUE_DAMAGE)
			end
        end
    end
end

local shusui_common_postinit = function(inst)
    inst:AddTag("shusui")
end

-- local shusui_master_postinit = function(inst)
--     inst.components.weapon:SetDamage(42)
-- end

local mortalblade_common_postinit = function(inst)
    inst:AddTag("mortalblade")
end

local function OnIsNightmareWild(inst, isnightmarewild)
    local owner = inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner or nil

    if owner ~= nil and isnightmarewild and inst.components.areaaware:CurrentlyInTag("Nightmare") then
        inst.components.talker:Say(GetString(owner, "ANNOUNCE_ISNIGHTMAREWILD"))
        owner.AnimState:OverrideSymbol()
    else

    end
end

local function OnRemove()
    local katanaspawner = TheWorld.components.katanaspawner
    if katanaspawner ~= nil and katanaspawner:GetTheWorldHasTomb() then
        katanaspawner:SetHasTomb(false)
    end
end

local mortalblade_master_postinit = function(inst)
    inst.components.weapon:SetDamage(TUNING.KATANA.TRUE_DAMAGE)
    inst.first_time_unsheathed = true

    inst:WatchWorldState("isnightmarewild", OnIsNightmareWild)
    OnIsNightmareWild(inst, TheWorld.state.isnightmarewild)

    inst:ListenForEvent("onremove", OnRemove)

    inst.TryStartFx = TryStartFx
    inst.StopFx = StopFx
end

local tenseiga_onattack = function(inst, owner, target)
    local health = target.components.health
    if health ~= nil then
        if target:HasTag("abigail") then
            owner.components.talker:Say(STRINGS.CHARACTERS.MANUTSAWEE.ABIGAIL.RESURRECTION)
        elseif target:HasTag("ghost") then
            health:Kill()
            local fx = SpawnPrefab("fx_book_light_upgraded")
            fx.Transform:SetScale(.9, 2.5, 1)
            fx.entity:AddFollower()
            fx.Follower:FollowSymbol(inst.GUID, "ghost_build", 0, 0, 0)
            owner.components.talker:Say(STRINGS.CHARACTERS.MANUTSAWEE.ABIGAIL.RESURRECTION)
        end

        -- 杀死非尘世之物
        if inst.IsShadow(target) or inst.IsLunar(target) then
            if health:IsInvincible() then
                health:SetInvincible(false)
            end
            health:Kill()
        end
    end
end

local tenseiga_common_postinit = function(inst)
    inst:AddTag("tenseiga")
end

local tenseiga_master_postinit = function(inst)
    local onhaunt = inst.components.hauntable.onhaunt
    function inst.components.hauntable.onhaunt(inst, player)
        if player ~= nil and player:HasTag("playerghost") then
            inst:PushEvent("respawnfromghost", { source = inst, user = inst })
            local fx = SpawnPrefab("fx_book_light_upgraded")
            fx.Transform:SetScale(.9, 2.5, 1)
            fx.entity:AddFollower()
            fx.Follower:FollowSymbol(inst.GUID, "swap_tenseiga", 0, 0, 0)
        end

        return onhaunt(inst, player)
    end
end

local katana_data = {
    shusui = {
        common_postinit = shusui_common_postinit,
        -- master_postinit = shusui_master_postinit,
        onattack = shusui_onattack,
        damage = TUNING.KATANA.TRUE_DAMAGE
    },
    mortalblade = {
        common_postinit = mortalblade_common_postinit,
        master_postinit = mortalblade_master_postinit,
        onattack = mortalblade_onattack,
        damage = TUNING.KATANA.TRUE_DAMAGE
    },
    tenseiga = {
        common_postinit = tenseiga_common_postinit,
        master_postinit = tenseiga_master_postinit,
        onattack = tenseiga_onattack,
        damage = 0,
    }
}

local katana = {}
for k, v in pairs(katana_data) do
    local data = {
        name = k,
        onattack = v.onattack,
        common_postinit = v.common_postinit,
        master_postinit = v.master_postinit,
        damage = v.damage
    }
    table.insert(katana, MakeKatana(data))
end

return unpack(katana)
