// @Author: Vulpya
// @Version: 1.0.0

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;

draw_level_hud()
{
    self endon("disconnect");

    flag_wait("initial_blackscreen_passed");

    self.xpText = createFontString("objective", 1.5);
    self.xpText setPoint("CENTER", "TOP", 0, -20);

    for(;;)
    {
        self.xpText setText(
            "^2LVL: ^7" + self.playerLevel +
            "  ^3XP: ^7" + self.xp + "/" + self.xpToNext
        );

        wait 0.2;
    }
}

draw_player_health()
{
	self endon("disconnect");
	self.healthText = createFontString("Objective" , 1.7);
    self.healthText setPoint("CENTER", "TOP", 300, "CENTER");
    while(true) {
        self.healthText setText( "^2HEALTH: ^7"+ self.health);
        wait 0.5;
    }
}

draw_zombies_counter()
{
    flag_wait("initial_blackscreen_passed");

    level.zombiesCounter = createServerFontString("objective", 1.6);
    level.zombiesCounter setPoint("TOPLEFT", "TOPLEFT", -55, -35);
    level.zombiesCounter.alpha = 1;

    flicker = false;

    for (;;)
    {
        enemies = get_round_enemy_array().size + level.zombie_total;

        if (enemies < 1)
        {
            level.zombiesCounter.alpha = 0;
        }
        else
        {
            level.zombiesCounter.alpha = 1;
            level.zombiesCounter setText("ZOMBIES: ^1" + enemies);
        }

        wait 0.5;
    }
}