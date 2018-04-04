//Mobile respawn
//Define functions for MRV action
G_fnc_MRV_Deploy_Action = {
	//MRV Deployment
	_mobile = _this select 0;
	_deployer = _this select 1;
	_side = _this select 3 select 0;
	_MRV_Logic = _this select 3 select 1;

	//Create respawn position
	_mobileRespawnID = [_side, _mobile] call BIS_fnc_addRespawnPosition;
	//Store respawn ID
	_mobile setVariable ["G_MRV_SpawnID", _mobileRespawnID, true];

	//Handle MRV if not moveable
	if !(G_Mobile_Respawn_Moveable) then {
		//Create empty helipad as anchor and position it on MRV
		_hp = "Land_HelipadEmpty_F" createVehicle (getPos _mobile);
		[_hp, getDir _mobile] remoteExec ["setDir", 0, false];
		//Sleep required to avoid MRV attaching to still-moving _hp
		sleep 0.1;
		//Anchor the MRV to the helipad
		_mobile attachTo [_hp];
	};

	//Set MRV as deployed for usage and marker handling
	_MRV_Logic setVariable ["G_MRV_Deployed", true, true];
};

G_fnc_MRV_UnDeploy_Action = {
	//Undeploy
	_mobile = _this select 0;
	_deployer = _this select 1;
	_undeployActionID = _this select 2;
	_MRV_Logic = _this select 3 select 1;
	_mobileRespawnID = _mobile getVariable "G_MRV_SpawnID";

	_mobileRespawnID call BIS_fnc_removeRespawnPosition; 

	if !(G_Mobile_Respawn_Moveable) then {
		_hp = attachedTo _mobile;
		detach _mobile;
		deleteVehicle _hp;
	};

	_MRV_Logic setVariable ["G_MRV_Deployed",false,true];
};

//Define functions for MRV action conditions
if (G_Revive_System) then {
	G_fnc_MRV_Common_actionCondition = {
		params ["_target", "_this"];
		(((_target distance _this) < 5) && (_target != _this) && !(_this getVariable "G_Dragged") && !(_this getVariable "G_Carried") && !(_this getVariable "G_Carrying") && !(_this getVariable "G_Dragging") && ((_this getVariable "G_Side") == ((_target getVariable "G_MRV_Logic") getVariable "G_Side")))
	};
}
else
{
	G_fnc_MRV_Common_actionCondition = {
		params ["_target", "_this"];
		(((_target distance _this) < 5) && (_target != _this) && ((_this getVariable "G_Side") == ((_target getVariable "G_MRV_Logic") getVariable "G_Side")))
	};
};

if (G_Mobile_Respawn_Moveable) then {
	G_fnc_MRV_Deploy_actionCondition = {
		params ["_target", "_this"];
		(([_target, _this] call G_fnc_MRV_Common_actionCondition) && !((_target getVariable "G_MRV_Logic") getVariable "G_MRV_Deployed"))
	};
	G_fnc_MRV_UnDeploy_actionCondition = {
		params ["_target", "_this"];
		(([_target, _this] call G_fnc_MRV_Common_actionCondition) && ((_target getVariable "G_MRV_Logic") getVariable "G_MRV_Deployed"))
	};
}
else
{
	G_fnc_MRV_Deploy_actionCondition = {
		params ["_target", "_this"];
		(([_target, _this] call G_fnc_MRV_Common_actionCondition) && !((_target getVariable "G_MRV_Logic") getVariable "G_MRV_Deployed") && ((speed _target) < 1) && ((speed _target) > -1))
	};
	G_fnc_MRV_UnDeploy_actionCondition = {
		params ["_target", "_this"];
		(([_target, _this] call G_fnc_MRV_Common_actionCondition) && ((_target getVariable "G_MRV_Logic") getVariable "G_MRV_Deployed") && ((speed _target) < 1) && ((speed _target) > -1))
	};
};

//Define function for MRV init
//bug - locality?
_initVars = {
	private ["_deployActionID", "_undeployActionID"];
	_side = _this select 0;
	_MRV = _this select 1;
	//Only execute locally, since all broadcasted
	//Create a game logic for MRV identity to persist on
	//Define MRV-specific variables on game logic
	//bug - local check earlier? depends on if other things can be broadcasted
	if (local _MRV) then {
		_hp = "Land_HelipadEmpty_F" createVehicle [0, 0, 0];
		_hp setVariable ["G_MRV_Dir", getDir _MRV, true];
		_hp setVariable ["G_MRV_Pos", getPos _MRV, true];
		_hp setVariable ["G_MRV_Type", typeOf _MRV, true];
		_hp setVariable ["G_Side", _side, true];
		_hp setVariable ["G_MRV_Name", vehicleVarName _MRV, true];
		_hp setVariable ["G_MRV_Deployed", false, true];
		_MRV setVariable ["G_MRV_Logic", _hp, true];
	};
	//System variables only being defined on server, so all other clients need to wait for definitions
	waitUntil {(!isNil {_MRV getVariable "G_MRV_Logic"})};
	//Define logic from MRV (on all machines now)
	//bug - all this vs remoteExec?
	_MRV_Logic = _MRV getVariable "G_MRV_Logic";
	//Add Deploy and Undeploy actions, with conditions, to MRV based on Moveable setting
	_deployActionID = _MRV addAction [format["<t color='%1'>Deploy Mobile Respawn</t>", G_Revive_Action_Color], G_fnc_MRV_Deploy_Action, [_side, _MRV_Logic], 1.5, true, true, "", "[_target, _this] call G_fnc_MRV_Deploy_actionCondition"];
	_undeployActionID = _MRV addAction [format["<t color='%1'>Undeploy Mobile Respawn</t>", G_Revive_Action_Color], G_fnc_MRV_UnDeploy_Action, [_side, _MRV_Logic], 1.5, true, true, "", "[_target, _this] call G_fnc_MRV_UnDeploy_actionCondition"];	
	//Broadcast the action variables for remote manipulation
	//bug - WOAH. Locality check. This is being broadcasted by everyone. Doesn't make sense. This needs to change.
	_MRV setVariable ["G_MRV_Action_ID",_deployActionID,true];
	_MRV setVariable ["G_MRV_Undeploy_ID",_undeployActionID,true];
};

//Define array of MRVs and associated side
_MRV_Array = [[G_Mobile_Respawn_WEST, WEST], [G_Mobile_Respawn_EAST, EAST], [G_Mobile_Respawn_GUER, RESISTANCE], [G_Mobile_Respawn_CIV, CIVILIAN]];

//Execute init function for each MRV based on its side
{
	//_x = [[MRV], Side]
	_side = _x select 1;
	{
		//_x = MRV
		[_side, _x] call _initVars;
	} forEach (_x select 0);
} forEach _MRV_Array;

//Define function to handle vehicle locked to enemy
G_fnc_MRV_Lock = {
	_MRV = _this select 0;
	_MRV_Logic = _this select 1;
	//On unit getting in, kick them back out if they are not friendly
	_MRV addEventHandler ["GetIn", {
		_MRV = _this select 0;
		_unit = _this select 2;
		//Obtain MRV logic from MRV
		_MRV_Logic = _MRV getVariable "G_MRV_Logic";
		//If the MRV and unit side are different, prevent entry
		//bug - way to make inde friendly, if appropriate? If so, that may be used elsewhere too
		if ((_MRV_Logic getVariable "G_Side") != (_unit getVariable "G_Side")) then {
			//Prevent engine from turning on
			_fuel = fuel _MRV;
			_MRV setFuel 0;
			//Remove unit from vehicle
			_unit action ["eject", _MRV];
			//Announce kick out and wait for unit to be out of vehicle before adding fuel back
			//bug - does this need to be spawn'd?
			[_unit,_MRV,_fuel] spawn {
				_unit = _this select 0;
				_MRV = _this select 1;
				_fuel = _this select 2;
				//Announce kick out using MRV's display name
				titleText [format["You are not on the right team to enter %1!", getText (configFile >> "CfgVehicles" >> typeOf _MRV >> "displayName")],"PLAIN",1]; 
				titleFadeOut 4;
				//Wait for unit to be out of the vehicle
				waitUntil {sleep 0.5; vehicle _unit == _unit};
				//Add fuel back to MRV
				_MRV setFuel _fuel;
			};
		};
	}];
};

//Define function for handling MRV actions onKilled
//bug - does this have to be outside of the actual EH?
	//until locality is corrected, probably yes
G_fnc_MRV_onKilled = {
	_MRV = _this select 0;
	//Remove Deploy and Undeploy actions from MRV
	_MRV removeAction (_MRV getVariable "G_MRV_Action_ID");
	_MRV removeAction (_MRV getVariable "G_MRV_Undeploy_ID");
};

//Define function for handling MRV onKilled
G_fnc_MRV_onKilled_EH = {
	_MRV = _this select 0;
	_MRV_Logic = _this select 1;
	//Define onKilled EH for MRV to manage respawn position, actions, and its own respawn
	_MRV_killed_EH = _MRV addEventHandler ["Killed",
		{
			_MRV = _this select 0;
			//Get MRV Logic from MRV
			_MRV_Logic = _MRV getVariable "G_MRV_Logic";
			//Remove Deploy and Undeploy actions on all machines
			[_MRV] remoteExecCall ["G_fnc_MRV_onKilled", 0, true];
			//If MRV is deployed, Undeploy it
			//bug - Once that process is made a function, use it here for consistency
			if (_MRV_Logic getVariable "G_MRV_Deployed") then {
				(_MRV getVariable "G_MRV_SpawnID") call BIS_fnc_removeRespawnPosition; 
				_MRV_Logic setVariable ["G_MRV_Deployed", false, true];
			};
			//Manage MRV wreck in parallel
			[_MRV] spawn {
				_oldMRV = _this select 0;
				//Wait for set wreck deletion time
				sleep G_Mobile_Respawn_Wreck;
				//Delete old MRV wreck
				deleteVehicle _oldMRV;
			};
			//Handle MRV respawn
			[_MRV_Logic] spawn G_fnc_MRV_onRespawn_EH;
		}
	];
};

//Define function for handling MRV onRespawn
//bug - a lot of this is done on init, so consider making a function
G_fnc_MRV_onRespawn = {
	private ["_deployActionID", "_undeployActionID"];
	_MRV = _this select 0;
	_MRV_Logic = _this select 1;
	
	//Set new MRV name
	_MRV setVehicleVarName (_MRV_Logic getVariable "G_MRV_Name");
	//Broadcast the new MRV name and non-Deployed status from local machine
	if (local _MRV) then {
		_MRV call compile format ["%1 = _this; publicVariable ""%1""", _MRV_Logic getVariable "G_MRV_Name"];
		_MRV_Logic setVariable ["G_MRV_Deployed", false, true];
	};
	//
	_mrvDir = _MRV_Logic getVariable "G_MRV_Dir";
	_MRV setDir _mrvDir;
	_side = _MRV_Logic getVariable "G_Side";
	//Add Deploy and Undeploy actions, with conditions, to MRV based on Moveable setting
	_deployActionID = _MRV addAction [format["<t color='%1'>Deploy Mobile Respawn</t>", G_Revive_Action_Color], G_fnc_MRV_Deploy_Action, [_side, _MRV_Logic], 1.5, true, true, "", "[_target, _this] call G_fnc_MRV_Deploy_actionCondition"];
	_undeployActionID = _MRV addAction [format["<t color='%1'>Undeploy Mobile Respawn</t>", G_Revive_Action_Color], G_fnc_MRV_UnDeploy_Action, [_side, _MRV_Logic], 1.5, true, true, "", "[_target, _this] call G_fnc_MRV_UnDeploy_actionCondition"];		
	//Broadcast Deploy and Undeploy action variables
	//bug - holy locality. See previous mention of this in init.
	_MRV setVariable ["G_MRV_Action_ID",_deployActionID,true];
	_MRV setVariable ["G_MRV_Undeploy_ID",_undeployActionID,true];
	//Manage MRV spawn marker init
	[_MRV, _MRV_Logic] spawn G_fnc_MRV_Marker_Creation;
	//Add MRV onkilled EH
	[_MRV, _MRV_Logic] spawn G_fnc_MRV_onKilled_EH;
	//Manage MRV locking if enabled
	if (G_Mobile_Respawn_Locked) then {
		[_MRV, _MRV_Logic] spawn G_fnc_MRV_Lock;
	};
	//Custom execution
	if (G_Custom_Exec_4 != "") then {
		[_MRV] execVM G_Custom_Exec_4;
	};
};

//Define function for handling MRV respawn
G_fnc_MRV_onRespawn_EH = {
	_MRV_Logic = _this select 0;

	//Wait for respawn timer
	sleep G_Mobile_Respawn_RespTimer;
	//Create MRV at initial spawn position
	_MRV = (_MRV_Logic getVariable "G_MRV_Type") createVehicle (_MRV_Logic getVariable "G_MRV_Pos");
	//Reassign MRV Logic to new MRV
	_MRV setVariable ["G_MRV_Logic",_MRV_Logic,true];
	//Publically handle MRV onRespawn
	[_MRV, _MRV_Logic] remoteExec ["G_fnc_MRV_onRespawn", 0, true];
};

//Define function for handling MRV markers
G_fnc_MRV_Marker_Process = {
	_MRV = _this select 0;
	_MRV_Logic = _this select 1;
	_MRV_mkr = _this select 2;
	//Check if MRV marker is displayed only when Deployed or not
	if !(G_Mobile_Respawn_Mkr_Display) then {
		//MRV marker only displayed when Deployed
		//Manage appropriately for PvP
		if (G_PvP) then {
			//Is PvP, so is local marker
			//Handle marker while MRV is alive
			while {alive _MRV} do {
				//Wait for MRV to be deployed or destroyed
				waitUntil {sleep 0.5; ((_MRV_Logic getVariable "G_MRV_Deployed") || (!alive _MRV))};
				//Display marker
				_MRV_mkr setMarkerTypeLocal G_Mobile_Respawn_Mkr_Type;
				//Handle marker while MRV is deployed
				while {((_MRV_Logic getVariable "G_MRV_Deployed") && (alive _MRV))} do {
					//Reposition marker onto MRV
					_MRV_mkr setMarkerPosLocal (getPos _MRV);
					//Wait for refresh time
					sleep G_Mobile_Respawn_Mkr_Refresh;
				};
				//Hide marker
				_MRV_mkr setMarkerTypeLocal "empty";
			};
			//Delete local marker
			deleteMarkerLocal _MRV_mkr;
		}
		else
		{
			//Is not PvP, so is public marker
			//Only handle public marker on server
			if (G_isServer) then {
				//Handle marker while MRV is alive
				while {alive _MRV} do {
					//Wait for MRV to be deployed or destroyed
					waitUntil {sleep 0.5; ((_MRV_Logic getVariable "G_MRV_Deployed") || (!alive _MRV))};
					//Display marker
					_MRV_mkr setMarkerType G_Mobile_Respawn_Mkr_Type;
					//Handle marker while MRV is deployed
					while {((_MRV_Logic getVariable "G_MRV_Deployed") && (alive _MRV))} do {
						//Reposition marker onto MRV
						_MRV_mkr setMarkerPos (getPos _MRV);
						//Wait for refresh time
						sleep G_Mobile_Respawn_Mkr_Refresh;
					};
					//Hide marker
					_MRV_mkr setMarkerType "empty";
				};
				//Delete public marker
				deleteMarker _MRV_mkr;
			};
		};
	}
	else
	{
		//MRV marker always displayed
		//Manage appropriately for PvP
		if (G_PvP) then {
			//Is PvP, so is local marker
			//Display marker
			_MRV_mkr setMarkerTypeLocal G_Mobile_Respawn_Mkr_Type;
			//Handle marker while MRV is alive
			while {alive _MRV} do {
				//Reposition marker onto MRV
				_MRV_mkr setMarkerPosLocal (getPos _MRV);
				//Wait for refresh time
				sleep G_Mobile_Respawn_Mkr_Refresh;
			};
			//Hide marker
			_MRV_mkr setMarkerTypeLocal "empty";
			//Delete local marker
			deleteMarkerLocal _MRV_mkr;
		}
		else
		{
			//Is not PvP, so is public marker
			//Only handle public marker on server
			if (G_isServer) then {
				//Display marker
				_MRV_mkr setMarkerType G_Mobile_Respawn_Mkr_Type;
				//Handle marker while MRV is alive
				while {alive _MRV} do {
					//Reposition marker onto MRV
					_MRV_mkr setMarkerPos (getPos _MRV);
					//Wait for refresh time
					sleep G_Mobile_Respawn_Mkr_Refresh;
				};
				//Hide marker
				_MRV_mkr setMarkerType "empty";
				//Delete local marker
				deleteMarker _MRV_mkr;
			};
		};
	};	
};

//Define function for creating MRV markers
G_fnc_MRV_Marker_Creation = {
	_MRV = _this select 0;
	_MRV_Logic = _this select 1;
	//Create local marker for each client if in PvP
	//bug - maybe just always do this, and optimize? Or detect PvP instead of setting it?
	if (G_PvP && G_isClient) then {
		//Check if MRV is on player's side
		if ((player getVariable "G_Side") == (_MRV_Logic getVariable "G_Side")) then {
			//MRV and player on same side, so create local marker
			_MRV_mkr = createMarkerLocal [format["G_MRV_mkr_%1",_MRV], getPos _MRV];
			_MRV_mkr setMarkerColorLocal G_Mobile_Respawn_Mkr_Color;
			_MRV_mkr setMarkerTextLocal G_Mobile_Respawn_Mkr_Text;
			//If respawn marker is enabled, handle it
			//bug - why did we create the marker before checking if this is enabled?
			if (G_Mobile_Respawn_Marker) then {
				[_MRV, _MRV_Logic, _MRV_mkr] spawn G_fnc_MRV_Marker_Process;
			};
		};
	};

	//Create public marker on server if not PvP
	if (!G_PvP && G_isServer) then {
		//Local to server and not in PvP, so create public marker
		_MRV_mkr = createMarker [format["G_MRV_mkr_%1",_MRV], getPos _MRV];
		_MRV_mkr setMarkerColor G_Mobile_Respawn_Mkr_Color;
		_MRV_mkr setMarkerText G_Mobile_Respawn_Mkr_Text;
		//If respawn marker is enabled, handle it
		//bug - why did we create the marker before checking if this is enabled?
		if (G_Mobile_Respawn_Marker) then {
			[_MRV, _MRV_Logic, _MRV_mkr] spawn G_fnc_MRV_Marker_Process;
		};
	};
};

//Execute MRV init
{
	//_x = [[MRV], Side]
	{
		//_x = MRV
		_MRV_Logic = _x getVariable "G_MRV_Logic";
		//Manage MRV spawn marker init
		[_x, _MRV_Logic] spawn G_fnc_MRV_Marker_Creation;
		//Add MRV onkilled EH
		[_x, _MRV_Logic] spawn G_fnc_MRV_onKilled_EH;
		//Manage MRV locking if enabled
		if (G_Mobile_Respawn_Locked) then {
			[_x, _MRV_Logic] spawn G_fnc_MRV_Lock;
		};
		//bug - onRespawn custom execution here, or no? Since this is init, could all just go in editor init
	} forEach (_x select 0);
} forEach _MRV_Array; 