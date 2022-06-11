#include "script_component.hpp"
params ["_unit"];
/*
    Credit to MajorDanvers
    Slowly regenerates bleedout timer, faster when closer to death
    2 minutes to regen last down to second last
    15 minutes to regen first down
    For coeff == 1, 1 second regenerated per duration of bleedout timer
*/

// If player has not gone down or has fully recovered, wait until they are down
if (isNil QGVAR(bleedOutTimeMalus)) then {
    [
        {
            !isNil QGVAR(bleedOutTimeMalus) && {!(_unit getVariable [QGVAR(unconscious),false])}
        },
        FUNC(regenBleedout), [_unit]
    ] call CBA_fnc_waitUntilAndExecute;
} else {
    // Every _nextRegen seconds, increase down timer by 1 second (reduce malus by 1 second)
    private _nextRegen = (GVAR(bleedoutTime) - GVAR(bleedOutTimeMalus) - GVAR(bleedoutTimeSubtraction)) / GVAR(bleedoutRegenCoeff); // d(malus)/d(time) = 1/60 when malus = 0
    [
        {
            if !(_unit getVariable [QGVAR(unconscious),false]) then {
                GVAR(bleedOutTimeMalus) = GVAR(bleedOutTimeMalus) - 1;
                if (GVAR(bleedOutTimeMalus) <= (-1 * GVAR(bleedoutTimeSubtraction))) then {GVAR(bleedOutTimeMalus) = nil};
            };
            [_unit] call FUNC(regenBleedout);
        },
        nil,
        _nextRegen
    ] call CBA_fnc_waitAndExecute;
};
