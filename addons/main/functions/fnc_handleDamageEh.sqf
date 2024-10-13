#include "script_component.hpp"
params ["_unit", "", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "", "_context"];
// params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];
if !(local _unit) exitWith {nil};

private _curDamage = 0;
if (_hitPoint isEqualTo "") then {
    _hitPoint = "#structural";
    _curDamage = damage _unit;
} else {
    _curDamage = _unit getHitIndex _hitIndex;
};

if (GVAR(damageEhVariant) isNotEqualTo 1 || {!(isDamageAllowed _unit)}) exitWith {_curDamage};

// Zeus END key kill
if (_context == 0 && {_damage == 1 && _projectile == "" && isNull _source && isNull _instigator}) exitWith {_damage};

private _newDamage = _damage - _curDamage;
if (_context != 2 && {_context == 4 || _newDamage == 0} || {_newDamage < 1E-3}) exitWith {
    _curDamage
};

// Drowning doesn't fire the EH for each hitpoint
// Damage occurs in consistent increments
if (
    _hitPoint isEqualTo "#structural" &&
    {getOxygenRemaining _unit <= 0.5} &&
    {_damage isEqualTo (_curDamage + 0.005)}
) exitWith {
    [_unit, _newDamage, "body", _unit, _projectile] call FUNC(receiveDamage);
    0
};

// Crashing a vehicle doesn't fire the EH for each hitpoint
// It does fire the EH multiple times, but this seems to scale with the intensity of the crash
private _vehicle = vehicle _unit;
if (
    _hitPoint isEqualTo "#structural" &&
    {_projectile isEqualTo ""} &&
    {_vehicle isNotEqualTo _unit} &&
    {vectorMagnitude (velocity _vehicle) > 5}
) exitWith {
    [_unit, _newDamage / 2, "vehicle", _unit, _projectile] call FUNC(receiveDamage);
    0
};

if (
    _projectile isEqualTo "" && {
    ([_source, _instigator] select (isNull _source)) isEqualTo _unit && {
    vectorMagnitude (velocity _unit) > 5 || {((velocity _unit) select 2) < -2}}}
) exitWith {
    if (_hitPoint isEqualTo "incapacitated") then {
        [_unit, _newDamage * 3.25, "falldamage", _unit, _projectile] call FUNC(receiveDamage);
        0
    } else {
        _curDamage
    };
};

if (_projectile isEqualTo "" && {isNull _source}) exitWith {
    // if !(isMultiplayer) then {
        // systemChat format ["DID NOT PASS DAMAGE: %1 | %2 | %3 | %4", _hitPoint, _projectile, _newDamage, _source];
    // };
    _curDamage
};

// handle rest of damage
private _armor = [_unit, _hitpoint] call FUNC(getHitpointArmor);
private _realDamage = _newDamage * (1 + _armor/100);
_hitPoint = [_hitPoint, "hit", ""] call CBA_fnc_replace;

private _var = format ["GVAR(lastHandleDamage)$%1", _hitPoint];
if ((_unit getVariable [_var, -1]) isEqualTo _realDamage) exitWith {_curDamage};
_unit setVariable [_var, _realDamage];

if (GVAR(useHandleDamageFiltering)) then {
    private _damageCache = _unit getVariable [QGVAR(damageCache), []];
    if (_damageCache isEqualTo []) then {
        _unit setVariable [QGVAR(damageCache), _damageCache];
        [{
            params ["_unit", "_source", "_projectile"];
            private _damageCache = _unit getVariable [QGVAR(damageCache), []];
            if (_damageCache isNotEqualTo []) then {
                _damageCache sort false;
                (_damageCache select 0) params ["_realDamage", "_hitPoint"];
                [_unit, _realDamage, _hitPoint, _source, _projectile] call FUNC(receiveDamage);
            };
            _unit setVariable [QGVAR(damageCache), nil];
        }, [_unit, [_source, _instigator] select (isNull _source), _projectile]] call CBA_fnc_execNextFrame;
    };
    _damageCache pushBack [_realDamage, _hitPoint];
} else {
    [_unit, _realDamage, _hitPoint, [_source, _instigator] select (isNull _source), _projectile] call FUNC(receiveDamage);
};

0
