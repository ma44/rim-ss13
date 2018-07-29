/atom/proc/cut_overlays()
	overlays.Cut()
	//overlays += priority_overlays

/atom/proc/add_overlay(image, priority = 0)
	if(image in overlays)
		return
	overlays += image
	/*
	var/list/new_overlays = overlays.Copy()
	if(priority)
		if(!priority_overlays)
			priority_overlays = list()
		priority_overlays += image
		new_overlays += image
	else
		if(priority_overlays)
			new_overlays -= priority_overlays
			new_overlays += image
			new_overlays += priority_overlays
		else
			new_overlays += image
	overlays = new_overlays
	*/

/obj/item/weapon/gun/projectile/attach
	icon = 'rimss13/guncraft/ausops_new.dmi'
	drawsound = null

/obj/item/weapon/gun/projectile/attach/barrel
	name = "short barrel"
	desc = "Determines the accuracy and effective range of the weapon."
	icon = 'rimss13/guncraft/main.dmi'
	icon_state = "barrel_short"

/obj/item/weapon/gun/projectile/attach/barrel/medium
	name = "medium barrel"
	icon_state = "barrel_medium"

/obj/item/weapon/gun/projectile/attach/barrel/long
	name = "long barrel"
	icon_state = "barrel_long"

/obj/item/weapon/gun/projectile/attach/base
	name = "base gun design"
	desc = "Determines the firemode and type of shell ejection of the weapon."
	icon = 'rimss13/guncraft/main.dmi'
	icon_state = "base_projectile_pistol"

/obj/item/weapon/gun/projectile/attach/handle
	var/calibertype = "9mm"
	name = "base handle"
	desc = "Determines the type of caliber the gun shoots. This one shoots a thing I guess."
	magazine_type = /obj/item/ammo_magazine/mc9mm
	allowed_magazines = /obj/item/ammo_magazine/mc9mm
	var/magtype = 3
	icon_state = "handle_semi1"

/obj/item/weapon/gun/projectile/attach/handle/Initialize()
	..()
	name = "[calibertype] gun handle"
	desc = "Determines the type of caliber the gun shoots. This one shoots a [calibertype]."

/obj/item/weapon/gun/projectile/attach/sight
	name = "basic gun sight"
	desc = "A basic gun sight, seems to have a image reflected onto the glass."
	icon_state = "attach_scope_reflex"

/obj/item/weapon/gun/projectile/attach/grip
	name = "forward grip"
	desc = "A forward grip attachment for a gun."
	icon = 'rimss13/guncraft/main.dmi'
	icon_state = "attach_handle"

/obj/item/weapon/gun/projectile/craft
	name = "gun frame"
	desc = "A gun frame, shoots and works like a gun once constructed."
	icon = 'rimss13/guncraft/ausops_new.dmi'
	icon_state = "frame_projectile1"
	var/obj/item/weapon/barrel = null
	var/obj/item/weapon/handle = null
	var/obj/item/weapon/base = null
	var/obj/item/weapon/sight = null
	var/obj/item/weapon/grip = null
	drawsound = null

/obj/item/weapon/gun/projectile/craft/update_icon()
	..()
	cut_overlays()
	if(barrel)
		var/image/I1 = image(icon = 'rimss13/guncraft/ausops_new.dmi', icon_state = barrel.icon_state)
		I1.color = barrel.color
		add_overlay(I1)
	var/image/I2 = image(icon = 'rimss13/guncraft/ausops_new.dmi', icon_state = base.icon_state)
	I2.color = base.color
	add_overlay(I2)
	if(handle)
		var/image/I3 = image(icon = 'rimss13/guncraft/ausops_new.dmi', icon_state = handle.icon_state)
		I3.color = handle.color
		add_overlay(I3)
		var/obj/item/weapon/gun/projectile/attach/handle/handle1 = handle
		if(handle1.allowed_magazines)
			src.allowed_magazines = handle1.allowed_magazines
		if(handle1.calibertype)
			src.caliber = handle1.calibertype
		if(handle1.magtype)
			if(handle1.magtype == 3) //If it's a magazine
				src.load_method = MAGAZINE
	var/image/I4 = image(icon = 'rimss13/guncraft/ausops_new.dmi', icon_state = src.icon_state)
	I4.color = src.color
	add_overlay(I4)
	if(sight)
		var/image/I5 = image(icon = 'rimss13/guncraft/ausops_new.dmi', icon_state = sight.icon_state)
		add_overlay(I5)
	if(grip)
		var/image/I6 = image(icon = 'rimss13/guncraft/ausops_new.dmi', icon_state = grip.icon_state)
		add_overlay(I6)
	/*
	for(var/obj/item/weapon/gun_attachment/underbarrel/U in attachments)
		var/image/UO = image(icon = 'icons/obj/guncrafting/ausops_new.dmi', icon_state = U.icon_state)
		UO.color = U.color
		UO.pixel_x += 6
		add_overlay(UO)
	for(var/obj/item/weapon/gun_attachment/scope/S in attachments)
		var/image/I6 = image(icon = 'icons/obj/guncrafting/ausops_new.dmi', icon_state = S.icon_state)
		I6.color = S.color
		add_overlay(I6)
	*/

/obj/item/weapon/gun/projectile/craft/attackby(obj/item/I, mob/user)
	..()
	if((istype(I, /obj/item/weapon/gun/projectile/attach/handle)) && do_after(user, 10, src)) //wake me up
		if(!handle)
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			handle = I
			I.loc = src
	if((istype(I, /obj/item/weapon/gun/projectile/attach/base)) && do_after(user, 10, src))
		if(!base)
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			base = I
			I.loc = src
	if((istype(I, /obj/item/weapon/gun/projectile/attach/barrel)) && do_after(user, 10, src))
		if(!barrel)
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			barrel = I
			I.loc = src
	if((istype(I, /obj/item/weapon/gun/projectile/attach/sight)) && do_after(user, 10, src))
		if(!sight)
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			sight = I
			I.loc = src
	if((istype(I, /obj/item/weapon/gun/projectile/attach/grip)) && do_after(user, 10, src))
		if(!grip)
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			grip = I
			I.loc = src
	update_icon()