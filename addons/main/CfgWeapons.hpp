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
            mass = 15;
        };
    };

    class GVAR(plate_30): GVAR(plate) {
        displayName = "Ceramic plate 30";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 30;
        };
    };

    class GVAR(plate_40): GVAR(plate) {
        displayName = "Ceramic plate 40";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 40;
        };
    };

    class GVAR(plate_45): GVAR(plate) {
        displayName = "Ceramic plate 45";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 45;
        };
    };

    class GVAR(plate_50): GVAR(plate) {
        displayName = "Ceramic plate 50";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 50;
        };
    };

    class GVAR(plate_60): GVAR(plate) {
        displayName = "Ceramic plate 60";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 60;
        };
    };

    class GVAR(plate_70): GVAR(plate) {
        displayName = "Ceramic plate 70";
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 70;
        };
    };
};
