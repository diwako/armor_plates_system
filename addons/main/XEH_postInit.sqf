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
if (GVAR(aceMedicalLoaded)) then {
    // ace medical
    ["CAManBase", "InitPost", {
        params ["_unit"];
        _unit setVariable ["ace_medical_engine_$#structural", [0, 0]];
        [{
            (_this getVariable ["ace_medical_HandleDamageEHID", -1]) > -1
        }, {
            _this removeEventHandler ["HandleDamage", _this getVariable ["ace_medical_HandleDamageEHID", -1]];
            private _id = _this addEventHandler ["HandleDamage", {
                _this call FUNC(handleDamageEhACE);
            }];
            _this setVariable ["ace_medical_HandleDamageEHID", _id];
        }, _unit] call CBA_fnc_waitUntilAndExecute;
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
            (_this select 0) setDamage 0;
            _this call FUNC(handleHealEh);
        }, _this, 5] call CBA_fnc_waitAndExecute;
        true
    }, true, [], true] call CBA_fnc_addClassEventHandler;

    [QGVAR(heal), {
        (_this select 0) setDamage 0;
        _this call FUNC(handleHealEh);
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
    _unit setVariable [QGVAR(vestContainer), vestContainer _unit];
    _unit setVariable [QGVAR(unconscious), false, true];

    if (_unit isEqualTo player) then {
        [QGVAR(respawned), [_unit]] call CBA_fnc_globalEvent;
        [_unit] call FUNC(updatePlateUi);
        if !(GVAR(aceMedicalLoaded)) then {
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

if !(GVAR(aceMedicalLoaded)) then {
    [] call FUNC(addPlayerHoldActions);
    if (GVAR(showDownedUnitIndicator)) then {
        GVAR(downedUnitIndicatorDrawEh) = addMissionEventHandler ["Draw3D", {
            call FUNC(drawDownedUnitIndicator);
        }];
    };

    [] spawn {
        GVAR(playerDamageSync) = GVAR(maxPlayerHP);
        while {true} do {
            if (alive player) then {
                private _oldValue = player getVariable [QGVAR(hp), GVAR(maxPlayerHP)];
                if (_oldValue isNotEqualTo GVAR(playerDamageSync)) then {
                    player setVariable [QGVAR(hp), _oldValue, true];
                    GVAR(playerDamageSync) = _oldValue;
                };
                if ((damage player) isEqualTo 0 && {_oldValue < GVAR(maxPlayerHP)}) then {
                    [player, _oldValue, GVAR(maxPlayerHP)] call FUNC(setA3Damage);
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
};

[{
    time > 1
}, {
    if (GVAR(spawnWithFullPlates)) then {
        private _plates = [];
        for "_i" from 1 to GVAR(numWearablePlates) do {
            _plates pushBack GVAR(maxPlateHealth);
        };
        (vestContainer player) setVariable [QGVAR(plates), _plates];
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

#include "\a3\ui_f\hpp\defineDIKCodes.inc"
[LLSTRING(category), QGVAR(addPlate), LLSTRING(addPlateKeyBind), {
    private _player = call CBA_fnc_currentUnit;
    if ((stance _player) == "PRONE" || {
        !([_player] call FUNC(canPressKey)) || {
        !([_player] call FUNC(canAddPlate))}}) exitWith {false};

    GVAR(addPlateKeyUp) = false;
    [_player] call FUNC(addPlate);

    true
}, {
    GVAR(addPlateKeyUp) = true;
    false
},
[DIK_T, [false, false, false]], false] call CBA_fnc_addKeybind;

INFO("Client post init done");
