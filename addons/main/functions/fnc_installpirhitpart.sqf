#include "script_component.hpp"
params [["_unit", objNull, [objNull]]];


if (isNull _unit) then {
    if !(hasInterface) exitWith {};
    waitUntil {!isNull player};
    _unit = player;
};

private _targetUnit = _unit;
if (isNull _targetUnit) exitWith {
};

if (!local _targetUnit && {!hasInterface || {_targetUnit isNotEqualTo player}}) exitWith {
};

if (isNil "PiRredirect0") exitWith {
};

private _existingId = _targetUnit getVariable [QGVAR(piRHitPartEH), -1];
private _installHitPartForPiRBridge = isPlayer _targetUnit || {!isNull (remoteControlled _targetUnit)} || {GVAR(applyPiRPlateRulesToAI)};
if (!_installHitPartForPiRBridge) exitWith {
    if (_existingId >= 0) then {
        _targetUnit removeEventHandler ["HitPart", _existingId];
    };
    _targetUnit setVariable [QGVAR(piRHitPartEH), -1];
};

if (_existingId >= 0) then {
    _targetUnit removeEventHandler ["HitPart", _existingId];
};

private _id = _targetUnit addEventHandler ["HitPart", {
    private _event = +(_this select 0);
    private _unit = _event param [0, objNull, [objNull]];
    private _isPlayerLike = isPlayer _unit || {!isNull (remoteControlled _unit)};
    private _protectOnlyTorso = [GVAR(protectOnlyTorsoAI), GVAR(protectOnlyTorso)] select (isPlayer _unit);
    private _eff = [_unit] call FUNC(piREffectivePlateSettings);
    _eff params ["_blockEff", "_allowEff"];
    private _isDirectHit = _event param [10, false, [false]];
    private _vest = vestContainer _unit;
    private _vestPlates = if (isNull _vest) then {[]} else {+(_vest getVariable [QGVAR(plates), []])};
    private _unitPlates = +(_unit getVariable [QGVAR(plates), []]);
    private _plateState = if (_vestPlates isNotEqualTo []) then {_vestPlates} else {_unitPlates};
    private _selectionText = toLower str (_event param [5, [], [[]]]);
    private _matchesTorsoProtection = !_protectOnlyTorso || {
        ("spine" in _selectionText) || {("pelvis" in _selectionText)} || {("body" in _selectionText)} || {("neck" in _selectionText)}
    };
    private _currentPlatePool = 0;
    {
        _currentPlatePool = _currentPlatePool + _x;
    } forEach _plateState;

    if (
        _isDirectHit &&
        {_blockEff} &&
        {!_allowEff} &&
        {_matchesTorsoProtection} &&
        {_currentPlatePool > 1}
    ) exitWith {
    };

    if (
        _isDirectHit &&
        {_blockEff}
    ) exitWith {
        [{
            params ["_event"];
            private _unit = _event param [0, objNull, [objNull]];
            if (isNull _unit) exitWith {};
            if (_event call FUNC(shouldSuppressPiRReaction)) exitWith {
            };

            private _dispatchReactionOnly = false;
            private _allowNow = ([_unit] call FUNC(piREffectivePlateSettings)) select 1;
            if (_allowNow) then {
                private _bridge = _unit getVariable [QGVAR(lastDamageBridge), []];
                if (_bridge isNotEqualTo []) then {
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

                    private _bridgeIsRecent = (_bridgeFrame >= 0 && {_bridgeFrame >= (diag_frameNo - 2)}) || {_bridgeTick >= 0 && {(diag_tickTime - _bridgeTick) <= 0.1}};
                    private _fullyBlockedHit = _ratio <= 0.02 && {_damageAfterPlates <= 0.005};
                    _dispatchReactionOnly = _bridgeIsRecent && {_fullyBlockedHit} && {_platesRemainAfterHit};
                };
            };

            private _selection = if (_event param [10, false, [false]]) then {
                +(_event param [5, [], [[]]])
            } else {
                []
            };
            private _shooter = _event param [1, objNull, [objNull]];
            // Do not call PiRredirect0 from this EH: stock PiR HitPart already invokes PiRredirect0 first; the
            // wrapper dedupes same-frame repeats so a second call here would no-op and skip all plate deferral.
            [_unit, _selection, _shooter, _dispatchReactionOnly] call FUNC(dispatchPiRReaction);
        }, [_event]] call CBA_fnc_execNextFrame;
    };

    private _selection = if (_event param [10, false, [false]]) then {
        +(_event param [5, [], [[]]])
    } else {
        []
    };
    private _shooter = _event param [1, objNull, [objNull]];
    [_unit, _selection, _shooter, false] call FUNC(dispatchPiRReaction);
}];

_targetUnit setVariable [QGVAR(piRHitPartEH), _id];
