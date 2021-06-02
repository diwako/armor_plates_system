#include "script_component.hpp"
params ["_player"];

// GVAR(timeToAddPlate)
private _display = findDisplay 46;
if (isNull _display) exitWith {
    systemChat "Could not find display, weird huh?";
};

private _height = GVAR(fullHeight)*2;
private _backCtrl = _display ctrlCreate ["RscText", -1];
_backCtrl ctrlSetPosition [0, 0.5, 1, _height];
_backCtrl ctrlSetBackgroundColor [0,0,0,0.75];
_backCtrl ctrlSetTextColor [1,1,1,1];
_backCtrl ctrlCommit 0;

private _ctrl = _display ctrlCreate ["RscText", -1];
_ctrl ctrlSetPosition [0, 0.5, 0, _height];
_ctrl ctrlSetBackgroundColor [1,1,1,1];
_ctrl ctrlSetTextColor [0,0,0,1];
_ctrl ctrlCommit 0;

private _forGroundCtrl = _display ctrlCreate ["RscStructuredText", -1];
_forGroundCtrl ctrlSetPosition [0, 0.5, 1, _height];
_forGroundCtrl ctrlSetBackgroundColor [0,0,0,0];
_forGroundCtrl ctrlSetTextColor [1,1,1,1];
_forGroundCtrl ctrlSetStructuredText parseText "<t align='center' valign='middle' shadow='2 shadowColor='#000000' color='#ffffff'>Adding ceramic plate to vest</t>";
_forGroundCtrl ctrlCommit 0;

uiNamespace setVariable [QGVAR(plateProgressBar), [_ctrl, _backCtrl, _forGroundCtrl]];

_player setVariable [QGVAR(wasSprintingAllowed), isSprintAllowed _player];
_player allowSprint false;
_player setVariable [QGVAR(wasForceWalked), isForcedWalk _player];
_player forceWalk true;

_ctrl ctrlSetPosition [0, 0.5, 1, _height];
_ctrl ctrlCommit GVAR(timeToAddPlate);

[{
    params ["_player", "_ctrl"];
    GVAR(addPlateKeyUp) || {
    ctrlCommitted _ctrl || {
    (stance _player) == "PRONE" || {
    !([_player] call FUNC(canPressKey)) || {
    !([_player] call FUNC(canAddPlate))}}}}
}, {
    params ["_player"];
    _player allowSprint (_player getVariable [QGVAR(wasSprintingAllowed), true]);
    _player forceWalk (_player getVariable [QGVAR(wasForceWalked), true]);
    {
        ctrlDelete _x;
    } forEach (uiNamespace getVariable [QGVAR(plateProgressBar), []]);

    if (GVAR(addPlateKeyUp) || {
        (stance _player) == "PRONE" || {
        !([_player] call FUNC(canPressKey)) || {
        !([_player] call FUNC(canAddPlate))
        }}}) exitWith {};

    private _plates = (vestContainer _player) getVariable [QGVAR(plates), []];

    if (_plates isNotEqualTo []) then {
        // get last plate, it might be already damaged
        private _lastPlate = _plates deleteAt ((count _plates) - 1);
        _plates pushBack GVAR(maxPlateHealth);
        // add the last plate back
        _plates pushBack _lastPlate;
    } else {
        _plates pushBack GVAR(maxPlateHealth);
    };
    _player removeItem QGVAR(plate);
    (vestContainer _player) setVariable [QGVAR(plates), _plates];
    [_player] call FUNC(updatePlateUi);

    // add another plate
    if ([_player] call FUNC(canAddPlate)) then {
        [_player] call FUNC(addPlate);
    };
}, [_player, _ctrl]] call CBA_fnc_waitUntilAndExecute;
