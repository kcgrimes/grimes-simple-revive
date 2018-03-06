//Drag

_unit = _this select 0;
_rescuer = _this select 1;

_unit setVariable ["G_Dragged",true,true];
_rescuer setVariable ["G_Dragging",true,true];

[[_unit, true], "G_fnc_enableSimulation", true, false] spawn BIS_fnc_MP;

waitUntil {simulationEnabled _unit};

sleep 0.3;

[[_rescuer, "AcinPknlMstpSrasWrflDnon"], "G_fnc_playMoveNow", true, false, true] call BIS_fnc_MP; 

[[_unit, "AinjPpneMrunSnonWnonDb_still"], "G_fnc_playMoveNow", true, false, true] call BIS_fnc_MP;
[[_unit, "AinjPpneMrunSnonWnonDb_still"], "G_fnc_switchMove", true, false, true] call BIS_fnc_MP;

_unit attachTo [_rescuer, [0.1,1.01,0.1]];
[[_unit, 180], "G_fnc_setDir", true, false] spawn BIS_fnc_MP; 

_dropActionID = _unit addAction [format["<t color='%1'>Drop</t>",G_Revive_Action_Color],"G_Revive\G_Drop_Action.sqf",[],1.5,true,true,""];
waitUntil {sleep 0.5; (!(_unit getVariable "G_Dragged") || !(alive _unit) || (_rescuer getVariable "G_Unconscious"));};  
if ((!alive _unit) || (_rescuer getVariable "G_Unconscious")) then {
	[_unit, _rescuer, _dropActionID] execVM "G_Revive\G_Drop_Action.sqf";
};