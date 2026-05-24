#include "script_component.hpp"
ADDON = false;

private _aceMedicalEngineLoaded = isClass(configFile >> "CfgPatches" >> "ace_medical_engine");
GVAR(piRLoaded) = isClass(configFile >> "CfgPatches" >> "PiR") || {isClass(configFile >> "CfgPatches" >> "pir_main")};
GVAR(aceMedicalLoaded) = _aceMedicalEngineLoaded || {GVAR(piRLoaded)};

if (isClass(configFile >> "CfgPatches" >> "ace_medical") && {!_aceMedicalEngineLoaded} && {!GVAR(piRLoaded)}) exitWith {
    INFO("PreInit: Disabled --> old ACE medical loaded");
};

if (GVAR(piRLoaded)) then {
    INFO("PreInit: PiR detected, using external medical mode");
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
