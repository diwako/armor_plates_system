#include "script_component.hpp"
params ["_unit", "_damage", "_isTorso", "_player", "_ammo", "_instigator"];

private _receivedDamage = false;
private _vest = vestContainer _unit;
private _plates = _vest getVariable [QGVAR(plates), []];
if (_plates isEqualTo [] || {!_isTorso && {GVAR(protectOnlyTorso)}}) exitWith {[_damage, _receivedDamage]};

switch (GVAR(armorHandlingMode)) do {
    case "arcade": {
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
                    playSound format [QGVAR(platebreak%1_%2), 1 + floor random 3, GVAR(audioFeedback)];
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
    case "realism": {
        private _penetrationMult = GVAR(ammoPenCache) getOrDefault [_ammo, -1];
        if (_penetrationMult isEqualTo -1) then {
            // cache multiplier
            private _caliber = getNumber (configFile >> "CfgAmmo" >> _ammo >> "ACE_Caliber");
            private _mass = getNumber (configFile >> "CfgAmmo" >> _ammo >> "ACE_bulletMass");
            if (_caliber isEqualTo 0) then {
                // handle none ace configured bullets
                _caliber = getNumber (configFile >> "CfgAmmo" >> _ammo >> "caliber");
                _mass = (getNumber (configFile >> "CfgAmmo" >> _ammo >> "hit")) / 2;
            };
            _penetrationMult = _caliber * _mass;
            GVAR(ammoPenCache) set [_ammo, _penetrationMult];
        };
        for "_i" from ((count _plates) - 1) to 0 step -1 do {
            private _plateIntegrity = _plates select _i;
            private _newDamage = _plateIntegrity - _damage;
            private _pennDamage = 0;
            private _mmPenned = (_damage * _penetrationMult) * (125 / 1000);
            if (_mmPenned > GVAR(plateThickness)) then {
                // plate was penetrated!
                _pennDamage = _damage * (1 - (GVAR(plateThickness) / _mmPenned));
            };
            if (_newDamage > 0) then {
                // plate managed to soak the damage
                _plates set [_i, _newDamage / (GVAR(maxPlateHealth) / _plateIntegrity)];
                _damage = _pennDamage;
            } else {
                // the plate shattered
                _damage = (abs _newDamage) + _pennDamage;
                _plates deleteAt _i;
                _vest setVariable ["ace_movement_vLoad", 0 max ((_vest getVariable ["ace_movement_vLoad", 0]) - PLATE_MASS), true];

                if (_player isEqualTo _unit && {GVAR(audioFeedback) > 0 && {GVAR(lastPlateBreakSound) isNotEqualTo diag_frameNo}}) then {
                    GVAR(lastPlateBreakSound) = diag_frameNo;
                    playSound format [QGVAR(platebreak%1_%2), 1 + floor random 3, GVAR(audioFeedback)];
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
    default {
        // unhandled
    };
};

[_damage, _receivedDamage]
