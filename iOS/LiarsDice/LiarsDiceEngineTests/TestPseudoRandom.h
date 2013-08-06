//
//  TestPseudoRandom.h
//  LiarsDiceClient
//
//  Created by David B Raleigh on 11/5/12.
//  Copyright (c) 2012 David Raleigh. All rights reserved.
//

#ifndef LiarsDiceClient_TestPseudoRandom_h
#define LiarsDiceClient_TestPseudoRandom_h

#include <cxxtest/TestSuite.h>
#include "PseudoRandom.h"
#include <memory>

class PseudoRandomTestSuite : public CxxTest::TestSuite
{
public:
    void testDestructor(void)
    {
        unsigned int seed = 123;
        int testVal1 = 0;
        int testVal2 = 1;
        {
            std::shared_ptr<PseudoRandom> randomGenerator = std::make_shared<PseudoRandom>(seed);
            TS_ASSERT_EQUALS(seed, randomGenerator->GetSeed());
            testVal1 = randomGenerator->GetRandomFromRange(0, 1000);
        }
        {
            std::shared_ptr<PseudoRandom> randomGenerator = std::make_shared<PseudoRandom>(seed);
            TS_ASSERT_EQUALS(seed, randomGenerator->GetSeed());
            testVal2 = randomGenerator->GetRandomFromRange(0, 1000);
        }
        TS_ASSERT_EQUALS(testVal1, testVal2);
    }
    
    void testShuffle(void)
    {
        std::shared_ptr<PseudoRandom> randomGen = std::make_shared<PseudoRandom>(123);
        std::vector<int> vect;
        vect.push_back(0);
        vect.push_back(1);
        vect.push_back(2);
        vect.push_back(3);
        randomGen->ShuffleVector(vect.begin(), vect.end());
        TS_ASSERT_DIFFERS(vect[0], 0);
        
    }
};

#endif
