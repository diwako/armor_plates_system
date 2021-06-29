#include "script_component.hpp"
#define AI_MODES ["AUTOCOMBAT", "COVER", "SUPPRESSION", "TARGET", "AUTOTARGET"]
params ["_unit", "_medic"];

if !(local _medic) exitWith {
    [QGVAR(requestAIRevive), _this, _medic] call CBA_fnc_targetEvent;
};

if !(canSuspend) exitWith {
    _this spawn FUNC(aiMoveAndHealUnit);
};

private _aiFeatures = AI_MODES apply {[_x, _medic checkAIFeature _x]};
_medic setVariable [QGVAR(hasHealRequest), true, true];
_medic forceSpeed (_medic getSpeed "FAST");
_medic doMove getPosATL _unit;
_medic setUnitPos "AUTO";
{_medic disableAI _x} foreach AI_MODES;
while {
    alive _unit && {(lifeState _unit) == 'INCAPACITATED'} &&
    alive _medic && {(lifeState _medic) != 'INCAPACITATED'} &&
    (_unit distance _medic) > 3.5
} do {
    if (speed _medic < 3) then {
        _medic forceSpeed (_medic getSpeed "FAST");
        _medic doMove getPosATL _unit;
        _medic setUnitPos "AUTO";
        sleep 2;
    };
    sleep 1;
};

{
    if (_x select 1) then {
        _medic enableAI (_x select 0);
    };
} foreach _aiFeatures;
if !(alive _unit && {(lifeState _unit) == 'INCAPACITATED'}) exitWith {
    _medic setVariable [QGVAR(hasHealRequest), nil, true];
};
if !(alive _medic && {(lifeState _medic) != 'INCAPACITATED'}) exitWith {
    // medic just went down, request help for patient. medic will request due to getting downed
    [_unit] call FUNC(requestAIRevive);
    _medic setVariable [QGVAR(hasHealRequest), nil, true];
};

_medic forceSpeed 0;

private _isProne = stance _medic == "PRONE";
_medic setVariable [QGVAR(wasProne), _isProne];
private _medicAnim = ["AinvPknlMstpSlayW[wpn]Dnon_medicOther", "AinvPpneMstpSlayW[wpn]Dnon_medicOther"] select _isProne;
private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _medic, secondaryWeapon _medic, handgunWeapon _medic] find currentWeapon _medic, "non"];
_medicAnim = [_medicAnim, "[wpn]", _wpn] call CBA_fnc_replace;
if (_medicAnim != "") then {
    _medic playMove _medicAnim;
};

sleep 5;
_unit setDamage 0;
[_unit, _medic] call FUNC(handleHealEh);
_medic setVariable [QGVAR(hasHealRequest), nil, true];
sleep 3;
_medic doFollow leader _medic;
_medic forceSpeed -1;
