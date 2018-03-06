//Mobile respawn

_initVars = {
	private ["_deployActionID", "_undeployActionID"];
	_side = _this select 0;
	_MRV = _this select 1;
	if (local _MRV) then {
		_hp = "Land_HelipadEmpty_F" createVehicle [0,0,0];
		_hp setVariable ["G_MRV_Dir",getDir _MRV,true];
		_hp setVariable ["G_MRV_Pos",getPos _MRV,true];
		_hp setVariable ["G_MRV_Type",typeOf _MRV,true];
		_hp setVariable ["G_Side",_side,true];
		_hp setVariable ["G_MRV_Name",vehicleVarName _MRV,true];
		_hp setVariable ["G_MRV_Deployed",false,true];
		_MRV setVariable ["G_MRV_Logic",_hp,true];
	};
	waitUntil {(!isNil {_MRV getVariable "G_MRV_Logic"})};
	_MRV_Logic = _MRV getVariable "G_MRV_Logic";
	if (G_Mobile_Respawn_Moveable) then {
		_deployActionID = _MRV addAction [format["<t color='%1'>Deploy Mobile Respawn</t>",G_Revive_Action_Color],"G_Revive\G_Deploy_Action.sqf",[_side, _MRV_Logic],1.5,true,true,"", "((_target distance _this) < 5) and (_target != _this) and !(_this getVariable ""G_Dragged"") and !(_this getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and !((_target getVariable ""G_MRV_Logic"") getVariable ""G_MRV_Deployed"") and ((_this getVariable ""G_Side"") == ((_target getVariable ""G_MRV_Logic"") getVariable ""G_Side""))"];
		_undeployActionID = _MRV addAction [format["<t color='%1'>Undeploy Mobile Respawn</t>",G_Revive_Action_Color],"G_Revive\G_Undeploy_Action.sqf",[_side, _MRV_Logic],1.5,true,true,"", "((_target distance _this) < 5) and (_target != _this) and !(_this getVariable ""G_Dragged"") and !(_this getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and ((_target getVariable ""G_MRV_Logic"") getVariable ""G_MRV_Deployed"") and ((_this getVariable ""G_Side"") == ((_target getVariable ""G_MRV_Logic"") getVariable ""G_Side""))"];	
	}
	else
	{
		_deployActionID = _MRV addAction [format["<t color='%1'>Deploy Mobile Respawn</t>",G_Revive_Action_Color],"G_Revive\G_Deploy_Action.sqf",[_side, _MRV_Logic],1.5,true,true,"", "((_target distance _this) < 5) and (_target != _this) and !(_this getVariable ""G_Dragged"") and !(_this getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and !((_target getVariable ""G_MRV_Logic"") getVariable ""G_MRV_Deployed"") and ((speed _target) < 1) and ((speed _target) > -1) and ((_this getVariable ""G_Side"") == ((_target getVariable ""G_MRV_Logic"") getVariable ""G_Side""))"];
		_undeployActionID = _MRV addAction [format["<t color='%1'>Undeploy Mobile Respawn</t>",G_Revive_Action_Color],"G_Revive\G_Undeploy_Action.sqf",[_side, _MRV_Logic],1.5,true,true,"", "((_target distance _this) < 5) and (_target != _this) and !(_this getVariable ""G_Dragged"") and !(_this getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and ((_target getVariable ""G_MRV_Logic"") getVariable ""G_MRV_Deployed"") and ((speed _target) < 1) and ((speed _target) > -1) and ((_this getVariable ""G_Side"") == ((_target getVariable ""G_MRV_Logic"") getVariable ""G_Side""))"];	
	};
	_MRV setVariable ["G_MRV_Action_ID",_deployActionID,true];
	_MRV setVariable ["G_MRV_Undeploy_ID",_undeployActionID,true];
};

if !(count G_Mobile_Respawn_WEST == 0) then {
	{
		_side = WEST;
		[_side, _x] call _initVars;
	} forEach G_Mobile_Respawn_WEST;
};

if !(count G_Mobile_Respawn_EAST == 0) then {
	{
		_side = EAST;
		[_side, _x] call _initVars;
	} forEach G_Mobile_Respawn_EAST;
};

if !(count G_Mobile_Respawn_GUER == 0) then {
	{
		_side = RESISTANCE;
		[_side, _x] call _initVars;
	} forEach G_Mobile_Respawn_GUER;
};

if !(count G_Mobile_Respawn_CIV == 0) then {
	{
		_side = CIVILIAN;
		[_side, _x] call _initVars;
	} forEach G_Mobile_Respawn_CIV;
};

_MRV_Array = G_Mobile_Respawn_WEST + G_Mobile_Respawn_EAST + G_Mobile_Respawn_GUER + G_Mobile_Respawn_CIV;

G_fnc_MRV_Lock = {
	_MRV = _this select 0;
	_MRV_Logic = _this select 1;
	_MRV addEventHandler ["GetIn", {
		_MRV = _this select 0;
		_unit = _this select 2;
		_MRV_Logic = _MRV getVariable "G_MRV_Logic";
		if ((_MRV_Logic getVariable "G_Side") != (_unit getVariable "G_Side")) then {
			_fuel = fuel _MRV;
			_MRV setFuel 0;
			_unit action ["eject", _MRV];
			[_unit,_MRV,_fuel] spawn {
				_unit = _this select 0;
				_MRV = _this select 1;
				_fuel = _this select 2;
				titleText [format["You are not on the right team to enter %1!",typeOf _MRV],"PLAIN",1]; 
				titleFadeOut 4;
				waitUntil {sleep 1; vehicle _unit == _unit};
				_MRV setFuel _fuel;
			};
		};
	}];
};

G_fnc_MRV_onKilled = {
	_MRV = _this select 0;
	_deployActionID = _MRV getVariable "G_MRV_Action_ID";
	_undeployActionID = _MRV getVariable "G_MRV_Undeploy_ID";
	_MRV removeAction _deployActionID;
	_MRV removeAction _undeployActionID;
};

G_fnc_MRV_onKilled_EH = {
	_MRV = _this select 0;
	_MRV_Logic = _this select 1;
	_MRV_killed_EH = _MRV addEventHandler ["Killed",
		{
			_MRV = _this select 0;
			_MRV_Logic = _MRV getVariable "G_MRV_Logic";
			[[_MRV], "G_fnc_MRV_onKilled",true,true,true] call BIS_fnc_MP;
			if (_MRV_Logic getVariable "G_MRV_Deployed") then {
				(_MRV getVariable "G_MRV_SpawnID") call BIS_fnc_removeRespawnPosition; 
				_MRV_Logic setVariable ["G_MRV_Deployed",true,true];
			};
			[_MRV] spawn {
				_oldMRV = _this select 0;
				sleep G_Mobile_Respawn_Wreck;
				deleteVehicle _oldMRV;
			};
			[_MRV_Logic] spawn G_fnc_MRV_onRespawn_EH;
		}
	];
};

G_fnc_MRV_onRespawn = {
	private ["_deployActionID", "_undeployActionID"];
	_MRV = _this select 0;
	_MRV_Logic = _this select 1;
	
	_MRV setVehicleVarName (_MRV_Logic getVariable "G_MRV_Name");
	if (local _MRV) then {
		_MRV call compile format ["%1 = _this; publicVariable ""%1""", _MRV_Logic getVariable "G_MRV_Name"];
		_MRV_Logic setVariable ["G_MRV_Deployed",false,true];
	};
	_mrvDir = _MRV_Logic getVariable "G_MRV_Dir";
	_MRV setDir _mrvDir;
	_side = _MRV_Logic getVariable "G_Side";
	if (G_Mobile_Respawn_Moveable) then {
		_deployActionID = _MRV addAction [format["<t color='%1'>Deploy Mobile Respawn</t>",G_Revive_Action_Color],"G_Revive\G_Deploy_Action.sqf",[_side, _MRV_Logic],1.5,true,true,"", "((_target distance _this) < 5) and (_target != _this) and !(_this getVariable ""G_Dragged"") and !(_this getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and !((_target getVariable ""G_MRV_Logic"") getVariable ""G_MRV_Deployed"") and ((_this getVariable ""G_Side"") == ((_target getVariable ""G_MRV_Logic"") getVariable ""G_Side""))"];
		_undeployActionID = _MRV addAction [format["<t color='%1'>Undeploy Mobile Respawn</t>",G_Revive_Action_Color],"G_Revive\G_Undeploy_Action.sqf",[_side, _MRV_Logic],1.5,true,true,"", "((_target distance _this) < 5) and (_target != _this) and !(_this getVariable ""G_Dragged"") and !(_this getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and ((_target getVariable ""G_MRV_Logic"") getVariable ""G_MRV_Deployed"") and ((_this getVariable ""G_Side"") == ((_target getVariable ""G_MRV_Logic"") getVariable ""G_Side""))"];	
	}
	else
	{
		_deployActionID = _MRV addAction [format["<t color='%1'>Deploy Mobile Respawn</t>",G_Revive_Action_Color],"G_Revive\G_Deploy_Action.sqf",[_side, _MRV_Logic],1.5,true,true,"", "((_target distance _this) < 5) and (_target != _this) and !(_this getVariable ""G_Dragged"") and !(_this getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and !((_target getVariable ""G_MRV_Logic"") getVariable ""G_MRV_Deployed"") and ((speed _target) < 1) and ((speed _target) > -1) and ((_this getVariable ""G_Side"") == ((_target getVariable ""G_MRV_Logic"") getVariable ""G_Side""))"];
		_undeployActionID = _MRV addAction [format["<t color='%1'>Undeploy Mobile Respawn</t>",G_Revive_Action_Color],"G_Revive\G_Undeploy_Action.sqf",[_side, _MRV_Logic],1.5,true,true,"", "((_target distance _this) < 5) and (_target != _this) and !(_this getVariable ""G_Dragged"") and !(_this getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and ((_target getVariable ""G_MRV_Logic"") getVariable ""G_MRV_Deployed"") and ((speed _target) < 1) and ((speed _target) > -1) and ((_this getVariable ""G_Side"") == ((_target getVariable ""G_MRV_Logic"") getVariable ""G_Side""))"];	
	};
	_MRV setVariable ["G_MRV_Action_ID",_deployActionID,true];
	_MRV setVariable ["G_MRV_Undeploy_ID",_undeployActionID,true];
	[_MRV, _MRV_Logic] spawn G_fnc_MRV_Marker_Creation;
	[_MRV, _MRV_Logic] spawn G_fnc_MRV_onKilled_EH;
	if (G_Mobile_Respawn_Locked) then {
		[_MRV, _MRV_Logic] spawn G_fnc_MRV_Lock;
	};
	if (G_Custom_Exec_4 != "") then {
		[_MRV] execVM G_Custom_Exec_4;
	};
};

G_fnc_MRV_onRespawn_EH = {
	_MRV_Logic = _this select 0;

	sleep G_Mobile_Respawn_RespTimer;
	_MRV = (_MRV_Logic getVariable "G_MRV_Type") createVehicle (_MRV_Logic getVariable "G_MRV_Pos");
	_MRV setVariable ["G_MRV_Logic",_MRV_Logic,true];
	[[_MRV, _MRV_Logic], "G_fnc_MRV_onRespawn", true, true] spawn BIS_fnc_MP;
};

G_fnc_MRV_Marker_Process = {
	_MRV = _this select 0;
	_MRV_Logic = _this select 1;
	_MRV_mkr = _this select 2;
	if !(G_Mobile_Respawn_Mkr_Display) then {
		if (G_PvP) then {
			while {alive _MRV} do {
				waitUntil {((_MRV_Logic getVariable "G_MRV_Deployed") || (!alive _MRV))};
				_MRV_mkr setMarkerTypeLocal G_Mobile_Respawn_Mkr_Type;
				while {((_MRV_Logic getVariable "G_MRV_Deployed") and (alive _MRV))} do {
					_MRV_mkr setMarkerPosLocal (getPos _MRV);
					sleep G_Mobile_Respawn_Mkr_Refresh;
				};
				_MRV_mkr setMarkerTypeLocal "empty";
			};
			deleteMarkerLocal _MRV_mkr;
		}
		else
		{
			if (G_isServer) then {
				while {alive _MRV} do {
					waitUntil {((_MRV_Logic getVariable "G_MRV_Deployed") || (!alive _MRV))};
					_MRV_mkr setMarkerType G_Mobile_Respawn_Mkr_Type;
					while {((_MRV_Logic getVariable "G_MRV_Deployed") and (alive _MRV))} do {
						_MRV_mkr setMarkerPos (getPos _MRV);
						sleep G_Mobile_Respawn_Mkr_Refresh;
					};
					_MRV_mkr setMarkerType "empty";
				};
				deleteMarker _MRV_mkr;
			};
		};
	}
	else
	{
		if (G_PvP) then {
			_MRV_mkr setMarkerTypeLocal G_Mobile_Respawn_Mkr_Type;
			while {alive _MRV} do {
				_MRV_mkr setMarkerPosLocal (getPos _MRV);
				sleep G_Mobile_Respawn_Mkr_Refresh;
			};
			_MRV_mkr setMarkerTypeLocal "empty";
			deleteMarkerLocal _MRV_mkr;
		}
		else
		{
			if (G_isServer) then {
				_MRV_mkr setMarkerType G_Mobile_Respawn_Mkr_Type;
				while {alive _MRV} do {
					_MRV_mkr setMarkerPos (getPos _MRV);
					sleep G_Mobile_Respawn_Mkr_Refresh;
				};
				_MRV_mkr setMarkerType "empty";
				deleteMarker _MRV_mkr;
			};
		};
	};	
};

G_fnc_MRV_Marker_Creation = {
	_MRV = _this select 0;
	_MRV_Logic = _this select 1;
	if (G_PvP and G_isClient) then {
		if ((player getVariable "G_Side") == (_MRV_Logic getVariable "G_Side")) then {
			_MRV_mkr = createMarkerLocal [format["G_MRV_mkr_%1",_MRV], getPos _MRV];
			_MRV_mkr setMarkerColorLocal G_Mobile_Respawn_Mkr_Color;
			_MRV_mkr setMarkerTextLocal G_Mobile_Respawn_Mkr_Text;
			if (G_Mobile_Respawn_Marker) then {
				[_MRV, _MRV_Logic, _MRV_mkr] spawn G_fnc_MRV_Marker_Process;
			};
		};
	};

	if (!G_PvP and G_isServer) then {
		_MRV_mkr = createMarker [format["G_MRV_mkr_%1",_MRV], getPos _MRV];
		_MRV_mkr setMarkerColor G_Mobile_Respawn_Mkr_Color;
		_MRV_mkr setMarkerText G_Mobile_Respawn_Mkr_Text;
		if (G_Mobile_Respawn_Marker) then {
			[_MRV, _MRV_Logic, _MRV_mkr] spawn G_fnc_MRV_Marker_Process;
		};
	};
};

{
	_MRV_Logic = _x getVariable "G_MRV_Logic";
	[_x, _MRV_Logic] spawn G_fnc_MRV_Marker_Creation;
	[_x, _MRV_Logic] spawn G_fnc_MRV_onKilled_EH;
	if (G_Mobile_Respawn_Locked) then {
		[_x, _MRV_Logic] spawn G_fnc_MRV_Lock;
	};
} forEach _MRV_Array; 