// @Author: Vulpya
// @Version: 1.0.0

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\gametypes_zm\_zm;
#include maps\mp\gametypes_zm\_zm_stats;
#include maps\mp\gametypes_zm\_zm_score;
#include scripts\zm\_print;

#define BASE_XP_PER_LEVEL 350
#define BASE_XP_PER_KILL 10

/**
 * Initializes XP-related player data.
 */
init_player_xp()
{
    if (!isDefined(self.prestige))
        self.prestige = 0;

    if (!isDefined(self.playerLevel))
        self.playerLevel = 1;

    if (!isDefined(self.xp))
        self.xp = 0;

    self.xpToNext = get_xp_for_level(self.playerLevel);
}

save_progress()
{
    /* */
}

/**
 * Gets the XP requirement for a level.
 *
 * @param playerLevel Current player level.
 * @return XP needed to reach the next level.
 */
get_xp_for_level(playerLevel)
{
    return int(250 + (playerLevel * playerLevel * 150) + (playerLevel * playerLevel * playerLevel * 5));
}

/**
 * Awards XP to the player and handles level-ups.
 *
 * @param amount Amount of XP to award.
 */
giveXP(amount)
{
    self.xp += amount;

    if (self.xp < 0)
        self.xp = 0;

    if (self.xp < self.xpToNext)
        return;

    self level_up();

    if (self.xp < 0)
        self.xp = 0;

    self save_progress();
}

/**
 * Increases the player's level and recalculates
 * the XP required for the next level.
 */
level_up()
{
    self.playerLevel++;
    self.xp -= self.xpToNext;
    self.xpToNext = get_xp_for_level(self.playerLevel);
    self checkPrestige();
    self save_progress();

    self thread show_level_up_message();
}

checkPrestige()
{
    if (self.playerLevel >= 55)
    {
        self.playerLevel = 1;
        self.prestige++;

        self print_small("^5PRESTIGE " + self.prestige + " UNLOCKED!");

        self save_progress();
    }
}


show_level_up_message()
{
    if(isDefined(self.lvlUpText))
        self.lvlUpText destroy();

    self.lvlUpText = createFontString("objective", 1.75);
    self.lvlUpText setPoint("CENTER", "TOP", 0, 50);
    self.lvlUpText setText("LEVEL UP: ^7" + self.playerLevel);

    wait 5;

    if(isDefined(self.lvlUpText))
        self.lvlUpText destroy();
}

/**
 * Continuously scans all AI zombies and attaches a death listener.
 *
 * This function runs in an infinite loop and checks for new zombies
 * spawned in the world. Each zombie is only initialized once using
 * the `zombie.init` flag to prevent duplicate threads.
 *
 * Once a zombie is detected as alive and not yet initialized,
 * it starts a separate thread to track its death event.
 */
init_zombie_tracker()
{
    for(;;)
    {
        zombies = getaiarray("axis");

        foreach(zombie in zombies)
        {
            if(isDefined(zombie) && isAlive(zombie) && !isDefined(zombie.init))
            {
                zombie.init = true;
                zombie thread handle_zombie_death();
            }
        }

        wait 0.5;
    }
}

/**
 * Waits for a zombie death event and awards XP to the attacker.
 *
 * This function runs on each individual zombie instance.
 * It listens for the "death" event and retrieves the attacker
 * who caused the kill. If the attacker is a valid player,
 * they are rewarded with XP.
 *
 * Events listened for:
 * - "death" (triggered when the zombie dies)
 *
 * Event data:
 * - attacker: entity that caused the kill.
 */
handle_zombie_death()
{
    self waittill("death", attacker, mod);

    if (!isDefined(attacker) || !isPlayer(attacker))
        return;

    wait 0.05;

    attacker iprintlnbold("MOD: " + mod);
    attacker giveXP(BASE_XP_PER_KILL);
}