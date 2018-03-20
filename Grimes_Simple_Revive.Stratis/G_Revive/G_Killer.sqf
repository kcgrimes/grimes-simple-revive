//Manages unit that kills unit
private ["_killer_lives"];

_unit = _this select 0;
_killer = _this select 1;

//If unit somehow killed self, exit
if (isNull _killer) exitWith {};
//If killer does not have lives, no need to be here
if ((typeName (_killer getVariable "G_Lives")) != "SCALAR") exitWith {};

//Check if teamkill
if (((_unit getVariable "G_Side") == (_killer getVariable "G_Side")) && (isPlayer _killer)) then {
	//Is teamkill, so see if there will be penalty of lives
	if (G_TK_Penalty != 0) then {
		//Life penality defined
		//Add penalty (negative) to killer life count, not going below 0
		_killer_lives = 0 max ((_killer getVariable "G_Lives") + G_TK_Penalty);
		//Set new killer life count and broadcast
		_killer setVariable ["G_Lives", _killer_lives, true];
	};
}
else
{
	//Not a teamkill, handle points for a normal man kill
	//bug - look into how BIS Revive does this in order to be more comprehensive
	_killer addRating 200;
};