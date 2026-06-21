// @Author: Vulpya + Modified Integration
// @Version: 1.0.1

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_powerups;
#include scripts\zm\_xp;
#include scripts\zm\_hud;
#include scripts\zm\_perks;

#define MAX_HEALTH 150

#define DEBUG_XP false

onPlayerConnect()
{
    for (;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawnLoop();
    }
}

onPlayerSpawnLoop()
{
    self endon("disconnect");

    for (;;)
    {
        self waittill("spawned_player");

        if (!isDefined(self.initialized))
        {
            self.initialized = true;

            self initPlayerXP();
            self thread applyHealthTweaks();
            self thread disableMeleeLunge();

            if (DEBUG_XP)
                self thread drawLevelHUD();

            if (!isDefined(level.bo4AmmoApplied))
            {
                level.bo4AmmoApplied = true;
                replaceFunc(
                    maps\mp\zombies\_zm_powerups::full_ammo_powerup,
                    ::bo4_max_ammo_powerup
                );
                self iprintln("BO4 Max-Ammo: ^2ON");
            }

            self changePerkLimit(5);
        }
    }
}

/**
 * Changes the max ammo behavior to the one from BO4.
 */
bo4_max_ammo_powerup(drop_item, player)
{
    players = get_players(player.team);

    if (isDefined(level._get_game_module_players))
    {
        players = [[level._get_game_module_players]](player);
    }

    for (i = 0; i < players.size; i++)
    {
        if (players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand())
            continue;

        primary_weapons = players[i] getweaponslist(1);

        players[i] notify("zmb_max_ammo");
        players[i] notify("zmb_lost_knife");
        players[i] notify("zmb_disable_claymore_prompt");
        players[i] notify("zmb_disable_spikemore_prompt");

        for (x = 0; x < primary_weapons.size; x++)
        {
            curWeapon = primary_weapons[x];

            if (level.headshots_only && is_lethal_grenade(curWeapon))
                continue;

            if (isDefined(level.zombie_include_equipment) &&
                isDefined(level.zombie_include_equipment[curWeapon]))
                continue;

            if (isDefined(level.zombie_weapons_no_max_ammo) &&
                isDefined(level.zombie_weapons_no_max_ammo[curWeapon]))
                continue;

            if (players[i] hasweapon(curWeapon))
            {
                players[i] givemaxammo(curWeapon);
                players[i] setweaponammoclip(curWeapon, 300);
            }
        }
    }

    level thread full_ammo_on_hud(drop_item, player.team);
}

/**
 * Health system
 */
applyHealthTweaks()
{
    self endon("disconnect");
    level endon("game_ended");

    self.maxhealth = MAX_HEALTH;
    self.health = MAX_HEALTH;

    self iprintln("3-Hit Down: ^2ON");

    for (;;)
    {
        self waittill("player_revived");

        self.maxhealth = MAX_HEALTH;
        self.health = MAX_HEALTH;
    }
}

/**
 * Global dvar tweak to remove the annoying knife lunge.
 */
disableMeleeLunge()
{
    setDvar("aim_automelee_enabled", 0);
    self iprintln("Melee Lunge: ^1OFF");
}