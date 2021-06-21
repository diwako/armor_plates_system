
class CBA_Extended_EventHandlers;
class CfgVehicles {
    // Treatment items
    class Item_Base_F;
    class GVAR(plateItem): Item_Base_F {
        scope = 2;
        scopeCurator = 2;
        displayName = "Armor Plate";
        author = "diawko";
        vehicleClass = "Items";
        class TransportItems {
            MACRO_ADDITEM(plate,1);
        };
    };
};
