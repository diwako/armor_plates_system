class ACE_Medical_Injuries {
    class damageTypes {
        class woundHandlers;
        class burn {
            class woundHandlers: woundHandlers {
                ADDON = QEFUNC(main,aceDamageHandler);
            };
        };
    };
};
