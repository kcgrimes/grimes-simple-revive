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