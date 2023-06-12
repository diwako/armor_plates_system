#include "script_component.hpp"
params ["_unit"];

private _items = call FUNC(uniqueItems);

if (GVAR(enableHpRegen) && {GVAR(enableHealRegen) < 1}) exitWith {-1};

if (_unit getUnitTrait "Medic" && {(GVAR(mediKitItems) arrayIntersect _items) isNotEqualTo []}) exitWith {
    2
};

private _availableFirstAidKitItems = GVAR(firstAidKitItems) arrayIntersect _items;
if (_availableFirstAidKitItems isNotEqualTo []) exitWith {
    _unit setVariable [QGVAR(availableFirstAidKit), _availableFirstAidKitItems select 0];
    1
};
0
