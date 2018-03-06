//Mobile respawn

_initVars = {
	_hp = "Land_HelipadEmpty_F" createVehicle [0,0,0];
	_hp setVariable ["G_MRV_Dir",getDir _x,true];
	_hp setVariable ["G_MRV_Pos",getPos _x,true];
	_hp setVariable ["G_MRV_Type",typeOf _x,true];
	_hp setVariable ["G_MRV_Side",_side,true];
	_hp setVariable ["G_MRV_Alive",true,true];
	_hp setVariable ["G_MRV_Name",vehicleVarName _x,true];
	_x setVariable ["G_MRV_Deployed",false,true];
	_deployActionID = _x addAction ["Deploy Mobile Respawn","G_Revive\G_Deploy_Action.sqf",[_side],1.5,true,true,"", format["((_target distance _this) < 5) and (_target != _this) and !(_this getVariable ""G_Dragged"") and !(_this getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and !(_target getVariable ""G_MRV_Deployed"") and ((speed _target) < 1) and ((speed _target) > -1) and (side _this == %1)", _side]];
	_undeployActionID = _x addAction ["Undeploy Mobile Respawn","G_Revive\G_Undeploy_Action.sqf",[_side],1.5,true,true,"", format["((_target distance _this) < 5) and (_target != _this) and !(_this getVariable ""G_Dragged"") and !(_this getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and (_target getVariable ""G_MRV_Deployed"") and ((speed _target) < 1) and ((speed _target) > -1) and (side _this == %1)", _side]];	
	_x setVariable ["G_MRV_Action_ID",_deployActionID,true];
	_x setVariable ["G_MRV_Undeploy_ID", _undeployActionID, true];
	call compile format["G_MRV_%1 = _hp",_x];
};
if !(count G_Mobile_Respawn_WEST == 0) then {
	{
		_side = WEST;
		call _initVars;
	} forEach G_Mobile_Respawn_WEST;
};

if !(count G_Mobile_Respawn_EAST == 0) then {
	{
		_side = EAST;
		call _initVars;
	} forEach G_Mobile_Respawn_EAST;
};

if !(count G_Mobile_Respawn_GUER == 0) then {
	{
		_side = GUER;
		call _initVars;
	} forEach G_Mobile_Respawn_GUER;
};

if !(count G_Mobile_Respawn_CIV == 0) then {
	{
		_side = CIV;
		call _initVars;
	} forEach G_Mobile_Respawn_CIV;
};

_MRV_Array = G_Mobile_Respawn_WEST + G_Mobile_Respawn_EAST + G_Mobile_Respawn_GUER + G_Mobile_Respawn_CIV;

G_fnc_MRV_onKilled = {
	_MRV = _this select 0;
	_MRV_killed_EH = _MRV addEventHandler ["Killed",
		{
			_MRV = _this select 0;
			_deployActionID = _MRV getVariable "G_MRV_Action_ID";
			_undeployActionID = _MRV getVariable "G_MRV_Undeploy_ID";
			_MRV removeAction _deployActionID;
			_MRV removeAction _undeployActionID;
			if (_MRV getVariable "G_MRV_Deployed") then {
				(_MRV getVariable "G_MRV_SpawnID") call BIS_fnc_removeRespawnPosition; 
				_MRV setVariable ["G_MRV_Deployed",false,true];
			};
			call compile format["G_MRV_%1 setVariable ['G_MRV_Alive',false,true]",_MRV];
			_oldMRVLogic = call compile format["G_MRV_%1",_MRV];
			[_MRV] spawn {
				_oldMRV = _this select 0;
				sleep G_Mobile_Respawn_Wreck;
				deleteVehicle _oldMRV;
			};
			[_oldMRVLogic] spawn G_fnc_MRV_onRespawn;
		}
	];
};

G_fnc_MRV_onRespawn = {
	_oldMRVLogic = _this select 0;

	sleep G_Mobile_Respawn_RespTimer;
	_MRV = (_oldMRVLogic getVariable "G_MRV_Type") createVehicle (_oldMRVLogic getVariable "G_MRV_Pos");
	_MRV setVehicleVarName (_oldMRVLogic getVariable "G_MRV_Name");
	_MRV call compile format ["%1 = _this; publicVariable ""%1""", ((call compile format["G_MRV_%1",_MRV]) getVariable "G_MRV_Name")];
	_MRV setDir ((call compile format["G_MRV_%1",_MRV]) getVariable "G_MRV_Dir");
	_MRV setVariable ["G_MRV_Deployed",false,true];
	_side = (call compile format["G_MRV_%1",_MRV]) getVariable "G_MRV_Side";
	_deployActionID = _MRV addAction ["Deploy Mobile Respawn","G_Revive\G_Deploy_Action.sqf",[_side],1.5,true,true,"", format["((_target distance _this) < 5) and (_target != _this) and !(_this getVariable ""G_Dragged"") and !(_this getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and !(_target getVariable ""G_MRV_Deployed"") and ((speed _target) < 1) and ((speed _target) > -1) and (side _this == %1)", _side]];
	_undeployActionID = _MRV addAction ["Undeploy Mobile Respawn","G_Revive\G_Undeploy_Action.sqf",[_side],1.5,true,true,"", format["((_target distance _this) < 5) and (_target != _this) and !(_this getVariable ""G_Dragged"") and !(_this getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and (_target getVariable ""G_MRV_Deployed"") and ((speed _target) < 1) and ((speed _target) > -1) and (side _this == %1)", _side]];	
	_MRV setVariable ["G_MRV_Action_ID",_deployActionID,true];
	_MRV setVariable ["G_MRV_Undeploy_ID", _undeployActionID, true];
	call compile format["G_MRV_%1 setVariable ['G_MRV_Alive',true,true]",_MRV];
	[_MRV] spawn G_fnc_MRV_onKilled;
	if (G_Custom_Exec_4 != "") then {
		[_MRV] execVM G_Custom_Exec_4;
	};
};

G_fnc_MRV_Marker_Process = {
	_MRV = _this select 0;

	if !(G_Mobile_Respawn_Mkr_Display) then {
		if (G_PvP) then {
			while {true} do {
				waitUntil {((call compile format["G_MRV_%1",_MRV]) getVariable "G_MRV_Alive")};
				_MRV = call compile ((call compile format["G_MRV_%1",_MRV]) getVariable "G_MRV_Name");
				while {((call compile format["G_MRV_%1",_MRV]) getVariable "G_MRV_Alive")} do {
					waitUntil {_MRV getVariable "G_MRV_Deployed"};
					format["G_MRV_mkr_%1",_MRV] setMarkerTypeLocal G_Mobile_Respawn_Mkr_Type;
					while {_MRV getVariable "G_MRV_Deployed"} do {
						format["G_MRV_mkr_%1",_MRV] setMarkerPosLocal (getPos _MRV);
						sleep G_Mobile_Respawn_Mkr_Refresh;
					};
					format["G_MRV_mkr_%1",_MRV] setMarkerTypeLocal "empty";
				};
			};
		}
		else
		{
			if (isServer) then {
				while {true} do {
					waitUntil {((call compile format["G_MRV_%1",_MRV]) getVariable "G_MRV_Alive")};
					_MRV = call compile ((call compile format["G_MRV_%1",_MRV]) getVariable "G_MRV_Name");
					while {((call compile format["G_MRV_%1",_MRV]) getVariable "G_MRV_Alive")} do {
						waitUntil {_MRV getVariable "G_MRV_Deployed"};
						format["G_MRV_mkr_%1",_MRV] setMarkerType G_Mobile_Respawn_Mkr_Type;
						while {_MRV getVariable "G_MRV_Deployed"} do {
							format["G_MRV_mkr_%1",_MRV] setMarkerPos (getPos _MRV);
							sleep G_Mobile_Respawn_Mkr_Refresh;
						};
						format["G_MRV_mkr_%1",_MRV] setMarkerType "empty";
					};
				};
			};
		};
	}
	else
	{
		if (G_PvP) then {
			while {true} do {
					waitUntil {((call compile format["G_MRV_%1",_MRV]) getVariable "G_MRV_Alive")};
					_MRV = call compile ((call compile format["G_MRV_%1",_MRV]) getVariable "G_MRV_Name");
					format["G_MRV_mkr_%1",_MRV] setMarkerTypeLocal G_Mobile_Respawn_Mkr_Type;
					while {((call compile format["G_MRV_%1",_MRV]) getVariable "G_MRV_Alive")} do {
						format["G_MRV_mkr_%1",_MRV] setMarkerPosLocal (getPos _MRV);
						sleep G_Mobile_Respawn_Mkr_Refresh;
					};
					format["G_MRV_mkr_%1",_MRV] setMarkerTypeLocal "empty";
			};
		}
		else
		{
			if (isServer) then {
				while {true} do {
					waitUntil {((call compile format["G_MRV_%1",_MRV]) getVariable "G_MRV_Alive")};
					_MRV = call compile ((call compile format["G_MRV_%1",_MRV]) getVariable "G_MRV_Name");
					format["G_MRV_mkr_%1",_MRV] setMarkerType G_Mobile_Respawn_Mkr_Type;
					while {((call compile format["G_MRV_%1",_MRV]) getVariable "G_MRV_Alive")} do {
						format["G_MRV_mkr_%1",_MRV] setMarkerPos (getPos _MRV);
						sleep G_Mobile_Respawn_Mkr_Refresh;
					};
					format["G_MRV_mkr_%1",_MRV] setMarkerType "empty";
				};
			};
		};
	};	
};

{
	if (G_PvP) then {
		if (side player == ((call compile format["G_MRV_%1",_x]) getVariable "G_MRV_Side")) then {
			_MRV_mkr = createMarkerLocal [format["G_MRV_mkr_%1",_x], getPos _x];
			format["G_MRV_mkr_%1",_x] setMarkerColorLocal G_Mobile_Respawn_Mkr_Color;
			format["G_MRV_mkr_%1",_x] setMarkerTextLocal G_Mobile_Respawn_Mkr_Text;
			if (G_Mobile_Respawn_Marker) then {
				[_x] spawn G_fnc_MRV_Marker_Process;
			};
		};
	}
	else
	{
		if (isServer) then {
			_MRV_mkr = createMarker [format["G_MRV_mkr_%1",_x], getPos _x];
			format["G_MRV_mkr_%1",_x] setMarkerColor G_Mobile_Respawn_Mkr_Color;
			format["G_MRV_mkr_%1",_x] setMarkerText G_Mobile_Respawn_Mkr_Text;
			if (G_Mobile_Respawn_Marker) then {
				[_x] spawn G_fnc_MRV_Marker_Process;
			};	
		};
	};
	[_x] spawn G_fnc_MRV_onKilled;
} forEach _MRV_Array; 