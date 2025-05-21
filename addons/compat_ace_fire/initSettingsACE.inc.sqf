private _header = LELSTRING(main,category);
private _category = [_header, LELSTRING(main,subCategoryCompat)];

[
    QEGVAR(main,ignoreArmorburn), "CHECKBOX",
    [LLSTRING(ignoreArmor), LLSTRING(ignoreArmor_desc)],
    _category,
    false,
    true
] call CBA_fnc_addSetting;