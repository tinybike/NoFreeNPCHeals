-- Thanks to Lunisole/Ghostboats for explaining Osi.PROC_SelfHealing_Disable to me!

local function onAttackedBy(defenderGuid, attackerGuid, _, _, _, _, _)
    local isPlayerAttacking = Osi.IsPlayer(attackerGuid) == 1
    local isPlayerDefending = Osi.IsPlayer(defenderGuid) == 1
    if (isPlayerAttacking and isPlayerDefending) or Osi.IsAlly(attackerGuid, defenderGuid) == 1 then
        return
    end
    if isPlayerAttacking then
        Osi.PROC_SelfHealing_Disable(defenderGuid)
    elseif isPlayerDefending then
        Osi.PROC_SelfHealing_Disable(attackerGuid)
    end
end

local function onSessionLoaded()
    Ext.Osiris.RegisterListener("AttackedBy", 7, "after", onAttackedBy)
end

Ext.Events.SessionLoaded:Subscribe(onSessionLoaded)
