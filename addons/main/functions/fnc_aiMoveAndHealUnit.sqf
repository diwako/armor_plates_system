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
{_medic disableAI _x} forEach AI_MODES;
while {
    alive _unit && {(lifeState _unit) == 'INCAPACITATED' || {(_unit getVariable [QGVAR(hp), GVAR(maxPlayerHP)]) < ((_unit getVariable [QGVAR(maxHp), ([GVAR(maxAiHp),GVAR(maxPlayerHP)] select (isPlayer _unit))]) * GVAR(maxHealMedic))}} &&
    alive _medic && {(lifeState _medic) != 'INCAPACITATED'} &&
    (_unit distance _medic) > GVAR(holdActionRange)
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
} forEach _aiFeatures;
if !(alive _unit && {(lifeState _unit) == 'INCAPACITATED' || {(_unit getVariable [QGVAR(hp), GVAR(maxPlayerHP)]) < ((_unit getVariable [QGVAR(maxHp), ([GVAR(maxAiHp),GVAR(maxPlayerHP)] select (isPlayer _unit))]) * GVAR(maxHealMedic))}}) exitWith {
    _medic setVariable [QGVAR(hasHealRequest), nil, true];
};
if !(alive _medic && {(lifeState _medic) isNotEqualTo 'INCAPACITATED' && {(lifeState _unit) == 'INCAPACITATED'}}) exitWith {
    // medic just went down, request help for patient. medic will request due to getting downed
    [_unit] call FUNC(requestAIRevive);
    _medic setVariable [QGVAR(hasHealRequest), nil, true];
};

_medic forceSpeed 0;

private _isProne = stance _medic isEqualTo "PRONE";
_medic setVariable [QGVAR(wasProne), _isProne];
private _medicAnim = ["AinvPknlMstpSlayW[wpn]Dnon_medicOther", "AinvPpneMstpSlayW[wpn]Dnon_medicOther"] select _isProne;
private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _medic, secondaryWeapon _medic, handgunWeapon _medic] find currentWeapon _medic, "non"];
_medicAnim = [_medicAnim, "[wpn]", _wpn] call CBA_fnc_replace;
if (_medicAnim isNotEqualTo "") then {
    _medic playMove _medicAnim;
};

sleep 5;
//private _isMedic = _medic getUnitTrait "Medic";
//sleep ([GVAR(noneMedicReviveTime),GVAR(medicReviveTime)] select _isMedic);
if !(alive _medic && {(lifeState _medic) isNotEqualTo 'INCAPACITATED' && {(lifeState _unit) == 'INCAPACITATED'}}) exitWith {
    // medic just went down, request help for patient. medic will request due to getting downed
    [_unit] call FUNC(requestAIRevive);
    _medic setVariable [QGVAR(hasHealRequest), nil, true];
};

if ((lifeState _unit) isEqualTo 'INCAPACITATED') then {[_unit, _medic] call FUNC(revive);} else {_unit setDamage 0; [_unit, _medic, false] call FUNC(handleHealEh)};
_medic setVariable [QGVAR(hasHealRequest), nil, true];
sleep 3;
_medic doFollow leader _medic;
_medic forceSpeed -1;

private _group = group _medic;
private _queue = _group getVariable [QGVAR(reviveQueue), []];
if (_queue isNotEqualTo []) then {
    private _newPatient = _queue deleteAt 0;
    [_newPatient, _medic] call FUNC(aiMoveAndHealUnit);
    _group setVariable [QGVAR(reviveQueue), _queue, true];
};
