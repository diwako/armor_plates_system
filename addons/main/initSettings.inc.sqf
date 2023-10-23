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
    QGVAR(maxPlateHealth),
    "SLIDER",
    [LLSTRING(maxPlateHealth), LLSTRING(maxPlateHealth_desc)],
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
    QGVAR(armorHandlingMode),
    "LIST",
    [LLSTRING(armorHandlingMode), LLSTRING(armorHandlingMode_desc)],
    _category,
    [["arcade", "realism"], [LLSTRING(armorHandlingMode_arcade), LLSTRING(armorHandlingMode_realism)], 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(plateThickness),
    "SLIDER",
    [LLSTRING(plateThickness), LLSTRING(plateThickness_desc)],
    _category,
    [0, 200, 40, 0],
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
    false,
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

[
    QGVAR(vestBlacklist),
    "EDITBOX",
    [LLSTRING(vestBlacklist), LLSTRING(vestBlacklist_desc)],
    _category,
    "",
    true,
    {   params ["_value"];
        GVAR(vestBlacklist) = ([(_value call CBA_fnc_removeWhitespace), ","] call CBA_fnc_split);
    },
    true
] call CBA_fnc_addSetting;

_category = [_header, LLSTRING(subCategoryFeedback)];

[
    QGVAR(showDamageMarker),
    "CHECKBOX",
    [LLSTRING(showDamageMarker), LLSTRING(showDamageMarker_desc)],
    _category,
    true,
    false
] call CBA_fnc_addSetting;

[
    QGVAR(downedFeedback),
    "LIST",
    [LLSTRING(downedFeedback), LLSTRING(downedFeedback_desc)],
    _category,
    [[0, 1, 2], [LLSTRING(downedFeedback_0), LLSTRING(downedFeedback_1), LLSTRING(downedFeedback_2)], 2],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(audioFeedback),
    "LIST",
    [LLSTRING(audioFeedback), LLSTRING(audioFeedback_desc)],
    _category,
    [[0, 1, 2, 3, 4], [LLSTRING(downedFeedback_0), LLSTRING(audioFeedback_1), LLSTRING(audioFeedback_2), LLSTRING(audioFeedback_3), LLSTRING(audioFeedback_4)], 3],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(showDownedSkull),
    "CHECKBOX",
    [LLSTRING(showDownedSkull), LLSTRING(showDownedSkull_desc)],
    _category,
    true,
    false
] call CBA_fnc_addSetting;

[
    QGVAR(showDownedUnitIndicator),
    "CHECKBOX",
    [LLSTRING(showDownedUnitIndicator), LLSTRING(showDownedUnitIndicator_desc)],
    _category,
    true,
    false, {
        params ["_value"];
        if (time < 1) exitWith {};
        if (_value) then {
            if (GVAR(downedUnitIndicatorDrawEh) < 0) then {
                GVAR(downedUnitIndicatorDrawEh) = addMissionEventHandler ["Draw3D", {
                    call FUNC(drawDownedUnitIndicator);
                }];
            };
        } else {
            if (GVAR(downedUnitIndicatorDrawEh) >= 0) then {
                removeMissionEventHandler ["Draw3D", GVAR(downedUnitIndicatorDrawEh)];
                GVAR(downedUnitIndicatorDrawEh) = -1;
            };
        }
    }
] call CBA_fnc_addSetting;

[
    QGVAR(showDownedUnitIndicatorRange),
    "SLIDER",
    [LLSTRING(showDownedUnitIndicatorRange), LLSTRING(showDownedUnitIndicatorRange_desc)],
    _category,
    [0, 500, 100, 0],
    false,
    {
        params ["_value"];
        GVAR(showDownedUnitIndicatorRange) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(showDownedUnitIndicatorRangeMedic),
    "SLIDER",
    [LLSTRING(showDownedUnitIndicatorRangeMedic), LLSTRING(showDownedUnitIndicatorRangeMedic_desc)],
    _category,
    [0, 500, 100, 0],
    false,
    {
        params ["_value"];
        GVAR(showDownedUnitIndicatorRangeMedic) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(showDownedUnitIndicatorSize),
    "SLIDER",
    [LLSTRING(showDownedUnitIndicatorSize), LLSTRING(showDownedUnitIndicatorSize_desc)],
    _category,
    [0, 10, 2, 2],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(visibleBleedoutTimer),
    "LIST",
    [LLSTRING(visibleBleedoutTimer), LLSTRING(visibleBleedoutTimer_desc)],
    _category,
    [[0, 1, 2], ["str_a3_cfgvehicles_modulesector_f_arguments_taskowner_values_nobody_0", "str_a3_rscdisplaycampaignlobby_mediconly", "str_a3_cfgvehicles_modulesector_f_arguments_taskowner_values_everyone_0"], 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(bleedoutTimerRange),
    "SLIDER",
    [LLSTRING(bleedoutTimerRange), LLSTRING(bleedoutTimerRange_desc)],
    _category,
    [0, 500, 100, 0],
    false,
    {
        params ["_value"];
        GVAR(bleedoutTimerRange) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(bleedoutTimerRangeMedic),
    "SLIDER",
    [LLSTRING(bleedoutTimerRangeMedic), LLSTRING(bleedoutTimerRangeMedic_desc)],
    _category,
    [0, 500, 100, 0],
    false,
    {
        params ["_value"];
        GVAR(bleedoutTimerRangeMedic) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(bleedoutTimerColor),
    "COLOR",
    LLSTRING(bleedoutTimerColor),
    _category,
    [1, 1, 1, 1],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(showGiveUpDialog),
    "CHECKBOX",
    [LLSTRING(showGiveUpDialog), LLSTRING(showGiveUpDialog_desc)],
    _category,
    true,
    false
] call CBA_fnc_addSetting;

[
    QGVAR(showFAKCount),
    "CHECKBOX",
    [LLSTRING(showFAKCount), LLSTRING(showFAKCount_desc)],
    _category,
    true,
    false
] call CBA_fnc_addSetting;

[
    QGVAR(showFAKCountMinimum),
    "SLIDER",
    [LLSTRING(showFAKCountMinimum), LLSTRING(showFAKCountMinimum_desc)],
    _category,
    [0, 10, 3, 0],
    false,
    {
        params ["_value"];
        GVAR(showFAKCountMinimum) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(readyAfterRevive),
    "LIST",
    [LLSTRING(readyAfterRevive), LLSTRING(readyAfterRevive_desc)],
    _category,
    [[0, 1, 2], [LLSTRING(readyAfterRevive_0), LLSTRING(readyAfterRevive_1), LLSTRING(readyAfterRevive_2)], 1],
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
    QGVAR(damageCoef),
    "SLIDER",
    [LLSTRING(damageCoef), LLSTRING(damageCoef_desc)],
    _category,
    [0.01, 100, 50, 2],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(headshotMult),
    "SLIDER",
    [LLSTRING(headshotMult), LLSTRING(headshotMult_desc)],
    _category,
    [0.01, 10, 2, 0, true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(limbMult),
    "SLIDER",
    [LLSTRING(limbMult), LLSTRING(limbMult_desc)],
    _category,
    [0, 10, 0.7, 0, true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(pelvisMult),
    "SLIDER",
    [LLSTRING(pelvisMult), LLSTRING(pelvisMult_desc)],
    _category,
    [0, 10, 0.5, 0, true],
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

[
    QGVAR(allowDownedDamage),
    "LIST",
    [LLSTRING(allowDownedDamage), LLSTRING(allowDownedDamage_desc)],
    _category,
    [[0, 1, 2, 3], [LLSTRING(downedFeedback_0), LLSTRING(allowDownedDamage_1), LLSTRING(allowDownedDamage_2), LLSTRING(allowDownedDamage_3)], 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(downedDamageHP),
    "SLIDER",
    [LLSTRING(downedDamageHP), LLSTRING(downedDamageHP_desc)],
    _category,
    [0.01, 10, 1, 2],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(downedDamageHits),
    "SLIDER",
    [LLSTRING(downedDamageHits), LLSTRING(downedDamageHits_desc)],
    _category,
    [1, 20, 5, 0],
    true,
    {
        params ["_value"];
        GVAR(downedDamageHits) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(damageEhVariant),
    "LIST",
    [LLSTRING(damageEhVariant), LLSTRING(damageEhVariant_desc)],
    _category,
    [[0, 1], ["Hit","HandleDamage"], 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(useHandleDamageFiltering),
    "CHECKBOX",
    [LLSTRING(useHandleDamageFiltering), LLSTRING(useHandleDamageFiltering_desc)],
    _category,
    false,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(enablePlayerUnconscious),
    "CHECKBOX",
    [LLSTRING(enablePlayerUnconscious), LLSTRING(enablePlayerUnconscious_desc)],
    _category,
    true,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(enableAIUnconscious),
    "CHECKBOX",
    [LLSTRING(enableAIUnconscious), LLSTRING(enableAIUnconscious_desc)],
    _category,
    false,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(radioModUnconRestrictions),
    "LIST",
    [LLSTRING(radioModUnconRestrictions), LLSTRING(radioModUnconRestrictions_desc)],
    _category,
    [[0, 1, 2], [LLSTRING(downedFeedback_0), LLSTRING(radioModUnconRestrictions_1), LLSTRING(radioModUnconRestrictions_2)], 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(pilotUncon),
    "LIST",
    [LLSTRING(pilotUncon), LLSTRING(pilotUncon_desc)],
    _category,
    [[0, 1, 2], [LLSTRING(pilotUncon_0), LLSTRING(pilotUncon_1), LLSTRING(pilotUncon_2)], 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(requestAIforHelp),
    "CHECKBOX",
    [LLSTRING(requestAIforHelp), LLSTRING(requestAIforHelp_desc)],
    _category,
    false,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(commEnable),
    "CHECKBOX",
    [LLSTRING(commEnable), LLSTRING(commEnable_desc)],
    _category,
    false,
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(bleedoutTime),
    "SLIDER",
    [LLSTRING(bleedoutTime), LLSTRING(bleedoutTime_desc)],
    _category,
    [0, 15 * 60, 60, 0],
    true,
    {
        params ["_value"];
        GVAR(bleedoutTime) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(bleedoutTimeSubtraction),
    "SLIDER",
    [LLSTRING(bleedoutTimeSubtraction), LLSTRING(bleedoutTimeSubtraction_desc)],
    _category,
    [0, 15 * 60, 10, 0],
    true,
    {
        params ["_value"];
        GVAR(bleedoutTimeSubtraction) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(minBleedoutTime),
    "SLIDER",
    [LLSTRING(minBleedoutTime), LLSTRING(minBleedoutTime_desc)],
    _category,
    [0, 15 * 60, 0, 0],
    true,
    {
        params ["_value"];
        GVAR(minBleedoutTime) = round _value;
    }
] call CBA_fnc_addSetting;

[
    QGVAR(bleedoutStop),
    "LIST",
    [LLSTRING(bleedoutStop), LLSTRING(bleedoutStop_desc)],
    _category,
    [[0, 1, 2, 3], [LLSTRING(downedFeedback_0), LLSTRING(bleedoutStop_1), LLSTRING(bleedoutStop_2), LLSTRING(bleedoutStop_3)], 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(bleedoutRecover),
    "SLIDER",
    [LLSTRING(bleedoutRecover), LLSTRING(bleedoutRecover_desc)],
    _category,
    [0, 12, 4.0, 1],
    true,
    {
        params ["_value"];
        GVAR(bleedoutRecover) = (parseNumber (_value toFixed 1));
    }
] call CBA_fnc_addSetting;

[
    QGVAR(medicReviveTime),
    "SLIDER",
    [LLSTRING(medicReviveTime), LLSTRING(medicReviveTime_desc)],
    _category,
    [1, 60, 8, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(noneMedicReviveTime),
    "SLIDER",
    [LLSTRING(noneMedicReviveTime), LLSTRING(noneMedicReviveTime_desc)],
    _category,
    [1, 60, 16, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(holdActionPriority),
    "LIST",
    [LLSTRING(holdActionPriority), LLSTRING(holdActionPriority_desc)],
    _category,
    [[0, 1], [LLSTRING(holdActionPriority_0), LLSTRING(holdActionPriority_1)], 0],
    false
] call CBA_fnc_addSetting;

[
    QGVAR(holdActionRange),
    "SLIDER",
    [LLSTRING(holdActionRange), LLSTRING(holdActionRange_desc)],
    _category,
    [0, 12, 5.0, 1],
    true,
    {
        params ["_value"];
        GVAR(holdActionRange) = (parseNumber (_value toFixed 1));
    }
] call CBA_fnc_addSetting;

[
    QGVAR(reviveItems),
    "LIST",
    [LLSTRING(reviveItems), LLSTRING(reviveItems_desc)],
    _category,
    [[0, 1, 2], [LLSTRING(reviveItems_0), format ["%1 / %2", localize "STR_A3_cfgWeapons_FirstAidKit0", localize "STR_A3_cfgWeapons_Medikit0"], "STR_A3_cfgWeapons_Medikit0"], 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(healItems),
    "LIST",
    [LLSTRING(healItems), LLSTRING(healItems_desc)],
    _category,
    [[0, 1, 2], [LLSTRING(reviveItems_0), format ["%1 / %2", localize "STR_A3_cfgWeapons_FirstAidKit0", localize "STR_A3_cfgWeapons_Medikit0"], "STR_A3_cfgWeapons_Medikit0"], 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowSelfRevive),
    "CHECKBOX",
    [LLSTRING(allowSelfRevive), LLSTRING(allowSelfRevive_desc)],
    _category,
    false,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowHideHP),
    "CHECKBOX",
    [LLSTRING(allowHideHP), LLSTRING(allowHideHP_desc)],
    _category,
    true,
    false
] call CBA_fnc_addSetting;

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

_category = [_header, LLSTRING(subCategoryHealth)];

[
    QGVAR(maxPlayerHP),
    "SLIDER",
    [LLSTRING(maxPlayerHP), LLSTRING(maxPlayerHP_desc)],
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
    [LLSTRING(maxAiHP), LLSTRING(maxAiHP_desc)],
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
    [LLSTRING(enableHpRegen), LLSTRING(enableHpRegen_desc)],
    _category,
    false,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(enableHpRegenForAI),
    "CHECKBOX",
    [LLSTRING(enableHpRegenForAI), LLSTRING(enableHpRegenForAI_desc)],
    _category,
    false,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(enableHealRegen),
    "LIST",
    [LLSTRING(enableHealRegen), LLSTRING(enableHealRegen_desc)],
    _category,
    [[0, 1, 2], [LLSTRING(downedFeedback_0), LLSTRING(enableHealRegen_1), LLSTRING(enableHealRegen_2)], 0],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(hpRegenRate),
    "SLIDER",
    [LLSTRING(hpRegenRate), LLSTRING(hpRegenRate_desc)],
    _category,
    [0.1, 100, 10, 2],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(hpRegenDelay),
    "SLIDER",
    [LLSTRING(hpRegenDelay), LLSTRING(hpRegenDelay_desc)],
    _category,
    [0.1, 100, 5, 1],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(maxHealRegen),
    "SLIDER",
    [LLSTRING(maxHealRegen), LLSTRING(maxHealRegen_desc)],
    _category,
    [0, 2, 1, 0, true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(maxHealMedic),
    "SLIDER",
    [LLSTRING(maxHealMedic), LLSTRING(maxHealMedic_desc)],
    _category,
    [0, 2, 0.75, 0, true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(maxHealRifleman),
    "SLIDER",
    [LLSTRING(maxHealRifleman), LLSTRING(maxHealRifleman_desc)],
    _category,
    [0, 1, 0.5, 0, true],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(healAtMedic),
    "CHECKBOX",
    [LLSTRING(healAtMedic), LLSTRING(healAtMedic_desc)],
    _category,
    false,
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(allowLimping),
    "CHECKBOX",
    [LLSTRING(allowLimping), LLSTRING(allowLimping_desc)],
    _category,
    false,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(injectorEffect),
    "LIST",
    [LLSTRING(injectorEffect), LLSTRING(injectorEffect_desc)],
    _category,
    [[0, 1, 2, 3], [LLSTRING(downedFeedback_0), LLSTRING(injectorEffect_1), LLSTRING(injectorEffect_2), LLSTRING(injectorEffect_3)], 2],
    true
] call CBA_fnc_addSetting;

[
    QGVAR(injectorCoef),
    "SLIDER",
    [LLSTRING(injectorCoef), LLSTRING(injectorCoef_desc)],
    _category,
    [0.1, 12, 1.0, 1],
    true,
    {
        params ["_value"];
        GVAR(injectorCoef) = (parseNumber (_value toFixed 1));
    }
] call CBA_fnc_addSetting;

[
    QGVAR(injectorConfirm),
    "CHECKBOX",
    [LLSTRING(injectorConfirm), LLSTRING(injectorConfirm_desc)],
    _category,
    false,
    false
] call CBA_fnc_addSetting;
