#include "../script_component.hpp"

params ["_hitCheck", ["_skip", false]];

// check early exit, no vest or dead player
private _player = player;
private _delay = GVAR(plateToughnessDelay);
private _plateCarrier = (vestContainer _player);
if (!alive _player || {isNull _plateCarrier}) exitWith {
    _player setVariable [QGVAR(hitTime), nil]
};

// second early exit, vest already full off plates, probably equipped vest with full plates
private _plateMaxHp = GVAR(maxPlateHealth);
private _plates = _plateCarrier getVariable [QGVAR(plates), [0]];
private _plateCnt = {_x isEqualTo _plateMaxHp} count _plates;
private _plateRegenCount = (GVAR(plateToughnessRegenCount) - 1) min (GVAR(numWearablePlates) - 1);

// if full plates already, reset hitTime
if (_plateCnt > _plateRegenCount) exitWith {_player setVariable [QGVAR(hitTime), nil]};

if (!_skip) then {sleep _delay;};

// check after sleep, player cold be dead now or hitTime has changed
if (!alive _player || _hitCheck isNotEqualTo (_player getVariable [QGVAR(hitTime), 0])) exitWith {};

// grab vest again, see if player dropped the vest
_plateCarrier = (vestContainer _player);
if (!alive _player || {isNull _plateCarrier}) exitWith {
    _player setVariable [QGVAR(hitTime), nil]
};

// check plate status again after sleep
_plates = _plateCarrier getVariable [QGVAR(plates), [0]];
_plateCnt = {_x isEqualTo _plateMaxHp} count _plates;
if (_plateCnt > _plateRegenCount) exitWith {_player setVariable [QGVAR(hitTime), nil]};

// player switching vests is handled via change in hitTime!

for '_i' from _plateCnt to _plateRegenCount do {
    _plates pushBack 0;
};

_plateCnt = _plates findIf {_x < _plateMaxHp};
_plateCarrier setVariable [QGVAR(plates), _plates];
private _tickRegen = GVAR(plateToughnessRegenPerTick);
private _waitTime = (GVAR(plateToughnessRegenSpeed)/_plateMaxHp) * _tickRegen;
private _inter = GVAR(plateToughnessDelayInter);
private _continue = true;

while {_plateCnt <= _plateRegenCount && _plateCnt isNotEqualTo -1 && _continue} do {
    private _skip = false;
    private _toughPlate = _plates # _plateCnt;
    while {alive _player} do {
        sleep _waitTime;
        // exit out if hitTime or vest changes
        if (_hitCheck isNotEqualTo (_player getVariable [QGVAR(hitTime), 0])) exitWith {
                _continue = false;
                break
        };
        _plates = (_plateCarrier getVariable [QGVAR(plates), [0]]);
        private _plateChk = _plates # _plateCnt;
        if (_plateChk > _toughPlate) exitWith {_skip = true};
        if (GVAR(plateToughnessRegenInUnconsciousness) || {lifeState _player != "INCAPACITATED"}) then {
            _toughPlate = _toughPlate + _tickRegen;
            _plates set [_plateCnt, (_toughPlate min _plateMaxHp)];
            _plateCarrier setVariable [QGVAR(plates), _plates];
            [_player] call FUNC(updatePlateUi);
        };
        if (_toughPlate >= _plateMaxHp) then {break};
    };
    if (_inter && {!_skip}) then {
        sleep _delay;
        if (_hitCheck isNotEqualTo (_player getVariable [QGVAR(hitTime), 0])) exitWith {
                _continue = false;
                break
        };
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
if ((_player getVariable [QGVAR(hitTime), 0]) isEqualTo _hitCheck) then {
    _player setVariable [QGVAR(hitTime), nil];
};
