//Drop (from Carry or Drag)

_unit = _this select 0;
_rescuer = _this select 1;
_dropActionID = _this select 2;

_unit removeAction _dropActionID;

if (_unit getVariable "G_Dragged") then {
	[[_rescuer, "AcinPknlMstpSrasWrflDnon_AmovPknlMstpSrasWrflDnon"], "G_fnc_switchMove", true, true, true] call BIS_fnc_MP;
	[[_unit, "AinjPpneMrunSnonWnonDb_release"], "G_fnc_playMoveNow", true, true, true] call BIS_fnc_MP;
	[[_unit, "AinjPpneMrunSnonWnonDb_release"], "G_fnc_switchMove", true, true, true] call BIS_fnc_MP;
	detach _unit;
	sleep 3;
	_unit enableSimulation false;
	_unit setVariable ["G_Dragged",false,true];
	_rescuer setVariable ["G_Dragging",false,true];
}
else
{
	[[_rescuer, "AcinPercMrunSrasWrflDf_AmovPercMstpSlowWrflDnon"], "G_fnc_playMoveNow", true, true, true] call BIS_fnc_MP;
	[[_unit, "AinjPfalMstpSnonWnonDnon_carried_Down"], "G_fnc_playMoveNow", true, true, true] call BIS_fnc_MP;
	[[_unit, "AinjPfalMstpSnonWnonDnon_carried_Down"], "G_fnc_switchMove", true, true, true] call BIS_fnc_MP;
	_rescuer forceWalk false;
	sleep 5;
	detach _unit;
	_unit enableSimulation false;
	_unit setVariable ["G_Carried",false,true];
	_rescuer setVariable ["G_Carrying",false,true];
};