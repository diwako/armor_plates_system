class CfgWeapons {
    class ItemCore;
    class CBA_MiscItem ;
    class CBA_MiscItem_ItemInfo;

    class GVAR(plate): CBA_MiscItem  {
        scope = 2;
        author = "diwako";
        // model = QPATHTOF(data\armor_plate.p3d);
        picture = QPATHTOF(ui\armor_plate_ca.paa);
        // displayName = CSTRING(plateItem);
        displayName = "Ceramic plate 15";
        descriptionShort = CSTRING(plateIteml_Desc_Short);
        descriptionUse = CSTRING(plateIteml_Desc_Use);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 35;
        };
    };
};
