#include "script_component.hpp"
params ["_unit", "_damage", "_bodyPart", "_instigator"];
if (_damage <= 0 || {!alive _unit}) exitWith {};

switch (_bodyPart) do {
    // case "neck";
    case "face_hub";
    case "face";
    case "head": { _damage = _damage * GVAR(headshotMult) };
    case "arms";
    case "hands";
    case "legs": { _damage = _damage * GVAR(limbMult) };
    default {};
};

_damage = _damage * GVAR(damageCoef);
systemChat format ["%1 DMG: %2 --> %3 | %4", name _unit, _damage, _bodyPart, diag_frameNo];

private _plates = (vestContainer _unit) getVariable [QGVAR(plates), []];
if (_plates isNotEqualTo []) then {
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
        };
    };
    _unit setVariable [QGVAR(plates), _plates];
    if ((call CBA_fnc_currentUnit) isEqualTo _unit) then {
        [_unit] call FUNC(updatePlateUi);
    };
};

[_unit] call FUNC(startHpRegen);

// no need to update unit health if there is no damage left
if (_damage isEqualTo 0) exitWith {};

private _curHp = _unit getVariable [QGVAR(hp), GVAR(maxUnitHP)];
private _newHP = (_curHp - _damage) max 0;
_unit setVariable [QGVAR(hp), _newHP];
if ((call CBA_fnc_currentUnit) isEqualTo _unit) then {
    [_unit] call FUNC(updateHPUi);
};

if (_newHP isEqualTo 0) exitWith {
    if (GVAR(enablePlayerUnconscious) && {isPlayer _unit}) then {
        if !((lifeState _unit) == "INCAPACITATED") then {
            _unit setUnconscious true;
            _unit setCaptive true;
            _unit setVariable [QGVAR(unconscious), true, true];
        };
        _unit setDamage 0.95;
    } else {
        _unit setDamage 1;
    };
};

_unit setDamage (1 - (_newHP / GVAR(maxUnitHP))) min 0.45;
