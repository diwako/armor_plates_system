#include "script_component.hpp"
params ["_unit"];

if (!alive _unit || {(lifeState _unit) != 'INCAPACITATED'}) exitWith {};

private _ai = (units _unit) select {
    _x isNotEqualTo _unit && {
    alive _x && {
    !(_x getVariable [QGVAR(hasHealRequest), false]) && {
    !isPlayer _x && {
    (lifeState _x) != 'INCAPACITATED' && {
    !(_x getVariable ["ace_dragging_isDragging", false]) && {
    !(_x getVariable ["ace_dragging_isCarrying", false]) && {
    ([_x] call FUNC(hasHealItems)) > 0}}}}}}}
};

if (_ai isEqualTo []) exitWith {};

_ai = _ai apply {[_unit distance _x, _x]};
_ai sort true;

private _healer = _ai select 0 select 1;
[_unit, _healer] spawn FUNC(aiMoveAndHealUnit);
