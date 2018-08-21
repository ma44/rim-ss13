////////////////////////////////////////////////////////////////////////////////
/// Food.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/food
	randpixel = 6
	flags = OPENCONTAINER
	possible_transfer_amounts = null
	volume = 50 //Sets the default container amount for all food items.
	var/filling_color = "#ffffff" //Used by sandwiches.
	var/trash = null



/obj/item/weapon/reagent_containers/food/standard_feed_mob(var/mob/user, var/mob/target) // This goes into attack
	. = ..()
	if(.)
		var/tablecount = 0
		for(var/obj/structure/table/table in view(src, 1))
			if(istype(table, /obj/structure/table))
				tablecount += 1
		if(tablecount == 0)
			if(istype(target, /mob/living/carbon))
				var/mob/living/carbon/target2 = target
				target2.add_event("table", /datum/happiness_event/table)