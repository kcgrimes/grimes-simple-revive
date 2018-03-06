//Controls 3D unit markers
if (G_isClient) then {
	if (G_Unit_Tag_ShowDistance) then {
		G_Unit_Tag_Text = "format['%1 (%2m)',name _unit,ceil(_unit distance player)]";
	}
	else
	{
		G_Unit_Tag_Text = "name _unit";
	};
};

if (G_isServer) then {
	_hp = "Land_HelipadEmpty_F" createVehicle [0,0,0];
	_hp setVehicleVarName "G_Unit_Tags_Logic";
	_hp call compile format ["%1 = _this; publicVariable ""%1""", "G_Unit_Tags_Logic"];
	G_Unit_Tags_Logic setVariable ["G_Revive_Player_List", [], false];
	G_Unit_Tag_Num_List = 0;
	{
		if (_x isKindOf "CAManBase") then {
			_x setVariable ["G_Unit_Tag_Number", G_Unit_Tag_Num_List, true];
			(G_Unit_Tags_Logic getVariable "G_Revive_Player_List") set [G_Unit_Tag_Num_List, _x];
			G_Unit_Tag_Num_List = G_Unit_Tag_Num_List + 1; 
		};
	} forEach allUnits;
	_var = G_Unit_Tags_Logic getVariable "G_Revive_Player_List";
	G_Unit_Tags_Logic setVariable ["G_Revive_Player_List", _var, true];
	sleep 1;
	publicVariable "G_Unit_Tag_Num_List";
};

if (G_isClient) then {
	waitUntil {!isNil "G_Unit_Tag_Num_List"};
	waitUntil {!isNull G_Unit_Tags_Logic};

	G_fnc_Unit_Tag_Exec = {
		_unit = _this select 0;
		_a = _this select 1;
		if (_unit == player) exitWith {};
		
		call compile format ["G_Unit_Tag_%1 = false;", _a];
		_ehID = addMissionEventHandler["Draw3D", format["
			private ['_color', '_height', '_alpha','_distp','_isUnconscious','_exists'];
			_unit = (G_Unit_Tags_Logic getVariable 'G_Revive_Player_List') select %1;
			if ((name _unit) == 'Error: No Unit') then {
				call compile format ['G_Unit_Tag_%1 = true', %1];
			};
			_distp = _unit distance player;
			if ((_distp <= G_Unit_Tag_Distance) and ((player getVariable 'G_Side') == (_unit getVariable 'G_Side'))) then {
				if ((G_Unit_Tag_Display == 1) and !(cursorTarget == _unit)) exitWith {};
				_alpha = (-0.02*(_distp))+(0.025*(G_Unit_Tag_Distance));
				_isUnconscious = false;
				_exists = false;
				if (!isNil {_unit getVariable 'G_Unconscious'}) then {
					_isUnconscious = _unit getVariable 'G_Unconscious';
					_exists = true;
				};
				if (((_isUnconscious or (!_exists)) or (!alive _unit)) and (G_Revive_System)) then {
					_color = [1,0,0,_alpha];
				} else {
					if (_unit in units player) then {
						_color = G_Unit_Tag_SquadColor + [_alpha];
					}
					else
					{
						_color = G_Unit_Tag_Color + [_alpha];
					};
				};
				_height = 0.0053*(_distp)+2;
				drawIcon3D ['', _color, [(visiblePosition _unit) select 0, (visiblePosition _unit) select 1, ((visiblePosition _unit) select 2) + _height], 0, 0, 0, call compile G_Unit_Tag_Text, 0, 0.03, 'EtelkaMonospacePro'];
			};
		",_a, _unit]];
		call compile format["
			G_Unit_Tag_%1 = false;
			_unit = (G_Unit_Tags_Logic getVariable 'G_Revive_Player_List') select %1;
			waitUntil {G_Unit_Tag_%1};
			removeMissionEventHandler ['Draw3D', %2];
		",_a, _ehID];
	};
	
	switch (G_Unit_Tag_Display) do {
		case 0: {
			G_Unit_Tags_Key_Pressed = false;
			waitUntil {!isNull (findDisplay 46)};
			(findDisplay 46) displayAddEventHandler ["KeyDown","if ((_this select 1) == G_Unit_Tag_Display_Key) then {G_Unit_Tags_Key_Pressed = true; false;};"]; 
			while {true} do {
				waitUntil {G_Unit_Tags_Key_Pressed};
				G_Unit_Tags_Key_Pressed = false;
				{
					if (_x isKindOf "CAManBase") then {
						[_x, (_x getVariable "G_Unit_Tag_Number")] spawn G_fnc_Unit_Tag_Exec;
					};
				} forEach allUnits;
				sleep G_Unit_Tag_Display_Time;
				removeAllMissionEventHandlers "Draw3D";
			};
		};

		case 1: {
			{
				if (_x isKindOf "CAManBase") then {
					[_x, (_x getVariable "G_Unit_Tag_Number")] spawn G_fnc_Unit_Tag_Exec;
				};
			} forEach allUnits;
		};
		
		case 2: {
			{
				if (_x isKindOf "CAManBase") then {
					[_x, (_x getVariable "G_Unit_Tag_Number")] spawn G_fnc_Unit_Tag_Exec;
				};
			} forEach allUnits;
		};
	};
};