/area
	luminosity           = TRUE
	var/dynamic_lighting = FALSE

/area/New()
	..()
	if(dynamic_lighting)
		luminosity = FALSE
