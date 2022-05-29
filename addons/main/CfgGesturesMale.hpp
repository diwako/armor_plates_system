class CfgMovesBasic {
    class ManActions {
        GVAR(addPlate_base)= QGVAR(addPlate_base);
        GVAR(addPlate_2)= QGVAR(addPlate_2);
        GVAR(addPlate_3)= QGVAR(addPlate_3);
        GVAR(addPlate_4)= QGVAR(addPlate_4);
        GVAR(addPlate_5)= QGVAR(addPlate_5);
        GVAR(addPlate_6)= QGVAR(addPlate_6);
        GVAR(addPlate_7)= QGVAR(addPlate_7);
        GVAR(addPlate_8)= QGVAR(addPlate_8);
        GVAR(addPlate_9)= QGVAR(addPlate_9);
        GVAR(addPlate_10)= QGVAR(addPlate_10);
        GVAR(addPlate_11)= QGVAR(addPlate_11);
        GVAR(addPlate_12)= QGVAR(addPlate_12);
        GVAR(addPlate_13)= QGVAR(addPlate_13);
        GVAR(addPlate_14)= QGVAR(addPlate_14);
        GVAR(stopGesture) = QGVAR(stopGesture);
    };
    class Actions {
        class Default;
        class NoActions: ManActions {
            GVAR(addPlate_base)[]= {QGVAR(addPlate_base), "Gesture"};
            GVAR(addPlate_2)[]= {QGVAR(addPlate_2), "Gesture"};
            GVAR(addPlate_3)[]= {QGVAR(addPlate_3), "Gesture"};
            GVAR(addPlate_4)[]= {QGVAR(addPlate_4), "Gesture"};
            GVAR(addPlate_5)[]= {QGVAR(addPlate_5), "Gesture"};
            GVAR(addPlate_6)[]= {QGVAR(addPlate_6), "Gesture"};
            GVAR(addPlate_7)[]= {QGVAR(addPlate_7), "Gesture"};
            GVAR(addPlate_8)[]= {QGVAR(addPlate_8), "Gesture"};
            GVAR(addPlate_9)[]= {QGVAR(addPlate_9), "Gesture"};
            GVAR(addPlate_10)[]= {QGVAR(addPlate_10), "Gesture"};
            GVAR(addPlate_11)[]= {QGVAR(addPlate_11), "Gesture"};
            GVAR(addPlate_12)[]= {QGVAR(addPlate_12), "Gesture"};
            GVAR(addPlate_13)[]= {QGVAR(addPlate_13), "Gesture"};
            GVAR(addPlate_14)[]= {QGVAR(addPlate_14), "Gesture"};
            GVAR(addPlate_15)[]= {QGVAR(addPlate_15), "Gesture"};
            GVAR(addPlate_16)[]= {QGVAR(addPlate_16), "Gesture"};
            GVAR(stopGesture)[] = {QGVAR(stopGesture), "Gesture"};
        };
    };
};

#define ADDPLATE(SECONDS) \
    class TRIPLES(ADDON,addPlate,SECONDS): GVAR(addPlate_base) { \
        speed = QUOTE(-SECONDS + 0.5); \
    }

class CfgGesturesMale {
    class Default;
    class States {
        class GVAR(addPlate_base): Default {
            speed = 0;
            looped = 0;
            file = QPATHTOF(anims\add_plate.rtm);
            mask = "handsWeapon";
            headBobStrength = -1;
            headBobMode = 4;
            disableWeapons = 1;
            interpolationRestart = 2;
            leftHandIKCurve[] = {0.01,1,0.1,0,0.94,0,0.98,1};
            rightHandIKBeg = 1;
            leftHandIKEnd = 1;
            rightHandIKCurve[] = {1};
            weaponIK = 1;
            canReload = 0;
        };
        ADDPLATE(2);
        ADDPLATE(3);
        ADDPLATE(4);
        ADDPLATE(5);
        ADDPLATE(6);
        ADDPLATE(7);
        ADDPLATE(8);
        ADDPLATE(9);
        ADDPLATE(10);
        ADDPLATE(11);
        ADDPLATE(12);
        ADDPLATE(13);
        ADDPLATE(14);
        ADDPLATE(15);
        ADDPLATE(16);
        class GestureNod;
        class GVAR(stopGesture): GestureNod {
            file = "a3\anims_f\data\anim\sdr\gst\gestureEmpty.rtm";
            disableWeapons = 0;
            disableWeaponsLong = 0;
            enableOptics = 1;
            mask = "empty";
        };
    };
};
