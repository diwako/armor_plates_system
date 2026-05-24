#include "script_component.hpp"
// Region code used by PiRanim / PiRanim0; mirrors PiR0.sqf ordering (substring checks on str _selection).
params [["_selection", [], [[]]]];

private _s = toLower str _selection;

if (("head" in _s) || ("face_hub" in _s)) exitWith {10};

if (("spine" in _s) || ("spine1" in _s) || ("spine2" in _s) || ("pelvis" in _s)) exitWith {7};

if (("spine3" in _s) || ("neck" in _s) || ("neck1" in _s)) exitWith {9};

if (
    ("leftforearm" in _s) || ("rightforearm" in _s) || ("lefthand" in _s) || ("righthand" in _s) || ("leftforearmroll" in _s) || ("rightforearmroll" in _s)
    || ("lefthandring" in _s) || ("lefthandring1" in _s) || ("lefthandring2" in _s) || ("lefthandring3" in _s) || ("lefthandpinky1" in _s) || ("lefthandpinky2" in _s) || ("lefthandpinky3" in _s)
    || ("lefthandmiddle1" in _s) || ("lefthandmiddle2" in _s) || ("lefthandmiddle3" in _s) || ("lefthandindex1" in _s) || ("lefthandindex2" in _s) || ("lefthandindex3" in _s)
    || ("lefthandthumb1" in _s) || ("lefthandthumb2" in _s) || ("lefthandthumb3" in _s) || ("righthandring" in _s) || ("righthandring1" in _s) || ("righthandring2" in _s) || ("righthandring3" in _s)
    || ("righthandpinky1" in _s) || ("righthandpinky2" in _s) || ("righthandpinky3" in _s) || ("righthandmiddle1" in _s) || ("righthandmiddle2" in _s) || ("righthandmiddle3" in _s)
    || ("righthandindex1" in _s) || ("righthandindex2" in _s) || ("righthandindex3" in _s) || ("righthandthumb1" in _s) || ("righthandthumb2" in _s) || ("righthandthumb3" in _s)
) exitWith {1};

if (("leftarm" in _s) || ("rightarm" in _s) || ("leftshoulder" in _s) || ("rightshoulder" in _s) || ("leftarmroll" in _s) || ("rightarmroll" in _s)) exitWith {3};

if (("leftupleg" in _s) || ("rightupleg" in _s) || ("leftuplegroll" in _s) || ("rightuplegroll" in _s)) exitWith {6};

if (("leftleg" in _s) || ("rightleg" in _s) || ("leftlegroll" in _s) || ("rightlegroll" in _s)) exitWith {4};

if (("leftfoot" in _s) || ("rightfoot" in _s) || ("lefttoebase" in _s) || ("righttoebase" in _s)) exitWith {2};

if (_s isEqualTo "[]") exitWith {8};

7
