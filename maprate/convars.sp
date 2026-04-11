void ConVarsInit()
{
    gShowRatesAfterRating = CreateConVar("sm_maprate_show_rates_after_rating", "1", "Show the map rates to the player after they have rated it", _, true, _, true, 1.0);
    gNextRatingCooldown   = CreateConVar("sm_maprate_rating_cooldown", "5", "After how many seconds player can rate the map again (0 - disable it)", _, true, 0.0);
}