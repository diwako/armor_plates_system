private _header = LELSTRING(main,category);
private _category = [_header, LELSTRING(main,subCategoryCompat)];

[
    QGVAR(preventScriptedDeath), "CHECKBOX",
    [LLSTRING(preventScriptedDeath), LLSTRING(preventScriptedDeath_desc)],
    _category,
    !EGVAR(main,aceMedicalLoaded),
    true
] call CBA_fnc_addSetting;