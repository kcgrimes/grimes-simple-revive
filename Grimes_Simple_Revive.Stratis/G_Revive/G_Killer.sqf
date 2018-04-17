//Manages unit that kills unit
private ["_killer_lives"];

_unit = _this select 0;
_killer = _this select 1;

//If unit was killed by environment, exit
if (isNull _killer) exitWith {};
//If unit killed self, exit
if (_unit == _killer) exitWith {};
//If killer does not have lives (is not a Man), no need to be here
if ((typeName (_killer getVariable "G_Lives")) != "SCALAR") exitWith {};

//Check if teamkill
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
	_killer addRating -1000;
}
else
{
	//Not a teamkill
	//Broadcast score bonus to server
	[_killer, [1, 0, 0, 0, 0]] remoteExec ["addPlayerScores", 2, false];
	//Rating bonus
	_killer addRating 200;
};