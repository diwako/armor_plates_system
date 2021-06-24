#include "script_component.hpp"
params ["_unit", "_damage", "_bodyPart", "_instigator"];
if (_damage <= 0 || {!alive _unit}) exitWith {};

private _maxHp = [GVAR(maxAiHP), GVAR(maxPlayerHP)] select (isPlayer _unit);
private _curHp = _unit getVariable [QGVAR(hp), _maxHp];

if (_curHp <= 0) exitWith {};

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
    case "arms";
    case "hands";
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
private _receivedDamage = false;
private _vest = vestContainer _unit;
private _plates = _vest getVariable [QGVAR(plates), []];
if (_plates isNotEqualTo []) then {
    // exit out and let rest of function handle the remaining damage
    // if torso was not hit and plates are set to only protect the torso
    if (!_isTorso && {GVAR(protectOnlyTorso)}) exitWith {};
    for "_i" from ((count _plates) - 1) to 0 step -1 do {
        private _plateIntegrity = _plates select _i;
        private _newDamage = _plateIntegrity - _damage;
        if (_newDamage > 0) then {
            // plate managed to soak the damage
            _plates set [_i, _newDamage];
            _damage = 0;
            break;
        } else {
            // the plate shattered bleeding damage into lower plates
            _damage = abs _newDamage;
            _plates deleteAt _i;
            _vest setVariable ["ace_movement_vLoad", 0 max ((_vest getVariable ["ace_movement_vLoad", 0]) - PLATE_MASS), true];

            if (_player isEqualTo _unit && {GVAR(audioFeedback) > 0 && {GVAR(lastPlateBreakSound) isNotEqualTo diag_frameNo}}) then {
                GVAR(lastPlateBreakSound) = diag_frameNo;
                playsound format [QGVAR(platebreak%1_%2), 1 + floor random 3, GVAR(audioFeedback)];
            };
        };
    };
    _unit setVariable [QGVAR(plates), _plates];
    if (_player isEqualTo _unit) then {
        [_unit] call FUNC(updatePlateUi);
        if (GVAR(showDamageMarker)) then {
            [_unit, _instigator, _damage] call FUNC(showDamageFeedbackMarker);
        };
        _receivedDamage = true;
    };
};

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
    [QGVAR(downedMessage), [_unit], (units _unit) - [_unit]] call CBA_fnc_targetEvent;
    if (GVAR(enablePlayerUnconscious) && {isPlayer _unit}) then {
        if !((lifeState _unit) == "INCAPACITATED") then {
            [_unit, true] call FUNC(setUnconscious);
        };
        [_unit, 0, _maxHp] call FUNC(setA3Damage);
    } else {
        // kill
        _unit setDamage 1;
    };
};

[_unit, _newHp, _maxHp] call FUNC(setA3Damage);
[_unit] call FUNC(startHpRegen);
