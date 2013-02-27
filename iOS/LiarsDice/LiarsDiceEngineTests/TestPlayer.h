//
//  TestPlayer.h
//  LiarsDiceClient
//
//  Created by David B Raleigh on 10/16/12.
//  Copyright (c) 2012 David Raleigh. All rights reserved.
//

#ifndef LiarsDiceClient_TestPlayer_h
#define LiarsDiceClient_TestPlayer_h

#include <cxxtest/TestSuite.h>
#include "PseudoRandom.h"
#include "Player.h"

class PlayerTestSuite : public CxxTest::TestSuite
{
    std::string m_playerName;
    
public:
    
    void setUp()
    {
        m_playerName = "Bob";
    }
    
    void tearDown()
    {
    }
    
    
    void testPlayerEmpty(void)
    {
        std::string playerName(m_playerName);
        Player *playerArray[3];
        playerArray[0] = new Player();
        playerArray[1] = new Player(playerName, 0, false, true);
        playerArray[2] = new Player("", 1, true, true);
        std::shared_ptr<PseudoRandom> randomGen = std::make_shared<PseudoRandom>();
        for (int i = 0; i < 3; i++)
        {
            Player *player = playerArray[i];
            TS_ASSERT_EQUALS(player->GetDieFaceValue(0), 0);
            TS_ASSERT_EQUALS(player->GetDiceCount(), 0);
            TS_ASSERT_EQUALS(player->GetPlayerDice().size(), 0);
            TS_ASSERT_EQUALS(player->GetPlayerName().size(), 0);
            TS_ASSERT_EQUALS(player->GetPlayerUID(), 0);
            TS_ASSERT_EQUALS(player->GetRoundNumber(), 0);
            TS_ASSERT_EQUALS(player->IsInactive(), true);
            TS_ASSERT(!player->FillGameDice(randomGen, 5, 2));
            TS_ASSERT(!player->Roll());
            TS_ASSERT(!player->IsPlayerOnThisDevice());
            delete player;
        }
    }
    
    void testRollTotal()
    {
        std::string playerName(m_playerName);
        int diceCount = 5;
        int playerCount = 6;
        bool bPlaysOnThisClient = true;
        unsigned int playerUID = 1;
        std::shared_ptr<PseudoRandom> pseudo = std::make_shared<PseudoRandom>(1);
        Player *player = new Player(playerName, playerUID, bPlaysOnThisClient, true);
        TS_ASSERT(player->FillGameDice(pseudo, playerCount, diceCount));
        
        int totalRollCount = playerCount * diceCount;
        for (int i = 0; i < totalRollCount; i++)
            TS_ASSERT(player->Roll());
        
        TS_ASSERT(!player->Roll());
    }
    
    void testPlayerNoQualities()
    {
        std::string playerName(m_playerName);
        // Cannot change this!
        int diceCount = 5;
        int playerCount = 6;
        bool bPlaysOnThisClient = true;
        unsigned int playerUID = 1;
        std::shared_ptr<PseudoRandom> pseudo = std::make_shared<PseudoRandom>(1);
        Player *player = new Player(playerName, playerUID, bPlaysOnThisClient, false);
        TS_ASSERT(!player->Roll());
        TS_ASSERT(player->FillGameDice(pseudo, playerCount, diceCount));
        TS_ASSERT(!player->FillGameDice(pseudo, playerCount, diceCount));
        TS_ASSERT_EQUALS(player->GetRoundNumber(), 0);
        TS_ASSERT(player->Roll());
        TS_ASSERT_EQUALS(player->GetRoundNumber(), 1);
        TS_ASSERT_EQUALS(player->GetDiceCount(), diceCount);
        std::vector<int> dice = player->GetPlayerDice();
        TS_ASSERT_EQUALS(dice.size(), player->GetDiceCount());
        // 2 2 4 5 6
        TS_ASSERT_EQUALS(dice[0], 6);
        TS_ASSERT_EQUALS(dice[1], 4);
        TS_ASSERT_EQUALS(dice[2], 2);
        TS_ASSERT_EQUALS(dice[3], 2);
        TS_ASSERT_EQUALS(dice[4], 5);
        TS_ASSERT_EQUALS(player->GetDieFaceValue(0), dice[0]);
        TS_ASSERT_EQUALS(player->GetDieFaceValue(1), dice[1]);
        TS_ASSERT_EQUALS(player->GetDieFaceValue(2), dice[2]);
        TS_ASSERT_EQUALS(player->GetDieFaceValue(3), dice[3]);
        TS_ASSERT_EQUALS(player->GetDieFaceValue(4), dice[4]);
        TS_ASSERT_EQUALS(player->GetGameDicePosition(), 5);
        
        player->RemoveDie();
        TS_ASSERT_EQUALS(player->GetDiceCount(), diceCount - 1);
        TS_ASSERT(player->Roll());
        TS_ASSERT(player->Roll());
        TS_ASSERT_EQUALS(player->GetRoundNumber(), 3);
        TS_ASSERT_EQUALS(player->GetDiceCount(), diceCount - 1);
        dice = player->GetPlayerDice();
        TS_ASSERT_EQUALS(dice[0], 5);
        TS_ASSERT_EQUALS(dice[1], 4);
        TS_ASSERT_EQUALS(dice[2], 5);
        TS_ASSERT_EQUALS(dice[3], 1);
        TS_ASSERT_EQUALS(dice.size(), diceCount - 1);
        player->RemoveDie();
        TS_ASSERT_EQUALS(player->GetDiceCount(), diceCount - 2);
        TS_ASSERT(player->Roll());
        dice = player->GetPlayerDice();
        TS_ASSERT_EQUALS(dice[0], 6);
        TS_ASSERT_EQUALS(dice[1], 1);
        TS_ASSERT_EQUALS(dice[2], 4);
        player->RemoveDie();
        TS_ASSERT(player->Roll());
        dice = player->GetPlayerDice();
        TS_ASSERT_EQUALS(dice[0], 6);
        TS_ASSERT_EQUALS(dice[1], 4);
        player->RemoveDie();
        TS_ASSERT(player->Roll());
        dice = player->GetPlayerDice();
        TS_ASSERT_EQUALS(dice[0], 6);
        player->RemoveDie();
        TS_ASSERT(!player->Roll());
        
        TS_ASSERT_EQUALS(player->GetPlayerName().compare(m_playerName), 0);
        TS_ASSERT_EQUALS(player->GetPlayerUID(), playerUID);
        TS_ASSERT(!player->IsInactive())
        
        player->ResetDice();
        TS_ASSERT_EQUALS(player->GetRoundNumber(), 0);
        TS_ASSERT_EQUALS(player->GetGameDicePosition(), 0);
        TS_ASSERT_EQUALS(player->GetDiceCount(), 0);
        TS_ASSERT_EQUALS(player->GetPlayerName().compare(m_playerName), 0);
        TS_ASSERT_EQUALS(player->GetPlayerUID(), playerUID);
        TS_ASSERT(!player->IsInactive())
        
        delete player;
    }
};

#endif
