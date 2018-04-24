//Universal definitions for EHs and more

_unit = _this select 0;

//Define revive-related variables based on data type
G_Revive_boolVars = ["G_Unconscious", "G_Dragged", "G_Carried", "G_Dragging", "G_Carrying"];
G_Revive_objVars = ["G_Reviver", "G_Reviving", "G_Loaded"];

//Define function to reset revive variables and broadcast them
G_fnc_Revive_resetVariables = {
	_unit = _this;
	{
		_unit setVariable [_x, false, true];
	} forEach G_Revive_boolVars;
	{
		_unit setVariable [_x, objNull, true];
	} forEach G_Revive_objVars;
	//rescueRole - 0: none, 1: reviver, 2: guard
	_unit setVariable ["G_AI_rescueRole", [0, objNull], true];
};

G_fnc_actionRevive = compile preprocessFileLineNumbers "G_Revive\G_Revive_Action.sqf";
G_fnc_actionDrag = compile preprocessFileLineNumbers "G_Revive\G_Drag_Action.sqf";
G_fnc_actionCarry = compile preprocessFileLineNumbers "G_Revive\G_Carry_Action.sqf";
G_fnc_actionLoad = compile preprocessFileLineNumbers "G_Revive\G_Load_Action.sqf";
G_fnc_actionUnload = compile preprocessFileLineNumbers "G_Revive\G_Unload_Action.sqf";
G_fnc_actionDrop = compile preprocessFileLineNumbers "G_Revive\G_Drop_Action.sqf";

//Define function to add all revive-related actions
G_fnc_Revive_Actions = {
	_unit = _this select 0;
	_side = _unit getVariable "G_Side";
	_reviveActionID = _unit addAction [format["<t color='%1'>Revive</t>", G_Revive_Action_Color], G_fnc_actionRevive, [], 1.5, true, true, "", "!(_this getVariable ""G_Unconscious"") and (_target getVariable ""G_Unconscious"") and ((_target distance _this) < 1.75) and !(_target == _this) and ((_this getVariable ""G_Side"") == (_target getVariable ""G_Side"")) and !(_target getVariable ""G_Dragged"") and !(_target getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and (isNull (_target getVariable ""G_Reviver"")) and (isNull (_this getVariable ""G_Reviving"")) and (((typeOf _this) in G_Revive_Can_Revive) or ((count G_Revive_Can_Revive) == 0)) and (isNull (_target getVariable ""G_Loaded""))"];
	_dragActionID = _unit addAction [format["<t color='%1'>Drag</t>", G_Revive_Action_Color], G_fnc_actionDrag, [], 1.5, true, true, "", "!(_this getVariable ""G_Unconscious"") and (_target getVariable ""G_Unconscious"") and ((_target distance _this) < 1.75) and (_target != _this) and !(_target getVariable ""G_Dragged"") and !(_target getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and (isNull (_target getVariable ""G_Reviver"")) and (isNull (_this getVariable ""G_Reviving"")) and (isNull (_target getVariable ""G_Loaded"")) and ((eyePos _target select 2) > 0)"];
	_carryActionID = _unit addAction [format["<t color='%1'>Carry</t>", G_Revive_Action_Color], G_fnc_actionCarry, [], 1.5, true, true, "", "!(_this getVariable ""G_Unconscious"") and (_target getVariable ""G_Unconscious"") and ((_target distance _this) < 1.75) and (_target != _this) and !(_target getVariable ""G_Carried"") and !(_target getVariable ""G_Dragged"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and (isNull (_target getVariable ""G_Reviver"")) and (isNull (_this getVariable ""G_Reviving"")) and (isNull (_target getVariable ""G_Loaded"")) and ((eyePos _target select 2) > 0)"];
	_loadActionID = _unit addAction [format["<t color='%1'>Load Into Vehicle</t>", G_Revive_Action_Color], G_fnc_actionLoad, [_side], 1.5, true, true, "", format["!(_this getVariable ""G_Unconscious"") and (_target getVariable ""G_Unconscious"") and ((_target distance _this) < 1.75) and !(_target == _this) and ((_this getVariable ""G_Side"") == (_target getVariable ""G_Side"")) and !(_target getVariable ""G_Dragged"") and !(_target getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and (isNull (_target getVariable ""G_Reviver"")) and (isNull (_this getVariable ""G_Reviving"")) and (count(nearestObjects [_target, %1, 7]) != 0) and (isNull (_target getVariable ""G_Loaded""))", G_Revive_Load_Types]];
};

//Define function to create revive-oriented AI behavior
G_fnc_Revive_AI_Behavior = {
	_unit = _this select 0; 
	//Create parallel loop to actually run the behavior
	[_unit] spawn {
		_unit = _this select 0; 
		//bug - is true the right condition here?
		while {true} do {
			//Wait for AI to be local
			waitUntil {sleep 5; (local _unit)};
			//Wait to be called upon as reviver or guard
			waitUntil {sleep 5; (((_unit getVariable "G_AI_rescueRole") select 0) != 0)};
			//Execute appropriate behavior up to and including completing revive or guard function
			_rescueRoleArray = _unit getVariable "G_AI_rescueRole";
			_victim = (_unit getVariable "G_AI_rescueRole") select 1;
			//Allow AI to move more freely to victim, but still detect and engage enemies
			_unit setBehaviour "SAFE";
			_unit disableAI "TARGET";
			_unit disableAI "SUPPRESSION";
			_unit disableAI "COVER";
			_unit disableAI "AUTOCOMBAT";
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
						[_victim, _unit] spawn G_fnc_actionRevive;
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
				_unit enableAI "TARGET";
				_unit enableAI "SUPPRESSION";
				_unit enableAI "COVER";
				_unit enableAI "AUTOCOMBAT";
				_unit setBehaviour "AWARE";
				//Regroup to squad leader
				_unit doFollow (leader (group _unit));
			};
		};
	};
};

//Define function that handles Load/Unload of player
G_fnc_moveInCargoToUnloadAction = {
	_unit = _this select 0;
	_vehicle = _this select 1;
	_side = _this select 2;
	
	//Command AI to stay in vehicle
	_unit assignAsCargo _vehicle;
	//Move unit into vehicle
	_unit moveInCargo _vehicle;
	//Perform DeadState animation due to lack of Unconscious anim in vehicle
	//bug - check locality
	[_unit, "Unconscious"] remoteExecCall ["playAction", 0, true];
	//Set vehicle side to unit's side for action condition
	//bug - is this reset later? 
	_vehicle setVariable ["G_Side", _unit getVariable "G_Side", true];
	
	//Add Unload action for unit to vehicle
	_unloadActionID = _vehicle addAction [format["<t color=""%2"">Unload %1</t>", name _unit, G_Revive_Action_Color], G_fnc_actionUnload, [_unit], 1.5, true, true, "", "((_this getVariable ""G_Side"") == (_target getVariable ""G_Side"")) && ((_target distance _this) < 5) and ((speed _target) < 1)"];
	
	//Create parallel loop to monitor Unload action
	//bug - can this not just be accomplished in the Unload script, instead of cycling?
	[_unit, _vehicle, _unloadActionID] spawn {
		_unit = _this select 0;
		_vehicle = _this select 1;
		_unloadActionID = _this select 2;
		//Wait for unit to be unloaded or no longer unconscious
		waitUntil {sleep 0.3; ((isNull (_unit getVariable "G_Loaded")) || (!(_unit getVariable "G_Unconscious")))};
		
		//Remove the Unload action from the vehicle
		_vehicle removeAction _unloadActionID;
	};
};

//Define player-only incapacitation dialog
if (G_isClient) then {
	//Define function for "nearest rescuer" text
	G_fnc_Dialog_Rescuer_Text = {
		[_this select 0] spawn {
			private ["_array", "_arrayDistance","_unit0","_unit1","_unit2","_unit3","_unit4"];
			//Continue cycling while player is unconscious and dialog is open
			while {((player getVariable "G_Unconscious") && (dialog))} do {
				//Get array of all "men" within 500m, including player
				_array = nearestObjects [player, ["CAManBase"], 500];
				_arrayDistance = [];
				{
					//Select unit that is not player, is friendly, can revive (or setting undefined), is alive, and is not unconscious
					if ((_x != player) && ((player getVariable "G_Side") == (_x getVariable "G_Side")) && (((typeOf _x) in G_Revive_Can_Revive) || ((count G_Revive_Can_Revive) == 0)) && (alive _x) && !(_x getVariable "G_Unconscious")) then {
						//Add to array with distance from player
						_arrayDistance pushBack ([_x, ceil(_x distance player)]);
					};
				} forEach _array;
				
				//Define empty variables for unit names
				_unit0 = "";
				_unit1 = "";
				_unit2 = "";
				_unit3 = "";
				_unit4 = "";
				
				//Define unit variables with unit name and distanace if available
				for "_i" from 0 to (((count _arrayDistance) - 1) min 4) do {
					call compile format["_unit%1 = format[""%2  (%3m)"", name (_arrayDistance select %1 select 0), _arrayDistance select %1 select 1];", _i, "%1", "%2"];
				};
				
				//Format text to be displayed
				_text = format["\n     Nearest Potential Rescuers:\n     %1\n     %2\n     %3\n     %4\n     %5", _unit0, _unit1, _unit2, _unit3, _unit4];
				//Output nearest rescuers
				((_this select 0) displayCtrl 1001) ctrlSetText _text;
				//Update list every 5 seconds
				sleep 5;
			};
		};
	};
	
	//Define function for "downs/lives remaining" text
	G_fnc_Dialog_Downs_Text = {
		private ["_downs", "_lives"];
		//If downs-per-life is limited, display remaining, otherwise text
		if (G_Revive_DownsPerLife > 0) then {
			//Subtract accrued number of downs from the limit to obtain remainder
			_downs = G_Revive_DownsPerLife - (player getVariable "G_Downs");
		}
		else
		{
			_downs = "Unlimited";
		};
		
		//If number of lives is limited, display remaining, otherwise text
		if (G_Num_Respawns == -1) then {
			_lives = "Unlimited";
		}
		else
		{
			_lives = player getVariable "G_Lives";
		};
		//Format text to be displayed
		_text = format["\n\n            Downs Remaining: %1\n            Lives Remaining: %2", _downs, _lives];
		//Display the "lives remaining" dialog"
		((_this select 0) displayCtrl 1002) ctrlSetText _text;
	};
};