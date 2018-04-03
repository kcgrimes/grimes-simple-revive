/*
Author: KC Grimes
Script: Grimes Simple Revive
Version: V0.8
*/
////Editable parameters, sorted by category and relevance - Please adjust values to suit your application.
//Generic
G_PvP = true; //true = PvP mission where there are more than one playable sides (PvP, TvT, etc), false = players only on one side (CoOp, SP, etc).
G_Enemy_AI_Unconscious = true; //true = Enemy AI can be revived, dragged, and carried by enemy players (only recommended for PvP), false = disabled
	G_Friendly_Side = WEST; //Side of friendly units if the above is false
G_Briefing = true; //true = information, how to, and credits will be displayed on ingame briefing screen. Can be used in conjunction with your own briefing. false = disabled. 

//Revive
G_Revive_System = true; //Whether the revive system will be used or not. true = enabled, false = disabled.
G_Revive_Time_Limit = 300; //Amount of time (in seconds) unit is available to be revived, before being forced to respawn. If -1, no time limit.
G_Allow_GiveUp = true; //Allow player to force death while unconscious. true = enabled, false = disabled.
G_Revive_DownsPerLife = 0; //Number of times unit can go Unconscious in single life. 0 = Unlimited, integer > 0 = limit of downs per life.
G_Revive_Can_Revive = []; //Classnames of units that can revive. Wrap in quotes, separate by commas. If empty, all can revive.
G_Revive_Time_To = 10; //Time (in seconds) required for reviver to complete revive action
G_Revive_Requirement = 0; //1 or greater = number of FAKs (single use) or Medikit (unlimited use) needed to revive (and treat still). 0 = Those items only needed to treat, not revive (stock).
G_Revive_Black_Screen = 0; //1 = While Unconscious/waiting for revive, screen stays black. 0 = Screen goes black at death then fades back in, with surroundings visible.
G_Revive_Action_Color = "#FFCC00"; //HTML color code that will be the color of the Revive, Drag, Carry, and Load/Unload action text. Default is Orange. 
G_Revive_Load_Types = ["Car","Tank","Helicopter","Ship"]; //Array of strings of kinds of vehicles that unconscious units can be loaded into
G_Eject_Occupants = false; //If killed while in a vehicle, the revivable unit is ejected from the vehicle. True = enabled, false = disabled.
G_Explosion_Eject_Occupants = true; //Once the wreck of an exploded vehicle comes to a stop (air or land), the occupants will be ejected and revivable. True to enable, false to disable (units will bypass revive and be forced to respawn).
G_Revive_Reward = 0; //0 = No lives rewarded for revive. 1 and up = number of lives rewarded for reviving. (CAN be a decimal)
G_TK_Penalty = 0; //Amount of lives a Team Killer loses per team kill. Note, must be negative to be negative result (Ex. Value of -2 means 2 lives lost per TK) (CAN be a decimal)

//Respawn/Initial Spawn
G_Init_Start = 0; //0 = starting position is editor-placed position. 1 = starting position is random spawn marker. 2 = On start, player is presented with menu to select spawn position (NOTE: For the menu to work at start, you must go to G_Revive\G_Desc_Include.hpp, find respawnOnStart, and change it to 1. As well, if you do this, G_JIP_Start must also be 2.)
G_JIP_Start = 0; //0 = JIP starting position is editor-placed position (or position of unit JIPing to). 1 = JIP starting position is random spawn marker. 2 = On start for JIP, player is presented with menu to select spawn position (NOTE: For the menu to work at start, you must go to G_Revive\G_Desc_Include.hpp, find respawnOnStart, and change it to 1. As well, if you do this, G_Init_Start must also be 2.)
G_Respawn_Button = true; //true = Respawn Button enabled, false = Respawn button disabled
G_Respawn_Time = 10; //Amount of time (in seconds) dead unit must wait before being able to respawn (overrides description.ext setting)
G_Num_Respawns = 3; //Number of lives/respawns available to players (must be integer). -1 = unlimited, 0 and up are actual values.
G_Spectator = true; //Upon expending all lives, the player will be put into a spectator camera. If false, mission ends only for that specific player.
G_Squad_Leader_Spawn = true; //Allows spawning on squad leader. Spawn in squad leader's stance. true = enabled, false = disabled.
G_Squad_Leader_Marker = true; //Displays marker on map indicating squad leader's position. true = enabled, false = disabled.
	G_Squad_Leader_Mkr_Type = "respawn_inf"; //Shape of marker
	G_Squad_Leader_Mkr_Color = "ColorBlack"; //Color of marker
	G_Squad_Leader_Mkr_Text = "Squad Leader"; //Text beside marker
	G_Squad_Leader_Mkr_Refresh = 1; //Time (in seconds) between refreshes in marker location. Must be a number greater than 0.
G_AI_Fixed_Spawn = true; //Upon respawn, the AI will spawn at the marker defined below for their respective side, as opposed to respawning at random if multiple markers exist
	G_AI_Fixed_Spawn_WEST = "respawn_west_0";
	G_AI_Fixed_Spawn_EAST = "respawn_east_0";
	G_AI_Fixed_Spawn_GUER = "respawn_guerrila_0";
	G_AI_Fixed_Spawn_CIV = "";

//Mobile Respawn Vehicle
//Note - To enable, simply add the editor-placed vehicle's name into the appropriate array depending on the intended side. It will not be wrapped in quotes. So, it will be vehname and not "vehname". If multiple vehicles, separate by commas.
G_Mobile_Respawn_WEST = [MobileRespawnWEST]; 
G_Mobile_Respawn_EAST = [MobileRespawnEAST];
G_Mobile_Respawn_GUER = [MobileRespawnGUER];
G_Mobile_Respawn_CIV = [];
G_Mobile_Respawn_Locked = true; //Lock enemy MRVs so MRVs can only be accessed by their own team. true = enabled, false = disabled.
G_Mobile_Respawn_Moveable = false; //true = Deployed mobile respawn can be moved while remaining deployed, false = Deployed mobile respawn is immobile. 
G_Mobile_Respawn_Wreck = 10; //Time (in seconds) after mobile respawn is destroyed before the wreck is deleted
G_Mobile_Respawn_RespTimer = 20; //Time (in seconds) for mobile respawn to respawn at starting position/direction
G_Mobile_Respawn_Marker = true; //Displays marker on map indicating MRV's position. true = enabled, false = disabled.
	G_Mobile_Respawn_Mkr_Type = "respawn_motor"; //Shape of marker
	G_Mobile_Respawn_Mkr_Color = "ColorBlack"; //Color of marker
	G_Mobile_Respawn_Mkr_Text = "MRV"; //Text beside marker
	G_Mobile_Respawn_Mkr_Refresh = 1; //Time (in seconds) between refreshes in marker location. Must be a number greater than 0.
	G_Mobile_Respawn_Mkr_Display = false; //Whether or not marker is always visible (true = marker always visible, false = marker only visible when MRV is deployed

//Unit Tags
G_Unit_Tag = true; //Refers to unit "name tags" that display over unit's head on HUD. Only friendlies visible. true = enabled, false = disabled.
	G_Unit_Tag_Display = 0; //0 = Press defined key to have names visible for defined time, 1 = Cursor over unit to have name displayed, 2 = Names always displayed
		G_Unit_Tag_Display_Key = 219; //Only used if Display 0 is that value above. Key number. Default is the Left Windows Key. See key codes for more options.
		G_Unit_Tag_Display_Time = 2; //Only used if Display 0 is that value above. Time (in seconds) names display when key pressed
	G_Unit_Tag_Distance = 75; //Distance from player that marker will begin to appear
	G_Unit_Tag_ShowDistance = true; //Distance is displayed next to player's name
	G_Unit_Tag_Color = [1,1,1]; //RGB settings for the tag color of non-squad members. Alpha is normally the 4th number, but that is handled in the script via a distance formula.
	G_Unit_Tag_SquadColor = [1,1,0.1]; //RGB settings for the tag color of squad members. Alpha is normally the 4th number, but that is handled in the script via a distance formula.

//Custom Executions
//Note - By default they will execute on AI as well. Read comment to side.
G_Custom_Exec_1 = ""; //File executed when unit is set Unconscious (NOT "killed")
G_Custom_Exec_2 = ""; //File executed when unit is killed (not revivable; unit is officially killed)
G_Custom_Exec_3 = ""; //File executed when unit respawns after being killed
G_Custom_Exec_4 = ""; //File executed when MRV respawns after being destroyed. The newly spawned MRV = _this select 0

////DO NOT EDIT
[] execVM "G_Revive\G_Revive_Init_Vars.sqf";