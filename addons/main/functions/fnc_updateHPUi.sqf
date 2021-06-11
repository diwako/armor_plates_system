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
        if (_diff < 1 && {_diff <= GVAR(maxHealRifleman) && {_diff > (GVAR(maxHealRifleman)/2)}}) exitWith {
            [
                profileNamespace getvariable ['igui_warning_RGB_R', 1],
                profileNamespace getvariable ['igui_warning_RGB_G', 0.5],
                profileNamespace getvariable ['igui_warning_RGB_B', 0.5],
                profileNamespace getvariable ['igui_warning_RGB_A', 1]
            ]
        };
        if (_diff <= (GVAR(maxHealRifleman)/2)) exitWith {
            [
                profileNamespace getvariable ['igui_error_RGB_R', 1],
                profileNamespace getvariable ['igui_error_RGB_G', 0.1],
                profileNamespace getvariable ['igui_error_RGB_B', 0.1],
                profileNamespace getvariable ['igui_error_RGB_A', 1]
            ]
        };
        if (_diff > 1) exitWith {
            GVAR(plateColor)
        };
        [
            profileNamespace getvariable ['igui_text_RGB_R', 0.13],
            profileNamespace getvariable ['igui_text_RGB_G', 0.54],
            profileNamespace getvariable ['igui_text_RGB_B', 0.21],
            profileNamespace getvariable ['igui_text_RGB_A', 0.8]
        ]
    };

    _hpBar ctrlSetBackgroundColor _color;
    _pos set [2, GVAR(fullWidth) * _diff];
};

_hpBar ctrlSetPosition _pos;
_hpBar ctrlCommit 0.1;
