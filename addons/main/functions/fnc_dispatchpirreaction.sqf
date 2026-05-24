#include "script_component.hpp"
params [
    ["_unit", objNull, [objNull]],
    ["_selection", [], [[]]],
    ["_shooter", objNull, [objNull]],
    ["_reactionOnly", false, [false]]
];

if (isNull _unit) exitWith {};

private _isPlayerLike = isPlayer _unit || {!isNull (remoteControlled _unit)};
private _targetFunction = ["PiR", "PiR0"] select _isPlayerLike;

// PiR0 rolls unconsciousness (Uncondition0 / Crawl0) from CBA coef sliders independently of
// HandleDamage. When plates still absorb this hit (bridge) and the player chose "block PiR
// damage + allow reactions", run PiRanim* only so flinch/camera moves stay without uncon.
// Player-like only: PiRanim* bypasses PiR0 medic/kneel/vehicle guards; AI must stay on full
// PiR / PiR0 unless you later add an AI-specific policy that mirrors stock PiR safely.
private _animOnly = _reactionOnly;
if (!_animOnly) then {
    private _eff = [_unit] call FUNC(piREffectivePlateSettings);
    _eff params ["_blkEff", "_allowEff"];
    if (_isPlayerLike && {_blkEff} && {_allowEff}) then {
        private _bridge = _unit getVariable [QGVAR(lastDamageBridge), []];
        if (_bridge isNotEqualTo []) then {
            _bridge params [
                ["_bf", -1, [0]],
                "",
                ["_ratio", 1, [0]],
                "",
                "",
                "",
                ["_dAfter", 1, [0]],
                ["_bt", -1, [0]],
                ["_blockedIntact", false, [false]],
                ["_platesRem", false, [false]]
            ];
            private _recent = (_bf >= 0 && {_bf >= (diag_frameNo - 8)}) || {_bt >= 0 && {(diag_tickTime - _bt) <= 0.35}};
            private _absorbedThisHit = _blockedIntact || (_ratio <= 0.05 && {_dAfter <= 0.01});
            if (_recent && {_absorbedThisHit} && {_platesRem}) then {
                _animOnly = true;
            };
        };
    };
};

if (!_isPlayerLike) then {
    _animOnly = false;
};

if (_animOnly) then {
    private _shans = [_selection] call FUNC(pirShansFromHitSelection);
    private _animFn = ["PiRanim", "PiRanim0"] select _isPlayerLike;
    [_unit, _shans, _selection] remoteExecCall [_animFn, 2];
} else {
    [_unit, _selection, _shooter] remoteExecCall [_targetFunction, 2];
};
