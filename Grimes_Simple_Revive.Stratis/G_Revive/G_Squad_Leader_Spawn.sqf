//Spawn on squad leader

[] spawn {
	private ["_squadrespawnid"];
	while {true} do {
		G_Player_Squad_Leader_Var = leader group player;
		if (G_Squad_Leader_Spawn) then {
			if (!isNil "_squadrespawnid") then {
				_squadrespawnid call BIS_fnc_removeRespawnPosition; 
			};
			_squadrespawnid = [player, G_Player_Squad_Leader_Var] call BIS_fnc_addRespawnPosition; 
		};
		waitUntil {sleep 2; ((leader group player) != G_Player_Squad_Leader_Var)};
	};
};

sleep 3;
	
if (G_Squad_Leader_Marker) then {
	_squad_leader_mkr = createMarkerLocal ["G_Squad_Leader_Mkr", getPos G_Player_Squad_Leader_Var];
	_squad_leader_mkr setMarkerColorLocal G_Squad_Leader_Mkr_Color;
	_squad_leader_mkr setMarkerTextLocal G_Squad_Leader_Mkr_Text;
	while {true} do {
		waitUntil {sleep 0.5; alive G_Player_Squad_Leader_Var};
		_squad_leader_mkr setMarkerTypeLocal G_Squad_Leader_Mkr_Type;
		while {alive G_Player_Squad_Leader_Var} do {
			_squad_leader_mkr setMarkerPosLocal (getPos G_Player_Squad_Leader_Var);
			sleep G_Squad_Leader_Mkr_Refresh; 
		};
		_squad_leader_mkr setMarkerTypeLocal "empty"; 
	};
};