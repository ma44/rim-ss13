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

/obj/effect/ambush/Initialize()
	..()
