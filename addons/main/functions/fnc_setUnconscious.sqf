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
            if ((_unit getVariable [QGVAR(bleedoutTime), -1]) isEqualTo _time) then {
                // kill them
                _unit setDamage 1;
            };
        }, [_unit, cba_missionTime], GVAR(bleedoutTime)] call CBA_fnc_waitAndExecute;
    };
} else {
    _unit setVariable [QGVAR(bleedoutTime), nil];
};

_unit setUnconscious _set;
[QGVAR(setHidden), [_unit , _set]] call CBA_fnc_globalEvent;
_unit setVariable [QGVAR(unconscious), _set, true];

true
