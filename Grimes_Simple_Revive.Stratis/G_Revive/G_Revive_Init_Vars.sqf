////Checks
//Generic
if (typeName G_PvP != "BOOL") exitWith {systemChat "G_Revive_Init - G_PvP must be true/false!"};
if (typeName G_Briefing != "BOOL") exitWith {systemChat "G_Revive_Init - G_Briefing must be true/false!"};

//Revive
if (typeName G_Revive_System != "BOOL") exitWith {systemChat "G_Revive_Init - G_Revive_System must be true/false!"};
if (typeName G_Revive_AI_Unconscious != "ARRAY") exitWith {systemChat "G_Revive_Init - G_Revive_AI_Unconscious must be an array of sides!"};
//if ((typeName (foreach G_Revive_AI_Unconscious) != "SIDE")) exitWith {systemChat "G_Revive_Init - G_Friendly_Side must be WEST, EAST, RESISTANCE, or CIVILIAN!"};
if ((typeName G_Revive_Time_Limit != "SCALAR") || (G_Revive_Time_Limit < -1)) exitWith {systemChat "G_Revive_Init - G_Revive_Time_Limit must be a number greater than or equal to -1!"};
if ((typeName G_Revive_DownsPerLife != "SCALAR") || (G_Revive_DownsPerLife < 0)) exitWith {systemChat "G_Revive_Init - G_Revive_DownsPerLife must be an integer greater than or equal to 0!"};
if ((typeName G_Revive_Time_To != "SCALAR") || (G_Revive_Time_To < 0)) exitWith {systemChat "G_Revive_Init - G_Revive_Time_To must be an integer greater than or equal to 0!"};
if ((typeName G_Revive_Requirement != "SCALAR") || (G_Revive_Requirement < 0)) exitWith {systemChat "G_Revive_Init - G_Revive_Requirement must be an integer greater than or equal to 0!"};
if ((typeName G_Revive_Black_Screen != "SCALAR") || !((G_Revive_Black_Screen == 0) || (G_Revive_Black_Screen == 1))) exitWith {systemChat "G_Revive_Init - G_Revive_Black_Screen must be defined as 0 or 1!"};
if (typeName G_Revive_Action_Color != "STRING") exitWith {systemChat "G_Revive_Init - G_Revive_Action_Color must be an HTML Color Code in string."};
if (typeName G_Eject_Occupants != "BOOL") exitWith {systemChat "G_Revive_Init - G_Eject_Occupants must be true/false!"};
if (typeName G_Explosion_Eject_Occupants != "BOOL") exitWith {systemChat "G_Revive_Init - G_Explosion_Eject_Occupants must be true/false!"};
if ((typeName G_Revive_Reward != "SCALAR") || (G_Revive_Reward < 0)) exitWith {systemChat "G_Revive_Init - G_Revive_Reward must be a number greater than or equal to 0!"};
if ((typeName G_TK_Penalty != "SCALAR") || (G_TK_Penalty > 0)) exitWith {systemChat "G_Revive_Init - G_TK_Penalty must be a number less than or equal to 0!"};

//Respawn/Initial Spawn
if ((typeName G_Init_Start != "SCALAR") || !((G_Init_Start > -1) and (G_Init_Start < 3))) exitWith {systemChat "G_Revive_Init - G_Init_Start must be defined as 0, 1, or 2!"};
if ((typeName G_JIP_Start != "SCALAR") || !((G_JIP_Start > -1) and (G_JIP_Start < 3))) exitWith {systemChat "G_Revive_Init - G_JIP_Start must be defined as 0, 1, or 2!"};
if (typeName G_Respawn_Button != "BOOL") exitWith {systemChat "G_Revive_Init - G_Respawn_Button must be true/false!"};
if ((typeName G_Respawn_Time != "SCALAR") || (G_Respawn_Time < 0)) exitWith {systemChat "G_Revive_Init - G_Respawn_Time must be a number greater than or equal to 0!"};
if ((typeName G_Num_Respawns != "SCALAR") || (G_Num_Respawns < -1)) exitWith {systemChat "G_Revive_Init - G_Num_Respawns must be an integer greater than or equal to -1!"};
if (typeName G_Spectator != "BOOL") exitWith {systemChat "G_Revive_Init - G_Spectator must be true/false!"};
if (typeName G_Squad_Leader_Spawn != "BOOL") exitWith {systemChat "G_Revive_Init - G_Squad_Leader_Spawn must be true/false!"};
if (typeName G_Squad_Leader_Marker != "BOOL") exitWith {systemChat "G_Revive_Init - G_Squad_Leader_Marker must be true/false!"};
if ((typeName G_Squad_Leader_Mkr_Type != "STRING") || (typeName G_Squad_Leader_Mkr_Color != "STRING") || (typeName G_Squad_Leader_Mkr_Text != "STRING")) exitWith {systemChat "G_Revive_Init - G_Squad_Leader_Mkr_SETTINGHERE must all be strings except for Refresh. If not in use, still have empty quotes."};
if ((typeName G_Squad_Leader_Mkr_Refresh != "SCALAR") || (G_Squad_Leader_Mkr_Refresh <= 0)) exitWith {systemChat "G_Revive_Init - G_Squad_Leader_Mkr_Refresh must be a number greater than 0!"};
if (typeName G_AI_Fixed_Spawn != "BOOL") exitWith {systemChat "G_Revive_Init - G_AI_Fixed_Spawn must be true/false!"};
if ((typeName G_AI_Fixed_Spawn_WEST != "STRING") || (typeName G_AI_Fixed_Spawn_EAST != "STRING") || (typeName G_AI_Fixed_Spawn_GUER != "STRING") || (typeName G_AI_Fixed_Spawn_CIV != "STRING")) exitWith {systemChat "G_Revive_Init - G_AI_Fixed_Spawn_SIDEHERE must all be strings. If not in use, still have empty quotes."};

//Mobile Respawn Vehicle
if (typeName G_Mobile_Respawn_Locked != "BOOL") exitWith {systemChat "G_Revive_Init - G_Mobile_Respawn_Locked must be true/false!"};
if (typeName G_Mobile_Respawn_Moveable != "BOOL") exitWith {systemChat "G_Revive_Init - G_Mobile_Respawn_Moveable must be true/false!"};
if ((typeName G_Mobile_Respawn_Wreck != "SCALAR") || (G_Mobile_Respawn_Wreck < 0)) exitWith {systemChat "G_Revive_Init - G_Mobile_Respawn_Wreck must be a number greater than or equal to 0!"};
if ((typeName G_Mobile_Respawn_RespTimer != "SCALAR") || (G_Mobile_Respawn_RespTimer < 0)) exitWith {systemChat "G_Revive_Init - G_Mobile_Respawn_RespTimer must be a number greater than or equal to 0!"};
if (typeName G_Mobile_Respawn_Marker != "BOOL") exitWith {systemChat "G_Revive_Init - G_Mobile_Respawn_Marker must be true/false!"};
if ((typeName G_Mobile_Respawn_Mkr_Type != "STRING") || (typeName G_Mobile_Respawn_Mkr_Color != "STRING") || (typeName G_Mobile_Respawn_Mkr_Text != "STRING")) exitWith {systemChat "G_Revive_Init - G_Mobile_Respawn_Mkr_SETTINGHERE must all be strings except for Refresh and Display. If not in use, still have empty quotes."};
if ((typeName G_Mobile_Respawn_Mkr_Refresh != "SCALAR") || (G_Mobile_Respawn_Mkr_Refresh <= 0)) exitWith {systemChat "G_Revive_Init - G_Mobile_Respawn_Mkr_Refresh must be a number greater than 0!"};
if (typeName G_Mobile_Respawn_Mkr_Display != "BOOL") exitWith {systemChat "G_Revive_Init - G_Mobile_Respawn_Mkr_Display must be true/false!"};

//Unit "Tags"
if (typeName G_Unit_Tag != "BOOL") exitWith {systemChat "G_Revive_Init - G_Unit_Tag must be true/false!"};
if ((typeName G_Unit_Tag_Display != "SCALAR") || !((G_Unit_Tag_Display > -1) and (G_Unit_Tag_Display < 3))) exitWith {systemChat "G_Revive_Init - G_Unit_Tag_Display must be defined as 0, 1, or 2!"};
if (typeName G_Unit_Tag_Display_Key != "SCALAR") exitWith {systemChat "G_Revive_Init - G_Unit_Tag_Display_Key must be an integer!"};
if ((typeName G_Unit_Tag_Display_Time != "SCALAR") || (G_Unit_Tag_Display_Time <= 0)) exitWith {systemChat "G_Revive_Init - G_Unit_Tag_Display_Time must be a number greater than 0!"};
if ((typeName G_Unit_Tag_Distance != "SCALAR") || (G_Unit_Tag_Distance <= 0)) exitWith {systemChat "G_Revive_Init - G_Unit_Tag_Distance must be a number greater than 0!"};
if (typeName G_Unit_Tag_ShowDistance != "BOOL") exitWith {systemChat "G_Revive_Init - G_Unit_Tag_ShowDistance must be true/false!"};

//Custom Executions
if ((typeName G_Custom_Exec_1 != "STRING") || (typeName G_Custom_Exec_2 != "STRING") || (typeName G_Custom_Exec_3 != "STRING") || (typeName G_Custom_Exec_4 != "STRING")) exitWith {systemChat "G_Revive_Init - G_Custom_Exec_# must all be strings. If not in use, still have empty quotes ("""")."};

//Track first spawn in order to adjust spawn time and life management accordingly
	//onRespawn occurs on any initial spawn; onKilled occurs with respawnOnStart
	//Without this, on respawnOnStart unit will wait full respawn time and lose a life
G_Revive_InitialSpawn = true;

//Execute briefing for player if enabled
if ((G_Briefing) && (G_isClient)) then {
	[] execVM "G_Revive\G_Briefing.sqf";
};

//If MRVs are in use, execute MRV script
//bug - does this need to be more specifically localized?
if (count (G_Mobile_Respawn_WEST + G_Mobile_Respawn_EAST + G_Mobile_Respawn_GUER + G_Mobile_Respawn_CIV) > 0) then {
	[] execVM "G_Revive\G_Mobile_Respawn.sqf";
};

//If Squad Leader spawn or markers are enabled, execute associated script for player
if (((G_Squad_Leader_Spawn) || (G_Squad_Leader_Marker)) && (G_isClient)) then {
	[] execVM "G_Revive\G_Squad_Leader_Spawn.sqf";
};

//If Unit_Tags are enabled, execute associated script depending on new vs. JIP status
//bug - does this need to be more specifically localized?
if (G_Unit_Tag) then {
	if (G_isJIP) then {
		waitUntil {alive player};
		player setVariable ["G_Unit_Tag_Number", G_Unit_Tag_Num_List, true];
		(G_Unit_Tags_Logic getVariable "G_Revive_Player_List") set [G_Unit_Tag_Num_List, player];
		_var = G_Unit_Tags_Logic getVariable "G_Revive_Player_List";
		G_Unit_Tags_Logic setVariable ["G_Revive_Player_List", _var, true];
		G_Unit_Tag_Num_List = G_Unit_Tag_Num_List + 1; 
		publicVariable "G_Unit_Tag_Num_List";
		sleep 1;
		_handle = [] execVM "G_Revive\G_Unit_Tags.sqf";
		if (G_Unit_Tag_Display != 0) then {
			waitUntil {scriptDone _handle};
			[player, (player getVariable "G_Unit_Tag_Number")] remoteExec ["G_fnc_Unit_Tag_Exec", 0, true];
		};
	}
	else
	{
		_handle = [] execVM "G_Revive\G_Unit_Tags.sqf";
		if (G_Unit_Tag_Display != 0) then {
			waitUntil {scriptDone _handle};
		};
	};
};

//Define EH to handle revive/respawn system
G_fnc_EH = compile preprocessFileLineNumbers "G_Revive\G_fnc_EH.sqf";

//Execute G_fnc_EH on all players and AI by side as enabled
//bug - does this need to be more specifically localized?
{
	if (isPlayer _x) then {
		//Is a player
		[_x] spawn G_fnc_EH;
	}
	else
	{
		//Is an AI
		if ((side _x) in G_Revive_AI_Unconscious) then {
			[_x] spawn G_fnc_EH;
		};
	};
} forEach allUnits;

//Handle loading game as JIP into an unconscious unit
if (G_isJIP) then {
	if (player getVariable "G_Unconscious") then {
		_revive_factors = player getVariable "G_Revive_Factors";
		_revive_factors execVM "G_Revive\G_Unconscious.sqf";
	};
};

//If revive system is enabled, create handler for key strokes
if (G_Revive_System) then {
	G_fnc_ReviveKeyDownAbort = {
		//bug - what are each of these, and is this all necessary?
		switch (_this select 0) do {
			case 17: {G_Revive_Abort = true; [] call G_fnc_Revive_Abort;};
			case 30: {G_Revive_Abort = true; [] call G_fnc_Revive_Abort;};
			case 31: {G_Revive_Abort = true; [] call G_fnc_Revive_Abort;};
			case 32: {G_Revive_Abort = true; [] call G_fnc_Revive_Abort;};
			case 200: {G_Revive_Abort = true; [] call G_fnc_Revive_Abort;};
			case 203: {G_Revive_Abort = true; [] call G_fnc_Revive_Abort;};
			case 208: {G_Revive_Abort = true; [] call G_fnc_Revive_Abort;};
			case 205: {G_Revive_Abort = true; [] call G_fnc_Revive_Abort;};
		};
	};
};

//If player's respawn button is disabled by script, execute loop that prevents use of it
if (!(G_Respawn_Button) and (G_isClient)) then {
	[] spawn {
		while {true} do {
			//Wait for game menu to open
			waitUntil {!isNull (findDisplay 49)};
			//Add EH to close game menu when respawn button is clicked and announce that it is disabled
			_respawnButtonEH = ((findDisplay 49) displayCtrl 1010) ctrlAddEventHandler ["MouseButtonDown",{(findDisplay 49) closeDisplay 0; titleText ["The Respawn Button is disabled by the host!","PLAIN",1]; titleFadeOut 5;}]; 
			//Wait for game menu to be closed (and EH deleted)
			waitUntil {isNull (findDisplay 49)};
		};
	};  
};

//Define function that handles Load/Unload of player
G_fnc_moveInCargoToUnloadAction = {
	waitUntil {!isNull player};
	_unit = _this select 0;
	_vehicle = _this select 1;
	_side = _this select 2;
	
	_unit assignAsCargo _vehicle;
	_unit moveInCargo _vehicle;
	[_unit, "DeadState"] remoteExecCall ["playMoveNow", 0, true];
	_vehicle setVariable ["G_Side", _unit getVariable "G_Side", true];
	
	_unloadActionID = _vehicle addAction [format["<t color=""%2"">Unload %1</t>",name _unit,G_Revive_Action_Color],"G_Revive\G_Unload_Action.sqf",[_unit],1.5,true,true,"", "((_this getVariable ""G_Side"") == (_target getVariable ""G_Side"")) and ((_target distance _this) < 5) and ((speed _target) < 1)"];

	[_unit, _vehicle, _unloadActionID] spawn {
		_unit = _this select 0;
		_vehicle = _this select 1;
		_unloadActionID = _this select 2;
		waitUntil {sleep 0.25; ((isNull (_unit getVariable "G_Loaded")) || (!(_unit getVariable "G_Unconscious")))};
	
		_vehicle removeAction _unloadActionID;
	};
};

//Define revive system text for player if revive is enabled
if ((G_isClient) and (G_Revive_System)) then {
	G_fnc_Dialog_Rescuer_Text = {
		[_this select 0] spawn {
			private ["_array", "_arrayDistance","_unit0","_unit1","_unit2","_unit3","_unit4"];
			//Continue cycling while player is unconscious and dialog is open
			while {((player getVariable "G_Unconscious") && (dialog))} do {
				//Get array of all "men" within 500m, including player
				_array = nearestObjects [player, ["CAManBase"], 500];
				_arrayDistance = [];
				{
					//Select unit that is not player, is friendly, can revive (or setting undefined), is alive, and is not unconscious
					if ((_x != player) && ((player getVariable "G_Side") == (_x getVariable "G_Side")) && (((typeOf _x) in G_Revive_Can_Revive) || ((count G_Revive_Can_Revive) == 0)) && (alive _x) && !(_x getVariable "G_Unconscious")) then {
						//Add to array with distance from player
						_arrayDistance pushBack ([_x, ceil(_x distance player)]);
					};
				} forEach _array;
				
				//Define empty variables for unit names
				_unit0 = "";
				_unit1 = "";
				_unit2 = "";
				_unit3 = "";
				_unit4 = "";
				
				//Define unit variables with unit name and distanace if available
				for "_i" from 0 to (((count _arrayDistance) - 1) min 4) do {
					call compile format["_unit%1 = format[""%2  (%3m)"", name (_arrayDistance select %1 select 0), _arrayDistance select %1 select 1];", _i, "%1", "%2"];
				};
				
				//Format nearest rescuers
				_text = format["\n     Nearest Potential Rescuers:\n     %1\n     %2\n     %3\n     %4\n     %5", _unit0, _unit1, _unit2, _unit3, _unit4];
				//Output nearest rescuers
				((_this select 0) displayCtrl 1001) ctrlSetText _text;
				//Update list every 5 seconds
				sleep 5;
			};
		};
	};

	G_fnc_Dialog_Downs_Text = {
		private ["_downs", "_lives"];
		if (G_Revive_DownsPerLife > 0) then {
			_downs = (G_Revive_DownsPerLife) - (player getVariable "G_Downs");
		}
		else
		{
			_downs = "Unlimited";
		};
		if (G_Num_Respawns == -1) then {
			_lives = "Unlimited";
		}
		else
		{
			_lives = player getVariable "G_Lives";
		};
		_text = format["\n\n            Downs Remaining: %1\n            Lives Remaining: %2",_downs,_lives];
		((_this select 0) displayCtrl 1002) ctrlSetText _text;
	};
};