#include "script_component.hpp"
params ["_player"];
private _vest = vest _player;
if (_vest isEqualTo "" || {_vest in GVAR(vestBlacklist)}) exitWith {false};

if !(GVAR(hasPlateInInvetory)) exitWith {false};

private _plates = (vestContainer _player) getVariable [QGVAR(plates), []];
if ((count _plates) >= GVAR(numWearablePlates)) exitWith {
    if (GVAR(allowPlateReplace) && {_plates isNotEqualTo [] && {_plates select ((count _plates) - 1) < GVAR(maxPlateHealth)}}) then {
        true
    } else {
        false
    };
};

true
