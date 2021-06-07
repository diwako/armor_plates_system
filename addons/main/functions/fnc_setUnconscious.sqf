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
        _unit setVariable [QGVAR(bleedoutTime), cba_missionTime];
        [{
            params ["_unit", "_time"];
            private _unconscious = (lifeState _unit) == "INCAPACITATED";
            if ((_unit getVariable [QGVAR(bleedoutTime), -1]) isEqualTo _time && {_unconscious}) then {
                // kill them
                [_unit, false] call FUNC(setUnconscious);
                _unit setDamage 1;
            } else {
                if (alive _unit && {_unit getVariable [QGVAR(unconscious), false] && {!_unconscious}}) then {
                    // not sure what happened? Mission or mod interfering?!
                    [_unit, false] call FUNC(setUnconscious);
                    _unit setDamage 0;
                    [_unit, _unit] call FUNC(handleHealEh);
                    [_unit] call FUNC(startHpRegen);
                    systemChat "Hello there fellow player, diwako here.";
                    systemChat "It seems the mission or some mod is interfering with this medical system of mine...";
                    systemChat "Enjoy your free revive, I guess?!";
                };
            };
        }, [_unit, cba_missionTime], GVAR(bleedoutTime)] call CBA_fnc_waitAndExecute;
    };
} else {
    _unit setVariable [QGVAR(bleedoutTime), nil];
};

_unit setUnconscious _set;
[QGVAR(setHidden), [_unit , _set]] call CBA_fnc_globalEvent;
_unit setVariable [QGVAR(unconscious), _set, true];
_unit setVariable ["ACE_isUnconscious", _set, true]; // support for ace dragging and other ace features if enabled

true
