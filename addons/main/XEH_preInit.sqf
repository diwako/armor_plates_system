#include "script_component.hpp"
ADDON = false;

GVAR(aceMedicalLoaded) = isClass(configFile >> "CfgPatches" >> "ace_medical_engine");
if (isClass(configFile >> "CfgPatches" >> "ace_medical") && {!GVAR(aceMedicalLoaded)}) exitWith {
    INFO("PreInit: Disabled --> old ACE medical loaded");
};

#include "XEH_PREP.hpp"
if (GVAR(aceMedicalLoaded)) then {
    #include "initSettingsACE.inc.sqf"
} else {
    #include "initSettings.inc.sqf"

    [] call FUNC(disableThirdParty);
    GVAR(armorCache) = false call CBA_fnc_createNamespace;
};

GVAR(AcreLoaded) = isClass (configFile >> "CfgPatches" >> "acre_main");
GVAR(TfarLoaded) = isClass (configFile >> "CfgPatches" >> "tfar_core");

ADDON = true;
