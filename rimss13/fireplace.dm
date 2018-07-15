/obj/structure/firepit
	name = "firepit"
	desc = "Warm and toasty."
	icon = 'icons/obj/fireplace.dmi'
	icon_state = "firepit-active"
	density = FALSE
	var/active = 1

/obj/structure/firepit/Initialize()
	..()
	set_light(l_range = 4)