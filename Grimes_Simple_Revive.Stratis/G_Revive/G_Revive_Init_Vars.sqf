////Settings Validation
_validationFailed = [];
//Generic
if (typeName G_Briefing != "BOOL") then {_validationFailed pushBack "G_Briefing must be true/false!"};

//Revive
if (typeName G_Revive_System != "BOOL") then {_validationFailed pushBack "G_Revive_System must be true/false!"};
if (typeName G_Revive_AI_Unconscious != "ARRAY") then {_validationFailed pushBack "G_Revive_AI_Unconscious must be an array of sides!"};
{
	if (typeName _x != "SIDE") then {_validationFailed pushBack "G_Revive_AI_Unconscious must be array containing only WEST, EAST, RESISTANCE, or CIVILIAN!"};
} forEach G_Revive_AI_Unconscious;
if ((typeName G_Revive_Time_Limit != "SCALAR") || (G_Revive_Time_Limit < -1)) then {_validationFailed pushBack "G_Revive_Time_Limit must be a number greater than or equal to -1!"};
if ((typeName G_Revive_DownsPerLife != "SCALAR") || (G_Revive_DownsPerLife < 0)) then {_validationFailed pushBack "G_Revive_DownsPerLife must be an integer greater than or equal to 0!"};
if (typeName G_Revive_Can_Revive != "ARRAY") then {_validationFailed pushBack "G_Revive_Can_Revive must be an array of classnames as strings!"};
{
	if (typeName _x != "STRING") then {_validationFailed pushBack "G_Revive_Can_Revive must be an array of classnames as strings!"};
} forEach G_Revive_Can_Revive;
if ((typeName G_Revive_actionTime != "SCALAR") || (G_Revive_actionTime < 0)) then {_validationFailed pushBack "G_Revive_actionTime must be an integer greater than or equal to 0!"};
if ((typeName G_Revive_Requirement != "SCALAR") || (G_Revive_Requirement < 0)) then {_validationFailed pushBack "G_Revive_Requirement must be an integer greater than or equal to 0!"};
if (typeName G_Revive_Black_Screen != "BOOL") then {_validationFailed pushBack "G_Revive_Black_Screen must be true/false!"};
if (typeName G_Revive_Action_Color != "STRING") then {_validationFailed pushBack "G_Revive_Action_Color must be an HTML Color Code in string format."};
if (typeName G_Revive_Load_Types != "ARRAY") then {_validationFailed pushBack "G_Revive_Load_Types must be an array of CfgVehicle types as strings!"};
{
	if (typeName _x != "STRING") then {_validationFailed pushBack "G_Revive_Load_Types must be an array of CfgVehicle types as strings!"};
} forEach G_Revive_Load_Types;
if (typeName G_Eject_Occupants != "BOOL") then {_validationFailed pushBack "G_Eject_Occupants must be true/false!"};
if (typeName G_Explosion_Eject_Occupants != "BOOL") then {_validationFailed pushBack "G_Explosion_Eject_Occupants must be true/false!"};
if ((typeName G_Revive_Reward != "SCALAR") || (G_Revive_Reward < 0)) then {_validationFailed pushBack "G_Revive_Reward must be a number greater than or equal to 0!"};
if ((typeName G_TK_Penalty != "SCALAR") || (G_TK_Penalty > 0)) then {_validationFailed pushBack "G_TK_Penalty must be a number less than or equal to 0!"};

//Respawn/Initial Spawn
if ((typeName G_Init_Start != "SCALAR") || !((G_Init_Start > -1) && (G_Init_Start < 3))) then {_validationFailed pushBack "G_Init_Start must be defined as 0, 1, or 2!"};
if ((typeName G_JIP_Start != "SCALAR") || !((G_JIP_Start > -1) && (G_JIP_Start < 3))) then {_validationFailed pushBack "G_JIP_Start must be defined as 0, 1, or 2!"};
if (typeName G_Respawn_Button != "BOOL") then {_validationFailed pushBack "G_Respawn_Button must be true/false!"};
if ((typeName G_Respawn_Time != "SCALAR") || (G_Respawn_Time < 0)) then {_validationFailed pushBack "G_Respawn_Time must be a number greater than or equal to 0!"};
if ((typeName G_Num_Respawns != "SCALAR") || (G_Num_Respawns < -1)) then {_validationFailed pushBack "G_Num_Respawns must be an integer greater than or equal to -1!"};
if (typeName G_Spectator != "BOOL") then {_validationFailed pushBack "G_Spectator must be true/false!"};
if (typeName G_Squad_Leader_Spawn != "BOOL") then {_validationFailed pushBack "G_Squad_Leader_Spawn must be true/false!"};
if (typeName G_Squad_Leader_Marker != "BOOL") then {_validationFailed pushBack "G_Squad_Leader_Marker must be true/false!"};
if ((typeName G_Squad_Leader_Mkr_Type != "STRING") || (typeName G_Squad_Leader_Mkr_Color != "STRING") || (typeName G_Squad_Leader_Mkr_Text != "STRING")) then {_validationFailed pushBack "G_Squad_Leader_Mkr_SETTINGHERE must all be strings except for Refresh. If not in use, still have empty quotes."};
if ((typeName G_Squad_Leader_Mkr_Refresh != "SCALAR") || (G_Squad_Leader_Mkr_Refresh <= 0)) then {_validationFailed pushBack "G_Squad_Leader_Mkr_Refresh must be a number greater than 0!"};
if (typeName G_AI_Fixed_Spawn != "BOOL") then {_validationFailed pushBack "G_AI_Fixed_Spawn must be true/false!"};
if ((typeName G_AI_Fixed_Spawn_WEST != "STRING") || (typeName G_AI_Fixed_Spawn_EAST != "STRING") || (typeName G_AI_Fixed_Spawn_GUER != "STRING") || (typeName G_AI_Fixed_Spawn_CIV != "STRING")) then {_validationFailed pushBack "G_AI_Fixed_Spawn_SIDEHERE must all be strings. If not in use, still have empty quotes ("""")."};

//Mobile Respawn Vehicle
if ((typeName G_Mobile_Respawn_WEST != "ARRAY") || (typeName G_Mobile_Respawn_EAST != "ARRAY") || (typeName G_Mobile_Respawn_GUER != "ARRAY") || (typeName G_Mobile_Respawn_CIV != "ARRAY")) then {_validationFailed pushBack "G_Mobile_Respawn_SIDEHERE must be an array of vehicle names. If not in use, still have empty array ([])."};
if (typeName G_Mobile_Respawn_Locked != "BOOL") then {_validationFailed pushBack "G_Mobile_Respawn_Locked must be true/false!"};
if (typeName G_Mobile_Respawn_Moveable != "BOOL") then {_validationFailed pushBack "G_Mobile_Respawn_Moveable must be true/false!"};
if ((typeName G_Mobile_Respawn_Wreck != "SCALAR") || (G_Mobile_Respawn_Wreck < 0)) then {_validationFailed pushBack "G_Mobile_Respawn_Wreck must be a number greater than or equal to 0!"};
if ((typeName G_Mobile_Respawn_RespTimer != "SCALAR") || (G_Mobile_Respawn_RespTimer < 0)) then {_validationFailed pushBack "G_Mobile_Respawn_RespTimer must be a number greater than or equal to 0!"};
if (typeName G_Mobile_Respawn_Marker != "BOOL") then {_validationFailed pushBack "G_Mobile_Respawn_Marker must be true/false!"};
if ((typeName G_Mobile_Respawn_Mkr_Type != "STRING") || (typeName G_Mobile_Respawn_Mkr_Color != "STRING") || (typeName G_Mobile_Respawn_Mkr_Text != "STRING")) then {_validationFailed pushBack "G_Mobile_Respawn_Mkr_SETTINGHERE must all be strings except for Refresh and Display. If not in use, still have empty quotes."};
if ((typeName G_Mobile_Respawn_Mkr_Refresh != "SCALAR") || (G_Mobile_Respawn_Mkr_Refresh <= 0)) then {_validationFailed pushBack "G_Mobile_Respawn_Mkr_Refresh must be a number greater than 0!"};
if (typeName G_Mobile_Respawn_Mkr_Display != "BOOL") then {_validationFailed pushBack "G_Mobile_Respawn_Mkr_Display must be true/false!"};

//Unit "Tags"
if (typeName G_Unit_Tag != "BOOL") then {_validationFailed pushBack "G_Unit_Tag must be true/false!"};
if ((typeName G_Unit_Tag_Display != "SCALAR") || !((G_Unit_Tag_Display > -1) && (G_Unit_Tag_Display < 3))) then {_validationFailed pushBack "G_Unit_Tag_Display must be defined as 0, 1, or 2!"};
if (typeName G_Unit_Tag_Display_Key != "SCALAR") then {_validationFailed pushBack "G_Unit_Tag_Display_Key must be an integer!"};
if ((typeName G_Unit_Tag_Display_Time != "SCALAR") || (G_Unit_Tag_Display_Time <= 0)) then {_validationFailed pushBack "G_Unit_Tag_Display_Time must be a number greater than 0!"};
if ((typeName G_Unit_Tag_Distance != "SCALAR") || (G_Unit_Tag_Distance <= 0)) then {_validationFailed pushBack "G_Unit_Tag_Distance must be a number greater than 0!"};
if (typeName G_Unit_Tag_ShowDistance != "BOOL") then {_validationFailed pushBack "G_Unit_Tag_ShowDistance must be true/false!"};
if (typeName G_Unit_Tag_Color != "ARRAY") then {_validationFailed pushBack "G_Unit_Tag_Color must be an array of 3 numbers from 0 to 1!"};
if ((count G_Unit_Tag_Color) != 3) then {_validationFailed pushBack "G_Unit_Tag_Color must be an array of 3 numbers from 0 to 1!"};
{
	if ((typeName _x != "SCALAR") || !((_x >= 0) && (_x <= 1))) then {_validationFailed pushBack "G_Unit_Tag_Color must be an array of 3 numbers from 0 to 1!"};
} forEach G_Unit_Tag_Color;
if (typeName G_Unit_Tag_SquadColor != "ARRAY") then {_validationFailed pushBack "G_Unit_Tag_SquadColor must be an array of 3 numbers from 0 to 1!"};
if ((count G_Unit_Tag_SquadColor) != 3) then {_validationFailed pushBack "G_Unit_Tag_SquadColor must be an array of 3 numbers from 0 to 1!"};
{
	if ((typeName _x != "SCALAR") || !((_x >= 0) && (_x <= 1))) then {_validationFailed pushBack "G_Unit_Tag_SquadColor must be an array of 3 numbers from 0 to 1!"};
} forEach G_Unit_Tag_SquadColor;

//Custom Executions
if ((typeName G_Custom_Exec_1 != "STRING") || (typeName G_Custom_Exec_2 != "STRING") || (typeName G_Custom_Exec_3 != "STRING") || (typeName G_Custom_Exec_4 != "STRING")) then {_validationFailed pushBack "G_Custom_Exec_# must all be strings. If not in use, still have empty quotes ("""")."};

//If error messages exist, format and execute a message for each one and exit
	//Done on all machines to prevent anyone from loading script
if ((count _validationFailed) > 0) exitWith {
	{
		_msg = format["G_Revive_Init ERROR: %1", _x];
		systemChat _msg;
		diag_log _msg;
	} forEach _validationFailed;
};

//Machine detection
G_isDedicated = false;
G_isServer = false;
G_isClient = false;
G_isJIP = false;
if (isDedicated) then {
	G_isDedicated = true;
	G_isServer = true;
}
else
{
	if (isServer) then {G_isServer = true};
	G_isClient = true;
	if (isNull player) then {G_isJIP = true};
	waitUntil {!isNull player};
};

//Define if PvP - Mission where there are more than one playable sides (PvP, TvT, etc.), as opposed to having players on only one side (CoOp, SP, etc.).
//Check each side for "playable" slots, adding to array if they exist
_playableSideArray = [];
{
	if ((playableSlotsNumber _x) > 0) then {
		_playableSideArray pushBack _x;
	};
} forEach [WEST, EAST, RESISTANCE, CIVILIAN];
//If more than one side has playable slots, this is PvP
if ((count _playableSideArray) > 1) then {
	G_PvP = true;
}
else
{
	G_PvP = false;
};

//Track first spawn in order to adjust spawn time and life management accordingly
	//onRespawn occurs on any initial spawn; onKilled occurs with respawnOnStart
	//Without this, on respawnOnStart unit will wait full respawn time and lose a life
G_Revive_InitialSpawn = true;

//Execute briefing for player if enabled
if ((G_Briefing) && (G_isClient)) then {
	[] execVM "G_Revive\G_Briefing.sqf";
};

//If MRVs are in use, execute MRV script
if (count (G_Mobile_Respawn_WEST + G_Mobile_Respawn_EAST + G_Mobile_Respawn_GUER + G_Mobile_Respawn_CIV) > 0) then {
	[] execVM "G_Revive\G_Mobile_Respawn.sqf";
};

//If Squad Leader spawn or markers are enabled, execute associated script for player
//bug - why not rework and use with AI too?
if (((G_Squad_Leader_Spawn) || (G_Squad_Leader_Marker)) && (G_isClient)) then {
	[] execVM "G_Revive\G_Squad_Leader_Spawn.sqf";
};

//If Unit_Tags are enabled, execute associated script depending on new vs. JIP status
if (G_Unit_Tag) then {
	//If JIP need to resume, if initial need to start (for client and server)
	if (G_isJIP) then {
		//Is JIP
		//bug - why is this statement even here?
		player setVariable ["G_Unit_Tag_Number", G_Unit_Tag_Num_List, true];
		//Add unit and tag number to player list
		(G_Unit_Tags_Logic getVariable "G_Revive_Player_List") set [G_Unit_Tag_Num_List, player];
		//Obtain complete local player list
		_var = G_Unit_Tags_Logic getVariable "G_Revive_Player_List";
		//Broadcast player list
		G_Unit_Tags_Logic setVariable ["G_Revive_Player_List", _var, true];
		//Add one to tag number list
		//bug - what if this JIP is a replacement? Is this appropriate?
		G_Unit_Tag_Num_List = G_Unit_Tag_Num_List + 1; 
		publicVariable "G_Unit_Tag_Num_List";
		//Wait for variable broadcasts
		sleep 1;
		_handle = [] execVM "G_Revive\G_Unit_Tags.sqf";
		if (G_Unit_Tag_Display != 0) then {
			//Wait for Unit Tags to process
			waitUntil {sleep 0.1; scriptDone _handle};
			[player, (player getVariable "G_Unit_Tag_Number")] remoteExec ["G_fnc_Unit_Tag_Exec", 0, true];
		};
	}
	else
	{
		//Fresh start for client and server
		_handle = [] execVM "G_Revive\G_Unit_Tags.sqf";
		if (G_Unit_Tag_Display != 0) then {
			//Wait for Unit Tags to process
			waitUntil {sleep 0.1; scriptDone _handle};
		};
	};
};

//Define EH to handle revive/respawn system
G_fnc_EH = compile preprocessFileLineNumbers "G_Revive\G_fnc_EH.sqf";

//Execute G_fnc_EH on all players and AI by side as enabled
//bug - does this need to be more specifically localized?
	//particularly for AI on isServer
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

//Init revive system
if (G_Revive_System) then {
	//Handle loading game as JIP into an unconscious unit
	if (G_isJIP) then {
		if (player getVariable "G_Unconscious") then {
			_revive_factors = player getVariable "G_Revive_Factors";
			_revive_factors execVM "G_Revive\G_Unconscious.sqf";
		};
	};

	//Define player-related incapacitated functions
	if (G_isClient) then {
		//Define function for "nearest rescuer" text
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
					
					//Format text to be displayed
					_text = format["\n     Nearest Potential Rescuers:\n     %1\n     %2\n     %3\n     %4\n     %5", _unit0, _unit1, _unit2, _unit3, _unit4];
					//Output nearest rescuers
					((_this select 0) displayCtrl 1001) ctrlSetText _text;
					//Update list every 5 seconds
					sleep 5;
				};
			};
		};
		
		//Define function for "downs/lives remaining" text
		G_fnc_Dialog_Downs_Text = {
			private ["_downs", "_lives"];
			//If downs-per-life is limited, display remaining, otherwise text
			if (G_Revive_DownsPerLife > 0) then {
				//Subtract accrued number of downs from the limit to obtain remainder
				_downs = G_Revive_DownsPerLife - (player getVariable "G_Downs");
			}
			else
			{
				_downs = "Unlimited";
			};
			
			//If number of lives is limited, display remaining, otherwise text
			if (G_Num_Respawns == -1) then {
				_lives = "Unlimited";
			}
			else
			{
				_lives = player getVariable "G_Lives";
			};
			//Format text to be displayed
			_text = format["\n\n            Downs Remaining: %1\n            Lives Remaining: %2", _downs, _lives];
			//Display the "lives remaining" dialog"
			((_this select 0) displayCtrl 1002) ctrlSetText _text;
		};
	};
	
	//Define function that handles Load/Unload of player
	G_fnc_moveInCargoToUnloadAction = {
		_unit = _this select 0;
		_vehicle = _this select 1;
		_side = _this select 2;
		
		//Command AI to stay in vehicle
		_unit assignAsCargo _vehicle;
		//Move unit into vehicle
		_unit moveInCargo _vehicle;
		//Perform DeadState animation due to lack of Unconscious anim in vehicle
		//bug - check locality
		[_unit, "Unconscious"] remoteExecCall ["playAction", 0, true];
		//Set vehicle side to unit's side for action condition
		//bug - is this reset later? 
		_vehicle setVariable ["G_Side", _unit getVariable "G_Side", true];
		
		//Add Unload action for unit to vehicle
		_unloadActionID = _vehicle addAction [format["<t color=""%2"">Unload %1</t>", name _unit, G_Revive_Action_Color], "G_Revive\G_Unload_Action.sqf", [_unit], 1.5, true, true, "", "((_this getVariable ""G_Side"") == (_target getVariable ""G_Side"")) && ((_target distance _this) < 5) and ((speed _target) < 1)"];
		
		//Create parallel loop to monitor Unload action
		//bug - can this not just be accomplished in the Unload script, instead of cycling?
		[_unit, _vehicle, _unloadActionID] spawn {
			_unit = _this select 0;
			_vehicle = _this select 1;
			_unloadActionID = _this select 2;
			//Wait for unit to be unloaded or no longer unconscious
			waitUntil {sleep 0.3; ((isNull (_unit getVariable "G_Loaded")) || (!(_unit getVariable "G_Unconscious")))};
			
			//Remove the Unload action from the vehicle
			_vehicle removeAction _unloadActionID;
		};
	};
};

//If player's respawn button is disabled by script, execute loop that prevents use of it
if (!(G_Respawn_Button) && (G_isClient)) then {
	[] spawn {
		while {true} do {
			//Wait for game menu to open
			waitUntil {sleep 0.1; !isNull (findDisplay 49)};
			//Add EH to close game menu when respawn button is clicked and announce that it is disabled
			_respawnButtonEH = ((findDisplay 49) displayCtrl 1010) ctrlAddEventHandler ["MouseButtonDown",{(findDisplay 49) closeDisplay 0; titleText ["The Respawn Button is disabled by the host!","PLAIN",1]; titleFadeOut 5;}]; 
			//Wait for game menu to be closed (and EH deleted)
			waitUntil {sleep 0.1; isNull (findDisplay 49)};
		};
	};  
};