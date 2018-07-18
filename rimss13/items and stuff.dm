/obj/item/stack/grass
	name = "bundled brass"
	singular_name = "piece of grass"
	desc = "Some grass bundled up neatly. Useful for making primitive tools and tightening things together."
	icon_state = "grassthing"
	max_amount = 10

/obj/item/rock
	name = "rock"
	desc = "A singular rock, despite it being a rock, it is in fact extremely useful for some things."

/obj/item/rock/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/rock))
		if(prob(50))
			playsound(src, 'sound/effects/sharpen_long1.ogg',50, 1)
		else
			playsound(src, 'sound/effects/sharpen_long2.ogg',50, 1)
		if(prob(5))
			var/obj/structure/firepit/firepit = 0
			for(var/obj/structure/firepit/F in view(1))
				if(F)
					firepit = F
					break
			if(firepit)
				if(firepit.fuel > 0)
					to_chat(user, "You make a spark from the two rocks, and successfully light up the firepit.")
					firepit.lightitup()
				else
					to_chat(user, "You make a spark from the two rocks near the firepit, sadly it didn't have enough fuel.")
			else
				to_chat(user, "You make a spark from the two rocks, but nothing was around to be lit up from the sparks.")
		else
			to_chat(user, "You strike the two stones together, but nothing happens.")

/obj/item/stack/rods/stick
	name = "wodden stick"
	desc = "A wooden stick."
	icon_state = "sticks"