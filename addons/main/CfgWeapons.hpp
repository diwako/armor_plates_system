class CfgWeapons {
    class ItemCore;
    class CBA_MiscItem ;
    class CBA_MiscItem_ItemInfo;

    class GVAR(plate): CBA_MiscItem  {
        scope = 2;
        author = "diwako";
        model = QPATHTOF(data\armor_plate.p3d);
        picture = QPATHTOF(ui\armor_plate_ca.paa);
        displayName = CSTRING(plateItem);
        descriptionShort = CSTRING(plateIteml_Desc_Short);
        descriptionUse = CSTRING(plateIteml_Desc_Use);
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = PLATE_MASS;
        };
    };

    class GVAR(autoInjector): GVAR(plate)  {
        author = "alien314, KrazyKat";
        model = "a3\Props_F_Orange\Humanitarian\Garbage\MedicalGarbage_01_Injector_F"; // model = QPATHTOF(data\autoInjector.p3d);
        picture = QPATHTOF(ui\autoInjector_ca.paa);
        displayName = CSTRING(autoinjectorItem);
        descriptionShort = CSTRING(autoinjectorIteml_Desc_Short);
        descriptionUse = CSTRING(autoinjectorIteml_Desc_Use);
        GVAR(isInjector) = 1;
        //magazines[]={QGVAR(autoInjectorMag)};
        class ItemInfo: CBA_MiscItem_ItemInfo {
            mass = 7;
        };
    };
};
