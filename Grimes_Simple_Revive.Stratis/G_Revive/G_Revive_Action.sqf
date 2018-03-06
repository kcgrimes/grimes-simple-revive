//Reviver

private ["_hasItem"];

_unit = _this select 0;
G_Revive_Global_Unit = _unit;
_rescuer = _this select 1;
G_Revive_Global_Rescuer = _rescuer;
_reviveActionID = _this select 2;

_unit setVariable ["G_getRevived",true,true];
_rescuer setVariable ["G_Reviving",true,true];

_hasItem = 0;
if (G_Revive_Requirement > 0) then {
	_rescitemsArray = items _rescuer;
	if ("Medikit" in (_rescitemsArray)) then {
		_hasItem = _hasItem + G_Revive_Requirement;
	};
	if (_hasItem < G_Revive_Requirement) then {
		{
			if (_x isEqualTo "FirstAidKit") then {
				if (_hasItem < G_Revive_Requirement) then {
					_hasItem = _hasItem + 1;
				};
			};
		} forEach _rescitemsArray;
		if (_hasItem >= G_Revive_Requirement) then {
			for "_i" from 1 to G_Revive_Requirement do {
				_rescuer removeItem "FirstAidKit";
			};
		};
	};
};

if ((G_Revive_Requirement > 0) and (_hasItem < G_Revive_Requirement)) exitWith {
	titleText [format["You require either %2 First Aid Kit(s) or a single Medikit to revive %1!",name _unit,G_Revive_Requirement],"PLAIN",1]; 
	_unit setVariable ["G_getRevived",false,true];
	_rescuer setVariable ["G_Reviving",false,true];
	sleep 1; 
	titleFadeOut 4;
};

_unit setVariable ["G_Reviver",_rescuer,true];

titleText [format["You are reviving %1! This will take %2 seconds!",name _unit,G_Revive_Time_To],"PLAIN",1]; 
titleFadeOut 5;

G_Revive_Abort = false;
G_fnc_Revive_Abort = {
	_unit = G_Revive_Global_Unit;
	_rescuer = G_Revive_Global_Rescuer;
	(findDisplay 46) displayRemoveEventHandler ["KeyDown",G_Revive_Global_KeyDown_EH];
	_unit setVariable ["G_getRevived",false,true];
	_rescuer setVariable ["G_Reviving",false,true];
	_unit setVariable ["G_Reviver",objNull,true];
	titleText [format["You have aborted the revive process of %1!",name _unit],"PLAIN",1]; 
	titleFadeOut 5;
};

waitUntil {!isNull (findDisplay 46)};
G_Revive_Global_KeyDown_EH = (findDisplay 46) displayAddEventHandler ["KeyDown","[_this select 1] call G_fnc_ReviveKeyDownAbort; false;"];  

G_Revive_Time_To_Var = 0;
[] spawn {
	while {(G_Revive_Time_To_Var < G_Revive_Time_To) and (!G_Revive_Abort)} do {
		sleep 1;
		G_Revive_Time_To_Var = G_Revive_Time_To_Var + 1;
	};
};

[_rescuer] spawn {
	_rescuer = _this select 0;
	while {(G_Revive_Time_To_Var < G_Revive_Time_To) and (!G_Revive_Abort)} do {
		[[_rescuer, "AinvPknlMstpSnonWrflDr_medic3"], "G_fnc_playMoveNow", true, false] spawn BIS_fnc_MP;
		waitUntil {sleep 0.1; (!(G_Revive_Time_To_Var < G_Revive_Time_To) || (G_Revive_Abort) || ((animationState _rescuer) != "AinvPknlMstpSnonWrflDr_medic3"));};
	};
	[[_rescuer, "AmovPknlMstpSrasWrflDnon"], "G_fnc_playMoveNow", true, true, true] call BIS_fnc_MP;
	[[_rescuer, "AmovPknlMstpSrasWrflDnon"], "G_fnc_switchMove", true, true, true] call BIS_fnc_MP;
};

waitUntil {!(G_Revive_Time_To_Var < G_Revive_Time_To) || (G_Revive_Abort)};
if (G_Revive_Abort) exitWith {};

[[_unit, true], "G_fnc_enableSimulation", true, true] spawn BIS_fnc_MP;

(findDisplay 46) displayRemoveEventHandler ["KeyDown",G_Revive_Global_KeyDown_EH];

[[_unit, "AmovPpneMstpSrasWrflDnon"], "G_fnc_playMoveNow", true, true, true] call BIS_fnc_MP;
[[_unit, "AmovPpneMstpSrasWrflDnon"], "G_fnc_switchMove", true, true, true] call BIS_fnc_MP;

_unit setVariable ["G_Unconscious",false,true];
_unit setVariable ["G_getRevived",false,true];
_rescuer setVariable ["G_Reviving",false,true];

_lives = _rescuer getVariable "G_Lives";
if ((_lives >= 0) and (G_Revive_Reward > 0)) then {
	_lives = _lives + G_Revive_Reward;
	titleText [format["You have been rewarded an additional life for reviving %1! You have %2 lives remaining!",name _unit,_lives],"PLAIN",1];
	titleFadeOut 4;
	_rescuer setVariable ["G_Lives",_lives,true];
}
else
{
	titleText [format["You have revived %1!",name _unit],"PLAIN",1]; 
	titleFadeOut 4;
};