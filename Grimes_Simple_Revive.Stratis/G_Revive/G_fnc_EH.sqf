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

//If is server or client's own player, define system variables and broadcast them
if (G_isServer || _specialJIP) then {
	if (G_Revive_System) then {
		//bug - consider defining in higher scope for less repetition for AI
		//Define revive-related variables based on data type
		G_Revive_boolVars = ["G_Unconscious", "G_Dragged", "G_Carried", "G_Dragging", "G_Carrying"];
		G_Revive_objVars = ["G_Reviver", "G_Reviving", "G_Loaded"];
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
		
		//Define function to reset revive variables
		G_fnc_Revive_resetVariables = {
			{
				_unit setVariable [_x, false, true];
			} forEach G_Revive_boolVars;
			{
				_unit setVariable [_x, objNull, true];
			} forEach G_Revive_objVars;
			//rescueRole - 0: none, 1: reviver, 2: guard
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
//so all other clients need to wait for definitions
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
				//Whoever the _unit is local to will execute Unconscious state publically
				if (local _unit) then {
					_unit allowDamage false;
					[_unit, _source, _projectile] execVM "G_Revive\G_Unconscious.sqf";
				};
				//Execute code for the killer
				//bug - does this need to be localized more specifically?
				[_unit, _source] execVM "G_Revive\G_Killer.sqf";
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
	
	//bug - this function should only be defined once, so move it to a higher scope than this file
	//Define function to add all revive-related 
	G_fnc_Revive_Actions = {
		_unit = _this select 0;
		_side = _unit getVariable "G_Side";
		_reviveActionID = _unit addAction [format["<t color='%1'>Revive</t>",G_Revive_Action_Color],"G_Revive\G_Revive_Action.sqf",[],1.5,true,true,"", "!(_this getVariable ""G_Unconscious"") and (_target getVariable ""G_Unconscious"") and ((_target distance _this) < 1.75) and !(_target == _this) and ((_this getVariable ""G_Side"") == (_target getVariable ""G_Side"")) and !(_target getVariable ""G_Dragged"") and !(_target getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and (isNull (_target getVariable ""G_Reviver"")) and (isNull (_this getVariable ""G_Reviving"")) and (((typeOf _this) in G_Revive_Can_Revive) or ((count G_Revive_Can_Revive) == 0)) and (isNull (_target getVariable ""G_Loaded""))"];
		_dragActionID = _unit addAction [format["<t color='%1'>Drag</t>",G_Revive_Action_Color],"G_Revive\G_Drag_Action.sqf",[],1.5,true,true,"", "!(_this getVariable ""G_Unconscious"") and (_target getVariable ""G_Unconscious"") and ((_target distance _this) < 1.75) and (_target != _this) and !(_target getVariable ""G_Dragged"") and !(_target getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and (isNull (_target getVariable ""G_Reviver"")) and (isNull (_this getVariable ""G_Reviving"")) and (isNull (_target getVariable ""G_Loaded""))"];
		_carryActionID = _unit addAction [format["<t color='%1'>Carry</t>",G_Revive_Action_Color],"G_Revive\G_Carry_Action.sqf",[],1.5,true,true,"", "!(_this getVariable ""G_Unconscious"") and (_target getVariable ""G_Unconscious"") and ((_target distance _this) < 1.75) and (_target != _this) and !(_target getVariable ""G_Carried"") and !(_target getVariable ""G_Dragged"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and (isNull (_target getVariable ""G_Reviver"")) and (isNull (_this getVariable ""G_Reviving"")) and (isNull (_target getVariable ""G_Loaded""))"];
		_loadActionID = _unit addAction [format["<t color='%1'>Load Into Vehicle</t>",G_Revive_Action_Color],"G_Revive\G_Load_Action.sqf",[_side],1.5,true,true,"", format["!(_this getVariable ""G_Unconscious"") and (_target getVariable ""G_Unconscious"") and ((_target distance _this) < 1.75) and !(_target == _this) and ((_this getVariable ""G_Side"") == (_target getVariable ""G_Side"")) and !(_target getVariable ""G_Dragged"") and !(_target getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and (isNull (_target getVariable ""G_Reviver"")) and (isNull (_this getVariable ""G_Reviving"")) and (count(nearestObjects [_target, %1, 7]) != 0) and (isNull (_target getVariable ""G_Loaded""))",G_Revive_Load_Types]];
	};
	
	//Execute function to add revive actions to unit
	[_unit] call G_fnc_Revive_Actions;
	
	//Add Respawn EH to unit to add revive actions publically
	//bug - some things are done onRespawn, like variable resetting; should they just be done here?
	_unit addEventHandler 
	[	"Respawn",
		{
			_unit = _this select 0;
			_old = _this select 1;
			[_unit] remoteExec ["G_fnc_Revive_Actions", 0, true];
		}
	];

	//Add Respawn EH specifically to AI to reset variables and the revive system
	//bug - The above EH for all units has enableSimulation too, so it is redundant to have it in this one
	if (!isPlayer _unit) then {
		_unit addEventHandler
		[	"Respawn",
			{
				_unit = _this select 0;
				_unit call G_fnc_Revive_resetVariables;
				_unit setVariable ["G_Downs",0,true];
				_unit setCaptive false;
				_unit setVariable ["G_Side",side _unit,true];
				_unit enableAI "MOVE";
				_unit enableAI "FSM";
				_unit allowDamage true;
			}
		];
	};
	
	//Define function to create revive-oriented AI behavior
	//bug - address locality, if need be
	G_fnc_Revive_AI_Behavior = {
		_unit = _this select 0; 
		//Create parallel loop to actually run the behavior
		[_unit] spawn {
			_unit = _this select 0; 
			//bug - is true the right condition here?
			while {true} do {
				//Wait to be called upon as reviver or guard
				waitUntil {sleep 5; (((_unit getVariable "G_AI_rescueRole") select 0) != 0)};
				//Execute appropriate behavior up to and including completing revive or guard function
				_rescueRoleArray = _unit getVariable "G_AI_rescueRole";
				_victim = (_unit getVariable "G_AI_rescueRole") select 1;
				//Allow AI to move more freely to victim, but still detect and engage enemies
				_unit setBehaviour "SAFE";
				//Determine assigned role
				if ((_rescueRoleArray select 0) == 1) then {
					//AI is reviver
					//Cycle behavior as long as victim is unconscious and rescuer is not, and rescuer has role
					while {((!(_unit getVariable "G_Unconscious")) && (alive _unit) && (_victim getVariable "G_Unconscious") && (alive _victim) && ((_unit getVariable "G_AI_rescueRole") isEqualTo _rescueRoleArray))} do {
						//Prevent AI from stopping
						//bug - is this stop necessary?
						_unit stop false;
						//Have regrouped AI move to victim
						_unit doMove (getPos _victim);
						//Have stopped AI move to victim
						_unit moveTo (getPos _victim);
						//If in range, perform revive action
						if ((_unit distance _victim < 2) && (isNull (_victim getVariable "G_Reviver"))) then {
							[_victim, _unit] execVM "G_Revive\G_Revive_Action.sqf";
							//Wait for revive to end one way or another
							waitUntil {((_unit getVariable "G_Unconscious") || (!(_victim getVariable "G_Unconscious")) || (!((_unit getVariable "G_AI_rescueRole") isEqualTo _rescueRoleArray)))};
						};
						sleep 3;
					};
				}
				else
				{
					//AI is guard
					//Cycle behavior as long as victim is unconscious and rescuer is not, and rescuer has role
					while {((!(_unit getVariable "G_Unconscious")) && (_victim getVariable "G_Unconscious") && ((_unit getVariable "G_AI_rescueRole") isEqualTo _rescueRoleArray))} do {
						//Prevent AI from stopping
						//bug - is this stop necessary?
						_unit stop false;
						//Have regrouped AI move to victim
						_unit doMove (getPos _victim);
						//Have stopped AI move to victim
						_unit moveTo (getPos _victim);
						//If in range, start guarding
						if (_unit distance _victim < 20) then {
							//bug - this changes behavior of entire group, which could have adverse effects
							_unit setBehaviour "AWARE";
							//Stop loop to allow "patrol"
							waitUntil {((_unit getVariable "G_Unconscious") || (!(_victim getVariable "G_Unconscious")) || (!(((_unit getVariable "G_AI_rescueRole") select 0) isEqualTo _rescueRoleArray)))};
						};
						sleep 3;
					};
				};
				//Unassigned from role, so resume previous behavior
				if (((_unit getVariable "G_AI_rescueRole") select 0) == 0) then {
					//Return to default behavior
					_unit setBehaviour "AWARE";
					//Regroup to squad leader
					_unit doFollow (leader (group _unit));
				};
			};
		};
	};
	
	//Execute revive-oriented behavior only on AI
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