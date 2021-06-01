private _header = "Armor Plate System";
private _category = [_header, "Armor Plates"];

[
    QGVAR(numWearablePlates),
    "SLIDER",
    ["Amount of plates wearable", "How many plates can you fit into your vest to give you protection"],
    _category,
    [0, 5, 3, 0],
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
    QGVAR(maxPlateHealth),
    "SLIDER",
    ["Armor Plate HP", "Max HP of an armor plate"],
    _category,
    [1, 200, 50, 0],
    true,
    {
        params ["_value"];
        GVAR(maxPlateHealth) = round _value;
    }
] call CBA_fnc_addSetting;

_category = [_header, "Health"];

[
    QGVAR(maxUnitHP),
    "SLIDER",
    ["Max Unit HP", "How much HP does a unit have"],
    _category,
    [1, 500, 100, 0],
    true,
    {
        params ["_value"];
        GVAR(maxUnitHP) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(enableHpRegen),
    "CHECKBOX",
    ["Enable HP regen", "Start hp regeneration after 5 seconds"],
    _category,
    true,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(enableHpRegenForAI),
    "CHECKBOX",
    ["Enable HP regen for AI", "Allows AI to regen hp"],
    _category,
    false,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(hpRegenRate),
    "SLIDER",
    ["HP regen rate", "How fast do my eyes stop bleeding?"],
    _category,
    [1, 100, 15, 2],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(maxHealMedic),
    "SLIDER",
    ["Max heal % for medics", "How percentage of max health can a medic heal?"],
    _category,
    [0, 2, 1, 0, true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(maxHealRifleman),
    "SLIDER",
    ["Max heal % for non-medics", "How percentage of max health can a medic heal?"],
    _category,
    [0, 1, 0.5, 0, true],
    true
] call CBA_fnc_addSetting;


_category = [_header, "General"];

[
    QGVAR(damageEhVariant),
    "LIST",
    ["Damage EH", "Which damage EH should be used, do mind that only HandleDamage can do multipliers to body parts!"],
    _category,
    [[0, 1], ["Hit","HandleDamage"], 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(damageCoef),
    "SLIDER",
    ["Damage coefficient", "Coefficient which manipulates the incoming damage"],
    _category,
    [0.01, 100, 50, 2],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(headshotMult),
    "SLIDER",
    ["Headshot Multiplier", "Damage multiplier on headshot"],
    _category,
    [0.01, 10, 2, 0, true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(limbMult),
    "SLIDER",
    ["Limb Multiplier", "Damage multiplier on limb shots"],
    _category,
    [0, 10, 0.7, 0, true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(enablePlayerUnconscious),
    "CHECKBOX",
    ["Enable player unconsciousness", "Start hp regeneration after 5 seconds"],
    _category,
    true,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(medicReviveTime),
    "SLIDER",
    ["Medic revive time", "How long does it take to revive someone as a medic in seconds"],
    _category,
    [1, 60, 5, 1],
    true
] call CBA_fnc_addSetting;
[
    QGVAR(noneMedicReviveTime),
    "SLIDER",
    ["None-medic revive time", "How long does it take to revive someone as not a medic in seconds"],
    _category,
    [1, 60, 10, 1],
    true
] call CBA_fnc_addSetting;
