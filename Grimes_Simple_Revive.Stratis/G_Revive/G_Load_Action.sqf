//Load unconscious

_unit = _this select 0;
_rescuer = _this select 1;
_side = _this select 3 select 0;

_vehicle = (nearestObjects [_unit, ["Car","Tank","Helicopter","Truck"], 10]) select 0;

if ((_vehicle emptyPositions "cargo") < 1) exitWith {
	titleText [format["You cannot move %1 into %2 because there is no more space!",name _unit,_vehicle],"PLAIN", 4]; sleep 1; titleFadeOut 4;
};

_unit setVariable ["G_Loaded",true,true];

_unit assignAsCargo _vehicle;
_unit moveInCargo _vehicle;

_unloadActionID = _vehicle addAction [format["Unload %1",name _unit],"G_Revive\G_Unload_Action.sqf",[_unit],1.5,true,true,"", format["(side _this == %1) and ((_target distance _this) < 5) and ((speed _target) < 1)",_side]];