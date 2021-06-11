#include "script_component.hpp"
[{
    params ["_unit"];
    (damage _unit) isEqualTo 0 || {!alive _unit}
},{
    params ["_unit", "_healer"];
    if !(alive _unit) exitWith {};
    private _unconcious = (lifeState _unit) == "INCAPACITATED";

    if (!_unconcious && {GVAR(enableHpRegen) && {isPlayer _unit}}) exitWith {
        systemChat LLSTRING(cannotHealWhileRegenOn);
    };
    private _maxHp = [GVAR(maxAiHP), GVAR(maxPlayerHP)] select (isPlayer _unit);
    private _curHp = _unit getVariable [QGVAR(hp), _maxHp];
    private _maxHeal = [GVAR(maxHealRifleman), GVAR(maxHealMedic)] select (_healer getUnitTrait "Medic");
    private _newHp = _maxHp * _maxHeal;

    if (!_unconcious && {_newHp <= _curHp}) exitWith {
        systemChat LLSTRING(cannotHealMoreThanCurrent);
        [_unit, _curHp, _maxHp] call FUNC(setA3Damage);
    };
    _unit setVariable [QGVAR(hp), _newHp];
    [_unit, _newHp, _maxHp] call FUNC(setA3Damage);
    if ((call CBA_fnc_currentUnit) isEqualTo _unit) then {
        [_unit] call FUNC(updateHPUi);
    };
    if (_unconcious) then {
        [_unit, false] call FUNC(setUnconscious);
        [_unit] call FUNC(startHpRegen);
    };
}, _this, 10] call CBA_fnc_waitUntilAndExecute;

