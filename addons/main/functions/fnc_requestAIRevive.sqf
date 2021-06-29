#include "script_component.hpp"
params ["_unit"];

if (!alive _unit || {(lifeState _unit) != 'INCAPACITATED'}) exitWith {};

private _units = units _unit;
private _ai = _units select {
    _x isNotEqualTo _unit && {
    alive _x && {
    !(_x getVariable [QGVAR(hasHealRequest), false]) && {
    !isPlayer _x && {
    (lifeState _x) != 'INCAPACITATED' && {
    !(_x getVariable ["ace_dragging_isDragging", false]) && {
    !(_x getVariable ["ace_dragging_isCarrying", false]) && {
    ([_x] call FUNC(hasHealItems)) > 0}}}}}}}
};

if (_ai isEqualTo []) exitWith {
    if (_units isNotEqualTo [_unit]) then {
        private _group = group _unit;
        private _queue = _group getVariable [QGVAR(reviveQueue), []];
        _queue pushBackUnique _unit;
        _queue = _queue select {alive _x && {(lifeState _x) == 'INCAPACITATED'}};
        _group setVariable [QGVAR(reviveQueue), _queue, true];
    };
};

_ai = _ai apply {[_unit distance _x, _x]};
_ai sort true;

private _healer = _ai select 0 select 1;
[_unit, _healer] spawn FUNC(aiMoveAndHealUnit);
