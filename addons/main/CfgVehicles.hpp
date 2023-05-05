
class CBA_Extended_EventHandlers;
class CfgVehicles {
    // Treatment items
    class Item_Base_F;
    class GVAR(plateItem): Item_Base_F {
        scope = 2;
        scopeCurator = 2;
        displayName = "Armor Plate";
        author = "diwako";
        model = "\A3\Weapons_F\DummyItemHorizontal.p3d";
        vehicleClass = "Items";
        class TransportItems {
            MACRO_ADDITEM(plate,1);
        };
    };

    class GVAR(autoInjectorItem): GVAR(plateItem) {
        editorPreview = "\A3\EditorPreviews_F_Orange\Data\CfgVehicles\MedicalGarbage_01_Injector_F.jpg";
        displayName = "Auto-Injector";
        author = "alien314";
        model = "\A3\Weapons_F\DummyItem.p3d";
        class TransportItems {
            MACRO_ADDITEM(autoInjector,1);
        };
    };

    class Module_F;
    class GVAR(moduleBase): Module_F {
        author = CSTRING(category);
        category = "APS";
        function = "";
        functionPriority = 1;
        isGlobal = 1;
        isTriggerActivated = 0;
        scope = 1;
        scopeCurator = 2;
    };
    class GVAR(moduleHeal): GVAR(moduleBase) {
        curatorCanAttach = 1;
        displayName = CSTRING(zeus_module_heal);
        function = QFUNC(moduleHeal);
        icon = "\A3\ui_f\data\Map\VehicleIcons\pictureHeal_ca.paa";
    };
    class GVAR(moduleResetMalus): GVAR(moduleBase) {
        curatorCanAttach = 1;
        displayName = CSTRING(zeus_module_malus);
        isGlobal = 0;
        function = QFUNC(moduleResetMalus);
        icon = QPATHTOF(ui\autoInjector_ca.paa);
    };
    class GVAR(moduleResetMalusGlobal): GVAR(moduleBase) {
        curatorCanAttach = 1;
        displayName = CSTRING(zeus_module_malusGlobal);
        function = "diw_armor_plates_main_bleedOutTimeMalus = nil";
        icon = "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa";
    };
};
