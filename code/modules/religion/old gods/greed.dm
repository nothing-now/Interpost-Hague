/datum/religion/greed
	name = GREED
	holy_item = new /obj/item/weapon/coin/gold()
	shrine = /obj/old_god_shrine/greed_shrine

/datum/old_god_spell/debt
	name = "Debt"
	requirments =  list("SOUTH" = /obj/item/weapon/paper)
	// requirments =  list("SOUTHEAST" = /obj/item/weapon/handcuffs,
	// 					"SOUTH" = /obj/item/weapon/paper,
	// 					"SOUTHWEST" = /obj/item/weapon/handcuffs,
	// 					"NORTH" = /ore/gold)
	old_god = GREED

	spell_effect(var/mob/living/user, var/list/spell_components)
		//TODO: his should be turned into a function for other spell use
		var/obj/item/weapon/paper/target_paper = locate(/obj/item/weapon/paper/) in spell_components
		for(var/mob/player in GLOB.player_list)
			to_world("checking [player.name]")
			if(findtext(target_paper.info, player.name))
				to_world("Got our victim!")
		to_world("[target_paper.info]")

/datum/old_god_spell/blood_gold
	name = "Blood gold"
	requirments =  list("SOUTHEAST" = /obj/item/weapon/flame/candle/,
						"EAST" = /obj/item/weapon/flame/candle/,
						"WEST" = /obj/item/weapon/flame/candle/,
						"SOUTH" = /obj/item/weapon/flame/candle/)
	old_god = GREED

	spell_effect(var/mob/living/user)
		to_world("for a short time, enemies bleed money.  Literally")
	
/obj/old_god_shrine/greed_shrine
	name = "Gozag Ym Sagoz shrine"
	shrine_religion = GREED
	icon_state = "alter_03"

/obj/old_god_shrine/greed_shrine/New()
	shrine_religion = GLOB.all_religions[GREED]