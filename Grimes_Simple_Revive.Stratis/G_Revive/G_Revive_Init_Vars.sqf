////Checks
//Generic
if (typeName G_PvP != "BOOL") exitWith {player sideChat "G_Revive_Init - G_PvP must be true/false!"};
if (typeName G_Enemy_AI_Unconscious != "BOOL") exitWith {player sideChat "G_Revive_Init - G_Enemy_AI_Unconscious must be true/false!"};
if (!(G_Enemy_AI_Unconscious) and (typeName G_Friendly_Side != "SIDE")) exitWith {player sideChat "G_Revive_Init - G_Friendly_Side must be WEST, EAST, GUER, or CIV!"};
if (typeName G_Briefing != "BOOL") exitWith {player sideChat "G_Revive_Init - G_Briefing must be true/false!"};

//Revive
if ((typeName G_Revive_Time_Limit != "SCALAR") || (G_Revive_Time_Limit < -1)) exitWith {player sideChat "G_Revive_Init - G_Revive_Time_Limit must be a number greater than or equal to -1!"};
if ((typeName G_Revive_Time_To != "SCALAR") || (G_Revive_Time_To < 0)) exitWith {player sideChat "G_Revive_Init - G_Revive_Time_To must be an integer greater than or equal to 0!"};
if ((typeName G_Revive_Requirement != "SCALAR") || (G_Revive_Requirement < 0)) exitWith {player sideChat "G_Revive_Init - G_Revive_Requirement must be an integer greater than or equal to 0!"};
if ((typeName G_Revive_Black_Screen != "SCALAR") || !((G_Revive_Black_Screen == 0) || (G_Revive_Black_Screen == 1))) exitWith {player sideChat "G_Revive_Init - G_Revive_Black_Screen must be defined as 0 or 1!"};
if ((typeName G_Revive_Reward != "SCALAR") || (G_Revive_Reward < 0)) exitWith {player sideChat "G_Revive_Init - G_Revive_Reward must be a number greater than or equal to 0!"};
if ((typeName G_TK_Penalty != "SCALAR") || (G_TK_Penalty > 0)) exitWith {player sideChat "G_Revive_Init - G_TK_Penalty must be a number less than or equal to 0!"};

//Respawn/Initial Spawn
if ((typeName G_Init_Start != "SCALAR") || !((G_Init_Start > -1) and (G_Init_Start < 3))) exitWith {player sideChat "G_Revive_Init - G_Init_Start must be defined as 0, 1, or 2!"};
if ((typeName G_JIP_Start != "SCALAR") || !((G_JIP_Start > -1) and (G_JIP_Start < 3))) exitWith {player sideChat "G_Revive_Init - G_JIP_Start must be defined as 0, 1, or 2!"};
if (typeName G_Respawn_Button != "BOOL") exitWith {player sideChat "G_Revive_Init - G_Respawn_Button must be true/false!"};
if ((typeName G_Respawn_Time != "SCALAR") || (G_Respawn_Time < 0)) exitWith {player sideChat "G_Revive_Init - G_Respawn_Time must be a number greater than or equal to 0!"};
if ((typeName G_Num_Respawns != "SCALAR") || (G_Num_Respawns < -1)) exitWith {player sideChat "G_Revive_Init - G_Num_Respawns must be an integer greater than or equal to -1!"};
if (typeName G_Spectator != "BOOL") exitWith {player sideChat "G_Revive_Init - G_Spectator must be true/false!"};
if (typeName G_Group_Leader_Spawn != "BOOL") exitWith {player sideChat "G_Revive_Init - G_Group_Leader_Spawn must be true/false!"};
if (typeName G_Group_Leader_Marker != "BOOL") exitWith {player sideChat "G_Revive_Init - G_Group_Leader_Marker must be true/false!"};
if ((typeName G_Group_Leader_Mkr_Type != "STRING") || (typeName G_Group_Leader_Mkr_Color != "STRING") || (typeName G_Group_Leader_Mkr_Text != "STRING")) exitWith {player sideChat "G_Revive_Init - G_Group_Leader_Mkr_SETTINGHERE must all be strings except for Refresh. If not in use, still have empty quotes."};
if ((typeName G_Group_Leader_Mkr_Refresh != "SCALAR") || (G_Group_Leader_Mkr_Refresh <= 0)) exitWith {player sideChat "G_Revive_Init - G_Group_Leader_Mkr_Refresh must be a number greater than 0!"};
if (typeName G_AI_Fixed_Spawn != "BOOL") exitWith {player sideChat "G_Revive_Init - G_AI_Fixed_Spawn must be true/false!"};
if ((typeName G_AI_Fixed_Spawn_WEST != "STRING") || (typeName G_AI_Fixed_Spawn_EAST != "STRING") || (typeName G_AI_Fixed_Spawn_GUER != "STRING") || (typeName G_AI_Fixed_Spawn_CIV != "STRING")) exitWith {player sideChat "G_Revive_Init - G_AI_Fixed_Spawn_SIDEHERE must all be strings. If not in use, still have empty quotes."};

//Mobile Respawn Vehicle
if (typeName G_Mobile_Respawn_Moveable != "BOOL") exitWith {player sideChat "G_Revive_Init - G_Mobile_Respawn_Moveable must be true/false!"};
if ((typeName G_Mobile_Respawn_Wreck != "SCALAR") || (G_Mobile_Respawn_Wreck < 0)) exitWith {player sideChat "G_Revive_Init - G_Mobile_Respawn_Wreck must be a number greater than or equal to 0!"};
if ((typeName G_Mobile_Respawn_RespTimer != "SCALAR") || (G_Mobile_Respawn_RespTimer < 0)) exitWith {player sideChat "G_Revive_Init - G_Mobile_Respawn_RespTimer must be a number greater than or equal to 0!"};
if (typeName G_Mobile_Respawn_Marker != "BOOL") exitWith {player sideChat "G_Revive_Init - G_Mobile_Respawn_Marker must be true/false!"};
if ((typeName G_Mobile_Respawn_Mkr_Type != "STRING") || (typeName G_Mobile_Respawn_Mkr_Color != "STRING") || (typeName G_Mobile_Respawn_Mkr_Text != "STRING")) exitWith {player sideChat "G_Revive_Init - G_Mobile_Respawn_Mkr_SETTINGHERE must all be strings except for Refresh and Display. If not in use, still have empty quotes."};
if ((typeName G_Mobile_Respawn_Mkr_Refresh != "SCALAR") || (G_Mobile_Respawn_Mkr_Refresh <= 0)) exitWith {player sideChat "G_Revive_Init - G_Mobile_Respawn_Mkr_Refresh must be a number greater than 0!"};
if (typeName G_Mobile_Respawn_Mkr_Display != "BOOL") exitWith {player sideChat "G_Revive_Init - G_Mobile_Respawn_Mkr_Display must be true/false!"};

//Unit "Tags"
if (typeName G_Unit_Tag != "BOOL") exitWith {player sideChat "G_Revive_Init - G_Unit_Tag must be true/false!"};
if ((typeName G_Unit_Tag_Display != "SCALAR") || !((G_Unit_Tag_Display > -1) and (G_Unit_Tag_Display < 3))) exitWith {player sideChat "G_Revive_Init - G_Unit_Tag_Display must be defined as 0, 1, or 2!"};
if (typeName G_Unit_Tag_Display_Key != "SCALAR") exitWith {player sideChat "G_Revive_Init - G_Unit_Tag_Display_Key must be an integer!"};
if ((typeName G_Unit_Tag_Display_Time != "SCALAR") || (G_Unit_Tag_Display_Time <= 0)) exitWith {player sideChat "G_Revive_Init - G_Unit_Tag_Display_Time must be a number greater than 0!"};
if ((typeName G_Unit_Tag_Distance != "SCALAR") || (G_Unit_Tag_Distance <= 0)) exitWith {player sideChat "G_Revive_Init - G_Unit_Tag_Distance must be a number greater than 0!"};
if (typeName G_Unit_Tag_ShowDistance != "BOOL") exitWith {player sideChat "G_Revive_Init - G_Unit_Tag_ShowDistance must be true/false!"};

//Custom Executions
if ((typeName G_Custom_Exec_1 != "STRING") || (typeName G_Custom_Exec_2 != "STRING") || (typeName G_Custom_Exec_3 != "STRING") || (typeName G_Custom_Exec_4 != "STRING")) exitWith {player sideChat "G_Revive_Init - G_Custom_Exec_# must all be strings except. If not in use, still have empty quotes."};

//Various defines
G_Num_Respawns_Base = G_Num_Respawns;
G_Revive_Has_Died_Once = false;
G_Unit_Tag_Display_EH_Loaded = false;
G_Unit_Start_Pos = getPos player;

if (G_Briefing) then {
	execVM "G_Revive\G_Briefing.sqf";
};

if ((isServer) || (G_JIP)) then {
	G_fnc_EH = compile preprocessFile "G_Revive\G_fnc_EH.sqf";
	if (isServer) then {
		if (G_Enemy_AI_Unconscious) then {
			{
				if (_x isKindOf "CAManBase") then {
					[_x] spawn G_fnc_EH;
				};
			} forEach allUnits;
		}
		else
		{
			{
				if ((_x isKindOf "CAManBase") and (side _x == G_Friendly_Side)) then {
					[_x] spawn G_fnc_EH;
				};
			} forEach allUnits;
		};
	};

	if (G_JIP) then {
		[player] spawn G_fnc_EH;
	};
};

if (count (G_Mobile_Respawn_WEST + G_Mobile_Respawn_EAST + G_Mobile_Respawn_GUER + G_Mobile_Respawn_CIV) > 0) then {
	execVM "G_Revive\G_Mobile_Respawn.sqf";
};

if (((G_Group_Leader_Spawn) || (G_Group_Leader_Marker)) and (!isDedicated)) then {
	execVM "G_Revive\G_Group_Leader_Spawn.sqf";
};

if (G_Unit_Tag) then {
	if (G_JIP) then {
		player setVariable ["G_Unit_Tag_Number", G_Unit_Tag_Num_List, true];
		G_Unit_Tag_Num_List = G_Unit_Tag_Num_List + 1; 
		publicVariable "G_Unit_Tag_Num_List";
		_handle = execVM "G_Revive\G_Unit_Tags.sqf";
		waitUntil {scriptDone _handle};
		[[player, (player getVariable "G_Unit_Tag_Number")], "G_fnc_Unit_Marker_ReExec", true, true] spawn BIS_fnc_MP;
		{
			if (_x isKindOf "CAManBase") then {
				[_x] spawn G_fnc_Unit_Marker_Exec;
			};
		} forEach allUnits;
	}
	else
	{
		execVM "G_Revive\G_Unit_Tags.sqf";
	};
	if ((G_Unit_Tag) and (G_Unit_Tag_Display != 0)) then {
		G_Unit_Tag_Display_EH_Loaded = true;
	};
};

G_fnc_ReviveKeyDownAbort = {
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

if (!(G_Respawn_Button)) then {
	[] spawn {
		while {true} do {
			waitUntil {!isNull (findDisplay 49)};
			_respawnButtonEH = ((findDisplay 49) displayCtrl 1010)  ctrlAddEventHandler ["MouseButtonDown",{(findDisplay 49) closeDisplay 0; titleText ["The Respawn Button is disabled by the host!","PLAIN",1]; titleFadeOut 5;}]; 
			waitUntil {isNull (findDisplay 49)};
		};
	};  
};


G_fnc_switchMove = {
	_unit = _this select 0;
	_animation = _this select 1;
	_unit switchMove _animation;
};

G_fnc_playMoveNow = {
	_unit = _this select 0;
	_animation = _this select 1;
	_unit playMoveNow _animation;
};

G_fnc_Revive_Actions = {
	_unit = _this select 0;
	_replaceArray = _this select 1;
	_side = _this select 2;
	_reviveActionID = _unit addAction ["Revive","G_Revive\G_Revive_Action.sqf",[_replaceArray],1.5,true,true,"", format["((_target distance _this) < 1.75) and !(_target == _this) and (%1 == side _this) and !(_target getVariable ""G_Dragged"") and !(_target getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and !(_target getVariable ""G_getRevived"") and !(_this getVariable ""G_Reviving"") and (((typeOf _this) in G_Revive_Can_Revive) or ((count G_Revive_Can_Revive) == 0)) and !(_target getVariable ""G_Loaded"")",_side]];
	_dragActionID = _unit addAction ["Drag","G_Revive\G_Drag_Action.sqf",[],1.5,true,true,"", "((_target distance _this) < 1.75) and (_target != _this) and !(_target getVariable ""G_Dragged"") and !(_target getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and !(_target getVariable ""G_getRevived"") and !(_this getVariable ""G_Reviving"") and !(_target getVariable ""G_Loaded"")"];
	_carryActionID = _unit addAction ["Carry","G_Revive\G_Carry_Action.sqf",[],1.5,true,true,"", "((_target distance _this) < 1.75) and (_target != _this) and !(_target getVariable ""G_Carried"") and !(_target getVariable ""G_Dragged"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and !(_target getVariable ""G_getRevived"") and !(_this getVariable ""G_Reviving"") and !(_target getVariable ""G_Loaded"")"];
	_loadActionID = _unit addAction ["Load Into Vehicle","G_Revive\G_Load_Action.sqf",[_side],1.5,true,true,"", format["((_target distance _this) < 1.75) and !(_target == _this) and (%1 == side _this) and !(_target getVariable ""G_Dragged"") and !(_target getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and !(_target getVariable ""G_getRevived"") and !(_this getVariable ""G_Reviving"") and (count(nearestObjects [_target, %2, 10]) != 0) and !(_target getVariable ""G_Loaded"")",_side,G_Revive_Load_Types]];
	_arrayHandle = []; 
	_arrayHandle = [_reviveActionID] + [_dragActionID] + [_carryActionID] + [_loadActionID]; 
	_unit setVariable ["G_Revive_Actions", _arrayHandle, false];
};