//
//  Utilities.h
//  LiarsDiceClient
//
//  Created by David Raleigh on 9/24/12.
//  Copyright (c) 2012 David Raleigh. All rights reserved.
//

#ifndef __LiarsDiceClient__MathUtilities__
#define __LiarsDiceClient__MathUtilities__

#include <iostream>


class Utilities {
    
    
public:    
    /**
     * deceleration method
     * http://gamedev.stackexchange.com/questions/20905/simple-speed-deceleration-with-variable-time-step
     * @param startVelocity is the current velocity
     * @param friction is the friction applied to the Velocity
     * @param dt is the time interval defined with a unit in respect
     * to the startVelocity
     * @return velocity after application of friction for duration dt
     *
     */
    static double ApplyFriction(double startVelocity, double friction, double dt);
    
    static void CapitalizeNames(std::string &name);
    
    /**
     * Factorial method. Multiply from
     * 1 to n.  There are better implementations.
     * This is a grade school hack.
     * @param n
     * @return
     */
    //TODO Use better algorithm
    static double Factorial(double n);
    
    /**
     * Get the friction coefficient to take the startVelocity
     * to the endVelocity using the maxDuration and the dt
     */
    static double GetFriction(double startVelocity, double endVelocity, double maxDuration, double dt);
    
    /**
     * Get the number of iterations it will take to go from the 
     * startVelocity to the endVelocity with the defined friction
     * and the defined dt
     */
    static int GetFrictionCount(double startVelocity, double endVelocity, double friction, double dt);
        
    static void GetOrdinalString(int number, std::string ordinalNumber);
    
    /**
     * This basically uses the binomial cumulative
     * distribution (kind of...) to get the likelihood
     * that at they very least the number of die needed
     * can be rolled within the total number of rolls.
     * This is inspired originally by a Stanford Univ.
     * assignment, then clarified by the Wikipedia page
     * and Matlab's bincdf function:
     * (int)(100 * (1-binocdf(numberOfMatchingRolls - 1, totalNumberOfRolls, 1 / 6)))
     * @param numberOfMatchingRolls the smallest number of matching rolls
     * @param totalNumberOfRolls total number of rolls allowed
     * @return
     */
    //TODO move to a separate class
    static int GetProbability(int numberOfMatchingRolls,
                              int totalNumberOfRolls,
                              bool bBidIsWildValue,
                              bool bWildOneUsedThisRound);
    
    static double HaversinceDistance(double lonDegrees1, double latDegrees1, double lonDegrees2, double latDegrees2, double radius);

    
    static int StringContains(std::string container, std::string contained);

    static bool StringIsInteger(std::string value);
    
    // trim from start
    static inline std::string &ltrim(std::string &s) {
        s.erase(s.begin(), std::find_if(s.begin(), s.end(), std::not1(std::ptr_fun<int, int>(std::isspace))));
        return s;
    }
    
    // trim from end
    static inline std::string &rtrim(std::string &s) {
        s.erase(std::find_if(s.rbegin(), s.rend(), std::not1(std::ptr_fun<int, int>(std::isspace))).base(), s.end());
        return s;
    }
    
    // trim from both ends
    static inline std::string &trim(std::string &s) {
        return ltrim(rtrim(s));
    }
    
};




#endif /* defined(__LiarsDiceClient__MathUtilities__) */
