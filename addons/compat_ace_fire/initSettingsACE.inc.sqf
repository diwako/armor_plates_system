private _header = LELSTRING(main,category);
private _category = [_header, LLSTRING(subCategoryCompat)];

[
    QGVAR(ignoreArmorACE), "CHECKBOX",
    [LLSTRING(ignoreArmor), LLSTRING(ignoreArmor_desc)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;