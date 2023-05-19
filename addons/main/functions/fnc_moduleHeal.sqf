#include "script_component.hpp"
params ["_logic"];

if !(local _logic) exitWith {};

private _unit = attachedTo _logic;
deleteVehicle _logic;

private _isObj = (typeName _unit) isEqualTo "OBJECT";
private _isPerson = (_isObj && {(_unit isKindOf "CAManBase")});
if (isNull _unit || { !_isObj || { _isPerson && {!alive _unit} } }) exitWith {
    [objNull, LLSTRING(zeus_invalid_target)] call BIS_fnc_showCuratorFeedbackMessage;
};

if (!_isPerson && {_isObj}) then {_unit = crew _unit;} else {_unit = [_unit]};

if (GVAR(aceMedicalLoaded)) then {
    {["ace_medical_treatment_fullHealLocal", [_x], _x] call CBA_fnc_targetEvent;} forEach _unit;
} else {
    {
        if !(_x getUnitTrait "Medic") then {
            _x setUnitTrait ["Medic", true];
            [{  params ["_caller"];
                _caller setUnitTrait ["Medic", false]; 
            }, [_x], 1] call CBA_fnc_waitAndExecute;
        };
        if ((lifeState _x) == "INCAPACITATED" || {_x getVariable [QGVAR(unconscious), false]}) then {
            [_x, _x, false] call FUNC(revive);
        } else {
            _x setDamage 0;
            [_x, _x, false] call FUNC(handleHealEh);
        };
    } forEach _unit;
};
