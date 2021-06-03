#include "script_component.hpp"
params ["_unit", "_instigator", "_damage"];
private _display = findDisplay 46;
if (isNull _display) exitWith {
    ERROR("display was null");
};

private _selfOrUnkownDamage = isNull _instigator || {_unit isEqualTo _instigator};
private _ctrl = _display ctrlCreate ["RscPictureKeepAspect", -1];
_ctrl ctrlSetBackgroundColor [0, 0, 0, 1];
_ctrl ctrlSetPosition [0, 0, 1, 1];
_ctrl ctrlSetTextColor [1, 1, 1, 0.75];
_ctrl ctrlSetText ([QPATHTOF(ui\damageMarker_ca.paa), QPATHTOF(ui\damageMarkerRound_ca.paa)] select _selfOrUnkownDamage);
_ctrl ctrlSetFade 1;
_ctrl ctrlCommit 0;

if !(_selfOrUnkownDamage) then {
    private _camDirVec = (positionCameratoWorld [0,0,0] vectorFromTo (positionCameraToWorld [0,0,1])) call CBA_fnc_vectDir;
    private _relDir = [_instigator, _unit] call BIS_fnc_dirTo;
    _ctrl ctrlSetAngle [180 + _relDir - _camDirVec, 0.5, 0.5, true];
};
if (GVAR(aceMedicalLoaded)) then {
    _ctrl ctrlSetFade 0;
} else {
    private _maxHp = [GVAR(maxAiHP), GVAR(maxPlayerHP)] select (isPlayer _unit);
    _ctrl ctrlSetFade (linearConversion [0, _maxHp, _damage, 0.75, 0, true]);
};
_ctrl ctrlCommit 0.05;

// addCamShake [50, 1, 2];

private _feedback = uiNamespace getVariable [QGVAR(feedBackCtrl), []];
_feedback pushBack _ctrl;
uiNamespace setVariable [QGVAR(feedBackCtrl), _feedback];

[{
    ctrlCommitted _this;
},{
    _this ctrlSetFade 1;
    _this ctrlCommit 5;
    [{
        ctrlCommitted _this;
    },{
        private _feedback = uiNamespace getVariable [QGVAR(feedBackCtrl), []];
        _feedback = _feedback - [_this];
        uiNamespace setVariable [QGVAR(feedBackCtrl), _feedback];
        ctrlDelete _this;
    }, _this] call CBA_fnc_waitUntilAndExecute;
}, _ctrl] call CBA_fnc_waitUntilAndExecute;
