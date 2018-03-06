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