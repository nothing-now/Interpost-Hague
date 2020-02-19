//REAGENTS
//The revelator toxin this is probably going away
/datum/reagent/toxin/revelator
	name = "Revelator"
	description = "For proving heretics."
	strength = 15//Yep, it's poisonous. To discourage random checking.

/obj/item/weapon/reagent_containers/syringe/revelator
	name = "Syringe (revelator)"
	desc = "Contains drugs for checking heretics."
	New()
		..()
		reagents.add_reagent(/datum/reagent/toxin/revelator,15)

/datum/reagent/toxin/unrevelator
	name = "Unrevelator"
	description = "For tricking church members."
	strength = 15//Yep, it's poisonous. To discourage taking it all the time.

/obj/item/weapon/reagent_containers/syringe/unrevelator
	name = "weird old syringe"
	desc = "You're not sure what it has."
	New()
		..()
		reagents.add_reagent(/datum/reagent/toxin/unrevelator,15)
