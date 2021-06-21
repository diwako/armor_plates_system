#include "script_component.hpp"
params ["_displayText", ["_time", 5]];

private _display = findDisplay 46;
if (isNull _display) exitWith {
    ERROR("Could not find display, weird huh?");
    controlNull
};

// clean up first
call FUNC(deleteProgressBar);

private _height = GVAR(fullHeight);
private _backCtrl = _display ctrlCreate ["RscText", -1];
_backCtrl ctrlSetPosition [0 - (10 * pixelW), 0.5 - (10 * pixelH), 1 + (20 * pixelW), _height + (20 * pixelH)];
_backCtrl ctrlSetBackgroundColor [
    profileNamespace getvariable ['igui_bcg_RGB_R', 0],
    profileNamespace getvariable ['igui_bcg_RGB_G', 0],
    profileNamespace getvariable ['igui_bcg_RGB_B', 0],
    // profileNamespace getvariable ['igui_bcg_RGB_A', 0.75]
    0.75 // lets use a set value instead as the defautl alpha is very light
];
_backCtrl ctrlSetTextColor [1,1,1,1];
_backCtrl ctrlCommit 0;

private _ctrl = _display ctrlCreate ["RscText", -1];
_ctrl ctrlSetPosition [0, 0.5, 0, _height];
_ctrl ctrlSetBackgroundColor [
    profileNamespace getvariable ['igui_warning_RGB_R', 0.13],
    profileNamespace getvariable ['igui_warning_RGB_G', 0.54],
    profileNamespace getvariable ['igui_warning_RGB_B', 0.21],
    profileNamespace getvariable ['igui_warning_RGB_A', 0.8]
];
_ctrl ctrlSetTextColor [0,0,0,1];
_ctrl ctrlCommit 0;

private _forGroundCtrl = _display ctrlCreate ["RscStructuredText", -1];
_forGroundCtrl ctrlSetPosition [0, 0.5 - _height - (15 * pixelH), 1, _height*2];
_forGroundCtrl ctrlSetBackgroundColor [0,0,0,0];
_forGroundCtrl ctrlSetTextColor [1,1,1,1];
_forGroundCtrl ctrlSetStructuredText parseText format ["<t align='right' valign='middle' shadow='2' shadowColor='#000000' color='#ffffff'>%1</t>", _displayText];
_forGroundCtrl ctrlCommit 0;

uiNamespace setVariable [QGVAR(plateProgressBar), [_ctrl, _backCtrl, _forGroundCtrl]];

_ctrl ctrlSetPosition [0, 0.5, 1, _height];
_ctrl ctrlCommit _time;

_ctrl
