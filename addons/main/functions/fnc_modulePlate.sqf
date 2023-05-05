#include "script_component.hpp"
params ["_logic"];

if !(local _logic) exitWith {};

private _unit = attachedTo _logic;
deleteVehicle _logic;

if (isNull _unit || {!(_unit isKindOf "CAManBase") || {!alive _unit}}) exitWith {
    [objNull, LLSTRING(invalid_target)] call BIS_fnc_showCuratorFeedbackMessage;
};

[_unit] remoteExec [QFUNC(fillVestWithPlates),_unit];