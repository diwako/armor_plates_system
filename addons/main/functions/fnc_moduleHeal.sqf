#include "script_component.hpp"
params ["_logic"];

if !(local _logic) exitWith {};

private _unit = attachedTo _logic;
deleteVehicle _logic;

if (isNull _unit || {!(_unit isKindOf "CAManBase") || {!alive _unit}}) exitWith {
    [objNull, LLSTRING(zeus_invalid_target)] call BIS_fnc_showCuratorFeedbackMessage;
};

if (GVAR(aceMedicalLoaded)) then {
    ["ace_medical_treatment_fullHealLocal", [_unit], _unit] call CBA_fnc_targetEvent;
} else {
    if ((lifeState _unit) == "INCAPACITATED" || {_unit getVariable [QGVAR(unconscious), false]}) then {
        [_unit, _unit, false] call FUNC(revive);
    } else {
        _unit setDamage 0;
        [_unit, _unit, false] call FUNC(handleHealEh);
    };
};
