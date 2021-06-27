#include "script_component.hpp"
params ["_player"];

private _vest = vestContainer _player;
private _plates = _vest getVariable [QGVAR(plates), []];
private _vLoad = _vest getVariable ["ace_movement_vLoad", 0];

if (_plates isNotEqualTo []) then {
    // get last plate, it might be already damaged
    private _count = count _plates;
    _plates sort false;
    private _lastPlate = _plates deleteAt (_count - 1);
    _plates pushBack GVAR(maxPlateHealth);
    if (_count < GVAR(numWearablePlates)) then {
        // add the last plate back
        _plates pushBack _lastPlate;
        _vest setVariable ["ace_movement_vLoad", _vLoad + PLATE_MASS, true];
    };
    _plates sort false;
} else {
    _plates pushBack GVAR(maxPlateHealth);
    _vest setVariable ["ace_movement_vLoad", _vLoad + PLATE_MASS, true];
};
_player removeItem QGVAR(plate);
_vest setVariable [QGVAR(plates), _plates];
[_player] call FUNC(updatePlateUi);

