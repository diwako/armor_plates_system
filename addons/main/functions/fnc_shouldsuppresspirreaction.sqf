#include "script_component.hpp"
params ["_hitPartEvent"];

private _unit = _hitPartEvent param [0, objNull, [objNull]];
if (isNull _unit) exitWith {false};
if !(_hitPartEvent param [10, false, [false]]) exitWith {false};

private _bridge = _unit getVariable [QGVAR(lastDamageBridge), []];
if (_bridge isEqualTo []) exitWith {false};
private _isPlayerLike = isPlayer _unit || {!isNull (remoteControlled _unit)};
private _protectOnlyTorso = [GVAR(protectOnlyTorsoAI), GVAR(protectOnlyTorso)] select (isPlayer _unit);
private _piREffective = [_unit] call FUNC(piREffectivePlateSettings);
_piREffective params ["_blockResidualPiRDamage", "_allowPiRWhilePlatesHoldEff"];

if (!_blockResidualPiRDamage) exitWith {false};

_bridge params [
    ["_bridgeFrame", -1, [0]],
    ["_bridgeHitPoint", "", [""]],
    ["_ratio", 1, [0]],
    ["_projectile", "", [""]],
    ["_selectionName", "", [""]],
    ["_oldDamage", 0, [0]],
    ["_damageAfterPlates", 1, [0]],
    ["_bridgeTick", -1, [0]],
    ["_blockedByIntactPlates", false, [false]],
    ["_platesRemainAfterHit", false, [false]]
];

private _bridgeIsRecent = (_bridgeFrame >= 0 && {_bridgeFrame >= (diag_frameNo - 2)}) || {_bridgeTick >= 0 && {(diag_tickTime - _bridgeTick) <= 0.1}};
if !(_bridgeIsRecent) exitWith {false};
private _fullyBlockedHit = _ratio <= 0.02 && {_damageAfterPlates <= 0.005};
if !(_fullyBlockedHit) exitWith {false};

if (_platesRemainAfterHit && {_allowPiRWhilePlatesHoldEff}) exitWith {
    false
};

private _selectionText = toLower str (_hitPartEvent param [5, [], [[]]]);

if (_protectOnlyTorso) then {
    if !(_bridgeHitPoint in ["HitPelvis", "HitAbdomen", "HitDiaphragm", "HitChest", "HitBody"]) exitWith {false};
    if !(("spine" in _selectionText) || {("pelvis" in _selectionText)} || {("body" in _selectionText)} || {("neck" in _selectionText)}) exitWith {false};
};


true
