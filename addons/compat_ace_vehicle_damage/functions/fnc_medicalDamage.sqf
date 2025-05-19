#include "..\script_component.hpp"
/*
 * Author: johnb43
 * Applies medical damage to a unit.
 *
 * Arguments:
 * 0: Target <OBJECT>
 * 1: Source <OBJECT>
 * 2: Instigator <OBJECT>
 * 3: Guarantee death? <BOOL> (default: false)
 *
 * Return Value:
 * None
 *
 * Example:
 * [cursorObject, player, player] call ace_vehicle_damage_fnc_medicalDamage;
 *
 * Public: No
 */

params ["_unit", "_source", "_instigator", ["_guaranteeDeath", false]];

// Check if unit is invulnerable
if !(isDamageAllowed _unit && {_unit getVariable ["ace_medical_allowDamage", true]}) exitWith {};

if (missionNamespace getVariable ["ace_medical_enabled", false]) then {
    for "_i" from 0 to floor (4 + random 3) do {
        private _damage = random [0, 0.66, 1];
        private _selection = selectRandom ["Head", "Body", "LeftArm", "RightArm", "LeftLeg", "RightLeg"];
        private _isTorso = (_selection isEqualTo "Body");
        private _damageLeft = [_unit,  _damage, _damage, _instigator, "", _isTorso] call EFUNC(main,receiveDamageACE);
        [_unit, _damageLeft, _selection, selectRandom ["bullet", "shell", "explosive"], _instigator] call ace_medical_fnc_addDamageToUnit;
    };
} else {
    if (EGVAR(main,enable)) exitWith {
        for "_i" from 0 to floor (4 + random 3) do {
            [_unit,  random [0, 0.66, 1], selectRandom ["HitFace", "HitNeck", "HitHead", "HitPelvis", "HitAbdomen", "HitDiaphragm", "HitChest", "HitBody", "HitArms", "HitHands", "HitLegs"], _instigator] call EFUNC(main,receiveDamage);
        };
    };
    {
        _unit setHitPointDamage [_x, (_unit getHitPointDamage _x) + random [0, 0.66, 1], true, _source, _instigator];
    } forEach ["HitFace", "HitNeck", "HitHead", "HitPelvis", "HitAbdomen", "HitDiaphragm", "HitChest", "HitBody", "HitArms", "HitHands", "HitLegs"];
};

// If guaranteed death is wished
if (!GVAR(preventScriptedDeath) && {_guaranteeDeath && {alive _unit}}) then {
    [_unit, "ace_vehicle_damage_medicalDamage", _source, _instigator] call ace_common_fnc_setDead;
};