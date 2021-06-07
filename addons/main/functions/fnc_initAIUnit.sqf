#include "script_component.hpp"
params ["_unit"];

if (GVAR(numWearablePlates) isEqualTo 0 || {!local _unit || {isPlayer _unit}}) exitWith {};

[{
    params ["_unit"];
    if (GVAR(AIchancePlateInVest) > 0 && {(random 1) < GVAR(AIchancePlateInVest) && {!isNull (vestContainer _unit)}}) then {
        private _arr = [];
        for "_i" from 1 to (ceil random GVAR(numWearablePlates)) do {
            _arr pushBack GVAR(maxPlateHealth);
        };
        (vestContainer _unit) setVariable [QGVAR(plates), _arr];
    };

    if (GVAR(AIchancePlateInInventory) > 0 && {(random 1) < GVAR(AIchancePlateInInventory)}) then {
        for "_i" from 1 to (ceil random GVAR(numWearablePlates)) do {
            if (_unit canAdd QGVAR(plate)) then {
                _unit addItem QGVAR(plate);
            };
        };
    };
}, [_unit], 1] call CBA_fnc_waitAndExecute;
