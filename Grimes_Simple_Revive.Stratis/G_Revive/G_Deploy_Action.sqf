//Deploy

_mobile = _this select 0;
_deployer = _this select 1;
_side = _this select 3 select 0;
_MRV_Logic = _this select 3 select 1;

_mobileRespawnID = [_side, _mobile] call BIS_fnc_addRespawnPosition; 
_mobile setVariable ["G_MRV_SpawnID",_mobileRespawnID,true];

if !(G_Mobile_Respawn_Moveable) then {
	_hp = "Land_HelipadEmpty_F" createVehicle (getPos _mobile);
	_hp setDir (getDir _mobile);
	[[_hp, getDir _mobile], "G_fnc_setDir", true, false] spawn BIS_fnc_MP; 
	_mobile attachTo [_hp];
};

_MRV_Logic setVariable ["G_MRV_Deployed",true,true];