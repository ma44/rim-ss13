/obj/item/smith_hammer
	name = "smithing hammer"
	desc = "A useful tool that can be used to smith some stuff."
	icon = 'rimss13/blacksmithing.dmi'
	icon_state = "hammer"

/obj/item/scrapmetal
	name = "scrap metal"
	desc = "Something that doesn't look like much. Seems to be for making a thing."
	var/obj/item/weapon/material/sword/thingtomake = /obj/item/weapon/material/sword
	var/heat = 0 //How much of it was heated up, heat is required to actually meld the thing into shape.
	var/progress = 0 //How far to go until made
	icon = 'rimss13/bolt.dmi'
	icon_state = "scrapmetal"

/obj/item/scrapmetal/Initialize()
	..()
	sleep(2) //So the thing from the anvil can do stuff
	if(thingtomake)
		name = "[thingtomake.name] scrap metal" //Dumb hack

/obj/item/scrapmetal/examine(mob/user)
	..()
	if(thingtomake) //Don't want any meme runtimes or null things
		user << "This object looks vaguely similar to a [thingtomake.name]."

/obj/item/scrapmetal/update_icon()
	..()
	cut_overlays()
	if(heat >= 2)
		var/image/stuff = image(icon = 'rimss13/fire.dmi', icon_state = "fire")
		add_overlay(stuff)

/obj/machinery/anvil
	name = "anvil"
	desc = "Allows a very nice surface to modify parts of metal on. Can be used to make useful weapons and armor of war."
	use_power = 0
	var/obj/item/scrapmetal/inneritem = null //The thing it currently holds, makes an overlay on top of the anvil
	icon = 'rimss13/blacksmithing.dmi'
	icon_state = "anvil"

/obj/machinery/anvil/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/material/iron))
		var/obj/item/stack/material/typecast = I
		var/listofthing = typesof(/obj/item/weapon/material/sword)
		var/obj/item/weapon/material/sword/thing = input(user, "What do you want to smith?", "Picking a thing") in listofthing
		var/obj/item/weapon/material/sword/thing2 = new thing
		if(thing2.materialsheet < typecast.amount)
			inneritem = new /obj/item/scrapmetal(src)
			inneritem.thingtomake = thing //Just the type path, not the actual object
			user << "You lay out the metal onto the anvil to be smithed into a [thing2.name]."
			update_icon()
		else
			user << "You don't have enough of [I.name] to make the [thing2.name]."
	if((istype(I, /obj/item/scrapmetal)) && !inneritem)
		user << "You place the [I.name] onto the anvil."
		inneritem = I
		I.forceMove(src)
		update_icon()
	if((istype(I, /obj/item/smith_hammer)) && inneritem)
		if(inneritem.heat <= 0)
			user << "The [inneritem.name] isn't hot enough to meld, heat it up!"
		user.setClickCooldown(10) //No hitting it multiple times in a row
		if(do_after(user, 10, src))
			inneritem.heat -= 1
			inneritem.progress += 1
			inneritem.update_icon()
			cut_overlays()
			update_icon()
			playsound(src, 'rimss13/fancymelee/forge.ogg', 50, 1)

/obj/machinery/anvil/attack_hand(var/mob/user)
	if(inneritem)
		user.put_in_hands(inneritem)
		inneritem = null
		update_icon()

/obj/machinery/anvil/update_icon()
	..()
	if(inneritem)
		add_overlay(inneritem, priority = 0)
	else
		cut_overlays()
