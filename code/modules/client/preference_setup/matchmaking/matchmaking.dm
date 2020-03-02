var/global/datum/matchmaker/matchmaker = new()

/hook/roundstart/proc/matchmaking()
	//matchmaker.do_matchmaking()
	return TRUE

/datum/matchmaker
	var/list/families = list()
	var/list/relation_types = list()
	var/list/relations = list()

/datum/matchmaker/New()
	..()
	for(var/T in subtypesof(/datum/relation/))
		var/datum/relation/R = T
		relation_types[initial(R.name)] = T

/datum/matchmaker/proc/do_matchmaking()
	var/list/to_warn = list()
	for(var/datum/relation/R in relations)
		if(!R.connected_relation && R.family_flag == 0)
			R.find_match()
		if(R.connected_relation && !R.finalized)
			to_warn |= R.relation_holder.current
	for(var/mob/M in to_warn)
		to_chat(M,"<span class='warning'>You have new connections. Use \"See Relationship Info\" to view and finalize them.</span>")

//This is where the families are made.  This is basically the big driver of everything.
/datum/matchmaker/proc/do_family_matchmaking()
	var/total_familes = round(GLOB.player_list.len * 0.2) + 1  // How many families we want Makes around 1 family per 4 people, and always at least on family
	var/list/player_list_copy = GLOB.player_list.Copy()
	//First setup families, and remove the family heads from the list
	while(families.len < total_familes)
		var/mob/living/carbon/human/pick_human = pick(GLOB.player_list)  //To make heads of families random (for now)
		var/datum/family/F = new /datum/family(pick_human)
		families |= F
		player_list_copy.Remove(pick_human)
	//Now that familes are created, add any left over humans to them
	for(var/mob/living/carbon/human/H in player_list_copy)
		var/datum/family/F = pick(families)
		F.add_member(H)
	/*Prints familes and memebers
	for(var/datum/family/F in families)
		to_world("Families head: [F.family_head.mind] Families last name = [F.name] Memebers are:")
		for(var/mob/living/carbon/human/M in F.members)
			to_world("Member: [M.real_name]")
	*/
	//Testing stuff
	/*
	var/list/test_player_list = list("John Doe", "Jane Dane", "Harold buster", "Jame righter", "Matt James", "Tim Panda", "Stever Typing", "The doom", "Debbie Downer", "Frail Mike")
	total_familes = round(test_player_list.len * 0.2)  // How many families we want Makes around 1 family per 4 people
	for(var/H in test_player_list)
		if(families.len < total_familes) // If we aren't at our limit yet, we make five ned players head of house
			var/datum/family/F = new /datum/family/(pick(test_player_list))
			families |= F
		else							 // If we are at our limit, start adding people to familes
			var/datum/family/F = pick(families)
			F.add_member(H)
	//Prints familes
	for(var/datum/family/F in families)
		to_world("Families head: [F.family_head] Families last name = [F.name] Memebers are:")
		for(var/M in F.members)
			to_world("Member: [M]")
	*/

/datum/matchmaker/proc/get_relationships(datum/mind/M)
	. = list()
	for(var/datum/relation/R in relations)
		if(R.relation_holder == M && R.connected_relation)
			. += R

//Types of relations

/datum/relation
	var/name = "Acquaintance"
	var/desc = "You just know them."
	var/list/can_connect_to	//What relations (names) can matchmaking join us with? Defaults to own name.
	var/list/incompatible 	//If we have relation like this with the mob, we can't join
	var/datum/mind/relation_holder  //Whoever owns this relationship
	var/datum/relation/connected_relation  //Whatever relationship this is connected to
	var/info
	var/finalized
	var/open = 2			//If non-zero, allow connected_relation relations to form connections
	var/family_flag = 0 //So we don't show family relations in options

/datum/relation/New()
	..()
	if(!can_connect_to)
		can_connect_to = list(name)
	matchmaker.relations += src

/datum/relation/proc/get_candidates()
	.= list()
	for(var/datum/relation/R in matchmaker.relations)
		if(!valid_candidate(R.relation_holder) || !can_connect(R))
			continue
		. += R

/datum/relation/proc/valid_candidate(datum/mind/M)
	if(M == relation_holder)	//no, you NEED connected_relation people
		return FALSE

	if(!M.current)	//no extremely platonic relationships
		return FALSE

	var/datum/antagonist/special_role_data = get_antag_data(M.special_role)
	if(special_role_data && (special_role_data.flags & ANTAG_OVERRIDE_JOB))
		return FALSE

	return TRUE

/datum/relation/proc/can_connect(var/datum/relation/R)
	for(var/datum/relation/D in matchmaker.relations) //have to check all connections between us and them
		if(D.relation_holder == R.relation_holder && D.connected_relation && D.connected_relation.relation_holder == relation_holder)
			if(D.name in incompatible)
				return 0
	return (R.name in can_connect_to) && !(R.name in incompatible) && R.open

/datum/relation/proc/get_copy()
	var/datum/relation/R = new type
	R.relation_holder = relation_holder
	R.info = relation_holder.current && relation_holder.current.client ? relation_holder.current.client.prefs.relations_info[R.name] : info
	R.open = 0
	return R

/datum/relation/proc/find_match()
	var/list/candidates = get_candidates()
	if(!candidates.len) //bwoop bwoop
		return 0
	var/datum/relation/R = pick(candidates)
	R.open--
	if(R.connected_relation)
		R = R.get_copy()
	connected_relation = R
	R.connected_relation = src
	return 1

/datum/relation/proc/sever()
	to_chat(relation_holder.current,"<span class='warning'>Your connection with [connected_relation.relation_holder] is no more.</span>")
	to_chat(connected_relation.relation_holder.current,"<span class='warning'>Your connection with [relation_holder] is no more.</span>")
	connected_relation.connected_relation = null
	matchmaker.relations -= connected_relation
	matchmaker.relations -= src
	qdel(connected_relation)
	connected_relation = null
	qdel(src)

//Finalizes and propagates info if both sides are done.
/datum/relation/proc/finalize()
	finalized = 1
	to_chat(relation_holder.current,"<span class='warning'>You have finalized a connection with [connected_relation.relation_holder].</span>")
	to_chat(connected_relation.relation_holder.current,"<span class='warning'>[relation_holder] has finalized a connection with you.</span>")
	if(connected_relation && connected_relation.finalized)
		to_chat(relation_holder.current,"<span class='warning'>Your connection with [connected_relation.relation_holder] is now confirmed!</span>")
		to_chat(connected_relation.relation_holder.current,"<span class='warning'>Your connection with [relation_holder] is now confirmed!</span>")
		var/list/candidates = filter_list(GLOB.player_list, /mob/living/carbon/human)
		candidates -= relation_holder.current
		candidates -= connected_relation.relation_holder.current
		for(var/mob/living/carbon/human/M in candidates)
			if(!M.mind || M.stat == DEAD || !valid_candidate(M.mind))
				candidates -= M
				continue
			var/datum/job/coworker = job_master.GetJob(M.job)
			if(coworker && relation_holder.assigned_job && connected_relation.relation_holder.assigned_job)
				if((coworker.department_flag & relation_holder.assigned_job.department_flag) || (coworker.department_flag & connected_relation.relation_holder.assigned_job.department_flag))
					candidates[M] = 5	//coworkers are 5 times as likely to know about your relations

		for(var/i=1 to 5)
			if(!candidates.len)
				break
			var/mob/M = pickweight(candidates)
			candidates -= M
			if(!M.mind.known_connections)
				M.mind.known_connections = list()
			if(prob(70))
				M.mind.known_connections += get_desc_string()
			else
				M.mind.known_connections += "[relation_holder] and [connected_relation.relation_holder] seem to know each connected_relation, but you're not sure on the details."

/datum/relation/proc/get_desc_string()
	return "[relation_holder] and [connected_relation.relation_holder] know each connected_relation."

/mob/living/verb/see_relationship_info()
	set name = "See Relationship Info"
	set desc = "See what connections between people you know of."
	set category = "IC"

	var/list/relations = matchmaker.get_relationships(mind)
	var/list/dat = list()
	var/editable = 0
	if(mind.gen_relations_info)
		dat += "<b>Things they all know about you:</b><br>[mind.gen_relations_info]<hr>"
		dat += "An <b>\[F\]</b> indicates that the connected_relation player has finalized the connection.<br>"
		dat += "<br>"
	for(var/datum/relation/R in relations)
		dat += "<b>[R.connected_relation.relation_holder]</b>, [R.connected_relation.relation_holder.role_alt_title ? R.connected_relation.relation_holder.role_alt_title : R.connected_relation.relation_holder.assigned_role]."
		if (!R.finalized)
			dat += " <a href='?src=\ref[src];del_relation=\ref[R]'>Remove</a>"
			editable = 1
		dat += "<br>[R.desc]"
		dat += "<br>"
		dat += "<b>Things they know about you:</b>[!R.finalized ?"<a href='?src=\ref[src];info_relation=\ref[R]'>Edit</a>" : ""]<br>[R.info ? "[R.info]" : " Nothing specific."]"
		if(R.connected_relation.info)
			dat += "<br><b>Things you know about them:</b><br>[R.connected_relation.info]<br>[R.connected_relation.relation_holder.gen_relations_info]"
		dat += "<hr>"

	if(mind.known_connections && mind.known_connections.len)
		dat += "<b>connected_relation people:</b>"
		for(var/I in mind.known_connections)
			dat += "<br><i>[I]</i>"

	var/datum/browser/popup = new(usr, "relations", "Relationship Info")
	if(editable)
		dat.Insert(1,"<a href='?src=\ref[src];relations_close=1;'>Finalize edits and close</a><br>")
		popup.set_window_options("focus=0;can_close=0;can_minimize=1;can_maximize=0;can_resize=1;titlebar=1;")
	popup.set_content(jointext(dat,null))
	popup.open()

/mob/living/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["del_relation"])
		var/datum/relation/R = locate(href_list["del_relation"])
		if(istype(R))
			R.sever()
			see_relationship_info()
			return 1
	if(href_list["info_relation"])
		var/datum/relation/R = locate(href_list["info_relation"])
		if(istype(R))
			var/info = sanitize(input("What would you like the connected_relation party for this connection to know about your character?","Character info",R.info) as message|null)
			if(info)
				R.info = info
				see_relationship_info()
				return 1
	if(href_list["relations_close"])
		var/ok = "Close anyway"
		ok = alert("HEY! You have some non-finalized relationships. You can terminate them if they do not fit your character, or edit the info tidbit that the connected_relation party is given. THIS IS YOUR ONLY CHANCE to do so - after you close the window, they won't be editable.","Finalize relationships","Return to edit", "Close anyway")
		if(ok == "Close anyway")
			var/list/relations = matchmaker.get_relationships(mind)
			for(var/datum/relation/R in relations)
				R.finalize()
			show_browser(usr,null, "window=relations")
		else
			show_browser(usr,null, "window=relations")
		return 1
