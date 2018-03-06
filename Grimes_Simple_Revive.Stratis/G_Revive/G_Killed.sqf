private ["_unit","_respawnDelay","_noLives"];

if (G_Revive_FirstSpawn) then {
	setPlayerRespawnTime 2;
}
else
{
	setPlayerRespawnTime G_Respawn_Time;
};

if (G_Custom_Exec_2 != "") then {
	[] execVM G_Custom_Exec_2;
};

disableserialization;

_unit = [_this,0,objnull,[objnull]] call bis_fnc_param;
_respawnDelay = [_this,3,0,[0]] call bis_fnc_param;

_noLives = false;
if !((G_Num_Respawns == -1) || (G_Revive_FirstSpawn)) then {
	_lives = _unit getVariable "G_Lives";
	_lives = _lives - 1;
	if (_lives < 0) then {
		_noLives = true;
	};
	_unit setVariable ["G_Lives",_lives,true];
};
	
if (_noLives) exitWith {
	if (G_Spectator) then {
		[_unit,_respawnDelay] execVM "G_Revive\G_Spectator.sqf";
	}
	else
	{
		setPlayerRespawnTime 30;
		["END1",false] call BIS_fnc_endMission;
	};
};

//MENU POSITION

if (!alive _unit) then {
	if (playerrespawntime < 1 || !isplayer _unit) exitwith {};
	if (simulationenabled _unit) then {
		if (playerrespawntime < 3) then {setplayerrespawntime (playerrespawntime + 3);};

		sleep 1.9;
		if (G_Revive_Black_Screen == 0) then {
			cutText ["","black out",0.5];
		}
		else
		{
			cutText ["","black in"];
		};
		sleep 1;
	};

	///////////////////////////////////////////////////////////////////////////////////////////
	//--- onPlayerKilled
	///////////////////////////////////////////////////////////////////////////////////////////

	BIS_fnc_respawnMenuPosition_draw = {
		_ctrlMap = _this select 0;
		_display = ctrlparent _ctrlMap;

		if (shownmap) then {
			_ctrlList = _display displayctrl BIS_fnc_respawnMenuPosition_ctrlList;
			_selected = _ctrlList lbvalue lbcursel _ctrlList;

			//--- Draw icons on respawn positions
			_color = (player call bis_fnc_objectSide) call bis_fnc_sidecolor;
			_icon = "selector_selectedFriendly" call bis_fnc_textureMarker;
			_iconSelected = "selector_selectedMission" call bis_fnc_textureMarker;
			{
				_colorLocal = if (_foreachindex == BIS_fnc_respawnMenuPosition_selected) then {[1,1,1,1]} else {_color};
				_iconLocal = if (_foreachindex == _selected) then {_iconSelected} else {_icon};
				_ctrlMap drawicon [
					_iconLocal,
					_colorLocal,
					_x call bis_fnc_position,
					48,
					48,
					time * 16,
					"",
					1
				];
			} foreach BIS_fnc_respawnMenuPosition_positions;
		} else {
			_ctrlMap drawrectangle [[0,0],1e5,1e5,0,[0.1,0.1,0.1,1],"#(argb,8,8,3)color(1,1,1,1)"];
		};
	};
	
	BIS_fnc_respawnMenuPosition_mouseMoving = {
		_ctrlMap = _this select 0;
		_mX = _this select 1;
		_mY = _this select 2;
		_dis = 0.048;
		_selected = -1;
		{
			_pos = _ctrlMap ctrlmapworldtoscreen (_x call bis_fnc_position);
			if (_pos distance [_mX,_mY] < _dis) then {
				_selected = _foreachindex;
			};
		} foreach BIS_fnc_respawnMenuPosition_positions;
		BIS_fnc_respawnMenuPosition_selected = _selected;
	};

	BIS_fnc_respawnMenuPosition_mouseButtonClick = {
		_ctrlMap = _this select 0;
		_button = _this select 1;
		if (_button == 0 && BIS_fnc_respawnMenuPosition_selected >= 0) then {
			_display = ctrlparent _ctrlMap;
			_ctrlList = _display displayctrl BIS_fnc_respawnMenuPosition_ctrlList;
			for "_i" from 0 to (lbsize _ctrlList - 1) do {
				_value = _ctrlList lbvalue _i;
				if (_value == BIS_fnc_respawnMenuPosition_selected) then {
					BIS_fnc_respawnMenuPosition_systemSelect = true;
					BIS_fnc_respawnMenuPosition_respawn = BIS_fnc_respawnMenuPosition_positions select _value;
					_ctrlList lbsetcursel _i;
				};
			};
		};
	};


	[
		"Select Respawn Point",
		{
			scriptname "BIS_fnc_respawnMenuPosition";
			_fnc_scriptName = "BIS_fnc_respawnMenuPosition";
			disableserialization;
			_mode = _this select 0;
			_ctrlListBackground = _this select 1;
			_ctrlList = _this select 2;
			_ctrlContentBackground = _this select 3;
			_ctrlContentGroup = _this select 4;
			_ctrlContent = _this select 5;
			_ctrlMap = _this select 6;
			_ctrlBlackContent = _this select 7;

			switch _mode do {
				case "init": {
					_ctrlContent ctrlenable false;
					_ctrlContentBackground ctrlenable false;
					_ctrlContentGroup ctrlenable false;
					_ctrlContentGroup ctrlshow false;
					_ctrlMap ctrlshow true;

					BIS_fnc_respawnMenuPosition_ctrlList = ctrlIDC _ctrlList;
					BIS_fnc_respawnMenuPosition_selected = -1;
					BIS_fnc_respawnMenuPosition_positions = [];
					BIS_fnc_respawnMenuPosition_systemSelect = true;

					_ctrlMap ctrladdeventhandler ["draw","_this call BIS_fnc_respawnMenuPosition_draw;"];
					_ctrlMap ctrladdeventhandler ["mouseMoving","_this call BIS_fnc_respawnMenuPosition_mouseMoving;"];
					_ctrlMap ctrladdeventhandler ["mouseHolding","_this call BIS_fnc_respawnMenuPosition_mouseMoving;"];
					_ctrlMap ctrladdeventhandler ["mouseButtonClick","_this call BIS_fnc_respawnMenuPosition_mouseButtonClick;"];

					//--- Default map position
					_mapSize = [] call bis_fnc_mapSize;
					_ctrlMap ctrlmapanimadd [0,0.1,[_mapSize * 0.5,_mapSize * 0.5]];
					ctrlmapanimcommit _ctrlMap;

					//--- Warning message about no positions (hidden by default)
					_ctrlContentGroup ctrlshow true;
					_ctrlContent ctrlsetstructuredtext parsetext format [
						"<t size='1.5' align='center'>%1</t>",
						(missionnamespace getvariable ["BIS_fnc_respawnMenuPosition_text",toupper "No respawn positions available"]) //--- ToDo: Localize
					];
					_h = _ctrlContent call bis_fnc_ctrlFitToTextHeight;

					_ctrlContentGroupPos = ctrlposition _ctrlContentGroup;
					_ctrlContentGroupPos set [1,(_ctrlContentGroupPos select 1) + (_ctrlContentGroupPos select 3) * 0.5 - _h * 0.5];
					_ctrlContentGroupPos set [3,_h];
					_ctrlContentGroup ctrlsetposition _ctrlContentGroupPos;
					_ctrlContentGroup ctrlcommit 0;
					_ctrlContentGroup ctrlshow false;

					_ctrlContentBackground ctrlsetposition _ctrlContentGroupPos;
					_ctrlContentBackground ctrlcommit 0;
					_ctrlContentBackground ctrlshow false;

					_ctrlBlackContent ctrlsetfade 0;
					_ctrlBlackContent ctrlcommit 0;
				};
				case "select": {
					if (lbsize _ctrlList == 0) exitwith {};
					_commitTime = 0.5;
					if (BIS_fnc_respawnMenuPosition_systemSelect) then {
						BIS_fnc_respawnMenuPosition_systemSelect = false;
						_commitTime = 0; //--- Should this be disabled?
					};

					_positionID = _ctrlList lbvalue lbcursel _ctrlList;
					if (_positionID < 0) then {
						//--- Random
						_respawnPositions = ((player call bis_fnc_objectSide) call bis_fnc_getRespawnMarkers) + (player call bis_fnc_getRespawnPositions);
						_respawnPositionsCount = count _respawnPositions;
						if (_respawnPositionsCount > 0) then {
							_posXmin = 1e10;
							_posXmax = 0;
							_posYmin = 1e10;
							_posYmax = 0;
							{
								_xPos = _x call bis_fnc_position;
								_posXmin = _posXmin min (_xPos select 0);
								_posXmax = _posXmax max (_xPos select 0);
								_posYmin = _posYmin min (_xPos select 1);
								_posYmax = _posYmax max (_xPos select 1);
							} foreach _respawnPositions;
							_posW =  _posXmax - _posXmin;
							_posH = _posYmax - _posYmin;
							_posX = _posXmin + _posW / 2;
							_posY = _posYmin + _posH / 2;

							_mapPosMax = _ctrlMap ctrlmapworldtoscreen [_posXmax,_posYmax];
							_mapPosMin = _ctrlMap ctrlmapworldtoscreen [_posXmin,_posYmin];
							_mapPosW = (_mapPosMax select 0) - (_mapPosMin select 0);
							_mapPosH = (_mapPosMin select 1) - (_mapPosMax select 1);
							_mapScale = ctrlmapscale _ctrlMap;
							_mapScaleW = _mapScale / ((ctrlposition _ctrlMap select 2) / _mapPosW);
							_mapScaleH = _mapScale / ((ctrlposition _ctrlMap select 3) / _mapPosH);

							_ctrlMap ctrlmapanimadd [_commitTime,(_mapScaleW max _mapScaleH) * 2,[_posX,_posY]];
							ctrlmapanimcommit _ctrlMap;
						};
						BIS_fnc_respawnMenuPosition_respawn = "";
					} else {
						//--- Specific
						_position = BIS_fnc_respawnMenuPosition_positions select _positionID;
						_ctrlMap ctrlmapanimadd [_commitTime,ctrlmapscale _ctrlMap,_position call bis_fnc_position];
						ctrlmapanimcommit _ctrlMap;
						BIS_fnc_respawnMenuPosition_respawn = _position;
					};

					_ctrlBlackContent ctrlsetfade 1;
					_ctrlBlackContent ctrlcommit 0.2;
				};
				case "update": {
					_selected = _ctrlList lbdata lbcursel _ctrlList;
					if (_selected == "") then {_selected = missionnamespace getvariable ["BIS_fnc_respawnMenuPosition_respawn",""];};

					//--- Preload the selected scene
					if (str _selected != """""") then {
						preloadcamera (_selected call bis_fnc_position);
						if (typename _selected == typename objnull) then {1 preloadobject _selected};
					};

					_respawnPositions = ((player call bis_fnc_objectSide) call bis_fnc_getRespawnMarkers) + (player call bis_fnc_getRespawnPositions);
					BIS_fnc_respawnMenuPosition_positions = _respawnPositions;

					//--- Show warning when no positions are available
					_showWarning = count _respawnPositions == 0;
					_ctrlContentGroup ctrlshow _showWarning;
					_ctrlContentBackground ctrlshow _showWarning;

					//--- Get current items
					_currentData = [];
					_previousData = [];
					for "_i" from 0 to (lbsize _ctrlList - 1) do {_previousData set [count _previousData,_ctrlList lbdata _i];};

					//--- Add random selection
					_dataRandom = "<random>";
					if (count _respawnPositions > 1) then {
						_currentData set [count _currentData,_dataRandom];
						if !(_dataRandom in _previousData) then {
							_previousData = [];
							lbclear _ctrlList;
							_lbAdd = _ctrlList lbAdd format ["<%1>",localize "STR_A3_BIS_fnc_respawnMenuPosition_random"];
							_ctrlList lbsetvalue [_lbAdd,-1];
							_ctrlList lbsetdata [_lbAdd,_dataRandom];
						};
					};

					//--- Add available positions
					_cursel = 0;
					_selectedStr = str _selected;
					{
						_text = "";
						_picture = "";
						_canAdd = true;
						switch (typename _x) do {
							case (typename ""): {
								_text = markertext _x;
								_picture = if (markertype _x == "empty") then {""} else {(markertype _x) call bis_fnc_textureMarker};
							};
							case (typename objnull): {
								_xVeh = vehicle _x;
								_text = name _x;
								if (isnull group _x) then {
									_text = gettext (configfile >> "cfgvehicles" >> typeof _xVeh >> "displayName");
								} else {
									if !(isplayer _x) then {_text = format ["%1: %2",localize "str_player_ai",_text]};
								};
								_picture = gettext (configfile >> "cfgvehicles" >> typeof _xVeh >> "icon") call bis_fnc_textureVehicleIcon;
								_canAdd = !isnull _x;
							};
							case (typename []): {
							};
						};
						if (_canAdd) then {
							if (_text == "") then {_text = format [localize "STR_A3_BIS_fnc_respawnMenuPosition_grid",mapgridposition (_x call bis_fnc_position)]};
							if (_picture == "") then {_picture = "respawn_inf" call bis_fnc_texturemarker;};

							_xStr = str _x;
							_currentData set [count _currentData,_xStr];
							_lbAdd = if (_xStr in _previousData) then {_previousData find _xStr} else {_ctrlList lbadd _text};
							_ctrlList lbsetvalue [_lbAdd,_foreachindex];
							_ctrlList lbsetdata [_lbAdd,_xStr];
							_ctrlList lbsetpicture [_lbAdd,_picture];
							if (_xStr == _selectedStr) then {_cursel = _lbAdd;};
						};
					} foreach _respawnPositions;
					if (
						missionnamespace getvariable ["BIS_fnc_respawnMenuPosition_systemSelect",false]
						&&
						count BIS_fnc_respawnMenuPosition_positions > 0
					) then {
						_positionID = _cursel;
						if (count _respawnPositions > 1) then {_positionID = (_positionID - 1) max 0;}; //--- Offset because of "<random>" item
						_position = BIS_fnc_respawnMenuPosition_positions select _positionID;
						BIS_fnc_respawnMenuPosition_respawn = _position;
						_ctrlList lbsetcursel _cursel;
					};

					//--- Remove obsolete items
					{
						_ctrlList lbdelete (_previousData find _x);
					} foreach (_previousData - _currentData);

					//--- Black in empty list
					if (lbsize _ctrlList == 0 && ctrlfade _ctrlBlackContent == 0) then {
						_ctrlBlackContent ctrlsetfade 1;
						_ctrlBlackContent ctrlcommit 0.2;
					};
				};
			};
		}
	] call bis_fnc_showRespawnMenu;
};