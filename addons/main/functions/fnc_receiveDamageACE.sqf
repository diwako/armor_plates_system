#include "script_component.hpp"
params ["_unit", "_damage", "_actualDamage", "_instigator", "_ammo"];
if (_damage <= 0 || {!alive _unit}) exitWith {0};

private _initialActualDamage = _actualDamage;
private _player = call CBA_fnc_currentUnit;
private _plates = (vestContainer _unit) getVariable [QGVAR(plates), []];
if (_plates isNotEqualTo []) then {
    private _caliber = getNumber (configFile >> "CfgAmmo" >> _ammo >> "ACE_Caliber");
    private _mass = getNumber (configFile >> "CfgAmmo" >> _ammo >> "ACE_bulletMass");
    for "_i" from ((count _plates) - 1) to 0 step -1 do {
        private _plateIntegrity = _plates select _i;
        private _newDamage = _plateIntegrity - _actualDamage;
        private _pennDamage = 0;
        private _mmPenned = (_actualDamage * _caliber * _mass) * (125 / 1000);
        if (_mmPenned > GVAR(plateThickness)) then {
            // plate was penetrated!
            _pennDamage = _actualDamage * (1 - (GVAR(plateThickness) / _mmPenned));
        };
        if (_newDamage > 0) then {
            // plate managed to soak the damage
            _plates set [_i, _newDamage / (GVAR(maxPlateHealth) / _plateIntegrity)];
            _actualDamage = _pennDamage;
        } else {
            // the plate shattered
            _actualDamage = (abs _newDamage) + _pennDamage;
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
    };
};

if (GVAR(audioFeedback) > 0 && {_player isEqualTo _unit}) then {
    if (GVAR(lastHPDamageSound) isNotEqualTo diag_frameNo) then {
        GVAR(lastHPDamageSound) = diag_frameNo;
        playsound format [QGVAR(hit%1_%2), 1 + floor random 3, GVAR(audioFeedback)];
    };
};

_damage * (_actualDamage / _initialActualDamage)
