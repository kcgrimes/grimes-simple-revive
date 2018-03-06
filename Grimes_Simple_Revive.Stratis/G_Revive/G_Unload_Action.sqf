//Unload unconscious

_vehicle = _this select 0;
_unloadActionID = _this select 2;
_unit = _this select 3 select 0;

_vehicle removeAction _unloadActionID;

_unit enableSimulation true;

unassignVehicle _unit;
_unit action ["EJECT", _vehicle];
sleep 1;
[[_unit, "DeadState"], "G_fnc_switchMove", true, true, true] call BIS_fnc_MP;
[[_unit, "DeadState"], "G_fnc_playMoveNow", true, true, true] call BIS_fnc_MP;

_unit setVariable ["G_Loaded",false,true];

sleep 3;

_unit enableSimulation false;