#include "script_component.hpp"
params ["_show", "_time", "_unit"];
if (GVAR(skullActive) isEqualTo _show) exitWith {};
if (_show) then {
    if (_time <= 0 || {!alive _unit}) exitWith {};
    if ((uiNamespace getVariable [QGVAR(skullControls), []]) isEqualTo []) then {
        // init
        private _display = findDisplay 46;
        if (isNull _display) exitWith {
            ERROR("Could not find display, weird huh?");
        };
        private _arr = [];
        getResolution params ["","_screenHeight","","","","_scale"];
        _scale = (linearConversion [0.55, 1, _scale, 1, 1.8181818181818181818181818181818]) * (_screenHeight / 1080);
        private _display = findDisplay 46;
        private _height = 256 * _scale * pixelH;
        private _width = 256 * _scale * pixelW;
        private _pos = [
            0.5 - (_width / 2), 0.5 - (_height / 2), _width, _height
        ];
        private _ctrl = _display ctrlCreate ["RscText", -1];
        _ctrl ctrlSetPosition [
            safeZoneX,
            safeZoneY,
            safeZoneW,
            safeZoneH];
        _ctrl ctrlSetBackgroundColor [0, 0, 0, 0.75];
        _ctrl ctrlSetTextColor [0, 0, 0, 0];
        _ctrl ctrlSetFade 1;
        _ctrl ctrlCommit 0;
        _arr pushBack _ctrl;
        for "_i" from 0 to 6 do {
            private _ctrl = _display ctrlCreate ["RscPictureKeepAspect", -1];
            _ctrl ctrlSetBackgroundColor [0, 0, 0, 0];
            _ctrl ctrlSetPosition _pos;
            _ctrl ctrlSetTextColor [1, 1, 1, 0.75];
            _ctrl ctrlSetText (format [QPATHTOF(ui\skull%1_ca.paa), _i]);
            _ctrl ctrlSetFade 1;
            _ctrl ctrlCommit 0;
            _arr pushBack _ctrl;
        };
        uiNamespace setVariable [QGVAR(skullControls), _arr];
    };
    if (isNil QGVAR(downedBlur)) then {
        private _name = "DynamicBlur";
        private _priority = 400;
        GVAR(downedBlur) = ppEffectCreate [_name, _priority];
        while {
            GVAR(downedBlur) < 0
        } do {
            _priority = _priority + 1;
            GVAR(downedBlur) = ppEffectCreate [_name, _priority];
        };
        GVAR(downedBlur) ppEffectEnable true;
        GVAR(downedBlur) ppEffectAdjust [0];
        GVAR(downedBlur) ppEffectCommit 0;
    };

    GVAR(skullActive) = true;
    private _controlsCopy = + (uiNamespace getVariable [QGVAR(skullControls), []]);
    _controlsCopy = _controlsCopy call BIS_fnc_arrayShuffle;
    private _waitTime = _time / 2;
    private _maxTimePerPart = _waitTime / 7;
    private _first = _controlsCopy deleteAt 0;
    _first setVariable [QGVAR(timeToShow), random [_time / 4, _waitTime, _time]];
    {
        _x setVariable [QGVAR(timeToShow), random [_waitTime / 4, _waitTime / 2, _waitTime]];
        private _rnd = (random _maxTimePerPart) min _waitTime;
        _waitTime = (_waitTime - _rnd) max 0;
    } forEach _controlsCopy;
    _controlsCopy pushBack _first;
    [{
        params ["_controls", "_unit"];
        private _timeLeft = (_unit getVariable [QGVAR(bleedoutKillTime), -1]) - cba_missionTime;
        {
            _x ctrlSetFade (linearConversion [_x getVariable [QGVAR(timeToShow), 0], 0, _timeLeft, 1, 0, true]);
            _x ctrlCommit 0;
        } forEach _controls;

        !GVAR(skullActive)
    }, {
        if !(isNil QGVAR(downedBlur)) then {
            GVAR(downedBlur) ppEffectAdjust [0];
            GVAR(downedBlur) ppEffectCommit 0.5;
        };
        {
            _x ctrlSetFade 1;
            _x ctrlCommit (random 1);
        } forEach (uiNamespace getVariable [QGVAR(skullControls), []]);
    }, [_controlsCopy, _unit]] call CBA_fnc_waitUntilAndExecute;
    GVAR(downedBlur) ppEffectAdjust [4];
    GVAR(downedBlur) ppEffectCommit _time;
} else {
    GVAR(skullActive) = false;
};

true
