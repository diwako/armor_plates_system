#include "script_component.hpp"
params ["_logic"];

if !(local _logic) exitWith {};

private _unit = attachedTo _logic;
deleteVehicle _logic;

if (isNull _unit || {(_unit isKindOf "CAManBase") && {!alive _unit}}) exitWith {
    [objNull, LLSTRING(invalid_target)] call BIS_fnc_showCuratorFeedbackMessage;
};

if (GVAR(aceMedicalLoaded)) exitWith {};

[_unit, { params ["_unit"];
	if !(_unit isKindOf "CAManBase") {_unit = player;};
    if (!alive _unit) exitWith {};
    diw_armor_plates_main_bleedOutTimeMalus = nil;
    if (_unit getVariable [QGVAR(unconscious), false]) then {
        _unit setVariable [QGVAR(bleedoutKillTime),(cba_missionTime + (GVAR(bleedoutTime) - 0)), true];
    };
}] remoteExec ["call", _unit];
