//Universal definitions for EHs and more
//Local to executor

//Define revive-related variables based on data type
G_Revive_boolVars = ["G_Unconscious", "G_Dragged", "G_Carried", "G_Dragging", "G_Carrying"];
G_Revive_objVars = ["G_Reviver", "G_Reviving", "G_Loaded"];

//Define function to reset revive variables and broadcast them
G_fnc_Revive_resetVariables = {
	private ["_unit"];
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

//Define Unconscious-state script
G_fnc_unconsciousState = compile preprocessFileLineNumbers "G_Revive\G_Unconscious.sqf";
//Define onKill script
G_fnc_onKill = compile preprocessFileLineNumbers "G_Revive\G_Killer.sqf";
//Define onKilled script
G_fnc_onKilled = compile preprocessFileLineNumbers "G_Revive\G_Killed.sqf";
//Define onRespawn script
G_fnc_onRespawn = compile preprocessFileLineNumbers "G_Revive\G_Respawn.sqf";

//Define revive-related actions
G_fnc_actionRevive = compile preprocessFileLineNumbers "G_Revive\G_Revive_Action.sqf";
G_fnc_actionDrag = compile preprocessFileLineNumbers "G_Revive\G_Drag_Action.sqf";
G_fnc_actionCarry = compile preprocessFileLineNumbers "G_Revive\G_Carry_Action.sqf";
G_fnc_actionLoad = compile preprocessFileLineNumbers "G_Revive\G_Load_Action.sqf";
G_fnc_actionUnload = compile preprocessFileLineNumbers "G_Revive\G_Unload_Action.sqf";
G_fnc_actionDrop = compile preprocessFileLineNumbers "G_Revive\G_Drop_Action.sqf";

//Define function to check common conditions in revive-related actions
G_fnc_Revive_Actions_Cond = {
	params ["_target", "_this"];
	((_target != _this) && !(_this getVariable "G_Unconscious") && (_target getVariable "G_Unconscious") && ((_target distance _this) < 1.75) && !(_target getVariable "G_Dragged") && !(_target getVariable "G_Carried") && !(_this getVariable "G_Carrying") && !(_this getVariable "G_Dragging") && (isNull (_target getVariable "G_Reviver")) && (isNull (_this getVariable "G_Reviving")) && (isNull (_target getVariable "G_Loaded")))
};

//Define function to add all revive-related actions
G_fnc_Revive_Actions = {
	private ["_unit", "_side", "_reviveActionID", "_dragActionID", "_carryActionID", "_loadActionID"];
	_unit = _this select 0;
	_side = _unit getVariable "G_Side";
	_reviveActionID = _unit addAction [format["<t color='%1'>Revive</t>", G_Revive_Action_Color], G_fnc_actionRevive, [], 1.5, true, true, "", "(([_target, _this] call G_fnc_Revive_Actions_Cond) && ((_this getVariable ""G_Side"") == (_target getVariable ""G_Side"")) && (((typeOf _this) in G_Revive_Can_Revive) or ((count G_Revive_Can_Revive) == 0)))"];
	_unit setUserActionText [_reviveActionID, format["<t color='%1'>Revive</t>", G_Revive_Action_Color], "", "<img image='\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa' size='3' shadow='2'/>"];
	_dragActionID = _unit addAction [format["<t color='%1'>Drag</t>", G_Revive_Action_Color], G_fnc_actionDrag, [], 1.5, true, true, "", "(([_target, _this] call G_fnc_Revive_Actions_Cond) && ((eyePos _target select 2) > 0))"];
	_carryActionID = _unit addAction [format["<t color='%1'>Carry</t>", G_Revive_Action_Color], G_fnc_actionCarry, [], 1.5, true, true, "", "(([_target, _this] call G_fnc_Revive_Actions_Cond) && ((eyePos _target select 2) > 0))"];
	_loadActionID = _unit addAction [format["<t color='%1'>Load Into Vehicle</t>", G_Revive_Action_Color], G_fnc_actionLoad, [_side], 1.5, true, true, "", format["(([_target, _this] call G_fnc_Revive_Actions_Cond) && ((_this getVariable ""G_Side"") == (_target getVariable ""G_Side"")) && (count(nearestObjects [_target, %1, 7]) != 0))", G_Revive_Load_Types]];
	_unit setUserActionText [_loadActionID, format["<t color='%1'>Load Into Vehicle</t>", G_Revive_Action_Color], "", "<img image='\A3\ui_f\data\igui\cfg\actions\unloadIncapacitated_ca.paa' size='3' shadow='2'/>"];
};

//Define function to create revive-oriented AI behavior
G_fnc_Revive_AI_Behavior = {
	private ["_unit", "_rescueRoleArray", "_victim"];
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
			private ["_distCount"];
			_distCount = 0;
			while {((!(_unit getVariable "G_Unconscious")) && (alive _unit) && (_victim getVariable "G_Unconscious") && (alive _victim) && ((_unit getVariable "G_AI_rescueRole") isEqualTo _rescueRoleArray))} do {
				//Prevent AI from stopping
				//bug - is this stop necessary?
				_unit stop false;
				//Have regrouped AI move to victim
				_unit doMove (getPos _victim);
				//Have stopped AI move to victim
				_unit moveTo (getPos _victim);
				//Fix for AI getting "stuck" near objects or unable to reach victim:
				//If close, add a point until it has been long enough, then setPos to victim
				if ((_unit distance _victim < 7) && (isNull (_victim getVariable "G_Reviver"))) then {
					_distCount = _distCount + 1;
				};
				if (_distCount > 9) then {
					_unit setPos (getPos _victim);
				};
				//If in range, perform revive action
				if ((_unit distance _victim < 2) && (isNull (_victim getVariable "G_Reviver"))) then {
					[_victim, _unit] spawn G_fnc_actionRevive;
					//Wait for revive to end one way or another
					waitUntil {((_unit getVariable "G_Unconscious") || (!(_victim getVariable "G_Unconscious")) || (!((_unit getVariable "G_AI_rescueRole") isEqualTo _rescueRoleArray)))};
				};
				sleep 2;
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
				if (_unit distance _victim < 10) then {
					//Have regrouped AI reset move
					_unit doMove (getPos _unit);
					//Have stopped AI reset move
					_unit moveTo (getPos _unit);
					//Increase awareness
					//bug - this changes behavior of entire group, which could have adverse effects
					_unit setBehaviour "AWARE";
					//Stop loop to allow "patrol"
					waitUntil {((_unit getVariable "G_Unconscious") || (!(_victim getVariable "G_Unconscious")) || (!(((_unit getVariable "G_AI_rescueRole") select 0) isEqualTo _rescueRoleArray)))};
				};
				sleep 2;
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
			//Allow time for commands to settle
			sleep 1;
			//Regroup to squad leader
			_unit doFollow (leader _unit);
		};
	};
};

//Define function that handles Load/Unload of player
G_fnc_moveInCargoToUnloadAction = {
	private ["_unit", "_vehicle", "_side", "_unloadActionID"];
	_unit = _this select 0;
	_vehicle = _this select 1;
	_side = _this select 2;
	
	if (local _unit) then {
		//Command AI to stay in vehicle
		_unit assignAsCargo _vehicle;
		//Move unit into vehicle
		_unit moveInCargo _vehicle;
		//Wait for unit to be in vehicle before executing animation to prevent wrong animation
		waitUntil {sleep 0.1; (vehicle _unit != _unit)};
		//Perform Unconscious animation manually due to lack of setUnconscious support in vehicle
			//This should have global effect, but does not, so it is here and broaadcasted
		[_unit, "Unconscious"] remoteExec ["playAction", 0, true];
		//Set vehicle side to unit's side for action condition
		//bug - is this reset later? 
		_vehicle setVariable ["G_Side", _unit getVariable "G_Side", true];
	};
	
	//Add Unload action for unit to vehicle
	_unloadActionID = _vehicle addAction [format["<t color=""%2"">Unload %1</t>", name _unit, G_Revive_Action_Color], G_fnc_actionUnload, [_unit], 10.2, true, true, "", "((_this getVariable ""G_Side"") == (_target getVariable ""G_Side"")) && ((_target distance _this) < 5) and ((speed _target) < 1)"];
	_vehicle setUserActionText [_unloadActionID, format["<t color=""%2"">Unload %1</t>", name _unit, G_Revive_Action_Color], "", "<img image='\A3\ui_f\data\igui\cfg\actions\unloadIncapacitated_ca.paa' size='3' shadow='2'/>"];
	
	//Create parallel loop to handle Unload action if unit dies, and also if no longer loaded
	[_unit, _vehicle, _unloadActionID] spawn {
		private ["_unit", "_vehicle", "_unloadActionID"];
		_unit = _this select 0;
		_vehicle = _this select 1;
		_unloadActionID = _this select 2;
		//Wait for unit to be unloaded or no longer unconscious
		waitUntil {sleep 0.3; ((vehicle _unit != _vehicle) || (isNull (_unit getVariable "G_Loaded")) || (!(_unit getVariable "G_Unconscious")))};
		
		//Remove the Unload action from the vehicle
		_vehicle removeAction _unloadActionID;
		
		//Handle BIS Revive's Unload action
		//Allow animation to set to prevent other animation executing too early
		sleep 3;
		
		//Make sure unit is not loaded and broadcast
		if (local _unit) then {
			if (!isNull (_unit getVariable "G_Loaded")) then {
				//BIS Revive's Unload action was used
				_unit setVariable ["G_Loaded", objNull, true];
			};
		};
	};
};

//Define player-only incapacitation dialog
if (G_isClient) then {
	//Define function for "nearest rescuer" text
	G_fnc_Dialog_Rescuer_Text = {
		[_this select 0] spawn {
			private ["_array", "_arrayDistance", "_unit0", "_unit1", "_unit2", "_unit3", "_unit4", "_text"];
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
		private ["_downs", "_lives", "_text"];
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

//Define player-only function for addon radio handling
if (G_isClient) then {
	//Determine whether to modify TFAR or ACRE2
	if (isClass (configFile >> "CfgPatches" >> "task_force_radio")) then {
		//Define function to handle TFAR
		G_fnc_muteAddonRadio = {
			//_this select 0 is local player
			//Check if muting or unmuting
			if (_this select 0) then {
				if (G_Revive_addonRadio_muteReceive) then {
					//Save current volume
					player setVariable ["G_save_tf_globalVolume", player getVariable ["tf_globalVolume", 1]];
					//Mute local radio volume
					player setVariable ["tf_globalVolume", 0], true;
				};
				if (G_Revive_addonRadio_muteTransmit) then {
					//Prevent transmission
					player setVariable ["tf_unable_to_use_radio", true, true];
				};
			}
			else
			{
				if (G_Revive_addonRadio_muteReceive) then {
					//Resume previous volume
					player setVariable ["tf_globalVolume", player getVariable ["G_save_tf_globalVolume", 1], true];
				};
				if (G_Revive_addonRadio_muteTransmit) then {
					//Allow transmission
					player setVariable ["tf_unable_to_use_radio", false, true];
				};
			};
		};
	}
	else
	{
		//Define function to handle ACRE2
		G_fnc_muteAddonRadio = {
			//_this select 0 is local player
			//Check if muting or unmuting
			if (_this select 0) then {
				if (G_Revive_addonRadio_muteReceive) then {
					//Save current volume
					player setVariable ["G_save_acreVolume", [] call acre_api_fnc_getGlobalVolume];
					//Mute radio volume
					[0] call acre_api_fnc_setGlobalVolume;
				};
				if (G_Revive_addonRadio_muteTransmit) then {
					//Prevent transmission
					player setVariable ["acre_sys_core_isDisabled", true, true];
				};
			}
			else
			{
				if (G_Revive_addonRadio_muteReceive) then {
					//Resume previous volume
					[player getVariable ["G_save_acreVolume", 1]] call acre_api_fnc_setGlobalVolume;
				};
				if (G_Revive_addonRadio_muteTransmit) then {
					//Allow transmission
					player setVariable ["acre_sys_core_isDisabled", false, true];
				};
			};
		};
	};
};