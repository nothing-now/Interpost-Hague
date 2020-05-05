#define SS_INIT_TICKER          -20
#define SS_PRIORITY_TICKER         100
#define SS_DISPLAY_TICKER         -10

SUBSYSTEM_DEF(ticker)
	name          = "Ticker"
	init_order    = SS_INIT_TICKER
	wait          = 2 SECONDS
	flags         = SS_KEEP_TIMING
	priority      = SS_PRIORITY_TICKER
	var/display_order = SS_DISPLAY_TICKER

	var/lastTickerTimeDuration
	var/lastTickerTime
	var/force_ending = 0

	var/datum/round_event/eof

/datum/controller/subsystem/ticker/Initialize(timeofday)
	NEW_SS_GLOBAL(SSticker)
	lastTickerTime = world.timeofday

	if (!ticker)
		ticker = new

	if (config.roundstart_events)
		eof = pick_round_event()

	if (eof)
		if(prob(30))
			eof.apply_event()
			eof.announce_event()


	spawn (0)
		if (ticker)
			ticker.pregame()

	..()


/datum/controller/subsystem/ticker/fire(resumed = FALSE)
	var/currentTime = world.timeofday

	if(currentTime < lastTickerTime) // check for midnight rollover
		lastTickerTimeDuration = (currentTime - (lastTickerTime - TICKS_IN_DAY)) / TICKS_IN_SECOND
	else
		lastTickerTimeDuration = (currentTime - lastTickerTime) / TICKS_IN_SECOND

	lastTickerTime = currentTime

	ticker.process()


/datum/controller/subsystem/ticker/proc/getLastTickerTimeDuration()
	return lastTickerTimeDuration
