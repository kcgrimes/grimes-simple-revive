////Editable parameters, sorted by category and relevance - Please adjust values to suit your application. See readMe for more information.
//Generic
G_PvP = false; //true = PvP mission where there are more than one playable sides (PvP, TvT, etc), false = players only on one side (CoOp, SP, etc).
G_Enemy_AI_Unconscious = false; //true = Enemy AI can be revived, dragged, and carried by enemy players (only recommended for PvP)
	G_Friendly_Side = WEST; //Side of friendly units if the above is false
G_Briefing = true; //true = information, how to, and credits will be displayed on ingame briefing screen. Can be used in conjunction with your own briefing. False = disabled. 

//Revive
G_Revive_Time_Limit = 300; //Amount of time (in seconds) before unit is available to be revived, before being forced to respawn. If -1, no time limit.
G_Revive_Can_Revive = []; //Classnames of units that can revive. Wrap in quotes, separate by commas. If empty, all can revive.
G_Revive_Time_To = 10; //Time (in seconds) required for revive to complete
G_Revive_Requirement = 0; //1 or greater = number of FAKs (single use) or Medikit (unlimited use) needed to revive (and treat still). 0 = Those items only needed to treat, not revive (stock).
G_Revive_Black_Screen = 0; //1 = While Unconscious/waiting for revive, screen stays black. 0 = Screen goes black at death then fades back in, with surroundings visible.
G_Revive_Load_Types = ["Car","Tank","Helicopter","Truck"]; //Add or remove strings of types of units that wounded can be loaded into
G_Revive_Reward = 0; //0 = No lives rewarded for revive. 1 and up = number of lives rewarded for reviving. (CAN be a decimal)
G_TK_Penalty = -1; //Amount of lives a Team Killer loses per team kill. Note, must be negative to be negative result. (Value of -2 means 2 lives lost per TK) (CAN be a decimal)

//Respawn/Initial Spawn
G_Init_Start = 0; //0 = starting position is editor-placed position. 1 = starting position is random spawn marker. 2 = On start, player is presented with menu to select spawn position.
G_JIP_Start = 0; //0 = JIP starting position is editor-placed position. 1 = JIP starting position is random spawn marker. 2 = On start for JIP, player is presented with menu to select spawn position.
G_Respawn_Button = true; //true = Respawn Button enabled, false = Respawn button disabled
G_Respawn_Time = 5; //Amount of time (in seconds) dead unit must wait before being able to respawn (overrides description.ext setting)
G_Num_Respawns = -1; //Number of respawns available to players(must be integer). -1 = unlimited, 0 and up are actual values.
G_Spectator = true; //Upon expending all lives, the player will be put into a spectator camera. If false, mission ends only for that specific player.
G_Group_Leader_Spawn = true; //Allows spawning on group leader. Spawn in group leader's stance. True = on, false = off
G_Group_Leader_Marker = true; //Displays marker on map indicating group leader's position. True = enabled, false = disabled.
	G_Group_Leader_Mkr_Type = "respawn_inf"; //Shape of marker
	G_Group_Leader_Mkr_Color = "ColorBlue"; //Color of marker
	G_Group_Leader_Mkr_Text = "Group Leader"; //Text beside marker
	G_Group_Leader_Mkr_Refresh = 1; //Time (in seconds) between refreshes in marker location. Must be a number greater than 0.
G_AI_Fixed_Spawn = true; //Upon respawn, the AI will spawn at the marker defined below for their respective side
	G_AI_Fixed_Spawn_WEST = "respawn_west";
	G_AI_Fixed_Spawn_EAST = "";
	G_AI_Fixed_Spawn_GUER = "";
	G_AI_Fixed_Spawn_CIV = "";
	
//Mobile Respawn Vehicle
//Note - To enable, simply add the editor-placed vehicle's name into the correct array. It will not be wrapped in quotes. So, it will be vehname and not "vehname". If multiple vehicles, separate by commas.
//Note - The side that can use the specific Mobile Respawn is determined by which array the MRV is put in below.
G_Mobile_Respawn_WEST = [MobileRespawn]; 
G_Mobile_Respawn_EAST = [];
G_Mobile_Respawn_GUER = [];
G_Mobile_Respawn_CIV = [];
G_Mobile_Respawn_Moveable = false; //true = Deployed mobile respawn can be moved while remaining deployed. false = Deployed mobile respawn is immobile. 
G_Mobile_Respawn_Wreck = 120; //Time (in seconds) after mobile respawn is destroyed before the wreck is deleted
G_Mobile_Respawn_RespTimer = 60; //Time (in seconds) for mobile respawn to respawn at starting position/direction
G_Mobile_Respawn_Marker = true; //Displays marker on map indicating MRV's position. True = enabled, false = disabled.
	G_Mobile_Respawn_Mkr_Type = "respawn_motor"; //Shape of marker
	G_Mobile_Respawn_Mkr_Color = "ColorBlue"; //Color of marker
	G_Mobile_Respawn_Mkr_Text = "MRV"; //Text beside marker
	G_Mobile_Respawn_Mkr_Refresh = 1; //Time (in seconds) between refreshes in marker location. Must be a number greater than 0.
	G_Mobile_Respawn_Mkr_Display = false; //whether or not marker is always visible (true = marker always visible, false = marker only visible when mobile respawn is deployed

//Unit "Tags"
G_Unit_Tag = true; //Refers to unit "name tags" that display over unit's head on HUD. Only friendlies visible. If true, is enabled. If false, is disabled.
	G_Unit_Tag_Display = 0; //0 = Press defined key to have names visible for defined time, 1 = Cursor over unit to have name displayed, 2 = Names always displayed
		G_Unit_Tag_Display_Key = 219; //Only used if Display 0 is that value above. Key number. Default is the Left Windows Key. See key codes for more options.
		G_Unit_Tag_Display_Time = 2.5; //Only used if Display 0 is that value above. Time (in seconds) names display when key pressed
		G_Unit_Tag_Distance = 75; //Distance from player that marker will begin to appear
		G_Unit_Tag_ShowDistance = true; //Distance is displayed next to player's name

//Custom Executions
//Note - By default they will execute on AI as well. Read comment to side.
G_Custom_Exec_1 = ""; //File executed when unit is set Unconscious (NOT "killed")
G_Custom_Exec_2 = ""; //File executed when unit is killed (not revivable; unit is officially killed)
G_Custom_Exec_3 = ""; //File executed when unit respawns after being killed
G_Custom_Exec_4 = ""; //File executed when MRV respawns after being destroyed. The newly spawned MRV = _this select 0

////DO NOT EDIT
execVM "G_Revive\G_Revive_Init_Vars.sqf";