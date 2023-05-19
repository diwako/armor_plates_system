#include "script_component.hpp"
params ["_logic"];

if !(local _logic) exitWith {};

private _unit = attachedTo _logic;
deleteVehicle _logic;

if (GVAR(aceMedicalLoaded)) exitWith {};

private _isObj = (typeName _unit) isEqualTo "OBJECT";
private _isPerson = (_isObj && {(_unit isKindOf "CAManBase")});
if (isNull _unit || { !_isObj || { _isPerson && {!alive _unit} } }) exitWith {
    [objNull, LLSTRING(invalid_target)] call BIS_fnc_showCuratorFeedbackMessage;
};

if (!_isPerson && {_isObj}) then {_unit = crew _unit;} else {_unit = [_unit]};

{[QGVAR(resetMalus), [_x], _x] call CBA_fnc_targetEvent;} forEach (_unit select {isPlayer _x});
