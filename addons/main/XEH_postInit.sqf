#include "script_component.hpp"

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

        [_unit] call FUNC(addActionsToUnit);
        [_unit] call FUNC(initAIUnit);
    }, true, [], true] call CBA_fnc_addClassEventHandler;

    ["CAManBase", "HandleHeal", {
        [{
            params ["_unit", "_healer"];
            _unit setDamage 0;
            [_unit, _healer, true] call FUNC(handleHealEh);
        }, _this, 5] call CBA_fnc_waitAndExecute;
        true
    }, true, [], true] call CBA_fnc_addClassEventHandler;

    [QGVAR(heal), {
        (_this select 0) setDamage 0;
        _this call FUNC(handleHealEh);
    }] call CBA_fnc_addEventHandler;

    [QGVAR(consumeFAK), {
        params ["_unit"];
        if (([_unit] call FUNC(hasHealItems)) isEqualTo 1) then {
            _unit removeItem (_unit getVariable [QGVAR(availableFirstAidKit), ""]);
            _unit setVariable [QGVAR(availableFirstAidKit), nil];
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
        params ["_unit", "_anim"];
        _unit switchMove _anim;
    }] call CBA_fnc_addEventHandler;

    [QGVAR(wokeUpCheck), {
        // check if someone is stuck in a downed animation
        params ["_unit"];
        if (!alive _unit) exitWith {};
        private _animation = animationState _unit;
        if ((_animation == "unconscious" || {_animation == "deadstate" || {_animation find "unconscious" != -1}}) && {lifeState _unit != "INCAPACITATED"}) then {
            [QGVAR(switchMove), [_unit, "AmovPpneMstpSnonWnonDnon"]] call CBA_fnc_globalEvent;
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
};

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

GVAR(fullWidth) = 10 * ( ((safezoneW / safezoneH) min 1.2) / 40);
GVAR(fullHeight) = 0.75 * ( ( ((safezoneW / safezoneH) min 1.2) / 1.2) / 25);

GVAR(respawnEHId) = ["CAManBase", "Respawn", {
    params ["_unit"];
    if !(local _unit) exitWith {};
    _unit setVariable [QGVAR(plates), nil];
    _unit setVariable [QGVAR(hp), nil];
    _unit setVariable [QGVAR(downedHp), nil];
    _unit setVariable [QGVAR(vestContainer), vestContainer _unit];
    _unit setVariable [QGVAR(unconscious), false, true];
    _unit setVariable [QGVAR(beingRevived), nil, true];

    if (_unit isEqualTo player) then {
        if (GVAR(spawnWithFullPlates)) then {
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
                        private _anim = ["amovpknlmstpsloww[wpn]dnon", "amovppnemstpsrasw[wpn]dnon"] select (_caller getVariable [QGVAR(wasProne), false]);
                        private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _caller, secondaryWeapon _caller, handgunWeapon _caller] find currentWeapon _caller, "non"];
                        _anim = [_anim, "[wpn]", _wpn] call CBA_fnc_replace;
                        [QGVAR(switchMove), [_caller, _anim]] call CBA_fnc_globalEvent;
                    };
                    _target setVariable [QGVAR(beingRevived), nil, true];
                    _target setVariable [QGVAR(revivingUnit), nil, true];
                }, {// fail
                    params ["_args"];
                    _args params ["_target", "_caller"];
                    if (isNull objectParent _caller) then {
                        private _anim = ["amovpknlmstpsloww[wpn]dnon", "amovppnemstpsrasw[wpn]dnon"] select (_caller getVariable [QGVAR(wasProne), false]);
                        private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _caller, secondaryWeapon _caller, handgunWeapon _caller] find currentWeapon _caller, "non"];
                        _anim = [_anim, "[wpn]", _wpn] call CBA_fnc_replace;
                        [QGVAR(switchMove), [_caller, _anim]] call CBA_fnc_globalEvent;
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
            {}, [], [0,0,0], 5,[false,true,false,false,false]
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
                        private _anim = ["amovpknlmstpsloww[wpn]dnon", "amovppnemstpsrasw[wpn]dnon"] select (_caller getVariable [QGVAR(wasProne), false]);
                        private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _caller, secondaryWeapon _caller, handgunWeapon _caller] find currentWeapon _caller, "non"];
                        _anim = [_anim, "[wpn]", _wpn] call CBA_fnc_replace;
                        [QGVAR(switchMove), [_caller, _anim]] call CBA_fnc_globalEvent;
                    };
                    _target setVariable [QGVAR(isHold), nil, true];
                    _target setVariable [QGVAR(holdingUnit), nil, true];
                }, {// fail
                    params ["_args"];
                    _args params ["_target", "_caller"];
                    if (isNull objectParent _caller) then {        
                        private _anim = ["amovpknlmstpsloww[wpn]dnon", "amovppnemstpsrasw[wpn]dnon"] select (_caller getVariable [QGVAR(wasProne), false]);
                        private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _caller, secondaryWeapon _caller, handgunWeapon _caller] find currentWeapon _caller, "non"];
                        _anim = [_anim, "[wpn]", _wpn] call CBA_fnc_replace;
                        [QGVAR(switchMove), [_caller, _anim]] call CBA_fnc_globalEvent;
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
                 }, ["isNotInside"]] call ace_common_fnc_progressBar;
            },
            {
                params ["_target", "_player", ""];
                !(_target getVariable [QGVAR(isHold), false] && {alive (_target getVariable [QGVAR(holdingUnit), objNull])}) && {[_player, _target] call FUNC(canHold)}
            },
                {}, [], [0,0,0], 5,[false,true,false,false,false]
            ] call ace_interact_menu_fnc_createAction;
            ["CAManBase", 0, ["ACE_MainActions"], _action, true] call ace_interact_menu_fnc_addActionToClass;
        };
    };
};

// ace interactions
if (_aceInteractLoaded) then {
    private _action = [QGVAR(addPlate), LLSTRING(addPlateKeyBind),
        "\a3\ui_f\data\gui\rsc\rscdisplayarsenal\vest_ca.paa", {
        params ["", "_player"];
        GVAR(addingPlate) = true;
        [GVAR(timeToAddPlate), [_player], {
            param [0] params ["_player"];
            [_player] call FUNC(addPlate);
            GVAR(addingPlate) = false;
        }, {
            GVAR(addingPlate) = false;
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
};

[{
    time > 1
}, {
    private _3den_maxPlateInVest = player getVariable [QGVAR(3den_maxPlateInVest), -1];
    if (_3den_maxPlateInVest >= 0 || {GVAR(spawnWithFullPlates)}) then {
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
#include "\a3\ui_f\hpp\defineDIKCodes.inc"
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
