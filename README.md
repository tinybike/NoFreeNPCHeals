# No Free NPC Heals

Many NPCs in Baldur's Gate 3 do a free, instant heal-to-full when they're out-of-combat.  This mod disables that heal for any NPC that has attacked or been attacked by a player character, which lasts until the player long rests or changes regions.

You can download this mod from [Nexus](https://www.nexusmods.com/baldursgate3/mods/12906).

### How this works

1. Any NPC that attacks a player or is attacked by a player can no longer self-heal.  We keep track of these NPCs and which region they're in.
2. After you long rest, we go through each NPC in the current region (that we've tagged with the no-free-heals effect) and heal them to full.
3. If you enter a new region, the NPCs in the previous region will get healed to full when you re-enter the previous region, even if you haven't long rested -- changing regions gives the NPCs enough space to breathe that they heal to full while you're gone.

### Wizardry

Hat tip to Lunisole and Ghostboats, you guys are wizards!
