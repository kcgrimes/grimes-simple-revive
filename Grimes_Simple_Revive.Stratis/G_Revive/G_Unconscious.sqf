private ["_reviveTimer"];
	
_unit = _this select 0;
_source = _this select 1;
_projectile = _this select 2;

//If the unit is already unconscious or is not local to the executer, and is not JIP, exit
if (((_unit getVariable "G_Unconscious") || !(local _unit)) && (!G_isJIP)) exitWith {};

//Broadcast unconscious-state animation
_unit setUnconscious true;

//Prepare to add mock delay to revive actions to prevent animation failures
_unit setVariable ["G_Dragged", true, true];

//Set unit as unconscious and broadcast
_unit setVariable ["G_Unconscious", true, true];

//Add parallel delay to revive-related actions
[_unit] spawn {
	_unit = _this select 0;
	sleep 2.5;
	//Set unit as unconscious and broadcast
	_unit setVariable ["G_Dragged", false, true];
};

//Disable collision of the incapacitated unit with all other units
	//Without this, incapacitated can be kicked around
	//bug - is the locality here ok, or does there need to be a broadcast?
{
	_unit disableCollisionWith _x;
} forEach allUnits;

//Handle unit if inside vehicle
_bypass = false;
//If already Loaded, define vehicle that unit is in
_vehicle = _unit getVariable "G_Loaded";
if ((vehicle _unit != _unit) || (!isNull _vehicle)) then {
	//Unit is unconscious inside a vehicle
	//If not yet Loaded, define vehicle that unit is going unconscious in
	if (isNull _vehicle) then {
		_vehicle = vehicle _unit;
	};
	
	//Check if vehicle is alive
	if (alive _vehicle) then {
		//Vehicle is alive, so unit is already "Loaded", so set accordingly
		_unit setVariable ["G_Loaded", _vehicle, true];
		[_unit, _vehicle, side _unit] remoteExecCall ["G_fnc_moveInCargoToUnloadAction", 0, true];
		
		//If killed units should be ejected, handle accordingly
		if (G_Eject_Occupants) then {
			//Remove unit from vehicle
			_unit setVariable ["G_Loaded", objNull, true];
			unassignVehicle _unit;
			_unit setPos (_unit modelToWorldVisual [-2,0,0]);
			//Allow time for animation to get set
			sleep 1.5;
			//Allow more time for animation if coming from Air vehicle
			//bug - why?
			if (_vehicle isKindOf "Air") then {
				sleep 1.5;
			};
		};
	}
	else
	{
		//Vehicle is destroyed
		//If eject on explosion is disabled, exit this scope and kill
		if (!G_Explosion_Eject_Occupants) exitWith {_bypass = true};
		//Eject on explosion is enabled, so eject
		//If in Air vehicle, wait for it to be nearly stopped and nearly crashed
		if (_vehicle isKindOf "Air") then {
			waitUntil {(((speed _vehicle) < 3) and (((getPos _vehicle) select 2) < 10))};
		};
		//Remove unit from vehicle
		_unit setVariable ["G_Loaded", objNull, true];
		unassignVehicle _unit;
		_unit setPos (_unit modelToWorldVisual [-2,0,0]);
		//Wait for game to catch up
		sleep 1.5;
		//Allow more time for animation if coming from Air vehicle
		//bug - why?
		if (_vehicle isKindOf "Air") then {
			sleep 1.5;
		};
	};
}
else
{
	//Unit unconscious outside vehicle, give time for ragdoll animation
	sleep 3;
};

//Handle bypassing Unconscious based on downs per life
//bug - should this be done in the HandleDamage EH before Unconscious is even executed? Probably.
if (G_Revive_DownsPerLife > 0) then {
	//Add 1 to current down count
	_downCount = (_unit getVariable "G_Downs") + 1;
	//Activate bypass if DownsPerLife is exceeded
	if (_downCount > G_Revive_DownsPerLife) exitWith {
		_bypass = true;
	};
	//Set new down count and broadcast
	_unit setVariable ["G_Downs", _downCount, true];
};

//If bypass is activated, set not Unconscious, kill, and proceed to onKilled
if (_bypass) exitWith {
	_unit setVariable ["G_Loaded", objNull, true];
	_unit setVariable ["G_Unconscious", false, true];
	//Enable collision of the incapacitated unit with all other units
		//bug - is the locality here ok, or does there need to be a broadcast?
	{
		_unit enableCollisionWith _x;
	} forEach allUnits;
	_unit setDamage 1;
};

//Black out the screen with text for unconscious player
if (isPlayer _unit) then {
	//Disable keyboard/mouse input
	disableUserInput true;
	//Black out the screen
	titleText ["","BLACK", 1]; 
	if (!G_Revive_Black_Screen) then {
		//Run in parallel because of suspension
		[] spawn {
			sleep 3;
			//Display unconscious announcement text for a few seconds
			titleText ["You are Unconscious. Wait for teammate to revive you.", "BLACK IN", 4]; 
		};
	};
};

//Define revive factors
_unit setVariable ["G_Revive_Factors", [_unit, _source, _projectile], true];

//Create unconscious dialog for player
//bug - check locality for this, make sure only be executed on one machine
if (isPlayer _unit) then {
	[_unit] spawn {
		_unit = _this select 0;
		//Wait a few seconds before opening dialog
		sleep 3.25;
		while {(_unit getVariable "G_Unconscious")} do {
			//Open dialog
			_reviveDialog = createDialog "G_Revive_Dialog";
			if (!G_Allow_GiveUp) then {
				((findDisplay 474637) displayCtrl 1600) ctrlShow false;
			};
			//Wait for dialog to be open
			waitUntil {!isNull (findDisplay 474637)};
			//Wait for dialog to be closed (by Escape)
			waitUntil {!dialog};
			//Give player time to access game menu before re-cycling
			sleep 5;
		};
	};
};

//Reenable keyboard/mouse input for player
if (isPlayer _unit) then {
	disableUserInput false;
};

//Prevent AI movement
_unit disableAI "MOVE";
//Prevent scripted AI responses (such as exiting immobile vehicle)
_unit disableAI "FSM";
//Prevent being further engaged by enemies
_unit setCaptive true;

//Custom execution
if (G_Custom_Exec_1 != "") then {
	[] execVM G_Custom_Exec_1;
};

//Wait for game to catch up
//bug - why sleep here?
sleep 2.5;

_reviveTimer = G_Revive_Time_Limit;
//Check if revive timer is unlimited
if (_reviveTimer > -1) then {
	//Revive timer is limited
	//Cycle count in unconscious state so long as unit is unconscious, not timed out, is alive, and is still local to the executor
	//bug - why the local check? 
	while {(_unit getVariable "G_Unconscious") && (_reviveTimer > 0) && (alive _unit) && (local _unit)} do 
	{
		//If unit is not currently being revived, count down
		if !(_unit getVariable "G_getRevived") then {
			_reviveTimer = _reviveTimer - 1;
		};
		//Handle vehicle if unit is in one
		_breakOut = false;
		if (!isNull (_unit getVariable "G_Loaded")) then {
			//Unit in a vehicle
			if (!alive (_unit getVariable "G_Loaded")) then {
				//Vehicle is destroyed
				if (G_Explosion_Eject_Occupants) then {
					//Eject on explosion is enabled, so eject
					//If in Air vehicle, wait for it to be nearly stopped and nearly crashed
					if (_vehicle isKindOf "Air") then {
						waitUntil {(((speed _vehicle) < 3) and (((getPos _vehicle) select 2) < 10))};
					};
					//Remove unit from vehicle
					_unit setVariable ["G_Loaded", objNull, true];
					unassignVehicle _unit;
					_unit setPos (_unit modelToWorldVisual [-2,0,0]);
					//Wait for game to catch up
					sleep 1.5;
					//Allow more time for animation if coming from Air vehicle
					//bug - why?
					if (_vehicle isKindOf "Air") then {
						sleep 1.5;
					};
				}
				else
				{
					_breakOut = true;
				};
			};
		};
		if (_breakOut) exitWith {};
		//Show counter text for player
		if (isPlayer _unit) then {
			//Check environment only if black screen is disabled
			if (!G_Revive_Black_Screen) then {
				titleText [format["%1 seconds until auto-respawn, unless you are revived!", _reviveTimer],"PLAIN",1];
			}
			else
			{
				titleText [format["%1 seconds until auto-respawn, unless you are revived!", _reviveTimer],"BLACK FADED",1];
			};
		};
		sleep 1;
	};
}
else
{
	//Revive timer is unlimited
	//Cycle in unconscious state so long as unit is unconscious, is alive, and is still local to the executor
	//bug - why the local check?
	while {(_unit getVariable "G_Unconscious") && (alive _unit) && (local _unit)} do 
	{
		//Handle vehicle if unit is in one
		_vehicleLoop = _unit getVariable "G_Loaded";
		_breakOut = false;
		if (!isNull _vehicleLoop) then {
			//Unit in a vehicle
			if ((!alive _vehicleLoop) && (!G_Explosion_Eject_Occupants)) then {
				//Vehicle is destroyed, cannot eject, break out to kill the unit
				_breakOut = true;
			};
		};
		if (_breakOut) exitWith {};
		sleep 0.25;
	};
};

//If unit no longer local, exit scope
//bug - why the local check?
if (!local _unit) exitWith {};
//No longer unconscious, and still local

//Close the unconscious dialog
closeDialog 0;

//Determine how to proceed based on status change
if ((isNull (_unit getVariable "G_Reviver")) || (!alive _unit) || (!isNull (_unit getVariable "G_Loaded"))) then {
	//Unit did not get revived (timer ran out or aborted), or is dead
	//Remove from Unconscious, and kill unit
	_unit setVariable ["G_Loaded", objNull, true];
	_unit setVariable ["G_Unconscious", false, true];
	_unit setDamage 1;
	//If on black screen, bring back normal view
	if (G_Revive_Black_Screen) then {
		titleText ["", "BLACK IN", 1]; 
	};
}
else
{
	//Unit was revived
	//Set unit to full health
	//bug - Make option to have certain damage, requiring further treatment?
	_unit setDamage 0;
	//Remove from Unconscious
	//bug - this is done anyway, so add it before the if/then for optimization?
	_unit setVariable ["G_Unconscious", false, true];
	_unit setUnconscious false;
	/*
	//Cleanly move unit to prone animation
	[_unit, "AmovPpneMstpSrasWrflDnon"] remoteExecCall ["playMoveNow", 0, true];
	//Forcefully move unit to prone animation
	[_unit, "AmovPpneMstpSrasWrflDnon"] remoteExecCall ["switchMove", 0, true];
	*/
	//Allow unit to be engaged by AI
	_unit setCaptive false;
	//Allow AI unit to move
	_unit enableAI "MOVE";
	//Allow scripted AI responses
	_unit enableAI "FSM";
	//Allow unit to take damage
	_unit allowDamage true;
	_rescuer = _unit getVariable "G_Reviver";
	_downs = _unit getVariable "G_Downs";
	//Enables collision of the incapacitated unit with all other units
		//bug - is the locality here ok, or does there need to be a broadcast?
	{
		_unit enableCollisionWith _x;
	} forEach allUnits;
	//Display downs remaining for players
	//bug - do AI units properly count downs?
	if (isPlayer _unit) then {
		//Display text depending on downs remaining
		if (G_Revive_DownsPerLife > 0) then {
			//Down(s) remaining
			_downsPlural = "downs";
			if (_downs == 1) then {
				_downsPlural = "down";
			};
			//Display text depending on if black screen is enabled
			if (G_Revive_Black_Screen) then {
				titleText [format["You have been revived by %1! You have %2 %3 remaining!", name _rescuer, _downs, _downsPlural], "BLACK IN", 5]; 
			}
			else
			{
				titleText [format["You have been revived by %1! You have %2 %3 remaining!", name _rescuer, _downs, _downsPlural], "PLAIN", 1];
			};
		}
		else
		{
			//No downs remaining
			//Display text depending on if black screen is enabled
			if (G_Revive_Black_Screen) then {
				titleText [format["You have been revived by %1!",name _rescuer],"BLACK IN", 5]; 
			}
			else
			{
				titleText [format["You have been revived by %1!",name _rescuer],"PLAIN",1];
			};
		};
	};
};

//Reset Reviver variable
_unit setVariable ["G_Reviver", objNull, true];