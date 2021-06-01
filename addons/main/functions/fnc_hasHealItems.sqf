params ["_unit"];

private _items = (getItemCargo uniformContainer _unit) select 0;
_items append ((getItemCargo vestContainer _unit) select 0);
_items append ((getItemCargo backpackContainer _unit) select 0);
_items = _items arrayIntersect _items;

if ("Medikit" in _items) exitWith {
    2
};
if ("FirstAidKit" in _items) exitWith {
    1
};
0
