/*
	The global hud:
	Uses the same visual objects for all players.
*/

GLOBAL_DATUM_INIT(global_hud, /datum/global_hud, new())

/datum/global_hud
	var/obj/screen/nvg
	var/obj/screen/thermal
	var/obj/screen/meson
	var/obj/screen/science

/datum/global_hud/proc/setup_overlay(icon_state, color)
	var/obj/screen/screen = new /obj/screen()
	screen.screen_loc = ui_entire_screen
	screen.icon = 'icons/obj/hud_full.dmi'
	screen.icon_state = icon_state
	screen.mouse_opacity = 0
	screen.plane = FULLSCREEN_PLANE
	screen.layer = FULLSCREEN_LAYER
	screen.alpha = 125

	screen.blend_mode = BLEND_MULTIPLY
	screen.color = color

	return screen

/datum/global_hud/New()
	nvg = setup_overlay("nvg_hud")
	thermal = setup_overlay("thermal_hud")
	meson = setup_overlay("meson_hud")
	science = setup_overlay("science_hud")