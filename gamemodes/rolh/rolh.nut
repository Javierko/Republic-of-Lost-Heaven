/*
	> Republic Of Lost Heaven > 
	 > Mod Created by Javierko <
*/

//Definice
local g_iVersion = "0.0.11a";
local g_szRcon = "ROLHAdmin141";

//Serverové
local g_iAdmin = array(serverGetMaxPlayers(), 0);

//Hráčské
local g_iLog = array(serverGetMaxPlayers(), 0);
local g_iReg = array(serverGetMaxPlayers(), 0);
local g_iPass = array(serverGetMaxPlayers(), 0);
local g_iMoney = array(serverGetMaxPlayers(), 0);
local g_iJob = array(serverGetMaxPlayers(), 0);
local g_iXP = array(serverGetMaxPlayers(), 0);
local g_iNextXP = array(serverGetMaxPlayers(), 0);
local g_iKills = array(serverGetMaxPlayers(), 0);
local g_iDeaths = array(serverGetMaxPlayers(), 0);
local g_iLevel = array(serverGetMaxPlayers(), 0);
local g_iCars = array(serverGetMaxPlayers(), 0);
local g_iCarCount;

//Barvičky
local red = "#ff0000";
local green = "#00ff00";
local blue = "#0000ff";
local yellow = "#ffff00";
local orange = "#ff7700";
local white = "#ffffff";
local gray25 = "#bfbfbf";
local gray50 = "#808080";
local gray75 = "#404040";
local lightdark = "#1d1d1d"
local black = "#000000";
local cyan = "#00FFFF";

/*
	> Start <
*/

/*
	> Start > Server init <
*/
function onServerInit()
{
	print("== *************************************************************** ==");
	print("Starting gamemode Republic of Lost Heaven created by Javierko.");
	print("Republic of Lost Heaven succesfully started with version: " + g_iVersion);
	print("Debugger automaticly turned off!");
	print("== *************************************************************** ==");
	serverSetGamemodeName("Republic of Lost Heaven");
	
	eventBind("OnPlayerConnect", onPlayerConnectSer);
	eventBind("OnPlayerDisconnect", onPlayerDisconnectSer);
	eventBind("OnPlayerChat", onPlayerTextSer);
	eventBind("OnPlayerCommand", onPlayerCommandSer);
	eventBind("OnPlayerRespawn", onPlayerSpawnSer);
	eventBind("OnPlayerDeath", onPlayerDeathSer);
	eventBind("OnPlayerUpdate", onPlayerUpdateSer);
}

/*
	> Start > Player Connect <
*/
function onPlayerConnectSer(iID)
{
	g_iAdmin[iID] = 0;
	g_iLog[iID] = 0;
	g_iReg[iID] = 0;
	g_iXP[iID] = 0;
	g_iMoney[iID] = 0;
	g_iKills[iID] = 0;
	g_iDeaths[iID] = 0;
	g_iNextXP[iID] = 0;
	g_iLevel[iID] = 0;
	g_iCars[iID] = 0;
	
	if(!iniFileExists("players/" + playerGetName(iID) + ".fwp"))
	{
		iniSetParam("players/" + playerGetName(iID) + ".fwp", "Register", "0");
		iniSetParam("players/" + playerGetName(iID) + ".fwp", "Password", "none");
		iniSetParam("players/" + playerGetName(iID) + ".fwp", "Money", "0");
		iniSetParam("players/" + playerGetName(iID) + ".fwp", "Job", "none");
		iniSetParam("players/" + playerGetName(iID) + ".fwp", "XP", "0");
		iniSetParam("players/" + playerGetName(iID) + ".fwp", "Kills", "0");
		iniSetParam("players/" + playerGetName(iID) + ".fwp", "Deaths", "0");
		iniSetParam("players/" + playerGetName(iID) + ".fwp", "Next", "250");
		iniSetParam("players/" + playerGetName(iID) + ".fwp", "Lvl", "0");
		
		print("Vytvoreni noveho konfiguracniho souboru hrace " + playerGetName(iID) + " path: players/" + playerGetName(iID));
	}
	else
	{
		g_iReg[iID] = iniGetParam("players/" + playerGetName(iID) + ".fwp", "Register", "0").tointeger();
		g_iPass[iID] = iniGetParam("players/" + playerGetName(iID) + ".fwp", "Password", "");
		g_iMoney[iID] = iniGetParam("players/" + playerGetName(iID) + ".fwp", "Money", "0").tointeger();
		g_iJob[iID] = iniGetParam("players/" + playerGetName(iID) + ".fwp", "Job", "");
		g_iXP[iID] = iniGetParam("players/" + playerGetName(iID) + ".fwp", "XP", "0").tointeger();
		g_iKills[iID] = iniGetParam("players/" + playerGetName(iID) + ".fwp", "Kills", "0").tointeger();
		g_iDeaths[iID] = iniGetParam("players/" + playerGetName(iID) + ".fwp", "Deaths", "0").tointeger();
		g_iNextXP[iID] = iniGetParam("players/" + playerGetName(iID) + ".fwp", "Next", "0").tointeger();
		g_iLevel[iID] = iniGetParam("players/" + playerGetName(iID) + ".fwp", "Lvl", "0").tointeger();
	}
	
	if(g_iReg[iID] == 1)
	{
		playerSetObjective(iID, "Prosim, prihlas se pomoci prikazu /login [heslo]");
	}
	else
	{
		playerSetObjective(iID, "Prosim, zaregistuj se pomoci /register [heslo]");
	}
	
	playerSetPosition(iID, -1258.07, -6.48055, -753.819);
	playerLockControls(iID, true);
	playerEnableMoney(iID, false);
	
	return false;
}

/*
	> Start > Player Disconnect <
*/
function onPlayerDisconnectSer(iID, iReason)
{
	g_iAdmin[iID] = 0;
	g_iLog[iID] = 0;
	
	SaveIniParam(iID, "XP", g_iXP);
	SaveIniParam(iID, "Money", g_iMoney);
	
	if(!(g_iCars[iID] < 0))
	{
		vehicleDelete(g_iCars[iID]);
		g_iCars[iID] = -1;
	}
}

/*
	> Start > Player death <
*/
function onPlayerDeathSer(iVictim, iKiller, iWeapon, iBodyPart)
{
	if(IsValidClient(iKiller))
	{
		if(iKiller != iVictim)
		{
			g_iXP[iKiller] += 25;
			g_iMoney[iKiller] += 25;
			g_iKills[iKiller]++;
			
			SaveIniParam(iKiller, "Kills", g_iKills);
			SaveIniParam(iKiller, "Money", g_iMoney);
			SaveIniParam(iKiller, "XP", g_iXP);
		}
	}
	
	if(IsValidClient(iVictim))
	{
		if(iVictim != iKiller)
		{
			g_iDeaths[iVictim]++;
			iniSetParam("players/" + playerGetName(iVictim) + ".fwp", "Deaths", g_iDeaths[iVictim].tostring());
		}
	}
}

/*
	> Start > Player update <
*/
function onPlayerUpdateSer(iID)
{
	if(IsValidClient(iID))
	{
		if(g_iXP[iID] >= g_iNextXP[iID])
		{
			g_iNextXP[iID] += 500;
			g_iLevel[iID]++;
			
			iniSetParam("players/" + playerGetName(iID) + ".fwp", "Next", g_iNextXP[iID].tostring());
			iniSetParam("players/" + playerGetName(iID) + ".fwp", "Lvl", g_iLevel[iID].tostring());
		}
		
		playerSetMoney(iID, g_iMoney[iID]);
	}
}

/*
	> Start > Player Spawn <
*/
function onPlayerSpawnSer(iID)
{
	if(IsValidClient(iID))
	{
		playerSetHealth(iID, 200.0);
	}
}

/*
	Start > Player Text <
*/
function onPlayerTextSer(iID, szMessage)
{
	if(g_iAdmin[iID] == 1)
	{
		print("[Admin][" + playerGetName(iID) + "]: " + szMessage);
		
		if(g_iJob[iID] == "police")
		{
			sendAllMessage(red + "[Admin] " + cyan + playerGetName(iID) + white + " [" + iID + "]: " + yellow + szMessage);
		}
		else if(g_iJob[iID] == "taxikar")
		{
			sendAllMessage(red + "[Admin] " + orange + playerGetName(iID) + white + " [" + iID + "]: " + yellow + szMessage);
		}
		else if(g_iJob[iID] == "none")
		{
			sendAllMessage(red + "[Admin] " + white + playerGetName(iID) + white + " [" + iID + "]: " + yellow + szMessage);
		}
	}
	else
	{
		print("[" + playerGetName(iID) + "]: " + szMessage);
		
		if(g_iJob[iID] == "police")
		{
			sendAllMessage(cyan + playerGetName(iID) + white + " [" + iID + "]: " + white + szMessage);
		}
		else if(g_iJob[iID] == "taxikar")
		{
			sendAllMessage(orange + playerGetName(iID) + white + " [" + iID + "]: " + white + szMessage);
		}
		else if(g_iJob[iID] == "none")
		{
			sendAllMessage(white + playerGetName(iID) + white + " [" + iID + "]: " + white + szMessage);
		}
	}
	
	return false;
}

/*
	> Start > Player Commands <
*/
function onPlayerCommandSer(iID, szMessage, szParams)
{
	if(g_iLog[iID] == 1)
	{
		print(playerGetName(iID) + "["+ iID + "] pouzil prikaz: /" + szMessage);
		switch(szMessage)
		{
			case "admin":
			{
				local args = split(szParams," ");
				
				if(args.len() > 0)
				{
					if(g_iAdmin[iID] == 1)
					{
						sendPlayerMessage(iID, red + "Uz jsi prihlaseny jako admin!");
					}
					else
					{
						if(g_szRcon == szParams)
						{
							g_iAdmin[iID] = 1;
							sendPlayerMessage(iID, red + "Uspesne ses prihlasil jako administrator.");
							sendAllMessage(white + "Hrac " + red + playerGetName(iID) + white + " se prihlasil jako administrator.");
						}
						else
						{
							sendPlayerMessageError(iID, "Zadal jsi spatne heslo!");
						}
					}
				}

				break;
			}
			
			/*
				> Zaměstnání <
			*/
			//Policie
			case "police":
			{
				if(g_iJob[iID] != "police")
				{
					g_iJob[iID] = "police";
					iniSetParam("players/" + playerGetName(iID) + ".fwp", "Job", g_iJob[iID].tostring());
					sendPlayerMessage(iID, white + "Uspesne ses zapsal jako" + blue + "policajt" + white + ".");
				}
				else
				{
					sendPlayerMessage(iID, white + "Momentalne uz jsi policajt!");
				}
				
				break;
			}
			
			//Taxikář
			case "taxikar":
			{
				if(g_iJob[iID] != "taxikar")
				{
					g_iJob[iID] = "taxikar";
					iniSetParam("players/" + playerGetName(iID) + ".fwp", "Job", g_iJob[iID].tostring());
					sendPlayerMessage(iID, white + "Uspesne ses zapsal jako" + orange + "taxikar" + white + ".");
				}
				else
				{
					sendPlayerMessage(iID, white + "Momentalne uz jsi taxikar!");
				}
				
				break;
			}
			
			/*
				> Konec zaměstnání <
			*/
			
			case "stats":
			{
				playerAddConsoleText(iID, "00ff00", "Hlavni statistiky");
				playerAddConsoleText(iID, "ffffff", "XP: " + g_iXP[iID] + "/" + g_iNextXP[iID]);
				playerAddConsoleText(iID, "ffffff", "Level: " + g_iLevel[iID]);
				playerAddConsoleText(iID, "ffffff", "Zabiti: " + g_iKills[iID]);
				playerAddConsoleText(iID, "ffffff", "Smrti: " + g_iDeaths[iID]);
				playerAddConsoleText(iID, "ffffff", "Penize: " + g_iMoney[iID]);
				
				break;
			}
			
			case "players":
			{
				for(local i = 0; i < serverGetMaxPlayers(); i++)
				{
					if(IsValidClient(i))
					{
						sendPlayerMessage(iID, green + "ID: " + white + i + white + " |" + green + " Name: " + white + playerGetName(i) + " |" + green + " HP: " + white + playerGetHealth(i) + " | " + green + "SkinID: " + white + playerGetSkinID(i) + " |" + green + " Penize: " + white + playerGetMoney(i) + " |" + green + " Level: " + white + g_iLevel[i] + " |" + green + " XP: " + white + g_iXP[i]);
					}
				}
				
				break;
			}
			
			case "weapon":
			{
				local args = split(szParams, " ");
				local wepID = 0;
				local ammo = 1;
				local ammo2 = 0;
				
				if(args.len() > 0)
				{
					wepID = args[0].tointeger();
					if(args.len() > 1)
					{
						ammo = args[1].tointeger();
						if(args.len() > 2)
						{
							ammo2 = args[2].tointeger();
						}
					}
					
					playerAddWeapon(iID, wepID, ammo, ammo2);
					sendPlayerMessage(iID, "Successfully added weapon!");
				}
				
				break;
			}
			
			case "car":
			{
				if(IsValidClient(iID))
				{
					if(g_iLevel[iID] >= 5)
					{
						if(g_iJob[iID] != "none")
						{
							if(g_iMoney[iID] >= 250)
							{
								if(g_iCarCount < 20)
								{
									local pos = playerGetPosition(iID);
									local args = split(cParams," ");
									
									if(args.len() > 0)
									{
										if(args.tointeger() > 169)
										{
											sendPlayerMessageError(iID, "Nezname ID auta!");
										}
										else
										{
											g_iCarCount++;
											
											vehicleSpawn(args[0].tointeger(), pos[0] + 2, pos[1], pos[2], 1.0, 0.0, 0.0);
											sendPlayerMessage(iID, "Uspesne sis spawnul auto!");
											
											g_iMoney[iID] -= 250;
											iniSetParam("players/" + playerGetName(iID) + ".fwp", "Money", g_iMoney[iID].tostring());
											
										}
									}
									
									g_iCars[iID] = g_iCarCount - 1;
								}
								else
								{
									sendPlayerMessageError(iID, "Na ulici je dost aut, vem si nejake!");
								}
							}
							else
							{
								sendPlayerMessageError(iID, "Musis mit minimalne 250$!");
							}
						}
						else
						{
							sendPlayerMessageError(iID, "Pro spawnuti auta musis mit zamestnani!");
						}
					}
					else
					{
						sendPlayerMessageError(iID, "Pro spawnovani aut musis mit vetsi lvl nez 4!");
					}
				}
				
				break;
			}
			
			case "help":
			{
				printPlayerRules(iID);
				
				break;
			}
			
			case "login":
			{
				sendPlayerMessageError(iID, "Tento prikaz momentalne nemuzes pouzit!");
				
				break;
			}
			
			case "register":
			{
				sendPlayerMessageError(iID, "Tento prikaz momentalne nemuzes pouzit!");
				
				break;
			}
			
			case "version":
			{
				sendPlayerMessage(iID, white + "Current version of RoLH is" + red + g_iVersion);
				
				break;
			}
			
			case "ver":
			{
				sendPlayerMessage(iID, white + "Current version of RoLH is" + red + g_iVersion);
				
				break;
			}
			
			default:
			{
				sendPlayerMessageError(iID, "Neznamy prikaz.");
			}
		}
	}
	else
	{
		switch(szMessage)
		{
			case "login":
			{
				local args = split(szParams," ");
				
				if(args.len() > 0)
				{
					if(g_iReg[iID] == 1)
					{
						if(g_iPass[iID] == szParams)
						{
							g_iLog[iID] = 1;
							sendPlayerMessage(iID, "Uspesne ses prihlasil! Nyni si muzes uzivat paradu na serveru!");
							playerLockControls(iID, false);
							
							if(playerGetName(iID) == "Javierko")
							{
								g_iAdmin[iID] = 1;
								sendPlayerMessage(iID, red + "Uspesne ses prihlasil jako administrator.");
								sendAllMessage(white + "Hrac " + red + playerGetName(iID) + white + " se prihlasil jako administrator.");
							}
							
							sendPlayerMessage(iID, red + "====================================");
							sendPlayerMessage(iID, white + "Vitej na " + green + " RoLH" + white + " serveru!");
							sendPlayerMessage(iID, white + "Tento server je v" + green + " DEV" + white + " verzi, tudiz se na serveru muzou nachazet chyby.");
							sendPlayerMessage(iID, white + "Napis " + green + "/help " + white + "pro zjisteni prikazu");
							if(g_iJob[iID] != "none")
							{
								sendPlayerMessage(iID, white + "Momentalne pracujes jako: " + green + g_iJob[iID]);
							}
							else
							{
								sendPlayerMessage(iID, white + "Momentalne jsi: " + green + "nepracujici");
							}
							sendPlayerMessage(iID, white + "Autor modu " + green + "Javierko " + white + "| Verze: " + green + g_iVersion);
							sendPlayerMessage(iID, white + "Momentalne hraje na serveru " + green + serverGetOnlinePlayers() + white + " hracu.");
							sendPlayerMessage(iID, red + "====================================");
							
							playerEnableMoney(iID, true);
						}
						else
						{
							sendPlayerMessageError(iID, "Zadal jsi spatne heslo!");
						}
					}
				}
				else
				{
					sendPlayerMessageError(iID, "Spatny syntax, pouzij: /login [heslo]");
					playerSetObjective(iID, "Spatny syntax, pouzij: /login [heslo]");
				}
				
				break;
			}
			
			case "register":
			{
				local args = split(szParams," ");
				
				if(args.len() > 0)
				{
					if(g_iReg[iID] == 0)
					{
						iniSetParam("players/" + playerGetName(iID) + ".fwp", "Password", szParams);
						g_iPass[iID] = szParams;
						iniSetParam("players/" + playerGetName(iID) + ".fwp", "Register", "1");
						sendPlayerMessage(iID, "Uspesne ses registroval, ted se prihlas pomoci: /login [heslo]");
						playerSetObjective(iID, "Uspesne ses registroval, ted se prihlas pomoci: /login [heslo]");
						g_iReg[iID] = 1;
					}
				}
				else
				{
					sendPlayerMessageError(iID, "Spatny syntax, pouzij: /register [heslo]");
				}
				
				break;
			}
			
			default:
			{
				sendPlayerMessageError(iID, "Neznamy prikaz.");
			}
		}
	}
}

/*
	> Stocks <
*/

function IsValidClient(iID)
{
	if(playerIsConnected(iID))
	{
		return true;
	}
	
	return false;
}

function sendPlayerMessageError(iID, szMessage)
{
	sendPlayerMessage(iID, red + "Error: " + white + szMessage);
	
	return true;
}

function printPlayerRules(iID, iPage = 1)
{
	if(iPage == 1)
	{
		sendPlayerMessage(iID, green + "==============" + white + " /help [1]" + green + " ==============");
		sendPlayerMessage(iID, green + "/stats " + white + "- ukaze to vase aktualni statistiky");
		sendPlayerMessage(iID, green + "/players " + white + "- ukaze to aktualni online hrace na serveru a informace o nich");
		sendPlayerMessage(iID, green + "/car [id] " + white + "- spawne vam to auto s urcitou ID");
		sendPlayerMessage(iID, green + "/version, /ver " + white + "- vypise vam to aktualni verzi RoLH");
	}
}

function SaveIniParam(iID, szItem, cParam)
{
	iniSetParam("players/" + playerGetName(iID) + ".fwp", szItem, cParam[iID].tostring());
	
	return true;
}