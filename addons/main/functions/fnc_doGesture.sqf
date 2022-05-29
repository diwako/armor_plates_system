#include "script_component.hpp"
params ["_player", ["_add", true]];

// easier editing when adding new gesture speeds
#define MIN 2
#define MAX 16

// prevent gesture eating your current mag when reloading
if (missionNamespace getVariable ["ace_common_isReloading", false]) exitWith {};
if (_add) then {
    private _seconds = floor GVAR(timeToAddPlate);
    if (_seconds >= MIN && {_seconds <= MAX}) exitWith {
        _player playActionNow (format [QGVAR(addPlate_%1), floor GVAR(timeToAddPlate)]);
    };
    if (_seconds > MAX) then {
        _player playActionNow (format [QGVAR(addPlate_%1), MAX]);
    };
} else {
    _player playActionNow QGVAR(stopGesture);
};
