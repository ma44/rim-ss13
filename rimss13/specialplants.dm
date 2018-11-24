/datum/seed/rim //Seeds that are special; extremely resiliant somehow
  name = "???"
  seed_name = "???"
  display_name = "???"
  set_trait(TRAIT_IMMUTABLE,            0)
  set_trait(TRAIT_HARVEST_REPEAT,       0)
  set_trait(TRAIT_CARNIVOROUS,          1) //Somehow eats pests in its place, go figure
  set_trait(TRAIT_PARASITE,             1) //Also heals off of weeds, magical
  set_trait(TRAIT_YIELD,                2)
  set_trait(TRAIT_MATURATION,           5)
	set_trait(TRAIT_PRODUCTION,           5)
  set_trait(TRAIT_REQUIRES_NUTRIENTS,   0)
	set_trait(TRAIT_REQUIRES_WATER,       0)
  set_trait(TRAIT_WATER_CONSUMPTION,    0)
  set_trait(TRAIT_LIGHT_TOLERANCE,      99) //Doesn't care about light on this day and night world
  set_trait(TRAIT_IDEAL_LIGHT,          0)
  set_trait(TRAIT_PEST_TOLERANCE,       99)            
	set_trait(TRAIT_WEED_TOLERANCE,       99)
  set_trait(TRAIT_ENDURANCE,            9999) //It don't care about the damm world

/datum/seed/potato/rim
  name = "strange potatos"
  seed_name = "strange potato"
  display_name = "strange potatos"
  chems = list(/datum/reagent/nutriment = list(5))
