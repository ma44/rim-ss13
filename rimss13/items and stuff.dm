/obj/item/stack/grass
	name = "leaves"
	singular_name = "leaf"
	desc = "Some leaves, these kind of leaves seem to be very good for rope related purposes. Useful for making primitive tools and tightening things together."
	icon_state = "rope"
	icon = 'rimss13/grass.dmi'
	max_amount = 10

/obj/item/rock
	name = "rock"
	desc = "A singular rock, despite it being a rock, it is in fact extremely useful for some things."
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore2"

/obj/item/rock/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/rock))
		if(prob(50))
			playsound(src, 'sound/effects/sharpen_long1.ogg',50, 1)
		else
			playsound(src, 'sound/effects/sharpen_long2.ogg',50, 1)
		if(prob(15))
			var/obj/structure/firepit/firepit = 0
			for(var/obj/structure/firepit/F in view(1))
				if(F)
					firepit = F
					break
			if(firepit)
				if(firepit.fuel > 0)
					to_chat(user, "You make a spark from the two rocks, and successfully light up the firepit.")
					playsound(src, 'sound/items/match.ogg', 50, 1)
					firepit.lightitup()
				else
					to_chat(user, "You make a spark from the two rocks near the firepit, sadly it didn't have enough fuel.")
					playsound(src, 'sound/items/match.ogg', 50, 1)
			else
				to_chat(user, "You make a spark from the two rocks, but nothing was around to be lit up from the sparks.")
				playsound(src, 'sound/items/match.ogg', 50, 1)
		else
			to_chat(user, "You strike the two stones together, but nothing happens.")

//A proc you can call to influence an item's stats after crafting, should probably also apply to blacksmithing but oh well
/obj/item/proc/aftercraft(craftingskill) //out of all the places to put this, it's here
	return

/obj/item/primitivetool
	name = "primitive survival tool"
	desc = "A extremely primitive tool that allows you to chop down trees and harvest some stone from ore deposits with it's semi sharp edge."
	force = 5
	sharp = 1
	edge = 0 //No delimbing please
	durability = 10 //TODO: make this start off at different numbers based on crafter's skill
	
/obj/item/primitivetool/get_examine_desc(mob/user)
	var/msg = desc
	msg += " This tool has a durability percentage of [initial(durability) / durability] left."
	
/obj/item/primitivetool/afterattack(obj/target, mob/user, flag)
	..()
	durability--
	if(durability <= 0)
		var/turf/T = get_turf(src)
		T.visible_message("<span class='danger'>\The [src] suddenly breaks!</span>")
		qdel(src) //f
	
/obj/item/primitivetool/aftercraft(craftingskill)
	durability = durability * (craftingskill / 20) //Up to a 5x durability bonus
	desc += " This tool also seems to have been crafted by a [skillnumtodesc(craftingskill)] crafter."
