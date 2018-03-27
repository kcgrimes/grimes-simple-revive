private _unit 			= _this param [0,objnull,[objnull]];
private _respawnDelay 	= _this param [3, 0, [0]];

//Handle first spawn
//bug - why is this a thing? Possibly from a deprecated fix, probably can remove
if ((G_Revive_FirstSpawn) && ((_unit getVariable "G_Lives") == G_Num_Respawns) && (((G_JIP_Start == 0) && (G_isJIP)) || ((G_Init_Start == 0) && (!G_isJIP)))) exitWith {
	G_Revive_FirstSpawn = false;
};

//BIS_fnc_respawnMenuPosition running in parallel

//Set system variables
//bug - forEach loop these like in init_vars
_unit setVariable ["G_Unconscious",false,true];
_unit setVariable ["G_Dragged",false,true];
_unit setVariable ["G_Carried",false,true];
_unit setVariable ["G_Dragging",false,true];
_unit setVariable ["G_Carrying",false,true];
_unit setVariable ["G_getRevived",false,true];
_unit setVariable ["G_Reviving",false,true];
_unit setVariable ["G_Reviver",objNull,true];
_unit setVariable ["G_Loaded",objNull,true];
_unit setVariable ["G_byVehicle",false,true];
_unit setVariable ["G_Downs",0,true];
_unit setCaptive false;
_unit setVariable ["G_Side",side _unit,true];
_unit enableAI "MOVE";
_unit allowDamage true;

//Handle starting position
//bug - is this working correctly? What is it actually meant for? Might be related to FirstSpawn fix-that-is-no-longer-a-fix
if ((G_Revive_FirstSpawn) && ((_unit getVariable "G_Lives") == G_Num_Respawns) && (((G_JIP_Start == 0) && (G_isJIP)) || ((G_Init_Start == 0) && (!G_isJIP)))) then {
	_unit setPos G_Unit_Start_Pos;
};

//Handle squad leader spawn
if (G_Squad_Leader_Spawn) then {
	//Execute in parallel because of having to wait on parallel script
	[_unit] spawn {
		_unit = _this select 0;
		//Make sure squad leader exists; note that squad leader changes when unit is setUnconscious
		if (isNil "G_Player_Squad_Leader_Var") exitWith {};
		//Make sure unit spawned on squad leader (probably landed within 10m) or time has elapsed without true
			//Code executes in 0.25, so this delay should be plenty and non-intrusive
		_timer = time;
		waitUntil {(((G_Player_Squad_Leader_Var distance _unit) < 10) || ((time - _timer) >= 2))};
		if ((G_Player_Squad_Leader_Var distance _unit) < 10) then {
			//Assume squad leader's stance
			[_unit, animationState G_Player_Squad_Leader_Var] remoteExecCall ["switchMove", 0, true];
		};
	};
};

//Custom execution
if (G_Custom_Exec_3 != "") then {
	[] execVM G_Custom_Exec_3;
};

//Slight delay before life count announcement
sleep 2;

//Handle life count announcement, if limited
_lives = _unit getVariable "G_Lives";
if ((_lives >= 0) && !(G_Revive_FirstSpawn)) then {
	//Use appropriate plurality
	_livesPlural = "lives";
	if (_lives == 1) then {
		_livesPlural = "life";
	};
	//Announce life count
	titleText [format["You have %1 %2 remaining!", _lives, _livesPlural], "PLAIN", 2];
	sleep 3;
	titleFadeOut 3;
};

//First Spawn won't occur again
G_Revive_FirstSpawn = false;