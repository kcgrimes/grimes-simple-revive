disableserialization;
_unit = [_this,0,objnull,[objnull]] call bis_fnc_param;
_respawnDelay = [_this,3,0,[0]] call bis_fnc_param;

if ((G_isJIP) and ((_unit getVariable "G_Lives") == G_Num_Respawns) and (G_JIP_Start == 0) and (G_Revive_FirstSpawn)) exitWith {G_Revive_FirstSpawn = false;};
if ((!G_isJIP) and ((_unit getVariable "G_Lives") == G_Num_Respawns) and (G_Init_Start == 0) and (G_Revive_FirstSpawn)) exitWith {G_Revive_FirstSpawn = false;};

private ["_respawn"];
if (alive _unit) then {

	///////////////////////////////////////////////////////////////////////////////////////////
	//--- onPlayerRespawn
	///////////////////////////////////////////////////////////////////////////////////////////
	if (isplayer _unit) then {
		["bis_fnc_respawnMenuPosition","RscDisplayLoadingBlack"] call bis_fnc_startloadingscreen;

		//--- Player - teleport to selected position
		[] call bis_fnc_showRespawnMenu;

		_respawn = missionnamespace getvariable ["BIS_fnc_respawnMenuPosition_respawn",""];
		if (str _respawn == """""") then {
			_positions = ((player call bis_fnc_objectSide) call bis_fnc_getRespawnMarkers) + (player call bis_fnc_getRespawnPositions);
			_respawn = if (count _positions > 0) then {
				_positions call bis_fnc_selectrandom;
			} else {
				nil
			};
		};

		if (isnil "_respawn") then {
			["Cannot respawn %1, no %2 respawn position found.",_unit,_unit call bis_fnc_objectSide] call bis_fnc_error;
		} else {
			[_unit,_respawn] call bis_fnc_moveToRespawnPosition;
		};

		//--- Clean-up
		BIS_fnc_respawnMenuPosition_draw = nil;
		BIS_fnc_respawnMenuPosition_mouseMoving = nil;
		BIS_fnc_respawnMenuPosition_mouseButtonClick = nil;
		BIS_fnc_respawnMenuPosition_systemSelect = nil;
		BIS_fnc_respawnMenuPosition_positions = nil;
		with uinamespace do {
			BIS_fnc_respawnMenuPosition_ctrlList = nil;
			BIS_fnc_respawnMenuPosition_positions = nil
		};

		setplayerrespawntime _respawnDelay;

		"bis_fnc_respawnMenuPosition" call bis_fnc_endloadingscreen;
	} else {
		//--- AI - teleport to random position
		_respawnPositions = ((_unit call bis_fnc_objectSide) call bis_fnc_getRespawnMarkers) + (_unit call bis_fnc_getRespawnPositions);
		if (count _respawnPositions > 0) then {
			_respawn = _respawnPositions call bis_fnc_selectrandom;
		};
		[_unit, _respawn] call bis_fnc_moveToRespawnPosition;
	};
};

_unit setVariable ["G_Unconscious",false,true];
_unit setVariable ["G_Dragged",false,true];
_unit setVariable ["G_Carried",false,true];
_unit setVariable ["G_Dragging",false,true];
_unit setVariable ["G_Carrying",false,true];
_unit setVariable ["G_getRevived",false,true];
_unit setVariable ["G_Reviving",false,true];
_unit setVariable ["G_Reviver",objNull,true];
_unit setVariable ["G_Loaded",false,true];
_unit setVariable ["G_byVehicle",false,true];
_unit setVariable ["G_Downs",0,true];
[[_unit, true], "G_fnc_enableSimulation", true, true] spawn BIS_fnc_MP;
_unit setCaptive false;
_unit setVariable ["G_Side",side _unit,true];
_unit enableAI "MOVE";
_unit allowDamage true;

if ((G_isJIP) and ((_unit getVariable "G_Lives") == G_Num_Respawns) and (G_JIP_Start == 0) and (G_Revive_FirstSpawn)) then {
	_unit setPos G_Unit_Start_Pos;
};

if ((!G_isJIP) and ((_unit getVariable "G_Lives") == G_Num_Respawns) and (G_Init_Start == 0) and (G_Revive_FirstSpawn)) then {
	_unit setPos G_Unit_Start_Pos;
};

if (G_Squad_Leader_Spawn) then {
	if (isNil "G_Player_Squad_Leader_Var") exitWith {};
	if (G_Player_Squad_Leader_Var isEqualTo _respawn) then {
		_stance = animationState G_Player_Squad_Leader_Var;
		[[_unit, _stance], "G_fnc_switchMove", true, true, true] call BIS_fnc_MP;
	};
};

if (G_Custom_Exec_3 != "") then {
	[] execVM G_Custom_Exec_3;
};

sleep 2;

_lives = _unit getVariable "G_Lives";
if ((_lives >= 0) and !(G_Revive_FirstSpawn)) then {
	titleText [format["You have %1 lives remaining!",_lives],"PLAIN",2];
	sleep 3;
	titleFadeOut 3;
};

G_Revive_FirstSpawn = false;