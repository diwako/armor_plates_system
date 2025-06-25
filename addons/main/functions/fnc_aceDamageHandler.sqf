#include "script_component.hpp"
params ["_unit", "_allDamages", "_typeOfDamage"];
private _copy = +_allDamages;

private _parentShooter = _shooter;
if (GVAR(disallowFriendfire) &&
    {!isNull _parentShooter && {
    _parentShooter isNotEqualTo _unit && {
    (side group _unit) isEqualTo (side group _parentShooter)}}}) exitWith {
        _this set [1, []];
        _this
};

{
    _x params ["_damage", "_bodyPart"];

    if (_damage isEqualTo 0 || {_bodyPart isEqualTo "#structural" || {(missionNamespace getVariable [format ["%1%2", QGVAR(ignoreArmor), toLower _typeOfDamage],false])}}) then {
        continue;
    };
    private _isTorso = _bodyPart isEqualTo "Body";
    if (GVAR(protectOnlyTorso) && {!_isTorso}) then {
        continue;
    };

    // _aceSelection is HitBody, HitLegs etc
    private _aceSelection = format ["Hit%1", _bodyPart];
    private _hitPointArmor = getNumber ((configOf _unit) >> "HitPoints" >> _aceSelection >> "armor");
    if (_isTorso) then {
        _aceSelection = "Hitchest";
    };

    private _bodyArmor = ([vest _unit, _aceSelection] call ace_medical_engine_fnc_getItemArmor) + ([uniform _unit, _aceSelection] call ace_medical_engine_fnc_getItemArmor);

    private _actualDamage = _damage;
    if (_bodyArmor > 0 && {_hitPointArmor > 0}) then {
        _actualDamage = _damage * (_hitPointArmor + _bodyArmor) / (_hitPointArmor / _bodyArmor) * ([0.5, 0.96] select _isTorso);
    };

    // _shooter and _ammo exist in the scope above
    private _damageLeft = [_unit, _damage, _actualDamage, _parentShooter, _ammo, _isTorso] call FUNC(receiveDamageACE);
    if (_damageLeft isEqualTo 0) then {
        _copy deleteAt _forEachIndex;
    } else {
        _x set [0, _damageLeft];
    };
} forEachReversed _copy;

_this set [1, _copy];
_this
