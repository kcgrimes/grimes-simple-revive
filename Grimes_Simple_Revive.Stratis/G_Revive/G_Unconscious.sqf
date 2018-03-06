private ["_itemsArray","_replaceArray","_reviveTimer","_byCar"];
	
_unit = _this select 0;
_source = _this select 1;
_projectile = _this select 2;

if (((_unit getVariable "G_Unconscious") || !(local _unit)) and (!G_isJIP)) exitWith {};
_unit setVariable ["G_Unconscious",true,true];

[[_unit, "DeadState"], "G_fnc_playMoveNow", true, true, true] call BIS_fnc_MP;

_byVeh = ((vehicle _source != _source) and (_projectile == ""));

if (isPlayer _unit) then {
	titleText ["","BLACK", 1]; 
	if (G_Revive_Black_Screen == 0) then {
		[_byVeh] spawn {
			_byVeh = _this select 0;
			sleep 3;
			if (_byVeh) then {
				titleText ["You are Unconscious. Wait for teammate to revive you.","BLACK IN", 9]; 
			}
			else
			{
				titleText ["You are Unconscious. Wait for teammate to revive you.","BLACK IN", 4]; 
			};
		};
	};
};

_unit setVariable ["G_Revive_Factors",[_unit, _source, _projectile],true];

if (_byVeh) then {
	_unit setVariable ["G_byVehicle",true,true];
	if (isPlayer _unit) then {
		disableUserInput true;
	};
	sleep 9;
	_dir = getDir _unit;
	_time = time;
	if (isPlayer _unit) then {
		disableUserInput false;
	};
	waitUntil {(getDir _unit >= _dir + 10) || (getDir _unit <= _dir - 10) || (time >= (_time + 10))};
};

_itemsArray = items _unit;
_replaceArray = [];
{
	if ((_x == "Medikit") || (_x == "FirstAidKit")) then {
		_replaceArray = _replaceArray + [_x];
	};
} forEach _itemsArray;
_unit removeItems "Medikit";
_unit removeItems "FirstAidKit"; 

_unit disableAI "MOVE";
_side = side _unit;
_unit setCaptive true;
	
if (G_Custom_Exec_1 != "") then {
	[] execVM G_Custom_Exec_1;
};

if (vehicle _unit != _unit) then {
	_vehicle = vehicle _unit;
	if (alive _vehicle) then {
		_unit setVariable ["G_Loaded",true,true];
		
		[[_unit, _vehicle, _side], "G_fnc_moveInCargoToUnloadAction", true, true, true] call BIS_fnc_MP; 
	}
	else
	{
		unassignVehicle _unit;
		_unit action ["EJECT", _vehicle];
		sleep 1;
		[[_unit, "DeadState"], "G_fnc_switchMove", true, true, true] call BIS_fnc_MP;
		[[_unit, "DeadState"], "G_fnc_playMoveNow", true, true, true] call BIS_fnc_MP;
		sleep 0.5;
	};
}
else
{
	sleep 2;
};

waitUntil {(animationState _unit) == "DeadState"};
sleep 1.5;
[[_unit, false], "G_fnc_enableSimulation", true, true] spawn BIS_fnc_MP;

sleep 2;
_reviveTimer = G_Revive_Time_Limit;
if (_reviveTimer > -1) then {
	while {(_unit getVariable "G_Unconscious") and (_reviveTimer > 0) and (alive _unit) and (local _unit)} do 
	{
		if !(_unit getVariable "G_getRevived") then {
			_reviveTimer = _reviveTimer - 1;
		};
		if (isPlayer _unit) then {
			if (G_Revive_Black_Screen == 0) then {
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
	waitUntil {(!(_unit getVariable "G_Unconscious") || (!alive _unit) || !(local _unit))};
};

if (!local _unit) exitWith {};

{
	_unit addItem _x;
} forEach _replaceArray;

if ((isNull (_unit getVariable "G_Reviver")) || (!alive _unit)) then {
	_unit setVariable ["G_Unconscious",false,true];
	_unit setDamage 1;
}
else
{
	_unit setDamage 0;
	_unit setVariable ["G_Unconscious",false,true];
	[[_unit, true], "G_fnc_enableSimulation", true, true] spawn BIS_fnc_MP;
	[[_unit, "AmovPpneMstpSrasWrflDnon"], "G_fnc_playMoveNow", true, true, true] call BIS_fnc_MP;
	[[_unit, "AmovPpneMstpSrasWrflDnon"], "G_fnc_switchMove", true, true, true] call BIS_fnc_MP;
	_unit setCaptive false;
	_unit enableAI "MOVE";
	_unit allowDamage true;
	_rescuer = _unit getVariable "G_Reviver";
	if (isPlayer _unit) then {
		if (G_Revive_Black_Screen == 1) then {
			titleText [format["You have been revived by %1!",name _rescuer],"BLACK IN", 5]; 
		}
		else
		{
			titleText [format["You have been revived by %1!",name _rescuer],"PLAIN",1];
		};
	};
};
_unit setVariable ["G_Reviver",objNull,true];