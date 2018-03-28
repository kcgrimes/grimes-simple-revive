//Unload unconscious

_vehicle = _this select 0;
_unloadActionID = _this select 2;
_unit = _this select 3 select 0;

unassignVehicle _unit;
_unit setPos (_unit modelToWorldVisual [-2,0,0]);

[_unit, "UnconsciousFaceDown"] remoteExecCall ["playMoveNow", 0, true];
[_unit, "UnconsciousFaceDown"] remoteExecCall ["switchMove", 0, true];

sleep 3;

_unit setVariable ["G_Loaded", objNull, true];