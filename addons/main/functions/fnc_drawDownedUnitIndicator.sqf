#include "script_component.hpp"

private _size = GVAR(showDownedUnitIndicatorSize) * ((call CBA_fnc_getFov) select 1);
private _camPos = positionCameraToWorld [0, 0, 0];
private _color = [
    profileNamespace getvariable ['igui_error_RGB_R', 1],
    profileNamespace getvariable ['igui_error_RGB_G', 0.1],
    profileNamespace getvariable ['igui_error_RGB_B', 0.1],
    profileNamespace getvariable ['igui_error_RGB_A', 1]
];

{
    private _distance = _x distance _camPos;
    if (_distance > GVAR(showDownedUnitIndicatorRange)) then {continue};
    private _sizeFinal = linearConversion [0, GVAR(showDownedUnitIndicatorRange), _distance, _size, _size/10, false];
    drawIcon3D [["\a3\ui_f\data\igui\cfg\actions\bandage_ca.paa", "\A3\ui_f\data\Map\VehicleIcons\pictureHeal_ca.paa"] select (_x getVariable [QGVAR(beingRevived), false]), _color, (ASLtoAGL visiblePositionASL _x) vectorAdd [0, 0, 0.5], _sizeFinal, _sizeFinal, 0, "", 0, 0, "RobotoCondensed", "center", true, 0, 0.5];
} forEach (GVAR(downedUnitIndicatorDrawCache) select {_x getVariable [QGVAR(unconscious), false]});
