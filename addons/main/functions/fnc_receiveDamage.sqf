#include "script_component.hpp"
// [player, 2, "head", player] call diw_armor_plates_main_fnc_receiveDamage
params ["_unit", "_damage", "_bodyPart", "_instigator", "_ammo"];
if (_damage <= 0 || {!alive _unit}) exitWith {};

private _maxHp = _unit getVariable [QGVAR(maxHP), [GVAR(maxAiHP), GVAR(maxPlayerHP)] select (isPlayer _unit)];
private _curHp = _unit getVariable [QGVAR(hp), _maxHp];

if (_curHp <= 0 && {!GVAR(allowDownedDamage)}) exitWith {};

if (GVAR(disallowFriendfire) &&
    {!isNull _instigator && {
    _instigator isNotEqualTo _unit && {
    (side group _unit) isEqualTo (side group _instigator)}}}) exitWith {};

private _isHeadshot = false;
private _isTorso = false;
switch (_bodyPart) do {
    case "face_hub";
    case "face";
    case "head": {_isHeadshot = _damage > 0.5; _damage = _damage * GVAR(headshotMult)};
    case "neck": {_damage = _damage * GVAR(headshotMult)};
    case "arms";
    case "hands";
    case "pelvis": {_isTorso = true; _damage = _damage * GVAR(pelvisMult)};
    case "legs": {_damage = _damage * GVAR(limbMult)};
    case "vehicle";
    case "incapacitated";
    case "#structural";
    case "falldamage": {};
    default {_isTorso = true};
};

_damage = _damage * GVAR(damageCoef);
// if !(isMultiplayer) then {
//     systemChat format ["%1 DMG: %2 form %5 --> %3 | %4", name _unit, _damage, _bodyPart, diag_frameNo, name _instigator];
// };

private _player = call CBA_fnc_currentUnit;
private _returnedDamage = [_unit, _damage, _isTorso, _player, _ammo, _instigator] call FUNC(handleArmorDamage);
_damage = _returnedDamage select 0;
private _receivedDamage = _returnedDamage select 1;

if (GVAR(audioFeedback) > 0 && {_player isEqualTo _unit}) then {
    if (_isHeadshot) then {
        GVAR(lastHPDamageSound) = diag_frameNo;
        playsound format [QGVAR(headshot%1_%2), 1 + floor random 3, GVAR(audioFeedback)];
    } else {
        if (GVAR(lastHPDamageSound) isNotEqualTo diag_frameNo) then {
            GVAR(lastHPDamageSound) = diag_frameNo;
            playsound format [QGVAR(hit%1_%2), 1 + floor random 3, GVAR(audioFeedback)];
        };
    };
};

// no need to update unit health if there is no damage left
if (_damage isEqualTo 0) exitWith {};

private _newHP = (_curHp - _damage) max 0;
_unit setVariable [QGVAR(hp), [_newHP, 100] select GVAR(aceMedicalLoaded)];
if (_player isEqualTo _unit) then {
    [_unit] call FUNC(updateHPUi);
    if (!_receivedDamage && {GVAR(showDamageMarker)}) then {
        [_unit, _instigator, _damage] call FUNC(showDamageFeedbackMarker);
    };
};

if (_newHP isEqualTo 0) exitWith {
    private _lifestate = (lifeState _unit) != "INCAPACITATED";
    if (_lifestate) then {
        [QGVAR(downedMessage), [_unit], (units _unit) - [_unit]] call CBA_fnc_targetEvent;
        private _setUnconscious = (GVAR(enablePlayerUnconscious) && {isPlayer _unit}) ||
        {GVAR(enableAIUnconscious) && {!isPlayer _unit && {_unit in (units player)}}};

        if (_setUnconscious) then {
            if (_lifestate) then {
                [_unit, true] call FUNC(setUnconscious);
            };
            [_unit, 0, _maxHp, _instigator] call FUNC(setA3Damage);
        } else {
            // kill
            _unit setHitPointDamage ["hitHead", 1, true, _instigator];
        };
    } else {
        // damage to downed units
        private _downedHp = _unit getVariable [QGVAR(downedHp), _maxHp];
        private _newDownedHP = (_downedHp - _damage) max 0;
        _unit setVariable [QGVAR(downedHp), _newDownedHP];
        if (_downedHp isEqualTo 0) then {
            _unit setHitPointDamage ["hitHead", 1, true, _instigator];
        };
    };
};

[_unit, _newHp, _maxHp, _instigator] call FUNC(setA3Damage);
[_unit] call FUNC(startHpRegen);
