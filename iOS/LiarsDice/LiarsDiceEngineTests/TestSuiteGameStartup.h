//
//  TestSuiteGameStartup.h
//  NativeEngine
//
//  Created by David Raleigh on 9/18/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#ifndef NativeEngine_TestSuiteGameStartup_h
#define NativeEngine_TestSuiteGameStartup_h

#include <cxxtest/TestSuite.h>
#include "LiarsDiceEngine.h"
#include "GamePlayers.h"
//#include "MessagePrep.h"
#include <json/json.h>

class GameStartupTestSuite : public CxxTest::TestSuite
{
public:
    void testAddPlayers(void)
    {
        const char *jsonPlayer = R"(
        { "players" : [
                       {"playerUID" : 12345 , "playerName" : "cooper", "playerQualities" :
                           {
                               "bidQualities" :
                               {
                                   "totalBids" : 30,
                                   "percentChanceOfBid" : [ 45, 48, 86, 89, 95, 100],
                                   "weakLyingOccurences" : [0, 0, 1, 2, 4, 8],
                                   "strongLyingOccurences" : [0, 1, 2, 0, 3, 2],
                                   "totalOccurences" : [5, 3, 2, 4, 6, 10]
                               }
                               ,
                               "challengeQualities" :
                               {
                                   "totalChallenges" : 8,
                                   "percentChanceOfBid" : [ 35, 40, 44, 54],
                                   "challengeOccurences" : [2, 1, 1, 2],
                                   "challengeSuccesses" : [2, 1, 0, 1],
                                   "totalOccurences" : [2, 1, 1, 4]
                               }
                           }
                       } ,
                       {"playerUID" : 12346 , "playerName" : "cory" , "playerQualities" :
                           {
                               "bidQualities" :
                               {
                                   "totalBids" : 30,
                                   "percentChanceOfBid" : [ 45, 48, 86, 89, 95, 100],
                                   "weakLyingOccurences" : [0, 0, 1, 2, 4, 8],
                                   "strongLyingOccurences" : [0, 1, 2, 0, 3, 2],
                                   "totalOccurences" : [5, 3, 2, 4, 6, 10]
                               }
                               ,
                               "challengeQualities" :
                               {
                                   "totalChallenges" : 8,
                                   "percentChanceOfBid" : [ 35, 40, 44, 54],
                                   "challengeOccurences" : [2, 1, 1, 2],
                                   "challengeSuccesses" : [2, 1, 0, 1],
                                   "totalOccurences" : [2, 1, 1, 4]
                               }
                           }
                       } ,
                       {"playerUID" : 12347 , "playerName" : "david", "playerQualities" :
                           {
                               "bidQualities" :
                               {
                                   "totalBids" : 30,
                                   "percentChanceOfBid" : [ 45, 48, 86, 89, 95, 100],
                                   "weakLyingOccurences" : [0, 0, 1, 2, 4, 8],
                                   "strongLyingOccurences" : [0, 1, 2, 0, 3, 2],
                                   "totalOccurences" : [5, 3, 2, 4, 6, 10]
                               }
                               ,
                               "challengeQualities" :
                               {
                                   "totalChallenges" : 8,
                                   "percentChanceOfBid" : [ 35, 40, 44, 54],
                                   "challengeOccurences" : [2, 1, 1, 2],
                                   "challengeSuccesses" : [2, 1, 0, 1],
                                   "totalOccurences" : [2, 1, 1, 4]
                               }
                           }
                       } ,
                       
                       {"playerUID" : 12348 , "playerName" : "brian ida", "playerQualities" :
                           {
                               "bidQualities" :
                               {
                                   "totalBids" : 30,
                                   "percentChanceOfBid" : [ 45, 48, 86, 89, 95, 100],
                                   "weakLyingOccurences" : [0, 0, 1, 2, 4, 8],
                                   "strongLyingOccurences" : [0, 1, 2, 0, 3, 2],
                                   "totalOccurences" : [5, 3, 2, 4, 6, 10]
                               }
                               ,
                               "challengeQualities" :
                               {
                                   "totalChallenges" : 8,
                                   "percentChanceOfBid" : [ 35, 40, 44, 54],
                                   "challengeOccurences" : [2, 1, 1, 2],
                                   "challengeSuccesses" : [2, 1, 0, 1],
                                   "totalOccurences" : [2, 1, 1, 4]
                               }
                           }
                       } ,
                       
                       {"playerUID" : 12349 , "playerName" : "DJ", "playerQualities" :
                           {
                               "bidQualities" :
                               {
                                   "totalBids" : 30,
                                   "percentChanceOfBid" : [ 45, 48, 86, 89, 95, 100],
                                   "weakLyingOccurences" : [0, 0, 1, 2, 4, 8],
                                   "strongLyingOccurences" : [0, 1, 2, 0, 3, 2],
                                   "totalOccurences" : [5, 3, 2, 4, 6, 10]
                               }
                               ,
                               "challengeQualities" :
                               {
                                   "totalChallenges" : 8,
                                   "percentChanceOfBid" : [ 35, 40, 44, 54],
                                   "challengeOccurences" : [2, 1, 1, 2],
                                   "challengeSuccesses" : [2, 1, 0, 1],
                                   "totalOccurences" : [2, 1, 1, 4]
                               }
                           }
                       } ,
                       
                       {"playerUID" : 12350 , "playerName" : "greg", "playerQualities" :
                           {
                               "bidQualities" :
                               {
                                   "totalBids" : 30,
                                   "percentChanceOfBid" : [ 45, 48, 86, 89, 95, 100],
                                   "weakLyingOccurences" : [0, 0, 1, 2, 4, 8],
                                   "strongLyingOccurences" : [0, 1, 2, 0, 3, 2],
                                   "totalOccurences" : [5, 3, 2, 4, 6, 10]
                               }
                               ,
                               "challengeQualities" :
                               {
                                   "totalChallenges" : 8,
                                   "percentChanceOfBid" : [ 35, 40, 44, 54],
                                   "challengeOccurences" : [2, 1, 1, 2],
                                   "challengeSuccesses" : [2, 1, 0, 1],
                                   "totalOccurences" : [2, 1, 1, 4]
                               }
                           }
                       } ,
                       
                       {"playerUID" : 12351 , "playerName" : "brian tayan", "playerQualities" :
                           {
                               "bidQualities" :
                               {
                                   "totalBids" : 30,
                                   "percentChanceOfBid" : [ 45, 48, 86, 89, 95, 100],
                                   "weakLyingOccurences" : [0, 0, 1, 2, 4, 8],
                                   "strongLyingOccurences" : [0, 1, 2, 0, 3, 2],
                                   "totalOccurences" : [5, 3, 2, 4, 6, 10]
                               }
                               ,
                               "challengeQualities" :
                               {
                                   "totalChallenges" : 8,
                                   "percentChanceOfBid" : [ 35, 40, 44, 54],
                                   "challengeOccurences" : [2, 1, 1, 2],
                                   "challengeSuccesses" : [2, 1, 0, 1],
                                   "totalOccurences" : [2, 1, 1, 4]
                               }
                           }
                       }
                       ]
        })";
        
        std::string jsonPlayerString(jsonPlayer);
        
        GamePlayers::getInstance().AddPlayers(std::move(jsonPlayerString));
    }
    
    void testDeviceDetails(void)
    {
//        MessagePrep *messagPrep = new MessagePrep(37, 1, 1);
//        Json::Value root = messagPrep->GetDeviceDetails("iOS", "6.0", "weroiud", 45, 85.2);
//        Json::StyledWriter writer;
//        std::string words = writer.write(root);
//        Json::Value testRoot;
//        Json::Reader reader;
//        TS_ASSERT(reader.parse(words, testRoot));
//        Json::Value defaultJson;
//        Json::Value objects = testRoot.get("deviceDetails", defaultJson);
//        TS_ASSERT(objects.isObject());
//        TS_ASSERT(objects.get("playerUID", defaultJson).isInt());
//        TS_ASSERT(objects.get("deviceOSName", defaultJson).isString());
//        TS_ASSERT_EQUALS(objects.get("longitude",defaultJson).asDouble(), 85.2);
        
    }
    
    void testAddition(void)
    {

        //GamePlayers::getInstance().AddPlayers(jsonPlayerString);

        //gamePlayers->AddPlayers(jsonPlayerString);
        
//        int diceCount = 5;
//        std::map<int, std::string> playerStuff = LiarsDiceEngine::GetPlayersFromJSON(jsonPlayerString);
//        LiarsDiceEngine *liarsDice = new LiarsDiceEngine(jsonPlayerString,  diceCount, true, 1977);
//        TS_ASSERT(liarsDice);
//        TS_ASSERT(playerStuff.size() > 0);
//        TS_ASSERT(!liarsDice->IsGameOver());
//        TS_ASSERT_EQUALS(diceCount, liarsDice->GetPlayersDiceCount(12345));
//        TS_ASSERT_EQUALS(liarsDice, <#y#>)
//        TS_ASSERT_EQUALS(1 + 1, 2);
    }
};

#endif
