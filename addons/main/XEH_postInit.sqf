#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

if (is3DEN) exitWith {};

if (hasInterface) then {
    {
        ctrlDelete (_x select 0);
        ctrlDelete (_x select 1);
    } forEach (uiNamespace getVariable [QGVAR(plateControls), []]);
    uiNamespace setVariable [QGVAR(plateControls), []];

    {
        ctrlDelete _x;
    } forEach (uiNamespace getVariable [QGVAR(plateProgressBar), []]);
    ctrlDelete (uiNamespace getVariable [QGVAR(mainControl), controlNull]);
    ctrlDelete (uiNamespace getVariable [QGVAR(hpControl), controlNull]);

    {
        ctrlDelete _x;
    } forEach (uiNamespace getVariable [QGVAR(feedBackCtrl), []]);
    uiNamespace setVariable [QGVAR(feedBackCtrl), []];

    {
        ctrlDelete _x;
    } forEach (uiNamespace getVariable [QGVAR(skullControls), []]);
    uiNamespace setVariable [QGVAR(skullControls), []];
};

if (isClass(configFile >> "CfgPatches" >> "ace_medical") && {!GVAR(aceMedicalLoaded)}) exitWith {
    INFO("PostInit: Disabled --> old ACE medical loaded");
};
if (!GVAR(enable)) exitWith {
    INFO("Disabled --> CBA settings");
};

GVAR(ammoPenCache) = createHashMap;

["CAManBase", "Local", {
    params ["_unit", "_isLocal"];
    if (_isLocal || {!alive _unit || {GVAR(numWearablePlates) isEqualTo 0 || {isNull (vestContainer _unit)}}}) exitWith {};
    private _plateHp = ((vestContainer _unit) getVariable [QGVAR(plates), nil]);
    if !(isNil "_plateHp") then {
        [QGVAR(plateSync), [_unit,_plateHp], _unit] call CBA_fnc_targetEvent;
    };
}, true, [], true] call CBA_fnc_addClassEventHandler;

[QGVAR(plateSync), {
    params ["_unit", "_plateHp"];
    (vestContainer _unit) setVariable [QGVAR(plates),_plateHp];
}] call CBA_fnc_addEventHandlerArgs;

if (GVAR(aceMedicalLoaded)) then {
    // ace medical
    ["CAManBase", "InitPost", {
        params ["_unit"];
        _unit setVariable ["ace_medical_engine_$#structural", [0, 0]];
        private _id = _unit addEventHandler ["HandleDamage", {
            _this call FUNC(handleDamageEhACE);
        }];
        _unit setVariable ["aps_HandleDamageEHID", _id];
        [_unit] call FUNC(initAIUnit);
    }, true, [], true] call CBA_fnc_addClassEventHandler;
} else {
    // vanilla arma
    ["CAManBase", "Hit", {
        _this call FUNC(hitEh);
    }, true, [], true] call CBA_fnc_addClassEventHandler;

    ["CAManBase", "InitPost", {
        params ["_unit"];

        // prevent re adding of handle damage eh for players
        if (_unit getVariable [QGVAR(HandleDamageEHID), -1] isEqualTo -1) then {
            private _id = _unit addEventHandler ["HandleDamage", {
                _this call FUNC(handleDamageEh);
            }];
            _unit setVariable [QGVAR(HandleDamageEHID), _id];
        };

        _unit addEventHandler ["HandleHeal", {
            [{
                params ["_unit", "_healer"];
                _unit setDamage 0;
                [_unit, _healer, true] call FUNC(handleHealEh);
            }, _this, 5] call CBA_fnc_waitAndExecute;
            false
        }];

        [_unit] call FUNC(addActionsToUnit);
        [_unit] call FUNC(initAIUnit);
    }, true, [], true] call CBA_fnc_addClassEventHandler;

    [QGVAR(heal), {
        (_this select 0) setDamage 0;
        _this call FUNC(handleHealEh);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(consumeFAK), {
        params ["_unit"];
        if (([_unit] call FUNC(hasHealItems)) isEqualTo 1) then {
            _unit removeItem (_unit getVariable [QGVAR(availableFirstAidKit), ""]);
            if (GVAR(showFAKCount) && {_unit isEqualTo (call CBA_fnc_currentUnit)}) then {
                // check how many faks are left
                private _count = 0;
                private _fnc_count = {
                    params ["_items", "_amounts"];
                    {
                        if (_x in GVAR(firstAidKitItems)) then {
                            _count = _count + (_amounts select _forEachIndex);
                        };
                    } forEach _items;
                };
                (getItemCargo uniformContainer _unit) call _fnc_count;
                (getItemCargo vestContainer _unit) call _fnc_count;
                (getItemCargo backpackContainer _unit) call _fnc_count;
                if (_count <= GVAR(showFAKCountMinimum)) then {
                    [
                        [getText (configFile >> "CfgWeapons" >> (_unit getVariable [QGVAR(availableFirstAidKit), ""]) >> "picture"), 4],
                        [format [LLSTRING(showFAKCount_hint1), getText (configFile >> "CfgWeapons" >> (_unit getVariable [QGVAR(availableFirstAidKit), ""]) >> "displayName")]],
                        [format [LLSTRING(showFAKCount_hint2), _count]],
                    true] call CBA_fnc_notify;
                };
            };
            _unit setVariable [QGVAR(availableFirstAidKit), nil];
        };
    }] call CBA_fnc_addEventHandler;

    [QGVAR(reduceMalus), {
        _this call FUNC(reduceMalus);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(consumeInjectorUse), {
        params ["_unit"];
        if ([_unit] call FUNC(hasInjector)) then {
            private _uses = 0;
            _unit removeItem (_unit getVariable [QGVAR(availableInjector), ""]);
            private _fnc_count = {
                params ["_items", "_amounts"];
                {
                    if (_x in GVAR(injectorItems)) then {
                        _uses = _uses + (_amounts select _forEachIndex);
                    };
                } forEach _items;
            };
            (getItemCargo uniformContainer _unit) call _fnc_count;
            (getItemCargo vestContainer _unit) call _fnc_count;
            (getItemCargo backpackContainer _unit) call _fnc_count;
            if (_unit isEqualTo (call CBA_fnc_currentUnit)) then {
                [
                    [getText (configFile >> "CfgWeapons" >> (_unit getVariable [QGVAR(availableInjector), ""]) >> "picture"), 4],
                    [format [LLSTRING(showFAKCount_hint1), getText (configFile >> "CfgWeapons" >> (_unit getVariable [QGVAR(availableInjector), ""]) >> "displayName")]],
                    [format [LLSTRING(showFAKCount_hint2), _uses]],
                true] call CBA_fnc_notify;
            };
            private _usedUp = "MedicalGarbage_01_Injector_F" createVehicle (getPosATL _unit);
            _usedUp setDir (random 360);
            _usedUp enableSimulationGlobal false;
            _unit setVariable [QGVAR(availableInjector), nil];
        };
    }] call CBA_fnc_addEventHandler;

    [QGVAR(revive), {
        _this call FUNC(revive);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(respawned), {
        if !(hasInterface) exitWith {};
        params ["_unit"];
        [_unit] call FUNC(addActionsToUnit);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(switchMove), {
        params ["_unit", "_anim", ["_weaponReady", true]];
        _unit switchMove _anim;
        _unit playMoveNow _anim; // clear playMove queue
        if (_weaponReady) then {
            _unit action ["WeaponInHand", _unit];
        };
    }] call CBA_fnc_addEventHandler;

    [QGVAR(wokeUpCheck), {
        // check if someone is stuck in a downed animation
        params ["_unit"];
        if (!alive _unit) exitWith {};
        private _animation = animationState _unit;
        if ((_animation == "unconscious" || {_animation == "deadstate" || {_animation find "unconscious" != -1}}) && {lifeState _unit != "INCAPACITATED"}) then {
            [QGVAR(switchMove), [_unit, "AmovPpneMstpSnonWnonDnon", false]] call CBA_fnc_globalEvent;
        };
    }] call CBA_fnc_addEventHandler;

    [QGVAR(setHidden), {
        params ["_object", "_set"];

        private _vis = [_object getUnitTrait "camouflageCoef"] param [0, 1];
        if (_set) then {
            if (_vis != 0) then {
                _object setVariable [QGVAR(oldVisibility), _vis];
                _object setUnitTrait ["camouflageCoef", 0];
                {
                    if (side _x != side group _object) then {
                        _x forgetTarget _object;
                    };
                } forEach allGroups;
            };
        } else {
            _vis = _object getVariable [QGVAR(oldVisibility), _vis];
            _object setUnitTrait ["camouflageCoef", _vis];
        };
    }] call CBA_fnc_addEventHandler;

    [QGVAR(bleedRecovery), {
        params ["_unit"];
        if !(_unit getVariable [QGVAR(holdLimiter), false]) then {
            _unit setVariable [QGVAR(holdLimiter), true, true];
            [{
                params ["_unit"];
                if !(_unit getVariable [QGVAR(unconscious), false]) exitWith {
                    _unit setVariable [QGVAR(holdLimiter), nil, true];
                };
                if (_unit getVariable [QGVAR(isHold), false]  || {GVAR(bleedoutStop) > 1 && {_unit getVariable [QGVAR(beingRevived), false]}}) then {
                    private _recovered = ((_unit getVariable [QGVAR(bleedoutKillTime), -1]) + GVAR(bleedoutRecover));
                    _unit setVariable [QGVAR(bleedoutKillTime), _recovered, true];
                };
                _unit setVariable [QGVAR(holdLimiter), false, true];
            }, _unit, 3] call CBA_fnc_waitAndExecute;
        };
    }] call CBA_fnc_addEventHandler;

    [QGVAR(resetMalus), {
        if (!alive player) exitWith {};
        GVAR(bleedOutTimeMalus) = nil;
        if (player getVariable [QGVAR(unconscious), false]) then {
            player setVariable [QGVAR(bleedoutKillTime),(cba_missionTime + (GVAR(bleedoutTime) - 0)), true];
        };
    }] call CBA_fnc_addEventHandler;

    addMissionEventHandler ["ControlsShifted", {
        params ["", "", "_vehicle", "_copilotEnabled", "_controlsUnlocked"];
        if (_copilotEnabled) then {
            if !(_controlsUnlocked) exitWith {_vehicle setVariable [QGVAR(controlsUnlocked),nil];};
            _vehicle setVariable [QGVAR(controlsUnlocked),true];
        };
    }];
};

[QGVAR(healUnit), {
    params ["_unit"];
    if (GVAR(aceMedicalLoaded)) then {
        ["ace_medical_treatment_fullHealLocal", [_unit]] call CBA_fnc_localEvent;
    } else {
        if !(_unit getUnitTrait "Medic") then {
            _unit setUnitTrait ["Medic", true];
            [{  params ["_caller"];
                _caller setUnitTrait ["Medic", false];
            }, [_unit], 1] call CBA_fnc_waitAndExecute;
        };
        if ((lifeState _unit) == "INCAPACITATED" || {_unit getVariable [QGVAR(unconscious), false]}) then {
            [_unit, _unit, false] call FUNC(revive);
        } else {
            _unit setDamage 0;
            [_unit, _unit, false] call FUNC(handleHealEh);
        };
    };
}] call CBA_fnc_addEventHandler;


[QGVAR(fillPlates), {
    params ["_unit"];
    if (!alive _unit) exitWith {};
    _unit call FUNC(fillVestWithPlates);
    if (isPlayer _unit) then { _unit call FUNC(updatePlateUi); };
}] call CBA_fnc_addEventHandler;

if !(hasInterface) exitWith {
    INFO("Dedicated server / Headless client post init done");
};

GVAR(lastDamageFeedbackMarkerShown) = -1;
GVAR(lastPlateBreakSound) = -1;
GVAR(lastHPDamageSound) = -1;
GVAR(skullID) = -1;
GVAR(downedUnitIndicatorDrawEh) = -1;
GVAR(downedUnitIndicatorDrawCache) = [];
GVAR(hasPlateInInvetory) = QGVAR(plate) in (player call FUNC(uniqueItems));
GVAR(skullActive) = false;

// disallow weapon firing during plate interaction when ace is loaded
if !(isNil "ace_common_fnc_addActionEventHandler") then {
    GVAR(weaponsEvtId) = [player, "DefaultAction", {!GVAR(addPlateKeyUp)}, {}] call ace_common_fnc_addActionEventHandler;
};

["unit", {
    params ["_newUnit", "_oldUnit"];
    [_newUnit] call FUNC(updatePlateUi);
    [_newUnit] call FUNC(updateHPUi);
    if !(isNil QGVAR(weaponsEvtId)) then {
        [_oldUnit, "DefaultAction", GVAR(weaponsEvtId)] call ace_common_fnc_removeActionEventHandler;
        GVAR(weaponsEvtId) = [_newUnit, "DefaultAction", {!GVAR(addPlateKeyUp)}, {}] call ace_common_fnc_addActionEventHandler;
    };
}] call CBA_fnc_addPlayerEventHandler;

["loadout", {
    params ["_unit"];
    GVAR(uniqueItemsCache) = nil;
    GVAR(hasPlateInInvetory) = QGVAR(plate) in (_unit call FUNC(uniqueItems));
}] call CBA_fnc_addPlayerEventHandler;

[QGVAR(downedMessage), {
    if (GVAR(downedFeedback) isEqualTo 0) exitWith {};
    params ["_unit"];
    private _player = call CBA_fnc_currentUnit;
    if (_unit in (units _player)) then {
        systemChat format [localize selectRandom [
            LSTRING(downedMessage1),
            LSTRING(downedMessage2),
            LSTRING(downedMessage3)
        ], name _unit];
        if (GVAR(downedFeedback) isEqualTo 2) then {
            playSound "3DEN_notificationWarning";
        };
    };
}] call CBA_fnc_addEventHandler;

GVAR(fullWidth) = 10 * ( ((safeZoneW / safeZoneH) min 1.2) / 40);
GVAR(fullHeight) = 0.75 * ( ( ((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25);

GVAR(respawnEHId) = ["CAManBase", "Respawn", {
    params ["_unit"];
    if !(local _unit) exitWith {};
    _unit setVariable [QGVAR(plates), nil];
    _unit setVariable [QGVAR(hp), nil];
    _unit setVariable [QGVAR(downedHp), nil];
    _unit setVariable [QGVAR(downedHits), nil];
    _unit setVariable [QGVAR(vestContainer), vestContainer _unit];
    _unit setVariable [QGVAR(unconscious), false, true];
    _unit setVariable [QGVAR(beingRevived), nil, true];

    if (_unit isEqualTo player) then {
        if (GVAR(spawnWithFullPlates) && {!((vest player) in GVAR(vestBlacklist))}) then {
            [{
                params ["_unit"];
                [_unit] call FUNC(fillVestWithPlates);
                [_unit] call FUNC(updatePlateUi);
            }, [_unit], 1] call CBA_fnc_waitAndExecute;
        };
        [_unit] call FUNC(updatePlateUi);

        if !(GVAR(aceMedicalLoaded)) then {
            [QGVAR(respawned), [_unit]] call CBA_fnc_globalEvent;
            [_unit] call FUNC(updateHPUi);
            [] call FUNC(addPlayerHoldActions);
            GVAR(bleedOutTimeMalus) = nil;
        };
    };
}, true, [], true] call CBA_fnc_addClassEventHandler;

GVAR(killedEHId) = ["CAManBase", "Killed",{
    params ["_unit"];
    if !(local _unit) exitWith {};
    private _oldVestcontainer = _unit getVariable [QGVAR(vestContainer), objNull];
    _oldVestcontainer setVariable [QGVAR(plates), _oldVestcontainer getVariable [QGVAR(plates), []], true];
    _unit setVariable [QGVAR(hp), nil];
    _unit setVariable [QGVAR(unconscious), false, true];

    if (!GVAR(aceMedicalLoaded) && {_unit isEqualTo player}) then {
        GVAR(bleedOutTimeMalus) = nil;
        [false] call FUNC(showDownedSkull);
        call FUNC(deleteProgressBar);
    };
}, true, [], true] call CBA_fnc_addClassEventHandler;

private _aceInteractLoaded = !(isNil "ace_interact_menu_fnc_addActionToClass");
if !(GVAR(aceMedicalLoaded)) then {
    [] call FUNC(addPlayerHoldActions);
    if (GVAR(showDownedUnitIndicator)) then {
        GVAR(downedUnitIndicatorDrawEh) = addMissionEventHandler ["Draw3D", {
            call FUNC(drawDownedUnitIndicator);
        }];
    };

    GVAR(firstAidKitItems) = "getNumber (_x >> 'ItemInfo' >> 'type') isEqualTo 401" configClasses (configFile >> "CfgWeapons") apply {configName _x};
    GVAR(mediKitItems) = "getNumber (_x >> 'ItemInfo' >> 'type') isEqualTo 619" configClasses (configFile >> "CfgWeapons") apply {configName _x};
    GVAR(injectorItems) = format ["getNumber (_x >> '%1') > 0", QGVAR(isInjector)] configClasses (configFile >> "CfgWeapons") apply {configName _x};

    [] spawn {
        GVAR(playerDamageSync) = player getVariable [QGVAR(maxHP), GVAR(maxPlayerHP)];
        while {true} do {
            if (alive player) then {
                private _maxHp = player getVariable [QGVAR(maxHP), GVAR(maxPlayerHP)];
                private _oldValue = player getVariable [QGVAR(hp), _maxHp];
                if (_oldValue isNotEqualTo GVAR(playerDamageSync)) then {
                    player setVariable [QGVAR(hp), _oldValue, true];
                    GVAR(playerDamageSync) = _oldValue;
                };
                if ((damage player) isEqualTo 0 && {_oldValue < _maxHp}) then {
                    [player, _oldValue, _maxHp] call FUNC(setA3Damage);
                };
            };
            if (GVAR(showDownedUnitIndicator)) then {
                private _player = call CBA_fnc_currentUnit;
                private _side = side group _player;
                GVAR(downedUnitIndicatorDrawCache) = allUnits select {
                    _x getVariable [QGVAR(unconscious), false] && {
                    alive _x && {
                    _side isEqualTo (side group _x)}}};
                GVAR(downedUnitIndicatorDrawCache) = GVAR(downedUnitIndicatorDrawCache) - [_player];
            };
            sleep 5;
        };
    };

    [QGVAR(requestAIRevive), {
        _this spawn FUNC(aiMoveAndHealUnit);
    }] call CBA_fnc_addEventHandler;

    if (_aceInteractLoaded) then {
        private _action = ["apsRevive", localize "str_heal", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa",
            {
                params ["_target", "_player", ""];
                private _isMedic = _player getUnitTrait 'Medic';
                private _reviveDelay = ([GVAR(noneMedicReviveTime),GVAR(medicReviveTime)] select _isMedic);
                if (isNull objectParent _player) then {
                    private _isProne = stance _player == "PRONE";
                    _player setVariable [QGVAR(wasProne), _isProne];
                    private _medicAnim = ["AinvPknlMstpSlayW[wpn]Dnon_medicOther", "AinvPpneMstpSlayW[wpn]Dnon_medicOther"] select _isProne;
                    private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _player, secondaryWeapon _player, handgunWeapon _player] find currentWeapon _player, "non"];
                    _medicAnim = [_medicAnim, "[wpn]", _wpn] call CBA_fnc_replace;
                    _player setVariable [QGVAR(medicAnim), _medicAnim];
                    if (_medicAnim != "") then {
                        _player playMove _medicAnim;
                    };
                };
                _target setVariable [QGVAR(beingRevived), true, true];
                _target setVariable [QGVAR(revivingUnit), _player, true];

                [_reviveDelay, [_target,_player], { // complete
                    params ["_args"];
                    _args params ["_target", "_caller"];
                    [QGVAR(revive), [_target, _caller, true], _target] call CBA_fnc_targetEvent;
                    if (isNull objectParent _caller) then {
                        private _wasProne = (_caller getVariable [QGVAR(wasProne), false]);
                        private _anim = ["amovpknlmstps[pos]w[wpn]dnon", "amovppnemstps[pos]w[wpn]dnon"] select _wasProne;
                        private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _caller, secondaryWeapon _caller, handgunWeapon _caller] find currentWeapon _caller, "non"];
                        private _pos = ["non","low","ras","low"] param [["", primaryWeapon _caller, secondaryWeapon _caller, handgunWeapon _caller] find currentWeapon _caller,"ras"];
                        if (_wasProne && {_pos isEqualTo "low"}) then {_pos = "ras";};
                        _anim = [_anim, "[pos]", _pos] call CBA_fnc_replace;
                        _anim = [_anim, "[wpn]", _wpn] call CBA_fnc_replace;
                        [QGVAR(switchMove), [_caller, _anim, (GVAR(readyAfterRevive) > 1)]] call CBA_fnc_globalEvent;
                    };
                    _target setVariable [QGVAR(beingRevived), nil, true];
                    _target setVariable [QGVAR(revivingUnit), nil, true];
                }, {// fail
                    params ["_args"];
                    _args params ["_target", "_caller"];
                    if (isNull objectParent _caller) then {
                        private _wasProne = (_caller getVariable [QGVAR(wasProne), false]);
                        private _anim = ["amovpknlmstps[pos]w[wpn]dnon", "amovppnemstps[pos]w[wpn]dnon"] select _wasProne;
                        private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _caller, secondaryWeapon _caller, handgunWeapon _caller] find currentWeapon _caller, "non"];
                        private _pos = ["non","low","ras","low"] param [["", primaryWeapon _caller, secondaryWeapon _caller, handgunWeapon _caller] find currentWeapon _caller,"ras"];
                        if (_wasProne && {_pos isEqualTo "low"}) then {_pos = "ras";};
                        _anim = [_anim, "[pos]", _pos] call CBA_fnc_replace;
                        _anim = [_anim, "[wpn]", _wpn] call CBA_fnc_replace;
                        [QGVAR(switchMove), [_caller, _anim, (GVAR(readyAfterRevive) > 0)]] call CBA_fnc_globalEvent;
                    };
                    _target setVariable [QGVAR(beingRevived), nil, true];
                    _target setVariable [QGVAR(revivingUnit), nil, true];
                }, format [LLSTRING(reviveUnit), name _target], // title
                { // pfh
                    params ["_args"];
                    _args params ["_target", "_caller"];
                    if !(_target getVariable [QGVAR(beingRevived), false]) then {
                        _target setVariable [QGVAR(beingRevived), true, true];
                        _target setVariable [QGVAR(revivingUnit), _caller, true];
                    };
                    if (GVAR(bleedoutStop) > 1 && {!(_target getVariable [QGVAR(holdLimiter), false]) && {GVAR(bleedoutStop) == 3 || {_caller getUnitTrait 'Medic'}}}) then {
                        if !(local _target) then { _target setVariable [QGVAR(holdLimiter), true]; };
                        [QGVAR(bleedRecovery), _target, _target] call CBA_fnc_targetEvent;
                    };
                    private _medicAnim = _caller getVariable [QGVAR(medicAnim), ""];
                    if (isNull objectParent _caller && {_medicAnim != "" && { animationState _caller != _medicAnim }}) then {
                        _caller playMove _medicAnim;
                    };
                    true
                }, ["isNotInside"]] call ace_common_fnc_progressBar;
            },{ // Condition
                params ["_target", "_player", ""];
                !(_target getVariable [QGVAR(beingRevived), false] && {alive (_target getVariable [QGVAR(revivingUnit), objNull])}) && {[_player, _target] call FUNC(canRevive)}
            },
            {}, [], [0,0,0], GVAR(holdActionRange),[false,true,false,false,false]
        ] call ace_interact_menu_fnc_createAction;
        ["CAManBase", 0, ["ACE_MainActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;

        if (GVAR(bleedoutStop) > 0) then {
            private _action = ["apsPreventBleed", LLSTRING(pressureWound), "\a3\ui_f\data\IGUI\Cfg\Cursors\unitBleeding_ca.paa",
            {
                params ["_target", "_player", ""];
                if (isNull objectParent _player) then {
                    private _isProne = stance _player == "PRONE";
                    _player setVariable [QGVAR(wasProne), _isProne];
                    private _medicAnim = ["AinvPknlMstpSlayW[wpn]Dnon_medicOther", "AinvPpneMstpSlayW[wpn]Dnon_medicOther"] select _isProne;
                    private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _player, secondaryWeapon _player, handgunWeapon _player] find currentWeapon _player, "non"];
                    _medicAnim = [_medicAnim, "[wpn]", _wpn] call CBA_fnc_replace;
                    _player setVariable [QGVAR(medicAnim), _medicAnim];
                    if (_medicAnim != "") then {
                        _player playMove _medicAnim;
                     };
                };
                _target setVariable [QGVAR(isHold), true, true];
                _target setVariable [QGVAR(holdingUnit), _player, true];

                [21.5, [_target,_player], { // complete
                    params ["_args"];
                    _args params ["_target", "_caller"];
                    if (isNull objectParent _caller) then {
                        private _wasProne = (_caller getVariable [QGVAR(wasProne), false]);
                        private _anim = ["amovpknlmstps[pos]w[wpn]dnon", "amovppnemstps[pos]w[wpn]dnon"] select _wasProne;
                        private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _caller, secondaryWeapon _caller, handgunWeapon _caller] find currentWeapon _caller, "non"];
                        private _pos = ["non","low","ras","low"] param [["", primaryWeapon _caller, secondaryWeapon _caller, handgunWeapon _caller] find currentWeapon _caller,"ras"];
                        if (_wasProne && {_pos isEqualTo "low"}) then {_pos = "ras";};
                        _anim = [_anim, "[pos]", _pos] call CBA_fnc_replace;
                        _anim = [_anim, "[wpn]", _wpn] call CBA_fnc_replace;
                        [QGVAR(switchMove), [_caller, _anim, (GVAR(readyAfterRevive) > 1)]] call CBA_fnc_globalEvent;
                    };
                    _target setVariable [QGVAR(isHold), nil, true];
                    _target setVariable [QGVAR(holdingUnit), nil, true];
                }, {// fail
                    params ["_args"];
                    _args params ["_target", "_caller"];
                    if (isNull objectParent _caller) then {
                        private _wasProne = (_caller getVariable [QGVAR(wasProne), false]);
                        private _anim = ["amovpknlmstps[pos]w[wpn]dnon", "amovppnemstps[pos]w[wpn]dnon"] select _wasProne;
                        private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _caller, secondaryWeapon _caller, handgunWeapon _caller] find currentWeapon _caller, "non"];
                        private _pos = ["non","low","ras","low"] param [["", primaryWeapon _caller, secondaryWeapon _caller, handgunWeapon _caller] find currentWeapon _caller,"ras"];
                        if (_wasProne && {_pos isEqualTo "low"}) then {_pos = "ras";};
                        _anim = [_anim, "[pos]", _pos] call CBA_fnc_replace;
                        _anim = [_anim, "[wpn]", _wpn] call CBA_fnc_replace;
                        [QGVAR(switchMove), [_caller, _anim, (GVAR(readyAfterRevive) > 0)]] call CBA_fnc_globalEvent;
                    };
                    _target setVariable [QGVAR(isHold), nil, true];
                    _target setVariable [QGVAR(holdingUnit), nil, true];
                }, format [LLSTRING(pressureUnit), name _target], // title
                { // pfh
                    params ["_args"];
                    _args params ["_target", "_caller"];
                    if !(_target getVariable [QGVAR(isHold), false]) then {
                        _target setVariable [QGVAR(isHold), true, true];
                        _target setVariable [QGVAR(holdingUnit), _caller, true];
                    };
                    if !(_target getVariable [QGVAR(holdLimiter), false]) then {
                        if !(local _target) then { _target setVariable [QGVAR(holdLimiter), true]; };
                        [QGVAR(bleedRecovery), _target, _target] call CBA_fnc_targetEvent;
                    };
                    true;
                 }, ["isNotInside"]] call ace_common_fnc_progressBar;
            },
            {
                params ["_target", "_player", ""];
                !(_target getVariable [QGVAR(isHold), false] && {alive (_target getVariable [QGVAR(holdingUnit), objNull])}) && {[_player, _target] call FUNC(canHold)}
            },
                {}, [], [0,0,0], GVAR(holdActionRange),[false,true,false,false,false]
            ] call ace_interact_menu_fnc_createAction;
            ["CAManBase", 0, ["ACE_MainActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;
        };
    };

    [LLSTRING(category), QGVAR(commOpen), LLSTRING(commOpenKeyBind), {
        if (!GVAR(commEnable)) exitWith {false};
        if (commandingMenu isEqualTo ("#USER:" + QGVAR(commMenu))) exitWith {showCommandingMenu "";};
        showCommandingMenu ("#USER:" + QGVAR(commMenu));
        true
    }, "",
    [DIK_Y, [false, false, true]], false] call CBA_fnc_addKeybind;

    GVAR(commMenu) = [ [LLSTRING(commMenu),false],
        ["base",[0],"",-5,[["expression",""]],"0","0"],
        [LLSTRING(reqHeal),[2],"",-5,[["expression","[player] call diw_armor_plates_main_fnc_commandHeal;"]],"!isAlone","1"],
        [LLSTRING(reqRevive),[3],"",-5,[["expression","[player] call diw_armor_plates_main_fnc_commandHeal;"]],"!isAlone","1"],
        [LLSTRING(commandHeal),[4],"",-5,[["expression","[cursorTarget] call diw_armor_plates_main_fnc_commandHeal;"]],"!isAlone","CursorOnFriendly"],
        [LLSTRING(commandRevive),[5],"",-5,[["expression","[cursorTarget] call diw_armor_plates_main_fnc_commandHeal;"]],"!isAlone","CursorOnFriendly"]
    ];

    {[_x, "init", {_this spawn FUNC(addStructureHeal)}, false, [], true] call CBA_fnc_addClassEventHandler;} forEach ("getNumber (_x >> 'attendant') > 0" configClasses (configFile >> "CfgVehicles") apply {configName _x});

    ["CAManBase", "AnimDone", {
        params ["_unit", "_anim"];
        if (local _unit && {!(_unit getVariable [QGVAR(unconscious), false]) && {_anim find "unconsciousface" != -1}}) then {
            _unit setUnconscious false;
        };
    }] call CBA_fnc_addClassEventHandler;
};

// ace interactions
if (_aceInteractLoaded) then {
    private _action = [QGVAR(addPlate), LLSTRING(addPlateKeyBind),
        "\a3\ui_f\data\gui\rsc\rscdisplayarsenal\vest_ca.paa", {
        params ["", "_player"];
        GVAR(addingPlate) = true;
        [_player] call FUNC(doGesture);
        [GVAR(timeToAddPlate), [_player], {
            param [0] params ["_player"];
            [_player] call FUNC(addPlate);
            GVAR(addingPlate) = false;
        }, {
            param [0] params ["_player"];
            GVAR(addingPlate) = false;
            [_player, false] call FUNC(doGesture);
        }, LLSTRING(addPlateToVest), {
            param [0] params ["_player"];
            (stance _player) != "PRONE" && {
            [_player] call FUNC(canPressKey) && {
            [_player] call FUNC(canAddPlate)}}
        }, ["isNotInside"]] call ace_common_fnc_progressBar
    }, {
        params ["", "_player"];
        (stance _player) != "PRONE" && {
        [_player] call FUNC(canPressKey) && {
        [_player] call FUNC(canAddPlate)}}
    },{},[], [0,0,0], 3] call ace_interact_menu_fnc_createAction;
    ["CAManBase", 1, ["ACE_SelfActions", "ACE_Equipment"], _action, true] call ace_interact_menu_fnc_addActionToClass;

    private _action2 = [QGVAR(useInjector), LLSTRING(useInjectorAce),
        "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_revive_ca.paa", {
        params ["_target", "_player"];
        private _isProne = stance _player == "PRONE";
        private _medicAnim = ["AinvPknlMstpSlayW[wpn]Dnon_medicOther", "AinvPpneMstpSlayW[wpn]Dnon_medicOther"] select _isProne;
        private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _player, secondaryWeapon _player, handgunWeapon _player] find currentWeapon _player, "non"];
        _medicAnim = [_medicAnim, "[wpn]", _wpn] call CBA_fnc_replace;
        if (_medicAnim != "") then {
            _player playMove _medicAnim;
        };
        [{params ["_target", "_player"];
            if (!alive _target || {!alive _player || {_player getVariable [QGVAR(unconscious), false]}}) exitWith {};
            [QGVAR(reduceMalus), [_target, _player, true], _target] call CBA_fnc_targetEvent;
        }, _this, 1] call CBA_fnc_waitAndExecute;
    }, {
        params ["_target", "_player"];
        alive _target && {_player getUnitTrait 'Medic' && {(_player call FUNC(hasInjector))}}
    },{},[], [0,0,0], 2.5] call ace_interact_menu_fnc_createAction;
    ["CAManBase", 1, ["ACE_SelfActions", "ACE_Equipment"], _action2, true] call ace_interact_menu_fnc_addActionToClass;
    ["CAManBase", 0, ["ACE_MainActions"], _action2, true] call ace_interact_menu_fnc_addActionToClass;
};

/* Plate transfer events for compatibility use
  Using cba_fnc_getLoadout/cba_fnc_setLoadout when altering loadout should automatically load plates.

  If using vanilla functions, use `diw_armor_plates_main_plateTransferArsenal = true;`, if you want the plateRefillArsenal setting to affect the transfer, then `["diw_armor_plates_main_transferStart",[_unit], _unit] call CBA_fnc_targetEvent;` before altering unit loadout, and `["diw_armor_plates_main_transfer",[_unit], _unit] call CBA_fnc_targetEvent;` after altering the loadout to maintain the player's plates when changing loadout/vest.
*/
[QGVAR(transferStart), { params [["_unit",player,[objNull]]];
    private _vest = vestContainer _unit;
    if (isNull _vest || {(vest _unit) in GVAR(vestBlacklist)}) exitWith {};
    GVAR(plateTransfer) = [_unit, (_vest getVariable [QGVAR(plates),[]])];
}] call CBA_fnc_addEventHandler;
[QGVAR(transfer), { params [["_unit",player,[objNull]]];
    private _plates = (missionNamespace getVariable [QGVAR(plateTransfer),nil]);
    if (isNil '_plates') exitWith {};
    GVAR(plateTransfer) = nil;
    private _unit = (_plates # 0);
    private _plates = (_plates # 1);
    private _vest = vestContainer _unit;
    if (isNil '_unit' || {isNull _vest || {(vest _unit) in GVAR(vestBlacklist)}}) exitWith {};
    _vest setVariable [QGVAR(plates),_plates];
    private _vLoad = _vest getVariable ["ace_movement_vLoad", 0];
    _vest setVariable ["ace_movement_vLoad", _vLoad + (PLATE_MASS * (count _plates)), true];
    if (_unit isEqualTo player) then {[_unit] call FUNC(updatePlateUi);};
}] call CBA_fnc_addEventHandler;

// Vanilla arsenal
[missionNamespace, "arsenalPreOpen", { params ["", "_center"];
    private _unit = nearestObject [_center,"CAManBase"];
    if (isNull _unit) then {_unit = player};
    GVAR(transferTarg) = _unit;
    [QGVAR(transferStart),[_unit],_unit] call CBA_fnc_targetEvent;
}] call BIS_fnc_addScriptedEventHandler;

[missionNamespace, "arsenalClosed", {
    0 spawn { sleep 1;
        private _unit = GVAR(transferTarg);
        GVAR(transferTarg) = nil;
        [QGVAR(transfer),[_unit],_unit] call CBA_fnc_targetEvent;
    };
}] call BIS_fnc_addScriptedEventHandler;

["CBA_loadoutSet", {
    params ["_unit", "", "_extradata"];
    if (isNull (vestContainer _unit) || {(vest _unit) in GVAR(vestBlacklist)}) exitWith {};
    private _plates = _extradata getOrDefault [QGVAR(plates), []];

    // setting check
    private _count = count _plates;
    private _platesMax = GVAR(numWearablePlates);
    private _plateMaxHp = GVAR(maxPlateHealth);
    if (_count > _platesMax) then {
        for "_i" from _platesMax to (_count -1) do {
            _plates deleteAt _platesMax;
        };
        _count = _platesMax;
    };
    if ((_plates # 0) > _plateMaxHp) then {
        _plates = _plates apply { [_x, _plateMaxHp] select (_x > _plateMaxHp) };
    };

    private _vest = vestContainer _unit;
    private _vLoad = _vest getVariable ["ace_movement_vLoad", 0];
    _vest setVariable [QGVAR(plates),_plates];
    _vest setVariable ["ace_movement_vLoad", _vLoad + (PLATE_MASS * _count), true];
    if (_unit isEqualTo player) then {[_unit] call FUNC(updatePlateUi);};
}] call CBA_fnc_addEventHandler;

["CBA_loadoutGet", {
    params ["_unit", "", "_extradata"];
    if (isNull (vestContainer _unit) || {(vest _unit) in GVAR(vestBlacklist)}) exitWith {};
    private _plates = (vestContainer _unit) getVariable [QGVAR(plates),[]];
    if (_plates isNotEqualTo []) then {
        _extradata set [QGVAR(plates), _plates];
    };
}] call CBA_fnc_addEventHandler;

[{
    time > 1
}, {
    private _3den_maxPlateInVest = player getVariable [QGVAR(3den_maxPlateInVest), -1];
    if (_3den_maxPlateInVest >= 0 || {GVAR(spawnWithFullPlates) && {!((vest player) in GVAR(vestBlacklist))}}) then {
        [player] call FUNC(fillVestWithPlates);
    };
    private _3den_maxPlateInInventory = player getVariable [QGVAR(3den_maxPlateInInventory), -1];
    if (_3den_maxPlateInInventory > 0) then {
        private _container = switch (true) do {
            case ((vest player) isNotEqualTo ""): {vestContainer player};
            case ((uniform player) isNotEqualTo ""): {uniformContainer player};
            case ((backpack player) isNotEqualTo ""): {backpackContainer player};
            default {objNull};
        };
        _container addItemCargoGlobal [QGVAR(plate), _3den_maxPlateInInventory];
    };
    [] call FUNC(initPlates);
    player setVariable [QGVAR(vestContainer), vestContainer player];
    GVAR(loadoutEHId) = ["cba_events_loadoutEvent",{
        params ["_unit"];
        private _currentVestContainer = vestContainer _unit;
        private _oldVestcontainer = _unit getVariable [QGVAR(vestContainer), objNull];

        if ((isNull _currentVestContainer && {!isNull _oldVestcontainer}) ||
            (!isNull _currentVestContainer && {isNull _oldVestcontainer}) ||
            (_currentVestContainer isNotEqualTo _oldVestcontainer)) then {
            _oldVestcontainer setVariable [QGVAR(plates), _oldVestcontainer getVariable [QGVAR(plates), []], true];
            _unit setVariable [QGVAR(vestContainer), _currentVestContainer];
            [_unit] call FUNC(updatePlateUi);
        };
    }] call CBA_fnc_addEventHandler;
    INFO("UI elements initialized");
}] call CBA_fnc_waitUntilAndExecute;

GVAR(addPlateKeyUp) = true;
GVAR(addingPlate) = false;

[LLSTRING(category), QGVAR(addPlate), LLSTRING(addPlateKeyBind), {
    if (GVAR(addingPlate)) exitWith {};
    private _player = call CBA_fnc_currentUnit;
    if (GVAR(allowHideArmor)) then {
        [_player] call FUNC(updatePlateUi);
    };
    if (GVAR(allowHideHP)) then {
        [_player] call FUNC(updateHPUi);
    };
    if ((stance _player) == "PRONE" || {
        !([_player] call FUNC(canPressKey)) || {
        !([_player] call FUNC(canAddPlate))}}) exitWith {false};

    GVAR(addPlateKeyUp) = false;
    [_player] call FUNC(addPlateKeyPress);

    true
}, {
    GVAR(addPlateKeyUp) = true;
    false
},
[DIK_T, [false, false, false]], false] call CBA_fnc_addKeybind;

INFO("Client post init done");
