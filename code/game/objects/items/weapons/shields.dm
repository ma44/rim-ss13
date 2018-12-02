//** Shield Helpers
//These are shared by various items that have shield-like behaviour

//bad_arc is the ABSOLUTE arc of directions from which we cannot block. If you want to fix it to e.g. the user's facing you will need to rotate the dirs yourself.
/proc/check_shield_arc(mob/user, var/bad_arc, atom/damage_source = null, mob/attacker = null)
	//check attack direction
	var/attack_dir = 0 //direction from the user to the source of the attack
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		attack_dir = get_dir(get_turf(user), P.starting)
	else if(attacker)
		attack_dir = get_dir(get_turf(user), get_turf(attacker))
	else if(damage_source)
		attack_dir = get_dir(get_turf(user), get_turf(damage_source))

	if(!(attack_dir && (attack_dir & bad_arc)))
		return 1
	return 0

/proc/default_parry_check(mob/living/user, mob/attacker, atom/damage_source)
	//parry only melee attacks
	if(istype(damage_source, /obj/item/projectile) || (attacker && get_dist(user, attacker) > 1) || user.incapacitated())
		return 0

	if(!user.combat_mode)//If you're not in combat mode you won't parry.
		return 0

	if(user.defense_intent != I_PARRY)//If you're not on parry intent, you won't parry.
		return 0

	//if(!user.skillcheck(user.melee_skill, 1, 0))//Need at least 1 skill to be able to parry effectively.
	//	return 0 //You can still block, just don't expect to do so for a long time

	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
	if(!check_shield_arc(user, bad_arc, damage_source, attacker))
		return 0

	return 1

/obj/item/weapon/shield
	name = "shield"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "buckler"
	var/base_block_chance = 50
	//All the above is related to the material/swords.dm located in the folder where this resides
	var/freeparry = 1 //if  you can have a free guaranteed parry against someone of the same skill
	var/parrystaminaloss = 12
	var/parrycooldown = 35 //Deciseconds
	var/parrypenalty = 1.1 //small additional stamina damage when parrying multiple times in a row
	var/parrystaminalimit = 50 //How much staminadamage is enough to negate any further parries
	var/parryability = 50 //How easy it is to parry with
	weapon_speed_delay = 50 //Stop ruining those free parries please thank you
	parry_sounds = list('sound/weapons/blunt_parry1.ogg', 'sound/weapons/blunt_parry2.ogg', 'sound/weapons/blunt_parry3.ogg')

/obj/item/weapon/shield/pickup(mob/user) //Changes stats based on skill of the user
	if(ishuman(user))
		var/skicoeff = (0.5 + ((10 % user.melee_skill) / 10)) //0 skill = 0.5, 50 = 1, 100 = 1.5
		parrycooldown = parrycooldown / skicoeff
		parrystaminaloss = parrystaminaloss / skicoeff

/obj/item/weapon/shield/handle_shield(mob/living/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(user.incapacitated())
		return 0

	//block as long as they are not directly behind us
	var/bad_arc = reverse_direction(user.dir) //arc of directions from which we cannot block
	if(check_shield_arc(user, bad_arc, damage_source, attacker))
		if(istype(damage_source, /obj/item/weapon/material/sword) || istype(damage_source, /obj/item/weapon/shield)) //uh oh snowflake time
			if(freeparry)
				if(default_parry_check(user, attacker, damage_source) && prob(((user.melee_skill * 2) + parryability) - attacker.melee_skill) && (user.get_active_hand() == src))//You gotta be holding onto that sheesh bro.
					user.visible_message("<span class='help'>\The [user] easily parries [attack_text] with \the [src]!</span>")
					if(parry_sounds)
						playsound(user.loc, pick(parry_sounds), 50, 1)
					user.adjustStaminaLoss(parrystaminaloss)
					health -= (damage / 20) //Damage done to weapon depends on the original damage of the thing
					freeparry = 0
					resetparry(parrycooldown, user)
					return 1
				else
					user.visible_message("<span class='danger'>\The [user] attempts to easily parry [attack_text] with \the [src] but fails!</span>")
			else
				if(default_parry_check(user, attacker, damage_source) && prob(((user.melee_skill) + parryability) - attacker.melee_skill) && (user.get_active_hand() == src))//You gotta be holding onto that sheesh bro.
					user.visible_message("<span class='good'>\The [user] skillfully parries [attack_text] with \the [src]!</span>")
					if(parry_sounds)
						playsound(user.loc, pick(parry_sounds), 50, 1)
					user.adjustStaminaLoss(parrystaminaloss)
					health -= (damage / 20) //Damage done to weapon depends on the original damage of the thing
					freeparry = 0
					resetparry(parrycooldown, user)
					return 1
				else
					user.visible_message("<span class='danger'>\The [user] attempts to skillfully parry [attack_text] with \the [src] but fails!</span>")
					return 0

		else
			if(prob(get_block_chance(user, damage, damage_source, attacker)))
				user.visible_message("<span class='danger'>\The [user] blocks [attack_text] with \the [src]!</span>")
				return 1
			return 0

/obj/item/weapon/shield/proc/resetparry(cooldown, mob/living/user)
	sleep(cooldown)
	freeparry = 1
	user << "You can parry again without additional strain!"

/obj/item/weapon/shield/proc/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	return base_block_chance

/obj/item/weapon/shield/riot
	name = "riot shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "riot"
	flags = CONDUCT
	slot_flags = SLOT_BACK
	force = 5.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_HUGE
	origin_tech = list(TECH_MATERIAL = 2)
	matter = list("glass" = 7500, DEFAULT_WALL_MATERIAL = 1000)
	attack_verb = list("shoved", "bashed")
	var/cooldown = 0 //shield bash cooldown. based on world.time

/obj/item/weapon/shield/riot/handle_shield(mob/living/user)
	. = ..()
	if(.) playsound(user.loc, 'sound/effects/shieldhit.ogg', 50, 1)

/obj/item/weapon/shield/riot/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		//plastic shields do not stop bullets or lasers, even in space. Will block beanbags, rubber bullets, and stunshots just fine though.
		if((is_sharp(P) && damage > 10) || istype(P, /obj/item/projectile/beam))
			return 0
	return base_block_chance

/obj/item/weapon/shield/riot/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/melee/baton))
		if(cooldown < world.time - 25)
			user.visible_message("<span class='warning'>[user] bashes [src] with [W]!</span>")
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
	else
		..()

/obj/item/weapon/shield/buckler
	name = "buckler"
	desc = "A wooden buckler used to block sharp things from entering your body back in the day.."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "buckler"
	slot_flags = SLOT_BACK
	force = 8
	throwforce = 8
	base_block_chance = 60
	throw_speed = 10
	throw_range = 20
	w_class = ITEM_SIZE_HUGE
	origin_tech = list(TECH_MATERIAL = 1)
	matter = list(DEFAULT_WALL_MATERIAL = 1000, "Wood" = 1000)
	attack_verb = list("shoved", "bashed")

/obj/item/weapon/shield/buckler/handle_shield(mob/living/user)
	. = ..()
	//if(.) playsound(user.loc, 'sound/items/buckler_block.ogg', 50, 1)

/obj/item/weapon/shield/buckler/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/item/projectile))
		return 0 //No blocking bullets, I'm afraid.
	return base_block_chance

/*
 * Energy Shield
 */

/obj/item/weapon/shield/energy
	name = "energy combat shield"
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "eshield0" // eshield1 for expanded
	flags = CONDUCT
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	attack_verb = list("shoved", "bashed")
	var/active = 0

/obj/item/weapon/shield/energy/handle_shield(mob/living/user)
	if(!active)
		return 0 //turn it on first!
	. = ..()

	if(.)
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)

/obj/item/weapon/shield/energy/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		if((is_sharp(P) && damage > 10) || istype(P, /obj/item/projectile/beam))
			return (base_block_chance - round(damage / 3)) //block bullets and beams using the old block chance
	return base_block_chance

/obj/item/weapon/shield/energy/attack_self(mob/living/user as mob)
	if ((CLUMSY in user.mutations) && prob(50))
		to_chat(user, "<span class='warning'>You beat yourself in the head with [src].</span>")
		user.take_organ_damage(5)
	active = !active
	if (active)
		force = 10
		update_icon()
		w_class = ITEM_SIZE_HUGE
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, "<span class='notice'>\The [src] is now active.</span>")

	else
		force = 3
		update_icon()
		w_class = ITEM_SIZE_TINY
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, "<span class='notice'>\The [src] can now be concealed.</span>")

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return

/obj/item/weapon/shield/energy/update_icon()
	icon_state = "eshield[active]"
	if(active)
		set_light(1.5, 1.5, "#006aff")
	else
		set_light(0)

