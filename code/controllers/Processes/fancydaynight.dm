/datum/controller/process/fancydaynight
	var/stateofday = "day" //starts off on day
	var/turf/dayturf = /turf/simulated/floor/exoplanet/grass //Wanna make day time turn the world to lava? well here ya go then
	var/turf/nightturf = /turf/simulated/floor/exoplanet/snow/
	var/turf/currentturf //Turf for stuff to be made into
	var/currentlum = 1 //Game starts off white and transition to night later on
	var/intx = 0

/datum/controller/process/fancydaynight/setup()
	name = "day night cycler"
	schedule_interval = 1200 //short time for testing purposes
	nighttoday() //game starts off dark; make it daytime

/datum/controller/process/fancydaynight/doWork()
	if(stateofday == "day")
		stateofday = "night"
		daytonight()
	else
		stateofday = "day"
		nighttoday()

/datum/controller/process/fancydaynight/proc/daytonight()
	sound_to(world, sound('rimss13/ash_storm_windup.ogg'))
	to_world("<span class='warning'>The night begins to come, find a place not exposed to the elements and a nearby fire if you wish to not die.</span>")
	while(currentlum != 1) //loop it a couple of times from darkness to complete day
		intx = 0
		while(intx != 255)
			sleep(1)
			for(var/turf/turf in block(locate(intx, 1, 1), locate(intx, world.maxy, 1)))
				if(!turf)
					continue
				turf.adjustambientlight(currentlum)
			intx += 1
		currentlum = max(currentlum - 150, 1)
	sound_to(world, sound('rimss13/ash_storm_start.ogg'))
	to_world("<span class='warning'>The night has come, stay sheltered.</span>")


/datum/controller/process/fancydaynight/proc/nighttoday()
	sound_to(world, sound('rimss13/ash_storm_windup.ogg'))
	to_world("<span class='warning'>The night is slowly going away but it is yet safe to go outside.</span>")
	while(currentlum != 255) //loop it a couple of times from darkness to complete day
		intx = 0
		while(intx != 255)
			sleep(1)
			for(var/turf/turf in block(locate(intx, 1, 1), locate(intx, world.maxy, 1)))
				if(!turf)
					continue
				turf.adjustambientlight(currentlum)
			intx += 1
		currentlum = max(currentlum + 150, 255)
	sound_to(world, sound('rimss13/ash_storm_end.ogg'))
	to_world("<span class='warning'>The night has now ended, it's surely safe to go outside now.</span>")


/turf/proc/adjustambientlight(currentlum)
	for (var/datum/lighting_corner/corner in corners)
		corner.lum_r = currentlum
		corner.lum_g = currentlum
		corner.lum_b = currentlum
		corner.update_overlays()
/*
	switch(stateofday)
		if("day")
			stateofday = "night"
			currentturf = nightturf
		if("night")
			stateofday = "day"
			currentturf = dayturf
	//for(var/turf/t in world)
	for(var/turf/t in block(locate(1, 1, 1), locate(1, 255, 1)))
		if(isturf(t))
			t.ChangeTurf(currentturf)
*/
