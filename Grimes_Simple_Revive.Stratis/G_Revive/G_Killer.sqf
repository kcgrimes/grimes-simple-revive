//Manages unit that kills unit
private ["_killer_lives"];

_unit = _this select 0;
_killer = _this select 1;

if (isNull _killer) exitWith {};
if ((typeName (_killer getVariable "G_Lives")) != "SCALAR") exitWith {};

if (((_unit getVariable "G_Side") == (_killer getVariable "G_Side")) and (isPlayer _killer)) then {
	if (G_TK_Penalty != 0) then {
		_killer_lives = _killer getVariable "G_Lives";
		_killer_lives = _killer_lives + G_TK_Penalty;
		if (_killer_lives < 0) then {
			_killer_lives = 0;
		};
		_killer setVariable ["G_Lives",_killer_lives,true];
	};
}
else
{
	_killer addRating 200;
};