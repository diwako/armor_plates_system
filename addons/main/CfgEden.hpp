class Cfg3DEN {
    class Attributes {
        class Slider;
        class GVAR(maxHpSlider): Slider {
            attributeLoad = "params [""_ctrlGroup""];\
            private _slider = _ctrlGroup controlsGroupCtrl 100;\
            private _edit = _ctrlGroup controlsGroupCtrl 101;\
            _slider sliderSetPosition _value;\
            _edit ctrlSetText (if (_value < 0.1) then {localize ""str_disp_default""} else {[_value, 1, 1] call CBA_fnc_formatNumber});";
            attributeSave = "params [""_ctrlGroup""];\
            sliderPosition (_ctrlGroup controlsGroupCtrl 100); ";
            onLoad = "params [""_ctrlGroup""];\
            private _slider = _ctrlGroup controlsGroupCtrl 100;\
            private _edit = _ctrlGroup controlsGroupCtrl 101;\
            _slider sliderSetRange [0, 1000];\
            _slider ctrlAddEventHandler [""SliderPosChanged"", {\
                params [""_slider""];\
                private _edit = (ctrlParentControlsGroup _slider) controlsGroupCtrl 101;\
                private _value = sliderPosition _slider;\
                _edit ctrlSetText (if (_value < 0.1) then {localize ""str_disp_default""} else {[_value, 1, 1] call CBA_fnc_formatNumber});\
            }];\
            _edit ctrlAddEventHandler [""KillFocus"", {\
                params [""_edit""];\
                private _slider = (ctrlParentControlsGroup _edit) controlsGroupCtrl 100;\
                private _value = ((parseNumber ctrlText _edit) min 1000) max 0;\
                _slider sliderSetPosition _value;\
                _edit ctrlSetText (if (_value < 0.1) then { localize ""str_disp_default"" } else {[_value, 1, 1] call CBA_fnc_formatNumber});\
            }];";
        };
        class GVAR(maxPlateInVestSlider): Slider {
            attributeLoad = "params [""_ctrlGroup""];\
            private _slider = _ctrlGroup controlsGroupCtrl 100;\
            private _edit = _ctrlGroup controlsGroupCtrl 101;\
            _slider sliderSetPosition _value;\
            _edit ctrlSetText (if (_value < 0) then {localize ""str_disp_default""} else {[_value, 1, 0] call CBA_fnc_formatNumber});";
            attributeSave = "params [""_ctrlGroup""];\
            sliderPosition (_ctrlGroup controlsGroupCtrl 100); ";
            onLoad = "params [""_ctrlGroup""];\
            private _slider = _ctrlGroup controlsGroupCtrl 100;\
            private _edit = _ctrlGroup controlsGroupCtrl 101;\
            _slider sliderSetRange [-1, 10];\
            _slider ctrlAddEventHandler [""SliderPosChanged"", {\
                params [""_slider""];\
                private _edit = (ctrlParentControlsGroup _slider) controlsGroupCtrl 101;\
                private _value = sliderPosition _slider;\
                _edit ctrlSetText (if (_value < 0) then {localize ""str_disp_default""} else {[_value, 1, 0] call CBA_fnc_formatNumber});\
            }];\
            _edit ctrlAddEventHandler [""KillFocus"", {\
                params [""_edit""];\
                private _slider = (ctrlParentControlsGroup _edit) controlsGroupCtrl 100;\
                private _value = ((parseNumber ctrlText _edit) min 10) max -1;\
                _slider sliderSetPosition _value;\
                _edit ctrlSetText (if (_value < 0) then { localize ""str_disp_default"" } else {[_value, 1, 0] call CBA_fnc_formatNumber});\
            }];";
        };
        class GVAR(maxPlateInInventorSlider): Slider {
            attributeLoad = "params [""_ctrlGroup""];\
            private _slider = _ctrlGroup controlsGroupCtrl 100;\
            private _edit = _ctrlGroup controlsGroupCtrl 101;\
            _slider sliderSetPosition _value;\
            _edit ctrlSetText (if (_value < 0) then {localize ""str_disp_default""} else {[_value, 1, 0] call CBA_fnc_formatNumber});";
            attributeSave = "params [""_ctrlGroup""];\
            sliderPosition (_ctrlGroup controlsGroupCtrl 100); ";
            onLoad = "params [""_ctrlGroup""];\
            private _slider = _ctrlGroup controlsGroupCtrl 100;\
            private _edit = _ctrlGroup controlsGroupCtrl 101;\
            _slider sliderSetRange [-1, 10];\
            _slider ctrlAddEventHandler [""SliderPosChanged"", {\
                params [""_slider""];\
                private _edit = (ctrlParentControlsGroup _slider) controlsGroupCtrl 101;\
                private _value = sliderPosition _slider;\
                _edit ctrlSetText (if (_value < 0) then {localize ""str_disp_default""} else {[_value, 1, 0] call CBA_fnc_formatNumber});\
            }];\
            _edit ctrlAddEventHandler [""KillFocus"", {\
                params [""_edit""];\
                private _slider = (ctrlParentControlsGroup _edit) controlsGroupCtrl 100;\
                private _value = ((parseNumber ctrlText _edit) min 10) max -1;\
                _slider sliderSetPosition _value;\
                _edit ctrlSetText (if (_value < 0) then { localize ""str_disp_default"" } else {[_value, 1, 0] call CBA_fnc_formatNumber});\
            }];";
        };
    };
    class Object {
        class AttributeCategories {
            class GVAR(attributes) {
                displayName = CSTRING(Eden_options);
                collapsed = 1;
                class Attributes {
                    class GVAR(threshold) {
                        property = QUOTE(threshold);
                        control = QGVAR(maxHpSlider);
                        displayName = CSTRING(Eden_maxHp);
                        tooltip = CSTRING(Eden_maxHp_desc);
                        expression = QUOTE(if (_value >= 0.1) then {_this setVariable [ARR_3(QQGVAR(maxHp),_value,true)]});
                        typeName = "NUMBER";
                        condition = "objectControllable";
                        defaultValue = 0;
                    };
                    class GVAR(maxPlateInVest) {
                        property = QUOTE(maxPlateInVest);
                        control = QGVAR(maxPlateInVestSlider);
                        displayName = CSTRING(maxPlateInVest);
                        tooltip = CSTRING(maxPlateInVest_desc);
                        expression = QUOTE(if (_value >= 0) then {_this setVariable [ARR_3(QQGVAR(3den_maxPlateInVest),round _value,true)]});
                        typeName = "NUMBER";
                        condition = "objectControllable";
                        defaultValue = -1;
                    };
                    class GVAR(maxPlateInInventor) {
                        property = QUOTE(maxPlateInInventor);
                        control = QGVAR(maxPlateInInventorSlider);
                        displayName = CSTRING(maxPlateInInventor);
                        tooltip = CSTRING(maxPlateInInventor_desc);
                        expression = QUOTE(if (_value >= 0) then {_this setVariable [ARR_3(QQGVAR(3den_maxPlateInInventory),round _value,true)]});
                        typeName = "NUMBER";
                        condition = "objectControllable";
                        defaultValue = -1;
                    };
                };
            };
        };
    };
};
