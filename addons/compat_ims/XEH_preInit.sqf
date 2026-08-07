#include "script_component.hpp"
ADDON = false;

if !(MAIN_ADDON) exitWith {
    INFO("PreInit: Disabled --> old ACE medical loaded");
};

if !(isClass(configFile >> "CfgPatches" >> "ace_medical_engine")) then {
    #include "initSettings.inc.sqf"
};

ADDON = true;
