#include "script_component.hpp"
params ["_player"];
if ((vest _player) isEqualTo "") exitWith {false};

private _items = call FUNC(uniqueItems);

if !(QGVAR(plate) in _items) exitWith {false};

private _plates = (vestContainer _player) getVariable [QGVAR(plates), []];
if ((count _plates) >= GVAR(numWearablePlates)) exitWith {
    if (GVAR(allowPlateReplace) && {_plates isNotEqualTo [] && {_plates select ((count _plates) - 1) < GVAR(maxPlateHealth)}}) then {
        true
    } else {
        false
    };
};

true
