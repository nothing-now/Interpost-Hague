/datum/family/
	var/name
	var/family_head
	var/list/members = list()

/datum/family/New(var/mob/living/carbon/human/head)
	var/regex/R = regex("\\w+$") //Get all words (\w+) that have an end of line ($).  Should pick off last names
	R.Find(head.real_name)
	name = R.match
	family_head = head.real_name
	to_world("Picked last name: [name]")

// Handles adding someone to the family datum "members"
// Also handles setting the player name correctly (TODO)
/datum/family/proc/add_member(var/mob/living/carbon/human/member)
	var/regex/R = regex("(^\\w+) (\\w+$)") //Get first name and last name
	R.Find(member.real_name)
	var/first_name = R.group[1]
	//var/last_name = R.group[2]
	member.real_name = "[first_name] [name]"
	members |= member
	to_world("Added [first_name] [name]")

/datum/relation/mother
	name = "Mother"
	desc = "They gave birth to you"
	incompatible = list("Son","Daughter","Cousin","Father")
	family_flag = 1

/datum/relation/mother/get_desc_string()
	return "[connected_relation.relation_holder] is your mother."

/datum/relation/father
	name = "Father"
	desc = "They banged your mom."
	incompatible = list("Son","Daughter","Cousin","Mother")
	family_flag = 1

/datum/relation/father/get_desc_string()
	return "[connected_relation.relation_holder] is your father."

/datum/relation/son
	name = "Son"
	desc = "They're your kid"
	incompatible = list("Mother","Father")
	family_flag = 1

/datum/relation/son/get_desc_string()
	return "[connected_relation.relation_holder] is your son."

/datum/relation/daughter
	name = "Daughter"
	desc = "They're your kid"
	incompatible = list("Mother","Father")
	family_flag = 1

/datum/relation/daughter/get_desc_string()
	return "[connected_relation.relation_holder] is your daughter."
