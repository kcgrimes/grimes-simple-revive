////Settings Validation
private ["_validationFailed"];
_validationFailed = [];
//Generic
if (typeName G_Briefing != "BOOL") then {_validationFailed pushBack "G_Briefing must be true/false!"};

//Revive
if (typeName G_Revive_System != "BOOL") then {_validationFailed pushBack "G_Revive_System must be true/false!"};
if (typeName G_Revive_AI_Incapacitated != "ARRAY") then {_validationFailed pushBack "G_Revive_AI_Incapacitated must be an array of sides!"};
{
	if (typeName _x != "SIDE") then {_validationFailed pushBack "G_Revive_AI_Incapacitated must be array containing only WEST, EAST, RESISTANCE, or CIVILIAN!"};
} forEach G_Revive_AI_Incapacitated;
if (typeName G_Revive_Unit_Exclusion != "ARRAY") then {_validationFailed pushBack "G_Revive_Unit_Exclusion must be an array of variable names of units!"};
{
	if (typeName _x != "OBJECT") then {_validationFailed pushBack "G_Revive_Unit_Exclusion must be array containing only variable names of units!"};
} forEach G_Revive_Unit_Exclusion;
if ((typeName G_Revive_bleedoutTime != "SCALAR") || (G_Revive_bleedoutTime < -1)) then {_validationFailed pushBack "G_Revive_bleedoutTime must be a number greater than or equal to -1!"};
if (typeName G_Allow_GiveUp != "BOOL") then {_validationFailed pushBack "G_Allow_GiveUp must be true/false!"};
if ((typeName G_Revive_DownsPerLife != "SCALAR") || (G_Revive_DownsPerLife < 0)) then {_validationFailed pushBack "G_Revive_DownsPerLife must be an integer greater than or equal to 0!"};
if (typeName G_Revive_addonRadio_muteTransmit != "BOOL") then {_validationFailed pushBack "G_Revive_addonRadio_muteTransmit must be true/false!"};
if (typeName G_Revive_addonRadio_muteReceive != "BOOL") then {_validationFailed pushBack "G_Revive_addonRadio_muteReceive must be true/false!"};
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
if ((typeName G_Revive_Messages != "SCALAR") || !((G_Revive_Messages > -1) && (G_Revive_Messages < 3))) then {_validationFailed pushBack "G_Revive_Messages must be defined as 0, 1, or 2!"};

//Respawn/Initial Spawn
if (typeName G_Respawn_Button != "BOOL") then {_validationFailed pushBack "G_Respawn_Button must be true/false!"};
if ((typeName G_Respawn_Time != "SCALAR") || (G_Respawn_Time < 0)) then {_validationFailed pushBack "G_Respawn_Time must be a number greater than or equal to 0!"};
if ((typeName G_Num_Respawns != "SCALAR") || (G_Num_Respawns < -1)) then {_validationFailed pushBack "G_Num_Respawns must be an integer greater than or equal to -1!"};
if (typeName G_Spectator != "BOOL") then {_validationFailed pushBack "G_Spectator must be true/false!"};
if (typeName G_Squad_Leader_Spawn != "BOOL") then {_validationFailed pushBack "G_Squad_Leader_Spawn must be true/false!"};
if (typeName G_Squad_Leader_Marker != "BOOL") then {_validationFailed pushBack "G_Squad_Leader_Marker must be true/false!"};
if ((typeName G_Squad_Leader_Mkr_Type != "STRING") || (typeName G_Squad_Leader_Mkr_Color != "STRING") || (typeName G_Squad_Leader_Mkr_Text != "STRING")) then {_validationFailed pushBack "G_Squad_Leader_Mkr_SETTINGHERE must all be strings except for Refresh. If not in use, still have empty quotes."};
if ((typeName G_Squad_Leader_Mkr_Refresh != "SCALAR") || (G_Squad_Leader_Mkr_Refresh <= 0)) then {_validationFailed pushBack "G_Squad_Leader_Mkr_Refresh must be a number greater than 0!"};
if (typeName G_AI_Fixed_Spawn != "BOOL") then {_validationFailed pushBack "G_AI_Fixed_Spawn must be true/false!"};
if ((typeName G_AI_Fixed_Spawn_WEST != "STRING") || (typeName G_AI_Fixed_Spawn_EAST != "STRING") || (typeName G_AI_Fixed_Spawn_IND != "STRING") || (typeName G_AI_Fixed_Spawn_CIV != "STRING")) then {_validationFailed pushBack "G_AI_Fixed_Spawn_SIDEHERE must all be strings. If not in use, still have empty quotes ("""")."};

//Mobile Respawn Vehicle
if ((typeName G_Mobile_Respawn_WEST != "ARRAY") || (typeName G_Mobile_Respawn_EAST != "ARRAY") || (typeName G_Mobile_Respawn_IND != "ARRAY") || (typeName G_Mobile_Respawn_CIV != "ARRAY")) then {_validationFailed pushBack "G_Mobile_Respawn_SIDEHERE must be an array of vehicle names. If not in use, still have empty array ([])."};
{
	{
		if (isNil {_x}) then {
			_validationFailed pushBack "G_Mobile_Respawn_SIDEHERE must be array containing only variable names of MRVs!"
		}
		else
		{
			if (typeName _x != "OBJECT") then {_validationFailed pushBack "G_Mobile_Respawn_SIDEHERE must be array containing only variable names of MRVs!"};
		};
	} forEach _x;
} forEach [G_Mobile_Respawn_WEST, G_Mobile_Respawn_EAST, G_Mobile_Respawn_IND, G_Mobile_Respawn_CIV];
if (typeName G_Mobile_Respawn_Locked != "BOOL") then {_validationFailed pushBack "G_Mobile_Respawn_Locked must be true/false!"};
if (typeName G_Mobile_Respawn_Movable != "BOOL") then {_validationFailed pushBack "G_Mobile_Respawn_Movable must be true/false!"};
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
if ((typeName G_Custom_Exec_1 != "STRING") || (typeName G_Custom_Exec_2 != "STRING") || (typeName G_Custom_Exec_3 != "STRING") || (typeName G_Custom_Exec_4 != "STRING") || (typeName G_Custom_Exec_5 != "STRING")) then {_validationFailed pushBack "G_Custom_Exec_# must all be strings. If not in use, still have empty quotes ("""")."};

//Handle BIS Revive (only on client)
if (!isDedicated) then {
	if ([player] call BIS_fnc_reviveEnabled) then {_validationFailed pushBack "BIS Revive must be disabled!"};
};

//If error messages exist, format and execute a message for each one and exit
	//Done on all machines to prevent anyone from loading script
if ((count _validationFailed) > 0) exitWith {
	{
		private ["_msg"];
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
private ["_playableSideArray"];
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

//Handle respawnOnStart because onKilled EH triggers when respawnOnStart = 1, so without this block the unit will wait full respawn time and lose a life
if ((getNumber(missionConfigFile >> "respawnOnStart")) == 1) then {
	//respawnOnStart
	//Add extra life if lives are limited to account for respawnOnStart
	if (G_Num_Respawns > -1) then {
		G_Num_Respawns = G_Num_Respawns + 1;
	};
	//Bypass intended respawn time for initial spawn
	if (G_isClient) then {
		setPlayerRespawnTime 2;
	};
}
else
{
	//No respawnOnStart, so set intended respawn time
	if (G_isClient) then {
		//Need to suspend to prevent overwrite by engine, apparently
		[] spawn {
			sleep 1;
			setPlayerRespawnTime G_Respawn_Time;
		};
	};
};

//Execute briefing for player if enabled
if ((G_Briefing) && (G_isClient)) then {
	[] execVM "G_Revive\G_Briefing.sqf";
};

//Define functions for custom executions
if (G_Custom_Exec_1 != "") then {
	G_fnc_Custom_Exec_1 = compile preprocessFileLineNumbers G_Custom_Exec_1;
};
if (G_Custom_Exec_2 != "") then {
	G_fnc_Custom_Exec_2 = compile preprocessFileLineNumbers G_Custom_Exec_2;
};
if (G_Custom_Exec_3 != "") then {
	G_fnc_Custom_Exec_3 = compile preprocessFileLineNumbers G_Custom_Exec_3;
};
if (G_Custom_Exec_4 != "") then {
	G_fnc_Custom_Exec_4 = compile preprocessFileLineNumbers G_Custom_Exec_4;
};
if (G_Custom_Exec_5 != "") then {
	G_fnc_Custom_Exec_5 = compile preprocessFileLineNumbers G_Custom_Exec_5;
};

//Call mandatory definitions for revive system if enabled
if (G_Revive_System) then {
	[] call compile preprocessFileLineNumbers "G_Revive\G_fnc_EH_defs.sqf";
};

//Define onKilled script
G_fnc_onKilled = compile preprocessFileLineNumbers "G_Revive\G_Killed.sqf";
//Define onRespawn script
G_fnc_onRespawn = compile preprocessFileLineNumbers "G_Revive\G_Respawn.sqf";

//Create function that will:
	//Create public object variables as enabled,
	//add EHs for revive system if enabled, 
	//add Fixed Spawn EH to AI if enabled,
G_fnc_EH = compile preprocessFileLineNumbers "G_Revive\G_fnc_EH.sqf";

//Execute G_fnc_EH on all players and AI by side as enabled
{
	if (isPlayer _x) then {
		//Is a player
		[_x] spawn G_fnc_EH;
	}
	else
	{
		//Is an AI
		if ((side _x) in G_Revive_AI_Incapacitated) then {
			[_x] spawn G_fnc_EH;
		};
	};
} forEach (allUnits + allDeadMen);

//Handle loading game as JIP into an incapacitated unit
if (G_Revive_System && G_isJIP) then {
	if (player getVariable "G_Incapacitated") then {
		player spawn G_fnc_enterIncapacitatedState;
	};
};

//If MRVs are in use, execute MRV script
if (count (G_Mobile_Respawn_WEST + G_Mobile_Respawn_EAST + G_Mobile_Respawn_IND + G_Mobile_Respawn_CIV) > 0) then {
	[] execVM "G_Revive\G_Mobile_Respawn.sqf";
};

//If Squad Leader spawn or markers are enabled, execute associated script for player
//bug - why not rework and use with AI too?
if (((G_Squad_Leader_Spawn) || (G_Squad_Leader_Marker)) && (G_isClient)) then {
	[player] execVM "G_Revive\G_Squad_Leader_Spawn.sqf";
};

//If Unit_Tags are enabled, execute associated script for player
if (G_Unit_Tag && G_isClient) then {
	[] execVM "G_Revive\G_Unit_Tags.sqf";
};

//If player's respawn button is disabled by script, execute loop that prevents use of it
if (!(G_Respawn_Button) && (G_isClient)) then {
	[] spawn {
		private ["_respawnButtonEH"];
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