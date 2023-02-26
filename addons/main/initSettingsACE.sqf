private _header = LLSTRING(category);
private _category = [_header, LLSTRING(subCategoryArmorPlates)];

[
    QGVAR(numWearablePlates),
    "SLIDER",
    [LLSTRING(numWearablePlates), LLSTRING(numWearablePlates_desc)],
    _category,
    [0, 10, 3, 0],
    true,
    {
        params ["_value"];
        GVAR(numWearablePlates) = round _value;
        if (time < 1) exitWith {};
        {
            ctrlDelete (_x select 0);
            ctrlDelete (_x select 1);
        } forEach (uiNamespace getVariable [QGVAR(plateControls), []]);
        uiNamespace setVariable [QGVAR(plateControls), []];
        [] call FUNC(initPlates);
    }
] call CBA_fnc_addSetting;

[
    QGVAR(armorHandlingMode),
    "LIST",
    [LLSTRING(armorHandlingMode), LLSTRING(armorHandlingMode_desc)],
    _category,
    [["arcade", "realism"], [LLSTRING(armorHandlingMode_arcade), LLSTRING(armorHandlingMode_realism)], 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(plateThickness),
    "SLIDER",
    [LLSTRING(plateThickness), LLSTRING(plateThickness_desc)],
    _category,
    [0, 200, 25, 0],
    true,
    {
        params ["_value"];
        GVAR(plateThickness) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(protectOnlyTorso),
    "CHECKBOX",
    [LLSTRING(protectOnlyTorso), LLSTRING(protectOnlyTorso_desc)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(maxPlateHealth),
    "SLIDER",
    [LLSTRING(maxPlateHealth), LLSTRING(maxPlateHealth_desc)],
    _category,
    [1, 50, 15, 0],
    true,
    {
        params ["_value"];
        GVAR(maxPlateHealth) = round _value;
        if (time < 1) exitWith {};
        {
            private _vest = vestContainer _x;
            if (isNull _vest) then {continue};
            private _plates = _vest getVariable [QGVAR(plates), []];
            {
                if (_x > GVAR(maxPlateHealth)) then {
                    _plates set [_forEachIndex, GVAR(maxPlateHealth)];
                };
            } forEach _plates;
        } forEach allUnits;
        if (hasInterface) then {
            [player] call FUNC(updatePlateUi);
        };
    }
] call CBA_fnc_addSetting;

[
    QGVAR(timeToAddPlate),
    "SLIDER",
    [LLSTRING(timeToAddPlate), LLSTRING(timeToAddPlate_desc)],
    _category,
    [0, 30, 8, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowPlateReplace),
    "CHECKBOX",
    [LLSTRING(allowPlateReplace), LLSTRING(allowPlateReplace_desc)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(spawnWithFullPlates),
    "CHECKBOX",
    [LLSTRING(spawnWithFullPlates), LLSTRING(spawnWithFullPlates_desc)],
    _category,
    false,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(AIchancePlateInVest),
    "SLIDER",
    [LLSTRING(AIchancePlateInVest), LLSTRING(AIchancePlateInVest_desc)],
    _category,
    [0, 1, 0.4, 0, true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(AIchancePlateInVestMaxNo),
    "SLIDER",
    [LLSTRING(AIchancePlateInVestMaxNo), LLSTRING(AIchancePlateInVestMaxNo_desc)],
    _category,
    [0, 10, 0, 0],
    true,
    {
        params ["_value"];
        GVAR(AIchancePlateInVestMaxNo) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(AIchancePlateInInventory),
    "SLIDER",
    [LLSTRING(AIchancePlateInInventory), LLSTRING(AIchancePlateInInventory_desc)],
    _category,
    [0, 1, 0.2, 0, true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(AIchancePlateInInventoryMaxNo),
    "SLIDER",
    [LLSTRING(AIchancePlateInInventoryMaxNo), LLSTRING(AIchancePlateInInventoryMaxNo_desc)],
    _category,
    [0, 10, 0, 0],
    true,
    {
        params ["_value"];
        GVAR(AIchancePlateInInventoryMaxNo) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(plateColor),
    "COLOR",
    LLSTRING(plateColor),
    _category,
    [0.35, 0.35, 1, 0.8],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(headBobStrength),
    "LIST",
    [LLSTRING(headBobStrength), LLSTRING(headBobStrength_desc)],
    _category,
    [[0, 1, 2], [LLSTRING(headBobStrength_0), LLSTRING(headBobStrength_1), LLSTRING(headBobStrength_2)], 1],
    false
] call CBA_fnc_addSetting;

_category = [_header, LLSTRING(subCategoryFeedback)];

[
    QGVAR(showDamageMarker),
    "CHECKBOX",
    [LLSTRING(showDamageMarker), LLSTRING(showDamageMarker_desc)],
    _category,
    false,
    false
] call CBA_fnc_addSetting;

[
    QGVAR(audioFeedback),
    "LIST",
    [LLSTRING(audioFeedback), LLSTRING(audioFeedback_desc)],
    _category,
    [[0, 1, 2, 3, 4], [LLSTRING(downedFeedback_0), LLSTRING(audioFeedback_1), LLSTRING(audioFeedback_2), LLSTRING(audioFeedback_3), LLSTRING(audioFeedback_4)], 0],
    false
] call CBA_fnc_addSetting;

_category = [_header, LLSTRING(subCategoryGeneral)];

[
    QGVAR(enable),
    "CHECKBOX",
    [LLSTRING(enable), LLSTRING(enable_desc)],
    _category,
    true,
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(disallowFriendfire),
    "CHECKBOX",
    [LLSTRING(disallowFriendfire), LLSTRING(disallowFriendfire_desc)],
    _category,
    false,
    true
] call CBA_fnc_addSetting;

GVAR(allowHideHP) = true;

[
    QGVAR(allowHideArmor),
    "CHECKBOX",
    [LLSTRING(allowHideArmor), LLSTRING(allowHideArmor_desc)],
    _category,
    true,
    false
] call CBA_fnc_addSetting;

[
    QGVAR(hideUiSeconds),
    "SLIDER",
    [LLSTRING(hideUiSeconds), LLSTRING(hideUiSeconds_desc)],
    _category,
    [1, 600, 5, 1],
    false
] call CBA_fnc_addSetting;
