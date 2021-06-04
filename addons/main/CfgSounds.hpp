#define SOUND_ID(SOUNDNAME,ID,VOL) \
    class TRIPLES(ADDON,SOUNDNAME,ID) { \
        name = QUOTE(TRIPLES(ADDON,SOUNDNAME,ID)); \
        sound[] = {QPATHTOF(sounds\SOUNDNAME.ogg), VOL, 1, 100}; \
        titles[] = {}; \
    }

#define SOUND(SOUNDNAME) \
    SOUND_ID(SOUNDNAME,1,2); \
    SOUND_ID(SOUNDNAME,2,1.75); \
    SOUND_ID(SOUNDNAME,3,1.5); \
    SOUND_ID(SOUNDNAME,4,1); \
    SOUND_ID(SOUNDNAME,5,0.75); \
    SOUND_ID(SOUNDNAME,6,0.5); \
    SOUND_ID(SOUNDNAME,7,0.25);


class CfgSounds {
    sounds[] = {};

    SOUND(platebreak1)
    SOUND(platebreak2)
    SOUND(platebreak3)
    SOUND(platebreak4)
    SOUND(platebreak5)
    SOUND(platebreak6)
    SOUND(platebreak7)

    SOUND(hit1)
    SOUND(hit2)
    SOUND(hit3)
    SOUND(hit4)
    SOUND(hit5)
    SOUND(hit6)
    SOUND(hit7)
    SOUND(hit8)
    SOUND(hit9)
    SOUND(hit10)

    SOUND(headshot1)
    SOUND(headshot2)
};
