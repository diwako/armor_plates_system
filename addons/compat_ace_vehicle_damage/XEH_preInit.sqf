#include "script_component.hpp"
ADDON = false;

if !(MAIN_ADDON) exitWith {
    INFO("PreInit: Disabled --> old ACE medical loaded");
};

#include "initSettings.inc.sqf"

ADDON = true;