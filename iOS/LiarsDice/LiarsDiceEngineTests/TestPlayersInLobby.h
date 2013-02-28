//
//  TestPlayersInLobby.h
//  LiarsDiceClient
//
//  Created by David Raleigh on 10/29/12.
//  Copyright (c) 2012 David Raleigh. All rights reserved.
//

#ifndef LiarsDiceClient_TestPlayersInLobby_h
#define LiarsDiceClient_TestPlayersInLobby_h

#include <cxxtest/TestSuite.h>
#include "json/json.h"
#include "PlayersInLobby.h"

class PlayersInLobbyTestSuite : public CxxTest::TestSuite
{
public:
    
    void testEmptyLobby(void)
    {
        TS_ASSERT(!PlayersInLobby::getInstance().ContainsPlayer(1));
        TS_ASSERT(!PlayersInLobby::getInstance().DeletePlayerAtUID(4));
        TS_ASSERT(!PlayersInLobby::getInstance().DeletePlayerAtPosition(1))
        PlayersInLobby::player_t player = PlayersInLobby::getInstance().GetGroupLeader(7);
        TS_ASSERT(player.playerUID == 0);
        TS_ASSERT(player.groupUID == 0);
        TS_ASSERT(player.distance == 0);
        TS_ASSERT_EQUALS(PlayersInLobby::getInstance().GetPlayerUID(0), 0);
        TS_ASSERT_EQUALS(PlayersInLobby::getInstance().GetPlayerPosition(0), -1);
        
        PlayersInLobby::player_t playerDetails;
        playerDetails.playerName = "Bob1000";
        playerDetails.playerUID = 12;
        playerDetails.groupUID = 10;
        playerDetails.bIsGroupLeader = true;
        playerDetails.distance = 5;
        //TS_ASSERT(!PlayersInLobby::getInstance().InsertPlayer(playerDetails));
    }
    
    void testStartup(void)
    {
        Json::Value playersLobby;
        
        PlayersInLobby::getInstance()._GenerateLobbyPlayers(playersLobby);
        TS_ASSERT(PlayersInLobby::getInstance().InitializePlayers(playersLobby, 15, 30, 30));
//        
//        TS_ASSERT(!PlayersInLobby::getInstance().ContainsPlayer(0));
//        TS_ASSERT(PlayersInLobby::getInstance().ContainsPlayer(1));
//    
//        TS_ASSERT_EQUALS(PlayersInLobby::getInstance().GetPlayerAtPosition(0).playerUID, 4);
//        TS_ASSERT(PlayersInLobby::getInstance().DeletePlayerAtUID(4));
//        TS_ASSERT_EQUALS(PlayersInLobby::getInstance().GetPlayerAtPosition(0).playerUID, 10);
//    
//        TS_ASSERT_EQUALS(PlayersInLobby::getInstance().GetPlayerAtPosition(1).playerUID, 9);
//        TS_ASSERT(PlayersInLobby::getInstance().DeletePlayerAtPosition(1))
//        TS_ASSERT_EQUALS(PlayersInLobby::getInstance().GetPlayerAtPosition(1).playerUID, 3);
//        
//        TS_ASSERT_EQUALS(PlayersInLobby::getInstance().GetGroupLeader(7).playerUID, 7);
//        
//        double distance = 0;
//        for (int i = 0; i < PlayersInLobby::getInstance().Size(); i++)
//        {
//            PlayersInLobby::player_t playerDetails = PlayersInLobby::getInstance().GetPlayerAtPosition(i);
//            TS_ASSERT_EQUALS(playerDetails.playerUID, PlayersInLobby::getInstance().GetPlayerUID(i));
//            TS_ASSERT_EQUALS(playerDetails.playerUID, PlayersInLobby::getInstance().GetPlayerFromUID(playerDetails.playerUID).playerUID);
//            TS_ASSERT_EQUALS(i, PlayersInLobby::getInstance().GetPlayerPosition(playerDetails.playerUID));
//            TS_ASSERT_LESS_THAN_EQUALS(0, playerDetails.distance);
//            distance = playerDetails.distance;
//        }
//        
//        TS_ASSERT_EQUALS(PlayersInLobby::getInstance().GetPlayerPosition(45), -1);
//        
//        // Create a player that is between player position 0 and 1
//        double newDistance = PlayersInLobby::getInstance().GetPlayerAtPosition(0).distance + 1;
//        PlayersInLobby::player_t playerDetails;
//        playerDetails.playerName = "Bob1000";
//        playerDetails.playerUID = 12;
//        playerDetails.groupUID = 10;
//        playerDetails.bIsGroupLeader = true;
//        playerDetails.distance = newDistance;
//        TS_ASSERT(PlayersInLobby::getInstance().InsertPlayer(playerDetails));
//        TS_ASSERT_EQUALS(PlayersInLobby::getInstance().GetPlayerAtPosition(1).playerUID, playerDetails.playerUID);
//        TS_ASSERT(!PlayersInLobby::getInstance().InsertPlayer(playerDetails));
//        playerDetails.playerUID = 0;
//        TS_ASSERT(!PlayersInLobby::getInstance().InsertPlayer(playerDetails));        
    }
};



#endif
