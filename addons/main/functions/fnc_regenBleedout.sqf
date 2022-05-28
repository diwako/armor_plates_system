/*
    Credit to MajorDanvers
    Slowly regenerates bleedout timer, faster when closer to death
    2 minutes to regen last down to second last
    15 minutes to regen first down
    For coeff == 1, 1 second regenerated per duration of bleedout timer
*/
#include "script_component.hpp"
params ["_unit"];

#define malus GVAR(bleedOutTimeMalus)
#define bleedout GVAR(bleedoutTime)
#define subtraction GVAR(bleedoutTimeSubtraction)
#define coeff GVAR(bleedoutRegenCoeff)

// If player has not gone down or has fully recovered, wait until they are down
if (isNil {malus}) then {
    [
        {
            !isNil {malus} && {!(_unit getVariable [QGVAR(unconscious),false])}
        },
        FUNC(regenBleedout), [_unit]
    ] call CBA_fnc_waitUntilAndExecute;
}
else {
    // Every _nextRegen seconds, increase down timer by 1 second (reduce malus by 1 second)
    private _nextRegen = (bleedout - malus - subtraction) / coeff; // d(malus)/d(time) = 1/60 when malus = 0
    [
        {
            if (!(_unit getVariable [QGVAR(unconscious),false]) && GVAR(enableBleedoutTimerRegen)) then {
                malus = malus - 1;
                if (malus <= (-1 * subtraction)) then {malus = nil};
            };
            [_unit] call FUNC(regenBleedout);
        },
        nil,
        _nextRegen
    ] call CBA_fnc_waitAndExecute;
};

