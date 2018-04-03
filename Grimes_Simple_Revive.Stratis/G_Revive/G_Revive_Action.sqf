//Reviver

private ["_hasItem"];

_unit = _this select 0;
G_Revive_Global_Unit = _unit;
_rescuer = _this select 1;
G_Revive_Global_Rescuer = _rescuer;
_reviveActionID = _this select 2;

//Set and broadcast Revive variables
_unit setVariable ["G_getRevived", true, true];
_rescuer setVariable ["G_Reviving", true, true];

//Handle First Aid Kit (FAK) requirement if enabled
_hasItem = 0;
if (G_Revive_Requirement > 0) then {
	//1 or more FAK, or Medikit, is required
	//Get array of rescuer's items
	_rescitemsArray = items _rescuer;
	//Handle Medikit
	if ("Medikit" in (_rescitemsArray)) then {
		//Has Medikit, so meet requirement
		_hasItem = _hasItem + G_Revive_Requirement;
	};
	//Handle FAKs if no Medikit
	if (_hasItem < G_Revive_Requirement) then {
		//No Medikit, so cycle through array of items
		{
			//If item is FAK, +1 to count
			if (_x isEqualTo "FirstAidKit") then {
				if (_hasItem < G_Revive_Requirement) then {
					_hasItem = _hasItem + 1;
				};
			};
		} forEach _rescitemsArray;
		//If FAK requirement achieved, remove only the required number of FAKs
		if (_hasItem >= G_Revive_Requirement) then {
			for "_i" from 1 to G_Revive_Requirement do {
				_rescuer removeItem "FirstAidKit";
			};
		};
	};
};

//If FAK requirement is enabled and not achieved, exit with error message and reset variables
if ((G_Revive_Requirement > 0) and (_hasItem < G_Revive_Requirement)) exitWith {
	titleText [format["You require either %2 First Aid Kit(s) or a single Medikit to revive %1!",name _unit,G_Revive_Requirement],"PLAIN",1]; 
	_unit setVariable ["G_getRevived", false, true];
	_rescuer setVariable ["G_Reviving", false, true];
	sleep 1; 
	titleFadeOut 4;
};

//bug - move this up top?
//bug - combine this with getRevived, using objNull?
_unit setVariable ["G_Reviver", _rescuer, true];

//Revive announcement for rescuer
//bug - add progress of some sort?
titleText [format["You are reviving %1! This will take %2 seconds!", name _unit, G_Revive_actionTime], "PLAIN", 1]; 
titleFadeOut 5;

//Handle revive abort
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

G_Revive_actionTime_Var = 0;
[] spawn {
	while {(G_Revive_actionTime_Var < G_Revive_actionTime) and (!G_Revive_Abort)} do {
		sleep 1;
		G_Revive_actionTime_Var = G_Revive_actionTime_Var + 1;
	};
};

[_rescuer] spawn {
	_rescuer = _this select 0;
	while {(G_Revive_actionTime_Var < G_Revive_actionTime) and (!G_Revive_Abort)} do {
		[_rescuer, "AinvPknlMstpSnonWrflDr_medic3"] remoteExec ["playMoveNow", 0, false];
		waitUntil {sleep 0.1; (!(G_Revive_actionTime_Var < G_Revive_actionTime) || (G_Revive_Abort) || ((animationState _rescuer) != "AinvPknlMstpSnonWrflDr_medic3"));};
	};
	[_rescuer, "AmovPknlMstpSrasWrflDnon"] remoteExecCall ["playMoveNow", 0, true];
	[_rescuer, "AmovPknlMstpSrasWrflDnon"] remoteExecCall ["switchMove", 0, true];
};

//Wait for revive timer or abort
waitUntil {!(G_Revive_actionTime_Var < G_Revive_actionTime) || (G_Revive_Abort)};
//Exit if revive was aborted
if (G_Revive_Abort) exitWith {};

(findDisplay 46) displayRemoveEventHandler ["KeyDown",G_Revive_Global_KeyDown_EH];

//Set unit animation to prone
[_unit, "AmovPpneMstpSrasWrflDnon"] remoteExecCall ["playMoveNow", 0, true];
[_unit, "AmovPpneMstpSrasWrflDnon"] remoteExecCall ["switchMove", 0, true];

//Reset revive variables
_unit setVariable ["G_Unconscious", false, true];
_unit setVariable ["G_getRevived", false, true];
_rescuer setVariable ["G_Reviving", false, true];

//Handle revive announcement depending on use of Lives system
_lives = _rescuer getVariable "G_Lives";
if ((_lives >= 0) and (G_Revive_Reward > 0)) then {
	_lives = _lives + G_Revive_Reward;
	_livesPlural = "lives";
	if (_lives == 1) then {
		_livesPlural = "life";
	};
	titleText [format["You have been rewarded an additional life for reviving %1! You have %2 %3 remaining!", name _unit, _lives, _livesPlural], "PLAIN", 1];
	titleFadeOut 4;
	_rescuer setVariable ["G_Lives",_lives,true];
}
else
{
	titleText [format["You have revived %1!",name _unit],"PLAIN",1]; 
	titleFadeOut 4;
};