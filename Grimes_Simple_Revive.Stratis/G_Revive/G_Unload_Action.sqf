//Unload unconscious

_vehicle = _this select 0;
_unloadActionID = _this select 2;
_unit = _this select 3 select 0;

//Order unit to be out of vehicle
unassignVehicle _unit;
//Manually remove unit from vehicle
//bug - does moveOut work now?
_unit setPos (_unit modelToWorldVisual [-2,0,0]);

//Execute Unconscious animation (still required despite playAction "Unconscious")
[_unit, "UnconsciousFaceDown"] remoteExecCall ["playMoveNow", 0, true];
[_unit, "UnconsciousFaceDown"] remoteExecCall ["switchMove", 0, true];

//Allow animation to set to prevent other animation executing too early
sleep 3;

//Set unit as not loaded and broadcast
_unit setVariable ["G_Loaded", objNull, true];