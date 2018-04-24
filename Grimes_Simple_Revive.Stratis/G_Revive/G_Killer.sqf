//Manages unit that kills unit
//Local to _unit
private ["_unit", "_killer", "_noKiller"];
_unit = _this select 0;
_killer = _this select 1;

_noKiller = false;
//If unit was killed by environment, exit
if (isNull _killer) then {
	_noKiller = true;
};
//If unit killed self, exit
if (_unit == _killer) then {
	_noKiller = true;
};
//If killer does not have lives (is not a Man), no need to be here
if ((typeName (_killer getVariable "G_Lives")) != "SCALAR") then {
	_noKiller = true;
};

//If no killer defined, no killer to manage, so exit with incapacitated text
if (_noKiller) exitWith {
	if (G_Revive_Messages > 0) then {
		_target = 0;
		if (G_Revive_Messages == 1) then {
			_target = _unit getVariable "G_Side";
		};
		[format["%1 was incapacitated", name _unit]] remoteExec ["systemChat", _target, false];
	};
};

//Killer was defined, so announce
if (G_Revive_Messages > 0) then {
	_target = 0;
	if (G_Revive_Messages == 1) then {
		_target = _unit getVariable "G_Side";
	};
	[format["%1 was incapacitated by %2", name _unit, name _killer]] remoteExec ["systemChat", _target, false];
};
	
//Check if teamkill
private ["_killer_lives"];
if ((_unit getVariable "G_Side") == (_killer getVariable "G_Side")) then {
	//Is teamkill
	//Handle life penalty if enabled
	if (G_TK_Penalty != 0) then {
		//Life penality exists for TK
		//Add penalty (negative) to killer life count, not going below 0
		_killer_lives = 0 max ((_killer getVariable "G_Lives") + G_TK_Penalty);
		//Set new killer life count and broadcast
		_killer setVariable ["G_Lives", _killer_lives, true];
	};
	//Broadcast score deduction to server
	[_killer, [-1, 0, 0, 0, 0]] remoteExec ["addPlayerScores", 2, false];
	//Rating penalty
	[_killer, -1000] remoteExec ["addRating", _killer, false];
}
else
{
	//Not a teamkill
	//Broadcast score bonus to server
	[_killer, [1, 0, 0, 0, 0]] remoteExec ["addPlayerScores", 2, false];
	//Rating bonus
	[_killer, 200] remoteExec ["addRating", _killer, false];
};