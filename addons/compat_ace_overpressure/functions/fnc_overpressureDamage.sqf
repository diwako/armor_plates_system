#include "..\script_component.hpp"
/*
 * Author: commy2 and esteldunedain
 * Calculate and apply backblast damage to potentially affected local units
 * Handles the "overpressure" event.
 *
 * Arguments:
 * 0: Unit that fired <OBJECT>
 * 1: Pos ASL of the projectile <ARRAY>
 * 2: Direction of the projectile (reversed for launcher backblast) <ARRAY>
 * 3: Weapon fired <STRING>
 * 4: Magazine <STRING>
 * 5: Ammo <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [tank, [1727.57,5786.15,7.24899], [-0.982474,-0.185998,-0.0122501], "cannon_125mm", "24Rnd_125mm_APFSDS_T_Green", "Sh_125mm_APFSDS_T_Green"] call ace_overpressure_fnc_overpressureDamage
 *
 * Public: No
 */

params ["_firer", "_posASL", "_direction", "_weapon", "_magazine", "_ammo"];

// Retrieve overpressure values
private _opValues = [_weapon, _ammo, _magazine] call ace_overpressure_fnc_getOverPressureValues;

_opValues params ["_overpressureAngle", "_overpressureRange", "_overpressureDamage"];
//TRACE_3("cache",_overpressureAngle,_overpressureRange,_overpressureDamage);

{
    if (local _x && {_x != _firer} && {isNull objectParent _x}) then {
        private _targetPositionASL = eyePos _x;
        private _relativePosition = _targetPositionASL vectorDiff _posASL;
        private _axisDistance = _relativePosition vectorDotProduct _direction;
        private _distance = vectorMagnitude _relativePosition;
        private _angle = acos (_axisDistance / _distance);

        private _line = [_posASL, _targetPositionASL, vehicle _firer, _x];
        private _line2 = [_posASL, _targetPositionASL];
        //TRACE_4("Affected:",_x,_axisDistance,_distance,_angle);

        if (_angle < _overpressureAngle && {_distance < _overpressureRange} && {!lineIntersects _line} && {!terrainIntersectASL _line2}) then {
            //TRACE_2("",isDamageAllowed _x,_x getVariable [ARR_2(QEGVAR(medical,allowDamage),true)]);

            // Skip damage if not allowed
            if (isDamageAllowed _x && {_x getVariable ["ace_medical_allowDamage", true]}) then {
                private _alpha = sqrt (1 - _distance / _overpressureRange);
                private _beta = sqrt (1 - _angle / _overpressureAngle);

                private _damage = _alpha * _beta * _overpressureDamage;
                //TRACE_1("",_damage);

                // If the target is the ACE_player
                if (_x isEqualTo ACE_player) then {
                    [_damage * 100] call BIS_fnc_bloodEffect;
                };

                if (missionNamespace getVariable ["ace_medical_enabled", false]) then {
                    [_x, _damage, "body", "backblast", _firer] call ace_medical_fnc_addDamageToUnit;
                } else {
                    if (EGVAR(main,enable)) then {
                        private _lifestate = lifeState _x;
                        if (_lifestate isNotEqualTo "INCAPACITATED" || ({GVAR(finishDowns) && {_lifestate isEqualTo "INCAPACITATED"}})) then {
                            _damage = _damage * GVAR(bbdmgCoef);
                            [_x, _damage, "", _firer, "", GVAR(ignoreArmor)] call EFUNC(main,receiveDamage);
                        };
                    } else {
                        _x setDamage (damage _x + _damage);
                    };
                };
            };

            #ifdef DEBUG_MODE_FULL
            //Shows damage lines in green
            [   _posASL,
            _targetPositionASL,
            [0,1,0,1]
            ] call ace_common_fnc_addLineToDebugDraw;
            #endif
        };
    };
} forEach ((ASLToAGL _posASL) nearEntities ["CAManBase", _overpressureRange]);
