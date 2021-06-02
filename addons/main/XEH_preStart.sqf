#include "script_component.hpp"
if (isClass(configFile >> "CfgPatches" >> "ace_medical")) exitWith {
    INFO("PreStart: Disabled --> ACE medical loaded");
};
#include "XEH_PREP.hpp"
