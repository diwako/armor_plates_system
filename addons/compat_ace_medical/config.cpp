#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"diw_armor_plates_main", "ace_medical_treatment"};
        author = "diwako";
        url = "";
        VERSION_CONFIG;
        skipWhenMissingDependencies = 1;
    };
};

#include "ACE_Medical_Treatment_Actions.hpp"
