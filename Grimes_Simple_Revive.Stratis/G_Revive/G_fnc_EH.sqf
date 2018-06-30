//Universal EHs
//Local to executor, not necessarily _unit
params ["_unit"];

//Add onKilled/onRespawn EH's early in case of respawnOnStart
//Add onKilled EH to unit to handle life count
	//onKilled EH will not trigger for respawnOnStart if there is any sleep between here and init
_unit addEventHandler ["Killed", {
	[_this select 0] spawn G_fnc_onKilled;
}];

//Add onRespawn EH to unit to reset various variables/systems and handle spawning
_unit addEventHandler ["Respawn", {
	[_this select 0] spawn G_fnc_onRespawn;;
}];

//If unit is local (AI or own player), define system variables and broadcast them
if (local _unit) then {
	if (G_Revive_System) then {
		//These variables are needed even if excluded, specifically for non-revive components like MRV
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
		//Define unassigned AI rescue role
		if (isNil {_unit getVariable "G_AI_rescueRole"}) then {
			_unit setVariable ["G_AI_rescueRole", [0, objNull], true];
		};
		//Define current number of downs
		if (isNil {_unit getVariable "G_Downs"}) then {
			_unit setVariable ["G_Downs", 0, true];
		};
	};
	//Define unit side
	if (isNil {_unit getVariable "G_Side"}) then {
		_unit setVariable ["G_Side", side _unit, true];
	};
	//Define unit renegade status
	if (isNil {_unit getVariable "G_isRenegade"}) then {
		_unit setVariable ["G_isRenegade", false, true];
	};
	//Define current number of lives
	if (isNil {_unit getVariable "G_Lives"}) then {
		_unit setVariable ["G_Lives", G_Num_Respawns, true];
	};
};

//System variables only being defined on AI/player where local,
//so all other machines need to wait for definitions
waitUntil {(!isNil {_unit getVariable "G_Lives"})};

//Handle rating detection for object variable G_isRenegade
_unit addEventHandler ["HandleRating", {
	//Local to _unit
	params ["_unit", "_ratingAdded"];
	//Check if rating exceeds renegade limit
	if (((rating _unit) + _ratingAdded) < -2000) then {
		//Is renegade, so set variable as such if not already done
		if (!(_unit getVariable "G_isRenegade")) then {
			_unit setVariable ["G_isRenegade", true, true];
		};
	}
	else
	{
		//Is no longer renegade, so set variable as such if not already done
		if (_unit getVariable "G_isRenegade") then {
			_unit setVariable ["G_isRenegade", false, true];
		};
	};
	//Return normal value
	_ratingAdded
}];

//If revive is enabled, add the components that "make it work"
if ((G_Revive_System) && (!(_unit in G_Revive_Unit_Exclusion))) then {
	//Define variables used to track what is damaged with how much damage
	_unit setVariable ["selections", []];
	_unit setVariable ["gethit", []];

	//Add the HandleDamage EH to execute Incapacitated state instead of death
	_unit addEventHandler 
	[	"HandleDamage",
		{
			//Local to executor, not necessarily _unit
			//Define unit, which part was damaged, the incoming damage value from the EH, and who caused the damage
			params ["_unit", "_selection", "_curDmg", "_source"];
			//Check if damage is to critical body part
			if !(_selection in ["arms", "hands", "legs"]) then {
				//Critical body part, so check if damage is fatal
				if (_curDmg >= 1) then {
					//Damage is fatal, so make it just under fatal so unit is not actually killed
					private _newDmg = 0.99;
					//Whoever _unit is local to will execute Incapacitated state publically
					if (local _unit) then {
						_unit allowDamage false;
						_unit spawn G_fnc_enterIncapacitatedState;
						//Execute code for the killer
						[_unit, side _unit, _source] spawn G_fnc_onKill;
					};
					//Output new, non-fatal damage value
					_newDmg;
				}
				else
				{
					//Damage is not fatal, handle normally without modification
					_curDmg;
				};
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
		_unit addEventHandler ["Respawn", {
			params ["_unit"];
			private ["_respawnPos"];
			//Define AI's fixed respawn position based on side
			switch (side _unit) do {
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
					if (G_AI_Fixed_Spawn_IND != "") then {
						_respawnPos = getMarkerPos G_AI_Fixed_Spawn_IND; 
					};
				};
				case CIVILIAN: {
					if (G_AI_Fixed_Spawn_CIV != "") then {
						_respawnPos = getMarkerPos G_AI_Fixed_Spawn_CIV; 
					};
				};
			};
			//Wait until the unit is alive (has spawned)
			waitUntil {alive _unit};
			//Immediatly move unit to desired respawn position
			_unit setPos _respawnPos;
		}];
	};
};