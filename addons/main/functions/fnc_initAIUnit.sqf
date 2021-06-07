#include "script_component.hpp"
params ["_unit"];

if (GVAR(numWearablePlates) isEqualTo 0 || {!local _unit || {isPlayer _unit || {(side group _unit) == civilian}}}) exitWith {};

[{
    params ["_unit"];
    if (GVAR(AIchancePlateInVest) > 0 && {(random 1) < GVAR(AIchancePlateInVest) && {!isNull (vestContainer _unit)}}) then {
        private _arr = [];
        private _num = [GVAR(AIchancePlateInVestMaxNo) min GVAR(numWearablePlates), (ceil random GVAR(numWearablePlates))] select (GVAR(AIchancePlateInVestMaxNo) isEqualTo 0);
        for "_i" from 1 to _num do {
            _arr pushBack GVAR(maxPlateHealth);
        };
        (vestContainer _unit) setVariable [QGVAR(plates), _arr];
    };

    if (GVAR(AIchancePlateInInventory) > 0 && {(random 1) < GVAR(AIchancePlateInInventory)}) then {
        private _num = [GVAR(AIchancePlateInInventoryMaxNo), (ceil random GVAR(numWearablePlates))] select (GVAR(AIchancePlateInInventoryMaxNo) isEqualTo 0);
        for "_i" from 1 to _num do {
            if (_unit canAdd QGVAR(plate)) then {
                _unit addItem QGVAR(plate);
            };
        };
    };
}, [_unit], 1] call CBA_fnc_waitAndExecute;
