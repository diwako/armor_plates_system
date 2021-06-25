#include "script_component.hpp"
params ["_player"];

private _ctrl = [LLSTRING(addPlateToVest), GVAR(timeToAddPlate)] call FUNC(createProgressBar);
if (isNull _ctrl) exitWith {};

_player setVariable [QGVAR(wasSprintingAllowed), isSprintAllowed _player];
_player allowSprint false;
_player setVariable [QGVAR(wasForceWalked), isForcedWalk _player];
_player forceWalk true;

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
    call FUNC(deleteProgressBar);

    if (GVAR(addPlateKeyUp) || {
        (stance _player) == "PRONE" || {
        !([_player] call FUNC(canPressKey)) || {
        !([_player] call FUNC(canAddPlate))
        }}}) exitWith {};

    private _vest = vestContainer _player;
    private _plates = _vest getVariable [QGVAR(plates), []];
    private _vLoad = _vest getVariable ["ace_movement_vLoad", 0];

    if (_plates isNotEqualTo []) then {
        // get last plate, it might be already damaged
        private _count = count _plates;
        _plates sort false;
        private _lastPlate = _plates deleteAt (_count - 1);
        _plates pushBack GVAR(maxPlateHealth);
        if (_count < GVAR(numWearablePlates)) then {
            // add the last plate back
            _plates pushBack _lastPlate;
            _vest setVariable ["ace_movement_vLoad", _vLoad + PLATE_MASS, true];
        };
        _plates sort false;
    } else {
        _plates pushBack GVAR(maxPlateHealth);
        _vest setVariable ["ace_movement_vLoad", _vLoad + PLATE_MASS, true];
    };
    _player removeItem QGVAR(plate);
    (vestContainer _player) setVariable [QGVAR(plates), _plates];
    [_player] call FUNC(updatePlateUi);

    // add another plate
    if ([_player] call FUNC(canAddPlate)) then {
        [_player] call FUNC(addPlate);
    };
}, [_player, _ctrl]] call CBA_fnc_waitUntilAndExecute;
