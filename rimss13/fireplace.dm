/obj/structure/firepit
	name = "firepit"
	desc = "An unlit fireplace."
	icon = 'icons/obj/fireplace.dmi'
	icon_state = "firepit"
	density = FALSE
	var/active = 1
	var/fuel = 1 //The amount of fuel in this fire
	var/burning = 0

/obj/structure/firepit/Initialize()
	..()
	//set_light(l_range = 4)

/obj/structure/firepit/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/stack/grass))
		var/obj/item/stack/grass/A = I
		A.amount -= 1
		to_chat(user, "You place some grass into the firepit.")
		fuel += 1
	if(istype(I, /obj/item/scrapmetal))
		var/obj/item/scrapmetal/B = I
		B.heat += 2
		to_chat(user, "You heat up the scrap metal.")
		playsound('sound/items/lighter1.ogg', 50, 1)
		B.update_icon()

/obj/structure/firepit/attack_hand(var/mob/user)
	if(!burning)
		to_chat(user, "You put your hand against the firepit, expecting something to happen, sadly nothing happened.")
	else
		to_chat(user, "You feel like touching the firepit while it's flaming is a really bad idea.")

/obj/structure/firepit/node/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/firepit/proc/lightitup()
	icon_state = "firepit-active"
	desc = "A lit firepit, you feel yourself calm near the fire."
	set_light(l_range = 4)
	START_PROCESSING(SSprocessing, src)

/obj/structure/firepit/proc/stoplighting()
	icon_state = "firepit"
	desc = initial(desc)
	set_light(l_range = 0)
	STOP_PROCESSING(SSprocessing, src)

/obj/structure/firepit/Process()
	fuel -= 0.01
	playsound(src, 'sound/effects/fire_loopshort.ogg',50, 1)
	for(var/mob/living/carbon/C in view(src, 1))
		if(istype(C, /mob/living/carbon))
			if(C.happiness == 0)
				to_chat(C, "That firepit sure feels nice.")
				C.add_event("warmth", /datum/happiness_event/warmth/campfire)
			C.bodytemperature = max(C.bodytemperature + 50, 360)
	if(fuel <= 0)
		fuel = 0
		stoplighting()