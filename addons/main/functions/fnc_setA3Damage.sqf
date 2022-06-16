#include "script_component.hpp"
params ["_unit", "_newHp", "_maxHp", ["_instigator", objNull]];
_maxHp = _maxHp * GVAR(maxHealRifleman);

if (_newHp >= _maxHp) exitWith {
    _unit setDamage 0;
};

_unit setDamage (0.251 max (linearConversion [0, _maxHp, _newHp, 0.95, 0, true]));
private _limbDamage = linearConversion [0, _maxHp, _newHp, [0.5, 0.95] select GVAR(allowLimping), 0, true];
_unit setHitPointDamage ["hitHands", _limbDamage, true, _instigator];
_unit setHitPointDamage ["hitLegs", _limbDamage, true, _instigator];
