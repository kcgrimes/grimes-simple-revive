//Controls 3D Unit Tags
//Format tag text for player based on distance display setting
if (G_Unit_Tag_ShowDistance) then {
	//Include distance calculation
	G_Unit_Tag_Text = "format['%1 (%2m)', name _x, ceil(_x distance player)]";
}
else
{
	//Don't include distance
	G_Unit_Tag_Text = "name _x";
};

//By overall default, show key as pressed
G_Unit_Tags_Key_Pressed = true;

//Create function to execute Unit Tag mission EH
G_fnc_Unit_Tag_Exec = {
	//Create EH that Draws name for appropriate units each frame
	addMissionEventHandler ["Draw3D", {
		private ["_playerSide", "_unitArray", "_color", "_height", "_alpha", "_unitDistance", "_isIncapacitated"];
		//If key press is not active when enabled, exit
		if (!G_Unit_Tags_Key_Pressed) exitWith {};
		//If player is Renegade, no teammates, so no tags
		if (player getVariable "G_isRenegade") exitWith {};
		//Get player's permanent side
		_playerSide = player getVariable "G_Side";
		//Create blank array for units to be drawn
		_unitArray = [];
		//Select units based on Display setting
		if (G_Unit_Tag_Display != 1) then {
			//0 (keydown) or 2 (constant)
			{
				//If option is not self, is not staying dead, and is friendly and not renegade, Draw
				if ((_x != player) && ((lifeState _x) != "DEAD")) then {
					if (!isNil {_x getVariable "G_Side"}) then {
						if (([_playerSide, _x getVariable "G_Side"] call BIS_fnc_sideIsFriendly) && !(_x getVariable "G_isRenegade")) then {
							_unitArray pushBack _x;
						};
					};
				};
			} forEach (allUnits + allDeadMen);
		}
		else
		{
			//Based on cursorTarget
			//If cursorTarget is a friendly unit that is not renegade, Draw
			if (cursorTarget isKindOf "Man") then {
				if (!isNil {cursorTarget getVariable "G_Side"}) then {
					if (([_playerSide, cursorTarget getVariable "G_Side"] call BIS_fnc_sideIsFriendly) && !(cursorTarget getVariable "G_isRenegade")) then {
						_unitArray pushBack cursorTarget;
					};
				};
			};
		};
		
		//Cycle through potential units
		{
			//Get distance to unit
			_unitDistance = _x distance player;
			//Only draw if close enough
			if (_unitDistance > G_Unit_Tag_Distance) exitWith {};
			//Set alpha based on distance
			_alpha = (-0.02*(_unitDistance))+(0.025*(G_Unit_Tag_Distance));
			//Check if incapacitated
			_isIncapacitated = false;
			if (!isNil {_x getVariable "G_Incapacitated"}) then {
				_isIncapacitated = _x getVariable "G_Incapacitated";
			};
			
			//Color based on status
			if (((_isIncapacitated) || (!alive _x)) && (G_Revive_System)) then {
				//Color red if incapacitated or dead
				//bug - make this a setting?
				_color = [1,0,0,_alpha];
			} 
			else 
			{
				if (_x in units player) then {
					//Squad member
					_color = +G_Unit_Tag_SquadColor;
				}
				else
				{
					//Not squad member
					_color = +G_Unit_Tag_Color;
				};
				//Add alpha to end of color array to complete it
				_color pushBack _alpha;
			};
			//Set height based on distance
			_height = 0.0053*(_unitDistance)+2;
			//Draw the name as defined
			drawIcon3D ["", _color, [(visiblePosition _x) select 0, (visiblePosition _x) select 1, ((visiblePosition _x) select 2) + _height], 0, 0, 0, call compile G_Unit_Tag_Text, 0, 0.03, "EtelkaMonospacePro"];
		} forEach _unitArray;
	}];
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
		//Handle keydown global variable in parallel
		[] spawn {
			while {true} do {
				//Wait for keydown
				waitUntil {sleep 0.1; G_Unit_Tags_Key_Pressed};
				//Wait for display time
				sleep G_Unit_Tag_Display_Time;
				//Reset keydown variable
				G_Unit_Tags_Key_Pressed = false;
			};
		};
		//Execute Unit Tag by key press
		[] spawn G_fnc_Unit_Tag_Exec;
	};

	case 1: {
		//Cursor over unit to display
		[] spawn G_fnc_Unit_Tag_Exec;
	};
	
	case 2: {
		//Always visible
		[] spawn G_fnc_Unit_Tag_Exec;
	};
};