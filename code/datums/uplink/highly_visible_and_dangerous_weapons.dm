/***************************************
* Highly Visible and Dangerous Weapons *
***************************************/
/datum/uplink_item/item/visible_weapons
	category = /datum/uplink_category/visible_weapons

/datum/uplink_item/item/visible_weapons/dartgun
	name = "Dart Gun"
	item_cost = 20
	path = /obj/item/weapon/gun/projectile/dartgun

/datum/uplink_item/item/visible_weapons/crossbow
	name = "Energy Crossbow"
	item_cost = 30
	path = /obj/item/weapon/gun/energy/crossbow

/datum/uplink_item/item/visible_weapons/energy_sword
	name = "Energy Sword"
	item_cost = 60
	antag_costs = list(MODE_MERCENARY = 30)
	path = /obj/item/weapon/melee/energy/sword

/datum/uplink_item/item/visible_weapons/g9mm
	name = "Silenced Holdout Pistol"
	item_cost = 30
	antag_costs = list(MODE_MERCENARY = 15)
	path = /obj/item/weapon/storage/box/syndie_kit/g9mm

/datum/uplink_item/item/badassery/money_cannon
	name = "Modified Money Cannon"
	item_cost = 45
	path = /obj/item/weapon/gun/launcher/money/hacked
	desc = "Too much money? Not enough screaming? Try the Money Cannon."

/datum/uplink_item/item/visible_weapons/energy_gun
	name = "Energy Gun"
	item_cost = 50
	antag_costs = list(MODE_MERCENARY = 25)
	path = /obj/item/weapon/gun/energy/gun

/datum/uplink_item/item/visible_weapons/revolver
	name = "Revolver, .357"
	item_cost = 20
	antag_roles = list(MODE_MERCENARY)
	path = /obj/item/weapon/storage/backpack/satchel/syndie_kit/revolver

/datum/uplink_item/item/visible_weapons/revolver2
	name = "Revolver, .44"
	item_cost = 45
	antag_costs = list(MODE_MERCENARY = 15)
	path = /obj/item/weapon/storage/backpack/satchel/syndie_kit/revolver2

/datum/uplink_item/item/visible_weapons/sawnoff
	name = "Sawnoff Shotgun"
	item_cost = 35
	antag_costs = list(MODE_MERCENARY = 10)
	path = /obj/item/weapon/gun/projectile/shotgun/doublebarrel/sawn
