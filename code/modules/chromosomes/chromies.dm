/client/proc/get_chromie_count()
	establish_db_connection()
	var/DBQuery/query = dbcon.NewQuery("SELECT chromosomes FROM [format_table_name("player")] WHERE ckey = '[ckey]'")
	var/chr_count = 0
	if(query.Execute())
		if(query.NextRow())
			chr_count = query.item[1]

	qdel(query)
	return text2num(chr_count)

/client/proc/set_chromie_count(chr_count, ann=TRUE)
	establish_db_connection()
	var/DBQuery/query = dbcon.NewQuery("UPDATE [format_table_name("player")] SET chromosomes = '[chr_count]' WHERE ckey = '[ckey]'")
	query.Execute()
	qdel(query)
	if(ann)
		to_chat(src, "Your new chromosome count is [chr_count].")

/client/proc/inc_chromie_count(chr_count, ann=TRUE)
	establish_db_connection()
	var/DBQuery/query = dbcon.NewQuery("UPDATE [format_table_name("player")] SET chromosomes = chromosomes + '[chr_count]' WHERE ckey = '[ckey]'")
	query.Execute()
	qdel(query)
	if(ann)
		to_chat(src, "[chr_count] chromosomes have been transferred to your account. This shouldn't have happened.")

//query_get_chromie
//query_set_chromie
//query_inc_chromie