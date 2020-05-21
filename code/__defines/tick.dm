
#define MAPTICK_MC_MIN_RESERVE 40 //Percentage of tick to leave for master controller to run
#define MAPTICK_LAST_INTERNAL_TICK_USAGE ((GLOB.internal_tick_usage / world.tick_lag) * 100) //internal_tick_usage is updated every tick by extools

#define TICK_BYOND_RESERVE 2
#define TICK_LIMIT_RUNNING (max(90 - MAPTICK_LAST_INTERNAL_TICK_USAGE, MAPTICK_MC_MIN_RESERVE))
/// Tick limit used to resume things in stoplag
#define TICK_LIMIT_TO_RUN 78
/// Tick limit for MC while running
#define TICK_LIMIT_MC 70
/// Tick limit while initializing
#define TICK_LIMIT_MC_INIT_DEFAULT (100 - TICK_BYOND_RESERVE)

#define TICK_CHECK ( world.tick_usage > Master.current_ticklimit )
#define CHECK_TICK if TICK_CHECK stoplag()

//"fancy" math for calculating time in ms from tick_usage percentage and the length of ticks
//percent_of_tick_used * (ticklag * 100(to convert to ms)) / 100(percent ratio)
//collapsed to percent_of_tick_used * tick_lag
#define TICK_DELTA_TO_MS(percent_of_tick_used) ((percent_of_tick_used) * world.tick_lag)
#define TICK_USAGE_TO_MS(starting_tickusage) (TICK_DELTA_TO_MS(TICK_USAGE_REAL - starting_tickusage))

/// for general usage of tick_usage
#define TICK_USAGE world.tick_usage
/// to be used where the result isn't checked
#define TICK_USAGE_REAL world.tick_usage

/// Returns true if tick_usage is above the limit
#define TICK_CHECK ( TICK_USAGE > Master.current_ticklimit )
/// runs stoplag if tick_usage is above the limit
#define CHECK_TICK ( TICK_CHECK ? stoplag() : 0 )