_unit = _this select 0;
_respawn = _this select 1;

[] spawn {
	while {true} do {
		setPlayerRespawnTime 60;
		sleep 40;
	};
};

[_unit] joinSilent grpNull;

G_fnc_ReviveKeyDownSpectator = {
	if !(G_Revive_SpecHintShow) then {
		_camInfo = "<t color='#FEF50A' size='1.5' shadow='1' shadowColor='#000000' align='center'>Spectator Camera</t><br/><t color='#FEF50A' size='1.5' shadow='1' shadowColor='#000000' align='center'>Control Information</t><br/><br/><t color='#EEEEEE' size='1' shadow='1' shadowColor='#000000' align='left'>Switch between camera/body view - [Space]</t><br/><br/><t color='#EEEEEE' size='1' shadow='1' shadowColor='#000000' align='left'>Reset camera position - [Num 5]</t><br/><br/><t color='#EEEEEE' size='1' shadow='1' shadowColor='#000000' align='left'>Movement along horizontal plane - [W], [S], [A], [D]</t><br/><br/><t color='#EEEEEE' size='1' shadow='1' shadowColor='#000000' align='left'>Movement along vertical plane - [Q] or [PgUp], [Z] or [PgDwn]</t><br/><br/><t color='#EEEEEE' size='1' shadow='1' shadowColor='#000000' align='left'>Boost - [LShift]</t><br/><br/><t color='#EEEEEE' size='1' shadow='1' shadowColor='#000000' align='left'>Rotate on axis - [Num 8], [Num 2], [Num 4], [Num 6]</t><br/><br/><t color='#EEEEEE' size='1' shadow='1' shadowColor='#000000' align='left'>Set track point - [F] or [Num /]</t><br/><br/><t color='#EEEEEE' size='1' shadow='1' shadowColor='#000000' align='left'>Zoom In/Out - [Num +]/[Num -]</t><br/><br/><t color='#EEEEEE' size='1' shadow='1' shadowColor='#000000' align='left'>Mouse has additional panning control</t><br/><br/><t color='#EEEEEE' size='1' shadow='1' shadowColor='#000000' align='left'>Hide lower right name box - [J]</t><br/><br/><t color='#EEEEEE' size='1' shadow='1' shadowColor='#000000' align='left'>Hide HUD - [L]</t><br/><br/><t color='#FEF50A' size='1.1' shadow='1' shadowColor='#000000' align='center'>At any time, press [C] to show/hide the camera controls.</t><br/>";
		hint parseText _camInfo;
		G_Revive_SpecHintShow = true;
	}
	else
	{
		hint "";
		G_Revive_SpecHintShow = false;
	};
};

G_Revive_SpecHintShow = false;
_camInfo = "<t color='#FEF50A' size='1.5' shadow='1' shadowColor='#000000' align='center'>Spectator Camera</t><br/><t color='#FEF50A' size='1.5' shadow='1' shadowColor='#000000' align='center'>Control Information</t><br/><br/><t color='#EEEEEE' size='1' shadow='1' shadowColor='#000000' align='left'>At any time, press [C] to show/hide the camera controls.</t><br/><br/>";
hint parseText _camInfo;
waitUntil {!isNull (findDisplay 46)};
(findDisplay 46) displayAddEventHandler ["KeyDown","if ((_this select 1) == 46) then {call G_fnc_ReviveKeyDownSpectator; false;};"];  

_layer = "BIS_fnc_respawnSpectator" call bis_fnc_rscLayer;

if (!alive _unit) then {
	_layer cutrsc ["RscSpectator","plain"];
} else {
	if (_respawn == 1) then {

		//--- Open
		waituntil {missionnamespace getvariable ["BIS_fnc_feedback_allowDeathScreen",true]};
		BIS_fnc_feedback_allowPP = false;
		//(["HealthPP_black"] call bis_fnc_rscLayer) cutText ["","BLACK IN",1];
		_layer cutrsc ["RscSpectator","plain"];
	} else {

		//--- Close
		_layer cuttext ["","plain"];
	};
};