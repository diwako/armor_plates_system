#include "script_component.hpp"
params ["_unit"];

private _fnc_getItems = {
    private _items = (getItemCargo uniformContainer _unit) select 0;
    _items append ((getItemCargo vestContainer _unit) select 0);
    _items append ((getItemCargo backpackContainer _unit) select 0);

    _items arrayIntersect _items
};

if (_unit isEqualTo (call CBA_fnc_currentUnit)) then {
    if (isNil QGVAR(uniqueItemsCache)) then {
        GVAR(uniqueItemsCache) = call _fnc_getItems;
    };
    +GVAR(uniqueItemsCache)
} else {
    call _fnc_getItems;
};
