#include "script_component.hpp"
params ["_target"];

private _group = (units group player);
private _med = _group findIf {_x isNotEqualTo _target && {
    alive _x && {
    !(_x getVariable [QGVAR(hasHealRequest), false]) && {
    !isPlayer _x && {
    (lifeState _x) != 'INCAPACITATED' && {
    _x getUnitTrait 'Medic' && {
    simulationEnabled _x && {
    _x checkAIFeature 'PATH' && {
    ([_x] call FUNC(hasHealItems)) > 0}}}}}}}}};
if (_med < 0) then {
    _med = _group findIf {_x isNotEqualTo _target && {
        alive _x && {
        !(_x getVariable [QGVAR(hasHealRequest), false]) && {
        !isPlayer _x && {
        (lifeState _x) != 'INCAPACITATED' && {
        simulationEnabled _x && {
        _x checkAIFeature 'PATH' && {
        ([_x] call FUNC(hasHealItems)) > 0}}}}}}}};
};
if (_med > -1) then {[_target, (_group select _med)] spawn diw_armor_plates_main_fnc_aiMoveAndHealUnit;
} else { systemChat LLSTRING(noMedic); };