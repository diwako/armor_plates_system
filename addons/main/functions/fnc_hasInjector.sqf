#include "script_component.hpp"
params ["_unit"];

private _items = call FUNC(uniqueItems);

private _availableInjectorItems = GVAR(injectorItems) arrayIntersect _items;
if (_unit getUnitTrait "Medic" && {_availableInjectorItems isNotEqualTo []}) exitWith {
    _unit setVariable [QGVAR(availableInjector), _availableInjectorItems select 0];
    true
};

false