#include "script_component.hpp"
params ["_unit", ["_healer", objNull], ["_consumeUse", false]];
if !(alive _unit) exitWith {};
if !(local _unit) exitWith {
    [QGVAR(reduceMalus), [_unit, _healer, _consumeUse], _unit] call CBA_fnc_targetEvent;
};

if (_consumeUse) then {
    [QGVAR(consumeInjectorUse), [_healer], _healer] call CBA_fnc_targetEvent;
};

if (isNil QGVAR(bleedOutTimeMalus) || {!isPlayer _unit && {!isNil QGVAR(bleedOutTimeMalus)}}) exitWith {
    [{params ["_unit"]; 
        [_unit, true] call FUNC(setUnconscious);
        private _isPlayer = isPlayer _unit;
        if (!_isPlayer) then {
            _unit setVariable [QGVAR(bleedoutKillTime),(cba_missionTime + GVAR(bleedoutTime)), true];
        };
        private _delay = ([GVAR(bleedoutTime),(GVAR(medicReviveTime) min GVAR(noneMedicReviveTime))] select _isPlayer);
        _delay = _delay / 2 - 1;
        [{params ["_unit"];
            [_unit,_unit,false] call FUNC(revive);
            if (isPlayer _unit) then { GVAR(bleedOutTimeMalus) = nil; };
        }, _unit, ((random _delay) + _delay)] call CBA_fnc_waitAndExecute;
    }, _unit, (random 5)] call CBA_fnc_waitAndExecute;
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
    _unit setVariable [QGVAR(bleedoutKillTime),(cba_missionTime + (GVAR(bleedoutTime) - _adjustedMalus)), true];
};