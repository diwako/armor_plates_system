#include "script_component.hpp"
if (isClass(configFile >> "CfgPatches" >> "ace_medical") && {!isClass(configFile >> "CfgPatches" >> "ace_medical_engine")}) exitWith {
    INFO("PreStart: Disabled --> old ACE medical loaded");
};
#include "XEH_PREP.hpp"
