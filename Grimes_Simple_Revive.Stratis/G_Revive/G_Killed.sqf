if (G_Revive_FirstSpawn) then {
	setPlayerRespawnTime 2;
}
else
{
	setPlayerRespawnTime G_Respawn_Time;
};

if (G_Custom_Exec_2 != "") then {
	[] execVM G_Custom_Exec_2;
};

private _unit 			= _this param [0,objnull,[objnull]];
private _respawnDelay 	= _this param [3, 0, [0]];
_respawn = _this param [2,-1,[0]];

_noLives = false;
if !((G_Num_Respawns == -1) || (G_Revive_FirstSpawn)) then {
	_lives = _unit getVariable "G_Lives";
	_lives = _lives - 1;
	if (_lives < 0) then {
		_noLives = true;
	};
	_unit setVariable ["G_Lives",_lives,true];
};
	
if (_noLives) exitWith {
	//Prevent display of RespawnMenu
	_unit setVariable ["BIS_fnc_showRespawnMenu_disable", true];
	if (G_Spectator) then {
		[_unit, _respawn] execVM "G_Revive\G_Spectator.sqf";
	}
	else
	{
		setPlayerRespawnTime 30;
		["END1", false] call BIS_fnc_endMission;
	};
};

if (!alive _unit) then {
	if (playerrespawntime < 1 || !isplayer _unit) exitwith {};
	if (simulationenabled _unit) then {
		if (playerrespawntime < 3) then {
			setplayerrespawntime (playerrespawntime + 3);
		};
	};
	
	//BIS_fnc_respawnMenuPosition running in parallel
};