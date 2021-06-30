#include "script_component.hpp"
params ["_unit", "_source", "_damage", "_instigator"];

if (!(local _unit) || {GVAR(damageEhVariant) isNotEqualTo 0 || {!(isDamageAllowed _unit)}}) exitWith {};

if (isNull _instigator) exitWith {
    private _vehicle = vehicle _unit;
    if (_vehicle isNotEqualTo _unit &&
        {vectorMagnitude (velocity _vehicle) > 5}
    ) exitWith {
        [_unit, _damage, "vehicle", _unit] call FUNC(receiveDamage);
    };

    if (_vehicle isEqualTo _unit && {vectorMagnitude (velocity _unit) > 5 || {((velocity _unit) select 2) < -2}}) exitWith {
        [_unit, _damage * 50, "falldamage", _unit] call FUNC(receiveDamage);
    };
};

[_unit, _damage, "body", [_source, _instigator] select (isNull _source)] call FUNC(receiveDamage);
