#include "script_component.hpp"
class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {QGVAR(moduleHeal)};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main"};
        author = "diwako";
        url = "";
        authorUrl = "";
        VERSION_CONFIG;
    };
};

#include "CfgEden.hpp"
#include "CfgEventHandlers.hpp"
#include "CfgFactionClasses.hpp"
#include "CfgMoves.hpp"
#include "CfgSounds.hpp"
#include "CfgVehicles.hpp"
#include "CfgWeapons.hpp"
#include "CfgFunctions.hpp"

class ACE_Medical_Injuries {
    class damageTypes {
        class woundHandlers;
        class bullet {
            class woundHandlers: woundHandlers {
                ADDON = QFUNC(aceDamageHandler);
            };
        };
        class grenade {
            class woundHandlers: woundHandlers {
                ADDON = QFUNC(aceDamageHandler);
            };
        };
        class explosive {
            class woundHandlers: woundHandlers {
                ADDON = QFUNC(aceDamageHandler);
            };
        };
        class shell {
            class woundHandlers: woundHandlers {
                ADDON = QFUNC(aceDamageHandler);
            };
        };
        class stab {
            class woundHandlers: woundHandlers {
                ADDON = QFUNC(aceDamageHandler);
            };
        };
        class punch {
            class woundHandlers: woundHandlers {
                ADDON = QFUNC(aceDamageHandler);
            };
        };
        class unknown {
            class woundHandlers: woundHandlers {
                ADDON = QFUNC(aceDamageHandler);
            };
        };
    };
};
