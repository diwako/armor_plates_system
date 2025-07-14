#include "script_component.hpp"
// [player, 2, "head", player] call diw_armor_plates_main_fnc_receiveDamage
params ["_unit", "_damage", "_bodyPart", "_instigator", "_ammo", ["_ignoreArmor",false]];
if (_damage <= 0 || {!alive _unit}) exitWith {};

private _maxHp = _unit getVariable [QGVAR(maxHP), [GVAR(maxAiHP), GVAR(maxPlayerHP)] select (isPlayer _unit)];
private _curHp = _unit getVariable [QGVAR(hp), _maxHp];
private _downDamage = GVAR(allowDownedDamage);

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
private _returnedDamage = [_damage,false];
if (!_ignoreArmor) then {_returnedDamage = [_unit, _damage, _isTorso, _player, _ammo, _instigator] call FUNC(handleArmorDamage)};
_damage = _returnedDamage select 0;
private _receivedDamage = _returnedDamage select 1;

if (GVAR(audioFeedback) > 0 && {_player isEqualTo _unit}) then {
    if (_isHeadshot) then {
        GVAR(lastHPDamageSound) = diag_frameNo;
        playSound format [QGVAR(headshot%1_%2), 1 + floor random 3, GVAR(audioFeedback)];
    } else {
        if (GVAR(lastHPDamageSound) isNotEqualTo diag_frameNo) then {
            GVAR(lastHPDamageSound) = diag_frameNo;
            playSound format [QGVAR(hit%1_%2), 1 + floor random 3, GVAR(audioFeedback)];
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
    private _setUnconscious = (GVAR(enablePlayerUnconscious) && {isPlayer _unit}) ||
        {GVAR(enableAIUnconscious) && {!isPlayer _unit && {_unit in (units player)}}};
    if (_lifestate) then {
        [QGVAR(downedMessage), [_unit], (units _unit) - [_unit]] call CBA_fnc_targetEvent;

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
        if (_downDamage isEqualTo 0) exitWith {
            // catch in case other scripts or mods use setUnconscious
            if (_setUnconscious) then {
                if !(_unit getVariable [QGVAR(unconscious), false]) then {
                    [_unit, true] call FUNC(setUnconscious);
                };
            } else {
                _unit setHitPointDamage ["hitHead", 1, true, _instigator];
            };
        };
        private _downedHits = 0;
        if (_downDamage > 1) then {
            _downedHits = ((_unit getVariable [QGVAR(downedHits),0]) + 1);
            _unit setVariable [QGVAR(downedHits), _downedHits];
        };
        if (_downDamage == 2 && {_downedHits < GVAR(downedDamageHits)}) exitWith {};
        private _downedHp = _unit getVariable [QGVAR(downedHp), (_maxHp * GVAR(downedDamageHP))];
        private _newDownedHP = (_downedHp - _damage) max 0;
        _unit setVariable [QGVAR(downedHp), _newDownedHP];
        if (_downedHits >= GVAR(downedDamageHits) || {_newDownedHP isEqualTo 0}) then {
            _unit setHitPointDamage ["hitHead", 1, true, _instigator];
        };
    };
};

[_unit, _newHp, _maxHp, _instigator] call FUNC(setA3Damage);
[_unit] call FUNC(startHpRegen);
