/datum/controller/process/fancydaynight
	var/stateofday = "day"
	var/turf/dayturf = /turf/simulated/floor/exoplanet/grass //Wanna make day time turn the world to lava? well here ya go then
	var/turf/nightturf = /turf/simulated/floor/exoplanet/snow/
	var/turf/currentturf //Turf for stuff to be made into
	var/currentlum = 1 //Starts off black but slowly to white
	var/intx = 0
	var/working = 0 //if it's currently doing fancy transition

/datum/controller/process/fancydaynight/setup()
	name = "day night cycler"
	schedule_interval = 1800 //short time for testing purposes

/datum/controller/process/fancydaynight/doWork()
	if(working)
		schedule_interval = 100 //try again later
		return
	else
		while(currentlum != 255) //loop it a couple of times from darkness to complete day
			intx = 0
			while(intx != 255)
				sleep(1)
				for(var/turf/turf in block(locate(intx, 1, 1), locate(intx, world.maxy, 1)))
					if(!turf)
						continue
					turf.adjustambientlight(currentlum)
				intx += 1
			currentlum = max(currentlum + 50, 255)
/*
	var/list/turfsyo = list()
	for(var/turf/turf in world)
		if(turf)
			turfsyo.Add(turf)
	var/fancylen = turfsyo.len



	for(var/i in 1 to fancylen)
		spawn(ceil(i/50))
			var/turf/T = turfsyo[i]
			if (!T)
				continue
*/

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
