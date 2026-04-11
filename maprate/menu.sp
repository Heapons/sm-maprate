void RateMenu(int client, bool changeRate = false, int display = MENU_TIME_FOREVER, DataPack cb = view_as<DataPack>(INVALID_HANDLE))
{
	if(!gWorking)
	{
		CPrintToChat(client, "%t %t", "Tag", "Plugin Still Getting Data");
		
		return;
	}

	char mapName[MAX_MAP_NAME_LENGTH];
	if(!gCurrentRating.GetDisplayName(mapName, sizeof(mapName)))
		GetCurrentMap(mapName, sizeof(mapName));

	bool rated = gPlayer[client].CurrentRate != None && !changeRate;

	Menu menu = new Menu(OnRateMenuAction);
	
	if(rated)
		menu.SetTitle("%T", "Menu Title Rated", client, gCurrentRating.Average, mapName);
	else
		menu.SetTitle("%T", "Menu Title Rating", client, mapName);
	int ratesSum = GetCurrentMapRateSum();
	char info[4], buffer[64];
	
	for(RateType rate = Terrible; rate <= Excellent; rate++)
	{
		if(rated)
		{
			char spacesPhrase[32];
			FormatEx(spacesPhrase, sizeof(spacesPhrase), "%s Spaces", gRatePhrases[rate]);
			
			int rateSum = gCurrentRates[rate].Length;
			float ratio = rateSum ? float(rateSum) / float(ratesSum) : 0.0;

			char bars[32];
			GetCountedBars(RoundFloat(float(MAX_BARS) * ratio), bars, sizeof(bars));

			FormatEx(buffer, sizeof(buffer), "%T:%T%s (%i)", gRatePhrases[rate], client, spacesPhrase, client, bars, gCurrentRates[rate].Length);
			FormatEx(info, sizeof(info), "--");
		}
		else
		{
			FormatEx(buffer, sizeof(buffer), "%T", gRatePhrases[rate], client);
			IntToString(view_as<int>(rate), info, sizeof(info));
		}

		if(rate == Excellent)
			Format(buffer, sizeof(buffer), "%s\n ", buffer);

		menu.AddItem(info, buffer, rated ? ITEMDRAW_DISABLED : ITEMDRAW_DEFAULT);
	}

	if(rated)
	{
		FormatEx(buffer, sizeof(buffer), "%T", "Menu Item Client Rate", client, gRatePhrases[gPlayer[client].CurrentRate], client);
		menu.AddItem("--", buffer, ITEMDRAW_DISABLED);
		FormatEx(buffer, sizeof(buffer), "%T", "Menu Item Rate Map", client);
		menu.AddItem("0", buffer);
	}
	
	if(cb != INVALID_HANDLE)
	{
		FormatEx(buffer, sizeof(buffer), "%i", view_as<int>(cb));
		menu.AddItem(buffer, "cb", ITEMDRAW_NOTEXT);

		menu.ExitBackButton = true;
	}
	
	menu.ExitButton = true;
	menu.Display(client, display);
}

int OnRateMenuAction(Menu menu, MenuAction action, int param1, int param2)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			char info[4];
			menu.GetItem(param2, info, sizeof(info));

			RateType rate = view_as<RateType>(StringToInt(info));

			DataPack cb = GetDataPackFromMenu(menu);
			if(cb != INVALID_HANDLE)
				cb = view_as<DataPack>(CloneHandle(cb))
			
			if(rate != None)
			{
				if(!gCurrentRating.Rate(param1, rate, cb) && cb != INVALID_HANDLE)
					delete cb;
			}
			else
				RateMenu(param1, true, _, cb);
		}
		case MenuAction_Cancel:
		{
			if(param2 == MenuCancel_ExitBack)
				InitCallbackFromDataPack(GetDataPackFromMenu(menu));
		}
		case MenuAction_End: 
		{
			DataPack cb = GetDataPackFromMenu(menu);
			if(cb != INVALID_HANDLE)
				delete cb;

			delete menu;
		}
	}

	return 0;
}