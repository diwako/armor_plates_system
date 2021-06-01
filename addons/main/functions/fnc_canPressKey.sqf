#include "script_component.hpp"
params ["_player"];

private _anim = animationState _player;
alive _player && {
!visibleMap && {
!((_anim select [1, 3]) in ["bdv","bsw","dve","sdv","ssw","swm"]) && { // not swimming
(lifeState _player) isNotEqualTo "INCAPACITATED" && { // not uncon
getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> _anim >> QGVAR(isLadder)) isNotEqualTo 1}}}} // not climbing a ladder
