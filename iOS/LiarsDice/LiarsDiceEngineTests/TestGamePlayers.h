//
//  TestGamePlayers.h
//  LiarsDiceClient
//
//  Created by David B Raleigh on 10/2/12.
//  Copyright (c) 2012 David Raleigh. All rights reserved.
//

#ifndef LiarsDiceClient_TestGamePlayers_h
#define LiarsDiceClient_TestGamePlayers_h

#include <cxxtest/TestSuite.h>
#include "Player.h"
#include "GamePlayers.h"

class GamePlayersTestSuite : public CxxTest::TestSuite
{
public:
    void testGamePlayer(void)
    {
        //untested : bool AddPlayer(unsigned int playerUID, std::string playerName)
        
        TS_ASSERT_EQUALS(GamePlayers::getInstance().PlayerCount(), 0);
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerUID(0), 0);
        TS_ASSERT(!GamePlayers::getInstance().ContainsPlayer(0));
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerNameAtPosition(0).length(), 0);
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerPosition(0), -1);
        TS_ASSERT_EQUALS(GamePlayers::getInstance().PlayerCount(), 0);
        
        // AddPlayer(unsigned int playerUID, std::string playerName)
        TS_ASSERT(GamePlayers::getInstance().AddPlayer("Ida", 45, true, false));
        TS_ASSERT(GamePlayers::getInstance().AddPlayer("Tayan", 35, true, true));
        TS_ASSERT(GamePlayers::getInstance().AddPlayer("Cooper", 25, true, false));
        TS_ASSERT(!GamePlayers::getInstance().AddPlayer("Jebidiah", 0, true, true));
        TS_ASSERT_EQUALS(GamePlayers::getInstance().PlayerCount(), 3);
        
        // MovePlayer
        TS_ASSERT(GamePlayers::getInstance().MovePlayer(0, 0));
        TS_ASSERT(GamePlayers::getInstance().MovePlayer(0, 2));
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerPosition(35), 0);
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerPosition(25), 1);
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerPosition(45), 2);
        TS_ASSERT(GamePlayers::getInstance().MovePlayer(1, 2));
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerPosition(35), 0);
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerPosition(45), 1);
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerPosition(25), 2);
        TS_ASSERT(GamePlayers::getInstance().MovePlayer(0, 1));
        TS_ASSERT(!GamePlayers::getInstance().MovePlayer(0, 3));
        TS_ASSERT(!GamePlayers::getInstance().MovePlayer(3, 3));
        TS_ASSERT(!GamePlayers::getInstance().MovePlayer(-1, 3));
        TS_ASSERT(!GamePlayers::getInstance().MovePlayer(-1, -2));
        
        // GetPlayerNameAtPosition
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerNameAtPosition(0).compare("Ida"), 0);
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerNameAtPosition(-1).length(), 0);
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerNameAtPosition(3).length(), 0);
       
        // GetPlayerNameAtUID
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerNameAtUID(0).compare(""), 0);
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerNameAtUID(-1).compare(""), 0);
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerNameAtUID(20).compare(""), 0);

        
        // ContainsPlayer(const std::string playerName)
        // ContainsPlayer(unsigned int playerUID)
        TS_ASSERT(GamePlayers::getInstance().ContainsPlayer("Ida"));
        TS_ASSERT(!GamePlayers::getInstance().ContainsPlayer("ida"));
        TS_ASSERT(GamePlayers::getInstance().ContainsPlayer(25));
        TS_ASSERT(!GamePlayers::getInstance().ContainsPlayer(-1));
        TS_ASSERT(!GamePlayers::getInstance().ContainsPlayer(0));
        
        // GetPlayerPosition
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerPosition(35), 1);
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerPosition(45), 0);
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerPosition(-1), -1);
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerPosition(0), -1);
        
        // SwapPlayerOrder
        TS_ASSERT(GamePlayers::getInstance().SwapPlayerOrder(0, 2));
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerPosition(45), 2);
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerPosition(35), 1);
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerPosition(25), 0);
        TS_ASSERT(GamePlayers::getInstance().SwapPlayerOrder(0, 2));
        TS_ASSERT(GamePlayers::getInstance().SwapPlayerOrder(1, 1));
        TS_ASSERT(!GamePlayers::getInstance().SwapPlayerOrder(1, -1));
        TS_ASSERT(!GamePlayers::getInstance().SwapPlayerOrder(12, 1));
        
        // DeletePlayerAtUID(unsigned int playerUID)
        // DeletePlayerAtPosition(short playerPosition)
        TS_ASSERT(GamePlayers::getInstance().AddPlayer("DJ", 65, true, true));
        TS_ASSERT(!GamePlayers::getInstance().DeletePlayerAtUID(44));
        TS_ASSERT(GamePlayers::getInstance().DeletePlayerAtUID(45));
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerPosition(35), 0);
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerPosition(65), 2);
        TS_ASSERT(GamePlayers::getInstance().DeletePlayerAtUID(65));
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetPlayerPosition(65), -1);
        TS_ASSERT_EQUALS(GamePlayers::getInstance().PlayerCount(), 2);
        TS_ASSERT(GamePlayers::getInstance().AddPlayer("Stevie", 75, true, false));
        TS_ASSERT(GamePlayers::getInstance().AddPlayer("Bernie", 85, true, true));
        TS_ASSERT(GamePlayers::getInstance().DeletePlayerAtPosition(3));
        TS_ASSERT(!GamePlayers::getInstance().ContainsPlayer(85));
        
        // GetPlayerAtPosition(short position)
        Player* playerDJ = GamePlayers::getInstance().GetPlayerAtPosition(1);
        TS_ASSERT_EQUALS(playerDJ->GetPlayerUID(), 25);
        TS_ASSERT(GamePlayers::getInstance().DeletePlayerAtUID(25));
        TS_ASSERT_EQUALS(playerDJ->GetPlayerUID(), 0);
        TS_ASSERT(!GamePlayers::getInstance().GetPlayerAtPosition(-1));
        // pointer is released
        
        
        //
        // GetPlayerAtUID(unsigned int playerUID)
        Player* playerStevie = GamePlayers::getInstance().GetPlayerAtUID(75);
        TS_ASSERT_EQUALS(playerStevie->GetPlayerUID(), 75);
        TS_ASSERT(!GamePlayers::getInstance().GetPlayerAtUID(0));
        
        // GetAvailableDummUID()
        TS_ASSERT_EQUALS(!GamePlayers::getInstance().GetAvailableDummyUID(), 0);
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetAvailableDummyUID(), 1);
        
        GamePlayers::getInstance().DeleteAll();
        TS_ASSERT_EQUALS(GamePlayers::getInstance().GetAvailableDummyUID(), 1);
        //TS_ASSERT(false);// Test for JSON
        
    }
};

#endif
