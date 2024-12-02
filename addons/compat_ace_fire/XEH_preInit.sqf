#include "script_component.hpp"
ADDON = false;

GVAR(aceMedicalLoaded) = isClass(configFile >> "CfgPatches" >> "ace_medical_engine");
if (isClass(configFile >> "CfgPatches" >> "ace_medical") && {!GVAR(aceMedicalLoaded)}) exitWith {
    INFO("PreInit: Disabled --> old ACE medical loaded");
};

#include "XEH_PREP.hpp"
call compile preprocessFileLineNumbers format["%1\XEH_preInit.sqf",REPLACEPATH];
if (GVAR(aceMedicalLoaded)) then {
    //#include "initSettingsACE.inc.sqf"
} else {
    #include "initSettings.inc.sqf"
};

ADDON = true;