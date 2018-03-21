//Drag

_unit = _this select 0;
_rescuer = _this select 1;

_unit setVariable ["G_Dragged",true,true];
_rescuer setVariable ["G_Dragging",true,true];

[_unit, true] remoteExec ["G_fnc_enableSimulation", 0, false];

waitUntil {simulationEnabled _unit};

sleep 0.3;

[_rescuer, "AcinPknlMstpSrasWrflDnon"] remoteExecCall ["playMoveNow", 0, false];

[_unit, 180] remoteExec ["setDir", 0, false];

[_unit, "AinjPpneMrunSnonWnonDb_still"] remoteExecCall ["playMoveNow", 0, false];
[_unit, "AinjPpneMrunSnonWnonDb_still"] remoteExecCall ["switchMove", 0, false];

_unit attachTo [_rescuer, [0.1,1.01,0.1]];

_dropActionID = _unit addAction [format["<t color='%1'>Drop</t>",G_Revive_Action_Color],"G_Revive\G_Drop_Action.sqf",[],1.5,true,true,""];
waitUntil {sleep 0.5; (!(_unit getVariable "G_Dragged") || !(alive _unit) || (_rescuer getVariable "G_Unconscious"));};  
if ((!alive _unit) || (_rescuer getVariable "G_Unconscious")) then {
	[_unit, _rescuer, _dropActionID] execVM "G_Revive\G_Drop_Action.sqf";
};