//
//  PseudoRandom.h
//  LiarsDiceConsole
//
//  Created by David Raleigh on 9/2/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#ifndef LiarsDiceConsole_PseudoRandom_h
#define LiarsDiceConsole_PseudoRandom_h

#include <vector>
#include <random>

class PseudoRandom
{
private:
    int m_randomCount;
    std::mt19937_64 m_generator;
    unsigned int m_seed;
    
public:
    enum CoinSide { Heads = 0, Tails = 1 };
    
    PseudoRandom ();
    
    PseudoRandom(unsigned int seed);
    
    ~PseudoRandom();
    
    unsigned int GetSeed();
    
    int GetDiceValue();
    
    std::vector<int> GetDiceValue(int numberOfDice);
    
    int GetRandomCount();
    
    int GetRandomFromRange(int lowPoint, int highPoint);
    
    CoinSide CoinToss();
};

#endif
