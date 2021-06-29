#include "script_component.hpp"
params ["_unit"];

if (GVAR(numWearablePlates) isEqualTo 0 || {!local _unit || {isPlayer _unit || {(side group _unit) == civilian}}}) exitWith {};

[{
    params ["_unit"];
    private _3den_maxPlateInVest = _unit getVariable [QGVAR(3den_maxPlateInVest), -1];
    if (_3den_maxPlateInVest >= 0 || {GVAR(AIchancePlateInVest) > 0 && {(random 1) < GVAR(AIchancePlateInVest) && {!isNull (vestContainer _unit)}}}) then {
        private _arr = [];
        private _num = if (_3den_maxPlateInVest >= 0) then {
            _3den_maxPlateInVest min GVAR(numWearablePlates)
        } else {
            [
                GVAR(AIchancePlateInVestMaxNo) min GVAR(numWearablePlates),
                (ceil random GVAR(numWearablePlates))
            ] select (GVAR(AIchancePlateInVestMaxNo) isEqualTo 0);
        };
        for "_i" from 1 to _num do {
            _arr pushBack GVAR(maxPlateHealth);
        };
        (vestContainer _unit) setVariable [QGVAR(plates), _arr];
    };

    private _3den_maxPlateInInventory = _unit getVariable [QGVAR(3den_maxPlateInInventory), -1];
    if (_3den_maxPlateInInventory >= 0 || {GVAR(AIchancePlateInInventory) > 0 && {(random 1) < GVAR(AIchancePlateInInventory)}}) then {
        private _num = if (_3den_maxPlateInVest >= 0) then {
            _3den_maxPlateInInventory
        } else {
            [
                GVAR(AIchancePlateInInventoryMaxNo),
                (ceil random GVAR(numWearablePlates))
            ] select (GVAR(AIchancePlateInInventoryMaxNo) isEqualTo 0);
        };
        private _container = switch (true) do {
            case ((vest _unit) isNotEqualTo ""): {vestContainer _unit};
            case ((uniform _unit) isNotEqualTo ""): {uniformContainer _unit};
            case ((backpack _unit) isNotEqualTo ""): {backpackContainer _unit};
            default {objNull};
        };
        _container addItemCargoGlobal [QGVAR(plate), _num];
    };
}, [_unit], 5] call CBA_fnc_waitAndExecute;
