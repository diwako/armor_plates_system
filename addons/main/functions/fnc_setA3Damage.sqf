#include "script_component.hpp"
params ["_unit", "_newHp", "_maxHp"];
_unit setDamage (linearConversion [0, _maxHp, _newHp, 0.95, 0]);
private _limbDamage = linearConversion [0, _maxHp, _newHp, 0.5, 0];
_unit setHitPointDamage ["hitHands", _limbDamage];
_unit setHitPointDamage ["hitLegs", _limbDamage];
