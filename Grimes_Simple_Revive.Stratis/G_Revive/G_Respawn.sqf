//Handle onRespawn
//Local to _unit
private ["_unit"];
_unit = _this select 0;

//Set next respawn time
setPlayerRespawnTime G_Respawn_Time;

[_unit] remoteExec ["G_fnc_Revive_Actions", 0, true];

//Set system variables
_unit call G_fnc_Revive_resetVariables;
_unit setVariable ["G_Downs", 0, true];
_unit setCaptive false;
_unit setVariable ["G_Side", side _unit, true];
_unit setVariable ["G_isRenegade", false, true];
_unit enableAI "MOVE";
_unit enableAI "FSM";
_unit allowDamage true;

//Handle squad leader spawn
if (G_Squad_Leader_Spawn) then {
	//Execute in parallel because of having to wait on parallel script
	[_unit] spawn {
		private ["_unit", "_squadLeader"];
		_unit = _this select 0;
		//Make sure unit spawned on squad leader (probably landed within 10m) or time has elapsed without true
			//Code executes in 0.25, so this delay should be plenty and non-intrusive
		_timer = time;
		_squadLeader = leader group _unit;
		waitUntil {sleep 0.1; (((_squadLeader != _unit) && ((_squadLeader distance _unit) < 10)) || ((time - _timer) >= 2))};
		if ((_squadLeader != _unit) && ((_squadLeader distance _unit) < 10)) then {
			//Assume squad leader's stance
			[_unit, animationState _squadLeader] remoteExecCall ["switchMove", 0, true];
		};
	};
};

//Custom execution
if (G_Custom_Exec_3 != "") then {
	[_unit] spawn G_fnc_Custom_Exec_3;
};

if (isPlayer _unit) then {
	//Slight delay before life count announcement
	sleep 2;

	//Handle life count announcement, if limited and not the inital spawn
	private ["_lives", "_livesPlural"];
	_lives = _unit getVariable "G_Lives";
	if (_lives >= 0) then {
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
};