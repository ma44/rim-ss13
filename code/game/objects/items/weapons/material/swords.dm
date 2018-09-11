#define SLASH 1
#define STAB 2
#define BASH 3

//Some documentation boi
//Sharp and edge = slice
//Sharp = thrust
//None of the above = blunt
//Sharpness = sharpness x str damage multipler to decap
//All the stuff below has a 'freeparry', this basically means against a person of the same skill and the same weapon, you get to parry it for free.
//If the freeparry is 0 and hasn't resetted, then it will be a more rng roll unless the skill difference is major.
//50 is the baseline; 0 is half as good against 50, 100 is twice as good against 50.

/obj/item/weapon/material/sword
	name = "sword"
	desc = "You use the sharp part on your foes. And the flat part on your lesser foes."
	icon_state = "claymore"
	item_state = "claymore"
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_HUGE
	//force_divisor = 0.2 // 30 when wielded with hardness 60 (steel)
	//thrown_force_divisor = 0.2 // 10 when thrown with weight 20 (steel)
	sharp = 1
	edge = 1
	attack_verb = list("slashed", "sliced")
	hitsound = "slash_sound"
	var/atk_mode = SLASH
	//block_chance = 25
	applies_material_colour = FALSE
	drawsound = 'sound/items/unholster_sword02.ogg'
	equipsound = 'sound/items/holster_sword1.ogg'
	sharpness = 25
	weapon_speed_delay = 30
	parry_sounds = list('sound/weapons/blade_parry1.ogg', 'sound/weapons/blade_parry2.ogg', 'sound/weapons/blade_parry3.ogg')
	drop_sound = 'sound/items/drop_sword.ogg'
	health = 50 //Durability
	var/freeparry = 1 //if  you can have a free guaranteed parry against someone of the same skill
	var/parrystaminaloss = 12
	var/parrycooldown = 35 //Deciseconds
	var/parrypenalty = 1.1 //small additional stamina damage when parrying multiple times in a row
	var/parrystaminalimit = 50 //How much staminadamage is enough to negate any further parries
	var/parryability = 50 //How easy it is to parry with
	w_class = 4 //Stamina damage on hitting stuff is already applied
	force = 25
	var/materialsheet = 5 //How many sheets of material it takes to make this, see rimss13/fancymelee/anvil for more stuff

/obj/item/weapon/material/sword/pickup(mob/user) //Changes stats based on skill of the user
	if(ishuman(user))
		var/skicoeff = (0.5 + ((10 % user.melee_skill) / 10)) //0 skill = 0.5, 50 = 1, 100 = 1.5
		weapon_speed_delay = weapon_speed_delay / skicoeff
		parrycooldown = parrycooldown / skicoeff
		parrystaminaloss = parrystaminaloss / skicoeff

/obj/item/weapon/material/sword/handle_shield(mob/living/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(default_sword_parry(user, damage, damage_source, attacker, def_zone, attack_text))
		return 1
	return 0

/obj/item/weapon/material/sword/proc/default_sword_parry(mob/living/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	//Ok this if looks like a bit of a mess, and it is. Basically you need to have the sword in your active hand, and pass the default parry check
	if(user.staminaloss < parrystaminalimit)
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
				user.visible_message("<span class='danger'>\The [user] attempts to parry [attack_text] with \the [src] but fails!</span>")
				return 0
		else	//Less chancce of parrying if recently parried, becomes much more dependent on the skill difference
			if(default_parry_check(user, attacker, damage_source) && prob(((user.melee_skill) + parryability) - attacker.melee_skill) && (user.get_active_hand() == src))
				user.visible_message("<span class='good'>\The [user] parries [attack_text] with \the [src]!</span>")
				if(parry_sounds)
					playsound(user.loc, pick(parry_sounds), 50, 1)
				user.adjustStaminaLoss(parrystaminaloss * parrypenalty) //Loose a bit more stamina due to multiple parries in a row
				health -= (damage / 20)
				return 1
			else
				user.visible_message("<span class='danger'>\The [user] attempts to parry [attack_text] with \the [src] but fails!</span>")
				return 0

/obj/item/weapon/material/sword/proc/resetparry(cooldown, mob/living/user)
	sleep(cooldown)
	freeparry = 1
	user << "You can parry again without additional strain!"

/obj/item/weapon/material/sword/rapier
	name = "rapier"
	desc = "A weapon that is perfect for dueling, can only thrust and is EXTREMELY bad at parrying multiple times in a short time."
	icon_state = "katana" //No questioning pls
	item_state = "katana"
	atk_mode = STAB
	parryability = 65 //The perfect dueling weapon
	parrystaminaloss = 9 //Also a bit forgiving on stamina damage
	parrypenalty = 1.75 //Massive penalty when getting hit several times in a row, worse than any other weapon
	parrycooldown = 20
	w_class = 3 //Less stamina damage on hit as well, go figure
	force = 20 //Pretty light and thin
	weapon_speed_delay = 25

/obj/item/weapon/material/sword/rapier/attack_self(mob/user)
	//..()
	switch_intent(user,STAB) //Stabbin only

/obj/item/weapon/material/sword/attack_self(mob/user)
	..()
	if(atk_mode == SLASH)
		switch_intent(user,STAB)
	else if(atk_mode == STAB)
		switch_intent(user,BASH)
	else if(atk_mode == BASH)
		switch_intent(user,SLASH)

/obj/item/weapon/material/sword/proc/switch_intent(mob/user,var/intent)
	switch(intent)
		if(STAB)
			atk_mode = STAB
			to_chat(user, "You will now stab.")
			edge = 0
			sharp = 1
			attack_verb = list("stabbed")
			hitsound = "stab_sound"
			return
		if(BASH)
			atk_mode = BASH
			to_chat(user, "You will now bash with the hilt.")
			edge = 0
			sharp = 0
			attack_verb = list("bashed", "smacked")
			hitsound = "swing_hit"
			return

		if(SLASH)
			atk_mode = SLASH
			to_chat(user, "You will now slash.")
			edge = 1
			sharp = 1
			attack_verb = list("slashed", "diced")
			hitsound = "slash_sound"
			return

/obj/item/weapon/material/sword/spear
	icon_state = "spearglass0"
	item_state  = "spearglass"
	name = "spear"
	desc = "A long weapon that is extremely good for attacking people without shields in crowded places and throwing to disable. Just don't try to parry with it."
	parryability = 10 //Hah no
	health = 25 //Also pretty weak in durability
	force = 30 //Also nice damage
	throwforce = 30 //easy disable probably

/obj/item/weapon/material/sword/spear/attack_self(mob/user)
	//..()
	switch_intent(user,STAB) //Stabbin only 2.0

/obj/item/weapon/material/sword/spear/throw_impact(atom/hit_atom)
	var/mob/living/carbon/C = hit_atom
	C.Weaken(3)
	health -= 12.5 //no spamming this meme
	


/obj/item/weapon/material/sword/replica
	edge = 0
	sharp = 0
	force_divisor = 0.2
	thrown_force_divisor = 0.2

/obj/item/weapon/material/sword/katana
	name = "katana"
	desc = "Woefully underpowered in D20. This one looks pretty sharp."
	icon_state = "katana"
	item_state = "katana"
	slot_flags = SLOT_BELT | SLOT_BACK

/obj/item/weapon/material/sword/katana/replica
	edge = 0
	sharp = 0
	force_divisor = 0.2
	thrown_force_divisor = 0.2

/obj/item/weapon/material/sword/sabre
	name = "sabre"
	desc = "Like a claymore but for an officer."
	icon_state = "sabre"
	item_state = "sabre"
	force_divisor = 0.4
	thrown_force_divisor = 0.4
	block_chance = 50


/obj/item/weapon/material/sword/combat_knife
	name = "combat knife"
	desc = "For self defense, and self offense."
	icon_state = "combatknife"
	item_state = "knife"
	attack_verb = list("slashed")
	force_divisor = 0.3
	block_chance = 15
	w_class = ITEM_SIZE_SMALL
	drawsound = 'sound/items/unholster_knife.ogg'
	sharpness = 15
	weapon_speed_delay = 10
	drop_sound = 'sound/items/knife_drop.ogg'
	swing_sound = "blunt_swing"

/obj/item/weapon/material/sword/combat_knife/attack_self(mob/user)
	if(atk_mode == SLASH)
		switch_intent(STAB)
	else
		switch_intent(SLASH)
