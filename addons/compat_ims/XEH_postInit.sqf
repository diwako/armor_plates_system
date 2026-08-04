#include "script_component.hpp"
#include "\a3\ui_f\hpp\defineDIKCodes.inc"

if (is3DEN) exitWith {};
if (!EGVAR(main,enable)) exitWith {};
if (EGVAR(main,aceMedicalLoaded)) exitWith {};

// if (true) exitWith {};

WBK_CreateDamage = {
    params [
        ["_unit", objNull],
        ["_incomingDamage", 0.2],
        ["_killer", objNull]
    ];
    private _damage = (_incomingDamage * parseNumber ([IMS_Damage_Multiplier_AI, IMS_Damage_Multiplier_Player] select (isPlayer _unit))) * 2;
    if (isNull _unit || isNull _killer || _damage <= 0.01) exitWith {};

    // too bad i guess
    if (stance _unit == "PRONE" || lifeState _unit == "INCAPACITATED") exitWith {
        [_unit, _killer] call WBK_Melee_FatalBlow;
    };

    [_unit, "WBK_IMS_Hit", [_unit,_damage,_killer]] call BIS_fnc_callScriptedEventHandler;
    [_unit, _damage, ["body", "head"] select ((animationState _killer in IMS_HeadDamageAnimations || gestureState _killer in IMS_HeadDamageAnimations)), _killer, "", GVAR(ignoreArmor)] call EFUNC(main,receiveDamage);

    // copy from IMS
    if (isPlayer _unit) then {
        [40] call BIS_fnc_bloodEffect;
        enableCamShake true;
        addCamShake [15, 1, 40];
        if !(isNil "SFX_EnableBreathing_Hurt") then {
            if (SFX_EnableBreathing_Hurt) then {
                [[_unit,_killer,objNull,[6390.73,5435,10.1987],[470.304,74.0389,-25.8961],["spine2","hit_spine2"],[5,0,0,0,"B_45ACP_Ball"],[-0.841351,-0.536923,-0.061989],0.177322,"a3\data_f\penetration\meatbones.bisurf",true,_unit]] spawn Unit_HitSFX_container;
            };
        };
    };
};
