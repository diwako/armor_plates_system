#include "script_component.hpp"
params ["_unit"];
private _3den_maxPlateInVest = _unit getVariable [QGVAR(3den_maxPlateInVest), -1];
private _plates = [];
private _num = [GVAR(numWearablePlates), _3den_maxPlateInVest] select (_3den_maxPlateInVest >= 0);
for "_i" from 1 to _num do {
    _plates pushBack GVAR(maxPlateHealth);
};
private _vest = vestContainer _unit;
_vest setVariable [QGVAR(plates), _plates];
_vest setVariable ["ace_movement_vLoad", (_vest getVariable ["ace_movement_vLoad", 0]) + (PLATE_MASS * _num), true];
