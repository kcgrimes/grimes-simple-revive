//Drag
//Local to _rescuer
private ["_unit", "_rescuer"];

_unit = _this select 0;
_rescuer = _this select 1;

//Set carry-related variables and broadcast
_unit setVariable ["G_Dragged", true, true];
_rescuer setVariable ["G_Dragging", true, true];

//Rescuer animation to reach down and lift up
[_rescuer, "AcinPknlMstpSrasWrflDnon"] remoteExecCall ["playMoveNow", 0, false];

//Victim animation to be lifted up
[_unit, "AinjPpneMrunSnonWnonDb_still"] remoteExecCall ["playMoveNow", 0, false];
[_unit, "AinjPpneMrunSnonWnonDb_still"] remoteExecCall ["switchMove", 0, false];

//Attach unit to rescuer
_unit attachTo [_rescuer, [0.1,1.01,0.1]];
//Orient unit to be set appropriately
[_unit, 180] remoteExecCall ["setDir", _unit, false];

//Create drop action
private ["_dropActionID"];
_dropActionID = _rescuer addAction [format["<t color='%1'>Drop</t>", G_Revive_Action_Color], G_fnc_actionDrop, _unit, 1.5, true, true, ""];

//Wait for Drop or someone to die
waitUntil {sleep 0.1; (!(_unit getVariable "G_Dragged") || !(alive _unit) || (_rescuer getVariable "G_Unconscious"));};  

//If unit or rescuer died, handle in Drop function
if ((!alive _unit) || (!(_unit getVariable "G_Unconscious")) || (_rescuer getVariable "G_Unconscious")) then {
	[_unit, _rescuer, _dropActionID] spawn G_fnc_actionDrop;
};