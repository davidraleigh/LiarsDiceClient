//
//  TestSuiteBinoCDF.h
//  NativeEngine
//
//  Created by David Raleigh on 9/6/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#ifndef NativeEngine_TestSuiteBinoCDF_h
#define NativeEngine_TestSuiteBinoCDF_h

#include <cxxtest/TestSuite.h>
#include "LiarsDiceEngine.h"
#include "PseudoRandom.h"
#include "Utilities.h"

class MyTestSuite2 : public CxxTest::TestSuite
{    
private:
    static int bruteForceBinoCDF(int numberOfMatchingRolls, 
                                 int totalNumberOfRolls, 
                                 int numberOfRuns, 
                                 bool bWild)
    {
        int totalDiceCount = totalNumberOfRolls;
        int requiredDiceCount = numberOfMatchingRolls;
        PseudoRandom *pseudo = new PseudoRandom(numberOfRuns + totalDiceCount);
        int successCount = 0;
        int trialCount = 0;
        for (int i = 0; i < numberOfRuns; i++) 
        {
            // fill vector<int>
            std::vector<int> dice = pseudo->GetDiceValue(totalDiceCount);
            for (int diceFaceValue = 2; diceFaceValue < 7; diceFaceValue++) 
            {
                int numberOfFaceValue = (int)std::count(dice.begin(), dice.end(), diceFaceValue);
                if (bWild)
                {
                    int numberOfOnes = (int)std::count(dice.begin(), dice.end(), 1);
                    numberOfFaceValue += numberOfOnes;
                }
                if (numberOfFaceValue >= requiredDiceCount)
                    successCount++;
                trialCount++;
            }
        }
        
        delete pseudo;
        return (int)((successCount * 100) / trialCount);
    }
    
    
public:
    void testBinoCDF_1(void)
    {
        // number of random run throughs to get actual bino cumulative distribution
        TS_TRACE("Starting BinoCDF test 1");
        int randomRunCount = 300; // before meresenne_twister, the count of 300 was sufficient for passing
        int totalDiceCount = 40;
//        for (randomRunCount = 300; randomRunCount < 600; randomRunCount++)
//        {
//            for (totalDiceCount = 20; totalDiceCount < 80; totalDiceCount++)
//            {
                for (int bidDiceCount = 1; bidDiceCount <= totalDiceCount; bidDiceCount++)
                {
                    int probResultBino = Utilities::GetProbability(bidDiceCount, totalDiceCount, false, false);
                    int probResultBrute = bruteForceBinoCDF(bidDiceCount, totalDiceCount, randomRunCount, false);
                    int probResultBinoWild = Utilities::GetProbability(bidDiceCount, totalDiceCount, false, true);
                    int probResultBruteWild = bruteForceBinoCDF(bidDiceCount, totalDiceCount, randomRunCount, true);
                    int difference = ::abs(probResultBino - probResultBrute);
                    int differenceWild = ::abs(probResultBinoWild - probResultBruteWild);
                    TS_ASSERT(difference <= 2);
                    TS_ASSERT(differenceWild <= 2);
                }
//            }
//        }
        TS_TRACE("Finishing BinoCDF test 1");
    }
};

#endif
