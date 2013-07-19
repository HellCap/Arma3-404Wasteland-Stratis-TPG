//	@file Version: 1.0
//	@file Name: init.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Description: The server init.
//	@file Args:
#include "setup.sqf"
if(!X_Server) exitWith {};

sideMissions = 1;
serverSpawning = 1;

vChecksum = compileFinal format ["'%1'", call generateKey];

//Execute Server Side Scripts.
_serverCompiledScripts = [] execVM "server\antihack\setup.sqf";
waitUntil {scriptDone _serverCompiledScripts};
[] execVM "server\admins.sqf";
[] execVM "server\functions\serverVars.sqf";
_serverCompiledScripts = [] execVM "server\functions\serverCompile.sqf";
[] execVM "server\functions\broadcaster.sqf";
[] execVM "server\functions\relations.sqf";
[] execVM "server\functions\serverTimeSync.sqf";
[] execVM "server\functions\timeAcceleration.sqf";
[] execVM "scripts\init.sqf";

waitUntil {scriptDone _serverCompiledScripts};

diag_log format["WASTELAND SERVER - Server Compile Finished"];

"requestCompensateNegativeScore" addPublicVariableEventHandler { (_this select 1) call removeNegativeScore };

//Execute Server Spawning.
if (serverSpawning == 1) then {
    diag_log format["WASTELAND SERVER - Initializing Server Spawning"];
	_vehSpawn = [] ExecVM "server\functions\vehicleSpawning.sqf";
	waitUntil{sleep 0.1; scriptDone _vehSpawn};
	_boatSpawn = [] ExecVM "server\functions\boatSpawning.sqf";
	waitUntil{sleep 0.1; scriptDone _boatSpawn};
    _objSpawn = [] ExecVM "server\functions\objectsSpawning.sqf";
	waitUntil{sleep 0.1; scriptDone _objSpawn};
    _boxSpawn = [] ExecVM "server\functions\boxSpawning.sqf";
	waitUntil{sleep 0.1; scriptDone _boxSpawn};
    //_gunSpawn = [] ExecVM "server\functions\staticGunSpawning.sqf";
	//waitUntil{sleep 0.1; scriptDone _gunSpawn};
    _heliSpawn = [] ExecVM "server\functions\staticHeliSpawning.sqf";
    waitUntil{sleep 0.1; scriptDone _heliSpawn};
};

//Execute Server Missions.
if (sideMissions == 1) then {
	diag_log format["WASTELAND SERVER - Initializing Missions"];
    [] execVM "server\missions\sideMissionController.sqf";
    sleep 5;
    [] execVM "server\missions\mainMissionController.sqf";
    //[] execVM "server\missions\worldMissionController.sqf";
};

if (isDedicated) then {
	_id = [] execFSM "server\WastelandServClean.fsm";
};
