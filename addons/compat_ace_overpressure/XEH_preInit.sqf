#include "script_component.hpp"
ADDON = false;

GVAR(aceMedicalLoaded) = isClass(configFile >> "CfgPatches" >> "ace_medical_engine");
if (isClass(configFile >> "CfgPatches" >> "ace_medical") && {!GVAR(aceMedicalLoaded)}) exitWith {
    INFO("PreInit: Disabled --> old ACE medical loaded");
};

if (GVAR(aceMedicalLoaded)) exitWith {
    //#include "initSettingsACE.inc.sqf"
};

#include "initSettings.inc.sqf"

ADDON = true;