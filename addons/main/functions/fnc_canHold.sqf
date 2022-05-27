#include "script_component.hpp"
params ["_unit", "_target"];

alive _target && {
_target isNotEqualTo _unit && {
(lifeState _target) == 'INCAPACITATED' && {
(_target distance _unit) < 5 && {
!(_unit getVariable ["ace_dragging_isDragging", false]) && {
!(_unit getVariable ["ace_dragging_isCarrying", false])}}}}}
