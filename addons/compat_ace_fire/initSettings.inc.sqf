private _header = LELSTRING(main,category);
private _category = [_header, LLSTRING(subCategoryCompat)];

[
    QGVAR(ignoreArmor), "CHECKBOX",
    [LLSTRING(ignoreArmor), LLSTRING(ignoreArmor_desc)],
    _category,
    false,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(fireMult), "SLIDER",
    [LLSTRING(nonMedBurnMult), LLSTRING(nonMedBurnMult_desc)],
    _category,
    [0, 10, 0.2, 2, false],
    true,
    {[QGVAR(fireMult), _this, true] call ace_common_fnc_cbaSettings_settingChanged}
] call CBA_fnc_addSetting;