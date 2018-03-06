//Load unconscious

_unit = _this select 0;
_rescuer = _this select 1;
_side = _this select 3 select 0;

_vehicle = (nearestObjects [_unit, ["Car","Tank","Helicopter","Truck"], 10]) select 0;

if (G_Mobile_Respawn_Locked) then {
	if ((!isNil {(_vehicle getVariable "G_MRV_Logic") getVariable "G_Side"}) and ((_unit getVariable "G_Side") != ((_vehicle getVariable "G_MRV_Logic") getVariable "G_Side"))) exitWith {
		titleText [format["You cannot load %1 into %2 because the vehicle belongs to the other team!",name _unit,typeOf _vehicle],"PLAIN", 1]; sleep 1; titleFadeOut 4;
	};
};

if ((_vehicle emptyPositions "cargo") < 1) exitWith {
	titleText [format["You cannot load %1 into %2 because there is no more space!",name _unit,typeOf _vehicle],"PLAIN", 1]; sleep 1; titleFadeOut 4;
};

_unit setVariable ["G_Loaded",true,true];

[[_unit, _vehicle, _side], "G_fnc_moveInCargoToUnloadAction", true, true, true] call BIS_fnc_MP; 