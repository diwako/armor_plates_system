#include "script_component.hpp"

#pragma hemtt flag pe23_ignore_has_include
#if __has_include("\z\ace\addons\vehicle_damage\script_component.hpp")
#define PATCH_SKIP "ACE Vehicle Damage"
#endif

#ifndef PATCH_SKIP
class CfgPatches {
    class DOUBLES(ADDON,notLoaded) {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"diw_armor_plates_main"};
        VERSION_CONFIG;
    };
};
class DOUBLES(PREFIX,notLoaded) {
    ADDON = "ACE Vehicle Damage";
};
#else
class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"diw_armor_plates_main",QUOTE(REPLACEMOD)};
        author = "Alien314";
        authors[] = {"Alien314","ACE-Team"};
        url = "";
        VERSION_CONFIG;
    };
};

class Extended_PreInit_EventHandlers {
    class REPLACEMOD {
        init = QUOTE(call COMPILE_SCRIPT(XEH_preInit));
    };
};

class Extended_PreStart_EventHandlers {
    class REPLACEMOD {
        init = QUOTE(call COMPILE_SCRIPT(XEH_preStart));
    };
};


#endif