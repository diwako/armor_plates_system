#include "script_component.hpp"
params ["_unit", "_set",["_recover", false]];

if (isNull _unit || {!local _unit || {!alive _unit} || {!(_unit isKindOf "CAManBase")}}) exitWith {
    false
};

if (!_recover && {_set isEqualTo (_unit getVariable [QGVAR(unconscious), false])}) exitWith {
    false
};

if (currentWeapon _unit != primaryWeapon _unit) then {
    _unit selectWeapon primaryWeapon _unit;
};

if (_set) then {
    if (GVAR(bleedoutTime) > 0) then {
        private _restBleedout = GVAR(bleedoutTime);
        private _downTime = cba_missionTime;
        if (!_recover) then {
            _unit setVariable [QGVAR(bleedoutTime), _downTime];
            if (_unit isEqualTo player) then {
                if (isNil QGVAR(bleedOutTimeMalus)) then {
                    GVAR(bleedOutTimeMalus) = - GVAR(bleedoutTimeSubtraction);
                };
                GVAR(bleedOutTimeMalus) = GVAR(bleedOutTimeMalus) + GVAR(bleedoutTimeSubtraction);
                _restBleedout = (GVAR(bleedoutTime) - GVAR(bleedOutTimeMalus)) max GVAR(minBleedoutTime);
            };
            _unit setVariable [QGVAR(bleedoutKillTime), _downTime + _restBleedout, true];
        } else {
            _downTime = (_unit getVariable [QGVAR(bleedoutTime), -1]);
            _restBleedout = ((_unit getVariable [QGVAR(bleedoutKillTime), -1]) - cba_missionTime);
        };
        [{
            params ["_unit", "_time"];
            private _unconscious = (lifeState _unit) == "INCAPACITATED";
            if (cba_missionTime < (_unit getVariable [QGVAR(bleedoutKillTime), -1]) && {_unconscious}) exitWith {
                [_unit, true, true] call FUNC(setUnconscious);
            };
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
        }, [_unit, _downTime], _restBleedout] call CBA_fnc_waitAndExecute;
        if (GVAR(showDownedSkull) && {_unit isEqualTo player}) then {
            if (_recover) then { [false] call FUNC(showDownedSkull); };
            [_set, _restBleedout] call FUNC(showDownedSkull);
        };
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

if (_set && {GVAR(requestAIforHelp)}) then {
    [_unit] call FUNC(requestAIRevive);
};

true
