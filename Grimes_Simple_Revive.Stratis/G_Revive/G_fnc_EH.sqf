//Universal EHs
private ["_specialJIP"];

_unit = _this select 0;

_specialJIP = false;
if (G_isClient) then {
	if (_unit == player) then {
		_specialJIP = true;
	};
};

if (G_isServer || _specialJIP) then {
	if (G_Revive_System) then {
		_vars = ["G_Unconscious","G_Dragged","G_Carried","G_Dragging","G_Carrying","G_getRevived","G_Reviving","G_Loaded","G_byVehicle"];
		{
			if (isNil {_unit getVariable _x}) then {
				_unit setVariable [_x,false,true];
			};
		} forEach _vars;
		if (isNil {_unit getVariable "G_Reviver"}) then {
			_unit setVariable ["G_Reviver",objNull,true];
		};
	};
	if (isNil {_unit getVariable "G_Side"}) then {
		_unit setVariable ["G_Side",side _unit,true];
	};
	if ((G_Revive_DownsPerLife > 0) and (isNil {_unit getVariable "G_Downs"})) then {
		_unit setVariable ["G_Downs",0,true];
	};
	if (isNil {_unit getVariable "G_Lives"}) then {
			_unit setVariable ["G_Lives",G_Num_Respawns,true];
	};
};

waitUntil {(!isNil {_unit getVariable "G_Lives"})};

if (G_Revive_System) then {
	_unit setVariable ["selections", []];
	_unit setVariable ["gethit", []];

	_unit addEventHandler 
	[	"HandleDamage",
		{
			_unit = _this select 0;
			_selections = _unit getVariable ["selections", []];
			_gethit = _unit getVariable ["gethit", []];
			_selection = _this select 1;
			_source = _this select 3;
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
				_newdmg = 0.99;
				if (local _unit) then {
					_unit allowDamage false;
					[_unit, _source, _projectile] execVM "G_Revive\G_Unconscious.sqf";
				};
				[_unit, _source] execVM "G_Revive\G_Killer.sqf";
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

	G_fnc_Revive_Actions = {
		_unit = _this select 0;
		_side = _unit getVariable "G_Side";
		_reviveActionID = _unit addAction [format["<t color='%1'>Revive</t>",G_Revive_Action_Color],"G_Revive\G_Revive_Action.sqf",[],1.5,true,true,"", "!(_this getVariable ""G_Unconscious"") and (_target getVariable ""G_Unconscious"") and ((_target distance _this) < 1.75) and !(_target == _this) and ((_this getVariable ""G_Side"") == (_target getVariable ""G_Side"")) and !(_target getVariable ""G_Dragged"") and !(_target getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and !(_target getVariable ""G_getRevived"") and !(_this getVariable ""G_Reviving"") and (((typeOf _this) in G_Revive_Can_Revive) or ((count G_Revive_Can_Revive) == 0)) and !(_target getVariable ""G_Loaded"")"];
		_dragActionID = _unit addAction [format["<t color='%1'>Drag</t>",G_Revive_Action_Color],"G_Revive\G_Drag_Action.sqf",[],1.5,true,true,"", "!(_this getVariable ""G_Unconscious"") and (_target getVariable ""G_Unconscious"") and ((_target distance _this) < 1.75) and (_target != _this) and !(_target getVariable ""G_Dragged"") and !(_target getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and !(_target getVariable ""G_getRevived"") and !(_this getVariable ""G_Reviving"") and !(_target getVariable ""G_Loaded"")"];
		_carryActionID = _unit addAction [format["<t color='%1'>Carry</t>",G_Revive_Action_Color],"G_Revive\G_Carry_Action.sqf",[],1.5,true,true,"", "!(_this getVariable ""G_Unconscious"") and (_target getVariable ""G_Unconscious"") and ((_target distance _this) < 1.75) and (_target != _this) and !(_target getVariable ""G_Carried"") and !(_target getVariable ""G_Dragged"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and !(_target getVariable ""G_getRevived"") and !(_this getVariable ""G_Reviving"") and !(_target getVariable ""G_Loaded"")"];
		_loadActionID = _unit addAction [format["<t color='%1'>Load Into Vehicle</t>",G_Revive_Action_Color],"G_Revive\G_Load_Action.sqf",[_side],1.5,true,true,"", format["!(_this getVariable ""G_Unconscious"") and (_target getVariable ""G_Unconscious"") and ((_target distance _this) < 1.75) and !(_target == _this) and ((_this getVariable ""G_Side"") == (_target getVariable ""G_Side"")) and !(_target getVariable ""G_Dragged"") and !(_target getVariable ""G_Carried"") and !(_this getVariable ""G_Carrying"") and !(_this getVariable ""G_Dragging"") and !(_target getVariable ""G_getRevived"") and !(_this getVariable ""G_Reviving"") and (count(nearestObjects [_target, %1, 10]) != 0) and !(_target getVariable ""G_Loaded"")",G_Revive_Load_Types]];
	};
	
	[_unit] call G_fnc_Revive_Actions;
	
	_unit addEventHandler 
	[	"Respawn",
		{
			_unit = _this select 0;
			_old = _this select 1;
			[[_unit],"G_fnc_Revive_Actions", true, true] spawn BIS_fnc_MP; 
			[[_old, true], "G_fnc_enableSimulation", true, true] spawn BIS_fnc_MP;
		}
	];

	if (!isPlayer _unit) then {
		_unit addEventHandler
		[	"Respawn",
			{
				_unit = _this select 0;
				_unit setVariable ["G_Unconscious",false,true];
				_unit setVariable ["G_Dragged",false,true];
				_unit setVariable ["G_Carried",false,true];
				_unit setVariable ["G_Dragging",false,true];
				_unit setVariable ["G_Carrying",false,true];
				_unit setVariable ["G_getRevived",false,true];
				_unit setVariable ["G_Reviving",false,true];
				_unit setVariable ["G_Reviver",objNull,true];
				_unit setVariable ["G_Loaded",false,true];
				_unit setVariable ["G_byVehicle",false,true];
				_unit setVariable ["G_Downs",0,true];
				[[_unit, true], "G_fnc_enableSimulation", true, true] spawn BIS_fnc_MP;
				_unit setCaptive false;
				_unit setVariable ["G_Side",side _unit,true];
				_unit enableAI "MOVE";
				_unit allowDamage true;
			}
		];
	};
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
					case RESISTANCE: {
						if (G_AI_Fixed_Spawn_GUER != "") then {
							_respawnPos = getMarkerPos G_AI_Fixed_Spawn_GUER; 
						};
					};
					case CIVILIAN: {
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

if (G_Unit_Tag) then {
	_unit addEventHandler 
	[	"Respawn",
		{
			_unit = _this select 0;
			_old = _this select 1;
			_num = _old getVariable "G_Unit_Tag_Number";
			_unit setVariable ["G_Unit_Tag_Number",_num,true];
			(G_Unit_Tags_Logic getVariable "G_Revive_Player_List") set [_num, _unit];
			_var = G_Unit_Tags_Logic getVariable "G_Revive_Player_List";
			G_Unit_Tags_Logic setVariable ["G_Revive_Player_List", _var, true];
			if (G_Unit_Tag_Display != 0) then {
				[_unit, _num] spawn {
					_unit = _this select 0;
					_num = _this select 1;
					sleep 1;
					[[_unit, _num], "G_fnc_Unit_Tag_Exec", true, true] spawn BIS_fnc_MP;
				};
			};
		}
	];
};