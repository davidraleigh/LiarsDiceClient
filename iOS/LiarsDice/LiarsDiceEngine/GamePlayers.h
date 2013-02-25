//
//  GamePlayers.h
//  LiarsDiceClient
//
//  Created by David Raleigh on 9/20/12.
//  Copyright (c) 2012 David Raleigh. All rights reserved.
//

#ifndef __LiarsDiceClient__GamePlayers__
#define __LiarsDiceClient__GamePlayers__

#include "Player.h"

#include <iostream>
#include <map>

class GamePlayers
{
private:
    GamePlayers(){};
    GamePlayers(GamePlayers const&);
    GamePlayers& operator=(GamePlayers const&);
    
    std::map<int, unsigned int> m_playerSeatingMap;
    std::map<unsigned int, Player> m_playersMap;
    unsigned int m_groupLeaderUID;
    unsigned int m_playerUID;
    
    void _ShiftPlayerOrder();
    
public:
    static GamePlayers& getInstance()
    {
        static GamePlayers instance;
        return instance;
    }
    
    /**
     * Get the number of players
     */
    int PlayerCount();

    bool AddPlayers(const std::string jsonString); // Tested
    bool AddPlayer(const std::string playerName, unsigned int playerUID, bool playerIsOnThisClient, bool isAI); // Tested
    
    bool ContainsPlayer(const std::string playerName); // Tested
    bool ContainsPlayer(unsigned int playerUID); // Tested

    void DeleteAll();
    bool DeletePlayerAtUID(unsigned int playerUID); // Tested
    bool DeletePlayerAtPosition(int playerPosition); // Tested

    unsigned int GetAvailableDummyUID(); // Tested
    unsigned int GetGroupLeaderUID();
    int GetPlayerPosition(unsigned int playerUID); // Tested

    Player* GetPlayerAtPosition(int position); // Tested
    Player* GetPlayerAtUID(unsigned int playerUID); // Tested
    
    std::string GetPlayerNameAtPosition(int position); // Tested
    std::string GetPlayerNameAtUID(unsigned int playerUID); // Tested
    
    unsigned int GetPlayerUID(int position); // Tested
    
    /**
     * Move the player from the source position
     * to the destination position and leave other
     * players undisturbed
     */
    bool MovePlayer(int sourcePosition, int destinationPosition); // Tested
    
    void SetGroupLeader(unsigned int playerUID);
    
    bool SwapPlayerOrder(int playerPosition1, int playerPosition2); // Tested

    /**
     * index is the position at the table.  it starts at 0 and goes
     * to the player count minus 1
     */
    
    

};

#endif /* defined(__LiarsDiceClient__GamePlayers__) */
