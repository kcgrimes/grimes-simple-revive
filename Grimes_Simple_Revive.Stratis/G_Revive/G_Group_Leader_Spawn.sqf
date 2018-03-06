//Spawn on group leader

[] spawn {
	while {true} do {
		G_Player_Group_Leader_Var = leader group player;
		sleep 2;
	};
};

sleep 1;

if (G_Group_Leader_Spawn) then {
	_grouprespawnid = [player, G_Player_Group_Leader_Var] call BIS_fnc_addRespawnPosition; 
};
	
if (G_Group_Leader_Marker) then {
	_group_leader_mkr = createMarkerLocal ["G_Group_Leader_Mkr", getPos G_Player_Group_Leader_Var];
	_group_leader_mkr setMarkerColorLocal G_Group_Leader_Mkr_Color;
	_group_leader_mkr setMarkerTextLocal G_Group_Leader_Mkr_Text;
	while {true} do {
		waitUntil {alive G_Player_Group_Leader_Var};
		_group_leader_mkr setMarkerTypeLocal G_Group_Leader_Mkr_Type;
		while {alive G_Player_Group_Leader_Var} do {
			_group_leader_mkr setMarkerPosLocal (getPos G_Player_Group_Leader_Var);
			sleep G_Group_Leader_Mkr_Refresh; 
		};
		_group_leader_mkr setMarkerTypeLocal "empty"; 
	};
};