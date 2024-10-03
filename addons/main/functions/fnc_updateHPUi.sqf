#include "script_component.hpp"
params ["_player"];

private _hpBar = uiNamespace getVariable [QGVAR(hpControl), controlNull];
private _pos = ctrlPosition _hpBar;
private _hide = false;
if (GVAR(aceMedicalLoaded)) then {
    _pos set [2, 0];
    _hide = true;
} else {
    private _maxHp = _player getVariable [QGVAR(maxHP), [GVAR(maxAiHP), GVAR(maxPlayerHP)] select (isPlayer _player)];
    private _newPH = _player getVariable [QGVAR(hp), _maxHp];
    private _diff = _newPH / _maxHp;

    private _color = call {
        if (_diff < 1 && {_diff < GVAR(maxHealRifleman) && {_diff > (GVAR(maxHealRifleman)/2)}}) exitWith {
            [
                profileNamespace getVariable ['igui_warning_RGB_R', 1],
                profileNamespace getVariable ['igui_warning_RGB_G', 0.5],
                profileNamespace getVariable ['igui_warning_RGB_B', 0.5],
                profileNamespace getVariable ['igui_warning_RGB_A', 1]
            ]
        };
        if (_diff <= (GVAR(maxHealRifleman)/2)) exitWith {
            [
                profileNamespace getVariable ['igui_error_RGB_R', 1],
                profileNamespace getVariable ['igui_error_RGB_G', 0.1],
                profileNamespace getVariable ['igui_error_RGB_B', 0.1],
                profileNamespace getVariable ['igui_error_RGB_A', 1]
            ]
        };
        _hide = true;
        if (_diff > 1) exitWith {
            GVAR(plateColor)
        };
        [
            profileNamespace getVariable ['igui_text_RGB_R', 0.13],
            profileNamespace getVariable ['igui_text_RGB_G', 0.54],
            profileNamespace getVariable ['igui_text_RGB_B', 0.21],
            profileNamespace getVariable ['igui_text_RGB_A', 0.8]
        ]
    };

    _hpBar ctrlSetBackgroundColor _color;
    _pos set [2, GVAR(fullWidth) * _diff];
};

if !(isNil QGVAR(hideHPHandle)) then {
    terminate GVAR(hideHPHandle);
    GVAR(hideHPHandle) = nil;
};
if (GVAR(allowHideHP) && {_hide}) then {
    GVAR(hideHPHandle) = [_hpBar] spawn {
        params ["_hpBar"];
        sleep GVAR(hideUiSeconds);
        _hpBar ctrlSetFade 1;
        _hpBar ctrlCommit 1;
    };
};

_hpBar ctrlSetFade 0;
_hpBar ctrlSetPosition _pos;
_hpBar ctrlCommit 0.1;
