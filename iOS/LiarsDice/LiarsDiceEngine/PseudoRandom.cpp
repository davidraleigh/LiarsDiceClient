//
//  PseudoRandom.cpp
//  LiarsDiceConsole
//
//  Created by David Raleigh on 9/2/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#include "PseudoRandom.h"
#include <ctime>

PseudoRandom::PseudoRandom()
{
    m_seed = std::time(NULL);
    m_generator.seed(1977);
    m_seed = 1977;
}

PseudoRandom::PseudoRandom(unsigned int seed)
{
    m_generator.seed(seed);
    m_randomCount = 1000;
    m_seed = seed;
    for (int i = 0; i <= m_randomCount; i++)
        m_generator();
    
}

PseudoRandom::~PseudoRandom()
{
}

unsigned int PseudoRandom::GetSeed()
{
    return m_seed;
}

int PseudoRandom::GetDiceValue()
{
    m_randomCount++;
    return (m_generator() % 6) + 1;
}

std::vector<int> PseudoRandom::GetDiceValue(int numberOfDice)
{
    std::vector<int> dice;
    for (int i = 0; i < numberOfDice; i++)
        dice.push_back(GetDiceValue());
    
    return dice;
}

int PseudoRandom::GetRandomCount()
{
    return m_randomCount;
}

int PseudoRandom::GetRandomFromRange(int lowPointInclusive, int highPointExclusive)
{
    m_randomCount++;
    
    return (m_generator() % (highPointExclusive - lowPointInclusive)) + lowPointInclusive;
}

PseudoRandom::CoinSide PseudoRandom::CoinToss()
{
    m_randomCount++;
    //TODO replace with Meresene Twister
    return m_generator() % 2 == Heads ? Heads : Tails;
}