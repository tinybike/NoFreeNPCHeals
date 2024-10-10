-- Thanks to Lunisole/Ghostboats for explaining Osi.PROC_SelfHealing_Disable to me!

PersistentVars = Mods.NoFreeNPCHeals.PersistentVars or {}

-- Any NPC that attacks a player or is attacked by a player can no longer self-heal.  We keep track of these NPCs and which region they're in.
local function onAttackedBy(defenderGuid, attackerGuid, _, _, _, _, _)
    local level = Osi.GetRegion(defenderGuid)
    local isPlayerAttacking = Osi.IsPlayer(attackerGuid) == 1
    local isPlayerDefending = Osi.IsPlayer(defenderGuid) == 1
    if (isPlayerAttacking and isPlayerDefending) or Osi.IsAlly(attackerGuid, defenderGuid) == 1 or level == nil then
        return
    end
    PersistentVars.SelfHealingDisabled[level] = PersistentVars.SelfHealingDisabled[level] or {}
    if isPlayerAttacking and not PersistentVars.SelfHealingDisabled[level][defenderGuid] then
        Osi.PROC_SelfHealing_Disable(defenderGuid)
        PersistentVars.SelfHealingDisabled[level][defenderGuid] = true
    elseif isPlayerDefending and not PersistentVars.SelfHealingDisabled[level][attackerGuid] then
        Osi.PROC_SelfHealing_Disable(attackerGuid)
        PersistentVars.SelfHealingDisabled[level][attackerGuid] = true
    end
end

local function healNPCsInLevel(level)
    if next(PersistentVars.SelfHealingDisabled) ~= nil and PersistentVars.SelfHealingDisabled[level] and next(PersistentVars.SelfHealingDisabled[level]) ~= nil then
        for npcGuid, _ in pairs(PersistentVars.SelfHealingDisabled[level]) do
            local isDead = Osi.IsDead(npcGuid)
            if isDead == 1 then
                PersistentVars.SelfHealingDisabled[level][npcGuid] = nil
            elseif isDead == 0 then
                Osi.SetHitpointsPercentage(npcGuid, 100.0)
                Osi.PROC_SelfHealing_Enable(npcGuid)
                PersistentVars.SelfHealingDisabled[level][npcGuid] = nil
            end
        end
    end
    PersistentVars.RegionsToHeal[level] = false
end

-- After you long rest, we go through each NPC in the current region (that we've tagged with the no-free-heals effect) and heal them to full.
local function onLongRestFinished()
    local level = Osi.GetRegion(Osi.GetHostCharacter())
    if level ~= nil then
        healNPCsInLevel(level)
    end
end

-- If you enter a new region, the NPCs in the previous region will get healed to full when you re-enter the previous region, even if you haven't long rested.
local function onLevelGameplayStarted(level, _)
    PersistentVars.SelfHealingDisabled[level] = PersistentVars.SelfHealingDisabled[level] or {}
    if PersistentVars.RegionsToHeal[level] == true then
        healNPCsInLevel(level)
    end
end

local function onLevelUnloading(level)
    PersistentVars.RegionsToHeal[level] = true
end

local function onSessionLoaded()
    PersistentVars.SelfHealingDisabled = PersistentVars.SelfHealingDisabled or {}
    PersistentVars.RegionsToHeal = PersistentVars.RegionsToHeal or {}
    Ext.Osiris.RegisterListener("AttackedBy", 7, "after", onAttackedBy)
    Ext.Osiris.RegisterListener("LongRestFinished", 0, "after", onLongRestFinished)
    Ext.Osiris.RegisterListener("LevelGameplayStarted", 2, "after", onLevelGameplayStarted)
    Ext.Osiris.RegisterListener("LevelUnloading", 1, "after", onLevelUnloading)
end

Ext.Events.SessionLoaded:Subscribe(onSessionLoaded)
