//#include in description.ext

#include "G_Defines.hpp"
#include "G_Dialogs.hpp"

Respawn = 3;
respawnDelay = 5;
RespawnDialog = false;
respawnOnStart = 0; //CHANGE TO 1 IF G_Init_Start AND G_JIP_Start = 2

class CfgRespawnTemplates
{
	class G_Revive
	{
		onPlayerKilled = "G_Revive\G_Killed.sqf";
		onPlayerRespawn = "G_Revive\G_Respawn.sqf";
	};
};

respawnTemplates[] = {"G_Revive"};