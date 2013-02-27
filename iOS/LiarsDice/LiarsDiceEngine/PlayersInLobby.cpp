//
//  PlayersInLobby.cpp
//  LiarsDiceClient
//
//  Created by David Raleigh on 9/22/12.
//  Copyright (c) 2012 David Raleigh. All rights reserved.
//

#include "PlayersInLobby.h"
#include "Utilities.h"

// TEMP
#include "PseudoRandom.h"
// TEMP

#include "json/json.h"

// TODO put in a try catch and return false if parsing fails
bool PlayersInLobby::InitializePlayers(Json::Value &allAvailablePlayersObj, unsigned int devicePlayerUID, double deviceLatitude, double deviceLongitude)
{
    // if inputs are crappy
    if (!allAvailablePlayersObj ||
        devicePlayerUID == 0 ||
        ::abs(deviceLatitude) > 90 ||
        ::abs(deviceLongitude) > 180)
        return false;
    
    // if the PlayersLobby as already been initialized
    if (m_displayedPlayers.size() + m_hiddenPlayers.size() > 0)
        return false;
    
    // assumes at object allAvailablePlayers
    m_playerUID = devicePlayerUID;
    m_latitude = deviceLatitude;
    m_longitude = deviceLongitude;
    m_sortType = PlayersInLobby::Distance;
    
    Json::Value defaultValue;
    
    double radius = 6371000;
    
    // TODO, replace string with Macro
    Json::Value timeRange = allAvailablePlayersObj.get("posixTimeWindow", defaultValue);
    int firstIndex = 0;
    m_unixTimeStampStart = timeRange[firstIndex].asUInt();
    m_unixTimeStampEnd = timeRange.get(1, defaultValue).asUInt();
    
    Json::Value jsonPlayerArray = allAvailablePlayersObj.get("newlyAvailablePlayers", defaultValue);
    for (int i = 0; i < jsonPlayerArray.size(); i++)
    {
        Json::Value jsonPlayer = jsonPlayerArray.get(i, defaultValue);
        player_t playerDetails;
        playerDetails.playerUID = jsonPlayer.get("playerUID", defaultValue).asUInt();
        playerDetails.playerName.append(jsonPlayer.get("playerName", defaultValue).asString());
        playerDetails.groupUID = jsonPlayer.get("groupUID", defaultValue).asUInt();
        playerDetails.bIsGroupLeader = jsonPlayer.get("isGroupLeader", defaultValue).asBool();
        playerDetails.previousIndex = i;
        double latitude = jsonPlayer.get("latitude", defaultValue).asDouble();
        double longitude = jsonPlayer.get("longitude", defaultValue).asDouble();
        playerDetails.distance = Utilities::HaversinceDistance(deviceLongitude, deviceLatitude, longitude, latitude, radius);
        if(!_IsValidPlayer(playerDetails))
            return false;
        //m_allAvailablePlayers[playerDetails.playerUID] = playerDetails;
        m_displayedPlayers.push_back(playerDetails);
    }
    
    m_displayedPlayers.sort(player_distance_comparator());
//    sort(m_displayedPlayers.begin(), m_displayedPlayers.end(), player_distance_comparator());
    return true;
}

bool PlayersInLobby::ContainsPlayer(unsigned int playerUID)
{
    std::list<player_t>::iterator iter;
    for (iter = m_displayedPlayers.begin(); iter != m_displayedPlayers.end(); iter++)
        if ((*iter).playerUID == playerUID)
            return true;
    
    return false;
}

bool PlayersInLobby::DeletePlayerAtUID(unsigned int playerUID)
{
    if (!ContainsPlayer(playerUID))
        return false;
    // TODO there is some check for whether you properly erased that I'm missing
    m_displayedPlayers.erase(_GetPlayerDetailsFromUID(playerUID));
    return true;
}

bool PlayersInLobby::DeletePlayerAtPosition(int position)
{
    unsigned int playerUID = GetPlayerUID(position);
    if (playerUID == 0)
        return false;

    return DeletePlayerAtUID(playerUID);
}

PlayersInLobby::player_t PlayersInLobby::GetGroupLeader(unsigned int groupUID)
{
    PlayersInLobby::player_t playerDetails;
    std::list<PlayersInLobby::player_t>::iterator iter;
    
    for (iter = m_displayedPlayers.begin(); iter != m_displayedPlayers.end(); iter++)
    {
        if ((*iter).groupUID == groupUID && (*iter).bIsGroupLeader)
        {
            playerDetails = *iter;
            break;
        }
    }
    
    return playerDetails;
}

PlayersInLobby::player_t PlayersInLobby::GetPlayerFromUID(unsigned int playerUID)
{
    PlayersInLobby::player_t playerDetails;
    std::list<PlayersInLobby::player_t>::iterator iter = _GetPlayerDetailsFromUID(playerUID);
    if (iter != m_displayedPlayers.end())
        playerDetails = *iter;
    return playerDetails;
}

std::list<PlayersInLobby::player_t>::iterator PlayersInLobby::_GetPlayerDetailsFromUID(unsigned int playerUID)
{
    std::list<PlayersInLobby::player_t>::iterator iter;
    for (iter = m_displayedPlayers.begin(); iter != m_displayedPlayers.end(); iter++)
        if ((*iter).playerUID == playerUID)
            return iter;
    return iter;
}

PlayersInLobby::player_t PlayersInLobby::GetPlayerAtPosition(int displayIndex)
{
    return GetPlayerFromUID(GetPlayerUID(displayIndex));
}

int PlayersInLobby::GetPlayerPosition(unsigned int playerUID)
{
    if (m_displayedPlayers.size() == 0 ||
        !ContainsPlayer(playerUID))
        return -1;
    int position = 0;
    std::list<PlayersInLobby::player_t>::iterator iter;
    for (iter = m_displayedPlayers.begin(); iter != m_displayedPlayers.end(); iter++, position++)
        if ((*iter).playerUID == playerUID)
            break;
    return position;
}

unsigned int PlayersInLobby::GetPlayerUID(int displayIndex)
{
    if (m_displayedPlayers.size() == 0 || displayIndex > m_displayedPlayers.size())
        return 0;
    int position = 0;
    std::list<PlayersInLobby::player_t>::iterator iter;
    for (iter = m_displayedPlayers.begin(); iter != m_displayedPlayers.end(); iter++, position++)
    {
        if (position == displayIndex)
        {
            return (*iter).playerUID;
            break;
        }
    }
    
    return 0;
}

void PlayersInLobby::HidePlayerAtPosition(int displayIndex)
{
    int position = 0;
    std::list<PlayersInLobby::player_t>::iterator iter;
    for (iter = m_displayedPlayers.begin(); iter != m_displayedPlayers.end(); iter++, position++)
    {
        if (position == displayIndex)
        {
            m_hiddenPlayers.emplace_back((*iter));
            m_displayedPlayers.erase(iter);
            break;
        }
    }
}

bool PlayersInLobby::InsertPlayer(PlayersInLobby::player_t playerDetails)
{
    if (m_playerUID == 0 ||
        ContainsPlayer(playerDetails.playerUID) ||
        !_IsValidPlayer(playerDetails))
        return false;
    
    m_displayedPlayers.push_back(playerDetails);
//    sort(m_displayedPlayers.begin(), m_displayedPlayers.end(), player_distance_comparator());
    m_displayedPlayers.sort(player_distance_comparator());

    return true;
}

bool PlayersInLobby::IsPlayerAvailable(int displayIndex)
{
    PlayersInLobby::AvailabilityType availability = GetPlayerAtPosition(displayIndex).availability;
    if (availability == PlayersInLobby::Offline || availability == PlayersInLobby::OnlineInGame)
        return false;
    return true;
}

Json::Value InvitePlayer(int displayIndex)
{
    Json::Value defaultVaue;
    
    // 
    
    return defaultVaue;
}

void PlayersInLobby::_GenerateLobbyPlayers(Json::Value &allAvailablePlayers)
{
    Json::Value arrayValues;
    std::shared_ptr<PseudoRandom> psuedo = std::make_shared<PseudoRandom>(1977);
    for (int i = 0; i < 10; i++)
    {
        Json::Value playerDetails;
        playerDetails["playerUID"] = i + 1000;
        playerDetails["groupUID"] = i + 1000;
        std::string name;
        switch (i) {
            case 0:
                playerDetails["playerName"] = "Greg";
                break;
            case 1:
                playerDetails["playerName"] = "Nick";
                break;
            case 2:
                playerDetails["playerName"] = "DJ";
                break;
            case 3:
                playerDetails["playerName"] = "Bida";
                break;
            case 4:
                playerDetails["playerName"] = "Brian Tayan";
                break;


            default:
                continue;
        }

        double decimalLatitude = (double)psuedo->GetRandomFromRange(10, 80);
        double decimalLongidtude = (double)psuedo->GetRandomFromRange(-100, 999);
        playerDetails["latitude"] = 30 + (decimalLatitude / 100);
        playerDetails["longitude"] = 30 + (decimalLongidtude / 1000);
        PseudoRandom::CoinSide coinFlip = psuedo->CoinToss();
        if (coinFlip == PseudoRandom::Heads)
            playerDetails["isGroupLeader"] = true;
        else
            playerDetails["isGroupLeader"] = false;
        
        arrayValues[i] = playerDetails;
    }
    
    allAvailablePlayers["newlyAvailablePlayers"] = arrayValues;
    Json::Value posixTimeWindow;
    int firstIndex = 0;
    posixTimeWindow[firstIndex] = 0;
    posixTimeWindow[1] = 1;
    
    allAvailablePlayers["posixTimeWindow"] = posixTimeWindow;

    Json::StyledWriter writer;
    std::string words = writer.write(allAvailablePlayers);
}

bool PlayersInLobby::_IsValidPlayer(PlayersInLobby::player_t playerDetails)
{
    if (playerDetails.playerUID == 0 ||
        playerDetails.distance < 0 ||
        playerDetails.groupUID == 0 ||
        playerDetails.playerName.size() == 0)
        return false;
    return true;
}
