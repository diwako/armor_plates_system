#include "script_component.hpp"
params ["_logic"];

diw_armor_plates_main_bleedOutTimeMalus = nil;

if !(local _logic) exitWith {};

deleteVehicle _logic;

