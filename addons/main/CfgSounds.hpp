#define SOUND_ID(SOUNDNAME,ID,VOL) \
    class TRIPLES(ADDON,SOUNDNAME,ID) { \
        name = QUOTE(TRIPLES(ADDON,SOUNDNAME,ID)); \
        sound[] = {QPATHTOF(sounds\SOUNDNAME.ogg), QUOTE(VOL), 1, 100}; \
        titles[] = {}; \
    }

#define SOUND(SOUNDNAME) \
    SOUND_ID(SOUNDNAME,1,db6); \
    SOUND_ID(SOUNDNAME,2,db3); \
    SOUND_ID(SOUNDNAME,3,db0); \
    SOUND_ID(SOUNDNAME,5,db-3);


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
