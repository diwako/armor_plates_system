#include "script_component.hpp"

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
        skipWhenMissingDependencies = 1;
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_SCRIPT(XEH_preInit));
    };
};

class Extended_PreStart_EventHandlers {
    class REPLACEMOD {
        init = QUOTE(call COMPILE_SCRIPT(XEH_preStart));
    };
};