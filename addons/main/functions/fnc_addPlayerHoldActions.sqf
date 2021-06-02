#include "script_component.hpp"
[
    player,
    "Give up",
    "\A3\Ui_f\data\IGUI\Cfg\Revive\overlayIcons\d50_ca.paa",
    "\A3\Ui_f\data\IGUI\Cfg\Revive\overlayIcons\d100_ca.paa",
    "alive _target && {(lifeState _target) == 'INCAPACITATED' && {_target isEqualTo (call CBA_fnc_currentUnit)}}",
    "alive _target",
    {},
    {},{
        params ["_target", ""];
        _target setDamage 1;
    },
    {},
    [],
    3,
    1000,
    true,
    true
] call BIS_fnc_holdActionAdd;
