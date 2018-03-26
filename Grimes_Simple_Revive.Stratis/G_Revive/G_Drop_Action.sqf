//Drop (from Carry or Drag)

_unit = _this select 0;
_rescuer = _this select 1;
_dropActionID = _this select 2;

_unit removeAction _dropActionID;

if (_unit getVariable "G_Dragged") then {
	if (_rescuer getVariable "G_Unconscious") then {
		[_rescuer, "UnconsciousFaceDown"] remoteExec ["switchMove", 0, true];
		[_unit, "UnconsciousFaceDown"] remoteExecCall ["playMoveNow", 0, true];
		[_unit, "UnconsciousFaceDown"] remoteExecCall ["switchMove", 0, true];
	}
	else
	{
		[_rescuer, "AcinPknlMstpSrasWrflDnon_AmovPknlMstpSrasWrflDnon"] remoteExec ["switchMove", 0, true];
		//[_unit, "AinjPpneMrunSnonWnonDb_release"] remoteExecCall ["playMoveNow", 0, true];
		//[_unit, "AinjPpneMrunSnonWnonDb_release"] remoteExecCall ["switchMove", 0, true];
		[_unit, "UnconsciousFaceDown"] remoteExecCall ["playMoveNow", 0, true];
		[_unit, "UnconsciousFaceDown"] remoteExecCall ["switchMove", 0, true];
	};
	detach _unit;
	sleep 3;
	_unit setVariable ["G_Dragged",false,true];
	_rescuer setVariable ["G_Dragging",false,true];
}
else
{
	if (_rescuer getVariable "G_Unconscious") then {
		[_rescuer, "UnconsciousFaceDown"] remoteExec ["switchMove", 0, true];
		[_unit, "UnconsciousFaceDown"] remoteExecCall ["playMoveNow", 0, true];
		[_unit, "UnconsciousFaceDown"] remoteExecCall ["switchMove", 0, true];
		sleep 4;
	}
	else
	{
		[_rescuer, "AcinPercMrunSrasWrflDf_AmovPercMstpSlowWrflDnon"] remoteExecCall ["playMoveNow", 0, true];
		[_unit, "AinjPfalMstpSnonWnonDnon_carried_Down"] remoteExecCall ["playMoveNow", 0, true];
		[_unit, "AinjPfalMstpSnonWnonDnon_carried_Down"] remoteExecCall ["switchMove", 0, true];
		sleep 5;
		[_unit, "UnconsciousFaceDown"] remoteExecCall ["playMoveNow", 0, true];
		[_unit, "UnconsciousFaceDown"] remoteExecCall ["switchMove", 0, true];
	};
	_rescuer forceWalk false;
	detach _unit;
	_unit setVariable ["G_Carried",false,true];
	_rescuer setVariable ["G_Carrying",false,true];
};