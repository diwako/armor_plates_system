#include "script_component.hpp"
ADDON = false;

if (isClass(configFile >> "CfgPatches" >> "ace_medical") && {!isClass(configFile >> "CfgPatches" >> "ace_medical_engine")}) exitWith {
    INFO("PreInit: Disabled --> old ACE medical loaded");
};

#include "XEH_PREP.hpp"

#include "initSettings.sqf"

GVAR(armorCache) = false call CBA_fnc_createNamespace;

ADDON = true;
