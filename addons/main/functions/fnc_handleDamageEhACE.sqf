#include "script_component.hpp"
#include "\z\ace\addons\medical_engine\script_macros_medical.hpp"

#define PRIORITY_HEAD       3
#define PRIORITY_BODY       4
#define PRIORITY_LEFT_ARM   (1 + random 1)
#define PRIORITY_RIGHT_ARM  (1 + random 1)
#define PRIORITY_LEFT_LEG   (1 + random 1)
#define PRIORITY_RIGHT_LEG  (1 + random 1)
#define PRIORITY_STRUCTURAL 1

params ["_unit", "", "_damage", "_shooter", "_ammo", "_hitPointIndex", "_instigator", "_hitpoint"];
if !(local _unit) exitWith {nil};
if !(GVAR(showDamageMarker) && {(call CBA_fnc_currentUnit) isEqualTo _unit}) exitWith {};
private _oldDamage = 0;

if (_hitPoint isEqualTo "") then {
    _hitPoint = "#structural";
    _oldDamage = damage _unit;
} else {
    _oldDamage = _unit getHitIndex _hitPointIndex;
};

if (!isDamageAllowed _unit || {!(_unit getVariable ["ace_medical_allowDamage", true])}) exitWith {
    nil
};

if (GVAR(disallowFriendfire) &&
    {!isNull _shooter && {
    _shooter isNotEqualTo _unit && {
    (side group _unit) isEqualTo (side group _shooter)}}}) exitWith {
    nil
};

private _newDamage = _damage - _oldDamage;
if (_hitPoint isNotEqualTo "ace_hdbracket" && {_newDamage isEqualTo 0 || {_newDamage < 1E-3}}) exitWith {
    nil
};

// drowning
if (
    _hitPoint isEqualTo "#structural" &&
    {getOxygenRemaining _unit <= 0.5} &&
    {_damage isEqualTo (_oldDamage + 0.005)}
) exitWith {
    nil
};

// car crash
private _vehicle = vehicle _unit;
if (
    ace_medical_enableVehicleCrashes &&
    {_hitPoint isEqualTo "#structural"} &&
    {_ammo isEqualTo ""} &&
    {_vehicle != _unit} &&
    {vectorMagnitude (velocity _vehicle) > 5}
) exitWith {
    nil
};


if (_hitPoint isEqualTo "ace_hdbracket") exitWith {
    if (_ammo isEqualTo "" || {
        !GVAR(showDamageMarker) || {
        (call CBA_fnc_currentUnit) isNotEqualTo _unit
    }}) exitWith {
        nil
    };

    private _damageStructural = _unit getVariable ["ace_medical_engine_$#structural", [0,0]];

    // --- Head
    private _damageHead = [
        _unit getVariable ["ace_medical_engine_$HitFace", [0,0]],
        _unit getVariable ["ace_medical_engine_$HitNeck", [0,0]],
        _unit getVariable ["ace_medical_engine_$HitHead", [0,0]]
    ];
    _damageHead sort false;
    _damageHead = _damageHead select 0;

    // --- Body
    private _damageBody = [
        _unit getVariable ["ace_medical_engine_$HitPelvis", [0,0]],
        _unit getVariable ["ace_medical_engine_$HitAbdomen", [0,0]],
        _unit getVariable ["ace_medical_engine_$HitDiaphragm", [0,0]],
        _unit getVariable ["ace_medical_engine_$HitChest", [0,0]]
        // HitBody removed as it's a placeholder hitpoint and the high armor value (1000) throws the calculations off
    ];
    _damageBody sort false;
    _damageBody = _damageBody select 0;

    // --- Arms and Legs
    private _damageLeftArm = _unit getVariable ["ace_medical_engine_$HitLeftArm", [0,0]];
    private _damageRightArm = _unit getVariable ["ace_medical_engine_$HitRightArm", [0,0]];
    private _damageLeftLeg = _unit getVariable ["ace_medical_engine_$HitLeftLeg", [0,0]];
    private _damageRightLeg = _unit getVariable ["ace_medical_engine_$HitRightLeg", [0,0]];

    // Find hit point that received the maxium damage
    // Priority used for sorting if incoming damage is equivalent (e.g. max which is 4)
    private _allDamages = [
        [_damageHead select 0,       PRIORITY_HEAD,       _damageHead select 1,       "Head"],
        [_damageBody select 0,       PRIORITY_BODY,       _damageBody select 1,       "Body"],
        [_damageLeftArm select 0,    PRIORITY_LEFT_ARM,   _damageLeftArm select 1,    "LeftArm"],
        [_damageRightArm select 0,   PRIORITY_RIGHT_ARM,  _damageRightArm select 1,   "RightArm"],
        [_damageLeftLeg select 0,    PRIORITY_LEFT_LEG,   _damageLeftLeg select 1,    "LeftLeg"],
        [_damageRightLeg select 0,   PRIORITY_RIGHT_LEG,  _damageRightLeg select 1,   "RightLeg"],
        [_damageStructural select 0, PRIORITY_STRUCTURAL, _damageStructural select 1, "#structural"]
    ];

    _allDamages sort false;
    _allDamages = _allDamages apply {[_x select 2, _x select 3, _x select 0]};

    (_allDamages select 0) params ["_receivedDamage", "_woundedHitPoint"];
    if (_receivedDamage > 1E-3) then {
        [_unit, [_instigator, _shooter] select (isNull _instigator), _newDamage] call FUNC(showDamageFeedbackMarker);
    };

    nil
};

nil
