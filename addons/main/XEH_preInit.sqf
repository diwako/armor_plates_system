#include "script_component.hpp"
ADDON = false;

private _aceMedicalLoaded = isClass(configFile >> "CfgPatches" >> "ace_medical_engine");
if (isClass(configFile >> "CfgPatches" >> "ace_medical") && {!_aceMedicalLoaded}) exitWith {
    INFO("PreInit: Disabled --> old ACE medical loaded");
};

GVAR(aceMedicalLoaded) = _aceMedicalLoaded;
#include "XEH_PREP.hpp"
if (_aceMedicalLoaded) then {
    #include "initSettingsACE.inc.sqf"
} else {
    #include "initSettings.inc.sqf"

    [] call FUNC(disableThirdParty);
    GVAR(armorCache) = false call CBA_fnc_createNamespace;
};

GVAR(AcreLoaded) = isClass (configFile >> "CfgPatches" >> "acre_main");
GVAR(TfarLoaded) = isClass (configFile >> "CfgPatches" >> "tfar_core");

ADDON = true;
