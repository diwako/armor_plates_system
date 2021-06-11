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
        private _container = switch (true) do {
            case ((vest _unit) isNotEqualTo ""): {vestContainer _unit};
            case ((uniform _unit) isNotEqualTo ""): {uniformContainer _unit};
            case ((backpack _unit) isNotEqualTo ""): {backpackContainer _unit};
            default {objNull};
        };
        _container addItemCargoGlobal [QGVAR(plate), _num];
    };
}, [_unit], 1] call CBA_fnc_waitAndExecute;
