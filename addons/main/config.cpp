class CfgPatches
{
	class diw_armor_plates_main
	{
		name = COMPONENT_NAME;
		units[]=
		{
			"diw_armor_plates_main_moduleHeal",
			"diw_armor_plates_main_modulePlate",
			"diw_armor_plates_main_moduleResetMalus",
			"diw_armor_plates_main_moduleResetMalusGlobal",
			"diw_armor_plates_main_plateItem",
			"diw_armor_plates_main_autoInjectorItem"
		};
		weapons[]=
		{
			"diw_armor_plates_main_plate",
			"diw_armor_plates_main_autoInjector"
		};
		requiredVersion=2.2;
		requiredAddons[]=
		{
			"cba_main"
		};
		author = "diwako";
		url="";
		authorUrl="";
		version=0.11;
		versionStr="0.11.2.1";
		versionAr[]={0,11,2,1};
	};
};
class Cfg3DEN
{
	class Attributes
	{
		class Slider;
		class diw_armor_plates_main_maxHpSlider: Slider
		{
			attributeLoad="params [""_ctrlGroup""];            private _slider = _ctrlGroup controlsGroupCtrl 100;            private _edit = _ctrlGroup controlsGroupCtrl 101;            _slider sliderSetPosition _value;            _edit ctrlSetText (if (_value < 0.1) then {localize ""str_disp_default""} else {[_value, 1, 1] call CBA_fnc_formatNumber});";
			attributeSave="params [""_ctrlGroup""];            sliderPosition (_ctrlGroup controlsGroupCtrl 100); ";
			onLoad="params [""_ctrlGroup""];            private _slider = _ctrlGroup controlsGroupCtrl 100;            private _edit = _ctrlGroup controlsGroupCtrl 101;            _slider sliderSetRange [0, 1000];            _slider ctrlAddEventHandler [""SliderPosChanged"", {                params [""_slider""];                private _edit = (ctrlParentControlsGroup _slider) controlsGroupCtrl 101;                private _value = sliderPosition _slider;                _edit ctrlSetText (if (_value < 0.1) then {localize ""str_disp_default""} else {[_value, 1, 1] call CBA_fnc_formatNumber});            }];            _edit ctrlAddEventHandler [""KillFocus"", {                params [""_edit""];                private _slider = (ctrlParentControlsGroup _edit) controlsGroupCtrl 100;                private _value = ((parseNumber ctrlText _edit) min 1000) max 0;                _slider sliderSetPosition _value;                _edit ctrlSetText (if (_value < 0.1) then { localize ""str_disp_default"" } else {[_value, 1, 1] call CBA_fnc_formatNumber});            }];";
		};
		class diw_armor_plates_main_maxPlateInVestSlider: Slider
		{
			attributeLoad="params [""_ctrlGroup""];            private _slider = _ctrlGroup controlsGroupCtrl 100;            private _edit = _ctrlGroup controlsGroupCtrl 101;            _slider sliderSetPosition _value;            _edit ctrlSetText (if (_value < 0) then {localize ""str_disp_default""} else {[_value, 1, 0] call CBA_fnc_formatNumber});";
			attributeSave="params [""_ctrlGroup""];            sliderPosition (_ctrlGroup controlsGroupCtrl 100); ";
			onLoad="params [""_ctrlGroup""];            private _slider = _ctrlGroup controlsGroupCtrl 100;            private _edit = _ctrlGroup controlsGroupCtrl 101;            _slider sliderSetRange [-1, 10];            _slider ctrlAddEventHandler [""SliderPosChanged"", {                params [""_slider""];                private _edit = (ctrlParentControlsGroup _slider) controlsGroupCtrl 101;                private _value = sliderPosition _slider;                _edit ctrlSetText (if (_value < 0) then {localize ""str_disp_default""} else {[_value, 1, 0] call CBA_fnc_formatNumber});            }];            _edit ctrlAddEventHandler [""KillFocus"", {                params [""_edit""];                private _slider = (ctrlParentControlsGroup _edit) controlsGroupCtrl 100;                private _value = ((parseNumber ctrlText _edit) min 10) max -1;                _slider sliderSetPosition _value;                _edit ctrlSetText (if (_value < 0) then { localize ""str_disp_default"" } else {[_value, 1, 0] call CBA_fnc_formatNumber});            }];";
		};
		class diw_armor_plates_main_maxPlateInInventorSlider: Slider
		{
			attributeLoad="params [""_ctrlGroup""];            private _slider = _ctrlGroup controlsGroupCtrl 100;            private _edit = _ctrlGroup controlsGroupCtrl 101;            _slider sliderSetPosition _value;            _edit ctrlSetText (if (_value < 0) then {localize ""str_disp_default""} else {[_value, 1, 0] call CBA_fnc_formatNumber});";
			attributeSave="params [""_ctrlGroup""];            sliderPosition (_ctrlGroup controlsGroupCtrl 100); ";
			onLoad="params [""_ctrlGroup""];            private _slider = _ctrlGroup controlsGroupCtrl 100;            private _edit = _ctrlGroup controlsGroupCtrl 101;            _slider sliderSetRange [-1, 10];            _slider ctrlAddEventHandler [""SliderPosChanged"", {                params [""_slider""];                private _edit = (ctrlParentControlsGroup _slider) controlsGroupCtrl 101;                private _value = sliderPosition _slider;                _edit ctrlSetText (if (_value < 0) then {localize ""str_disp_default""} else {[_value, 1, 0] call CBA_fnc_formatNumber});            }];            _edit ctrlAddEventHandler [""KillFocus"", {                params [""_edit""];                private _slider = (ctrlParentControlsGroup _edit) controlsGroupCtrl 100;                private _value = ((parseNumber ctrlText _edit) min 10) max -1;                _slider sliderSetPosition _value;                _edit ctrlSetText (if (_value < 0) then { localize ""str_disp_default"" } else {[_value, 1, 0] call CBA_fnc_formatNumber});            }];";
		};
	};
	class Object
	{
		class AttributeCategories
		{
			class diw_armor_plates_main_attributes
			{
				displayName="$STR_diw_armor_plates_main_Eden_options";
				collapsed=1;
				class Attributes
				{
					class diw_armor_plates_main_threshold
					{
						property="threshold";
						control="diw_armor_plates_main_maxHpSlider";
						displayName="$STR_diw_armor_plates_main_Eden_maxHp";
						tooltip="$STR_diw_armor_plates_main_Eden_maxHp_desc";
						expression="if (_value >= 0.1) then {_this setVariable [""diw_armor_plates_main_maxHp"", _value, true]}";
						typeName="NUMBER";
						condition="objectControllable";
						defaultValue=0;
					};
					class diw_armor_plates_main_maxPlateInVest
					{
						property="maxPlateInVest";
						control="diw_armor_plates_main_maxPlateInVestSlider";
						displayName="$STR_diw_armor_plates_main_maxPlateInVest";
						tooltip="$STR_diw_armor_plates_main_maxPlateInVest_desc";
						expression="if (_value >= 0) then {_this setVariable [""diw_armor_plates_main_3den_maxPlateInVest"", round _value, true]}";
						typeName="NUMBER";
						condition="objectControllable";
						defaultValue=-1;
					};
					class diw_armor_plates_main_maxPlateInInventor
					{
						property="maxPlateInInventor";
						control="diw_armor_plates_main_maxPlateInInventorSlider";
						displayName="$STR_diw_armor_plates_main_maxPlateInInventor";
						tooltip="$STR_diw_armor_plates_main_maxPlateInInventor_desc";
						expression="if (_value >= 0) then {_this setVariable [""diw_armor_plates_main_3den_maxPlateInInventory"", round _value, true]}";
						typeName="NUMBER";
						condition="objectControllable";
						defaultValue=-1;
					};
				};
			};
		};
	};
};
class Extended_PreStart_EventHandlers
{
	class diw_armor_plates_main
	{
		init="call compileScript ['\z\diw_armor_plates\addons\main\XEH_preStart.sqf']";
	};
};
class Extended_PreInit_EventHandlers
{
	class diw_armor_plates_main
	{
		init="call compileScript ['\z\diw_armor_plates\addons\main\XEH_preInit.sqf']";
	};
};
class Extended_PostInit_EventHandlers
{
	class diw_armor_plates_main
	{
		init="call compileScript ['\z\diw_armor_plates\addons\main\XEH_postInit.sqf']";
	};
};
class CfgFactionClasses
{
	class APS
	{
		displayName="$STR_diw_armor_plates_main_category";
		priority=2;
		side=7;
	};
};
class CfgMovesBasic
{
	class ManActions
	{
		diw_armor_plates_main_addPlate_base="diw_armor_plates_main_addPlate_base";
		diw_armor_plates_main_addPlate_2_0="diw_armor_plates_main_addPlate_2_0";
		diw_armor_plates_main_addPlate_3_0="diw_armor_plates_main_addPlate_3_0";
		diw_armor_plates_main_addPlate_4_0="diw_armor_plates_main_addPlate_4_0";
		diw_armor_plates_main_addPlate_5_0="diw_armor_plates_main_addPlate_5_0";
		diw_armor_plates_main_addPlate_6_0="diw_armor_plates_main_addPlate_6_0";
		diw_armor_plates_main_addPlate_7_0="diw_armor_plates_main_addPlate_7_0";
		diw_armor_plates_main_addPlate_8_0="diw_armor_plates_main_addPlate_8_0";
		diw_armor_plates_main_addPlate_9_0="diw_armor_plates_main_addPlate_9_0";
		diw_armor_plates_main_addPlate_10_0="diw_armor_plates_main_addPlate_10_0";
		diw_armor_plates_main_addPlate_11_0="diw_armor_plates_main_addPlate_11_0";
		diw_armor_plates_main_addPlate_12_0="diw_armor_plates_main_addPlate_12_0";
		diw_armor_plates_main_addPlate_13_0="diw_armor_plates_main_addPlate_13_0";
		diw_armor_plates_main_addPlate_14_0="diw_armor_plates_main_addPlate_14_0";
		diw_armor_plates_main_addPlate_15_0="diw_armor_plates_main_addPlate_15_0";
		diw_armor_plates_main_addPlate_16_0="diw_armor_plates_main_addPlate_16_0";
		diw_armor_plates_main_addPlate_2_1="diw_armor_plates_main_addPlate_2_1";
		diw_armor_plates_main_addPlate_3_1="diw_armor_plates_main_addPlate_3_1";
		diw_armor_plates_main_addPlate_4_1="diw_armor_plates_main_addPlate_4_1";
		diw_armor_plates_main_addPlate_5_1="diw_armor_plates_main_addPlate_5_1";
		diw_armor_plates_main_addPlate_6_1="diw_armor_plates_main_addPlate_6_1";
		diw_armor_plates_main_addPlate_7_1="diw_armor_plates_main_addPlate_7_1";
		diw_armor_plates_main_addPlate_8_1="diw_armor_plates_main_addPlate_8_1";
		diw_armor_plates_main_addPlate_9_1="diw_armor_plates_main_addPlate_9_1";
		diw_armor_plates_main_addPlate_10_1="diw_armor_plates_main_addPlate_10_1";
		diw_armor_plates_main_addPlate_11_1="diw_armor_plates_main_addPlate_11_1";
		diw_armor_plates_main_addPlate_12_1="diw_armor_plates_main_addPlate_12_1";
		diw_armor_plates_main_addPlate_13_1="diw_armor_plates_main_addPlate_13_1";
		diw_armor_plates_main_addPlate_14_1="diw_armor_plates_main_addPlate_14_1";
		diw_armor_plates_main_addPlate_15_1="diw_armor_plates_main_addPlate_15_1";
		diw_armor_plates_main_addPlate_16_1="diw_armor_plates_main_addPlate_16_1";
		diw_armor_plates_main_addPlate_2_2="diw_armor_plates_main_addPlate_2_2";
		diw_armor_plates_main_addPlate_3_2="diw_armor_plates_main_addPlate_3_2";
		diw_armor_plates_main_addPlate_4_2="diw_armor_plates_main_addPlate_4_2";
		diw_armor_plates_main_addPlate_5_2="diw_armor_plates_main_addPlate_5_2";
		diw_armor_plates_main_addPlate_6_2="diw_armor_plates_main_addPlate_6_2";
		diw_armor_plates_main_addPlate_7_2="diw_armor_plates_main_addPlate_7_2";
		diw_armor_plates_main_addPlate_8_2="diw_armor_plates_main_addPlate_8_2";
		diw_armor_plates_main_addPlate_9_2="diw_armor_plates_main_addPlate_9_2";
		diw_armor_plates_main_addPlate_10_2="diw_armor_plates_main_addPlate_10_2";
		diw_armor_plates_main_addPlate_11_2="diw_armor_plates_main_addPlate_11_2";
		diw_armor_plates_main_addPlate_12_2="diw_armor_plates_main_addPlate_12_2";
		diw_armor_plates_main_addPlate_13_2="diw_armor_plates_main_addPlate_13_2";
		diw_armor_plates_main_addPlate_14_2="diw_armor_plates_main_addPlate_14_2";
		diw_armor_plates_main_addPlate_15_2="diw_armor_plates_main_addPlate_15_2";
		diw_armor_plates_main_addPlate_16_2="diw_armor_plates_main_addPlate_16_2";
		diw_armor_plates_main_stopGesture="diw_armor_plates_main_stopGesture";
	};
	class Actions
	{
		class NoActions: ManActions
		{
			diw_armor_plates_main_addPlate_base[]=
			{
				"diw_armor_plates_main_addPlate_base",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_2_0[]=
			{
				"diw_armor_plates_main_addPlate_2_0",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_3_0[]=
			{
				"diw_armor_plates_main_addPlate_3_0",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_4_0[]=
			{
				"diw_armor_plates_main_addPlate_4_0",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_5_0[]=
			{
				"diw_armor_plates_main_addPlate_5_0",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_6_0[]=
			{
				"diw_armor_plates_main_addPlate_6_0",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_7_0[]=
			{
				"diw_armor_plates_main_addPlate_7_0",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_8_0[]=
			{
				"diw_armor_plates_main_addPlate_8_0",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_9_0[]=
			{
				"diw_armor_plates_main_addPlate_9_0",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_10_0[]=
			{
				"diw_armor_plates_main_addPlate_10_0",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_11_0[]=
			{
				"diw_armor_plates_main_addPlate_11_0",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_12_0[]=
			{
				"diw_armor_plates_main_addPlate_12_0",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_13_0[]=
			{
				"diw_armor_plates_main_addPlate_13_0",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_14_0[]=
			{
				"diw_armor_plates_main_addPlate_14_0",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_15_0[]=
			{
				"diw_armor_plates_main_addPlate_15_0",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_16_0[]=
			{
				"diw_armor_plates_main_addPlate_16_0",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_2_1[]=
			{
				"diw_armor_plates_main_addPlate_2_1",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_3_1[]=
			{
				"diw_armor_plates_main_addPlate_3_1",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_4_1[]=
			{
				"diw_armor_plates_main_addPlate_4_1",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_5_1[]=
			{
				"diw_armor_plates_main_addPlate_5_1",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_6_1[]=
			{
				"diw_armor_plates_main_addPlate_6_1",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_7_1[]=
			{
				"diw_armor_plates_main_addPlate_7_1",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_8_1[]=
			{
				"diw_armor_plates_main_addPlate_8_1",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_9_1[]=
			{
				"diw_armor_plates_main_addPlate_9_1",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_10_1[]=
			{
				"diw_armor_plates_main_addPlate_10_1",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_11_1[]=
			{
				"diw_armor_plates_main_addPlate_11_1",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_12_1[]=
			{
				"diw_armor_plates_main_addPlate_12_1",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_13_1[]=
			{
				"diw_armor_plates_main_addPlate_13_1",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_14_1[]=
			{
				"diw_armor_plates_main_addPlate_14_1",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_15_1[]=
			{
				"diw_armor_plates_main_addPlate_15_1",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_16_1[]=
			{
				"diw_armor_plates_main_addPlate_16_1",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_2_2[]=
			{
				"diw_armor_plates_main_addPlate_2_2",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_3_2[]=
			{
				"diw_armor_plates_main_addPlate_3_2",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_4_2[]=
			{
				"diw_armor_plates_main_addPlate_4_2",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_5_2[]=
			{
				"diw_armor_plates_main_addPlate_5_2",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_6_2[]=
			{
				"diw_armor_plates_main_addPlate_6_2",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_7_2[]=
			{
				"diw_armor_plates_main_addPlate_7_2",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_8_2[]=
			{
				"diw_armor_plates_main_addPlate_8_2",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_9_2[]=
			{
				"diw_armor_plates_main_addPlate_9_2",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_10_2[]=
			{
				"diw_armor_plates_main_addPlate_10_2",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_11_2[]=
			{
				"diw_armor_plates_main_addPlate_11_2",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_12_2[]=
			{
				"diw_armor_plates_main_addPlate_12_2",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_13_2[]=
			{
				"diw_armor_plates_main_addPlate_13_2",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_14_2[]=
			{
				"diw_armor_plates_main_addPlate_14_2",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_15_2[]=
			{
				"diw_armor_plates_main_addPlate_15_2",
				"Gesture"
			};
			diw_armor_plates_main_addPlate_16_2[]=
			{
				"diw_armor_plates_main_addPlate_16_2",
				"Gesture"
			};
			diw_armor_plates_main_stopGesture[]=
			{
				"diw_armor_plates_main_stopGesture",
				"Gesture"
			};
		};
	};
};
class CfgGesturesMale
{
	class Default;
	class States
	{
		class diw_armor_plates_main_addPlate_base: Default
		{
			speed=0;
			looped=0;
			file="\z\diw_armor_plates\addons\main\anims\add_plate.rtm";
			mask="handsWeapon";
			headBobStrength=0;
			headBobMode=2;
			disableWeapons=1;
			interpolationRestart=2;
			leftHandIKCurve[]={0.0099999998,1,0.1,0,0.94,0,0.98000002,1};
			rightHandIKBeg=1;
			leftHandIKEnd=1;
			rightHandIKCurve[]={1};
			weaponIK=1;
			canReload=0;
		};
		class diw_armor_plates_main_addPlate_2_0: diw_armor_plates_main_addPlate_base
		{
			speed="-2 + 0.5";
			headBobStrength="-0 * 0.25";
		};
		class diw_armor_plates_main_addPlate_3_0: diw_armor_plates_main_addPlate_base
		{
			speed="-3 + 0.5";
			headBobStrength="-0 * 0.25";
		};
		class diw_armor_plates_main_addPlate_4_0: diw_armor_plates_main_addPlate_base
		{
			speed="-4 + 0.5";
			headBobStrength="-0 * 0.25";
		};
		class diw_armor_plates_main_addPlate_5_0: diw_armor_plates_main_addPlate_base
		{
			speed="-5 + 0.5";
			headBobStrength="-0 * 0.25";
		};
		class diw_armor_plates_main_addPlate_6_0: diw_armor_plates_main_addPlate_base
		{
			speed="-6 + 0.5";
			headBobStrength="-0 * 0.25";
		};
		class diw_armor_plates_main_addPlate_7_0: diw_armor_plates_main_addPlate_base
		{
			speed="-7 + 0.5";
			headBobStrength="-0 * 0.25";
		};
		class diw_armor_plates_main_addPlate_8_0: diw_armor_plates_main_addPlate_base
		{
			speed="-8 + 0.5";
			headBobStrength="-0 * 0.25";
		};
		class diw_armor_plates_main_addPlate_9_0: diw_armor_plates_main_addPlate_base
		{
			speed="-9 + 0.5";
			headBobStrength="-0 * 0.25";
		};
		class diw_armor_plates_main_addPlate_10_0: diw_armor_plates_main_addPlate_base
		{
			speed="-10 + 0.5";
			headBobStrength="-0 * 0.25";
		};
		class diw_armor_plates_main_addPlate_11_0: diw_armor_plates_main_addPlate_base
		{
			speed="-11 + 0.5";
			headBobStrength="-0 * 0.25";
		};
		class diw_armor_plates_main_addPlate_12_0: diw_armor_plates_main_addPlate_base
		{
			speed="-12 + 0.5";
			headBobStrength="-0 * 0.25";
		};
		class diw_armor_plates_main_addPlate_13_0: diw_armor_plates_main_addPlate_base
		{
			speed="-13 + 0.5";
			headBobStrength="-0 * 0.25";
		};
		class diw_armor_plates_main_addPlate_14_0: diw_armor_plates_main_addPlate_base
		{
			speed="-14 + 0.5";
			headBobStrength="-0 * 0.25";
		};
		class diw_armor_plates_main_addPlate_15_0: diw_armor_plates_main_addPlate_base
		{
			speed="-15 + 0.5";
			headBobStrength="-0 * 0.25";
		};
		class diw_armor_plates_main_addPlate_16_0: diw_armor_plates_main_addPlate_base
		{
			speed="-16 + 0.5";
			headBobStrength="-0 * 0.25";
		};
		class diw_armor_plates_main_addPlate_2_1: diw_armor_plates_main_addPlate_base
		{
			speed="-2 + 0.5";
			headBobStrength="-1 * 0.25";
		};
		class diw_armor_plates_main_addPlate_3_1: diw_armor_plates_main_addPlate_base
		{
			speed="-3 + 0.5";
			headBobStrength="-1 * 0.25";
		};
		class diw_armor_plates_main_addPlate_4_1: diw_armor_plates_main_addPlate_base
		{
			speed="-4 + 0.5";
			headBobStrength="-1 * 0.25";
		};
		class diw_armor_plates_main_addPlate_5_1: diw_armor_plates_main_addPlate_base
		{
			speed="-5 + 0.5";
			headBobStrength="-1 * 0.25";
		};
		class diw_armor_plates_main_addPlate_6_1: diw_armor_plates_main_addPlate_base
		{
			speed="-6 + 0.5";
			headBobStrength="-1 * 0.25";
		};
		class diw_armor_plates_main_addPlate_7_1: diw_armor_plates_main_addPlate_base
		{
			speed="-7 + 0.5";
			headBobStrength="-1 * 0.25";
		};
		class diw_armor_plates_main_addPlate_8_1: diw_armor_plates_main_addPlate_base
		{
			speed="-8 + 0.5";
			headBobStrength="-1 * 0.25";
		};
		class diw_armor_plates_main_addPlate_9_1: diw_armor_plates_main_addPlate_base
		{
			speed="-9 + 0.5";
			headBobStrength="-1 * 0.25";
		};
		class diw_armor_plates_main_addPlate_10_1: diw_armor_plates_main_addPlate_base
		{
			speed="-10 + 0.5";
			headBobStrength="-1 * 0.25";
		};
		class diw_armor_plates_main_addPlate_11_1: diw_armor_plates_main_addPlate_base
		{
			speed="-11 + 0.5";
			headBobStrength="-1 * 0.25";
		};
		class diw_armor_plates_main_addPlate_12_1: diw_armor_plates_main_addPlate_base
		{
			speed="-12 + 0.5";
			headBobStrength="-1 * 0.25";
		};
		class diw_armor_plates_main_addPlate_13_1: diw_armor_plates_main_addPlate_base
		{
			speed="-13 + 0.5";
			headBobStrength="-1 * 0.25";
		};
		class diw_armor_plates_main_addPlate_14_1: diw_armor_plates_main_addPlate_base
		{
			speed="-14 + 0.5";
			headBobStrength="-1 * 0.25";
		};
		class diw_armor_plates_main_addPlate_15_1: diw_armor_plates_main_addPlate_base
		{
			speed="-15 + 0.5";
			headBobStrength="-1 * 0.25";
		};
		class diw_armor_plates_main_addPlate_16_1: diw_armor_plates_main_addPlate_base
		{
			speed="-16 + 0.5";
			headBobStrength="-1 * 0.25";
		};
		class diw_armor_plates_main_addPlate_2_2: diw_armor_plates_main_addPlate_base
		{
			speed="-2 + 0.5";
			headBobStrength="-2 * 0.25";
		};
		class diw_armor_plates_main_addPlate_3_2: diw_armor_plates_main_addPlate_base
		{
			speed="-3 + 0.5";
			headBobStrength="-2 * 0.25";
		};
		class diw_armor_plates_main_addPlate_4_2: diw_armor_plates_main_addPlate_base
		{
			speed="-4 + 0.5";
			headBobStrength="-2 * 0.25";
		};
		class diw_armor_plates_main_addPlate_5_2: diw_armor_plates_main_addPlate_base
		{
			speed="-5 + 0.5";
			headBobStrength="-2 * 0.25";
		};
		class diw_armor_plates_main_addPlate_6_2: diw_armor_plates_main_addPlate_base
		{
			speed="-6 + 0.5";
			headBobStrength="-2 * 0.25";
		};
		class diw_armor_plates_main_addPlate_7_2: diw_armor_plates_main_addPlate_base
		{
			speed="-7 + 0.5";
			headBobStrength="-2 * 0.25";
		};
		class diw_armor_plates_main_addPlate_8_2: diw_armor_plates_main_addPlate_base
		{
			speed="-8 + 0.5";
			headBobStrength="-2 * 0.25";
		};
		class diw_armor_plates_main_addPlate_9_2: diw_armor_plates_main_addPlate_base
		{
			speed="-9 + 0.5";
			headBobStrength="-2 * 0.25";
		};
		class diw_armor_plates_main_addPlate_10_2: diw_armor_plates_main_addPlate_base
		{
			speed="-10 + 0.5";
			headBobStrength="-2 * 0.25";
		};
		class diw_armor_plates_main_addPlate_11_2: diw_armor_plates_main_addPlate_base
		{
			speed="-11 + 0.5";
			headBobStrength="-2 * 0.25";
		};
		class diw_armor_plates_main_addPlate_12_2: diw_armor_plates_main_addPlate_base
		{
			speed="-12 + 0.5";
			headBobStrength="-2 * 0.25";
		};
		class diw_armor_plates_main_addPlate_13_2: diw_armor_plates_main_addPlate_base
		{
			speed="-13 + 0.5";
			headBobStrength="-2 * 0.25";
		};
		class diw_armor_plates_main_addPlate_14_2: diw_armor_plates_main_addPlate_base
		{
			speed="-14 + 0.5";
			headBobStrength="-2 * 0.25";
		};
		class diw_armor_plates_main_addPlate_15_2: diw_armor_plates_main_addPlate_base
		{
			speed="-15 + 0.5";
			headBobStrength="-2 * 0.25";
		};
		class diw_armor_plates_main_addPlate_16_2: diw_armor_plates_main_addPlate_base
		{
			speed="-16 + 0.5";
			headBobStrength="-2 * 0.25";
		};
		class GestureNod;
		class diw_armor_plates_main_stopGesture: GestureNod
		{
			file="a3\anims_f\data\anim\sdr\gst\gestureEmpty.rtm";
			disableWeapons=0;
			disableWeaponsLong=0;
			enableOptics=1;
			mask="empty";
		};
	};
};
class CfgMovesMaleSdr: CfgMovesBasic
{
	class StandBase;
	class LadderCivilStatic: StandBase
	{
		diw_armor_plates_main_isLadder=1;
	};
};
class CfgSounds
{
	sounds[]={};
	class diw_armor_plates_main_platebreak1_1
	{
		name="diw_armor_plates_main_platebreak1_1";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\platebreak1.ogg",
			"db6",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_platebreak1_2
	{
		name="diw_armor_plates_main_platebreak1_2";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\platebreak1.ogg",
			"db3",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_platebreak1_3
	{
		name="diw_armor_plates_main_platebreak1_3";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\platebreak1.ogg",
			"db0",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_platebreak1_4
	{
		name="diw_armor_plates_main_platebreak1_4";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\platebreak1.ogg",
			"db-3",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_platebreak2_1
	{
		name="diw_armor_plates_main_platebreak2_1";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\platebreak2.ogg",
			"db6",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_platebreak2_2
	{
		name="diw_armor_plates_main_platebreak2_2";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\platebreak2.ogg",
			"db3",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_platebreak2_3
	{
		name="diw_armor_plates_main_platebreak2_3";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\platebreak2.ogg",
			"db0",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_platebreak2_4
	{
		name="diw_armor_plates_main_platebreak2_4";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\platebreak2.ogg",
			"db-3",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_platebreak3_1
	{
		name="diw_armor_plates_main_platebreak3_1";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\platebreak3.ogg",
			"db6",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_platebreak3_2
	{
		name="diw_armor_plates_main_platebreak3_2";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\platebreak3.ogg",
			"db3",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_platebreak3_3
	{
		name="diw_armor_plates_main_platebreak3_3";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\platebreak3.ogg",
			"db0",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_platebreak3_4
	{
		name="diw_armor_plates_main_platebreak3_4";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\platebreak3.ogg",
			"db-3",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_hit1_1
	{
		name="diw_armor_plates_main_hit1_1";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\hit1.ogg",
			"db6",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_hit1_2
	{
		name="diw_armor_plates_main_hit1_2";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\hit1.ogg",
			"db3",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_hit1_3
	{
		name="diw_armor_plates_main_hit1_3";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\hit1.ogg",
			"db0",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_hit1_4
	{
		name="diw_armor_plates_main_hit1_4";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\hit1.ogg",
			"db-3",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_hit2_1
	{
		name="diw_armor_plates_main_hit2_1";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\hit2.ogg",
			"db6",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_hit2_2
	{
		name="diw_armor_plates_main_hit2_2";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\hit2.ogg",
			"db3",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_hit2_3
	{
		name="diw_armor_plates_main_hit2_3";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\hit2.ogg",
			"db0",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_hit2_4
	{
		name="diw_armor_plates_main_hit2_4";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\hit2.ogg",
			"db-3",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_hit3_1
	{
		name="diw_armor_plates_main_hit3_1";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\hit3.ogg",
			"db6",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_hit3_2
	{
		name="diw_armor_plates_main_hit3_2";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\hit3.ogg",
			"db3",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_hit3_3
	{
		name="diw_armor_plates_main_hit3_3";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\hit3.ogg",
			"db0",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_hit3_4
	{
		name="diw_armor_plates_main_hit3_4";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\hit3.ogg",
			"db-3",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_headshot1_1
	{
		name="diw_armor_plates_main_headshot1_1";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\headshot1.ogg",
			"db6",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_headshot1_2
	{
		name="diw_armor_plates_main_headshot1_2";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\headshot1.ogg",
			"db3",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_headshot1_3
	{
		name="diw_armor_plates_main_headshot1_3";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\headshot1.ogg",
			"db0",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_headshot1_4
	{
		name="diw_armor_plates_main_headshot1_4";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\headshot1.ogg",
			"db-3",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_headshot2_1
	{
		name="diw_armor_plates_main_headshot2_1";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\headshot2.ogg",
			"db6",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_headshot2_2
	{
		name="diw_armor_plates_main_headshot2_2";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\headshot2.ogg",
			"db3",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_headshot2_3
	{
		name="diw_armor_plates_main_headshot2_3";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\headshot2.ogg",
			"db0",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_headshot2_4
	{
		name="diw_armor_plates_main_headshot2_4";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\headshot2.ogg",
			"db-3",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_headshot3_1
	{
		name="diw_armor_plates_main_headshot3_1";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\headshot3.ogg",
			"db6",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_headshot3_2
	{
		name="diw_armor_plates_main_headshot3_2";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\headshot3.ogg",
			"db3",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_headshot3_3
	{
		name="diw_armor_plates_main_headshot3_3";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\headshot3.ogg",
			"db0",
			1,
			100
		};
		titles[]={};
	};
	class diw_armor_plates_main_headshot3_4
	{
		name="diw_armor_plates_main_headshot3_4";
		sound[]=
		{
			"\z\diw_armor_plates\addons\main\sounds\headshot3.ogg",
			"db-3",
			1,
			100
		};
		titles[]={};
	};
};
class CfgVehicles
{
	class Item_Base_F;
	class diw_armor_plates_main_plateItem: Item_Base_F
	{
		scope=2;
		scopeCurator=2;
		displayName="Armor Plate";
		author="diwako";
		model="\A3\Weapons_F\DummyItemHorizontal.p3d";
		vehicleClass="Items";
		class TransportItems
		{
			class _xx_plate
			{
				name="diw_armor_plates_main_plate";
				count=1;
			};
		};
	};
	class diw_armor_plates_main_autoInjectorItem: diw_armor_plates_main_plateItem
	{
		editorPreview="\A3\EditorPreviews_F_Orange\Data\CfgVehicles\MedicalGarbage_01_Injector_F.jpg";
		displayName="Auto-Injector";
		author="alien314";
		model="\A3\Weapons_F\DummyItem.p3d";
		class TransportItems
		{
			class _xx_autoInjector
			{
				name="diw_armor_plates_main_autoInjector";
				count=1;
			};
		};
	};
	class Module_F;
	class diw_armor_plates_main_moduleBase: Module_F
	{
		author="$STR_diw_armor_plates_main_category";
		category="APS";
		function="";
		functionPriority=1;
		isGlobal=1;
		isTriggerActivated=0;
		scope=1;
		scopeCurator=2;
	};
	class diw_armor_plates_main_moduleHeal: diw_armor_plates_main_moduleBase
	{
		curatorCanAttach=1;
		displayName="$STR_diw_armor_plates_main_zeus_module_heal";
		function="diw_armor_plates_main_fnc_moduleHeal";
		icon="\A3\ui_f\data\Map\VehicleIcons\pictureHeal_ca.paa";
	};
	class diw_armor_plates_main_modulePlate: diw_armor_plates_main_moduleBase
	{
		curatorCanAttach=1;
		displayName="$STR_diw_armor_plates_main_zeus_module_plate";
		function="diw_armor_plates_main_fnc_modulePlate";
		icon="\a3\ui_f\data\gui\rsc\rscdisplayarsenal\vest_ca.paa";
	};
	class diw_armor_plates_main_moduleResetMalus: diw_armor_plates_main_moduleBase
	{
		curatorCanAttach=1;
		displayName="$STR_diw_armor_plates_main_zeus_module_malus";
		function="diw_armor_plates_main_fnc_moduleResetMalus";
		icon="\z\diw_armor_plates\addons\main\ui\autoInjector_ca.paa";
	};
	class diw_armor_plates_main_moduleResetMalusGlobal: diw_armor_plates_main_moduleBase
	{
		curatorCanAttach=1;
		displayName="$STR_diw_armor_plates_main_zeus_module_malusGlobal";
		function="diw_armor_plates_main_fnc_moduleResetMalusGlobal";
		icon="\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa";
	};
	class Camping_base_F;
	class Land_MedicalTent_01_base_F: Camping_base_F
	{
		class EventHandlers
		{
			class diw_armor_plates_main_medTent
			{
				postInit="_this spawn diw_armor_plates_main_fnc_addStructureHeal;";
			};
		};
	};
};
class CfgWeapons
{
	class CBA_MiscItem;
	class CBA_MiscItem_ItemInfo;
	class diw_armor_plates_main_plate: CBA_MiscItem
	{
		scope=2;
		author="diwako";
		model="a3\Props_F_Orange\Humanitarian\Garbage\MedicalGarbage_01_Injector_F.p3d";
		picture="\z\diw_armor_plates\addons\main\ui\armor_plate_ca.paa";
		displayName="$STR_diw_armor_plates_main_plateItem";
		descriptionShort="$STR_diw_armor_plates_main_plateIteml_Desc_Short";
		descriptionUse="$STR_diw_armor_plates_main_plateIteml_Desc_Use";
		class ItemInfo: CBA_MiscItem_ItemInfo
		{
			mass=35;
		};
	};
	class diw_armor_plates_main_autoInjector: diw_armor_plates_main_plate
	{
		author="alien314, KrazyKat";
		model="a3\Props_F_Orange\Humanitarian\Garbage\MedicalGarbage_01_Injector_F.p3d";
		picture="\z\diw_armor_plates\addons\main\ui\autoInjector_ca.paa";
		displayName="$STR_diw_armor_plates_main_autoinjectorItem";
		descriptionShort="$STR_diw_armor_plates_main_autoinjectorIteml_Desc_Short";
		descriptionUse="$STR_diw_armor_plates_main_autoinjectorIteml_Desc_Use";
		diw_armor_plates_main_isInjector=1;
		class ItemInfo: CBA_MiscItem_ItemInfo
		{
			mass=7;
		};
	};
};
class CfgFunctions
{
	class A3_Mark
	{
		class Revive
		{
			class reviveInit
			{
				postInit=0;
			};
		};
	};
};
class ACE_Medical_Injuries
{
	class damageTypes
	{
		class woundHandlers;
		class bullet
		{
			class woundHandlers: woundHandlers
			{
				diw_armor_plates_main="diw_armor_plates_main_fnc_aceDamageHandler";
			};
		};
		class grenade
		{
			class woundHandlers: woundHandlers
			{
				diw_armor_plates_main="diw_armor_plates_main_fnc_aceDamageHandler";
			};
		};
		class explosive
		{
			class woundHandlers: woundHandlers
			{
				diw_armor_plates_main="diw_armor_plates_main_fnc_aceDamageHandler";
			};
		};
		class shell
		{
			class woundHandlers: woundHandlers
			{
				diw_armor_plates_main="diw_armor_plates_main_fnc_aceDamageHandler";
			};
		};
		class stab
		{
			class woundHandlers: woundHandlers
			{
				diw_armor_plates_main="diw_armor_plates_main_fnc_aceDamageHandler";
			};
		};
		class punch
		{
			class woundHandlers: woundHandlers
			{
				diw_armor_plates_main="diw_armor_plates_main_fnc_aceDamageHandler";
			};
		};
		class unknown
		{
			class woundHandlers: woundHandlers
			{
				diw_armor_plates_main="diw_armor_plates_main_fnc_aceDamageHandler";
			};
		};
	};
};
