#define MAINPREFIX z
#define PREFIX diw_armor_plates

#include "script_version.hpp"

#define VERSION         MAJOR.MINOR
#define VERSION_STR     MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_AR      MAJOR,MINOR,PATCHLVL,BUILD
#define VERSION_PLUGIN  MAJOR.MINOR.PATCHLVL.BUILD

#define REQUIRED_VERSION 2.04

#ifdef COMPONENT_BEAUTIFIED
    #define COMPONENT_NAME QUOTE(Armor Plates Medical COMPONENT_BEAUTIFIED)
#else
    #define COMPONENT_NAME QUOTE(Armor Plates Medical COMPONENT)
#endif

