#include "script_component.hpp"
params ["_unit", "_set"];

if (isNull _unit || {!local _unit || {!alive _unit} || {!(_unit isKindOf "CAManBase")}}) exitWith {
    false
};

if (_set isEqualTo (_unit getVariable [QGVAR(unconscious), false])) exitWith {
    false
};

if (currentWeapon _unit != primaryWeapon _unit) then {
    _unit selectWeapon primaryWeapon _unit;
};

if (_set) then {
    if (GVAR(bleedoutTime) > 0) then {
        private _restBleedout = GVAR(bleedoutTime);
        _unit setVariable [QGVAR(bleedoutTime), cba_missionTime];
        if (_unit isEqualTo player) then {
            if (isNil QGVAR(bleedOutTimeMalus)) then {
                GVAR(bleedOutTimeMalus) = - GVAR(bleedoutTimeSubtraction);
            };
            GVAR(bleedOutTimeMalus) = GVAR(bleedOutTimeMalus) + GVAR(bleedoutTimeSubtraction);
            _restBleedout = (GVAR(bleedoutTime) - GVAR(bleedOutTimeMalus)) max GVAR(minBleedoutTime);
        };

        _unit setVariable [QGVAR(bleedoutKillTime), cba_missionTime + _restBleedout, true];
        if (GVAR(showDownedSkull) && {_unit isEqualTo player}) then {
            [_set, _restBleedout, _unit] call FUNC(showDownedSkull);
        };
        [{
            params ["_unit"];
            private _timeLeft = (_unit getVariable [QGVAR(bleedoutKillTime), -1]) - cba_missionTime;
            _timeLeft <= 0 || {(lifeState _unit) != "INCAPACITATED"}
        }, {
            params ["_unit", "_time"];
            private _unconscious = (lifeState _unit) == "INCAPACITATED";
            if ((_unit getVariable [QGVAR(bleedoutTime), -1]) isEqualTo _time && {_unconscious}) then {
                // kill them
                [_unit, false] call FUNC(setUnconscious);
                _unit setHitPointDamage ["hitHead", 1, true, _unit];
            } else {
                if (alive _unit && {_unit getVariable [QGVAR(unconscious), false] && {!_unconscious}}) then {
                    // not sure what happened? Mission or mod interfering?!
                    [_unit, _unit] call FUNC(revive);
                    systemChat "Hello there fellow player, diwako here.";
                    systemChat "It seems the mission or some mod is interfering with this medical system of mine...";
                    systemChat "Enjoy your free revive, I guess?!";
                };
            };
        }, [_unit, cba_missionTime]] call CBA_fnc_waitUntilAndExecute;
    };
} else {
    _unit setVariable [QGVAR(bleedoutTime), nil];
    _unit setVariable [QGVAR(beingRevived), nil, true];
    _unit setVariable [QGVAR(bleedoutKillTime), nil, true];
    if (GVAR(showDownedSkull) && {_unit isEqualTo player}) then {
        [_set] call FUNC(showDownedSkull);
    };
    if (isNull objectParent _unit) then {
        [QGVAR(switchMove), [_unit, "AmovPpneMstpSnonWnonDnon"]] call CBA_fnc_globalEvent;
        if (currentWeapon _unit == secondaryWeapon _unit && {currentWeapon _unit != ""}) then {
            [QGVAR(switchMove), [_unit, "AmovPknlMstpSrasWlnrDnon"]] call CBA_fnc_globalEvent;
        };
        [{
            [QGVAR(wokeUpCheck), [_this]] call CBA_fnc_globalEvent;
        }, _unit, 0.5] call CBA_fnc_waitAndExecute;
    };
};

_unit setUnconscious _set;
[QGVAR(setHidden), [_unit , _set]] call CBA_fnc_globalEvent;
_unit setVariable [QGVAR(unconscious), _set, true];
_unit setVariable ["ACE_isUnconscious", _set, true]; // support for ace dragging and other ace features if enabled

if (GVAR(radioModUnconRestrictions) > 0) then {
    // ACRE
    private _player = call CBA_fnc_currentUnit;
    if (GVAR(AcreLoaded)) then {
        _unit setVariable ["acre_sys_core_isDisabledRadio", _set, true];
        if (_player isEqualTo _unit) then {
            [-1] call acre_sys_core_fnc_handleMultiPttKeyPressUp;
            [0] call acre_sys_core_fnc_handleMultiPttKeyPressUp;
            [1] call acre_sys_core_fnc_handleMultiPttKeyPressUp;
            [2] call acre_sys_core_fnc_handleMultiPttKeyPressUp;
        };
    };

    // TFAR
    if (GVAR(TfarLoaded)) then {
        _unit setVariable ["tf_unable_to_use_radio", _set, true];
        if (_player isEqualTo _unit) then {
            _unit call TFAR_fnc_releaseAllTangents;
        };
    };
    if (GVAR(radioModUnconRestrictions) isEqualTo 2) then {
        _unit setVariable ["acre_sys_core_isDisabled", _set, GVAR(AcreLoaded)];
        _unit setVariable ["tf_voiceVolume", [1, 0] select _set, GVAR(TfarLoaded)];
    };
};

if (_set && {GVAR(requestAIforHelp)}) then {
    [_unit] call FUNC(requestAIRevive);
};

true
