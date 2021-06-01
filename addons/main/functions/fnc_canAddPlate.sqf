#include "script_component.hpp"
params ["_player"];
if ((vest _player) isEqualTo "") exitWith {false};

private _plates = _player getVariable [QGVAR(plates), []];
if ((count _plates) >= GVAR(numWearablePlates)) exitWith {false};

private _items = (getItemCargo uniformContainer _player) select 0;
_items append ((getItemCargo vestContainer _player) select 0);
_items append ((getItemCargo backpackContainer _player) select 0);
_items = _items arrayIntersect _items;

QGVAR(plate) in _items
