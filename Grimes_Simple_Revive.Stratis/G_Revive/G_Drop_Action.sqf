//Drop (from Carry or Drag)

_unit = _this select 0;
_rescuer = _this select 1;
_dropActionID = _this select 2;

_unit removeAction _dropActionID;

if (_unit getVariable "G_Dragged") then {
	if (_rescuer getVariable "G_Unconscious") then {
		[_rescuer, "DeadState"] remoteExec ["G_fnc_switchMove", 0, true];
		[_unit, "DeadState"] remoteExecCall ["G_fnc_playMoveNow", 0, true];
		[_unit, "DeadState"] remoteExecCall ["G_fnc_switchMove", 0, true];
	}
	else
	{
		[_rescuer, "AcinPknlMstpSrasWrflDnon_AmovPknlMstpSrasWrflDnon"] remoteExec ["G_fnc_switchMove", 0, true];
		[_unit, "AinjPpneMrunSnonWnonDb_release"] remoteExecCall ["G_fnc_playMoveNow", 0, true];
		[_unit, "AinjPpneMrunSnonWnonDb_release"] remoteExecCall ["G_fnc_switchMove", 0, true];
	};
	detach _unit;
	sleep 3;
	[_unit, false] remoteExec ["G_fnc_enableSimulation", 0, true];
	_unit setVariable ["G_Dragged",false,true];
	_rescuer setVariable ["G_Dragging",false,true];
}
else
{
	if (_rescuer getVariable "G_Unconscious") then {
		[_rescuer, "DeadState"] remoteExec ["G_fnc_switchMove", 0, true];
		[_unit, "DeadState"] remoteExecCall ["G_fnc_playMoveNow", 0, true];
		[_unit, "DeadState"] remoteExecCall ["G_fnc_switchMove", 0, true];
		sleep 4;
	}
	else
	{
		[_rescuer, "AcinPercMrunSrasWrflDf_AmovPercMstpSlowWrflDnon"] remoteExecCall ["G_fnc_playMoveNow", 0, true];
		[_unit, "AinjPfalMstpSnonWnonDnon_carried_Down"] remoteExecCall ["G_fnc_playMoveNow", 0, true];
		[_unit, "AinjPfalMstpSnonWnonDnon_carried_Down"] remoteExecCall ["G_fnc_switchMove", 0, true];
		sleep 5;
	};
	_rescuer forceWalk false;
	detach _unit;
	[_unit, false] remoteExec ["G_fnc_enableSimulation", 0, true];
	_unit setVariable ["G_Carried",false,true];
	_rescuer setVariable ["G_Carrying",false,true];
};