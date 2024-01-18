local assets = {
    Asset("ANIM", "anim/maid_hb.zip"),
    Asset("ANIM", "anim/maid_hb_swap.zip"),
	Asset("ANIM", "anim/m_hb.zip"),
	Asset("ANIM", "anim/m_oni.zip"),
	Asset("ANIM", "anim/m_nohat.zip"),
}

local mitemlist = {"maid_hb_swap","m_hb","m_oni","m_nohat"}

local function MItemmode(inst)
	local owner = inst.components.inventoryitem.owner
	owner.AnimState:OverrideSymbol("swap_hat", mitemlist[inst.mitemstatus], "swap_hat")
end

local function OnEquip(inst, owner)
	MItemmode(inst)
    owner.AnimState:Show("HAT")

	if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
    end
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("HAT")
	if inst.components.fueled ~= nil then
       inst.components.fueled:StopConsuming()
    end
end

local function CastFn(inst, target)
	if inst.mitemstatus < #mitemlist then
		inst.mitemstatus = inst.mitemstatus + 1
	else
		inst.mitemstatus = 1
	end

	MItemmode(inst)
end

local function onSave(inst, data)
    data.mitemstatus = inst.mitemstatus
end

local function onLoad(inst, data)
    if data ~= nil then
        inst.mitemstatus = data.mitemstatus or 1
    end
end

local function fn()
 local inst = CreateEntity()

	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

	inst:AddTag("hat")
	inst:AddTag("quickcast")
	inst.spelltype = "SCIENCE"

    MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("maid_hb")
    inst.AnimState:SetBuild("maid_hb")
    inst.AnimState:PlayAnimation("idle")

	MakeInventoryFloatable(inst, nil, 0.1)

    inst.entity:SetPristine()

	if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst:AddComponent("tradable")

	inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

	inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)

	inst:AddComponent("insulator")
    inst.components.insulator:SetSummer()
    inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)

    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(CastFn)
    inst.components.spellcaster.canusefrominventory = true
    inst.components.spellcaster.quickcast = true

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.GOGGLES_PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)

	inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED

	inst.mitemstatus = 1
	inst.OnSave = onSave
    inst.OnLoad = onLoad

	MakeHauntableLaunch(inst)

    return inst
end

return Prefab("maid_hb", fn, assets)
