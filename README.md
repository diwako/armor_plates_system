# Armor Plates System

Standalone Arma 3 Alternative Medical System

## Features

-   Many settings to fit your play style
-   Lightweight
-   ACE features support
-   Own revive system (Only when ACE medical is not loaded)
-   UI and QoL additions
-   ACE medical rewrite support

## Info - Standalone mode

The Armor Plates System is at its core a stand-alone medical system. It is meant to abstract Arma 3’s vanilla damage and streamline the vanilla medical system. It draws inspiration from COD MW Warzone’s medical system and allows you to put ceramic plates into your vest which act as additional HP.

Originally this system was created to accommodate the play style used by the streamer Beagle over at https://www.twitch.tv/beagsandjam/ , though as usual I want to share this with the whole community.

This system gives each unit health points (HP) which will be reduced by incoming damage. The armor plates have their own amount of HP which will act as a layer above the unit’s HP. The unit will only take damage if the ceramic plates in the unit’s vests are fully destroyed. The ceramic plates themselves are an inventory item that needs to be inserted into vests to provide protection. In order to put a ceramic plate into your vest, you must have a ceramic plate item in your inventory and press and hold the key bind to perform the action (default: T). This keybind can be changed.

This mod also includes new UI elements such as damage direction indicators, on-hit sound indicators, and downed icons in 3D space. These are meant to aid newer players or help players make sense of a chaotic battlefield. All of these features can be disabled or customized under “Armor Plates System” inside Addon Options.

Your unit’s HP and armor plates are shown beneath the stamina bar. Switching units and even remote controlling them with Zeus is supported. The armor plate color can be adjusted in “Addon Options” while the rest of the colors will use your current HUD settings.

This system makes heavy use of CBA settings, allowing server owners or mission makers to make players or AI as tanky or brittle as you’d like. If you are playing a mission that is incompatible with this system or uses its own medical system with it, you can simply disable the Armor Plates System, restart the mission, and play the mission without this mod interfering. However, ALL of the mod’s features will be disabled!

## Info - ACE Medical mode

When ACE with its medical components (rewrite and NOT old medical!) is loaded, APS will switch its standalone arcade mode to a more realistically one. In this mode the plates in your vest will only protect from gunshots and blunt force to your torso. If your limbs or your head gets hit, it will react as ACE medical normally would. There will not be any unit HP either, as this does not fit into the ACE medical system with its structural damage and blood simulation. Many of the standalone mode’s features will be disabled, some feedback features will be still available, but turned off by default.

Ceramic plates now have a certain thickness (settable in addon options) which bullets can penetrate and bleed damage to the lower plates, or to your torso. Ceramic plates are also getting destroyed faster the less integrity (health) they have left, making it more likely that a gunshot will damage deeper protective layers.

Overall, this will make units with ceramic plates in their vests more survivable, but only temporarily as the plates can be destroyed. Damage to units without any plates will behave the same as ACE medical. Going for the head will still work as before.

## Links

Steam workshop: https://steamcommunity.com/sharedfiles/filedetails/?edit=true&id=2523439183 \
BI thread: https://forums.bohemia.net/forums/topic/235085-armor-plates-system-standalone-alternative-medical-system/
