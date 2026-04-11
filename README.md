# sm-maprate
A SourceMod plugin that allows to rate a map and synchronize player ratings with a MySQL database


## Installation
- Go to [Releases](https://github.com/saxybois/sm-maprate/releases)
- Download next files: 
    - `maprate.smx`
    - `maprate.phrases.txt`
    - `maprate.inc` *(optional, required only for compiling plugins that use this include)*
- Put files in specific SourceMod folders
    - `maprate.smx` in `plugins`
    - `maprate.phrases.txt` in `translations`
    - `maprate.inc` in `scripts/include`
- In `configs/databases.cfg` add the following lines *(don't forget to replace the strings with your database's data)*:
    ```
    "MapRate"
        {
            "driver"	"mysql" 
            "host"		"<your database host>"      
            "database"  "<your database name>"
            "user"      "<your database user>"
            "pass"      "<your database pass>"
        }
    ```
- Restart the server
## Commands & ConVars
| Command | Admin Flag | Description |
|-|-|-|
| `sm_maprate` `sm_maprating` | None | Opens the menu for rating the current map |
| `sm_forcemaprate` | `g` (`ADMFLAG_CHANGEMAP`) | Opens the menu for rating the current map for all players |
| `sm_maprate_reset` | `n` (`ADMFLAG_CHEATS`) | Clear the plugin's memory and retrieve the data again |
| `sm_maprates` | Server console only | Display all map ratings in the console |

| ConVar | Default Value | Description |
|-|-|-|
| `sm_maprate_show_rates_after_rating` | 1 | Show the map rates to the player after they have rated it |
| `sm_maprate_rating_cooldown` | 5 | After how many seconds player can rate the map again (0 - disable it) |
## Dependencies
- **SourceMod 1.11 and newer to compile** *(release builds have been compiled on Sourcemod 1.12.0.7212)*
- **[MoreColors](https://github.com/DoctorMcKay/sourcemod-plugins/blob/master/scripting/include/morecolors.inc)** *(compile)*
## Examples for developers
- **Ultimate Map Chooser** | Force rating of the current map after a mapvote
```c
#include <maprate>
#include <umc-core>

public void UMC_OnNextmapSet(Handle kv, const char[] map, const char[] group, const char[] display)
{
	for(int client = 1; client < MaxClients; client++)
	{
		if(!IsClientInGame(client) || IsFakeClient(client))
			continue;
		
		if(MapRate_GetPlayerCurrentRate(client) == None)
			MapRate_AskToRate(client);
	}
}
```