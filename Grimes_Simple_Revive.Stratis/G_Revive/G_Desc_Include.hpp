//#include in description.ext

Respawn = 3;
respawnDelay = 5;
RespawnDialog = false;
respawnOnStart = 1;

class CfgRespawnTemplates
{
	class G_Revive
	{
		onPlayerKilled = "G_Revive\G_Killed.sqf";
		onPlayerRespawn = "G_Revive\G_Respawn.sqf";
	};
};

respawnTemplates[] = {"G_Revive"};