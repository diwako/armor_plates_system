#include "script_component.hpp"
params ["_logic"];

if !(local _logic) exitWith {};

deleteVehicle _logic;

[QGVAR(resetMalus), []] call CBA_fnc_globalEvent;