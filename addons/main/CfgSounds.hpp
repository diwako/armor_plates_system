#define SOUND_ID(SOUNDNAME,ID,VOL) \
    class TRIPLES(ADDON,SOUNDNAME,ID) { \
        name = QUOTE(TRIPLES(ADDON,SOUNDNAME,ID)); \
        sound[] = {QPATHTOF(sounds\SOUNDNAME.ogg), QUOTE(VOL), 1, 100}; \
        titles[] = {}; \
    }

#define SOUND(SOUNDNAME) \
    SOUND_ID(SOUNDNAME,1,db23); \
    SOUND_ID(SOUNDNAME,2,db20); \
    SOUND_ID(SOUNDNAME,3,db15); \
    SOUND_ID(SOUNDNAME,4,db9); \
    SOUND_ID(SOUNDNAME,5,db0);


class CfgSounds {
    sounds[] = {};

    SOUND(platebreak1)
    SOUND(platebreak2)
    SOUND(platebreak3)

    SOUND(hit1)
    SOUND(hit2)
    SOUND(hit3)

    SOUND(headshot1)
    SOUND(headshot2)
    SOUND(headshot3)
};
