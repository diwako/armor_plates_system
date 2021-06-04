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
            if ((_unit getVariable [QGVAR(bleedoutTime), -1]) isEqualTo _time && {(lifeState _unit) == "INCAPACITATED"}) then {
                // kill them
                [_unit, false] call FUNC(setUnconscious);
                _unit setDamage 1;
            } else {
                if (_unit getVariable [QGVAR(unconscious), false]) then {
                    // not sure what happened? Mission interfering?!
                    [_unit, false] call FUNC(setUnconscious);
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

true
