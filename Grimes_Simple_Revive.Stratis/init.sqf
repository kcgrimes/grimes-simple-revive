enableSaving [false, false];

////THE FOLLOWING LINES ARE NEEDED FOR GRIMES' SIMPLE REVIVE SCRIPT
G_Server = false;
G_Client = false;
G_JIP = false;
if (isServer) then {G_Server = true};
if (!isDedicated) then {G_Client = true};
if (isNull player) then {G_JIP = true};

waitUntil {!isNull player};

execVM "G_Revive_init.sqf";
////