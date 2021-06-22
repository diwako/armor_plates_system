#include "script_component.hpp"
params ["_unit", "_damage", "_bodyPart", "_instigator", "_ammo"];
if (_damage <= 0 || {!alive _unit}) exitWith {0};

if (GVAR(disallowFriendfire) &&
    {!isNull _instigator && {
    _instigator isNotEqualTo _unit && {
    (side group _unit) isEqualTo (side group _instigator)}}}) exitWith {-1};

// if !(isMultiplayer) then {
//     systemChat format ["%1 DMG: %2 form %5 --> %3 | %4", name _unit, _damage, _bodyPart, diag_frameNo, name _instigator];
// };

private _caliber = getNumber (configFile >> "CfgAmmo" >> _ammo >> "ACE_Caliber");
private _mass = getNumber (configFile >> "CfgAmmo" >> _ammo >> "ACE_bulletMass");
systemChat str _mmPenned;

private _player = call CBA_fnc_currentUnit;
private _receivedDamage = false;
private _plates = (vestContainer _unit) getVariable [QGVAR(plates), []];
if (_bodyPart isEqualTo "Body" && {_plates isNotEqualTo []}) then {
    for "_i" from ((count _plates) - 1) to 0 step -1 do {
        private _plateIntegrity = _plates select _i;
        private _newDamage = _plateIntegrity - _damage;
        private _pennDamage = 0;
        private _mmPenned = _damage * _caliber * _mass / GVAR(plateThickness);
        if (_mmPenned > 1) then {
            // plate was penetrated!
            _pennDamage = _damage * ((_mmPenned - 1) min 0.5);
            systemChat format ["PENNED! %1 | %2", _mmPenned, _pennDamage];
        };
        if (_newDamage > 0) then {
            // plate managed to soak the damage
            _plates set [_i, _newDamage];
            _damage = _pennDamage;
        } else {
            // the plate shattered
            _damage = (abs _newDamage) + _pennDamage;
            _plates deleteAt _i;

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
    if (GVAR(lastHPDamageSound) isNotEqualTo diag_frameNo) then {
        GVAR(lastHPDamageSound) = diag_frameNo;
        playsound format [QGVAR(hit%1_%2), 1 + floor random 3, GVAR(audioFeedback)];
    };
};

_damage
