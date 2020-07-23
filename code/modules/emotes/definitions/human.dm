/decl/emote/human
	key = "vomit"

/decl/emote/human/check_user(var/mob/living/carbon/human/user)
	return (istype(user) && user.check_has_mouth() && !user.isSynthetic())

/decl/emote/human/do_emote(var/mob/living/carbon/human/user)
	user.vomit()

/decl/emote/human/deathgasp
	key = "deathgasp"

/decl/emote/human/deathgasp/get_emote_message_3p(var/mob/living/carbon/human/user)
	return "USER [user.species.get_death_message()]"

/decl/emote/human/swish
	key = "swish"

/decl/emote/human/swish/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_once()

/decl/emote/human/wag
	key = "wag"

/decl/emote/human/wag/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_start()

/decl/emote/human/sway
	key = "sway"

/decl/emote/human/sway/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_start()

/decl/emote/human/qwag
	key = "qwag"

/decl/emote/human/qwag/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_fast()

/decl/emote/human/fastsway
	key = "fastsway"

/decl/emote/human/fastsway/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_fast()

/decl/emote/human/swag
	key = "swag"

/decl/emote/human/swag/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_stop()

/decl/emote/human/stopsway
	key = "stopsway"

/decl/emote/human/stopsway/do_emote(var/mob/living/carbon/human/user)
	user.animate_tail_stop()

//Shitty stuff starts here.
/decl/emote/human/poo
	key = "poo"

/decl/emote/human/poo/do_emote(var/mob/living/carbon/human/user)
	user.handle_shit()

/decl/emote/human/pee
	key = "pee"

/decl/emote/human/pee/do_emote(var/mob/living/carbon/human/user)
	user.handle_piss()

/decl/emote/human/dance
	key ="dance"
	check_restraints = TRUE
	emote_message_3p = "USER dances around happily."

/decl/emote/human/dance/do_emote(var/mob/living/carbon/human/user)
	user.do_dancing_animation()
	addtimer(CALLBACK(user, /mob/living/carbon.proc/do_dancing_animation, 10), 20) //dance immediately, then again after 2 and 4 seconds
	addtimer(CALLBACK(user, /mob/living/carbon.proc/do_dancing_animation, 10), 40)

/mob/living/proc/do_dancing_animation()
	var/amplitude = min(4, (35/100) + 1)
	var/pixel_x_diff = rand(-amplitude, amplitude)
	var/pixel_y_diff = rand(-amplitude/3, amplitude/3)
	var/final_pixel_x = get_standard_pixel_x_offset(lying)
	var/final_pixel_y = get_standard_pixel_y_offset(lying)
	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff , time = 2, loop = 6)
	animate(pixel_x = final_pixel_x , pixel_y = final_pixel_y , time = 2)

/mob/living/proc/get_standard_pixel_x_offset()
	return initial(pixel_x)

/mob/living/proc/get_standard_pixel_y_offset()
	return initial(pixel_y)