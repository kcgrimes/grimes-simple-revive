//Unload unconscious

_vehicle = _this select 0;
_unloadActionID = _this select 2;
_unit = _this select 3 select 0;

_unit setVariable ["G_Loaded",false,true];

[_unit, true] remoteExec ["G_fnc_enableSimulation", 0, true];

unassignVehicle _unit;
_unit action ["EJECT", _vehicle];
sleep 1;
[_unit, "DeadState"] remoteExecCall ["switchMove", 0, true];
[_unit, "DeadState"] remoteExecCall ["playMoveNow", 0, true];

sleep 2.75;

[_unit, false] remoteExec ["G_fnc_enableSimulation", 0, true];