private ["_itemsArray","_replaceArray"];

_unit = _this select 0;

[[_unit, "DeadState"], "G_fnc_playMoveNow", true, true, true] call BIS_fnc_MP;

if (isPlayer _unit) then {
	titleText ["","BLACK", 1]; 
	if (G_Revive_Black_Screen == 0) then {
		[] spawn {
			sleep 4;
			titleText ["You are Unconcious. Wait for teammate to revive you.","BLACK IN", 5]; 
		};
	};
};

_itemsArray = items _unit;
_replaceArray = [];
{
	if ((_x == "Medikit") || (_x == "FirstAidKit")) then {
		_replaceArray = _replaceArray + [_x];
	};
} forEach _itemsArray;
_unit removeItems "Medikit";
_unit removeItems "FirstAidKit"; 
_unit disableAI "MOVE";
_side = side _unit;
_unit setCaptive true;
sleep 2;
_unit enableSimulation false;

_unit setVariable ["G_Unconscious",true,true];

[[_unit, _replaceArray, _side], "G_fnc_Revive_Actions", true, true] spawn BIS_fnc_MP; 
	
if (G_Custom_Exec_1 != "") then {
	execVM G_Custom_Exec_1;
};

sleep 1;
_reviveTimer = G_Revive_Time_Limit;
if (_reviveTimer > -1) then {
	while {(_unit getVariable "G_Unconscious") and (_reviveTimer > 0)} do 
	{
		_reviveTimer = _reviveTimer - 1;
		if (isPlayer _unit) then {
			if (G_Revive_Black_Screen == 0) then {
				titleText [format["%1 seconds until auto-respawn, unless you are revived!", _reviveTimer],"PLAIN",1];
			}
			else
			{
				titleText [format["%1 seconds until auto-respawn, unless you are revived!", _reviveTimer],"BLACK FADED",1];
			};
		};
		sleep 1;
	};
}
else
{
	waitUntil {!(_unit getVariable "G_Unconscious")};
};

{
	_unit removeAction _x;
} forEach (_unit getVariable "G_Revive_Actions"); 

if ((_unit getVariable "G_Reviver") == "none") then {
	_unit enableSimulation true;
	_unit setCaptive false;
	_unit enableAI "MOVE";
	_unit allowDamage true;
	_unit setDamage 1;
	_unit setVariable ["G_Unconscious",false,true];
}
else
{
	if (isPlayer _unit) then {
		_rescuer = _unit getVariable "G_Reviver";
		if (G_Revive_Black_Screen == 1) then {
			titleText [format["You have been revived by %1!",_rescuer],"BLACK IN", 5]; 
		}
		else
		{
			titleText [format["You have been revived by %1!",_rescuer],"PLAIN",1];
		};
	};
	_unit setVariable ["G_Unconscious",false,true];
	_unit enableSimulation true;
	_unit setCaptive false;
	_unit enableAI "MOVE";
	_unit allowDamage true;
	_unit setVariable ["G_Reviver","none",true];
};