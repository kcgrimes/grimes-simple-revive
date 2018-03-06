//Drag

_unit = _this select 0;
_rescuer = _this select 1;

_unit setVariable ["G_Dragged",true,true];
_rescuer setVariable ["G_Dragging",true,true];

_unit enableSimulation true;

sleep 0.5;

[[_rescuer, "AcinPknlMstpSrasWrflDnon"], "G_fnc_playMoveNow", true, true, true] call BIS_fnc_MP; 

[[_unit, "AinjPpneMrunSnonWnonDb_still"], "G_fnc_playMoveNow", true, true, true] call BIS_fnc_MP;
[[_unit, "AinjPpneMrunSnonWnonDb_still"], "G_fnc_switchMove", true, true, true] call BIS_fnc_MP;

_unit attachTo [_rescuer, [0.1,1.01,0]];
_unit setDir 180;

_dropActionID = _unit addAction ["Drop","G_Revive\G_Drop_Action.sqf",[],1.5,true,true,""];
waitUntil {sleep 1; (!(_unit getVariable "G_Dragged") || !(alive _unit))};  
if (!alive _unit) then {
	[_unit, _rescuer, _dropActionID] execVM "G_Revive\G_Drop_Action.sqf";
};