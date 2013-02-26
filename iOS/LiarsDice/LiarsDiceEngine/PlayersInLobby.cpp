//
//  PlayersInLobby.cpp
//  LiarsDiceClient
//
//  Created by David Raleigh on 9/22/12.
//  Copyright (c) 2012 David Raleigh. All rights reserved.
//

#include "PlayersInLobby.h"
#include "MathUtilities.h"

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
    if (m_availablePlayers.size() > 0)
        return false;
    
    // assumes at object allAvailablePlayers
    m_playerUID = devicePlayerUID;
    m_latitude = deviceLatitude;
    m_longitude = deviceLongitude;
    
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
        double latitude = jsonPlayer.get("latitude", defaultValue).asDouble();
        double longitude = jsonPlayer.get("longitude", defaultValue).asDouble();
        playerDetails.distance = MathUtilities::HaversinceDistance(deviceLongitude, deviceLatitude, longitude, latitude, radius);
        if(!_IsValidPlayer(playerDetails))
            return false;
        m_availablePlayers.push_back(playerDetails);
    }
    
    sort(m_availablePlayers.begin(), m_availablePlayers.end(), player_comparator());
    return true;
}

bool PlayersInLobby::ContainsPlayer(unsigned int playerUID)
{
    std::vector<player_t>::iterator iter;
    for (iter = m_availablePlayers.begin(); iter != m_availablePlayers.end(); iter++)
        if ((*iter).playerUID == playerUID)
            return true;
    
    return false;
}

bool PlayersInLobby::DeletePlayerAtUID(unsigned int playerUID)
{
    if (!ContainsPlayer(playerUID))
        return false;
    // TODO there is some check for whether you properly erased that I'm missing
    m_availablePlayers.erase(_GetPlayerDetailsFromUID(playerUID));
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
    std::vector<PlayersInLobby::player_t>::iterator iter;
    
    for (iter = m_availablePlayers.begin(); iter != m_availablePlayers.end(); iter++)
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
    std::vector<PlayersInLobby::player_t>::iterator iter = _GetPlayerDetailsFromUID(playerUID);
    if (iter != m_availablePlayers.end())
        playerDetails = *iter;
    return playerDetails;
}

std::vector<PlayersInLobby::player_t>::iterator PlayersInLobby::_GetPlayerDetailsFromUID(unsigned int playerUID)
{
    std::vector<PlayersInLobby::player_t>::iterator iter;
    for (iter = m_availablePlayers.begin(); iter != m_availablePlayers.end(); iter++)
        if ((*iter).playerUID == playerUID)
            return iter;
    return iter;
}

PlayersInLobby::player_t PlayersInLobby::GetPlayerAtPosition(int position)
{
    return GetPlayerFromUID(GetPlayerUID(position));
}

int PlayersInLobby::GetPlayerPosition(unsigned int playerUID)
{
    if (m_availablePlayers.size() == 0 ||
        !ContainsPlayer(playerUID))
        return -1;
    int position = 0;
    std::vector<PlayersInLobby::player_t>::iterator iter;
    for (iter = m_availablePlayers.begin(); iter != m_availablePlayers.end(); iter++, position++)
        if ((*iter).playerUID == playerUID)
            break;
    return position;
}

unsigned int PlayersInLobby::GetPlayerUID(int position)
{
    if (m_availablePlayers.size() == 0 || position > m_availablePlayers.size())
        return 0;
    return m_availablePlayers[position].playerUID;
}

bool PlayersInLobby::InsertPlayer(PlayersInLobby::player_t playerDetails)
{
    if (m_playerUID == 0 ||
        ContainsPlayer(playerDetails.playerUID) ||
        !_IsValidPlayer(playerDetails))
        return false;
    
    m_availablePlayers.push_back(playerDetails);
    sort(m_availablePlayers.begin(), m_availablePlayers.end(), player_comparator());
    return true;
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
                break;
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
