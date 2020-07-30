/mob/living/carbon/proc/print_happiness(var/mob/living/carbon/human/H)
	var/msg = "\n<span class='info'>|----------|</span>\n"
	msg += "<span class='info'>I am a follower of <font color='red'>[religion]</font></span>.\n"
	msg += "<span class='info'>My name is <font color='green'>[name].</font></span>\n"
	msg += "<span class='info'>I am <font color='red'>[H.age]</font> years old.</span>\n"
	msg += "<span class='info'>Everyone knows that I am [get_social_class()].</span>\n"
	msg += "<span class='info'>I am a <font color='blue'>[H.gender]</font>, as well.\n"
	msg += "<span class='info'>*---------*\n<EM>Current mood</EM>\n"
	for(var/i in events)
		var/datum/happiness_event/event = events[i]
		msg += event.description

	if(!events.len)
		msg += "<span class='info'>I feel indifferent.</span>\n"


	msg += "<span class='info'>*---------*</span>"
	to_chat(src, msg)

/mob/living/carbon/proc/update_happiness()
	var/old_happiness = happiness
	var/old_icon = null
	if(happiness_icon)
		old_icon = happiness_icon.icon_state
	happiness = 0
	for(var/i in events)
		var/datum/happiness_event/event = events[i]
		happiness += event.happiness

	switch(happiness)
		if(-5000000 to MOOD_LEVEL_SAD4)
			if(happiness_icon)
				happiness_icon.icon_state = "mood7"

		if(MOOD_LEVEL_SAD4 to MOOD_LEVEL_SAD3)
			if(happiness_icon)
				happiness_icon.icon_state = "mood6"

		if(MOOD_LEVEL_SAD3 to MOOD_LEVEL_SAD2)
			if(happiness_icon)
				happiness_icon.icon_state = "mood5"

		if(MOOD_LEVEL_SAD2 to MOOD_LEVEL_SAD1)
			if(happiness_icon)
				happiness_icon.icon_state = "mood5"

		if(MOOD_LEVEL_SAD1 to MOOD_LEVEL_HAPPY1)
			if(happiness_icon)
				happiness_icon.icon_state = "mood4"

		if(MOOD_LEVEL_HAPPY1 to MOOD_LEVEL_HAPPY2)
			if(happiness_icon)
				happiness_icon.icon_state = "mood4"

		if(MOOD_LEVEL_HAPPY2 to MOOD_LEVEL_HAPPY3)
			if(happiness_icon)
				happiness_icon.icon_state = "mood3"

		if(MOOD_LEVEL_HAPPY3 to MOOD_LEVEL_HAPPY4)
			if(happiness_icon)
				happiness_icon.icon_state = "mood2"

		if(MOOD_LEVEL_HAPPY4 to INFINITY)
			if(happiness_icon)
				happiness_icon.icon_state = "mood1"

	if(old_icon && old_icon != happiness_icon.icon_state)
		if(old_happiness > happiness)
			to_chat(src, "<span class='warning'>My mood gets worse.</span>")
		else
			to_chat(src, "<span class='info'>My mood gets better.</span>")

/mob/proc/flash_sadness()
	if(prob(2))
		flick("sadness",pain)
		var/spoopysound = pick('sound/effects/badmood1.ogg','sound/effects/badmood2.ogg','sound/effects/badmood3.ogg','sound/effects/badmood4.ogg')
		sound_to(src, spoopysound)

/mob/living/carbon/proc/handle_happiness()
	switch(happiness)
		if(-5000000 to MOOD_LEVEL_SAD4)
			flash_sadness()
			crit_mood_modifier = -10
		if(MOOD_LEVEL_SAD4 to MOOD_LEVEL_SAD3)
			flash_sadness()
			crit_mood_modifier = -5
		if(MOOD_LEVEL_SAD1 to MOOD_LEVEL_HAPPY2)
			crit_mood_modifier = CRIT_SUCCESS_NORM
		if(MOOD_LEVEL_HAPPY3 to MOOD_LEVEL_HAPPY4)
			crit_mood_modifier = 5
		if(MOOD_LEVEL_HAPPY4 to INFINITY)
			crit_mood_modifier = 10


/mob/living/carbon/proc/add_event(category, type) //Category will override any events in the same category, should be unique unless the event is based on the same thing like hunger.
	var/datum/happiness_event/the_event
	if(events[category])
		the_event = events[category]
		if(the_event.type != type)
			clear_event(category)
			return .()
		else
			return 0 //Don't have to update the event.
	else
		the_event = new type()

	events[category] = the_event
	update_happiness()

	if(the_event.timeout)
		spawn(the_event.timeout)
			clear_event(category)

/mob/living/carbon/proc/clear_event(category)
	var/datum/happiness_event/event = events[category]
	if(!event)
		return 0

	events -= category
	qdel(event)
	update_happiness()

/mob/living/carbon/proc/handle_hygiene()
	adjust_hygiene(-my_hygiene_factor)
	var/image/smell = image('icons/effects/effects.dmi', "smell")//This is a hack, there has got to be a safer way to do this but I don't know it at the moment.
	switch(hygiene)
		if(HYGIENE_LEVEL_NORMAL to INFINITY)
			add_event("hygiene", /datum/happiness_event/hygiene/clean)
			overlays -= smell
		if(HYGIENE_LEVEL_DIRTY to HYGIENE_LEVEL_NORMAL)
			clear_event("hygiene")
			overlays -= smell
		if(0 to HYGIENE_LEVEL_DIRTY)
			overlays -= smell
			overlays += smell
			add_event("hygiene", /datum/happiness_event/hygiene/smelly)

/mob/living/carbon/proc/adjust_hygiene(var/amount)
	var/old_hygiene = hygiene
	if(amount>0)
		hygiene = min(hygiene+amount, HYGIENE_LEVEL_CLEAN)

	else if(old_hygiene)
		hygiene = max(hygiene+amount, 0)

/mob/living/carbon/proc/set_hygiene(var/amount)
	if(amount >= 0)
		hygiene = min(HYGIENE_LEVEL_CLEAN, amount)

#define DEHYDRATION_MIN 200
#define DEHYDRATION_NOTICE 100
#define DEHYDRATION_WEAKNESS 50
#define DEHYDRATION_NEARDEATH -100
#define DEHYDRATION_NEGATIVE_INFINITY -10000

#define DEHYDRATION_OXY_DAMAGE 2.5
#define DEHYDRATION_TOX_DAMAGE 2.5
#define DEHYDRATION_BRAIN_DAMAGE 2.5
#define DEHYDRATION_OXY_HEAL_RATE 1

/mob/living/carbon/human/proc/handle_stomach()
	spawn(0)
		for(var/a in stomach_contents)
			if(!(a in contents) || isnull(a))
				stomach_contents.Remove(a)
				continue
			if(iscarbon(a)|| isanimal(a))
				var/mob/living/M = a
				if(M.stat == DEAD)
					M.death(1)
					stomach_contents.Remove(M)
					qdel(M)
					continue
				if(!(M.status_flags & GODMODE))
					M.adjustBruteLoss(5)
				nutrition += 10
	var/list/hunger_phrases = list(
		"You feel weak and malnourished. You must find something to eat now!",
		"You haven't eaten in ages, and your body feels weak! It's time to eat something.",
		"You can barely remember the last time you had a proper, nutritional meal. Your body will shut down soon if you don't eat something!",
		"Your body is running out of essential nutrients! You have to eat something soon.",
		"If you don't eat something very soon, you're going to starve to death."
		)
	var/list/shunger_phrases = list(
		"Your stomach is growling.",
		"You should grab something to eat.",
		"It will be nice if you find something to eat.",
		"You belly growls."
		)
	var/list/dehydratation_phrases = list(
		"You feel weak and malnourished. You must find something to drink now!",
		"You haven't drunk in ages, and your body feels weak! It's time to eadrinkt something.",
		"You can barely remember the last time you had a drink. Your body will shut down soon if you don't drink something!",
		"Your body is running out of essential water! You have to drink something soon.",
		"If you don't drink something very soon, you're going to dehydrate to death."
		)
	var/list/sdehydratation_phrases = list(
		"Your throat is sore.",
		"You should grab something to drink.",
		"It will be nice if you find something to drink."
		)
//DEHYDRATATION//////////////////////////
		//When you're starving, the rate at which oxygen damage is healed is reduced by 80% (you only restore 1 oxygen damage per life tick, instead of 5)
	if(hydration < 300)
		switch(hydration)
			if(DEHYDRATION_NOTICE to DEHYDRATION_MIN) //60-80
				add_event("thirsty", /datum/happiness_event/thirst/thirsting)
				if(sleeping)
					return
				if(prob(2))
					to_chat(src, "<span class='danger'>[pick(sdehydratation_phrases)]</span>")
			if(DEHYDRATION_WEAKNESS to DEHYDRATION_NOTICE) //30-60
				add_event("thirsty", /datum/happiness_event/thirst/thirsty)
				if(sleeping)
					return

				if(prob(5)) //3% chance of a tiny amount of oxygen damage (1-10)

					adjustOxyLoss(rand(10,20))
					to_chat(src, "<span class='danger'>[pick(dehydratation_phrases)]</span>")

			if(DEHYDRATION_NEARDEATH to DEHYDRATION_WEAKNESS) //5-30, 5% chance of weakening and 1-230 oxygen damage. 5% chance of a seizure. 10% chance of dropping item
				add_event("thirsty", /datum/happiness_event/thirst/verythirsty)
				if(sleeping)
					return

				if(prob(3))

					adjustOxyLoss(rand(10,30))
					to_chat(src, "<span class='danger'>You're dehydrating. You feel your life force slowly leaving your body...</span>")
					eye_blurry += 20
					Weaken(20)

				else if(paralysis<1 && prob(5)) //Mini seizure (25% duration and strength of a normal seizure)

					Weaken(15)
					make_jittery(15)
					make_dizzy(1)
					adjustOxyLoss(rand(5,25))
					eye_blurry += 20

			if(-INFINITY to DEHYDRATION_NEARDEATH) //Fuck the whole body up at this point
				add_event("thirsty", /datum/happiness_event/thirst/dehydrated)
				to_chat(src, "<span class='danger'>You are dying from dehydratation!</span>")
				adjustToxLoss(STARVATION_TOX_DAMAGE)
				adjustOxyLoss(STARVATION_OXY_DAMAGE)
				adjustBrainLoss(STARVATION_BRAIN_DAMAGE)

				if(prob(10))
					Weaken(15)
	//NUTRITION/////////////////////////////
	if(nutrition < 300) //Nutrition is below 100 = starvation
		switch(nutrition)
			if(STARVATION_NOTICE to STARVATION_MIN) //60-80
				add_event("hungry", /datum/happiness_event/nutrition/lilhungry)
				if(sleeping)
					return

				if(prob(2))
					to_chat(src, "<span class='danger'>[pick(shunger_phrases)]</span>")


			if(STARVATION_WEAKNESS to STARVATION_NOTICE) //30-60
				add_event("hungry", /datum/happiness_event/nutrition/hungry)
				if(sleeping)
					return

				if(prob(3)) //3% chance of a tiny amount of oxygen damage (1-10)

					adjustOxyLoss(rand(10,20))
					to_chat(src, "<span class='danger'>[pick(hunger_phrases)]</span>")

			if(STARVATION_NEARDEATH to STARVATION_WEAKNESS) //5-30, 5% chance of weakening and 1-230 oxygen damage. 5% chance of a seizure. 10% chance of dropping item
				add_event("hungry", /datum/happiness_event/nutrition/veryhungry)
				if(sleeping)
					return

				if(prob(3))

					adjustOxyLoss(rand(10,30))
					to_chat(src, "<span class='danger'>You're starving. You feel your life force slowly leaving your body...</span>")
					eye_blurry += 20
					Weaken(20)

				else if(paralysis<1 && prob(5)) //Mini seizure (25% duration and strength of a normal seizure)

					Weaken(15)
					make_jittery(15)
					make_dizzy(1)
					adjustOxyLoss(rand(5,25))
					eye_blurry += 20

			if(-INFINITY to STARVATION_NEARDEATH) //Fuck the whole body up at this point
				add_event("hungry", /datum/happiness_event/nutrition/starving)
				to_chat(src, "<span class='danger'>You are dying from starvation!</span>")
				adjustToxLoss(STARVATION_TOX_DAMAGE)
				adjustOxyLoss(STARVATION_OXY_DAMAGE)
				adjustBrainLoss(STARVATION_BRAIN_DAMAGE)

				if(prob(10))
					Weaken(15)