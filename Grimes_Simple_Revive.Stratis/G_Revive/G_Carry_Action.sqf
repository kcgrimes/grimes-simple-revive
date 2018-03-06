//Carry

_unit = _this select 0;
_rescuer = _this select 1;

_unit setVariable ["G_Carried",true,true];
_rescuer setVariable ["G_Carrying",true,true];

_unit enableSimulation true;
_rescuer forceWalk true;

_unit setDir (getDir player + 180);
_unitPos = getPos _unit;

[[_unit, "AidlPpneMstpSnonWnonDnon_AI"], "G_fnc_switchMove", true, true, true] call BIS_fnc_MP;
[[_unit, "AinjPfalMstpSnonWnonDf_carried_dead"], "G_fnc_playMoveNow", true, true, true] call BIS_fnc_MP;

sleep 1.5;

[[_rescuer, "AcinPknlMstpSrasWrflDnon_AcinPercMrunSrasWrflDnon"], "G_fnc_playMoveNow", true, true, true] call BIS_fnc_MP;

waitUntil {animationState _unit == "AinjPfalMstpSnonWnonDf_carried_dead"};
//sleep 15;

_unit attachTo [_rescuer, [-0.2, 0.25, 0]];

_dropActionID = _unit addAction ["Drop","G_Revive\G_Drop_Action.sqf",[],1.5,true,true,""];
waitUntil {sleep 1; (!(_unit getVariable "G_Carried") || !(alive _unit))};  
if (!alive _unit) then {
	[_unit, _rescuer, _dropActionID] execVM "G_Revive\G_Drop_Action.sqf";
};