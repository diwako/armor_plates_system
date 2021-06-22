#include "script_component.hpp"
#include "\z\ace\addons\medical_engine\script_macros_medical.hpp"

#define PRIORITY_HEAD       3
#define PRIORITY_BODY       4
#define PRIORITY_LEFT_ARM   (1 + random 1)
#define PRIORITY_RIGHT_ARM  (1 + random 1)
#define PRIORITY_LEFT_LEG   (1 + random 1)
#define PRIORITY_RIGHT_LEG  (1 + random 1)

params ["_unit", "_selection", "_damage", "_shooter", "_ammo", "_hitPointIndex", "_instigator", "_hitpoint"];
if !(local _unit) exitWith {nil};

private _curDamage = 0;
if (_hitPoint isEqualTo "") then {
    _hitPoint = "#structural";
    _curDamage = damage _unit;
} else {
    _curDamage = _unit getHitIndex _hitPointIndex;
};

if (!isDamageAllowed _unit || {_hitPoint in ["hithead", "hitbody", "hithands", "hitlegs"] || {_unit getVariable ["ace_medical_allowDamage", false]}}) exitWith {_curDamage};

private _newDamage = _damage - _curDamage;
if (_newDamage isEqualTo 0) exitWith {
    _curDamage
};

private _armor = [_unit, _hitpoint] call ace_medical_engine_fnc_getHitpointArmor;
private _realDamage = _newDamage * _armor;
_unit setVariable [format ["ace_medical_engine_$%1", _hitPoint], [_realDamage, _newDamage]];

if (_hitPoint isEqualTo "ace_hdbracket") exitWith {
    if (_ammo isEqualTo "") exitWith {
        // let ace do the thing
        _this call ace_medical_engine_fnc_handleDamage;
        0;
    };

    // write hitpoint damage to unit var

    private _damageStructural = _unit getVariable ["ace_medical_engine_$#structural", 0];

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
        _damageHead     + [PRIORITY_HEAD,      "Head"],
        _damageBody     + [PRIORITY_BODY,      "Body"],
        _damageLeftArm  + [PRIORITY_LEFT_ARM,  "LeftArm"],
        _damageRightArm + [PRIORITY_RIGHT_ARM, "RightArm"],
        _damageLeftLeg  + [PRIORITY_LEFT_LEG,  "LeftLeg"],
        _damageRightLeg + [PRIORITY_RIGHT_LEG, "RightLeg"]
    ];

    // represents all incoming damage for selecting a non-selectionSpecific wound location, (used for selectRandomWeighted [value1,weight1,value2....])
    private _damageSelectionArray = [
        HITPOINT_INDEX_HEAD, _damageHead select 1, HITPOINT_INDEX_BODY, _damageBody select 1, HITPOINT_INDEX_LARM, _damageLeftArm select 1,
        HITPOINT_INDEX_RARM, _damageRightArm select 1, HITPOINT_INDEX_LLEG, _damageLeftLeg select 1, HITPOINT_INDEX_RLEG, _damageRightLeg select 1
    ];

    _allDamages sort false;
    (_allDamages select 0) params ["", "_receivedDamage", "", "_woundedHitPoint"];
    private _receivedDamageHead = _damageHead select 1;
    if (_receivedDamageHead >= HEAD_DAMAGE_THRESHOLD) then {
        _receivedDamage = _receivedDamageHead;
        _woundedHitPoint = "Head";
    };

    // We know it's structural when no specific hitpoint is damaged
    if (_receivedDamage == 0) then {
        _receivedDamage = _damageStructural select 1;
        _woundedHitPoint = "Body";
        _damageSelectionArray = [1, 1]; // sum of weights would be 0
    };

    if (_woundedHitPoint isNotEqualTo "Body") exitWith {
        // let ace do the thing
        _unit setVariable [format ["ace_medical_engine_$%1", _hitPoint], nil];
        _this call ace_medical_engine_fnc_handleDamage;
        0
    };

     // No wounds for minor damage
    if (_receivedDamage > 1E-3) then {
        // APS code begin

        private _damageLeft = [_unit, _receivedDamage, _woundedHitPoint, [_instigator, _shooter] select (isNull _instigator), _ammo] call FUNC(receiveDamageACE);
        // private _bodyArmor = [player, "HitBody"] call ace_medical_engine_fnc_getHitpointArmor;
        // _damageLeft = _damageLeft / _bodyArmor;

        _unit setVariable ["ace_medical_engine_$HitBody", [_realDamage, _newDamage]];

        systemChat format ["D %1 | L %2 | %3", _receivedDamage, _damageLeft, _damageSelectionArray];

        // APS code end

        // ["ace_medical_woundReceived", [_unit, _woundedHitPoint, _damageLeft, _shooter, _ammo, _damageSelectionArray]] call CBA_fnc_localEvent;
    };

    // Clear stored damages otherwise they will influence future damage events
    // (aka wounds will pile onto the historically most damaged hitpoint)
    {
        _unit setVariable [_x, nil];
    } forEach [
        "ace_medical_engine_$HitFace","ace_medical_engine_$HitNeck","ace_medical_engine_$HitHead",
        "ace_medical_engine_$HitPelvis","ace_medical_engine_$HitAbdomen","ace_medical_engine_$HitDiaphragm","ace_medical_engine_$HitChest","ace_medical_engine_$HitBody",
        "ace_medical_engine_$HitLeftArm","ace_medical_engine_$HitRightArm","ace_medical_engine_$HitLeftLeg","ace_medical_engine_$HitRightLeg"
    ];

    0
};

// Drowning doesn't fire the EH for each hitpoint
// Damage occurs in consistent increments
if (
    _hitPoint isEqualTo "#structural" &&
    {getOxygenRemaining _unit <= 0.5} &&
    {_damage isEqualTo (_curDamage + 0.005)}
) exitWith {
    // let ace do the thing
    _this call ace_medical_engine_fnc_handleDamage;
    0
};

// Crashing a vehicle doesn't fire the EH for each hitpoint so the "ace_hdbracket" code never runs
// It does fire the EH multiple times, but this seems to scale with the intensity of the crash
private _vehicle = vehicle _unit;
if (
    _hitPoint isEqualTo "#structural" &&
    {_ammo isEqualTo ""} &&
    {_vehicle != _unit} &&
    {vectorMagnitude (velocity _vehicle) > 5}
) exitWith {
    // let ace do the thing
    _this call ace_medical_engine_fnc_handleDamage;
    0
};

0
