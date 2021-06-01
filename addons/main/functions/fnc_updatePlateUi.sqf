params ["_player"];
private _plates = _player getVariable [QGVAR(plates), []];
private _plateCtrls = uiNamespace getVariable [QGVAR(plateControls), []];
private _count = count _plates;

{
    private _ctrl = _x select 0;
    private _pos = ctrlPosition _ctrl;
    if (_count > _forEachIndex) then {
        private _plateStatus = _plates select _forEachIndex;
        private _newWidth = GVAR(innerWidth) * (_plateStatus / GVAR(maxPlateHealth));
        _pos set [2, _newWidth];
    } else {
        _pos set [2, 0];
    };
    _ctrl ctrlSetPosition _pos;
    _ctrl ctrlCommit 0.1;
} forEach _plateCtrls;
