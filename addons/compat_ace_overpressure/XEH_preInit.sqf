#include "script_component.hpp"
ADDON = false;

if !(MAIN_ADDON) exitWith {
    INFO("PreInit: Disabled --> old ACE medical loaded");
};

if (EGVAR(main,aceMedicalLoaded)) then {
    #include "initSettingsACE.inc.sqf"
} else {
    #include "initSettings.inc.sqf"
};

ADDON = true;
