// @Author: Vulpya
// @Version: 1.0.0

#include scripts\zm\_xp;
#include scripts\zm\_hud;
#include scripts\zm\_player;
#include scripts\zm\_zombies;
#include scripts\zm\_visuals;

init()
{
    level.initial_spawn = true; 

    level thread on_player_connect();
    level thread init_zombie_tracker();
    level thread draw_zombies_counter();
}