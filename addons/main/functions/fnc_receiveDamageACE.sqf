#include "script_component.hpp"
params ["_unit", "_damage", "_actualDamage", "_instigator", "_ammo", "_isTorso"];
if (_damage <= 0 || {!alive _unit}) exitWith {0};

private _initialActualDamage = _actualDamage;
private _player = call CBA_fnc_currentUnit;
private _returnedDamage = [_unit, _actualDamage, [true, _isTorso] select GVAR(protectOnlyTorso), _player, _ammo, _instigator] call FUNC(handleArmorDamage);
_actualDamage = _returnedDamage select 0;
private _receivedDamage = _returnedDamage select 1;

if (GVAR(audioFeedback) > 0 && {_player isEqualTo _unit}) then {
    if (GVAR(lastHPDamageSound) isNotEqualTo diag_frameNo) then {
        GVAR(lastHPDamageSound) = diag_frameNo;
        playsound format [QGVAR(hit%1_%2), 1 + floor random 3, GVAR(audioFeedback)];
    };
};

_damage * (_actualDamage / _initialActualDamage)
