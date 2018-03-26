//Unload unconscious

_vehicle = _this select 0;
_unloadActionID = _this select 2;
_unit = _this select 3 select 0;

_unit setVariable ["G_Loaded", objNull, true];

unassignVehicle _unit;
_unit setPos (_unit modelToWorldVisual [-2,0,0]);