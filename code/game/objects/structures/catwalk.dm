/obj/structure/catwalk
	name = "catwalk"
	desc = "Cats really don't like these things."
	icon = 'icons/obj/catwalks.dmi'
	icon_state = "catwalk"
	density = 0
	anchored = 1.0
	plane = ABOVE_TURF_PLANE
	layer = CATWALK_LAYER

/obj/structure/catwalk/Initialize()
	. = ..()
	for(var/obj/structure/catwalk/C in get_turf(src))
		if(C != src)
			qdel(C)
	update_icon()
	redraw_nearby_catwalks()


/obj/structure/catwalk/Destroy()
	redraw_nearby_catwalks()
	return ..()

/obj/structure/catwalk/proc/redraw_nearby_catwalks()
	for(var/direction in GLOB.alldirs)
		var/obj/structure/catwalk/L = locate() in get_step(src, direction)
		if(L)
			L.update_icon() //so siding get updated properly


/obj/structure/catwalk/update_icon()
	var/connectdir = 0
	for(var/direction in GLOB.cardinal)
		if(locate(/obj/structure/catwalk, get_step(src, direction)))
			connectdir |= direction

	//Check the diagonal connections for corners, where you have, for example, connections both north and east. In this case it checks for a north-east connection to determine whether to add a corner marker or not.
	var/diagonalconnect = 0 //1 = NE; 2 = SE; 4 = NW; 8 = SW
	var/dirs = list(1,2,4,8)
	var/i = 1
	for(var/diag in list(NORTHEAST, SOUTHEAST,NORTHWEST,SOUTHWEST))
		if((connectdir & diag) == diag)
			if(locate(/obj/structure/catwalk, get_step(src, diag)))
				diagonalconnect |= dirs[i]
		i += 1

	icon_state = "catwalk[connectdir]-[diagonalconnect]"


/obj/structure/catwalk/ex_act(severity)
	switch(severity)
		if(1)
			new /obj/item/stack/rods(src.loc)
			qdel(src)
		if(2)
			new /obj/item/stack/rods(src.loc)
			qdel(src)

/obj/structure/catwalk/attackby(obj/item/C as obj, mob/user as mob)
	if(isWelder(C))
		var/obj/item/weapon/weldingtool/WT = C
		if(WT.remove_fuel(0, user))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			to_chat(user, "<span class='notice'>Slicing catwalk joints ...</span>")
			new /obj/item/stack/rods(src.loc)
			new /obj/item/stack/rods(src.loc)
			//Lattice would delete itself, but let's save ourselves a new obj
			if(istype(src.loc, /turf/space) || istype(src.loc, /turf/simulated/open))
				new /obj/structure/lattice/(src.loc)
			qdel(src)
/*
			deconstruct(user)
		return
	if(istype(C, /obj/item/weapon/gun/energy/plasmacutter))
		var/obj/item/weapon/gun/energy/plasmacutter/cutter = C
		if(!cutter.slice(user))
			return
		deconstruct(user)
		return
	if(isCrowbar(C) && plated_tile)
		hatch_open = !hatch_open
		if(hatch_open)
			playsound(src, 'sound/items/Crowbar.ogg', 100, 2)
			to_chat(user, "<span class='notice'>You pry open \the [src]'s maintenance hatch.</span>")
		else
			playsound(src, 'sound/items/Deconstruct.ogg', 100, 2)
			to_chat(user, "<span class='notice'>You shut \the [src]'s maintenance hatch.</span>")
		update_icon()
		return
	if(istype(C, /obj/item/stack/tile/mono) && !plated_tile)
		var/obj/item/stack/tile/floor/ST = C
		if(!ST.in_use)
			to_chat(user, "<span class='notice'>Placing tile...</span>")
			ST.in_use = 1
			if (!do_after(user, 10))
				ST.in_use = 0
				return
			to_chat(user, "<span class='notice'>You plate \the [src]</span>")
			name = "plated catwalk"
			ST.in_use = 0
			src.add_fingerprint(user)
			if(ST.use(1))
				var/list/decls = decls_repository.get_decls_of_subtype(/decl/flooring)
				for(var/flooring_type in decls)
					var/decl/flooring/F = decls[flooring_type]
					if(!F.build_type)
						continue
					if(ispath(C.type, F.build_type))
						plated_tile = F
						break
				update_icon()

/obj/structure/catwalk/refresh_neighbors()
	return

/obj/effect/catwalk_plated
	name = "plated catwalk spawner"
	icon = 'icons/obj/catwalks.dmi'
	icon_state = "catwalk_plated"
	density = 1
	anchored = 1.0
	var/activated = FALSE
	layer = ABOVE_TURF_PLANE
	var/plating_type = /decl/flooring/tiling/mono

/obj/effect/catwalk_plated/Initialize(mapload)
	. = ..()
	activate()
	return INITIALIZE_HINT_QDEL

/obj/effect/catwalk_plated/CanPass()
	return 0

/obj/effect/catwalk_plated/attack_hand()
	attack_generic()

/obj/effect/catwalk_plated/attack_ghost()
	attack_generic()

/obj/effect/catwalk_plated/attack_generic()
	activate()

/obj/effect/catwalk_plated/proc/activate()
	if(activated) return

	if(locate(/obj/structure/catwalk) in loc)
		warning("Frame Spawner: A catwalk already exists at [loc.x]-[loc.y]-[loc.z]")
	else
		var/obj/structure/catwalk/C = new /obj/structure/catwalk(loc)
		C.plated_tile += new plating_type
		C.name = "plated catwalk"
		C.update_icon()
	activated = 1
	for(var/turf/T in orange(src, 1))
		for(var/obj/effect/wallframe_spawn/other in T)
			if(!other.activated) other.activate()

/obj/effect/catwalk_plated/dark
	icon_state = "catwalk_plateddark"
	plating_type = /decl/flooring/tiling/mono/dark

/obj/effect/catwalk_plated/white
	icon_state = "catwalk_platedwhite"
	plating_type = /decl/flooring/tiling/mono/white
*/