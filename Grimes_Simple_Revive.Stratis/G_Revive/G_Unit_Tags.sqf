//Controls 3D Unit Tags
//Format tag text for player
if (G_isClient) then {
	//If tags are to show distance, include it in formatted text
	if (G_Unit_Tag_ShowDistance) then {
		G_Unit_Tag_Text = "format['%1 (%2m)', name _unit, ceil(_unit distance player)]";
	}
	else
	{
		G_Unit_Tag_Text = "name _unit";
	};
};

//Create central control on server
if (G_isServer) then {
	//Create helipad to be game logic
	_hp = "Land_HelipadEmpty_F" createVehicle [0,0,0];
	_hp setVehicleVarName "G_Unit_Tags_Logic";
	//Make game logic object public
	//bug - why format it this way?
	_hp call compile format ["%1 = _this; publicVariable ""%1""", "G_Unit_Tags_Logic"];
	//Start player list as game logic object variable, but don't broadcast yet
	//bug - use of "player" is misleading; this list includes AI, as intended
	G_Unit_Tags_Logic setVariable ["G_Revive_Player_List", [], false];
	//Start tag number counter, to become public variable
	G_Unit_Tag_Num_List = 0;
	//Add all units to player list
	{
		//bug - is this check necessary?
		if (_x isKindOf "CAManBase") then {
			//Assign Tag Number to unit and broadcast
			_x setVariable ["G_Unit_Tag_Number", G_Unit_Tag_Num_List, true];
			//Add unit and tag number to player list
			(G_Unit_Tags_Logic getVariable "G_Revive_Player_List") set [G_Unit_Tag_Num_List, _x];
			//+1 to tag number counter
			G_Unit_Tag_Num_List = G_Unit_Tag_Num_List + 1; 
		};
	} forEach allUnits;
	//Obtain complete local player list
	_var = G_Unit_Tags_Logic getVariable "G_Revive_Player_List";
	//Broadcast player list
	G_Unit_Tags_Logic setVariable ["G_Revive_Player_List", _var, true];
	//Wait for broadcast
	//bug - is this necessary?
	sleep 1;
	//Broadcast tag number counter
	publicVariable "G_Unit_Tag_Num_List";
};

//Handle Unit Tags on client
if (G_isClient) then {
	//Wait for server to make Unit Tag variables public
	waitUntil {sleep 0.1; !isNil "G_Unit_Tag_Num_List"};
	waitUntil {sleep 0.1; !isNull G_Unit_Tags_Logic};
	
	//bug - able to slow the waitUntil in here?
	G_fnc_Unit_Tag_Exec = {
		_unit = _this select 0;
		//bug - and _a is...?
		_a = _this select 1;
		//Do not display own tag
		if (_unit == player) exitWith {};
		
		//bug - consider formatting differently to allow for syntax highlighting/easier reading
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
						_color = +G_Unit_Tag_SquadColor;
					}
					else
					{
						_color = +G_Unit_Tag_Color;
					};
					_color pushBack _alpha;
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
	
	//Handle display of Unit Tags depending on setting
	switch (G_Unit_Tag_Display) do {
		case 0: {
			//By key press
			//By default, key is not pressed
			G_Unit_Tags_Key_Pressed = false;
			//Common display EH fix
			waitUntil {sleep 0.1; !isNull (findDisplay 46)};
			//Add keydown EH for certain keydown to result in true
			(findDisplay 46) displayAddEventHandler ["KeyDown","if ((_this select 1) == G_Unit_Tag_Display_Key) then {G_Unit_Tags_Key_Pressed = true; false;};"]; 
			while {true} do {
				//Wait for keydown
				waitUntil {sleep 0.1; G_Unit_Tags_Key_Pressed};
				//Reset keydown variable
				G_Unit_Tags_Key_Pressed = false;
				//Execute Unit Tag handling for each unit
				{
					if (_x isKindOf "CAManBase") then {
						[_x, (_x getVariable "G_Unit_Tag_Number")] spawn G_fnc_Unit_Tag_Exec;
					};
				} forEach allUnits;
				//Wait for display time
				sleep G_Unit_Tag_Display_Time;
				//Remove all Draw3D EH's
				removeAllMissionEventHandlers "Draw3D";
			};
		};

		case 1: {
			//Cursor over unit to display
			{
				//Execute Unit Tag handling for each unit
				if (_x isKindOf "CAManBase") then {
					[_x, (_x getVariable "G_Unit_Tag_Number")] spawn G_fnc_Unit_Tag_Exec;
				};
			} forEach allUnits;
		};
		
		case 2: {
			//Always visible
			{
				//Execute Unit Tag handling for each unit
				if (_x isKindOf "CAManBase") then {
					[_x, (_x getVariable "G_Unit_Tag_Number")] spawn G_fnc_Unit_Tag_Exec;
				};
			} forEach allUnits;
		};
	};
};