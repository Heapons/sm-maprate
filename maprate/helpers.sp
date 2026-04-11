bool IsCurrentMap(const char[] map)
{
	char currentMap[MAX_MAP_NAME_LENGTH];
	GetCurrentMap(currentMap, sizeof(currentMap));

	return !strcmp(map, currentMap);
}

float GetCurrentRatesAverage()
{
	int sum, amount;

	for(RateType rate = Excellent; rate > None; rate--)
	{
		int length = gCurrentRates[rate].Length;

		sum += (gCurrentRates[rate].Length * view_as<int>(rate));
		amount += length;
	}

	if(amount)
		return (float(sum) / float(amount));
	else
		return 0.0;
}

RateType GetClientMapRate(int client)
{
	char auth[32];
	GetClientAuthId(client, AuthId_Steam2, auth, sizeof(auth));

	for(RateType rate = Excellent; rate > None; rate--)
	{
		if(gCurrentRates[rate].FindString(auth) != -1)
			return rate;
	}

	return None;
}

int GetCurrentMapRateSum()
{
	int sum;
	
	for(RateType rate = Excellent; rate > None; rate--)
		sum += gCurrentRates[rate].Length;

	return sum;
}

void GetCountedBars(int barsSum, char[] buffer, int maxLength)
{
	for(int i = 0; i < MAX_BARS; i++)
	{
		if(i < barsSum)
			StrCat(buffer, maxLength, "▓");
		else
			StrCat(buffer, maxLength, "░");
	}
}

stock bool IsEntityPlayer(int entity)
{
	return IsValidEntity(entity) && (1 <= entity <= MaxClients);
}

stock bool IsValidClient(int client)
{
	if(!IsEntityPlayer(client))
		return false;

	if(!IsClientConnected(client) || !IsClientInGame(client))
		return false;

	return true;
}

DataPack CreateDataPackForCallback(Handle plugin, Function callback, int data = 0)
{
	DataPack pack = new DataPack();
	pack.WriteCell(plugin);
	pack.WriteFunction(callback);
	pack.WriteCell(data);

	return pack;
}

DataPack GetDataPackFromMenu(Menu menu)
{
	char address[2][32];
	menu.GetItem(menu.ItemCount - 1, address[0], sizeof(address[]), _, address[1], sizeof(address[]));

	return !strcmp(address[1], "cb") ? view_as<DataPack>(StringToInt(address[0])) : view_as<DataPack>(INVALID_HANDLE);
}

void InitCallbackFromDataPack(DataPack pack)
{
	if(pack == INVALID_HANDLE)
		return;

	pack.Reset();
	Handle plugin = pack.ReadCell();
	Function cb = pack.ReadFunction();
	int data = pack.ReadCell();

	Call_StartFunction(plugin, cb);

	Call_PushCell(data);

	int finish = Call_Finish();
	if(finish)
		LogError("InitCallbackFromDataPack() :: Something wrong happened while calling a function (error code: %i)", finish);
}

Action OnCooldownThink(Handle timer, int userid)
{
	int client = GetClientOfUserId(userid);
	if(!client)
		return Plugin_Stop;

	if(!gPlayer[client].Cooldown)
	{
		gPlayer[client].Timer = null;
		return Plugin_Stop;
	}
	
	gPlayer[client].Cooldown--;
	return Plugin_Continue;
}