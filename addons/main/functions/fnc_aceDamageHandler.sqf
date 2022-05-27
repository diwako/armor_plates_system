#include "script_component.hpp"
params ["_unit", "_allDamages", "_typeOfDamage"];
private _copy = +_allDamages;

if ((_copy select 0 select 0) > 0) then {
    (_copy select 0) params ["_damage", "_bodyPart"];
    if (_damage isEqualTo 0 || {_bodyPart == "#structural"}) then {continue};
    private _isTorso = _bodyPart isEqualTo "Body";
    if (GVAR(protectOnlyTorso) && {!_isTorso}) then {continue};

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
    private _damageLeft = [_unit, _damage, _actualDamage, _shooter, _ammo, _isTorso] call FUNC(receiveDamageACE);
    (_copy select 0) set [0, _damageLeft];
};

// if you want to do nothing, just exitWith {_this}. if you return nil or [] it will block further handling
[_unit, _copy, _typeOfDamage] //return
