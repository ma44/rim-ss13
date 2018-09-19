/datum/crafting_recipe/primitivetool //A sharp tool for harvesting stuff like trees and rocky deposits
	name = "Primitive Survival Tool"
	parts = list(/obj/item/weapon/material/stick = 1, /obj/item/stack/grass = 1, /obj/item/rock = 1)
	tools = list()
	result = list(/obj/item/primitivetool = 1)
	time = 50
	base_chance = 100
	soundtoplay = 'sound/effects/sharpen_long1.ogg' //Sample sound for now until I get something better for it
