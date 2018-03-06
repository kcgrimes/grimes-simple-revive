//Universal EH
//Prevent unit from being !alive, begins revive

_unit = _this select 0;

_unit setVariable ["G_Unconscious",false,true];
_unit setVariable ["G_Dragged",false,true];
_unit setVariable ["G_Carried",false,true];
_unit setVariable ["G_Dragging",false,true];
_unit setVariable ["G_Carrying",false,true];
_unit setVariable ["G_getRevived",false,true];
_unit setVariable ["G_Reviving",false,true];
_unit setVariable ["G_Reviver","none",true];
_unit setVariable ["G_Loaded",false,true];
_unit setVariable ["G_Side",side _unit,true];

_unit setVariable ["selections", []];
_unit setVariable ["gethit", []];

_unit addEventHandler 
[	"HandleDamage",
	{
		_unit = _this select 0;
		_selections = _unit getVariable ["selections", []];
		_gethit = _unit getVariable ["gethit", []];
		_selection = _this select 1;
		_projectile = _this select 4;
		if !(_selection in _selections) then
		{
			_selections set [count _selections, _selection];
			_gethit set [count _gethit, 0];
		};
		_i = _selections find _selection;
		_olddmg = _gethit select _i;
		_curdmg = _this select 2;
		if (_curdmg >= 1) then {
			_newdmg = 0.9999;
			_unit allowDamage false;
			null = [_unit] execVM "G_Revive\G_Unconscious.sqf";
			[_unit, _this select 3] execVM "G_Revive\G_Killer.sqf";
			_newdmg;
		}
		else
		{
			_newdmg = _curdmg;
			_gethit set [_i, _newdmg];
			_newdmg;
		};
	}
];

//Unit marker management
if ((G_Unit_Tag) and (G_Unit_Tag_Display != 0)) then {
	waitUntil {G_Unit_Tag_Display_EH_Loaded};
	
	_unit addEventHandler 
	[	"Respawn",
		{
			[[_this select 0, _unit getVariable "G_Unit_Tag_Number"], "G_fnc_Unit_Marker_ReExec", false, true] spawn BIS_fnc_MP;
		}
	];
};

if (G_AI_Fixed_Spawn) then {
	if (!isPlayer _unit) then {
		_unit addEventHandler 
		[	"Respawn",
			{
				private ["_respawnPos"];
				_respawnPos = getPos (_this select 0);
				switch (side (_this select 0)) do {
					case WEST: {
						if (G_AI_Fixed_Spawn_WEST != "") then {
							_respawnPos = getMarkerPos G_AI_Fixed_Spawn_WEST; 
						};
					};
					case EAST: {
						if (G_AI_Fixed_Spawn_EAST != "") then {
							_respawnPos = getMarkerPos G_AI_Fixed_Spawn_EAST; 
						};
					};
					case GUER: {
						if (G_AI_Fixed_Spawn_GUER != "") then {
							_respawnPos = getMarkerPos G_AI_Fixed_Spawn_GUER; 
						};
					};
					case CIV: {
						if (G_AI_Fixed_Spawn_CIV != "") then {
							_respawnPos = getMarkerPos G_AI_Fixed_Spawn_CIV; 
						};
					};
				};
				waitUntil {alive (_this select 0)};
				(_this select 0) setPos _respawnPos;
			}
		];
	};
};