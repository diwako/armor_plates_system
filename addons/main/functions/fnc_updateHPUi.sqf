#include "script_component.hpp"
params ["_player"];

private _hpBar = uiNamespace getVariable [QGVAR(hpControl), controlNull];
private _pos = ctrlPosition _hpBar;
if (GVAR(aceMedicalLoaded)) then {
    _pos set [2, 0];
} else {
    private _maxHp = [GVAR(maxAiHP), GVAR(maxPlayerHP)] select (isPlayer _player);
    private _newPH = _player getVariable [QGVAR(hp), _maxHp];
    private _diff = _newPH / _maxHp;

    private _color = call {
        if (_diff < GVAR(maxHealRifleman) && {_diff > (GVAR(maxHealRifleman)/2)}) exitWith {
            [1, 0.5, 0.5, 1];
        };
        if (_diff < (GVAR(maxHealRifleman)/2)) exitWith {
            [1, 0.1, 0.1, 1];
        };
        if (_diff > 1) exitWith {
            [0.5, 0.5, 1, 1];
        };
        [1, 1, 1, 1];
    };

    _hpBar ctrlSetBackgroundColor _color;
    _pos set [2, GVAR(fullWidth) * _diff];
};

_hpBar ctrlSetPosition _pos;
_hpBar ctrlCommit 0.1;
