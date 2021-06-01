params ["_unit", "_source", "_damage", ["_instigator", objNull]];

if (!(local _unit) || {GVAR(damageEhVariant) isNotEqualTo 0}) exitWith {};

[_unit, _damage, "", _instigator] call FUNC(receiveDamage);
