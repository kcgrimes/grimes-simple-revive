//Handle spawn time based on initial spawn or not
if (G_Revive_InitialSpawn) then {
	//Initial spawn, so ensure no respawn time
	setPlayerRespawnTime 2;
}
else
{
	//Subsequent spawn, so apply respawn time
	setPlayerRespawnTime G_Respawn_Time;
};

//Custom execution
if (G_Custom_Exec_2 != "") then {
	[] execVM G_Custom_Exec_2;
};

private _unit 			= _this param [0,objnull,[objnull]];
private _respawnDelay 	= _this param [3, 0, [0]];
_respawn = _this param [2,-1,[0]];

//Handle life count if spawns are limited and this is not the initial spawn
_noLives = false;
if !((G_Num_Respawns == -1) || (G_Revive_InitialSpawn)) then {
	//Get life count
	_lives = _unit getVariable "G_Lives";
	//Remove one life from count
	_lives = _lives - 1;
	//Determine if no lives remain
	if (_lives < 0) then {
		_noLives = true;
	};
	//Set new life count
	_unit setVariable ["G_Lives", _lives, true];
};

//Handle unit if no lives remain
if (_noLives) exitWith {
	//Prevent display of RespawnMenu
	_unit setVariable ["BIS_fnc_showRespawnMenu_disable", true];
	//Enter Spectator or end the mission
	if (G_Spectator) then {
		//Spectator enabled, so launch it
		[_unit, _respawn] execVM "G_Revive\G_Spectator.sqf";
	}
	else
	{
		//Spectator disabled, so prevent unit from respawning before they are removed
		setPlayerRespawnTime 30;
		//End the mission locally as failure
		["END1", false] call BIS_fnc_endMission;
	};
};

//Handle respawn times
//No respawn timer for AI
//bug - intended...?
if (playerRespawnTime < 1 || !isPlayer _unit) exitWith {};
//Ensure at least a 6 second respawn time
//bug - why?
if (playerRespawnTime < 3) then {
	setPlayerRespawnTime (playerRespawnTime + 3);
};

//BIS_fnc_respawnMenuPosition running in parallel