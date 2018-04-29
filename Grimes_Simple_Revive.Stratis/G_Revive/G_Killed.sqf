//Handle onKilled
//Local to _unit

private ["_unit", "_respawnType"];
_unit = _this select 0;
_respawnType = getNumber(missionConfigFile >> "respawn");

//For respawnOnStart, allow time for definitions to catch up
waitUntil {(!isNil {_unit getVariable "G_Lives"})};

//Custom execution
if (G_Custom_Exec_2 != "") then {
	[_unit] spawn G_fnc_Custom_Exec_2;
};

//Handle life count if spawns are limited and this is not the initial spawn
private ["_noLives", "_lives"];
_noLives = false;
if (!(G_Num_Respawns == -1)) then {
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
	if (isPlayer _unit) then {
		//Handle as player
		//Prevent display of RespawnMenu
		_unit setVariable ["BIS_fnc_showRespawnMenu_disable", true];
		//Enter Spectator if enabled, otherwise end the mission
		if (G_Spectator) then {
			//Spectator enabled, so launch it
			[_unit, _respawnType] execVM "G_Revive\G_Spectator.sqf";
		}
		else
		{
			//Spectator disabled, so prevent unit from respawning before they are removed
			setPlayerRespawnTime 30;
			//End the mission locally as failure
			["END1", false] call BIS_fnc_endMission;
		};
	}
	else
	{
		//Handle as AI
		//bug - what to do here to prevent AI from respawning? Possibly delete somehow?
	};
};

//Handle respawn times
//No respawn timer for AI
//bug - need to look at all this and associated commands for player/AI integration
//bug - intended...?
if (playerRespawnTime < 1 || !isPlayer _unit) exitWith {};
//Ensure at least a 6 second respawn time
//bug - why?
if (playerRespawnTime < 3) then {
	setPlayerRespawnTime (playerRespawnTime + 3);
};

//BIS_fnc_respawnMenuPosition running in parallel