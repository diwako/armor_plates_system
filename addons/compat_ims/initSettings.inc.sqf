private _header = LELSTRING(main,category);
private _category = [_header, LELSTRING(main,subCategoryCompat)];

[
    QGVAR(ignoreArmor), "CHECKBOX",
    [LLSTRING(ignoreArmor), LLSTRING(ignoreArmor_desc)],
    _category,
    false,
    true
] call CBA_fnc_addSetting;
