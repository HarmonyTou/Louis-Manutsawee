local PopupDialogScreen = require("screens/redux/popupdialog")
local SpawnUtil = require("utils/spawnutil")
local CreateLight = SpawnUtil.CreateLight

local function PushConfirmDatingRelationship()
    local ConfirmDatingRelationship = function()
        TheWorld:PushEvent("ms_dating_relationship")
        TheFrontEnd:PopScreen()
    end

    local CancelDatingRelationship = function()
        TheFrontEnd:PopScreen()
    end

    local str = STRINGS.MOMO.START_DATING_RELATIONSHIP
    local confirmation = PopupDialogScreen(str.TITLE, str.BODY, {
        { text = str.OK,     cb = ConfirmDatingRelationship },
        { text = str.CANCEL, cb = CancelDatingRelationship  },
    })

    TheFrontEnd:PushScreen(confirmation)
end

local assets = {
    Asset("ANIM", "anim/player_basic.zip"),
    Asset("ANIM", "anim/player_actions.zip"),
    Asset("ANIM", "anim/player_attacks.zip"),
    Asset("ANIM", "anim/player_actions_item.zip"),
    Asset("ANIM", "anim/player_idles_wanda.zip"),
    Asset("ANIM", "anim/player_attack_prop.zip"),
    Asset("ANIM", "anim/player_parryblock.zip"),
    Asset("ANIM", "anim/player_actions_uniqueitem.zip"),
    Asset("ANIM", "anim/player_actions_useitem.zip"),
    Asset("ANIM", "anim/player_actions_item.zip"),
    Asset("ANIM", "anim/player_attack_leap.zip"),
    Asset("ANIM", "anim/wortox_portal.zip"),
    Asset("ANIM", "anim/player_lunge.zip"),
    Asset("ANIM", "anim/player_multithrust.zip"),
    Asset("ANIM", "anim/player_superjump.zip"),
    Asset("ANIM", "anim/player_pocketwatch_portal.zip"),
    Asset("ANIM", "anim/wanda_casting.zip"),
	Asset("ANIM", "anim/wendy_recall.zip"),
    Asset("ANIM", "anim/player_jump.zip"),

    Asset("ANIM", "anim/momo.zip"),
    Asset("ANIM", "anim/momo_maid.zip"),
    Asset("ANIM", "anim/momo_school.zip"),
    Asset("ANIM", "anim/momo_sailor.zip"),
    Asset("ANIM", "anim/momo_dark.zip"),
}

local prefabs = {
    "fx_book_light_upgraded",
    "mnaginata",
    "momo_hat",
    "battlesong_instant_taunt_fx",
    "mortalblade",
}

local momo_skins = {
    "momo",
	"momo_sailor",
	"momo_school",
	"momo_maid",
}

local profile_chat_icon = {
    "profileflair_food_steakfrites",
    "profileflair_food_pizza",
    "profileflair_waffle",
    "profileflair_food_jellyroll",
    "profileflair_food_grilledcheese",
}

local brain = require("brain/momobrain")

local function IsPantsu(item)
    return item:HasTag("pantsu")
end

local function MomoSay(inst, str_table)
    for i = 1, #str_table do
        inst:DoTaskInTime(i * 3, function(inst)
            inst.components.talker:Say(str_table[i])
        end)
    end
end

local function TheHoney(inst)
    -- Only save userid and use LookupPlayerInstByUserID to get data from networking.lua
    if inst.honey == nil and inst.honey_userid ~= nil then
        inst.honey = LookupPlayerInstByUserID(inst.honey_userid)
    end
    return inst.honey or nil
end

-- only accept pantsu and fruit from Louis, reject everything else
local function ShouldAcceptItem(inst, item, giver, count)
    local honey = inst:TheHoney()
    if honey ~= nil then
        return giver == honey and ((item:HasTag("mfruit")) or (inst:IsPantsu(item)))
    end
end

local function OnAccept(inst, giver, item)
    if item ~= nil then
        if (inst:IsPantsu(item)) or (inst.numberofbribes > 3) then
            inst:PushEvent("admitdefeated")
        end

        if item:HasTag("mfruit") then
            inst.numberofbribes = inst.numberofbribes + 1
        end
    end
end

local function OnRefuse(inst, giver, item)
    local honey = inst:TheHoney()
    if honey ~= nil and giver == honey then
        inst.components.talker:Say(STRINGS.MOMO.ONREFUSE.LIST[math.random(1, #STRINGS.MOMO.ONREFUSE.LIST)])
    else
        inst.components.talker:Say(STRINGS.MOMO.ONREFUSE.IRRELEVANT)
    end
end

local function Defeated(inst)
    local honey = inst:TheHoney()
    if honey ~= nil then
        honey.momo_light:Remove()
        inst.momo_light:Remove()
    end
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

local function SetUpEquip(inst)
    local inventory = inst.components.inventory
    if inventory ~= nil then
        -- priority use mnaginata
        if not inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
            local weapon = SpawnPrefab("mnaginata")
            inventory:Equip(weapon)
        end

        -- just a decoration, no effect
        if not inventory:GetEquippedItem(EQUIPSLOTS.HEAD) then
            local hat = SpawnPrefab("momo_hat")
            inventory:Equip(hat)
        end

        local mortalblade = SpawnPrefab("mortalblade")
        inventory:GiveItem(mortalblade)
    end
end

local function FindItemInInventory(inst, item)
    if inst.components.inventory ~= nil then
        return inst.components.inventory:FindItem(function(inst)
            return inst:HasTag(item) or (item.prefab == item) or false
        end)
    end
end

-- switch weapon, mnaginata or mortalblade
local function SwitchWeapon(inst, weapon)
    local inventory = inst.components.inventory
    if inventory ~= nil and type(weapon) == "string" then
        -- first take off the weapon in your hand and equip it with a new weapon
        local _weapon = inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        if _weapon ~= nil then
            inventory:Unequip(_weapon)
            inventory:GiveItem(_weapon)
        end

        local weapon = inst:FindItemInInventory(weapon)
        if weapon ~= nil then
            inventory:Equip(weapon)
            if weapon.UnsheathMode ~= nil then
                weapon:UnsheathMode(inst)
            end
        end
    end
end

local function OnSave(inst, data)
    if inst.honey ~= nil then
        data.honey_userid = inst.honey.userid
    end
end

local function OnPreLoad(inst, data)
end

local function OnLoad(inst, data)
    if data ~= nil then
        inst.honey_userid = data.honey_userid
    end
end

-- initialization
local function OnPostInit(inst)
    -- release lighting effects when appearing
    inst:ReleaseLightFx()

    -- fade in
    inst.components.spawnfader:FadeIn()
end

local function OnChangePhase(inst, phase)
    local honey = inst:TheHoney()
    if honey ~= nil then
        -- open up the aperture for honey and self at night
        if phase == "night" then
            if honey.momo_light == nil and inst.momo_light == nil then
                honey.momo_light = CreateLight()
                honey.momo_light.Follower:FollowSymbol(honey.GUID)
                inst:PushEvent("releaselight", {phase = phase})
                inst:DoTaskInTime(2, function(inst)
                    inst.momo_light = CreateLight()
                    inst.momo_light.Follower:FollowSymbol(inst.GUID)
                end)
            else
                honey.momo_light.Light:Enable(true)
                inst.momo_light.Light:Enable(true)
                inst:PushEvent("releaselight", {sametime = true, phase = phase})
            end
        elseif phase == "day" then
            if honey.momo_light ~= nil and inst.momo_light ~= nil then
                inst.momo_light.Light:Enable(false)
                honey.momo_light.Light:Enable(false)
                inst:PushEvent("releaselight", {phase = phase})
            end
        end
    end
end

local function OnStartADate(inst)
    inst:SetUpEquip()

    -- cancel invincible
    inst.components.health:SetInvincible(false)

    local honey = inst:TheHoney()

    -- track target and pantsu
    if honey ~= nil then
        -- lock the target and never give up
        inst.components.combat:SetTarget(honey)

        -- track all status of target, health, hunger, san
        inst.components.tracktargetstatus:StartTrack(honey)
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

local function GetStatus(inst, viewer)
    -- local list = {
    --     "",
    --     "",
    --     "",
    --     "",
    --     "",
    --     "",
    -- }
    -- local datingmanager = TheWorld.components.datingmanager
    -- local isdatingrelationship = datingmanager ~= nil and datingmanager:GetIsDatingRelationship() or false
    -- if viewer ~= nil and viewer:HasTag("naughtychild") and isdatingrelationship then
    --     return list[math.random(1, #list)]
    -- end
end

local function OnHitOtherFn(inst, target, damage, stimuli, weapon, damageresolved, spdamage, damageredirecttarget)
    if weapon ~= nil and target ~= nil and target:IsValid() then
        local fx = SpawnPrefab("wanda_attack_shadowweapon_old_fx")
        local x, y, z = target.Transform:GetWorldPosition()
        local radius = target:GetPhysicsRadius(.5)
        local angle = (inst.Transform:GetRotation() - 90) * DEGREES
        fx.Transform:SetPosition(x + math.sin(angle) * radius, 0, z + math.cos(angle) * radius)
	end
end

local function StartFencing()

end

local function StartDialogue(inst)
    MomoSay(inst, STRINGS.MOMO.DIALOGUE.HELLO)

    inst:DoTaskInTime(18, function(inst)
        local AcceptRequest = function()
            MomoSay(inst, STRINGS.MOMO.DIALOGUE.ACCEPT)

            TheFrontEnd:PopScreen()
        end

        local RejectRequest = function()
            MomoSay(inst, STRINGS.MOMO.DIALOGUE.REJECT)

            TheFrontEnd:PopScreen()
        end

        local str = STRINGS.MOMO.SELECT_REQUEST
        local confirmation = PopupDialogScreen(str.TITLE, str.BODY, {
            { text = str.OK,     cb = AcceptRequest },
            { text = str.CANCEL, cb = RejectRequest  },
        })

        TheFrontEnd:PushScreen(confirmation)
    end)
end

local function RegisterMasterEventListeners(inst)
    inst:ListenForEvent("admitdefeated", Defeated)
    inst:ListenForEvent("onstartadate", OnStartADate)
    inst:ListenForEvent("start_dialogue", StartDialogue)
end

local function RegisterWorldStateWatchers(inst)
    inst:WatchWorldState("phase", OnChangePhase)
    OnChangePhase(inst, TheWorld.state.phase)
end

local function SetInstanceValue(inst)
    inst.numberofbribes = 0
    inst.customidleanim = "idle_wanda"
    inst.soundsname = "wendy"
    inst.momo_skins = momo_skins
    inst.profile_chat_icon = profile_chat_icon
end

local function SetInstanceFunctions(inst)
    inst.OnPostInit = OnPostInit
    inst.SetUpEquip = SetUpEquip
    inst.SwitchWeapon = SwitchWeapon
    inst.ReleaseLightFx = ReleaseLightFx
    inst.Defeated = Defeated
    inst.ChargeEffects = ChargeEffects
    inst.IsPantsu = IsPantsu
    inst.TheHoney = TheHoney
    inst.CreateLight = CreateLight
    inst.OnStartADate = OnStartADate
    inst.FindItemInInventory = FindItemInInventory
    inst.StartDialogue = StartDialogue

    inst.OnSleepIn = OnSleepIn
    inst.OnWakeUp = OnWakeUp

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnPreload = OnPreLoad
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild(momo_skins[math.random(1, #momo_skins)])
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetScale(0.94, 0.94, 1)

    inst.AnimState:Hide("ARM_carry")
    inst.AnimState:Hide("HAT")
    inst.AnimState:Hide("HAIR_HAT")
    inst.AnimState:Show("HAIR_NOHAT")
    inst.AnimState:Show("HAIR")
    inst.AnimState:Show("HEAD")
    inst.AnimState:Hide("HEAD_HAT")
    inst.AnimState:Hide("HEAD_HAT_NOHELM")
    inst.AnimState:Hide("HEAD_HAT_HELM")

    inst.AnimState:AddOverrideBuild("player_idles_wanda")
    inst.AnimState:AddOverrideBuild("player_multithrust")
    inst.AnimState:AddOverrideBuild("player_attack_leap")
    inst.AnimState:AddOverrideBuild("player_superjump")
    inst.AnimState:AddOverrideBuild("player_actions_uniqueitem")

    inst.DynamicShadow:SetSize(1.3, .6)

    -- inst.MiniMapEntity:SetIcon("momo.tex")
    -- inst.MiniMapEntity:SetPriority(10)

    MakeCharacterPhysics(inst, 75, .5)

    inst:AddTag("character")
    inst:AddTag("girl")

    inst:AddTag("pocketwatchcaster")

    -- inst:AddTag("momo_npc")

    -- trader (from trader component) added to pristine state for optimization
    inst:AddTag("trader")

    inst:AddComponent("spawnfader")

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 30
    inst.components.talker.offset = Vector3(0, -400, 0)
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.colour = Vector3(238 / 255, 69 / 255, 105 / 255)
    inst.components.talker.chaticon = profile_chat_icon[math.random(1, #profile_chat_icon)]
    inst.components.talker.chaticonbg = "playerlevel_bg_lavaarena"
    inst.components.talker:MakeChatter()

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		return inst
	end

    inst:AddComponent("timer")
    inst:AddComponent("inventory")
    inst:AddComponent("entitytracker")
    inst:AddComponent("tracktargetstatus")
    inst:AddComponent("colouradder")

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("follower")
    inst.components.follower.canaccepttarget = true

    -- inst:AddComponent("healthtrigger")
	-- for i, v in pairs(PHASES) do
        -- 	inst.components.healthtrigger:AddTrigger(v.hp, v.fn)
	-- end

	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = TUNING.MOMO_WALKSPEED
	inst.components.locomotor.runspeed = TUNING.MOMO_RUNSPEED

	inst:AddComponent("health")
	inst.components.health:SetMinHealth(1)
	inst.components.health:SetMaxHealth(TUNING.MOMO_HEALTH)

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnAccept
    inst.components.trader:SetOnRefuse(OnRefuse)
    inst.components.trader.deleteitemonaccept = false

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.UNARMED_DAMAGE)
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetAttackPeriod(0.2)
    inst.components.combat:SetRange(TUNING.DEFAULT_ATTACK_RANGE)
    inst.components.combat.onhitotherfn = OnHitOtherFn

    MakeMediumBurnableCharacter(inst, "torso")
    MakeLargeFreezableCharacter(inst, "torso")

	inst:SetStateGraph("SGmomo")
	inst:SetBrain(brain)

    SetInstanceValue(inst)
    SetInstanceFunctions(inst)
    RegisterWorldStateWatchers(inst)
    RegisterMasterEventListeners(inst)

    inst:DoTaskInTime(0, OnPostInit)

    return inst
end

return Prefab("momo", fn, assets, prefabs)
    -- Prefab("momo_npc", fn, assets, prefabs)
