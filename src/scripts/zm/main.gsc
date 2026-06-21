// @Author: Vulpya
// @Version: 1.0.0

#include scripts\zm\_xp;
#include scripts\zm\_hud;
#include scripts\zm\_player;
#include scripts\zm\_zombies;

init()
{
    level.initial_spawn = true; 

    level thread onPlayerConnect();
    level thread initZombieTracker();
    level thread drawZombiesCounter();
}