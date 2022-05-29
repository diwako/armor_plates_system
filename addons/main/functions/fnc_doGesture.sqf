#include "script_component.hpp"
params ["_player", ["_add", true]];

// easier editing when adding new gesture speeds
#define MIN 2
#define MAX 16

// prevent gesture eating your current mag when reloading
if (missionNamespace getVariable ["ace_common_isReloading", false]) exitWith {};
if (_add) then {
    private _seconds = (floor GVAR(timeToAddPlate)) min MAX;
    if (_seconds < MIN) exitWith {};
    _player playActionNow (format [QGVAR(addPlate_%1), _seconds]);

    // prevent button spam for sound
    _player setVariable [QGVAR(gestureStart), cba_missionTime];
    if ((_player getVariable [QGVAR(nextGestureSound), -1]) < cba_missionTime) then {
        _player setVariable [QGVAR(nextGestureSound), cba_missionTime + (_seconds * 0.15) + 1];
        [{
            params ["_player", "_gestureTime"];
            systemChat "Sound: Ziiiiiiiip";
        }, [_player, cba_missionTime], _seconds * 0.15] call CBA_fnc_waitAndExecute;
    };

    if (_seconds > 3) then {
        [{
            params ["_player", "_gestureTime"];
            if ((_player getVariable [QGVAR(gestureStart), -1]) isNotEqualTo _gestureTime) exitWith {};
            systemChat "Sound: Sliiiiiiide";
        }, [_player, cba_missionTime], _seconds * 0.55] call CBA_fnc_waitAndExecute;
    };

    [{
        params ["_player", "_gestureTime"];
        if ((_player getVariable [QGVAR(gestureStart), -1]) isNotEqualTo _gestureTime) exitWith {};
        systemChat "Sound: Zoooooop";
    }, [_player, cba_missionTime], _seconds * 0.75] call CBA_fnc_waitAndExecute;
} else {
    _player playActionNow QGVAR(stopGesture);
    _player setVariable [QGVAR(gestureStart), nil];
};
