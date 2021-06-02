#include "script_component.hpp"
ADDON = false;

if (isClass(configFile >> "CfgPatches" >> "ace_medical")) exitWith {
    INFO("PreInit: Disabled --> ACE medical loaded");
};

#include "XEH_PREP.hpp"

#include "initSettings.sqf"

GVAR(armorCache) = false call CBA_fnc_createNamespace;

ADDON = true;
