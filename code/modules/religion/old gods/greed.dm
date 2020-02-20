/datum/religion/greed
	name = GREED
	holy_item = new /obj/item/weapon/coin/gold()
	shrine = /obj/old_god_shrine/greed_shrine
	var/bloodgold = FALSE

/datum/old_god_spell/debt
	name = "Debt"
	requirments =  list("SOUTH" = /obj/item/weapon/handcuffs,
						"SOUTHEAST" = /obj/item/weapon/paper,
						"SOUTHWEST" = /obj/item/weapon/paper)
	old_god = GREED

	spell_effect(var/mob/living/user, var/list/spell_components)
		//TODO: his should be turned into a function for other spell use
		var/obj/item/weapon/paper/target1_paper = spell_components["SOUTHWEST"]
		var/obj/item/weapon/paper/target2_paper = spell_components["SOUTHEAST"]
		var/mob/target1 = get_player_from_paper(target1_paper)
		var/mob/target2 = get_player_from_paper(target2_paper)
		if(target1 && target2)
			var/L = target1.loc
			new /obj/item/weapon/paper/contract/debt/(L, user,  target1, target2)
			playsound(L, 'sound/effects/phone_ring.ogg', 50, 1, -1)

/datum/old_god_spell/blood_gold
	name = "Blood gold"
	requirments =  list("SOUTHEAST" = /obj/item/weapon/flame/candle/)
	old_god = GREED

	spell_effect(var/mob/living/user)
		to_chat(user, "<span class='danger'>You hear a sinister voice whisper unspeakable acts in your mind, promising untold profits</span>")
		var/sound = "sound/effects/badmood[pick(1,4)].ogg"
		playsound(get_turf(user), sound,50,1)
		GLOB.all_religions[GREED].bloodgold = TRUE
		spawn(300) //30 seconds
			GLOB.all_religions[GREED].bloodgold = FALSE
	
/obj/old_god_shrine/greed_shrine
	name = "Gozag Ym Sagoz shrine"
	shrine_religion = GREED
	icon_state = "alter_03"
	var/spell_to_blood = FALSE

/obj/old_god_shrine/greed_shrine/New()
	..()
	shrine_religion = GLOB.all_religions[GREED]


/* 
Debt contract
*/
/obj/item/weapon/paper/contract
	throw_range = 3
	throw_speed = 3
	var/signed = FALSE
	var/datum/mind/target
	info = "test"
	item_flags = ITEM_FLAG_NO_BLUDGEON

/obj/item/weapon/paper/contract/proc/update_text()
	return

/obj/item/weapon/paper/contract/debt
	icon_state = "paper_words"

/obj/item/weapon/paper/contract/debt/New(atom/loc, mob/living/nOwner, var/mob/target1, var/mob/target2)
	. = ..()
	if(!nOwner || !nOwner.mind)
		qdel(src)
		return -1
	target = nOwner.mind
	update_text(target1,target2)
	spawn(3000)
		for(var/datum/money_account/acounts in all_money_accounts)
			if(acounts.owner_name == target2.name)
				for(var/datum/transaction/T in acounts.transaction_log)
					if(T.target_name == target1.name)
						return
		for(var/mob/living/carbon/human/gore_target in GLOB.player_list)
			if(gore_target.name == target1.name)
				var/obj/item/organ/external/E = pick(gore_target.organs)
				E.droplimb(0, DROPLIMB_EDGE)
					

/obj/item/weapon/paper/contract/debt/update_text(var/mob/target1, var/mob/target2)
	name = "paper- [target] employment contract"
	to_world("These are our vars [target1], [target2]")
	info = "<center>NOTICE OF DEBT</center><BR>This letter is to inform you <bold>([target1.name])</bold> of a debt issued to your account, either by death of a relative or other means.  A claim has been places on your account for 1000 credits payed in full to <bold>[target2]</bold> Account Number: <bold>[target2.mind.initial_account.account_number]</bold> within the next 5 minutes.  Failure to do so will result in collection through alternative means. <BR>Sincerely, <BR> Gozag Ym Sagoz Banking"