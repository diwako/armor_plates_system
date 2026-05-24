#include "script_component.hpp"
params [["_unit", objNull, [objNull]], ["_limitFatalDamage", false]];


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

private _existingId = _targetUnit getVariable [QGVAR(piRHandleDamageEH), -1];
if (_existingId >= 0) then {
    _targetUnit removeEventHandler ["HandleDamage", _existingId];
};

_targetUnit setVariable [QGVAR(limitFatalDamage), _limitFatalDamage];
_targetUnit setVariable [QGVAR(lastAllowedOverallDamage), damage _targetUnit];

private _id = _targetUnit addEventHandler ["HandleDamage", {
    if !(local (_this select 0)) exitWith {nil};

    params ["_unit", "_selection", "_damage", "_source", "_projectile"];

    private _instigator = _this param [6, objNull, [objNull]];
    private _hitPoint = toLower (_this param [7, "", [""]]);
    private _oldDamage = if (_selection isEqualTo "") then {
        damage _unit
    } else {
        _unit getHit _selection
    };

    private _newDamage = (_damage - _oldDamage) max 0;
    if (_newDamage <= 0) exitWith {_damage};

    private _isPlayerLike = isPlayer _unit || {!isNull (remoteControlled _unit)};
    private _protectOnlyTorso = [GVAR(protectOnlyTorsoAI), GVAR(protectOnlyTorso)] select (isPlayer _unit);
    private _piREffective = [_unit] call FUNC(piREffectivePlateSettings);
    _piREffective params ["_blockResidualPiRDamage", "_allowPiRWhilePlatesHoldEff"];
    private _vest = vestContainer _unit;
    private _vestPlatesBeforeAny = if (isNull _vest) then {[]} else {+(_vest getVariable [QGVAR(plates), []])};
    private _unitPlatesBeforeAny = +(_unit getVariable [QGVAR(plates), []]);
    private _anyPlatesBefore = (_vestPlatesBeforeAny isNotEqualTo []) || {_unitPlatesBeforeAny isNotEqualTo []};
    if (_isPlayerLike) then {
    };

    if (
        _projectile isNotEqualTo "" &&
        {_selection isEqualTo ""} &&
        {_hitPoint isEqualTo ""} &&
        {_anyPlatesBefore}
    ) exitWith {
        private _safeOverallDamage = _unit getVariable [QGVAR(lastAllowedOverallDamage), _oldDamage];
        if (_blockResidualPiRDamage) then {
            _safeOverallDamage = _safeOverallDamage max 0;
            if ((damage _unit) > _safeOverallDamage) then {
                _unit setDamage _safeOverallDamage;
            };
        } else {
            _safeOverallDamage = _oldDamage;
        };
        _safeOverallDamage
    };

    // Projectile-driven "incapacitated" damage is a synthetic follow-up event.
    // Let PiR handle it directly instead of letting APS consume plates or overwrite
    // the last bridge state from the actual body-part hit that preceded it.
    if (
        _projectile isNotEqualTo "" &&
        {_hitPoint isEqualTo "incapacitated"}
    ) exitWith {
        if (
            _blockResidualPiRDamage &&
            {_anyPlatesBefore}
        ) exitWith {
            private _safeOverallDamage = _unit getVariable [QGVAR(lastAllowedOverallDamage), _oldDamage];
            if (_safeOverallDamage < _oldDamage) then {
                _unit setDamage _safeOverallDamage;
            };
            _safeOverallDamage
        };

        private _fireCoef = missionNamespace getVariable ["PiR_healthcoef_fire_on", 1];
        private _headCoef = missionNamespace getVariable ["PiR_healthcoef_head_on", 1];
        private _torsoCoef = missionNamespace getVariable ["PiR_healthcoef_tors_on", 1];
        private _legsCoef = missionNamespace getVariable ["PiR_healthcoef_legs_on", 1];
        private _handsCoef = missionNamespace getVariable ["PiR_healthcoef_hands_on", 1];
        private _genericCoef = missionNamespace getVariable ["PiR_healthcoef_on", 1];
        private _headCoefAI = missionNamespace getVariable ["PiR_healthcoefAI_head_on", 1];
        private _torsoCoefAI = missionNamespace getVariable ["PiR_healthcoefAI_tors_on", 1];
        private _legsCoefAI = missionNamespace getVariable ["PiR_healthcoefAI_legs_on", 1];
        private _handsCoefAI = missionNamespace getVariable ["PiR_healthcoefAI_hands_on", 1];
        private _genericCoefAI = missionNamespace getVariable ["PiR_healthcoefAI_on", 1];

        if ((isBurning _unit) && {_projectile isEqualTo ""}) then {
            _newDamage = _newDamage / _fireCoef;
        } else {
            if (!("afalpercmstp" in animationState _unit) && {_projectile isEqualTo ""}) then {
                if (isPlayer _unit) then {
                    switch _hitPoint do {
                        case "hitface";
                        case "hitneck";
                        case "hithead": {
                            _newDamage = _newDamage / _headCoef;
                        };
                        case "hitpelvis";
                        case "hitabdomen";
                        case "hitdiaphragm";
                        case "hitchest";
                        case "hitbody": {
                            _newDamage = _newDamage / _torsoCoef;
                        };
                        case "hitlegs": {
                            _newDamage = _newDamage / _legsCoef;
                        };
                        case "hitarms";
                        case "hithands": {
                            _newDamage = _newDamage / _handsCoef;
                        };
                        case "incapacitated": {};
                        case "";
                        default {
                            _newDamage = _newDamage / _genericCoef;
                        };
                    };
                } else {
                    switch _hitPoint do {
                        case "hitface";
                        case "hitneck";
                        case "hithead": {
                            _newDamage = _newDamage / _headCoefAI;
                        };
                        case "hitpelvis";
                        case "hitabdomen";
                        case "hitdiaphragm";
                        case "hitchest";
                        case "hitbody": {
                            _newDamage = _newDamage / _torsoCoefAI;
                        };
                        case "hitlegs": {
                            _newDamage = _newDamage / _legsCoefAI;
                        };
                        case "hitarms";
                        case "hithands": {
                            _newDamage = _newDamage / _handsCoefAI;
                        };
                        case "incapacitated": {};
                        case "";
                        default {
                            _newDamage = _newDamage / _genericCoefAI;
                        };
                    };
                };
            };
        };

        _damage = _oldDamage + _newDamage;

        private _shouldLimitFatalSynthetic = if (_isPlayerLike) then {
            !(missionNamespace getVariable ["PiR_instantdeathplayer_on", false])
        } else {
            !(missionNamespace getVariable ["PiR_instantdeathAI_on", false])
        };

        if (_shouldLimitFatalSynthetic && {_damage > 0.94}) then {
            _damage = 0.94;
            if (_isPlayerLike) then {
                _unit setDamage 0.94;
            };
        };

        if (_selection isEqualTo "") then {
            _unit setVariable [QGVAR(lastAllowedOverallDamage), _damage];
        };

        _damage
    };

    if (_projectile isNotEqualTo "") then {
        private _apsHitPoint = switch _hitPoint do {
            case "hitface": {"HitFace"};
            case "hitneck": {"HitNeck"};
            case "hithead": {"HitHead"};
            case "hitpelvis": {"HitPelvis"};
            case "hitabdomen": {"HitAbdomen"};
            case "hitdiaphragm": {"HitDiaphragm"};
            case "hitchest": {"HitChest"};
            case "hitbody": {"HitBody"};
            case "hitlegs": {"HitLegs"};
            case "hitarms": {"HitArms"};
            case "hithands": {"HitHands"};
            case "";
            case "incapacitated": {"#structural"};
            default {"#structural"};
        };

        private _isTorsoHit = _apsHitPoint in ["HitPelvis", "HitAbdomen", "HitDiaphragm", "HitChest", "HitBody"];

        if (_apsHitPoint isNotEqualTo "") then {
            private _existingBridge = _unit getVariable [QGVAR(lastDamageBridge), []];
            private _vestPlatesBefore = if (isNull _vest) then {[]} else {+(_vest getVariable [QGVAR(plates), []])};
            private _unitPlatesBeforeHit = +(_unit getVariable [QGVAR(plates), []]);
            private _hadPlatesBeforeArmor = (_vestPlatesBefore isNotEqualTo []) || {_unitPlatesBeforeHit isNotEqualTo []};
            private _armor = if (_apsHitPoint isEqualTo "#structural") then {0} else {[_unit, _apsHitPoint] call FUNC(getHitpointArmor)};
            private _realDamage = _newDamage * (1 + (_armor / 100));
            private _ratio = 1;
            private _blockedByIntactPlates = false;

            if (
                _apsHitPoint isNotEqualTo "#structural" &&
                {_vestPlatesBefore isNotEqualTo []} &&
                {_realDamage > 0}
            ) then {
                private _playerUnit = objNull;
                if (!isNil "CBA_fnc_currentUnit") then {
                    _playerUnit = call CBA_fnc_currentUnit;
                };

                private _markerSource = [_source, _instigator] select (isNull _source);
                private _damageResult = [_unit, _realDamage, _isTorsoHit, _playerUnit, _projectile, _markerSource] call FUNC(handleArmorDamage);
                private _damageLeft = _damageResult select 0;
                _ratio = _damageLeft / _realDamage;
                _newDamage = _newDamage * _ratio;
            };

            if (
                _apsHitPoint isEqualTo "#structural" &&
                {_ratio > 0.05} &&
                {_newDamage > 0.01} &&
                {_hadPlatesBeforeArmor} &&
                {_existingBridge isNotEqualTo []}
            ) then {
                _existingBridge params [
                    ["_existingFrame", -1, [0]],
                    ["_existingHitPoint", "", [""]],
                    ["_existingRatio", 1, [0]],
                    ["_existingProjectile", "", [""]],
                    ["_existingSelection", "", [""]],
                    ["_existingOldDamage", 0, [0]],
                    ["_existingDamageAfter", 1, [0]],
                    ["_existingTick", -1, [0]]
                ];

                private _existingBridgeIsRecent = (_existingFrame >= 0 && {_existingFrame >= (diag_frameNo - 8)}) || {_existingTick >= 0 && {(diag_tickTime - _existingTick) <= 0.35}};
                private _existingAbsorbed = _existingRatio <= 0.05 && {_existingDamageAfter <= 0.01};
                private _existingTorso = _existingHitPoint in ["HitPelvis", "HitAbdomen", "HitDiaphragm", "HitChest", "HitBody", "HitNeck"];

                if (
                    _existingBridgeIsRecent &&
                    {_existingAbsorbed} &&
                    {_existingProjectile isEqualTo _projectile} &&
                    {!_protectOnlyTorso || {_existingTorso}}
                ) then {
                    _ratio = 0;
                    _newDamage = 0;
                };
            };

            private _vestPlatesAfter = if (isNull _vest) then {[]} else {+(_vest getVariable [QGVAR(plates), []])};
            private _unitPlatesAfter = +(_unit getVariable [QGVAR(plates), []]);
            private _damageAfterPlatesRaw = _newDamage;
            private _platesRemainAfterHit = (_vestPlatesAfter isNotEqualTo []) || {_unitPlatesAfter isNotEqualTo []};

            if (
                _blockResidualPiRDamage &&
                {_apsHitPoint isNotEqualTo "#structural"} &&
                {_hadPlatesBeforeArmor} &&
                {_platesRemainAfterHit} &&
                {_newDamage > 0.01}
            ) then {
                _blockedByIntactPlates = true;
                _ratio = 0;
                _newDamage = 0;
            };

            private _newBridge = [diag_frameNo, _apsHitPoint, _ratio, _projectile, _selection, _oldDamage, _newDamage, diag_tickTime, _blockedByIntactPlates, _platesRemainAfterHit];
            private _storeNewBridge = true;

            if (_existingBridge isNotEqualTo []) then {
                _existingBridge params [
                    ["_existingFrame", -1, [0]],
                    ["_existingHitPoint", "", [""]],
                    ["_existingRatio", 1, [0]],
                    ["_existingProjectile", "", [""]],
                    ["_existingSelection", "", [""]],
                    ["_existingOldDamage", 0, [0]],
                    ["_existingDamageAfter", 1, [0]],
                    ["_existingTick", -1, [0]]
                ];

                if (_existingFrame isEqualTo diag_frameNo) then {
                    private _existingAbsorbed = _existingRatio <= 0.05 && {_existingDamageAfter <= 0.01};
                    private _newAbsorbed = _ratio <= 0.05 && {_newDamage <= 0.01};
                    private _existingTorso = _existingHitPoint in ["HitPelvis", "HitAbdomen", "HitDiaphragm", "HitChest", "HitBody", "HitNeck"];

                    if (_existingAbsorbed && {!_newAbsorbed} && {_platesRemainAfterHit}) then {
                        _storeNewBridge = false;
                    };

                    if (_storeNewBridge && {_protectOnlyTorso} && {_existingAbsorbed} && {_existingTorso} && {!_isTorsoHit}) then {
                        _storeNewBridge = false;
                    };
                };
            };

            if (_storeNewBridge) then {
                _unit setVariable [QGVAR(lastDamageBridge), _newBridge, true];
            } else {
            };

        };
    };

    private _fireCoef = missionNamespace getVariable ["PiR_healthcoef_fire_on", 1];
    private _headCoef = missionNamespace getVariable ["PiR_healthcoef_head_on", 1];
    private _torsoCoef = missionNamespace getVariable ["PiR_healthcoef_tors_on", 1];
    private _legsCoef = missionNamespace getVariable ["PiR_healthcoef_legs_on", 1];
    private _handsCoef = missionNamespace getVariable ["PiR_healthcoef_hands_on", 1];
    private _genericCoef = missionNamespace getVariable ["PiR_healthcoef_on", 1];
    private _headCoefAI = missionNamespace getVariable ["PiR_healthcoefAI_head_on", 1];
    private _torsoCoefAI = missionNamespace getVariable ["PiR_healthcoefAI_tors_on", 1];
    private _legsCoefAI = missionNamespace getVariable ["PiR_healthcoefAI_legs_on", 1];
    private _handsCoefAI = missionNamespace getVariable ["PiR_healthcoefAI_hands_on", 1];
    private _genericCoefAI = missionNamespace getVariable ["PiR_healthcoefAI_on", 1];

    if ((isBurning _unit) && {_projectile isEqualTo ""}) then {
        _newDamage = _newDamage / _fireCoef;

        if (!(_unit getVariable ["dam_player_firenow0", false]) && {!(_unit getVariable ["dam_ignore_injured0", false]) && {missionNamespace getVariable ["PiR_veh_crew_fire_turn", false]}}) then {
            [{
                params ["_unit"];

                if ((isBurning _unit) && {!(_unit getVariable ["dam_player_firenow0", false]) && {!(_unit getVariable ["dam_ignore_injured0", false]) && {missionNamespace getVariable ["PiR_veh_crew_fire_turn", false]}}}) then {
                    _unit setVariable ["dam_player_firenow0", true, true];
                    _unit setVariable ["dam_player_lecitsebia0", true, true];
                    _unit setVariable ["dam_ignore_injured0", true, true];

                    private _fireMin = missionNamespace getVariable ["PiR_veh_crew_fire", 0];
                    private _fireMax = missionNamespace getVariable ["PiR_veh_crew_fireM", _fireMin];
                    private _delay = _fireMin + random (abs (_fireMax - _fireMin));

                    if (!(isPlayer _unit) && {isNull (remoteControlled _unit)}) then {
                        [_unit, _unit, _delay] remoteExecCall ["PiRvehicleFireCrew", 0];
                    } else {
                        [_unit, _delay] remoteExecCall ["PiRvehicleFireCrew0", 0];
                    };
                };
            }, [_unit], (2 + random 4)] call CBA_fnc_waitAndExecute;
        };
    } else {
        if (!("afalpercmstp" in animationState _unit) && {_projectile isEqualTo ""}) then {
            if (isPlayer _unit) then {
                switch _hitPoint do {
                    case "hitface";
                    case "hitneck";
                    case "hithead": {
                        _newDamage = _newDamage / _headCoef;
                    };
                    case "hitpelvis";
                    case "hitabdomen";
                    case "hitdiaphragm";
                    case "hitchest";
                    case "hitbody": {
                        _newDamage = _newDamage / _torsoCoef;
                    };
                    case "hitlegs": {
                        _newDamage = _newDamage / _legsCoef;
                    };
                    case "hitarms";
                    case "hithands": {
                        _newDamage = _newDamage / _handsCoef;
                    };
                    case "incapacitated": {};
                    case "";
                    default {
                        _newDamage = _newDamage / _genericCoef;
                    };
                };
            } else {
                switch _hitPoint do {
                    case "hitface";
                    case "hitneck";
                    case "hithead": {
                        _newDamage = _newDamage / _headCoefAI;
                    };
                    case "hitpelvis";
                    case "hitabdomen";
                    case "hitdiaphragm";
                    case "hitchest";
                    case "hitbody": {
                        _newDamage = _newDamage / _torsoCoefAI;
                    };
                    case "hitlegs": {
                        _newDamage = _newDamage / _legsCoefAI;
                    };
                    case "hitarms";
                    case "hithands": {
                        _newDamage = _newDamage / _handsCoefAI;
                    };
                    case "incapacitated": {};
                    case "";
                    default {
                        _newDamage = _newDamage / _genericCoefAI;
                    };
                };
            };
        };
    };

    _damage = _oldDamage + _newDamage;

    private _shouldLimitFatal = if (_isPlayerLike) then {
        !(missionNamespace getVariable ["PiR_instantdeathplayer_on", false])
    } else {
        !(missionNamespace getVariable ["PiR_instantdeathAI_on", false])
    };

    if (_shouldLimitFatal) then {
        if (_damage > 0.94) then {
            _damage = 0.94;
            if (_isPlayerLike) then {
                _unit setDamage 0.94;
            };
        };

        if ((vehicle _unit != _unit) && {damage (vehicle _unit) == 1}) then {
            moveOut _unit;
            _unit allowDamage false;
            _unit setDamage 0.94;

            [{
                params ["_unit"];
                _unit allowDamage true;
            }, [_unit], 0.1] call CBA_fnc_waitAndExecute;
        };
    };

    if (
        _isPlayerLike &&
        {_projectile isNotEqualTo ""} &&
        {_selection isNotEqualTo ""} &&
        {_hitPoint isNotEqualTo ""} &&
        {_hitPoint isNotEqualTo "incapacitated"}
    ) then {
        private _vestNow = vestContainer _unit;
        private _vestPlatesNow = if (isNull _vestNow) then {[]} else {+(_vestNow getVariable [QGVAR(plates), []])};
        private _unitPlatesNow = +(_unit getVariable [QGVAR(plates), []]);

        if (_vestPlatesNow isEqualTo [] && {_unitPlatesNow isEqualTo []}) then {
            if (
                !_shouldLimitFatal &&
                {!(_unit getVariable ["dam_ignore_injured0", false])} &&
                {_damage > 0.94}
            ) then {
                // Let PiR own the first fatal player hit after plates are fully depleted.
                _damage = 0.94;
                _unit setDamage 0.94;
            };

            private _overallDamageBefore = damage _unit;
            if (_damage > (_overallDamageBefore + 0.01)) then {
                _unit setDamage _damage;
            };
            _unit setVariable [QGVAR(lastAllowedOverallDamage), _damage];
        };
    };

    if (_selection isEqualTo "") then {
        _unit setVariable [QGVAR(lastAllowedOverallDamage), _damage];
    };

    _damage
}];

_targetUnit setVariable [QGVAR(piRHandleDamageEH), _id];
