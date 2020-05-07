#define TICK_LIMIT_RUNNING 110
#define TICK_LIMIT_TO_RUN 108
#define TICK_LIMIT_MC 100
#define TICK_LIMIT_MC_INIT_DEFAULT 188

#define TICK_CHECK ( world.tick_usage > Master.current_ticklimit )
#define CHECK_TICK if TICK_CHECK stoplag()
