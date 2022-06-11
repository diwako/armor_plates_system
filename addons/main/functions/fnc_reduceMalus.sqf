#include "script_component.hpp"
params ["_unit", "_healer", "_consumeUse"];
if !(alive _unit) exitWith {};
if !(local _unit) exitWith {
    [QGVAR(reduceMalus), [_unit, _healer, _consumeUse], _unit] call CBA_fnc_targetEvent;
};

if (_consumeUse) then {
    [QGVAR(consumeInjectorUse), [_healer], _healer] call CBA_fnc_targetEvent;
};

if (isNil QGVAR(bleedOutTimeMalus)) exitWith { 
    [_unit] spawn { params ["_unit"];
        sleep (random 5); 
        [_unit, true] call FUNC(setUnconscious);
    };
};

private _adjustedMalus = GVAR(bleedOutTimeMalus);

switch (GVAR(injectorEffect)) do
{
    case 0: {_adjustedMalus = _adjustedMalus};
    case 1: {_adjustedMalus = nil;};
    case 2: {_adjustedMalus = (_adjustedMalus / 2); if (_adjustedMalus < 1) then {_adjustedMalus = nil;}; };
    case 3: {
        _adjustedMalus = (_adjustedMalus - (GVAR(injectorCoef) * GVAR(bleedoutTimeSubtraction))) max 0;
        if (_adjustedMalus < 1) then {_adjustedMalus = nil;};
    };
    default {};
};

GVAR(bleedOutTimeMalus) = _adjustedMalus;

private _unconscious = _unit getVariable [QGVAR(unconscious), false];

if (_unconscious) then {
    if (isNil "_adjustedMalus") then { _adjustedMalus = 0; };
    _unit setVariable [QGVAR(bleedoutKillTime),(cba_missionTime + (GVAR(bleedOutTime) - _adjustedMalus)), true];
};