//Universal EHs
private ["_specialJIP"];

_unit = _this select 0;

//bug - why is this named specialJIP?
_specialJIP = false;
if (G_isClient) then {
	if (_unit == player) then {
		//_unit is client/player executing
		_specialJIP = true;
	};
};

//Add onKilled/onRespawn EH's early in case of respawnOnStart
if (G_Revive_System) then {
	//Add onKilled EH to unit
		//onKilled EH will not trigger for respawnOnStart if there is any sleep between here and init
	_unit addEventHandler 
	[	"Killed",
		{
			[_this select 0] execVM "G_Revive\G_Killed.sqf";
		}
	];

	//Add onRespawn EH to unit to reset revive system and handle spawning
	_unit addEventHandler 
	[	"Respawn",
		{
			[_this select 0] execVM "G_Revive\G_Respawn.sqf";
		}
	];
};

//If is server or client's own player, define system variables and broadcast them
if (G_isServer || _specialJIP) then {
	if (G_Revive_System) then {
		//Set init variables if not already done, maintaining variables for JIP
		{
			if (isNil {_unit getVariable _x}) then {
				_unit setVariable [_x, false, true];
			};
		} forEach G_Revive_boolVars;
		{
			if (isNil {_unit getVariable _x}) then {
				_unit setVariable [_x, objNull, true];
			};
		} forEach G_Revive_objVars;
		if (isNil {_unit getVariable "G_AI_rescueRole"}) then {
			_unit setVariable ["G_AI_rescueRole", [0, objNull], true];
		};
	};
	//Define unit side
	if (isNil {_unit getVariable "G_Side"}) then {
		_unit setVariable ["G_Side", side _unit, true];
	};
	//Define current number of downs
	if ((G_Revive_DownsPerLife > 0) && (isNil {_unit getVariable "G_Downs"})) then {
		_unit setVariable ["G_Downs", 0, true];
	};
	//Define current number of lives
	if (isNil {_unit getVariable "G_Lives"}) then {
		_unit setVariable ["G_Lives", G_Num_Respawns, true];
	};
};

//System variables only being defined on server and client's own player,
//so all other clients need to wait for definitions with or without revive enabled
waitUntil {(!isNil {_unit getVariable "G_Lives"})};

//If revive is enabled, add the components that "make it work"
if (G_Revive_System) then {
	//Define variables used to track what is damaged with how much damage
	_unit setVariable ["selections", []];
	_unit setVariable ["gethit", []];

	//Add the HandleDamage EH to execute Unconscious state instead of death
	_unit addEventHandler 
	[	"HandleDamage",
		{
			_unit = _this select 0;
			//Define variables used to track what is damaged with how much damage, empty if undefined
			_selections = _unit getVariable ["selections", []];
			_getHit = _unit getVariable ["gethit", []];
			//Define which part was damaged
			_selection = _this select 1;
			//Define who caused the damage
			_source = _this select 3;
			//Define what caused the damage
			_projectile = _this select 4;
			//Check if damaged part is tracked and already damaged
			if !(_selection in _selections) then {
				//Damaged part not tracked, not damaged yet
				//Add damaged part to end of array
				_selections set [count _selections, _selection];
				//Add placeholder damage value to end of array
				_getHit set [count _getHit, 0];
			};
			//Get position in both arrays for subject part
			_i = _selections find _selection;
			//Get previous damage value from array
			_oldDmg = _getHit select _i;
			//Get current/incoming damage value from EH
			_curDmg = _this select 2;
			//Check if damage is fatal
			if (_curDmg >= 1) then {
				//Damage is fatal, so make it just under fatal so unit is not actually killed
				_newDmg = 0.99;
				_unit allowDamage false;
				_unit spawn G_fnc_unconsciousState;
				//Execute code for the killer
				//bug - does this need to be localized more specifically?
				[_unit, _source] spawn G_fnc_onKill;
				//Output new (total) damage value
				_newDmg;
			}
			else
			{
				//Damage is not fatal, handle normally without modification
				_getHit set [_i, _curDmg];
				_curDmg;
			};
		}
	];
	
	//Execute function to add revive actions to unit
	[_unit] call G_fnc_Revive_Actions;
	
	//Execute revive-oriented behavior only on AI
	//bug - what if player leaves playable slot, leaving AI in place?
	if (!isPlayer _unit) then {
		[_unit] spawn G_fnc_Revive_AI_Behavior;
	};
};

//If AI Fixed Spawn is defined, add Respawn EH to setPos the AI on respawn
if (G_AI_Fixed_Spawn) then {
	if (!isPlayer _unit) then {
		_unit addEventHandler 
		[	"Respawn",
			{
				private ["_respawnPos"];
				//Define AI's fixed respawn position based on side
				switch (side (_this select 0)) do {
					case WEST: {
						if (G_AI_Fixed_Spawn_WEST != "") then {
							_respawnPos = getMarkerPos G_AI_Fixed_Spawn_WEST; 
						};
					};
					case EAST: {
						if (G_AI_Fixed_Spawn_EAST != "") then {
							_respawnPos = getMarkerPos G_AI_Fixed_Spawn_EAST; 
						};
					};
					case RESISTANCE: {
						if (G_AI_Fixed_Spawn_GUER != "") then {
							_respawnPos = getMarkerPos G_AI_Fixed_Spawn_GUER; 
						};
					};
					case CIVILIAN: {
						if (G_AI_Fixed_Spawn_CIV != "") then {
							_respawnPos = getMarkerPos G_AI_Fixed_Spawn_CIV; 
						};
					};
				};
				//Wait until the unit is alive (has spawned)
				waitUntil {alive (_this select 0)};
				//Immediatly move unit to desired respawn position
				(_this select 0) setPos _respawnPos;
			}
		];
	};
};

//Add Respawn EH to all units to handle Unit Tags on respawn, if enabled
if (G_Unit_Tag) then {
	_unit addEventHandler 
	[	"Respawn",
		{
			_unit = _this select 0;
			_old = _this select 1;
			//Obtain unit tag number from old object
			_num = _old getVariable "G_Unit_Tag_Number";
			//Add unit tag number to new object and broadcast
			_unit setVariable ["G_Unit_Tag_Number", _num, true];
			//Add unit and tag number to player list
			(G_Unit_Tags_Logic getVariable "G_Revive_Player_List") set [_num, _unit];
			//Obtain complete local player list
			_var = G_Unit_Tags_Logic getVariable "G_Revive_Player_List";
			//Broadcast player list
			G_Unit_Tags_Logic setVariable ["G_Revive_Player_List", _var, true];
			//Handle display of Unit Tags depending on setting
			if (G_Unit_Tag_Display != 0) then {
				//bug - is this spawn necessary? 
				[_unit, _num] spawn {
					_unit = _this select 0;
					_num = _this select 1;
					//Wait for variable broadcasts
					sleep 1;
					[_unit, _num] remoteExec ["G_fnc_Unit_Tag_Exec", 0, true];
				};
			};
		}
	];
};