#include "script_component.hpp"
ADDON = false;

GVAR(aceMedicalLoaded) = isClass(configFile >> "CfgPatches" >> "ace_medical_engine");
if (isClass(configFile >> "CfgPatches" >> "ace_medical") && {!GVAR(aceMedicalLoaded)}) exitWith {
    INFO("PreInit: Disabled --> old ACE medical loaded");
};

#include "XEH_PREP.hpp"
if (GVAR(aceMedicalLoaded)) then {
    #include "initSettingsACE.sqf"
} else {
    #include "initSettings.sqf"

    GVAR(armorCache) = false call CBA_fnc_createNamespace;
};

ADDON = true;
