#include "script_component.hpp"
params ["_unit", "_healer"];

AISFinishHeal [_unit, _healer, true];
private _unconcious = (lifeState _unit) == "INCAPACITATED";

if (!_unconcious && {GVAR(enableHpRegen)}) exitWith {
    systemChat "Cannot heal when HP regeneration is on!";
};
private _curHp = _unit getVariable [QGVAR(hp), GVAR(maxUnitHP)];
if (!alive _unit) exitWith {};
private _maxHeal = [GVAR(maxHealRifleman), GVAR(maxHealMedic)] select (_healer getUnitTrait "Medic");
private _newHp = GVAR(maxUnitHP) * _maxHeal;

if (!_unconcious && {_newHp <= _curHp}) exitWith {
    systemChat "Healing failed, cannot heal more than current HP!";
};

_unit setVariable [QGVAR(hp), _newHp];
_unit setDamage ((1 - (_newHp / GVAR(maxUnitHP))) min 0.45);
if ((call CBA_fnc_currentUnit) isEqualTo _unit) then {
    [_unit] call FUNC(updateHPUi);
};

if (_unconcious) then {
    _unit setUnconscious false;
    _unit setCaptive false;
};

[_unit] call FUNC(startHpRegen);
