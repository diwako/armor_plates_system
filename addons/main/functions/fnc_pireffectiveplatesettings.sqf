#include "script_component.hpp"
// Returns [blockResidualPiRDamage, allowPiRReactionsWhilePlatesHold] for this unit (player vs AI CBA).
params [["_unit", objNull, [objNull]]];

private _isPlayerLike = isPlayer _unit || {!isNull (remoteControlled _unit)};
if (_isPlayerLike) exitWith {
    [GVAR(blockDamageUntilPlatesDestroyed), GVAR(allowPiRReactionsWhilePlatesHold)]
};

if (GVAR(applyPiRPlateRulesToAI)) exitWith {
    [GVAR(blockDamageUntilPlatesDestroyedAI), GVAR(allowPiRReactionsWhilePlatesHoldAI)]
};

// Default: do not apply player plate/PiR bridge rules to AI (vanilla PiR + APS plate mitigation only).
[false, true]
