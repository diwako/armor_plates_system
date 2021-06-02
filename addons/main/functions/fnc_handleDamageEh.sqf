#include "script_component.hpp"
params ["_unit", "", "_damage", "", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
// params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
if !(local _unit) exitWith {nil};

private _curDamage = 0;
if (_hitPoint isEqualTo "") then {
    _hitPoint = "#structural";
    _curDamage = damage _unit;
} else {
    _curDamage = _unit getHitIndex _hitIndex;
};

if (GVAR(damageEhVariant) isNotEqualTo 1) exitWith {_curDamage};
if !(isDamageAllowed _unit && {_unit getVariable ["ace_medical_allowDamage", true]}) exitWith {_curDamage};
if (_hitPoint in ["hithead", "hitbody", "hithands", "hitlegs"]) exitWith {_curDamage};

private _newDamage = _damage - _curDamage;
if (_newDamage isEqualTo 0) exitWith {
    _curDamage
};

// Drowning doesn't fire the EH for each hitpoint
// Damage occurs in consistent increments
if (
    _hitPoint isEqualTo "#structural" &&
    {getOxygenRemaining _unit <= 0.5} &&
    {_damage isEqualTo (_curDamage + 0.005)}
) exitWith {
    [_unit, _newDamage, "body", _unit] call FUNC(receiveDamage);
    0
};
if (_newDamage < 0.05) exitWith {_curDamage};

// Crashing a vehicle doesn't fire the EH for each hitpoint
// It does fire the EH multiple times, but this seems to scale with the intensity of the crash
private _vehicle = vehicle _unit;
if (
    _hitPoint isEqualTo "#structural" &&
    {_projectile isEqualTo ""} &&
    {_vehicle != _unit} &&
    {vectorMagnitude (velocity _vehicle) > 5}
) exitWith {
    [_unit, _newDamage, "body", _unit] call FUNC(receiveDamage);
    0
};

// handle rest of damage
private _armor = [_unit, _hitpoint] call FUNC(getHitpointArmor);
private _realDamage = _newDamage * (1 + _armor/100);
_hitPoint = [_hitPoint, "hit", ""] call CBA_fnc_replace;

private _var = format ["GVAR(lastHandleDamage)$%1", _hitPoint];
if ((_unit getVariable [_var, -1]) isEqualTo _realDamage) exitWith {_curDamage};
_unit setVariable [_var, _realDamage];
[_unit, _realDamage, _hitPoint, _instigator] call FUNC(receiveDamage);
0
