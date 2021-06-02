#include "script_component.hpp"
// params ["_unit", "_source", "_damage", ["_instigator", objNull]];
params ["_unit", "", "_damage", ["_instigator", objNull]];

if (!(local _unit) || {GVAR(damageEhVariant) isNotEqualTo 0}) exitWith {};

[_unit, _damage, "body", _instigator] call FUNC(receiveDamage);
