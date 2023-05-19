#include "script_component.hpp"
params["_structure"];

private _id = _structure addAction ["<img image='\A3\ui_f\data\igui\cfg\actions\heal_ca.paa' size='1.8' shadow=2 />", {
        params ["", "_caller"];
        private _isProne = stance _caller == "PRONE";
        private _medicAnim = ["AinvPknlMstpSlayW[wpn]Dnon_medicOther", "AinvPpneMstpSlayW[wpn]Dnon_medicOther"] select _isProne;
        private _wpn = ["non", "rfl", "lnr", "pst"] param [["", primaryWeapon _caller, secondaryWeapon _caller, handgunWeapon _caller] find currentWeapon _caller, "non"];
        _medicAnim = [_medicAnim, "[wpn]", _wpn] call CBA_fnc_replace;
        if (_medicAnim != "") then {
            _caller playMove _medicAnim;
        };
        [{
            params ["_target", "_caller"];
            if (!alive _target || {!alive _caller || {_caller getVariable [QGVAR(unconscious), false]}}) exitWith {};
            if !(_caller getUnitTrait "Medic") then {
                _caller setUnitTrait ["Medic", true]
                [{  params ["_caller"];
                    _caller setUnitTrait ["Medic", false]; 
                }, [_caller], 1] call CBA_fnc_waitAndExecute;
            };
            [QGVAR(heal), [_caller, _caller, false], _caller] call CBA_fnc_targetEvent;
        }, _this, 5] call CBA_fnc_waitAndExecute;
    }, [], 10, true, true, "",
    format ["!(_this getVariable ['%6',false]) && {alive _this && {(_this getVariable ['%1' , %2]) < (_this getVariable ['%7', ([%8,%2] select (isPlayer _this)) * %5]) }}", QGVAR(hp), QGVAR(maxPlayerHP), QFUNC(hasHealItems), QGVAR(maxHealRifleman), QGVAR(maxHealMedic), QGVAR(unconscious), QGVAR(maxHp), QGVAR(maxAiHp)],
    ((sizeOf (typeOf _structure)) min 9)];
    _structure setUserActionText [_id, format [((localize "STR_A3_CfgActions_Heal0") + " (APS)"), getText ((configOf _structure) >> "displayName")], "<img image='\A3\ui_f\data\igui\cfg\actions\heal_ca.paa' size='1.8' shadow=2 />"];
