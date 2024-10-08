#include "script_component.hpp"
class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {QGVAR(moduleHeal),QGVAR(modulePlate),QGVAR(moduleResetMalus),QGVAR(moduleResetMalusGlobal),QGVAR(plateItem),QGVAR(autoInjectorItem)};
        weapons[] = {QGVAR(plate),QGVAR(autoInjector)};
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
#include "CfgGesturesMale.hpp"
#include "CfgSounds.hpp"
#include "CfgVehicles.hpp"
#include "CfgWeapons.hpp"
#include "CfgFunctions.hpp"
#include "ACE_Medical_Injuries.hpp"
