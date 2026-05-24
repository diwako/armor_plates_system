// Shared by initSettings.inc.sqf and initSettingsACE.inc.sqf (only one is loaded per session).
// Defaults come from APS_TORSO_DEFAULT_PLAYER / APS_TORSO_DEFAULT_AI set by the parent file before #include.
// Titles/tooltips are literal strings so CBA never shows a failed LLSTRING / raw config name.

[
    QGVAR(protectOnlyTorso),
    "CHECKBOX",
    [
        "Protect Only Torso for Player",
        "Only allow plates to mitigate torso hits for players and Zeus remote-controlled units."
    ],
    _category,
    APS_TORSO_DEFAULT_PLAYER,
    true
] call CBA_fnc_addSetting;

[
    QGVAR(protectOnlyTorsoAI),
    "CHECKBOX",
    [
        "Protect Only Torso for AI",
        "Only allow plates to mitigate torso hits for AI"
    ],
    _category,
    APS_TORSO_DEFAULT_AI,
    true
] call CBA_fnc_addSetting;
