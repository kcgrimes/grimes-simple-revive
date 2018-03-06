//Controls 3D unit markers

if (G_Unit_Tag_ShowDistance) then {
	G_Unit_Tag_Text = "format['%1 (%2m)',name _unit,ceil(_unit distance player)]";
}
else
{
	G_Unit_Tag_Text = "name _unit";
};

if (isServer) then {
	G_Unit_Tag_Num_List = 0;
	{
		_x setVariable ["G_Unit_Tag_Number", G_Unit_Tag_Num_List, true];
		G_Unit_Tag_Num_List = G_Unit_Tag_Num_List + 1; 
	} forEach allUnits;
	publicVariable "G_Unit_Tag_Num_List";
};

G_fnc_Unit_Marker_Exec = {
    _unit = _this select 0;
	_a = _unit getVariable "G_Unit_Tag_Number";
	
	(player getVariable "G_Revive_Player_List") set [_a, _unit];

	call compile format ["G_Unit_Tag_%1 = false;", _a];
	_ehID = addMissionEventHandler["Draw3D", format["
		private ['_color', '_height', '_alpha','_distp'];
		_unit = (player getVariable 'G_Revive_Player_List') select %1;
		if ((name _unit) == 'Error: No Unit') then {
			call compile format ['G_Unit_Tag_%1 = true', %1];
		};
		_distp = _unit distance player;
		if ((_distp <= G_Unit_Tag_Distance) and ((player getVariable 'G_Side') == (_unit getVariable 'G_Side')) and (_unit != player) and (_unit isKindOf 'CAManBase')) then {
			if ((G_Unit_Tag_Display == 1) and !(cursorTarget == _unit)) exitWith {};
			_alpha = (-0.02*(_distp))+(0.025*(G_Unit_Tag_Distance));
			if ((_unit getVariable 'G_Unconscious') or (!alive _unit)) then {
				_color = [1,0,0,_alpha];
			} else {
				_color = [1,1,1,_alpha];
			};
			_height = 0.0053*(_distp)+2;
			drawIcon3D ['', _color, [(visiblePosition _unit) select 0, (visiblePosition _unit) select 1, _height], 0, 0, 0, call compile G_Unit_Tag_Text, 0, 0.03, 'EtelkaMonospacePro'];
		};
	",_a]];
	call compile format["
		G_Unit_Tag_%1 = false;
		_unit = (player getVariable 'G_Revive_Player_List') select %1;
		waitUntil {G_Unit_Tag_%1};
		removeMissionEventHandler ['Draw3D', %2];
	",_a, _ehID];
};

G_fnc_Unit_Marker_ReExec = {
	[[(_this select 0), (_this select 1)], "G_fnc_Unit_Marker_Exec", true, true] spawn BIS_fnc_MP;
};

player setVariable ["G_Revive_Player_List", []];

switch (G_Unit_Tag_Display) do {
	case 0: {
		G_Unit_Tags_Key_Pressed = false;
		waitUntil {!isNull (findDisplay 46)};
		(findDisplay 46) displayAddEventHandler ["KeyDown","if ((_this select 1) == G_Unit_Tag_Display_Key) then {G_Unit_Tags_Key_Pressed = true; false;};"]; 
		while {true} do {
			waitUntil {G_Unit_Tags_Key_Pressed};
			G_Unit_Tags_Key_Pressed = false;
			_i = 0;
			{
				[_x,_i] spawn G_fnc_Unit_Marker_Exec;
				_i = _i + 1;
			} forEach allUnits;
			sleep G_Unit_Tag_Display_Time;
			removeAllMissionEventHandlers "Draw3D";
		};
	};

	case 1: {
		{
			if (_x isKindOf "CAManBase") then {
				[[_x], "G_fnc_Unit_Marker_Exec", true, true, true] spawn BIS_fnc_MP;
			};
		} forEach allUnits;
	};
    
	case 2: {
		{
			if (_x isKindOf "CAManBase") then {
				[[_x], "G_fnc_Unit_Marker_Exec", true, true, true] spawn BIS_fnc_MP;
			};
		} forEach allUnits;
	};
};