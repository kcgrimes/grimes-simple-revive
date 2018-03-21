//Carry

_unit = _this select 0;
_rescuer = _this select 1;

_unit setVariable ["G_Carried",true,true];
_rescuer setVariable ["G_Carrying",true,true];

[_unit, true] remoteExec ["G_fnc_enableSimulation", 0, false];
_rescuer forceWalk true;

[_unit, (getDir _rescuer) + 180] remoteExec ["G_fnc_setDir", 0, false];
_unitPos = getPos _unit;

[_unit, "AidlPpneMstpSnonWnonDnon_AI"] remoteExecCall ["switchMove", 0, false];
[_unit, "AinjPfalMstpSnonWnonDf_carried_dead"] remoteExecCall ["playMoveNow", 0, false];

sleep 2;

[_rescuer, "AcinPknlMstpSrasWrflDnon_AcinPercMrunSrasWrflDnon"] remoteExecCall ["playMoveNow", 0, false];

waitUntil {animationState _unit == "AinjPfalMstpSnonWnonDf_carried_dead"};

_unit attachTo [_rescuer, [-0.2, 0.25, 0]];

_dropActionID = _unit addAction [format["<t color='%1'>Drop</t>",G_Revive_Action_Color],"G_Revive\G_Drop_Action.sqf",[],1.5,true,true,""];
waitUntil {sleep 0.5; (!(_unit getVariable "G_Carried") || !(alive _unit) || (_rescuer getVariable "G_Unconscious"));};  
if ((!alive _unit) || (_rescuer getVariable "G_Unconscious")) then {
	[_unit, _rescuer, _dropActionID] execVM "G_Revive\G_Drop_Action.sqf";
};