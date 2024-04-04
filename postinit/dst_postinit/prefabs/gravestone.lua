local AddPrefabPostInit = AddPrefabPostInit
GLOBAL.setfenv(1, GLOBAL)

AddPrefabPostInit("gravestone", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local DEV_EPITAPHS = STRINGS.DEV_EPITAPHS.SYDNEY
    local function GetDevEpitaph(epitaph)
        if epitaph ~= nil then
            for i, v in ipairs(DEV_EPITAPHS) do
                if v == epitaph then
                    return true
                end
                return false
            end
        end
    end

    inst.GetDevEpitaph = GetDevEpitaph

    local _OnLoad = inst.OnLoad
    local function OnLoad(inst, data, newents)
        _OnLoad(inst, data, newents)

        if data ~= nil then
            if GetDevEpitaph(data.setepitaph) then
                local _setepitaph = "Sydney" .. DEV_EPITAPHS[math.random(1, #DEV_EPITAPHS)]
                inst.components.inspectable:SetDescription("'".._setepitaph.."'")
                inst.setepitaph = _setepitaph
            end
        end
    end
    inst.OnLoad = OnLoad

    local mound = inst.mound
    local is_dev_epitaph = GetDevEpitaph(inst.setepitaph)
    if mound ~= nil and is_dev_epitaph and mound ~= nil then
        local _onfinish = mound.components.workable.onfinish
        local function OnFinishCallback(inst, worker, ...)
            if is_dev_epitaph then
                inst.AnimState:PlayAnimation("dug")
                inst:RemoveComponent("workable")

                if worker ~= nil then
                    if worker.components.sanity ~= nil then
                        worker.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
                    end
                    inst.components.lootdropper:SpawnLootPrefab("m_pantsu")
                end
            else
                _onfinish(inst, worker, ...)
            end
        end
        mound.components.workable:SetOnFinishCallback(OnFinishCallback)
    end
end)