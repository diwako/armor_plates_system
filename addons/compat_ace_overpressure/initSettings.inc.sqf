private _header = LELSTRING(main,category);
private _category = [_header, LLSTRING(subCategoryCompat)];

[
    QGVAR(bbdmgCoef), "SLIDER",
    [LLSTRING(bbdmgCoef), LLSTRING(bbdmgCoef_desc)],
    _category,
    [0, 10, 2.0, 2, false],
    true,
    {[QGVAR(bbdmgCoef), _this, true] call ace_common_fnc_cbaSettings_settingChanged}
] call CBA_fnc_addSetting;

[
    QGVAR(ignoreArmor), "CHECKBOX",
    [LLSTRING(ignoreArmor), LLSTRING(ignoreArmor_desc)],
    _category,
    false,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(finishDowns), "CHECKBOX",
    [LLSTRING(finishDowns), LLSTRING(finishDowns_desc)],
    _category,
    false,
    true
] call CBA_fnc_addSetting;