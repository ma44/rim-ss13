/datum/controller/process/fancydaynight
	var/stateofday = "day"
	var/turf/dayturf = /turf/simulated/floor/grass //Wanna make day time turn the world to lava? well here ya go then
	var/turf/nightturf = /turf/simulated/floor/snow
	var/turf/currentturf //Turf for stuff to be made into

/datum/controller/process/fancydaynight/setup()
	name = "day night cycler"
	schedule_interval = 1200 // every minute for testing purposes
	doWork()

/datum/controller/process/fancydaynight/doWork()
	switch(stateofday)
		if("day")
			stateofday = "night"
			currentturf = nightturf
		if("night")
			stateofday = "day"
			currentturf = dayturf
	for(var/turf/turf in world)
		if(isturf(turf))
			if(!get_area(turf)) //No area; this means it isn't 'roofed' or whatever so good to do stuff on it
				turf.ChangeTurf(currentturf)