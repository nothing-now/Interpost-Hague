//This file is responsible for all kind of spell casting with old god stuff.  Hopefully it will be implimented in such a way that all someone needs to do to adds a spell is define a spell object with
// - Ingredients and 3x3 locations
// - Verb to call


//Old god "shrines" are whatever a cultists uses to cast magic.  Magic is cast by laying the correct objects in the correct configuration around a shrine, in a 3x3 patter, or
// X  X  X
// X  X  X
// X  X  X
/obj/old_god_shrine
	name = "Old God Shrine"
	icon = 'icons/obj/religion.dmi'
	icon_state = "woodcross"
	density = 1
	anchored = 1
	var/datum/religion/shrine_religion = null
	var/toughness = 5 //sorta fragile
	var/sounds = list('sound/hallucinations/behind_you1.ogg', 'sound/hallucinations/behind_you2.ogg', 'sound/hallucinations/growl1.ogg','sound/hallucinations/turn_around2.ogg')


/obj/old_god_shrine/New()
	shrine_religion = GLOB.all_religions[TEST_GOD]
	return

//Used when someone breaks a shrine
/obj/old_god_shrine/proc/destroy()
	shrine_religion.lose_territory(src.loc, shrine_religion.name)
	qdel(src)

/obj/old_god_shrine/attackby(obj/item/W as obj, var/mob/living/user)
	playsound(src.loc, pick(sounds), 100, 1)
	if(W.damtype == BRUTE || W.damtype == BURN) 
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if (W.force >= src.toughness)
			user.do_attack_animation(src)
			visible_message("<span class='warning'><b>[src] has been [pick(W.attack_verb)] with [W] by [user]!</b></span>")
			if (istype(W, /obj/item)) //is it even possible to get into attackby() with non-items?
				var/obj/item/I = W
				if (I.hitsound)
					playsound(loc, I.hitsound, 50, 1, -1)
					take_damage(W.force,user)

/obj/old_god_shrine/proc/take_damage(var/force, var/mob/living/user/attacker)
	playsound(src.loc, pick(sounds), 100, 1)
	//prob(25) gives an average of 1-2 hits
	if (force >= toughness && prob(75))
		destroy()

// DONT OVERRIDE THIS UNLESS YOU KNOW WHAT YOU ARE DOING
//  This does all the decoding from old_god_shrine datum -> actual spell
//  It looks up all spells with your God's tag, and then checks the requirments.  If you meet them, runs the spell's
/obj/old_god_shrine/proc/activate(var/mob/living/user)
	var/list/spells = list()
	for(var/S in GLOB.all_spells)
		if(GLOB.all_spells[S].old_god == user.religion)
			spells += GLOB.all_spells[S]
	var/datum/old_god_spell/selected_spell = input(user, "What spell will we use?") as null|anything in spells
	if(isnull(selected_spell))
		return
	var/list/spell_components = list()
	for(var/direction in selected_spell.requirments)
		// First check if it's empty
		var/found = FALSE
		//get turf contents
		for(var/obj/item/a in get_step(src, DIRECTION_TO_VAL(direction)).contents)
			if(istype(a, selected_spell.requirments[direction]))
				found = TRUE
				spell_components += a
		if (found == FALSE)
			visible_message("<span class='notice'>\The [src] glows faintly, then falls dark</span>")
			return
	selected_spell.spell_effect(user,spell_components)

/obj/old_god_shrine/attack_hand(var/mob/living/user)
	activate(user)

/obj/old_god_shrine/proc/near_camera()
	if (!isturf(loc))
		return 0
	else if(!cameranet.is_visible(src))
		return 0
	GLOB.global_headset.autosay("Heretical Shrine detected in [get_area(src)]","Verina","Inquisition")
	return 1