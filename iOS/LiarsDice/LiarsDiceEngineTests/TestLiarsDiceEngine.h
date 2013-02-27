 //
//  TestLiarsDiceEngine.h
//  LiarsDiceClient
//
//  Created by David Raleigh on 10/26/12.
//  Copyright (c) 2012 David Raleigh. All rights reserved.
//

#ifndef LiarsDiceClient_TestLiarsDiceEngine_h
#define LiarsDiceClient_TestLiarsDiceEngine_h

#include <cxxtest/TestSuite.h>
#include "LiarsDiceEngine.h"
#include "GamePlayers.h"
#include <memory>
//#include "Player.hpp"

class LiarsDiceEngineTestSuite : public CxxTest::TestSuite
{
public:
    
    void setUp()
    {
        GamePlayers::getInstance().AddPlayer(std::move("Ida"), 1, true, true);
        GamePlayers::getInstance().AddPlayer(std::move("Tayan"), 2, true, true);
        GamePlayers::getInstance().AddPlayer(std::move("Cooper"), 3, true, true);
        GamePlayers::getInstance().AddPlayer(std::move("Jebidiah"), 4, true, true);
    }
    
    void tearDown()
    {
    }
    
    void testLiarsDiceEngine(void)
    {
//        LiarsDiceEngine *liarsDice = new LiarsDiceEngine(5, true, 666);
//        RoundDetails::bid_t lowestBid = liarsDice->GetLowestPossibleBid();
//        TS_ASSERT_EQUALS(lowestBid.bidQuantity, 1);
//        TS_ASSERT_EQUALS(lowestBid.bidFaceValue, 1);
////        liarsDice->StartRound();
////        unsigned int playerUID = liarsDice->GetCurrentUID();
////        RoundDetails::bid_t AIBid = liarsDice->GenerateAIBid(playerUID);
//        
//        
//        delete liarsDice;
    }
    
    void testDestructor(void)
    {
        std::vector<int> hand1;
        {
            std::shared_ptr<LiarsDiceEngine> liarsDice1 = std::make_shared<LiarsDiceEngine>(5, true, 1977);
            liarsDice1->StartRound();
            hand1 = liarsDice1->GetPlayersDice(1);
        }
        
        std::vector<int> hand2;
        {
            std::shared_ptr<LiarsDiceEngine> liarsDice2 = std::make_shared<LiarsDiceEngine>(5, true, 1977);
            liarsDice2->StartRound();
            hand2 = liarsDice2->GetPlayersDice(1);
        }
        
        for (int index = 0; index < hand2.size(); index++)
        {
            int value1 = hand1[index];
            int value2 = hand2[index];
            TS_ASSERT_EQUALS(value1, value2);
        }
        
    }
};

#endif
