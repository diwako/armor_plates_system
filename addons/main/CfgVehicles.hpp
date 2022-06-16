
class CBA_Extended_EventHandlers;
class CfgVehicles {
    // Treatment items
    class Item_Base_F;
    class GVAR(plateItem): Item_Base_F {
        scope = 2;
        scopeCurator = 2;
        displayName = "Armor Plate";
        author = "diwako";
        vehicleClass = "Items";
        class TransportItems {
            MACRO_ADDITEM(plate,1);
        };
    };

    class GVAR(autoInjectorItem): GVAR(plateItem) {
        editorPreview = "\A3\EditorPreviews_F_Orange\Data\CfgVehicles\MedicalGarbage_01_Injector_F.jpg";
        displayName = "Auto-Injector";
        author = "alien314";
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
};
