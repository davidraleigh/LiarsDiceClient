//
//  TestUtilities.h
//  LiarsDiceClient
//
//  Created by David B Raleigh on 11/12/12.
//  Copyright (c) 2012 David Raleigh. All rights reserved.
//

#ifndef LiarsDiceClient_TestUtilities_h
#define LiarsDiceClient_TestUtilities_h


#include <cxxtest/TestSuite.h>
#include "Utilities.h"
#include <memory>

class UtilitiesTestSuite : public CxxTest::TestSuite
{
public:
    
    void setUp()
    {
    }
    
    void tearDown()
    {
    }
    
    void testStringContains(void)
    {
        std::string string1("albert");
        std::string string2("diLBeArd");
        std::string string3("a");
        std::string string4("t");
        std::string string5("lbE");
        std::string string6("lbe.");
        TS_ASSERT_EQUALS(Utilities::StringContains(string1, string3), 0);
        TS_ASSERT_EQUALS(Utilities::StringContains(string1, string5), 1);
        TS_ASSERT_EQUALS(Utilities::StringContains(string1, string4), 5);
        TS_ASSERT_EQUALS(Utilities::StringContains(string1, string6), -1);
        TS_ASSERT_EQUALS(Utilities::StringContains(string2, string5), 2);
        TS_ASSERT_EQUALS(Utilities::StringContains(string1, string2), -1);
        TS_ASSERT_EQUALS(Utilities::StringContains(string2, string4), -1);
        TS_ASSERT_EQUALS(Utilities::StringContains(string2, string3), 5);
        
    }
    
    void testCapitalization(void)
    {
        std::string string1("albErT");
        std::string string2("A chesty b.  jKingus");
        Utilities::CapitalizeNames(string1);
        Utilities::CapitalizeNames(string2);
        std::string string3("  albErT  ");
        std::string string4("  A chesty b.  jKingus  ");
        Utilities::CapitalizeNames(string3);
        Utilities::CapitalizeNames(string4);
        
        TS_ASSERT_EQUALS(string1.compare("AlbErT"), 0);
        TS_ASSERT_EQUALS(string2.compare("A chesty b.  JKingus"), 0);
        TS_ASSERT_EQUALS(string3.compare("  AlbErT  "), 0);
        TS_ASSERT_EQUALS(string4.compare("  A chesty b.  JKingus  "), 0);
        
    }
    
    void testStringIsInteger(void)
    {
        TS_ASSERT(Utilities::StringIsInteger("1"));
        TS_ASSERT(Utilities::StringIsInteger("01"));
        TS_ASSERT(!Utilities::StringIsInteger("1.1"));
        TS_ASSERT(!Utilities::StringIsInteger(".1"));
        TS_ASSERT(!Utilities::StringIsInteger("1="));
        TS_ASSERT(!Utilities::StringIsInteger("1+1"));
        TS_ASSERT(!Utilities::StringIsInteger("a"));
        TS_ASSERT(!Utilities::StringIsInteger("1a"));
        TS_ASSERT(!Utilities::StringIsInteger(""));
    }
    
    void testApplyFriction(void)
    {
        
        //(with an unknown number of variable frames adding up to 1 second)
        //Where an initial speed of 1000 and a friction value of 0.95 yielded:
        //950 when applying it with fixed time step.
        //951.2092 when applying it with variable time step over the course of 60 frames in a second.
        
        double speed = 1000;
        for (int i = 0; i < 60; i++)
        {
            speed = Utilities::ApplyFriction(speed, 0.95, 1.0 / 60.0);
        }
        
        TS_ASSERT_EQUALS(950.0, ::round(speed));

        int count = 0;
        speed = 1000;
        while (speed > 150)
        {
            speed = Utilities::ApplyFriction(speed, .5312, 1.0/ 60.0);
            count++;
        }
        
        TS_ASSERT_LESS_THAN_EQUALS(count, 180);
        
        speed = 1000;
        TS_ASSERT_EQUALS(1000, Utilities::ApplyFriction(speed, 1.0, 1.0/60.0));
        
        double friction = Utilities::GetFriction(1000.0, 149.99, 3.0, 1.0/60.0);
     
        TS_ASSERT_EQUALS_TOL(friction, .5312, .01);
        
        TS_ASSERT_EQUALS(Utilities::GetFriction(1000, 1001, 3, 1.0/60.0), 0);
        TS_ASSERT_EQUALS(Utilities::GetFriction(1000, 1000, 3, 1.0/60.0), 1);
        TS_ASSERT_EQUALS(Utilities::GetFriction(1000, 1000, 3, 4), 1);
    }
};


#endif
