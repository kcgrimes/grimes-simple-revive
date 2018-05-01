## Grimes Simple Revive

Created with user-friendliness and quality assurance in mind, Grimes Simple Revive is a Revive script for ArmA 3 that sets itself apart from other Revive Scripts due to the fact that it is exceptionally organized and simplified for ease-of-use by mission editors of all levels. Although this script contains a variety of features on top of its original action-based Revive System, all features, in addition to already having default values set, are organized by relevancy in a simple way that allows editors to adapt this script to their mission. 

Highlights:
* Singleplayer (SP), Multiplayer (MP), Dedicated Server, & Join-In-Progress (JIP) Support
	* For SP, simply run your SP mission as an MP Host. This allows for the use of parameters anyway, allowing you to make your mission more diverse!
* Minimal setup required, quick and easy installation
* Integrated value checking system to ensure the script is being utilized effectively
* Revive your teammates, whether they are players or AI
* Drag & Carry players and AI, whether they are your teammates or not
* Load incapacitated teammates into vehicles, and Unload them at your destination
* Utilization of the stock Respawn Menu for use of multiple respawn points
* Available limitless Mobile Respawn Vehicle and Squad Leader Respawn systems
* Utilization of BIS functions and dialogs wherever possible to be as stock as possible
* Available “unit tags” that mark friendly players and AI on your HUD
* Available Spectator Mode for use when lives run out
* Pre-placed custom execution lines to run your own scripts within this one
* Loads of other large and small features! Check out G_Revive_init.sqf

This package includes an application of the script as part of an example mission. 

This README is intended to provide detailed information as to the purpose, function, FAQs, and minor troubleshooting for this script in addition to installation, uninstallation, and maintenance tips. For further information or specifics in the code, the user should read the comments to the code within the script files. 

## Author Information

Kent “KC” Grimes of Austin, Texas, United States is the author of the Grimes Simple Revive script. The script was made in order to provide mission makers a user-friendly means of utilizing a revive system.

The purpose of this script is to provide a way for the mission maker to easily implement the revive and spawning abilities into gameplay in order to make their mission unique. 

BI Forums Topic: https://forums.bohemia.net/forums/topic/167673-grimes-simple-revive-script/

## Installation

At this time, there is no “installer” for the script, and it is instead a simple series of actions and file moves.  

1. Obtain the script files
	1. Armaholic: http://www.armaholic.com/page.php?id=25662
	1. github: https://github.com/kcgrimes/grimes-simple-revive/releases
	1. Steam Workshop: http://steamcommunity.com/sharedfiles/filedetails/?id=1349229256
2. Extract the “Grimes_Simple_Revive.stratis” folder and place it somewhere on your computer that is easily accessible, such as Desktop or your MP Missions folder.
3. In the folder that contains your mission.sqm (ie, “my_mission.stratis”), do the following:
	1. If you haven’t already created a description.ext file, simply copy the provided one into your mission folder. If you already have your own description.ext, simply copy and paste the following line into it. Be sure to not have any respawn-related settings in place, as they will conflict with this file (for custom use, just edit the file).
	```
	#include "G_Revive\G_Desc_Include.hpp"
	```
	2. If you haven’t already created an init.sqf file, simply copy the provided one into your mission folder. If you already have your own init.sqf, simply copy and paste the following lines into it. 
	```
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

	[] execVM "G_Revive_init.sqf";
	```
	3. Copy and Paste the G_Revive_init.sqf file and the G_Revive folder into your mission folder. 
4. That is all that is required for the file implementation! Depending on your settings, you will still need make some edits in the in-game editor. 
	1. If using respawn, create markers named “respawn_west_0”, “respawn_west_1”, etc. for the desired side.
	1. If using the mobile respawn vehicle, be sure to name your vehicle in the Name field when you double-click on the vehicle in the editor.

Parameters:  
```
////Editable parameters, sorted by category and relevance - Please adjust values to suit your application.
//Generic
G_PvP = true; //true = PvP mission where there are more than one playable sides (PvP, TvT, etc), false = players only on one side (CoOp, SP, etc).
G_Enemy_AI_Incapacitated = true; //true = Enemy AI can be revived, dragged, and carried by enemy players (only recommended for PvP), false = disabled
	G_Friendly_Side = WEST; //Side of friendly units if the above is false
G_Briefing = true; //true = information, how to, and credits will be displayed on ingame briefing screen. Can be used in conjunction with your own briefing. false = disabled. 

//Revive
G_Revive_System = true; //Whether the revive system will be used or not. true = enabled, false = disabled.
G_Revive_bleedoutTime = 300; //Amount of time (in seconds) unit is available to be revived, before being forced to respawn. If -1, no time limit.
G_Revive_DownsPerLife = 0; //Number of times unit can go Incapacitated in single life. 0 = Unlimited, integer > 0 = limit of downs per life.
G_Revive_Can_Revive = []; //Classnames of units that can revive. Wrap in quotes, separate by commas. If empty, all can revive.
G_Revive_Time_To = 10; //Time (in seconds) required for reviver to complete revive action
G_Revive_Requirement = 0; //1 or greater = number of FAKs (single use) or Medikit (unlimited use) needed to revive (and treat still). 0 = Those items only needed to treat, not revive (stock).
G_Revive_Black_Screen = 0; //1 = While Incapacitated/waiting for revive, screen stays black. 0 = Screen goes black at death then fades back in, with surroundings visible.
G_Revive_Action_Color = "#FFCC00"; //HTML color code that will be the color of the Revive, Drag, Carry, and Load/Unload action text. Default is Orange. 
G_Revive_Load_Types = ["Car","Tank","Helicopter","Truck"]; //Add or remove strings of types of units that wounded can be loaded into
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
G_AI_Fixed_Spawn = true; //Upon respawn, the AI will spawn at the marker defined below for their respective side
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
G_Mobile_Respawn_Movable = false; //true = Deployed mobile respawn can be moved while remaining deployed, false = Deployed mobile respawn is immobile. 
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
G_Custom_Exec_1 = ""; //File executed when unit is set Incapacitated (NOT "killed")
G_Custom_Exec_2 = ""; //File executed when unit is killed (not revivable; unit is officially killed)
G_Custom_Exec_3 = ""; //File executed when unit respawns after being killed
G_Custom_Exec_4 = ""; //File executed when MRV respawns after being destroyed. The newly spawned MRV = _this select 0
```

## Documentation

This README is intended to provide detailed information as to the purpose, function, FAQs, and minor troubleshooting for this script in addition to installation, uninstallation, and maintenance tips. For further information or specifics in the code, the user should read the comments to the code within the script files. Any further questions or comments can be directed to the author. 

## Tests

The script is designed to exit upon critical failure and it will attempt to announce the problem in chat. These types of failures are intended for development, and should never be encountered down the road if they were not encountered at launch, save for software updates. Upon setup or completion of modifications, it is recommended that the user, before launch, run the script in a test environment.

## Contributors

Contributions are welcomed and encouraged. Please follow the below guidelines:
* Use the Issue Tracker
* Use the Pull Request feature
* Document any additional work
* Provide reasonable commit history comments
* Test all modifications locally and online

## License

MIT License

Copyright (c) 2013-2018 Kent "KC" Grimes. All Rights Reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
