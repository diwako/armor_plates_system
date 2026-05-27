#include "../script_component.hpp"

params ["_hitCheck",['_skip',false]];

private _delay = GVAR(plateDelay);
if (!_skip) then {sleep _delay;};
if (_hitCheck isNotEqualTo (player getVariable [QGVAR(hitTime), 0])) exitWith {};
private _full = true;
private _plateCarrier = (vestContainer player);
if (!alive player || {_plateCarrier isEqualTo objNull}) exitWith {};
private _plates = _plateCarrier getVariable [QGVAR(plates), [0]];
private _plateCnt = count _plates;
private _plateRegenCount = (GVAR(plateRegenCount) - 1) min (GVAR(numWearablePlates) - 1);

if (_plateCnt > _plateRegenCount) exitWith {player setVariable [QGVAR(hitTime), nil]};

for '_i' from _plateCnt to _plateRegenCount do {
    _plates pushBack 0;
};

private _plateMaxHp = GVAR(maxPlateHealth);
_plateCnt = _plates findIf {_x < _plateMaxHp};
_plateCarrier setVariable [QGVAR(plates), _plates];
private _tickRegen = GVAR(plateRegenPerTick);
private _waitTime = (GVAR(plateRegenSpeed)/_plateMaxHp) * _tickRegen;
private _inter = GVAR(plateDelayInter);

while {_plateCnt isNotEqualTo -1} do {
    private _skip = false;
    private _toughPlate = _plates # _plateCnt;
    while {alive player} do {
        sleep _waitTime;
        if (_hitCheck isNotEqualTo (player getVariable [QGVAR(hitTime), 0])) exitWith {_full = false; break};
        _plates = (_plateCarrier getVariable [QGVAR(plates), [0]]);
        private _plateChk = _plates # _plateCnt;
        if (_plateChk > _toughPlate) exitWith {_skip = true};
        _toughPlate = _toughPlate + _tickRegen;
        _plates set [_plateCnt, (_toughPlate min _plateMaxHp)];
        _plateCarrier setVariable [QGVAR(plates), _plates];
        [player] call FUNC(updatePlateUi);
        if (_toughPlate >= _plateMaxHp) then {break};
    };
    if (_inter && {!_skip}) then {
        sleep _delay;
        if (_hitCheck isNotEqualTo (player getVariable [QGVAR(hitTime), 0])) exitWith {_full = false; break};
        _plates = _plateCarrier getVariable [QGVAR(plates), []];
        private _plateChk = _plates # _plateCnt;
        if (isNil "_plateChk") exitWith {  };
        if (_plateChk > _toughPlate) exitWith {_skip = true};
        _plateCnt = (count _plates - 1) max 0;
        for '_i' from _plateCnt to (_plateRegenCount - 1) do {
            _plates pushBack 0;
        };
    };
    _plateCnt = _plates findIf {_x < _plateMaxHp};
};
if (_full) then {player setVariable [QGVAR(hitTime), nil]};