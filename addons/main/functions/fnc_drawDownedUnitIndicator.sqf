#include "script_component.hpp"

private _size = GVAR(showDownedUnitIndicatorSize) * ((call CBA_fnc_getFov) select 1);
private _camPos = positionCameraToWorld [0, 0, 0];
private _color = [
    profileNamespace getvariable ['igui_error_RGB_R', 1],
    profileNamespace getvariable ['igui_error_RGB_G', 0.1],
    profileNamespace getvariable ['igui_error_RGB_B', 0.1],
    profileNamespace getvariable ['igui_error_RGB_A', 1]
];
private _isMedic = (call CBA_fnc_currentUnit) getUnitTrait "Medic";

{
    private _distance = _x distance _camPos;
	if ( _distance > GVAR(showDownedUnitIndicatorRange) && { GVAR(visibleBleedoutTimer) == 0 || {_distance > GVAR(bleedoutTimerRange) || { !(_isMedic || GVAR(visibleBleedoutTimer) == 2 ) } } } ) then {continue};
    private _sizeFinal = linearConversion [0, GVAR(showDownedUnitIndicatorRange), _distance, _size, _size/10, true];
    drawIcon3D [["\a3\ui_f\data\igui\cfg\actions\bandage_ca.paa", "\A3\ui_f\data\Map\VehicleIcons\pictureHeal_ca.paa"] select (_x getVariable [QGVAR(beingRevived), false]), _color, (ASLtoAGL visiblePositionASL _x) vectorAdd [0, 0, 0.5], _sizeFinal, _sizeFinal, 0, "", 0, 0, "RobotoCondensed", "center", true, 0, 0.5];
    if (_distance > GVAR(bleedoutTimerRange)) then {continue};
    private _timeRemaining = round ((_x getVariable [QGVAR(bleedoutKillTime), -1]) - cba_missionTime);
    if (_timeRemaining >= 0 && { GVAR(visibleBleedoutTimer) > 0 && { _isMedic || GVAR(visibleBleedoutTimer) == 2 } }) then {
        drawIcon3D ["", GVAR(bleedoutTimerColor), (ASLtoAGL visiblePositionASL _x) vectorAdd [0, 0, 0.5], 0, 0, 0, str _timeRemaining, 2, 0.06 * (_size/2), "RobotoCondensed", "center", false, -0.0005 * (_size/2), -0.015 * (_size/2)];
    };
} forEach (GVAR(downedUnitIndicatorDrawCache) select {_x getVariable [QGVAR(unconscious), false]});
