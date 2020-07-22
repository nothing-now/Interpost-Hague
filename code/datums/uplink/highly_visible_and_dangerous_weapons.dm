/***************************************
* Highly Visible and Dangerous Weapons *
***************************************/
/datum/uplink_item/item/visible_weapons
	category = /datum/uplink_category/visible_weapons

/datum/uplink_item/item/visible_weapons/revolver
	name = "Revolver, .357"
	item_cost = 20
	antag_roles = list(MODE_MERCENARY)
	path = /obj/item/weapon/storage/backpack/satchel/syndie_kit/revolver

/datum/uplink_item/item/visible_weapons/sawnoff
	name = "Sawnoff Shotgun"
	item_cost = 35
	antag_costs = list(MODE_MERCENARY = 10)
	path = /obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn

/datum/uplink_item/item/visible_weapons/sword
	name = "beserk sword"
	item_cost = 15
	antag_costs = list(MODE_MERCENARY = 10)
	path = /obj/item/weapon/material/sword/siegesword

/datum/uplink_item/item/visible_weapons/boltaction
	name = "bolt action rifle"
	item_cost = 25
	antag_costs = list(MODE_MERCENARY = 10)
	path = /obj/item/weapon/gun/projectile/shotgun/pump/boltaction/shitty/bayonet
