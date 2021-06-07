private _header = LLSTRING(category);
private _category = [_header, LLSTRING(subCategoryArmorPlates)];
private _aceMedicalLoaded = isClass(configFile >> "CfgPatches" >> "ace_medical_engine");

[
    QGVAR(numWearablePlates),
    "SLIDER",
    ["Amount of plates wearable", "How many plates can you fit into your vest to give you protection"],
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
    QGVAR(maxPlateHealth),
    "SLIDER",
    ["Armor Plate HP", "Max HP of an armor plate"],
    _category,
    [1, 200, 25, 0],
    true,
    {
        params ["_value"];
        GVAR(maxPlateHealth) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(timeToAddPlate),
    "SLIDER",
    ["Time to add one plate", "How long does it take to add one plate to the vest in seconds"],
    _category,
    [0, 30, 8, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowPlateReplace),
    "CHECKBOX",
    ["Allow replacing damaged plate", "Allows people to replace damaged plates, the damaged plate will be discarded"],
    _category,
    true,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(spawnWithFullPlates),
    "CHECKBOX",
    ["Players spawn with full plates", "When spawning or respawning you will start with maximum amount of plates already preloaded into your vest."],
    _category,
    false,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(AIchancePlateInVest),
    "SLIDER",
    ["Chance for AI to carry plates in vests", "Chance in % if AI can have plates in their vest"],
    _category,
    [0, 1, 0.4, 0, true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(AIchancePlateInVestMaxNo),
    "SLIDER",
    ["Amount added to vest", "0 == random up to max allowed carry capacity, any other number is the amount that will be added to any AI that is selected to carry plates in their vest. Any number above the allowed carry capacity will be reduced to max carry capacity"],
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
    ["Chance for AI to carry plates in inventory", "Chance in % if AI can have plates in their inventory. These plates can be looted!"],
    _category,
    [0, 1, 0.2, 0, true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(AIchancePlateInInventoryMaxNo),
    "SLIDER",
    ["Amount added to inventory", "0 == random up to max allowed carry carry capacity, any other number is the amount that will be added to any AI that is selected to carry plates in their inventory."],
    _category,
    [0, 10, 0, 0],
    true,
    {
        params ["_value"];
        GVAR(AIchancePlateInInventoryMaxNo) = round _value;
    }
] call CBA_fnc_addSetting;

_category = [_header, LLSTRING(subCategoryFeedback)];

[
    QGVAR(showDamageMarker),
    "CHECKBOX",
    ["Show damage markers", "Shows damage marker and direction of inconing damage"],
    _category,
    true,
    false
] call CBA_fnc_addSetting;

[
    QGVAR(downedFeedback),
    "LIST",
    ["Use downed feedback", "Shows text in chat and plays a sound when a friendly unit that is in your squad gets downed."],
    _category,
    [[0, 1, 2], ["Off", "Show message", "Message and Sound"], 2],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(audioFeedback),
    "LIST",
    ["Audio feedback", "Plays audio clip when taking damage, receiving a headshot or an armor plate just broke."],
    _category,
    [[0, 1, 2, 3, 4], ["Off", "150% Volume", "125% Volume", "100% Volume", "75% Volume"], 3],
    true
] call CBA_fnc_addSetting;

_category = [_header, LLSTRING(subCategoryGeneral)];

[
    QGVAR(enable),
    "CHECKBOX",
    ["Enable the whole system", "Enables the system, disable if you want to play a mission with its own medical system. CANNOT BE TOGGLED OFF OR ON DURING THE MISSION!"],
    _category,
    true,
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(damageCoef),
    "SLIDER",
    ["Damage coefficient", "Coefficient which manipulates the incoming damage"],
    _category,
    [0.01, 100, [50, 5] select _aceMedicalLoaded, 2],
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
    QGVAR(disallowFriendfire),
    "CHECKBOX",
    ["Disallow friendly fire", "Do not allow friendly from weapon fire"],
    _category,
    false,
    true
] call CBA_fnc_addSetting;

if (_aceMedicalLoaded) exitWith {};

[
    QGVAR(damageEhVariant),
    "LIST",
    ["Damage EH", "Which damage EH should be used, do mind that only HandleDamage can do multipliers to body parts!"],
    _category,
    [[0, 1], ["Hit","HandleDamage"], 1],
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
    QGVAR(bleedoutTime),
    "SLIDER",
    ["Bleed out timer", "Time in seconds how long someone can lie on the floor bleeding. 0 means it is disabled!"],
    _category,
    [0, 15 * 60, 60, 0],
    true,
    {
        params ["_value"];
        GVAR(bleedoutTime) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(medicReviveTime),
    "SLIDER",
    ["Medic revive time", "How long does it take to revive someone as a medic in seconds"],
    _category,
    [1, 60, 8, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(noneMedicReviveTime),
    "SLIDER",
    ["None-medic revive time", "How long does it take to revive someone as not a medic in seconds"],
    _category,
    [1, 60, 16, 1],
    true
] call CBA_fnc_addSetting;

_category = [_header, LLSTRING(subCategoryHealth)];

[
    QGVAR(maxPlayerHP),
    "SLIDER",
    ["Max Player HP", "How much HP does a player have"],
    _category,
    [1, 1000, 100, 0],
    true,
    {
        params ["_value"];
        GVAR(maxPlayerHP) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(maxAiHP),
    "SLIDER",
    ["Max AI HP", "How much HP does an AI have"],
    _category,
    [1, 1000, 100, 0],
    true,
    {
        params ["_value"];
        GVAR(maxAiHP) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(enableHpRegen),
    "CHECKBOX",
    ["Enable HP regen", "Start hp regeneration after 5 seconds"],
    _category,
    false,
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
    [1, 100, 10, 2],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(maxHealMedic),
    "SLIDER",
    ["Max heal % for medics", "How percentage of max health can a medic heal?"],
    _category,
    [0, 2, 0.75, 0, true],
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
