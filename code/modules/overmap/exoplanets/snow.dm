/obj/effect/overmap/sector/exoplanet/snow
	name = "snow exoplanet"
	desc = "Cold planet with limited plant life."
	color = "#e8faff"

/obj/effect/overmap/sector/exoplanet/snow/generate_map()
	for(var/zlevel in map_z)
		var/datum/random_map/noise/exoplanet/M = new /datum/random_map/noise/exoplanet/snow(md5(world.time + rand(-100,1000)),1,1,zlevel,maxx,maxy,0,1,1)
		get_biostuff(M)
		new /datum/random_map/noise/ore/poor(md5(world.time + rand(-100,1000)),1,1,zlevel,maxx,maxy,0,1,1)

/obj/effect/overmap/sector/exoplanet/snow/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.temperature = T0C - rand(10, 100)
		atmosphere.update_values()

/datum/random_map/noise/exoplanet/snow
	descriptor = "snow exoplanet"
	smoothing_iterations = 3
	flora_prob = 50
	large_flora_prob = 50
	water_level_min = 0
	water_level_max = 1
	land_type = /turf/simulated/floor/exoplanet/snow
	//water_type = /turf/simulated/floor/exoplanet/ice
	water_type = /obj/effect/waterspawn
	planetary_area = /area/exoplanet/snow
	//fauna_types = list(/mob/living/simple_animal/hostile/dog)
	//fauna_types = list(/mob/living/simple_animal/hostile/retaliate/beast/samak, /mob/living/simple_animal/hostile/retaliate/beast/diyaab, /mob/living/simple_animal/hostile/retaliate/beast/shantak)
	fauna_types = list(/mob/living/simple_animal/cow) //They just somehow appear there
	plantcolors = list("#d0fef5","#93e1d8","#93e1d8", "#b2abbf", "#3590f3", "#4b4e6d")

/area/exoplanet/snow
	ambience = list('sound/effects/wind/tundra0.ogg','sound/effects/wind/tundra1.ogg','sound/effects/wind/tundra2.ogg','sound/effects/wind/spooky0.ogg','sound/effects/wind/spooky1.ogg')
	base_turf = /turf/simulated/floor/exoplanet/snow/

/datum/random_map/noise/ore/poor
	deep_val = 0.8
	rare_val = 0.9

/obj/effect/waterspawn //Randomly generates a big enough spot of water
	name = "water spawner boi"

/obj/effect/waterspawn/Initialize()
	..()
	for(var/turf/t in range(2)) //Forgive me for all of this
		t.ChangeTurf(/turf/simulated/floor/exoplanet/water/shallow) //base of water
	for(var/turf/t2 in range(3))
		if(prob(75)) //The outer edges of the water spot will have some missing spots
			t2.ChangeTurf(/turf/simulated/floor/exoplanet/water/shallow)

/turf/simulated/floor/exoplanet/ice
	name = "ice"
	icon = 'icons/turf/snow.dmi'
	icon_state = "ice"

/turf/simulated/floor/exoplanet/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

/turf/simulated/floor/exoplanet/snow/New()
	icon_state = pick("snow[rand(1,12)]","snow0")
	..()

/turf/simulated/floor/exoplanet/snow/fire_act(datum/gas_mixture/air, temperature, volume)
	name = "permafrost"
	icon_state = "permafrost"

/datum/random_map/noise/exoplanet/snow/replace_space
	descriptor = "snoww exoplanet replaces space"
	target_turf_type = /turf/space
