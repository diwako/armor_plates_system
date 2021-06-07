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
    uiNamespace setVariable [QGVAR(feedBackCtrl), []]
};

GVAR(aceMedicalLoaded) = isClass(configFile >> "CfgPatches" >> "ace_medical_engine");
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

        private _arr = [_unit, "Heal", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa",
            // condition show
            format ["alive _target && {(lifeState _target) == 'INCAPACITATED' && {_this getUnitTrait 'Medic' && {(_target distance _this) < 4 && {[_this] call %1 > 0}}}}", QFUNC(hasHealItems)],
            // condition progress
            "alive _target && {(lifeState _target) == 'INCAPACITATED'}", {
            // code start
            params ["_target", "_caller"];
            private _isProne = stance _caller == "PRONE";
            _caller setVariable [QGVAR(wasProne), _isProne];
            private _medicAnim = ["AinvPknlMstpSlayW[wpn]Dnon_medicOther", "AinvPpneMstpSlayW[wpn]Dnon_medicOther"] select _isProne;
            private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _caller, secondaryWeapon _caller, handgunWeapon _caller] find currentWeapon _caller, "non"];
            _medicAnim = [_medicAnim, "[wpn]", _wpn] call CBA_fnc_replace;
            if (_medicAnim != "") then {
                _caller playMove _medicAnim;
            };
        }, {
            // code progress
        }, {
            // codeCompleted
            params ["_target", "_caller"];
            private _ret = [_caller] call FUNC(hasHealItems);
            if (_ret isEqualTo 1) then {
                _caller removeItem "FirstAidKit";
            };
            [QGVAR(heal), [_target, _caller], _target] call CBA_fnc_targetEvent;
        }, {
            // code interrupted
            params ["", "_caller"];
            private _anim = ["amovpknlmstpsloww[wpn]dnon", "amovppnemstpsrasw[wpn]dnon"] select (_caller getVariable [QGVAR(wasProne), false]);
            private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _caller, secondaryWeapon _caller, handgunWeapon _caller] find currentWeapon _caller, "non"];
            _anim = [_anim, "[wpn]", _wpn] call CBA_fnc_replace;
            [QGVAR(switchMove), [_caller, _anim]] call CBA_fnc_globalEvent;
        }, [], GVAR(medicReviveTime), 15, false, false, true];

        _arr call BIS_fnc_holdActionAdd;
        private _arr2 = +_arr;
        _arr2 set [4, format ["alive _target && {(lifeState _target) == 'INCAPACITATED' && {!(_this getUnitTrait 'Medic') && {(_target distance _this) < 4 && {[_this] call %1 > 0}}}}", QFUNC(hasHealItems)]];
        _arr2 set [11, GVAR(noneMedicReviveTime)];
        _arr2 call BIS_fnc_holdActionAdd;

        private _id = _unit addEventHandler ["HandleDamage", {
            _this call FUNC(handleDamageEh);
        }];
        _unit setVariable ["ace_medical_HandleDamageEHID", _id];

        [_unit] call FUNC(initAIUnit);
    }, true, [], true] call CBA_fnc_addClassEventHandler;

    ["CAManBase", "HandleHeal", {
        [{
            _this call FUNC(handleHealEh);
        }, _this, 5] call CBA_fnc_waitAndExecute;
        true
    }, true, [], true] call CBA_fnc_addClassEventHandler;

    [QGVAR(heal), {
        (_this select 0) setDamage 0;
        _this call FUNC(handleHealEh);
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

["unit", {
    params ["_newUnit"];
    [_newUnit] call FUNC(updatePlateUi);
    [_newUnit] call FUNC(updateHPUi);
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

GVAR(respawnEHId) = player addEventHandler ["Respawn", {
    params ["_unit"];
    // player setVariable [QGVAR(plates), []];
    _unit setVariable [QGVAR(hp), nil];
    _unit setVariable [QGVAR(vestContainer), vestContainer _unit];
    [_unit] call FUNC(updatePlateUi);
    [_unit] call FUNC(updateHPUi);
    [] call FUNC(addPlayerHoldActions);
    _unit setVariable [QGVAR(unconscious), false, true];
}];

GVAR(killedEHId) = player addEventHandler ["Killed", {
    params ["_unit"];
    private _oldVestcontainer = _unit getVariable [QGVAR(vestContainer), objNull];
    _oldVestcontainer setVariable [QGVAR(plates), _oldVestcontainer getVariable [QGVAR(plates), []], true];
    _unit setVariable [QGVAR(hp), nil];
}];

if !(GVAR(aceMedicalLoaded)) then {
    [] call FUNC(addPlayerHoldActions);
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

// (vestContainer player) setVariable [QGVAR(plates), [GVAR(maxPlateHealth),GVAR(maxPlateHealth),GVAR(maxPlateHealth)]];
// player setVariable [QGVAR(hp), 20];
