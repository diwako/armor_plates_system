#include "script_component.hpp"
if (!MAIN_ADDON) exitWith {
    INFO("PreStart: Disabled --> old ACE medical loaded");
};
#include "XEH_PREP.hpp"
call compileScript preprocessFileLineNumbers format["%1\XEH_preStart.sqf",REPLACEPATH];