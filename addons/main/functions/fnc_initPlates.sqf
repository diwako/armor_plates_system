#include "script_component.hpp"
private _staminaDisplay = uiNamespace getVariable [QGVAR(mainDisplay), displayNull];
if (isNull _staminaDisplay) then {
    private _guiDisplay = uiNamespace getVariable ["IGUI_displays", []];
    private _index = _guiDisplay findIf {(str _x) == "Display #305"};
    if (_index isNotEqualTo -1) then {
        _staminaDisplay = _guiDisplay select _index;
        uiNamespace setVariable [QGVAR(mainDisplay), _staminaDisplay];
    };
};

if (isNull _staminaDisplay) exitWith {
    ERROR("Could not find stamina bar display...");
};

private _ctrlGroup = uiNamespace getVariable [QGVAR(mainControl), controlNull];

if (isNull _ctrlGroup) then {
    _ctrlGroup = _staminaDisplay ctrlCreate ["RscControlsGroupNoScrollbars", 65481];
    uiNamespace setVariable [QGVAR(mainControl), _ctrlGroup];

    private _ctrlx = (profilenamespace getvariable ["IGUI_GRID_STAMINA_X", ((safezoneX + safezoneW) - (10 * ( ((safezoneW / safezoneH) min 1.2) / 40)) - 4.3 * ( ((safezoneW / safezoneH) min 1.2) / 40))]);
    private _ctrly = (profilenamespace getvariable ["IGUI_GRID_STAMINA_Y", (safezoneY + 4.05 * ( ( ((safezoneW / safezoneH) min 1.2) / 1.2) / 25))]);
    _ctrly = _ctrly + GVAR(fullHeight);
    _ctrlGroup ctrlSetPosition [_ctrlx, _ctrly, GVAR(fullWidth), GVAR(fullHeight)];
    _ctrlGroup ctrlSetTextColor [1, 1, 1, 1];
    _ctrlGroup ctrlSetBackgroundColor [1, 0, 0, 0];
    _ctrlGroup ctrlSetText "Group";
    _ctrlGroup ctrlCommit 0;
};

private _plateCtrls = uiNamespace getVariable [QGVAR(plateControls), []];
private _count = count _plateCtrls;
if (_count isNotEqualTo GVAR(numWearablePlates)) then {
    private _width = GVAR(fullWidth) / GVAR(numWearablePlates);
    private _innerWidth = _width * 0.9;
    private _padding = (_width - _innerWidth) / 2;
    private _height = (GVAR(fullHeight) / 2) * HEIGHTMOD_HPBARS;
    GVAR(innerWidth) = _innerWidth;
    if (_count < GVAR(numWearablePlates)) then {
        for "_i" from _count to (GVAR(numWearablePlates) - 1) do {
            private _ctrlBack = _staminaDisplay ctrlCreate ["RscText", -1, _ctrlGroup];
            _ctrlBack ctrlSetPosition [_padding + _width * _i, 0, _innerWidth, _height];
            _ctrlBack ctrlSetTextColor [1, 1, 1, 0];
            _ctrlBack ctrlSetBackgroundColor [
                profileNamespace getvariable ['igui_bcg_RGB_R', 0],
                profileNamespace getvariable ['igui_bcg_RGB_G', 0],
                profileNamespace getvariable ['igui_bcg_RGB_B', 0],
                profileNamespace getvariable ['igui_bcg_RGB_A', 0.33]
            ];
            _ctrlBack ctrlCommit 0;
            private _ctrl = _staminaDisplay ctrlCreate ["RscText", -1, _ctrlGroup];
            _ctrl ctrlSetPosition [_padding + _width * _i, 0, 0, _height];
            _ctrl ctrlSetTextColor [1, 1, 1, 0];
            // _ctrl ctrlSetBackgroundColor [0.25, 0.25, 1, 1];
            _ctrl ctrlSetBackgroundColor GVAR(plateColor);
            _ctrl ctrlCommit 0;
            _plateCtrls pushBack [_ctrl, _ctrlBack];
        };
    } else {
        ERROR("Armor plate UI elements can only be added by this function, did you call this by hand? Make sure to delete and clear the plate controls first!");
    };
    uiNamespace setVariable [QGVAR(plateControls), _plateCtrls];
};

private _hpBar = uiNamespace getVariable [QGVAR(hpControl), controlNull];
if (isNull _hpBar) then {
    private _ctrl = _staminaDisplay ctrlCreate ["RscText", -1, _ctrlGroup];
    _ctrl ctrlSetPosition [0, GVAR(fullHeight) / 2, GVAR(fullWidth), (GVAR(fullHeight) / 2) * HEIGHTMOD_HPBARS];
    _ctrl ctrlSetTextColor [1, 1, 1, 0];
    _ctrl ctrlSetBackgroundColor [1, 1, 1, 1];
    _ctrl ctrlSetText "hp";
    _ctrl ctrlCommit 0;
    uiNamespace setVariable [QGVAR(hpControl), _ctrl];
};

[player] call FUNC(updatePlateUi);
[player] call FUNC(updateHPUi);
