#include "script_component.hpp"
// Plate-bridge gate for PiRredirect / PiRredirect0 (was a local in xeh_postinit; must be a FUNC so deferred CBA frames can call it).
params ["_event", "_unit"];

if (isNull _unit) exitWith {false};

private _isPlayerLike = isPlayer _unit || {!isNull (remoteControlled _unit)};
private _protectOnlyTorso = [GVAR(protectOnlyTorsoAI), GVAR(protectOnlyTorso)] select (isPlayer _unit);
private _eff = [_unit] call FUNC(piREffectivePlateSettings);
_eff params ["_blk", "_allowPiRPlateReact"];
private _vest = vestContainer _unit;
private _hasPlateState = (!isNull _vest && {(_vest getVariable [QGVAR(plates), []]) isNotEqualTo []}) || {(+(_unit getVariable [QGVAR(plates), []])) isNotEqualTo []};
private _isDirectHit = _event param [10, false, [false]];
private _selectionText = toLower str (_event param [5, [], [[]]]);
private _matchesTorsoProtection = !_protectOnlyTorso || {
    ("spine" in _selectionText) || {("pelvis" in _selectionText)} || {("body" in _selectionText)} || {("neck" in _selectionText)}
};

if (!_isPlayerLike && {!_blk}) exitWith {false};

if (
    _isPlayerLike &&
    {_isDirectHit} &&
    {_hasPlateState} &&
    {_matchesTorsoProtection} &&
    {_blk} &&
    {!_allowPiRPlateReact}
) exitWith {
    true
};

private _bridge = _unit getVariable [QGVAR(lastDamageBridge), []];
if (_bridge isEqualTo []) exitWith {
    _event call FUNC(shouldSuppressPiRReaction)
};

_bridge params [
    ["_bridgeFrame", -1, [0]],
    ["_bridgeHitPoint", "", [""]],
    ["_ratio", 1, [0]],
    ["_bridgeProjectile", "", [""]],
    ["_bridgeSelection", "", [""]],
    ["_bridgeOldDamage", 0, [0]],
    ["_damageAfterPlates", 1, [0]],
    ["_bridgeTick", -1, [0]],
    ["_blockedByIntactPlates", false, [false]],
    ["_platesRemainAfterHit", false, [false]]
];

private _bridgeIsRecent = (_bridgeFrame >= 0 && {_bridgeFrame >= (diag_frameNo - 8)}) || {_bridgeTick >= 0 && {(diag_tickTime - _bridgeTick) <= 0.35}};
if !(_bridgeIsRecent) exitWith {
    _event call FUNC(shouldSuppressPiRReaction)
};

private _fullyBlockedHit = _ratio <= 0.05 && {_damageAfterPlates <= 0.01};
if !(_fullyBlockedHit) exitWith {false};

if (
    _blk &&
    {_platesRemainAfterHit} &&
    {!_allowPiRPlateReact}
) exitWith {
    true
};

_event call FUNC(shouldSuppressPiRReaction)
