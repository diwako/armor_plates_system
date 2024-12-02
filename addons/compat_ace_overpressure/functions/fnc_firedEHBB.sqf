#include "..\script_component.hpp"
/*
 * Author: joko // Jonas
 * Handle fire of local launchers. Called from the unified fired EH only for the local player.
 *
 * Arguments:
 * None. Parameters inherited from EFUNC(common,firedEH)
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, "launch_RPG32_F", "launch_RPG32_F", "Single", "R_PG32V_F", "RPG32_F", projectile] call ace_overpressure_fnc_firedEHBB;
 *
 * Public: No
 */

//IGNORE_PRIVATE_WARNING ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
//TRACE_8("firedEH:",_unit,_weapon,_muzzle,_mode,_ammo,_magazine,_projectile,_gunner);

// Retrieve backblast values
private _bbValues = [_weapon, _ammo, _magazine] call ace_overpressure_fnc_getOverPressureValues;

_bbValues params ["_backblastAngle", "_backblastRange", "_backblastDamage", "_offset"];
_backblastRange = _backblastRange * ace_overpressure_backblastDistanceCoefficient;

//TRACE_4("cache",_backblastAngle,_backblastRange,_backblastDamage,_offset);

if (_backblastDamage <= 0) exitWith {};

private _direction = (vectorDir _projectile) vectorMultiply -1;
private _position = (getPosASL _projectile) vectorAdd (_direction vectorMultiply _offset);

// Damage to others
private _affected = (ASLToAGL _position) nearEntities ["CAManBase", _backblastRange];

// Let each client handle their own affected units
["ace_overpressure", [_unit, _position, _direction, _weapon, _magazine, _ammo], _affected] call CBA_fnc_targetEvent;

// Damage to the firer
private _distance = 2 * ([_position, _direction, _backblastRange, _unit] call ace_overpressure_fnc_getDistance);

//TRACE_1("Distance",_distance);

if (_distance < _backblastRange) then {
    //TRACE_2("",isDamageAllowed _unit,_unit getVariable [ARR_2(QEGVAR(medical,allowDamage),true)]);

    // Skip damage if not allowed
    if (isDamageAllowed _unit && {_unit getVariable ["ace_medical_allowDamage", true]}) then {
        private _alpha = sqrt (1 - _distance / _backblastRange);
        private _beta = sqrt 0.5;

        private _damage = _alpha * _beta * _backblastDamage;
        //TRACE_1("",_damage);

        [_damage * 100] call BIS_fnc_bloodEffect;

        if (missionNamespace getVariable ["ace_medical_enabled", false]) then {
            [_unit, _damage, "body", "backblast", _unit] call ace_medical_fnc_addDamageToUnit;
        } else {
            if ( EGVAR(main,enable) && {!(GVAR(finishDowns) && {lifestate _unit isEqualTo "INCAPACITATED"} ) } ) exitWith {
                _damage = _damage * GVAR(bbdmgCoef);
                if (GVAR(ignoreArmor)) then {
                    private _vest = vestContainer _unit;
                    private _plates = _vest getVariable [QEGVAR(main,plates), []];
                    _vest setVariable [QEGVAR(main,plates), []];
                    [{params ["_vest","_plates"]; _vest setVariable [QEGVAR(main,plates), _plates];}, [_vest,_plates]] call CBA_fnc_execNextFrame;
                };
                [_unit, _damage, "", _unit] call EFUNC(main,receiveDamage);
            };
            _unit setDamage (damage _unit + _damage);
        };
    };
};

// Draw debug lines
#ifdef DEBUG_MODE_FULL
    [   _position,
        _position vectorAdd (_direction vectorMultiply _backblastRange),
        [1,1,0,1]
    ] call ace_common_fnc_addLineToDebugDraw;

    private _ref = _direction call ace_common_fnc_createOrthonormalReference;
    [   _position,
        _position vectorAdd (_direction vectorMultiply _backblastRange) vectorAdd ((_ref select 1) vectorMultiply _backblastRange * tan _backblastAngle),
        [1,1,0,1]
    ] call ace_common_fnc_addLineToDebugDraw;
    [   _position,
        _position vectorAdd (_direction vectorMultiply _backblastRange) vectorDiff ((_ref select 1) vectorMultiply _backblastRange * tan _backblastAngle),
        [1,1,0,1]
    ] call ace_common_fnc_addLineToDebugDraw;
    [   _position,
        _position vectorAdd (_direction vectorMultiply _backblastRange) vectorAdd ((_ref select 2) vectorMultiply _backblastRange * tan _backblastAngle),
        [1,1,0,1]
    ] call ace_common_fnc_addLineToDebugDraw;
    [   _position,
        _position vectorAdd (_direction vectorMultiply _backblastRange) vectorDiff ((_ref select 2) vectorMultiply _backblastRange * tan _backblastAngle),
        [1,1,0,1]
    ] call ace_common_fnc_addLineToDebugDraw;

    [   _position,
        _position vectorAdd (_direction vectorMultiply ((_distance/2) min _backblastRange)),
        [1,0,0,1]
    ] call ace_common_fnc_addLineToDebugDraw;
#endif