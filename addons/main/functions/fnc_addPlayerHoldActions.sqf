#include "script_component.hpp"
[
    player,
    LLSTRING(giveUp),
    "\A3\Ui_f\data\IGUI\Cfg\Revive\overlayIcons\d50_ca.paa",
    "\A3\Ui_f\data\IGUI\Cfg\Revive\overlayIcons\d100_ca.paa",
    "alive _target && {(lifeState _target) == 'INCAPACITATED' && {_target isEqualTo (call CBA_fnc_currentUnit)}}",
    "alive _target",
    {},
    {},{
        _this spawn {
            params ["_target", ""];
            private _response = true;
            if (GVAR(showGiveUpDialog)) then {
                _response = [
                    LLSTRING(giveUp_text), // body
                    LLSTRING(giveUp_title), // title
                    localize "str_lib_info_yes", // true return
                    localize "str_lib_info_no", // false return
                    nil, nil, false] call BIS_fnc_guiMessage;
            };
            if (_response) then {
                [QGVAR(setHidden), [_target , false]] call CBA_fnc_localEvent;
                _target setDamage 1;
            };
        };
    },
    {},
    [],
    5,
    1000,
    false,
    true
] call BIS_fnc_holdActionAdd;

// workaround for mods or missions healing the default a3 damage while the internal health is not at max
// First Aid action for healing self
private _id = player addAction ["<img image='\A3\ui_f\data\igui\cfg\actions\heal_ca.paa' size='1.8' shadow=2 />", {
    params ["_target"];
    private _isProne = stance _target == "PRONE";
    private _medicAnim = ["AinvPknlMstpSlayW[wpn]Dnon_medic", "AinvPpneMstpSlayW[wpn]Dnon_medic"] select _isProne;
    private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _target, secondaryWeapon _target, handgunWeapon _target] find currentWeapon _target, "non"];
    _medicAnim = [_medicAnim, "[wpn]", _wpn] call CBA_fnc_replace;
    if (_medicAnim != "") then {
        _target playMove _medicAnim;
    };
    [{
        params ["_target"];
        if (!alive _target || {_target getVariable [QGVAR(unconscious), false]}) exitWith {};
        [QGVAR(heal), [_target, _target, true]] call CBA_fnc_localEvent;
    }, _this, 5] call CBA_fnc_waitAndExecute;
}, [], 10, true, true, "", format ["alive _target && {_originalTarget isEqualTo _this && {(damage _target) isEqualTo 0 && {(_target getVariable ['%1' , %2]) < (%2 * ([%4, %5] select (_target getUnitTrait 'Medic'))) && {([_target] call %3) > 0}}}}", QGVAR(hp), QGVAR(maxPlayerHP), QFUNC(hasHealItems), QGVAR(maxHealRifleman), QGVAR(maxHealMedic)], 2];
player setUserActionText [_id, localize "str_a3_cfgactions_healsoldierself0", "<img image='\A3\ui_f\data\igui\cfg\actions\heal_ca.paa' size='1.8' shadow=2 />"];

// self revive
private _arr = [player, LLSTRING(allowSelfRevive_action), "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa",
    // condition show
    format ["%2 && {_this getUnitTrait 'Medic' && {(lifeState _this) == 'INCAPACITATED' && {([_this] call %1) > 0}}}", QFUNC(hasHealItems), QGVAR(allowSelfRevive)],
    "alive _this && {(lifeState _this) == 'INCAPACITATED'}", {
    // code start
    params ["_target", "", "", "_arguments"];
    _arguments params ["_time"];
    [format [LLSTRING(reviveUnit), name _target], _time] call FUNC(createProgressBar);
}, {
    // code progress
}, {
    // codeCompleted
    params ["_target"];
    call FUNC(deleteProgressBar);
    [QGVAR(revive), [_target, _target, true], _target] call CBA_fnc_localEvent;
}, {
    // code interrupted
    call FUNC(deleteProgressBar);
}, [GVAR(medicReviveTime) * 2], GVAR(medicReviveTime) * 2, 15, false, true, true];

_arr call BIS_fnc_holdActionAdd;
private _arr2 = +_arr;
_arr2 set [4, format ["%2 && {!(_this getUnitTrait 'Medic') && {(lifeState _this) == 'INCAPACITATED' && {([_this] call %1) > 0}}}", QFUNC(hasHealItems), QGVAR(allowSelfRevive)]];
_arr2 set [10, [GVAR(noneMedicReviveTime) * 2]];
_arr2 set [11, GVAR(noneMedicReviveTime) * 2];
_arr2 call BIS_fnc_holdActionAdd;
