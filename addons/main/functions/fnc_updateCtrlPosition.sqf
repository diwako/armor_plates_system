#include "script_component.hpp"
params ["_unit", "_ctrlGroup"];
private _stanceDisplay = uiNamespace getVariable [QGVAR(stanceDisplay), displayNull];
if (isNull _stanceDisplay) then {
    private _guiDisplay = uiNamespace getVariable ["IGUI_displays", []];
    private _index = _guiDisplay findIf {(str _x) == "Display #303"};
    if (_index isNotEqualTo -1) then {
        _stanceDisplay = _guiDisplay select _index;
        uiNamespace setVariable [QGVAR(stanceDisplay), _stanceDisplay];
    };
};

if !(isNull _ctrlGroup) then {
    // default to infantry position
    private _ctrlx = (profileNamespace getVariable ["IGUI_GRID_STAMINA_X", ((safezoneX + safezoneW) - (10 * ( ((safezoneW / safezoneH) min 1.2) / 40)) - 4.3 * ( ((safezoneW / safezoneH) min 1.2) / 40))]);
    if (!(isNull _stanceDisplay) && { !(isNull _unit) && { vehicle _unit != _unit } }) then {
        _ctrlx = _ctrlx + (ctrlPosition (_stanceDisplay displayCtrl 188) select 2);
    };
    private _ctrly = (profileNamespace getVariable ["IGUI_GRID_STAMINA_Y", (safezoneY + 4.05 * ( ( ((safezoneW / safezoneH) min 1.2) / 1.2) / 25))]);
    _ctrly = _ctrly + GVAR(fullHeight);
    _ctrlGroup ctrlSetPosition [_ctrlx, _ctrly, GVAR(fullWidth), GVAR(fullHeight)];
    _ctrlGroup ctrlCommit 0;
    true;
} else { false };