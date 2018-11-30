/*
    > Definice <
*/

local VERSION = "0.1.3a";

local g_lRcon = "123456789";
local g_lAdsInterval = 120;
local g_lAds = ["Be patient, this server may have some bugs!","This gamemode is under development by Javierko.","If you have some idea's to do, just contact us!","Do wanna some job? Then join to job! /jobs"];
local g_lAdsPrefix = "#ffffff[#ff0000LH#ffffff:MP #ff0000Reborn#ffffff] ";
local g_lCarSweep = 3;

local g_lAdmin = array(serverGetMaxPlayers(), 0);
local g_lRadio = array(serverGetMaxPlayers(), 0);
local g_lCars = array(serverGetMaxPlayers(), -1);
local g_lMsg = array(serverGetMaxPlayers(), 0);

local g_pPolicie = array(serverGetMaxPlayers(), 0);
local g_pZachranar = array(serverGetMaxPlayers(), 0);
local g_pTaxikar = array(serverGetMaxPlayers(), 0);

local g_lLog = array(serverGetMaxPlayers(), 0);

local g_lPedsBlocked = [1,2,5,6,7,9,10,11,12,13,15,17,18,19,22,28,31,42,43,45,62,63,74,77,78,80,82,83,84,85,86,87,89,98,100,109,112,117,123,124,125,132,137,149,150,154,155,156,157,158,159,161,163,164,166,170,176,177,178,179,170,187,193,197,199,214,218,222,224,226,228,234,238,250,252,255,257,259,263,279,278,280,286,289,293,297,298,299,300,301,302,303];
local g_lPeds = [3,4,8,14,16,20,21,23,24,25,26,27,29,30,32,33,37,38,39,40,41,44,46,47,48,49,50,51,55,56,57,58,59,60,61,64,65,66,67,68,69,70,71,72,73,75,76,79,81,88,90,91,92,93,94,95,96,97,99,101,102,103,104,105,106,107,108,110,111,113,114,115,116,118,119,120,121,122,126,129,130,131,133,134,135,136,138,139,140,141,142,143,144,145,146,147,148,151,152,153,160,162,165,167,168,169,171,172,173,174,175,181,182,183,184,185,186,188,189,190,191,192,194,195,196,198,200,201,202,203,204,205,206,207,208,209,210,211,212,213,215,216,217,219,220,221,223,225,227,229,230,231,232,233,235,236,237,239,247,248,249,251,253,254,256,258,260,261,262,264,265,266,267,268,269,270,271,272,273,274,275,277,279,281,282,283,284,285,287,288,290,291,292,294,295,296];
local g_lPedsPolice = [34,35,36,127,128,240,241,242,243,244,245,246];
local g_lPedsDetective = [52,53,54];

local g_lPoliceCars = [111,115,119,123];
local g_lTaxiCars = [166,163,161,154,153,96]
local g_lGangsterCars = [95,122,126,128,130,137,138,139,140];
local g_lDoctorCars = [144];

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

local g_iCarCount = 0;
local g_iSeconds = 0;
local g_iSecondsC = 0;

/*
    > Main <
*/

//Start
function onServerInit()
{
    print("LH:MP Reborn RoLH successfully started!");
    serverSetGamemodeName("RoLH " + VERSION);
}

//Connect
function onPlayerConnect(iID)
{
	playerChangeSkin(iID, g_lPeds[rand()%g_lPeds.len()]);
	print(playerGetName(iID) + " joined the game.");

    guiToggleNametag(iID, 0);
}

//Disconnect
function onPlayerDisconnect(iID)
{
    g_lMsg[iID] = 0;
    g_lAdmin[iID] = 0;
    g_lRadio[iID] = 0;

    if(g_lCars[iID] != -1)
    {
        vehicleDelete(g_lCars[iID]);
        g_lCars[iID] = -1;
    }

    print(playerGetName(iID) + " left the game.");
}

//Spawn
function onPlayerSpawn(iID)
{
	sendPlayerMessage(iID, white + playerGetName(iID) + green + " you have been spawned.");
    g_lMsg[iID]++;

    if(g_lMsg[iID] == 1)
    {    
        local g_cInfo = array(serverGetMaxPlayers(), 0);
        g_cInfo[iID] = "You dont have any job! (/jobs)";
        local pJob = iniGetParam("players/players_job_" + playerGetName(iID) + ".txt", "job", "nema");

        if(pJob == "policie")
        {
            g_pPolicie[iID] = 1;
            g_cInfo[iID] = "#00FFFFPolice man";
        }
        else if(pJob == "zachranar")
        {
            g_pZachranar[iID] = 1;
            g_cInfo[iID] = "#ffff00Doctor";
        }
        else if(pJob == "taxikar")
        {
            g_pTaxikar[iID] = 1;
            g_cInfo[iID] = "#ff7700Taxi driver";
        }

        //Msg
        sendPlayerMessage(iID, red + "====================================");
        sendPlayerMessage(iID, white + "Welcome to " + green + " RoLH" + white + " server!");
        sendPlayerMessage(iID, white + "This server is in" + green + " DEV" + white + " version, so some things can't work.");
        sendPlayerMessage(iID, white + "Type " + green + "/help " + white + "to get commands.");
		sendPlayerMessage(iID, white + "Currently you work as: " + green + g_cInfo[iID]);
        sendPlayerMessage(iID, white + "Creator " + green + "Javierko " + white + "| Version: " + green + VERSION);
        sendPlayerMessage(iID, white + "There are " + green + serverGetOnlinePlayers() + white + " players online.");
        sendPlayerMessage(iID, red + "====================================");

        playerEnableMoney(iID, 1);
    }
}

//Death
function onPlayerIsKilled(iDeathID, iKillerID, cReason, iHitbox)
{
    if(iKillerID != iDeathID)
    {
		sendAllMessage(white + playerGetName(iDeathID) + green + " has been killed by " + white + playerGetName(iKillerID) + red + " [" + green + "Reason: " + cReason + white + "/" + green + "Body part: " + iHitbox + red + "]");
        playerSetMoney(iKillerID, playerGetMoney(iKillerID) + 250);
    } 
    else 
    {
		sendAllMessage(white + playerGetName(iDeathID) + green + " committed suicide.");
	}
}

//Client say
function onPlayerText(iID, cMessage)
{
	if(g_lAdmin[iID] == 1)
	{
        print("[Admin][" + playerGetName(iID) + "]: " + cMessage);	
        if(g_pPolicie[iID] == 1)
        {
            sendAllMessage(red + "[Admin] " + cyan + playerGetName(iID) + white + ": " + yellow + cMessage);
        }
        else if(g_pZachranar[iID] == 1)
        {
            sendAllMessage(red + "[Admin] " + yellow + playerGetName(iID) + white + ": " + yellow + cMessage);
        }
        else if(g_pTaxikar[iID] == 1)
        {
            sendAllMessage(red + "[Admin] " + orange + playerGetName(iID) + white + ": " + yellow + cMessage);
        }
        else if(g_pZachranar[iID] == 0 || g_pPolicie[iID] == 0 || g_pTaxikar[iID] == 0)
        {
            sendAllMessage(red + "[Admin] " + white + playerGetName(iID) + white + ": " + yellow + cMessage);
        }
	}
	else
	{
        print("[" + playerGetName(iID) + "]: " + cMessage);	
        if(g_pPolicie[iID] == 1)
        {
            sendAllMessage(cyan + playerGetName(iID) + white + ": " + cMessage);
        }
        else if(g_pZachranar[iID] == 1)
        {
            sendAllMessage(yellow + playerGetName(iID) + white + ": " + cMessage);
        }
        else if(g_pTaxikar[iID] == 1)
        {
            sendAllMessage(orange + playerGetName(iID) + white + ": " + cMessage);
        }
        else if(g_pZachranar[iID] == 0 || g_pPolicie[iID] == 0 || g_pTaxikar[iID] == 0)
        {
            sendAllMessage(white + playerGetName(iID) + ": " + cMessage);
        }
	}

	return false;
}

//Tick
function onServerTickSecond(ticks)
{
    g_iSeconds++;
    g_iSecondsC++;

    if(g_iSeconds >= g_lAdsInterval)
    {
        g_iSeconds = 0;
        sendAllMessage(g_lAdsPrefix + g_lAds[random(0, g_lAds.len())]);
	}

	return;

	if(g_iSecondsC >= g_lCarSweep)
    {
        g_iSecondsC = 0;
        for(local i = 0; i < g_iCarCount; i++)
        {
            if(playerInVehicleID(i) == -1)
            {
                vehicleDelete(i);
                g_iCarCount--;
            }
        }
	}
}

//Enter
function onPlayerEnterVehicle(iID, iVehID, iSeatID)
{
	playerToggleCityMusic(iID, g_lRadio[iID]);
}

//Exit
function onPlayerExitVehicle(iID, iVehID)
{
	playerToggleCityMusic(iID, 0);
}

/*
    > Commands <
*/

function onPlayerCommand(iID, cMessage, cParams)
{
    print(playerGetName(iID) + "["+ iID + "] used command: /" + cMessage);

    switch(cMessage)
    {
        case "help":
        {
            switch(cParams)
            {
                case "1":
                {
                    defaultHelp(iID);

                    break;
                }

                case "2":
                {
                    page2Help(iID);

                    break;
                }

                default:
                {
                    defaultHelp(iID);

                    break;
                }
            }
            break;
        }

        case "police":
        {
            if(g_pPolicie[iID] != 1)
            {
                if(g_pZachranar[iID] == 1 || g_pTaxikar[iID] == 1)
                {
                    if(g_pZachranar[iID] == 1)
                    {
                        g_pZachranar[iID] = 0;
                        iniRemoveFile("players/players_job_" + playerGetName(iID) + ".txt");
                    }
                    else if(g_pTaxikar[iID] == 1)
                    {
                        g_pTaxikar[iID] = 0;
                        iniRemoveFile("players/players_job_" + playerGetName(iID) + ".txt");
                    }

                    g_pPolicie[iID] = 1;
                    iniSetParam("players/players_job_" + playerGetName(iID) + ".txt", "job", "policie");

                    sendPlayerMessage(iID, "Now you're" + cyan + " police");
                }
                else
                {
                    g_pPolicie[iID] = 1;
                    iniSetParam("players/players_job_" + playerGetName(iID) + ".txt", "job", "policie");

                    sendPlayerMessage(iID, "Now you're" + cyan + " police");
                }
            }
            else
            {
                sendPlayerMessage(iID, white + "You're " + cyan + "police" + white + " man!");
            }

            break;
        }

        case "doctor":
        {
            if(g_pZachranar[iID] != 1)
            {
                if(g_pPolicie[iID] == 1 || g_pTaxikar[iID] == 1)
                {
                    if(g_pPolicie[iID] == 1)
                    {
                        g_pPolicie[iID] = 0;
                        iniRemoveFile("players/players_job_" + playerGetName(iID) + ".txt");
                    }
                    else if(g_pTaxikar[iID] == 1)
                    {
                        g_pTaxikar[iID] = 0;
                        iniRemoveFile("players/players_job_" + playerGetName(iID) + ".txt");
                    }

                    g_pZachranar[iID] = 1;
                    iniSetParam("players/players_job_" + playerGetName(iID) + ".txt", "job", "zachranar");

                    sendPlayerMessage(iID, "Now you're" + red + " doctor");
                }
                else
                {
                    g_pZachranar[iID] = 1;
                    iniSetParam("players/players_job_" + playerGetName(iID) + ".txt", "job", "zachranar");

                    sendPlayerMessage(iID, white + "Now you're" + red + " doctor");
                }
            }
            else
            {
                sendPlayerMessage(iID, "You're " + yellow + "doctor" + white + "!");
            }

            break;
        }

        case "taxidriver":
        {
            if(g_pTaxikar[iID] != 1)
            {
                if(g_pPolicie[iID] == 1 || g_pZachranar[iID] == 1)
                {
                    if(g_pPolicie[iID] == 1)
                    {
                        g_pPolicie[iID] = 0;
                        iniRemoveFile("players/players_job_" + playerGetName(iID) + ".txt");
                    }
                    else if(g_pZachranar[iID] == 1)
                    {
                        g_pZachranar[iID] = 1;
                        iniRemoveFile("players/players_job_" + playerGetName(iID) + ".txt");
                    }
                    
                    g_pTaxikar[iID] = 1;
                    iniSetParam("players/players_job_" + playerGetName(iID) + ".txt", "job", "taxikar");

                    sendPlayerMessage(iID, white + "Now you're" + orange + " taxi driver");
                }
                else
                {
                    g_pTaxikar[iID] = 1;
                    iniSetParam("players/players_job_" + playerGetName(iID) + ".txt", "job", "taxikar");

                    sendPlayerMessage(iID, white + "Now you're" + orange + " taxi driver");
                }
            }

            break;
        }

        case "kontrola":
        {
            if(g_pPolicie[iID] == 1)
            {
                local args = split(cParams," ");

                if(args.len() > 0)
                {
                    if(args[0].tointeger() != iID)
                    {
                        if(playerGetName(args[0].tointeger()))
                        {
                            if(playerInVehicleID(args[0].tointeger()))
                            {
                                sendPlayerMessage(args[0], red + "STOP THE CAR, RIGHT NOW!" + playerGetName(iID) + " stopped you!");
                                if(playerInVehicleID(iID) != -1)
                                {
                                    local l_carID = playerInVehicleID(iID);
                                    vehicleToggleSiren(l_carID, !vehicleGetSirenState(l_carID));

                                    break;
                                }
                            }
                        }
                        else
                        {
                            sendPlayerMessage(iID, red + "Player with id (" + args[0] + ") is not on server");
                        }
                    }
                    else
                    {
                        sendPlayerMessage(iID, red + "You can't do this on yourself...");
                    }
                }
                else
                {
                    sendPlayerMessage(iID, red + "Wrong syntax, use: /kontrola [ID]");
                }
            }
            else
            {
                sendPlayerMessage(iID, red + "You must be police man for this command!");
            }

            break;
        }

        case "heal":
        {
            if(g_pZachranar[iID] == 1)
            {
                local args = split(cParams," ");

                if(args.len() > 0)
                {
                    if(args[0].tointeger() != iID)
                    {
                        if(playerGetName(args[0].tointeger()))
                        {
                            local iCurr = playerGetPosition(iID);
                            local iTarget = playerGetPosition(args[0].tointeger());
                            local fDistance = getDistance(iCurr[0], iTarget[0], iCurr[1], iTarget[1]);

                            if(fDistance <= 5.0)
                            {
                                playerSetHealth(args[0].tointeger(), 200.0);

                                sendPlayerMessage(args[0].tointeger(), "You have been healed by " + playerGetName(iID));
                                sendPlayerMessage(iID, "You healed " + playerGetName(args[0].tointeger()));
                            }
                            else
                            {
                                sendPlayerMessage(iID, "You're too far.");
                            }
                        }
                        else
                        {
                            sendPlayerMessage(iID, red + "Player with id (" + args[0] + ") is not on server");
                        }
                    }
                    else
                    {
                        sendPlayerMessage(iID, red + "You can't do this on yourself...");
                    }
                }
                else
                {
                    sendPlayerMessage(iID, red + "Wrong syntax, use: /heal [ID]");
                }
            }
            else
            {
                sendPlayerMessage(iID, red + "You must be doctor for this command!");
            }

            break;
        }

        case "sirena":
		{
			if(playerInVehicleID(iID) != -1)
			{
				local l_carID = playerInVehicleID(iID);
				vehicleToggleSiren(l_carID, !vehicleGetSirenState(l_carID));
                sendPlayerMessage(iID, white + "You toggled" + green + " sirena" + white + ".");

                break;
			}
		}

        case "bum":
		{
			if(playerInVehicleID(iID) != -1)
			{
				sendPlayerMessage(iID, white + "You succesfully exploded your car.");
				vehicleExplode(playerInVehicleID(iID));

                break;
			}

            break;
		}

        case "lock":
		{
			playerLockControls(iID, !playerIsLocked(iID));

            break;
		}

        case "radio":
		{
            if(g_lRadio[iID] == 0)
            {
				g_lRadio[iID] = 1;
				sendPlayerMessage(iID, green + "Radio turned on.");
			}
            else
            {
				g_lRadio[iID] = 0;
				sendPlayerMessage(iID, green + "Radio turned off.");
			}

			if(playerInVehicleID(iID) != -1)
            {
                playerToggleCityMusic(iID, g_lRadio[iID]);
            }

			break;
        }

        case "ahelp":
        {
            pageAHelp(iID);

            break;
        }

        case "me":
        {
            sendAllMessage("#663399*" + playerGetName(iID) + " " + cParams);

            break;
        }

        case "neo":
		{
            if(g_lAdmin[iID] == 1)
            {
                playerChangeSkin(iID, 303);
                sendPlayerMessage(iID,"Welcome back, agent " + playerGetName(iID) + "!");
                playerAddWeapon(iID, 12, 1000, 1000);

                break;
            }
            else
            {
                sendPlayerMessage(iID, red + "You have no permission for that!");

                break;
            }
        }

        case "random":
		{
            sendPlayerMessage(iID, "Random: " + rand()%cParams.tointeger());

			break;
        }

        case "admin":
		{
            if(g_lRcon == cParams)
			{
				g_lAdmin[iID] = 1;
				print("Player [" + playerGetName(iID) + "] has successfully login as administrator");
				sendPlayerMessage(iID, white + "You are logged as Admin!");
				sendPlayerMessage(iID, white + "Type " + green + "/ahelp" + white + " for admin commands.");
			}
			else
			{
                sendPlayerMessage(iID, red + "Wrong rcon password!");
            }

			break;
        }

        case "kick":
		{
            local args = split(cParams," ");

			if(g_lAdmin[iID] == 1)
			{
                if(playerGetName(args[0].tointeger()))
                {
                    sendPlayerMessage(iID, red + playerNameIP(args[0].tointeger()) + green + " was kicked for " + white + args[1]);
                    kickPlayer(args[0].tointeger());
                }
                else
                {
                    sendPlayerMessage(iID, red + "Player with id (" + args[0] + ") is not on server");
                }
			}
			else
			{
			    sendPlayerMessage(iID, red + "You have no permission for that!");
			}

			break;
        }

        case "getip":
		{
            if(g_lAdmin[iID] == 1)
            {
                local args = split(cParams," ");

                if(playerGetName(args[0].tointeger()))
                {
				    sendPlayerMessage(iID, green + "IP Address of player " + white + playerGetName(cParams.tointeger()) + green + " is " + white + playerGetIP(cParams.tointeger()));
                }
                else
                {
                    sendPlayerMessage(iID, red + "Player with id (" + args[0] + ") is not on server");
                }
            } 
			else 
            {
				sendPlayerMessage(iID, red + "You have no permission for that!");
			}

			break;
        }

        case "skin":
		{
            local args = split(cParams," ");

            if(args.len() > 0)
            {
                if (cParams.tointeger() > 302)
                {
                    sendPlayerMessage(iID, red + "Wrong skin ID!");
                }
                else 
                {
                    if(cParams.tointeger() == 34 || cParams.tointeger() == 35 || cParams.tointeger() == 36 || cParams.tointeger() == 127 || cParams.tointeger() == 128 ||
                    cParams.tointeger() == 240 || cParams.tointeger() == 241 || cParams.tointeger() == 242 || cParams.tointeger() == 243 || cParams.tointeger() == 244 ||
                    cParams.tointeger() == 245 || cParams.tointeger() == 246)
                    {
                        if(g_pPolicie[iID] == 1 || g_lAdmin[iID] == 1)
                        {
                            playerChangeSkin(iID, cParams.tointeger());

                            sendPlayerMessage(iID, "Skin has been changed.");
                        }
                        else
                        {
                            sendPlayerMessage(iID, red + "You must be police man!");
                        }
                    }
                    else
                    {
                        playerChangeSkin(iID, cParams.tointeger());

                        sendPlayerMessage(iID, "Skin has been changed.");
                    }
                }
            }
            else
            {
                sendPlayerMessage(iID, red + "Wrong syntax! /skin [SkinID]");
            }

			break;
        }

		case "kill":
		{
            playerSetHealth(iID, 0.0);

			break;
        }

		case "a":
		{
            playerPlayAnim(iID, cParams);

			break;
        }

		case "s":
		{
            allPlaySound("sounds\\" + cParams + ".wav");

			break;
        }

		case "as":
		{
            if(g_lAdmin[iID] == 1)
            {
				allPlaySound("sounds\\" + cParams);
            }
			else 
            {
				sendPlayerMessage(iID, red + "You have no permission for that!");
            }

			break;
        }

        case "weapon":
		{
			local args = split(cParams," ");
			local wepID = 0;
			local ammo = 1;
			local ammo2 = 0;

			if(args.len() > 0)
			{
				wepID = args[0].tointeger();
				if(args.len() > 1)
				{
					ammo = args[1].tointeger();
					if(args.len() > 2){
					ammo2 = args[2].tointeger();}
				}
                playerAddWeapon(iID, wepID, ammo, ammo2);
                sendPlayerMessage(iID, "Successfully added weapon!");
			}
			else 
            {
				sendPlayerMessage(iID, red + "Wrong syntax! /weapon [WeaponID] [PrimaryAmmo] [SecondaryAmmo]");
			}

			break;
        }

        case "suicide":
		{
			break;
        }

        case "setpos":
		{
            if(g_lAdmin[iID] == 1)
			{
                local xyz = split(cParams," ");
                playerSetPosition(iID, xyz[0].tointeger(), xyz[1].tointeger(), xyz[2].tointeger());
                
                break;
            }
            else
            {
                sendPlayerMessage(iID, red + "You have no permission for that!");

                break;
            }
        }

        case "mov":
		{
            if(g_lAdmin[iID] == 1)
			{
                local args = split(cParams," ");
                local oldpos = playerGetPosition(iID);

                if(args[0] == "x")
                {
                    playerSetPosition(iID, oldpos[0] + args[1].tointeger(), oldpos[1], oldpos[2]);
                }
                else if(args[0] == "y")
                {
                    playerSetPosition(iID, oldpos[0], oldpos[1] + args[1].tointeger(),oldpos[2]);
                }
                else if(args[0] == "z")
                {
                    playerSetPosition(iID, oldpos[0], oldpos[1], oldpos[2] + args[1].tointeger());
                }

                break;
            }
        }

        case "car":
		{
			local pos = playerGetPosition(iID);
            local args = split(cParams," ");

            if(args.len() > 0)
            {
                if (args[0].tointeger() > 169)
                {
                    sendPlayerMessage(iID, red + "Wrong car ID!");
                }
                else
                {
                    if(g_iCarCount > 6)
                    {
                        sendPlayerMessage(iID, red + "Car capacity has been reached, grab some car on street!"); 
                        
                        return;
                    }
      
                    if(cParams.tointeger() == 111 || cParams.tointeger() == 115 || cParams.tointeger() == 119 || cParams.tointeger() == 123)
                    {
                        if(g_pPolicie[iID] == 1 || g_lAdmin[iID] == 1)
                        {
                            g_iCarCount++;

                            vehicleSpawn(args[0].tointeger(), pos[0] + 2, pos[1], pos[2], 1.0, 0.0, 0.0);

                            sendPlayerMessage(iID, "You succesfully spawned" + red + " a car" + white + ".");
                        }
                        else
                        {
                            sendPlayerMessage(iID, red + "This command can use only police man!");
                        }
                    }
                    else if(cParams.tointeger() == 166 || cParams.tointeger() == 163 || cParams.tointeger() == 161 || cParams.tointeger() == 154 ||
                    cParams.tointeger() == 153 || cParams.tointeger() == 96)
                    {
                        if(g_pTaxikar[iID] == 1 || g_lAdmin[iID] == 1)
                        {
                            g_iCarCount++;

                            vehicleSpawn(args[0].tointeger(), pos[0] + 2, pos[1], pos[2], 1.0, 0.0, 0.0);

                            sendPlayerMessage(iID, "You succesfully spawned" + red + " a car" + white + ".");
                        }
                        else
                        {
                            sendPlayerMessage(iID, red + "This command can use only taxi driver!");
                        }
                    }
                    else if(cParams.tointeger() == 144)
                    {
                        if(g_pZachranar[iID] == 1 || g_lAdmin[iID] == 1)
                        {
                            g_iCarCount++;

                            vehicleSpawn(args[0].tointeger(), pos[0] + 2, pos[1], pos[2], 1.0, 0.0, 0.0);

                            sendPlayerMessage(iID, "You succesfully spawned" + red + " a car" + white + ".");
                        }
                        else
                        {
                            sendPlayerMessage(iID, red + "This command can use only doctor!");
                        }
                    }
                    else
                    {
                        g_iCarCount++;

                        vehicleSpawn(args[0].tointeger(), pos[0] + 2, pos[1], pos[2], 1.0, 0.0, 0.0);

                        sendPlayerMessage(iID, "You succesfully spawned" + red + " a car" + white + ".");
                    }
                }

                g_lCars[iID] = g_iCarCount - 1;
            }
            else
            {
                sendPlayerMessage(iID, red + "Wrong syntax! /car [CarID]");
            }

			break;
        }

        case "carjob":
        {
            local pos = playerGetPosition(iID);

            if(g_iCarCount > 64)
            {
                sendPlayerMessage(iID, red + "Car capacity has been reached, grab some car on street!"); 
                        
                return;
            }
            
            if(g_pPolicie[iID] == 1 || g_lAdmin[iID] == 1)
            {
                g_iCarCount++;

                vehicleSpawn(g_lPoliceCars[rand()%g_lPoliceCars.len()], pos[0] + 2, pos[1], pos[2], 1.0, 0.0, 0.0);

                sendPlayerMessage(iID, "You succesfully spawned" + red + " a job car" + white + ".");
            }
            else if(g_pZachranar[iID] == 1 || g_lAdmin[iID] == 1)
            {
                g_iCarCount++;

                vehicleSpawn(144, pos[0] + 2, pos[1], pos[2], 1.0, 0.0, 0.0);

                sendPlayerMessage(iID, "You succesfully spawned" + red + " a job car" + white + ".");
            }
            else if(g_pTaxikar[iID] == 1 || g_lAdmin[iID] == 1)
            {
                g_iCarCount++;

                vehicleSpawn(g_lTaxiCars[rand()%g_lTaxiCars.len()], pos[0] + 2, pos[1], pos[2], 1.0, 0.0, 0.0);

                sendPlayerMessage(iID, "You succesfully spawned" + red + " a job car" + white + ".");
            }
            else if(g_pTaxikar[iID] == 0 || g_pZachranar[iID] == 0 || g_pPolicie[iID] == 0)
            {
                sendPlayerMessage(iID, red + "You need to have job to spawn a car job!");
            }

            break;
        }

        case "players":
        {
            sendPlayerMessage(iID, white + "Currently is online " + serverGetOnlinePlayers() + " players.");
            for(local i = 0; i < 100; i++)
            {
                if(playerGetName(i))
                {
                    sendPlayerMessage(iID, red + "Name: " + white + playerGetName(i) + " |" + red + " HP: " + white + playerGetHealth(i) + " | " + red + "SkinID: " + white + playerGetSkinID(i) + " |" + red + " Money: " + white + playerGetMoney(i));
                }
            }

            break;
        }

        case "carfuck": 
		{
			for(local i = 0; i < 100; i++)
			{
				if(vehicleExists(i))
				{
					if(vehicleGetDriverID(i) == -1)
					{
						vehicleDelete(i);
						g_iCarCount--;

                        sendPlayerMessage(i, "You succesfully deleted cars.");
					}
				}	
			}
		}

        case "delcars": 
		{
            if(g_lAdmin[iID] == 1) 
			{
				for(local i = 0; i < g_iCarCount; i++)
				{
					vehicleDelete(i);
					g_iCarCount = 0;
				}
			}
			else
			{
			    sendPlayerMessage(iID, red + "You have no permission for that!");
			}

			break;
        }

        case "info":
		{
            sendPlayerMessage(iID, white + "LH:" + red + "MP" + white + " Reborn Testing server");

			break;
        }

        case "tp":
		{
            if(g_lAdmin[iID] == 1)
            {
                local iPos = playerGetPosition(cParams.tointeger());
			    playerSetPosition(iID, iPos[0], iPos[1], iPos[2]);
            }
            else
            {
                sendPlayerMessage(iID, red + "You have no permission for that!");
            }

			break;
        }

		case "tphere":
        {
            if(g_lAdmin[iID] == 1)
            {
                local iPos = playerGetPosition(iID);
			    playerSetPosition(cParams.tointeger(), iPos[0], iPos[1], iPos[2]);
            }
            else
            {
                sendPlayerMessage(iID, red + "You have no permission for that!");
            }

            break;
        }

        case "getposition":
        {
            if(g_lAdmin[iID] == 1)
            {
                local iPos = playerGetPosition(iID);
                sendPlayerMessage(iID, white + "X: " + iPos[0] + " Y: " + iPos[1] + " Z: " + iPos[2]);
            }
            else
            {
                sendPlayerMessage(iID, red + "You have no permission for that!");
            }

            break;
        }

        case "money":
        {
            sendPlayerMessage(iID, white + "You have: " + green + playerGetMoney(iID) "$");
        }

        case "exit":    break;
		case "quit":    break;

		case "version":
        {
            sendPlayerMessage(iID, white + "Current version of LH:MP Reborn Roleplay is " + green + VERSION);

            break;
        }

        case "ver":
        {
            sendPlayerMessage(iID, white + "Current version of LH:MP Reborn Roleplay is " + green + VERSION);

            break;
        }

		case "debug":   break;
		case "clearchat":   break;
		case "cc":  break;
        case "turbo":   break;

        case "jobs":
        {
            printJobs(iID);

            break;
        }

        default:
        {
            sendPlayerMessage(iID, red + "Command not found!");

            break;
        }
    }
}

/* 
    > "Booleans" <
*/

function getDistance(x1, x2, y1, y2)
{
	return (sqrt( ( (x2-x1) * (x2-x1) ) + ( (y2-y1) * (y2-y1) ) ) );
}

function isInArea(posx, posy, x1, x2, y1, y2)
{
	if((posx >= x1 && posx <= x2) && (posy >= y1 && posy <= y2))
    {
		return 1;
	} 
    else 
    {
		return 0;
	}
}

function random(min,max)
{
	srand(time());
	return ((rand() % (max-min)) + min);
}

function defaultHelp(iID)
{
	sendPlayerMessage(iID, green + "===================[HELP]===================");
	sendPlayerMessage(iID, white + "/skin [skinid] " + green + "- " + white + "Change your skin");
	sendPlayerMessage(iID, white + "/weapon [id] [clip] [ammo] " + green + "- " + white + "Add weapon");
	sendPlayerMessage(iID, white + "/car [id] " + green + "- " + white + "Spawn a car");
	sendPlayerMessage(iID, white + "/t [message] " + green + "- " + white + "Post message!");
	sendPlayerMessage(iID, white + "/chat " + green + "- " + white + "show info about chat system.");
	sendPlayerMessage(iID, white + "Type " + green + "/help 2 " + white + "for next page.");
	sendPlayerMessage(iID, green + "============================================");
}

function page2Help(iID)
{
	sendPlayerMessage(iID, green + "===================[HELP 2]===================");
	sendPlayerMessage(iID, white + "/anim [id] " + green + "- " + white + "Let's do some animation :)");
	sendPlayerMessage(iID, white + "/setlines [amount] " + green + "- " + white + "Sets the amount of chat lines (starts from 6)");
	sendPlayerMessage(iID, white + "/suicide " + green + "- " + white + "Kill yourself.");
	sendPlayerMessage(iID, white + "/info " + green + "- "+white + "Shows you info about server");
	sendPlayerMessage(iID, white + "/radio " + green + "- " + white + "Toggles car radio");
	sendPlayerMessage(iID, white + "/quit " + green + "- " + white + "quit's the game");
	sendPlayerMessage(iID, green + "============================================");
}

function pageAHelp(iID)
{
    if(g_lAdmin[iID] == 1)
    {
        sendPlayerMessage(iID, green + "===================[ADMIN HELP]===================");
        sendPlayerMessage(iID, "/delcars " + green + "- " + white + "Removing all cars from map");
        sendPlayerMessage(iID, "/kick [id] " + green + "- " + white + "Kicking player by ID");
        sendPlayerMessage(iID, "/getip [id] " + green + "- " + white + "Get player IP by ID");
        sendPlayerMessage(iID, green + "==================================================");
    }
    else
    {
        sendPlayerMessage(iID, red + "You have no permission for that!");
    }
}

function printJobs(iID)
{
    sendPlayerMessage(iID, green + "===================[JOBS]===================");
	sendPlayerMessage(iID, white + "/" + cyan + "police " + green + "- " + white + "Be a hero, join to police!");
	sendPlayerMessage(iID, white + "/" + yellow + "doctor " + green + "- " + white + "Healing is your job?");
	sendPlayerMessage(iID, white + "/" + orange + "taxidriver " + green + "- " + white + "'Tak te mame parchante, pan Morello je pekne nasranej, ...'");
	sendPlayerMessage(iID, green + "============================================");
}

function cmp(a,b)
{
	if(a > b) return 1
	else if(a < b) return -1
	return 0;
}