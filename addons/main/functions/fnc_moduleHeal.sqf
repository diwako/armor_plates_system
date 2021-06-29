#include "script_component.hpp"
params ["_logic"];

if !(local _logic) exitWith {};

private _unit = attachedTo _logic;
deleteVehicle _logic;

if (isNull _unit || {!(_unit isKindOf "CAManBase") || {!alive _unit}}) exitWith {
    [objNull, LLSTRING(invalid_target)] call BIS_fnc_showCuratorFeedbackMessage;
};

if (GVAR(aceMedicalLoaded)) then {
    ["ace_medical_treatment_fullHealLocal", [_unit], _unit] call CBA_fnc_targetEvent;
} else {
    _unit setDamage 0;
    [_unit, _unit] call FUNC(handleHealEh);
};
