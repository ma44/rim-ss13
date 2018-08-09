//Some documentation boi
//Sharp and edge = slice
//Sharp = thrust
//None of the above = blunt
//Sharpness = sharpness x str damage multipler to decap

/obj/item/weapon/melee/rim //A 'rim' sword, aka reworked melee
	name = "sword"
	desc = "Just a regular sword."
	var/canparry
	var/parrystaminaloss
	var/parrycooldown
	var/parrystaminalimit
	w_class = 4 //Stamina damage on hitting stuff is already applied
	force = 20
