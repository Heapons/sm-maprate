#if defined _maprate_included_
  #endinput
#endif
#define _maprate_included_

enum RateType
{
	None = 0,
	Terrible,
	Poor,
	Average,
	Good,
	Excellent
}

/**
 *	Called when player closed map rate menu
 *	@param client  Player index
 *	@noreturn
 */
typedef MapRate_MenuOnExitBack = function void (int client);

/**
 * Open map rating menu for client
 * @param client      	  	  Player index
 * @param forceRate   	  	  Forcing client rate a map even when they've already rated it
 * @param display     	  	  How long will the menu be displayed (0 - forever)  
 * @param onExitBackCallback  Callback func that will be activated after the player presses "Back" in the menu (this option appears if the function is specified in the parameter)
 */
native void MapRate_AskToRate(int client, bool forceRate = false, int display = 0, MapRate_MenuOnExitBack onExitBackCallback = INVALID_FUNCTION);

/**
 * Get the average of all ratings for a specified map
 * @param mapName  Map name (no .bsp)
 * @return  Average map rating
 */
native float MapRate_GetAverage(const char[] mapName);

/**
 * Set the map viewable (in menu and response) name
 * @param mapName      The name of the map where the viewable name will be set
 * @param displayName  Viewable name
 */
native void MapRate_SetDisplayName(const char[] mapName, const char[] displayName);

/**
 * Returns the plugin's status (whether all the ratings have been received)
 * @return  true if all location ratings have been received, otherwise false (also false will be returned during plugin data cleaning)
 */
native bool MapRate_IsWorking();

/**
 * Forward, called after successful launch and getting all ratings
 */
forward void MapRate_OnSuccessInit();

/**
 * Get player's current map rate
 * @param client  Player index
 * @return  Current map rate (None - player haven't rate map yet or not in the server)
 * @error  Invalid player index
 */
native RateType MapRate_GetPlayerCurrentRate(int client);

/**
 * Forward, called after a player successfully rated a map
 * @param client   Player index
 * @param rate     Player's map rate
 * @param oldRate  Player's old rate
 * @param display  The displayed name of the rated map
 */
forward void MapRate_OnPlayerMapRate(int client, RateType rate, RateType oldRate, const char[] display);

public SharedPlugin __pl_maprate = 
{
	name = "maprate",
	file = "maprate.smx",

	#if defined REQUIRE_PLUGIN
		required = 1
	#else
		required = 0
	#endif
};

#if !defined REQUIRE_PLUGIN
public void __pl_maprate_SetNTVOptional()
{
	MarkNativeAsOptional("MapRate_AskToRate");
	MarkNativeAsOptional("MapRate_GetAverage");
	MarkNativeAsOptional("MapRate_SetDisplayName");
	MarkNativeAsOptional("MapRate_IsWorking");
	MarkNativeAsOptional("MapRate_GetPlayerCurrentRate");
}
#endif