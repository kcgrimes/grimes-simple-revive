//Spawn on squad leader

//Permanent parallel cycle of squad leader definition and respawn position
[] spawn {
	private ["_squadrespawnid"];
	while {true} do {
		//Obtain squad leader
		G_Player_Squad_Leader_Var = leader group player;
		//If squad leader spawn enabled, execute
		if (G_Squad_Leader_Spawn) then {
			//If squad respawn ID is defined, then it needs replacing
			if (!isNil "_squadrespawnid") then {
				//Delete old squad leader respawn point
				_squadrespawnid call BIS_fnc_removeRespawnPosition; 
			};
			//Add new respawn point on squad leader
			_squadrespawnid = [player, G_Player_Squad_Leader_Var] call BIS_fnc_addRespawnPosition; 
		};
		//Wait for squad leader to change
		waitUntil {sleep 2; ((leader group player) != G_Player_Squad_Leader_Var)};
	};
};

//Wait for definition of squad leader
sleep 3;

//If squad leader map marker is enabled, execute
if (G_Squad_Leader_Marker) then {
	//Create marker for squad leader to always be used
	_squad_leader_mkr = createMarkerLocal ["G_Squad_Leader_Mkr", getPos G_Player_Squad_Leader_Var];
	_squad_leader_mkr setMarkerColorLocal G_Squad_Leader_Mkr_Color;
	_squad_leader_mkr setMarkerTextLocal G_Squad_Leader_Mkr_Text;
	//Permanent parallel cycle of squad leader marker
	while {true} do {
		//Wait for squad leader to be alive
		waitUntil {sleep 0.5; alive G_Player_Squad_Leader_Var};
		//Make marker visible
		_squad_leader_mkr setMarkerTypeLocal G_Squad_Leader_Mkr_Type;
		//Reset marker position at defined refresh rate until squad leader dies
		while {alive G_Player_Squad_Leader_Var} do {
			_squad_leader_mkr setMarkerPosLocal (getPos G_Player_Squad_Leader_Var);
			sleep G_Squad_Leader_Mkr_Refresh; 
		};
		//Squad leader is dead, so hide the marker
		_squad_leader_mkr setMarkerTypeLocal "empty"; 
	};
};