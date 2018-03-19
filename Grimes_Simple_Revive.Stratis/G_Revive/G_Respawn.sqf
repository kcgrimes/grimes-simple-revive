private _unit 			= _this param [0,objnull,[objnull]];
private _respawnDelay 	= _this param [3, 0, [0]];

if ((G_Revive_FirstSpawn) and ((_unit getVariable "G_Lives") == G_Num_Respawns) and (((G_JIP_Start == 0) and (G_isJIP)) || ((G_Init_Start == 0) and (!G_isJIP)))) exitWith {
	G_Revive_FirstSpawn = false;
};

//BIS_fnc_respawnMenuPosition running in parallel

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

if ((G_Revive_FirstSpawn) and ((_unit getVariable "G_Lives") == G_Num_Respawns) and (((G_JIP_Start == 0) and (G_isJIP)) || ((G_Init_Start == 0) and (!G_isJIP)))) then {
	_unit setPos G_Unit_Start_Pos;
};

if (G_Squad_Leader_Spawn) then {
	if ((isNil "G_Player_Squad_Leader_Var") || (isNil "_identity")) exitWith {};
	if (G_Player_Squad_Leader_Var isEqualTo _identity) then {
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