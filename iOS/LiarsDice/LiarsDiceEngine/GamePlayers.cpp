//
//  GamePlayers.cpp
//  LiarsDiceClient
//
//  Created by David Raleigh on 9/20/12.
//  Copyright (c) 2012 David Raleigh. All rights reserved.
//

#include "GamePlayers.h"
#include <json/json.h>

int GamePlayers::PlayerCount()
{
    return (int)m_playersMap.size();
}

// TODO change this to use move?
bool GamePlayers::AddPlayers(const std::string jsonString)
{
    Json::Value root;
    Json::Reader reader;
    bool parsingSuccessful = reader.parse(jsonString, root);
    
    if (!parsingSuccessful)
        return false;
    
    Json::Value defaultValue;
    Json::Value arrayVal;
    arrayVal = root.get("players", defaultValue);// maybe players should be defined as an object
    
    if (!arrayVal.isArray())
        return false;
    
    for (int i = 0; i < arrayVal.size(); i++)
    {
        Json::Value playerObject = arrayVal.get(i, defaultValue);
        Player player(playerObject);
        m_playersMap[player.GetPlayerUID()] = player;
    }
    return true;
}

bool GamePlayers::AddPlayer(const std::string playerName, unsigned int playerUID, bool playerIsOnThisClient, bool isAI)
{
    if (playerUID == 0 ||                                                 // test that the UID isn't 0
        playerName.length() == 0 ||                                       // test that the playerName value isn't empty
        ContainsPlayer(playerName) ||                                           // test that the name hasn't been used
        ContainsPlayer(playerUID) ||                                            // test that the playerUID hasn't been used
        playerName.find_first_not_of(" \t\n\v\f\r") == std::string::npos) // test that the name isn't all white space
    {
        return false;
    }
    
    Player player(playerName, playerUID, playerIsOnThisClient, isAI);
    m_playersMap[playerUID] = player;
    m_playerSeatingMap[(int)m_playerSeatingMap.size()] = playerUID;
    return true;
}

bool GamePlayers::ContainsPlayer(const std::string playerName)
{
    std::map<unsigned int, Player>::iterator iter;
    for (iter = m_playersMap.begin(); iter != m_playersMap.end(); iter++)
        if (iter->second.GetPlayerName().compare(playerName) == 0)
            return true;
    return false;
}

// TODO inline this funciton
bool GamePlayers::ContainsPlayer(unsigned int playerUID)
{
    if (m_playersMap.count(playerUID) == 0)
        return false;
    return true;
}

void GamePlayers::DeleteAll()
{
    m_playersMap.clear();
    m_playerSeatingMap.clear();
}

bool GamePlayers::DeletePlayerAtUID(unsigned int playerUID)
{
    if (m_playersMap.count(playerUID) == 0)
        return false;
    
    int playerPosition = GetPlayerPosition(playerUID);
    m_playersMap.erase(playerUID);
    m_playerSeatingMap.erase(playerPosition);
    _ShiftPlayerOrder();

    return true;
}

bool GamePlayers::DeletePlayerAtPosition(int playerPosition)
{
    Player* player = GetPlayerAtPosition(playerPosition);
    if (!player)
        return false;
    return DeletePlayerAtUID(player->GetPlayerUID());
}

unsigned int GamePlayers::GetAvailableDummyUID()
{
    unsigned int availableUID = 1;
    while (m_playersMap.count(availableUID) > 0)
        availableUID++;
    
    return availableUID;
}

unsigned int GamePlayers::GetGroupLeaderUID()
{
    return m_groupLeaderUID;
}

Player* GamePlayers::GetPlayerAtPosition(int playerPosition)
{
    if (m_playerSeatingMap.count(playerPosition) == 0)
        return NULL;
    unsigned int playerUID = m_playerSeatingMap[playerPosition];
    std::map<unsigned int, Player>::iterator iter = m_playersMap.find(playerUID);
    return &iter->second;
}

Player* GamePlayers::GetPlayerAtUID(unsigned int playerUID)
{
    if (m_playersMap.count(playerUID) == 0)
        return NULL;
    return &m_playersMap[playerUID];
}

std::string GamePlayers::GetPlayerNameAtPosition(int position)
{
    if (position < 0 || position >= m_playerSeatingMap.size())
        return "";
    return GamePlayers::getInstance().GetPlayerAtPosition(position)->GetPlayerName();
}

std::string GamePlayers::GetPlayerNameAtUID(unsigned int playerUID)
{
    if (m_playersMap.count(playerUID) == 0)
        return "";
    return m_playersMap[playerUID].GetPlayerName();
}

int GamePlayers::GetPlayerPosition(unsigned int playerUID)
{
    std::map<int, unsigned int>::iterator iter;
    for (iter = m_playerSeatingMap.begin(); iter != m_playerSeatingMap.end(); iter++)
        if (iter->second == playerUID)
            return iter->first;
    return -1;
}

unsigned int GamePlayers::GetPlayerUID(int position)
{
    if (m_playerSeatingMap.count(position) == 0)
        return 0;
    return m_playerSeatingMap[position];
}

bool GamePlayers::MovePlayer(int sourcePosition, int destinationPosition)
{
    if (sourcePosition > m_playerSeatingMap.size() - 1 ||
        destinationPosition > m_playerSeatingMap.size() - 1 ||
        sourcePosition < 0 || destinationPosition < 0)
        return false;

    unsigned int sourceUID = m_playerSeatingMap[sourcePosition];
    // shift source down and displaced up
    if (sourcePosition > destinationPosition)
    {
        for (int position = sourcePosition; position > destinationPosition; position--)
            m_playerSeatingMap[position] = m_playerSeatingMap[position - 1];
    }
    // shift source up and displaced down
    else if (sourcePosition < destinationPosition)
    {
        for (int position = sourcePosition; position < destinationPosition; position++)
            m_playerSeatingMap[position] = m_playerSeatingMap[position + 1];
    }
    m_playerSeatingMap[destinationPosition] = sourceUID;
    return true;
}

void GamePlayers::SetGroupLeader(unsigned int playerUID)
{
    m_groupLeaderUID = playerUID;
}

bool GamePlayers::SwapPlayerOrder(int playerPosition1, int playerPosition2)
{
    if (playerPosition1 > m_playerSeatingMap.size() - 1 ||
        playerPosition2 > m_playerSeatingMap.size() - 1 ||
        playerPosition2 < 0 || playerPosition1 < 0)
        return false;
    
    if (playerPosition1 == playerPosition2)
        return true;
    
    unsigned int playerUID_1 = m_playerSeatingMap[playerPosition1];
    m_playerSeatingMap[playerPosition1] = m_playerSeatingMap[playerPosition2];
    m_playerSeatingMap[playerPosition2] = playerUID_1;
    return true;
}

void GamePlayers::_ShiftPlayerOrder()
{
    std::map<int, unsigned int> shiftedPlayerOrder;
    std::map<int, unsigned int>::iterator iter;
    int position = 0;
    // this relies on the idea that maps are sorted and the idea
    // that there are so few players that this isn't a performance hit
    for (iter = m_playerSeatingMap.begin(); iter != m_playerSeatingMap.end(); iter++)
        shiftedPlayerOrder[position++] = iter->second;
    m_playerSeatingMap = shiftedPlayerOrder;
}

//std::map<int, std::string> LiarsDiceEngine::GetPlayersFromJSON(const std::string playersJSON)
//{
//    std::map<int, std::string> players;
//    
//    Json::Value root;
//    Json::Reader reader;
//    bool parsingSuccessful = reader.parse(playersJSON, root);
//    
//    if (!parsingSuccessful)
//        return players;
//    
//    Json::Value defaultValue;
//    Json::Value arrayVal;
//    arrayVal = root.get("players", defaultValue);
//    
//    if (!arrayVal.isArray())
//        return players;
//    
//    Json::Value::iterator iter;
//    for (int i = 0; i < arrayVal.size(); i++)
//    {
//        Json::Value value = arrayVal.get(i, defaultValue);
//        Json::Value playerUID = value.get("playerUID", defaultValue);
//        Json::Value playerName = value.get("playerName", defaultValue);
//        players[playerUID.asInt()] = playerName.asString();
//    }
//    return players;
//}
