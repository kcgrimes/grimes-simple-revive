//Manages unit that kills unit
/*
_unit = _this select 0;
_killer = _this select 1;

if (isNull _killer) exitWith {};

if (((side _unit) == (side _killer)) and (isPlayer _killer)) then {
	if (G_TK_Penalty != 0) then {
		_killer_lives = _killer getVariable "G_Num_Respawns";
		_killer_lives = _killer_lives + G_TK_Penalty;
		_killer setVariable ["G_Num_Respawns",_killer_lives,true];
	};
}
else
{
	_killer addRating 200;
};
*/