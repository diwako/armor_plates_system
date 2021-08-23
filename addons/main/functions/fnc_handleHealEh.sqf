#include "script_component.hpp"
[{
    params ["_unit"];
    (damage _unit) isEqualTo 0 || {!alive _unit}
},{
    params ["_unit", "_healer", "_consumeFAK"];
    if !(alive _unit) exitWith {};
    if !(local _unit) exitWith {
        [QGVAR(heal), [_unit, _healer, _consumeFAK], _unit] call CBA_fnc_targetEvent;
    };
    if ((lifeState _unit) == "INCAPACITATED" || {_unit getVariable [QGVAR(unconscious), false]}) exitWith {};

    if (GVAR(enableHpRegen) && {isPlayer _unit}) exitWith {
        systemChat LLSTRING(cannotHealWhileRegenOn);
    };

    private _maxHp = _unit getVariable [QGVAR(maxHP), [GVAR(maxAiHP), GVAR(maxPlayerHP)] select (isPlayer _unit)];
    private _curHp = _unit getVariable [QGVAR(hp), _maxHp];
    private _maxHeal = [GVAR(maxHealRifleman), GVAR(maxHealMedic)] select (_healer getUnitTrait "Medic");
    private _newHp = _maxHp * _maxHeal;

    if (_newHp <= _curHp) exitWith {
        systemChat LLSTRING(cannotHealMoreThanCurrent);
        [_unit, _curHp, _maxHp] call FUNC(setA3Damage);
    };
    _unit setVariable [QGVAR(hp), _newHp, true];
    [_unit, _newHp, _maxHp] call FUNC(setA3Damage);
    if ((call CBA_fnc_currentUnit) isEqualTo _unit) then {
        [_unit] call FUNC(updateHPUi);
    };
    if (_consumeFAK) then {
        [QGVAR(consumeFAK), [_healer], _healer] call CBA_fnc_targetEvent;
    };
}, _this, 10, {
    params ["_unit", "_healer"];
    systemChat format ["DEBUG: %1 could not be healed by %2, wait timer ran out: ", name _unit, name _healer];
    systemChat format ["Patient local %1", local _unit];
    systemChat format ["Medic local %1, is medic %2", local _healer, _healer getUnitTrait "Medic"];
    systemChat "Report this to diwako with a screenshot";
}] call CBA_fnc_waitUntilAndExecute;
