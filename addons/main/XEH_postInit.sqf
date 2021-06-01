#include "script_component.hpp"

if (is3DEN) exitWith {};

["CAManBase", "Hit", {
    _this call FUNC(hitEh);
}, true, [], true] call CBA_fnc_addClassEventHandler;

["CAManBase", "InitPost", {
    params ["_unit"];

    private _arr = [_unit, "Heal", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa",
        // condition show
        format ["alive _target && {(lifeState _target) == 'INCAPACITATED' && {_this getUnitTrait 'Medic' && {(_target distance _this) < 4 && {[_this] call %1 > 0}}}}", QFUNC(hasHealItems)],
        // condition progress
        "alive _target && {(lifeState _target) == 'INCAPACITATED'}", {
        // code start
        params ["_target", "_caller"];
        private _isProne = stance _caller == "PRONE";
        _caller setVariable [QGVAR(wasProne), _isProne];
        private _medicAnim = ["AinvPknlMstpSlayW[wpn]Dnon_medicOther", "AinvPpneMstpSlayW[wpn]Dnon_medicOther"] select _isProne;
        private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _caller, secondaryWeapon _caller, handgunWeapon _caller] find currentWeapon _caller, "non"];
        _medicAnim = [_medicAnim, "[wpn]", _wpn] call CBA_fnc_replace;
        if (_medicAnim != "") then {
            _caller playMove _medicAnim;
        };
    }, {
        // code progress
    }, {
        // codeCompleted
        params ["_target", "_caller"];
        private _ret = [_caller] call FUNC(hasHealItems);
        if (_ret isEqualTo 1) then {
            _caller removeItem "FirstAidKit";
        };
        [QGVAR(heal), [_target, _caller], _target] call CBA_fnc_targetEvent;
    }, {
        // code interrupted
        params ["", "_caller"];
        private _anim = ["amovpknlmstpsloww[wpn]dnon", "amovppnemstpsrasw[wpn]dnon"] select (_caller getVariable [QGVAR(wasProne), false]);
        private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _caller, secondaryWeapon _caller, handgunWeapon _caller] find currentWeapon _caller, "non"];
        _anim = [_anim, "[wpn]", _wpn] call CBA_fnc_replace;
        [QGVAR(switchMove), [_caller, _anim]] call CBA_fnc_globalEvent;
    }, [], GVAR(medicReviveTime), 15, false, false, true];

    _arr call BIS_fnc_holdActionAdd;
    private _arr2 = +_arr;
    _arr2 set [4, format ["alive _target && {(lifeState _target) == 'INCAPACITATED' && {!(_this getUnitTrait 'Medic') && {(_target distance _this) < 4 && {[_this] call %1 > 0}}}}", QFUNC(hasHealItems)]];
    _arr2 set [11, GVAR(noneMedicReviveTime)];
    _arr2 call BIS_fnc_holdActionAdd;

    _unit addEventHandler ["HandleDamage", {
        _this call FUNC(handleDamageEh);
    }];
}, true, [], true] call CBA_fnc_addClassEventHandler;

["CAManBase", "HandleHeal", {
    [{
        _this call FUNC(handleHealEh);
    }, _this, 5] call CBA_fnc_waitAndExecute;
    true
}, true, [], true] call CBA_fnc_addClassEventHandler;

["unit", {
    params ["_newUnit", "_oldUnit"];
    [_newUnit] call FUNC(updatePlateUi);
    [_newUnit] call FUNC(updateHPUi);
}] call CBA_fnc_addPlayerEventHandler;

[QGVAR(heal), {
    _this call FUNC(handleHealEh);
}] call CBA_fnc_addEventHandler;

[QGVAR(switchMove), {
    params ["_unit", "_anim"];
    _unit switchMove _anim;
}] call CBA_fnc_addEventHandler;

if !(hasInterface) exitWith {};

{
    ctrlDelete (_x select 0);
    ctrlDelete (_x select 1);
} forEach (uiNamespace getVariable [QGVAR(plateControls), []]);
uiNamespace setVariable [QGVAR(plateControls), []];
ctrlDelete (uiNamespace getVariable [QGVAR(mainControl), controlNull]);
ctrlDelete (uiNamespace getVariable [QGVAR(hpControl), controlNull]);

player addEventHandler ["Respawn", {
    player setVariable [QGVAR(plates), []];
    player setVariable [QGVAR(hp), GVAR(maxUnitHP)];
    [player] call FUNC(updatePlateUi);
    [player] call FUNC(updateHPUi);
    player setCaptive false;
    [] call FUNC(addPlayerHoldActions);
}];

[] call FUNC(addPlayerHoldActions);

[{
    time > 1
}, {
    [] call FUNC(initPlates);
}] call CBA_fnc_waitUntilAndExecute;

player setVariable [QGVAR(plates), [GVAR(maxPlateHealth),GVAR(maxPlateHealth),GVAR(maxPlateHealth)]];
// player setVariable [QGVAR(hp), 20];
