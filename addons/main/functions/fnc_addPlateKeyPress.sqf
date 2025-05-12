#include "script_component.hpp"
params ["_player"];

private _ctrl = [LLSTRING(addPlateToVest), GVAR(timeToAddPlate)] call FUNC(createProgressBar);
if (isNull _ctrl) exitWith {};
if (isNil "ace_common_fnc_statusEffect_set") then {
    _player setVariable [QGVAR(wasSprintingAllowed), isSprintAllowed _player];
    _player allowSprint false;
    _player setVariable [QGVAR(wasForceWalked), isForcedWalk _player];
    _player forceWalk true;
} else {
    [_player, "blockSprint", QUOTE(ADDON), true] call ace_common_fnc_statusEffect_set;
    [_player, "forceWalk", QUOTE(ADDON), true] call ace_common_fnc_statusEffect_set;
};
[_player] call FUNC(doGesture);

[{
    params ["_player", "_ctrl"];
    GVAR(addPlateKeyUp) || {
    ctrlCommitted _ctrl || {
    (stance _player) == "PRONE" || {
    !([_player] call FUNC(canPressKey)) || {
    !([_player] call FUNC(canAddPlate))}}}}
}, {
    params ["_player"];
    if (isNil "ace_common_fnc_statusEffect_set") then {
        _player allowSprint (_player getVariable [QGVAR(wasSprintingAllowed), true]);
        _player forceWalk (_player getVariable [QGVAR(wasForceWalked), true]);
    } else {
        [_player, "blockSprint", QUOTE(ADDON), false] call ace_common_fnc_statusEffect_set;
        [_player, "forceWalk", QUOTE(ADDON), false] call ace_common_fnc_statusEffect_set;
    };
    call FUNC(deleteProgressBar);
    [_player, false] call FUNC(doGesture);

    if (GVAR(addPlateKeyUp) || {
        (stance _player) == "PRONE" || {
        !([_player] call FUNC(canPressKey)) || {
        !([_player] call FUNC(canAddPlate))
        }}}) exitWith {};

    [_player] call FUNC(addPlate);

    // add another plate
    if ([_player] call FUNC(canAddPlate)) then {
        [_player] call FUNC(addPlateKeyPress);
    };
}, [_player, _ctrl]] call CBA_fnc_waitUntilAndExecute;
