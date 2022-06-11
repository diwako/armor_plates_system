class CfgWeapons {
    class ItemCore;
    class CBA_MiscItem ;
    class CBA_MiscItem_ItemInfo;

    class GVAR(plate): CBA_MiscItem  {
        scope = 2;
        author = "diwako";
        // model = QPATHTOF(data\armor_plate.p3d);
        picture = QPATHTOF(ui\armor_plate_ca.paa);
        displayName = CSTRING(plateItem);
        descriptionShort = CSTRING(plateIteml_Desc_Short);
        descriptionUse = CSTRING(plateIteml_Desc_Use);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = PLATE_MASS;
        };
    };

    class GVAR(autoInjector): GVAR(plate)  {
        author = "diwako, alien314";
        model = "a3\Props_F_Orange\Humanitarian\Garbage\MedicalGarbage_01_Injector_F"; // model = QPATHTOF(data\autoInjector.p3d);
        picture = "\A3\EditorPreviews_F_Orange\Data\CfgVehicles\MedicalGarbage_01_Injector_F.jpg"; //QPATHTOF(ui\autoInjector_ca.paa)
        displayName = CSTRING(autoinjectorItem);
        descriptionShort = CSTRING(autoinjectorIteml_Desc_Short);
        descriptionUse = CSTRING(autoinjectorIteml_Desc_Use);
        GVAR(usesRemaining) = 20;
    };
    class GVAR(autoInjector)_1: GVAR(autoInjector)  {
		scopeArsenal = 0;
        ace_arsenal_hide = 1;
        ace_arsenal_uniqueBase = QGVAR(autoInjector);
        descriptionShort = CSTRING(autoinjectorItemUsed_Desc_Short_1);
        GVAR(usesRemaining) = 1;
    };
    class GVAR(autoInjector)_2: GVAR(autoInjector)_1  {
        descriptionShort = CSTRING(autoinjectorItemUsed_Desc_Short_2);
        GVAR(usesRemaining) = 2;
    };
    class GVAR(autoInjector)_3: GVAR(autoInjector)_1  {
        descriptionShort = CSTRING(autoinjectorItemUsed_Desc_Short_3);
        GVAR(usesRemaining) = 3;
    };
    class GVAR(autoInjector)_4: GVAR(autoInjector)_1  {
        descriptionShort = CSTRING(autoinjectorItemUsed_Desc_Short_4);
        GVAR(usesRemaining) = 4;
    };
    class GVAR(autoInjector)_5: GVAR(autoInjector)_1  {
        descriptionShort = CSTRING(autoinjectorItemUsed_Desc_Short_5);
        GVAR(usesRemaining) = 5;
    };
    class GVAR(autoInjector)_6: GVAR(autoInjector)_1  {
        descriptionShort = CSTRING(autoinjectorItemUsed_Desc_Short_6);
        GVAR(usesRemaining) = 6;
    };
    class GVAR(autoInjector)_7: GVAR(autoInjector)_1  {
        descriptionShort = CSTRING(autoinjectorItemUsed_Desc_Short_7);
        GVAR(usesRemaining) = 7;
    };
    class GVAR(autoInjector)_8: GVAR(autoInjector)_1  {
        descriptionShort = CSTRING(autoinjectorItemUsed_Desc_Short_8);
        GVAR(usesRemaining) = 8;
    };
    class GVAR(autoInjector)_9: GVAR(autoInjector)_1  {
        descriptionShort = CSTRING(autoinjectorItemUsed_Desc_Short_9);
        GVAR(usesRemaining) = 9;
    };
    class GVAR(autoInjector)_10: GVAR(autoInjector)_1  {
        descriptionShort = CSTRING(autoinjectorItemUsed_Desc_Short_10);
        GVAR(usesRemaining) = 10;
    };
    class GVAR(autoInjector)_11: GVAR(autoInjector)_1  {
        descriptionShort = CSTRING(autoinjectorItemUsed_Desc_Short_11);
        GVAR(usesRemaining) = 11;
    };
    class GVAR(autoInjector)_12: GVAR(autoInjector)_1  {
        descriptionShort = CSTRING(autoinjectorItemUsed_Desc_Short_13);
        GVAR(usesRemaining) = 12;
    };
    class GVAR(autoInjector)_13: GVAR(autoInjector)_1  {
        descriptionShort = CSTRING(autoinjectorItemUsed_Desc_Short_13);
        GVAR(usesRemaining) = 13;
    };
    class GVAR(autoInjector)_14: GVAR(autoInjector)_1  {
        descriptionShort = CSTRING(autoinjectorItemUsed_Desc_Short_14);
        GVAR(usesRemaining) = 14;
    };
    class GVAR(autoInjector)_15: GVAR(autoInjector)_1  {
        descriptionShort = CSTRING(autoinjectorItemUsed_Desc_Short_15);
        GVAR(usesRemaining) = 15;
    };
    class GVAR(autoInjector)_16: GVAR(autoInjector)_1  {
        descriptionShort = CSTRING(autoinjectorItemUsed_Desc_Short_16);
        GVAR(usesRemaining) = 16;
    };
    class GVAR(autoInjector)_17: GVAR(autoInjector)_1  {
        descriptionShort = CSTRING(autoinjectorItemUsed_Desc_Short_17);
        GVAR(usesRemaining) = 17;
    };
    class GVAR(autoInjector)_18: GVAR(autoInjector)_1  {
        descriptionShort = CSTRING(autoinjectorItemUsed_Desc_Short_18);
        GVAR(usesRemaining) = 18;
    };
    class GVAR(autoInjector)_19: GVAR(autoInjector)_1  {
        descriptionShort = CSTRING(autoinjectorItemUsed_Desc_Short_19);
        GVAR(usesRemaining) = 19;
    };
};
