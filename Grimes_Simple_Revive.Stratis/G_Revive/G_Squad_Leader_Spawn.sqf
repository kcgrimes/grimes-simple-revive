//Handle squad leader spawn position and marker

_unit = _this select 0;

//If squad leader spawning is enabled, execute permanent parallel cycle of squad leader definition and respawn position
if (G_Squad_Leader_Spawn) then {
	[_unit] spawn {
		private ["_squadrespawnid", "_squadLeader"];
		_unit = _this select 0;
		while {true} do {
			//Obtain squad leader
			_squadLeader = leader group _unit;
			//If squad respawn ID is defined, then it needs replacing
			if (!isNil "_squadrespawnid") then {
				//Delete old squad leader respawn point
				_squadrespawnid call BIS_fnc_removeRespawnPosition; 
			};
			//Add new respawn point on eligible squad leader
			if (_squadLeader != _unit) then {
				_squadrespawnid = [_unit, _squadLeader] call BIS_fnc_addRespawnPosition; 
			};
			//Wait for squad leader to change
			waitUntil {sleep 2; ((leader group _unit) != _squadLeader)};
		};
	};
};

//If squad leader map marker is enabled, execute
if (G_Squad_Leader_Marker) then {
	private ["_squadLeader"];
	_squadLeader = leader group _unit;
	//Create marker for squad leader to always be used
	_squad_leader_mkr = createMarkerLocal ["G_Squad_Leader_Mkr", getPos _squadLeader];
	_squad_leader_mkr setMarkerColorLocal G_Squad_Leader_Mkr_Color;
	_squad_leader_mkr setMarkerTextLocal G_Squad_Leader_Mkr_Text;
	//Permanent parallel cycle of squad leader marker
	while {true} do {
		//Wait for squad leader to be alive and eligible
		waitUntil {sleep 2; ((alive (leader group _unit)) && (_unit != (leader group _unit)))};
		//Make marker visible
		_squad_leader_mkr setMarkerTypeLocal G_Squad_Leader_Mkr_Type;
		//Reset marker position at defined refresh rate until squad leader dies
		while {((alive (leader group _unit)) && (_unit != (leader group _unit)))} do {
			_squad_leader_mkr setMarkerPosLocal (getPos (leader group _unit));
			sleep G_Squad_Leader_Mkr_Refresh; 
		};
		//Squad leader is dead, so hide the marker
		_squad_leader_mkr setMarkerTypeLocal "empty"; 
	};
};