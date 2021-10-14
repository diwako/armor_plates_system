#include "script_component.hpp"
params ["_player"];
private _plates = (vestContainer _player) getVariable [QGVAR(plates), []];
private _plateCtrls = uiNamespace getVariable [QGVAR(plateControls), []];
private _count = count _plates;

{
    private _ctrl = _x select 0;
    private _ctrlBack = _x select 1;
    private _pos = ctrlPosition _ctrl;
    if (_count > _forEachIndex) then {
        private _plateStatus = _plates select _forEachIndex;
        private _newWidth = GVAR(innerWidth) * (_plateStatus / GVAR(maxPlateHealth));
        _pos set [2, _newWidth];
    } else {
        _pos set [2, 0];
    };
    _ctrl ctrlSetPosition _pos;
    _ctrl ctrlSetFade 0;
    _ctrl ctrlCommit 0.1;
    _ctrlBack ctrlSetFade 0;
    _ctrlBack ctrlCommit 0.1;
} forEach _plateCtrls;

if !(isNil QGVAR(hidePlateHandle)) then {
    terminate GVAR(hidePlateHandle);
    GVAR(hidePlateHandle) = nil;
};
if (GVAR(allowHideArmor)) then {
    GVAR(hidePlateHandle) = _plateCtrls spawn {
        sleep GVAR(hideUiSeconds);
        {
            {
                _x ctrlSetFade 1;
                _x ctrlCommit 1;
            } forEach  _x;
        } foreAch _this;
    };
};
