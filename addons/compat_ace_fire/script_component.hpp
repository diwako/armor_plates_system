#define COMPONENT compat_ace_fire
#define COMPONENT_BEAUTIFIED ACE Fire Compat
#define REPLACEMOD ace_fire
#define REPLACEPATH "z\ace\addons\fire"

#include "\z\diw_armor_plates\addons\main\script_mod.hpp"

#include "\z\diw_armor_plates\addons\main\script_macros.hpp"

#define PRONE_ROLLING_ANIMS [\
    "amovppnemstpsnonwnondnon_amovppnemevasnonwnondl",\
    "amovppnemstpsnonwnondnon_amovppnemevasnonwnondr",\
    "amovppnemstpsraswrfldnon_amovppnemevaslowwrfldl",\
    "amovppnemstpsraswrfldnon_amovppnemevaslowwrfldr",\
    "amovppnemstpsraswpstdnon_amovppnemevaslowwpstdl",\
    "amovppnemstpsraswpstdnon_amovppnemevaslowwpstdr",\
    "amovppnemstpsoptwbindnon_amovppnemevasoptwbindl",\
    "amovppnemstpsoptwbindnon_amovppnemevasoptwbindr"\
]

#define BURN_MAX_INTENSITY 10
#define BURN_MIN_INTENSITY 1

#define INTENSITY_DECREASE_MULT_PAT_DOWN 0.8
#define INTENSITY_DECREASE_MULT_ROLLING INTENSITY_DECREASE_MULT_PAT_DOWN

#define INTENSITY_LOSS 0.02
#define INTENSITY_UPDATE 2
#define BURN_PROPAGATE_UPDATE 1
#define BURN_PROPAGATE_DISTANCE 2
#define BURN_THRESHOLD_INTENSE 3
