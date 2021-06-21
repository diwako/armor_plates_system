#include "script_component.hpp"
params ["_unit"];
if (GVAR(enableHpRegen)) then {
    if (!GVAR(enableHpRegenForAI) && {!isPlayer _unit}) exitWith {};
    if ((_unit getVariable [QGVAR(generation), -1]) isNotEqualTo -1) then {
        terminate (_unit getVariable [QGVAR(generation), -1]);
    };
    private _handle = _unit spawn {
        private _unit = _this;
        sleep 5;

        // Regenerate HP
        private _maxHp = [GVAR(maxAiHP), GVAR(maxPlayerHP)] select (isPlayer _unit);
        while {(_unit getVariable [QGVAR(hp), _maxHp]) < _maxHp && {(lifeState _unit) != "INCAPACITATED"}} do {
            private _newHp = (_unit getVariable [QGVAR(hp), _maxHp]) + (GVAR(hpRegenRate) * 0.1);
            _unit setVariable [QGVAR(hp), _newHp min _maxHp];
            [_unit, _newHp, _maxHp] call FUNC(setA3Damage);

            if ((call CBA_fnc_currentUnit) isEqualTo _unit) then {
                [_unit] call FUNC(updateHPUi);
            };
            sleep 0.1;
        };
    };
    _unit setVariable [QGVAR(generation), _handle];
};
