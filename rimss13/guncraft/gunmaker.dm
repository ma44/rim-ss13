//A machine that allows production of various gun attachments and things
//Currently uses no power due to the state of no electricty on the map

/obj/machinery/gunpart
	name = "gun parts manufacturer"
	desc = "A machine that seems to produce various gun parts. Harm intent to get the thing currently selected and help intent to select a thing."
	use_power = 0
	icon_state = "autolathe"
	var/thingtomake = null

/*
/obj/machinery/gunpart/proc/AltClickOn(var/atom/A)
	var/list/listofthing = subtypesof(/obj/item/weapon/gun/projectile/attach)
	if(alert(A, "Gun frame or attachment?", "Confirmation", "Gun Frame", "Attachment") == "Gun Frame")
		thingtomake = new/obj/item/weapon/gun/projectile/craft(src)
	else
		thingtomake = input(A, "Which gun attachment?", "Picking a thing")  as null|anything in listofthing
*/

/obj/machinery/gunpart/attack_hand(var/mob/user)
	if(user.a_intent == I_HURT)
		var/item = new thingtomake(src)
		user.put_in_hands(item)
		playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
	if(user.a_intent == I_HELP)
		var/list/listofthing = subtypesof(/obj/item/weapon/gun/projectile/attach)
		if(alert(user, "Gun frame or attachment?", "Confirmation", "Gun Frame", "Attachment") == "Gun Frame")
			thingtomake = new/obj/item/weapon/gun/projectile/craft(src)
		else
			thingtomake = input(user, "Which gun attachment?", "Picking a thing")  as null|anything in listofthing

/obj/machinery/magazinemaker
	name = "gun magazine manufacturer"
	desc = "Can make magazines of up to fifty rounds for any caliber of gun."
	use_power = 0
	icon_state = "autolathe"
	var/thingtomake = null

/obj/machinery/magazinemaker/attack_hand(var/mob/user)
	if(user.a_intent == I_HURT)
		var/item = new thingtomake(src) //Magazine gets properely filled on new
		user.put_in_hands(item)
		playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
	if(user.a_intent == I_HELP)
		var/obj/item/ammo_magazine/mc9mm/mag = new/obj/item/ammo_magazine/mc9mm(src) //Placeholder until a standard set of calibers are made
		var/magcaliber = input("Enter caliber name.") as text
		var/magmaxammo = input("Enter magazine capacity.") as num
		mag.caliber = magcaliber
		mag.max_ammo = magmaxammo
		mag.initial_ammo = magmaxammo
		mag.contents = list() //Clear all the current ammo
		mag.New() //Refills the magazine
		thingtomake = mag