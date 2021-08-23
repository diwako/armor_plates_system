#include "script_component.hpp"
params ["_unit", "_healer", "_consumeFAK"];
if !(alive _unit) exitWith {};
if !(local _unit) exitWith {
    [QGVAR(revive), [_unit, _healer, _consumeFAK], _unit] call CBA_fnc_targetEvent;
};

private _unconcious = (lifeState _unit) == "INCAPACITATED" || {_unit getVariable [QGVAR(unconscious), false]};

if !(_unconcious) exitWith {};

[_unit, false] call FUNC(setUnconscious);
//reviving would normally consume a medkit regardless of regen status, so consume it here b/c handleHealEh will not be called if HP regen is on
if (_consumeFAK) then {
    [QGVAR(consumeFAK), [_healer], _healer] call CBA_fnc_targetEvent;
};
if (GVAR(enableHpRegen)) then {
    if (isPlayer _unit) then {
        [_unit] call FUNC(startHpRegen);
    } else {
        if (GVAR(enableHpRegenForAI)) then {
            [_unit] call FUNC(startHpRegen);
        } else {
            _unit setDamage 0;
            [_unit, _healer, false] call FUNC(handleHealEh);
        };
    };
} else {
    _unit setDamage 0;
    [_unit, _healer, false] call FUNC(handleHealEh);
};
