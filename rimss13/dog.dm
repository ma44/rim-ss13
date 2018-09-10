/mob/living/simple_animal/hostile/dog
	health = 30
	maxHealth = 30
	name = "wild dog"
	move_to_delay = 2
	destroy_surroundings = 0
	icon = 'rimss13/dog.dmi'
	icon_state = "dog"
	melee_damage_lower = 10
	melee_damage_upper = 15
	turns_per_move = 1

/obj/effect/ambush
	name = "dog spawner boi"
	var/triggered = 0

/obj/effect/ambush/Initialize()
	..()
	START_PROCESSING(SSobj, src)

/obj/effect/ambush/Process()
	for(var/atom/A in hearers(src, 5))
		if(!triggered)
			if(ishuman(A))
				triggered = 1
				ambush()

/obj/effect/ambush/proc/ambush()
	playsound(src, 'rimss13/ambush1.ogg',50, 1)
	for(var/mob/living/carbon/C in view(src, 7))
		if(istype(C, /mob/living/carbon))
			to_chat(C, "Ambush! Curse them!")
	new/mob/living/simple_animal/hostile/dog(src.loc)
	qdel()