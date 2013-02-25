//
//  MathUtilities.cpp
//  LiarsDiceClient
//
//  Created by David Raleigh on 9/24/12.
//  Copyright (c) 2012 David Raleigh. All rights reserved.
//

#include "MathUtilities.h"

#include <cmath>
#include <sstream>


double MathUtilities::ApplyFriction(double value, double friction, double dt)
{
    return value * ::pow(friction, dt);
}

double MathUtilities::Factorial(double n)
{
    if (n == 0)
        return 1;
    
    double factorial = 1;
    double nextFactor = 1;
    
    while (nextFactor <= n)
    {
        factorial *= nextFactor;
        nextFactor++;
    }
    
    return factorial;
}

double MathUtilities::GetFriction(double startVelocity, double endVelocity, double maxDuration, double dt)
{
    if (startVelocity == endVelocity ||
        maxDuration <= dt)
        return 1.0;
    if (endVelocity > startVelocity ||
        endVelocity < 0.0 ||
        startVelocity < 0.0)
        return 0;
    
    double tolerence   = .00001;
    double lowFriction = .0001;
    double highFriction = 1.0 - lowFriction;
    int desiredCount = (int)::floor(maxDuration / dt);
    
    // test highFriction point
    int highCount = GetFrictionCount(startVelocity, endVelocity, highFriction, dt);
    if (highCount == desiredCount)
        return highFriction;
    
    // test lowFrition point
    int lowCount = GetFrictionCount(startVelocity, endVelocity, lowFriction, dt);
    if (lowCount == desiredCount)
        return lowFriction;
    
    // TODO fix this so that the friction returned is the average
    // of the highest and the lowest frictions that
    while ((highFriction - lowFriction) > tolerence)
    {
        double testFriction = (highFriction - lowFriction) / 2.0 + lowFriction;
        int testCount = GetFrictionCount(startVelocity, endVelocity, testFriction, dt);
        if (testCount == desiredCount)
            return testFriction;
        
        if (testCount < desiredCount)
        {
            lowCount = testCount;
            lowFriction = testFriction;
        }
        else
        {
            highCount = testCount;
            highFriction = testFriction;
        }
    }
    
    return 0.0;
}

int MathUtilities::GetFrictionCount(double startVelocity, double endVelocity, double friction, double dt)
{
    int count = 0;
    while (startVelocity > endVelocity)
    {
        startVelocity = ApplyFriction(startVelocity, friction, dt);
        count++;
    }
    return count;
}

void MathUtilities::GetOrdinalString(int number, std::string ordinalNumber)
{
    if (number <= 0)
    {
        ordinalNumber = "";
        return;
    }
    
    std::stringstream ss;
    ss << number;
    switch (number % 100)
    {
		case 11:
		case 12:
		case 13:
		{
            ordinalNumber = ss.str() + "th";
			return;
		}
    }
    
    if (((number - 11) % 100 != 0) &&
        ((number - 1) % 10 == 0))
        ordinalNumber = ss.str() + "st";
    else if (((number - 12) % 100 != 0) &&
             ((number - 2) % 10 == 0))
        ordinalNumber = ss.str() + "nd";
    else if (((number - 13) % 100 != 0) &&
             ((number - 3) % 10 == 0))
        ordinalNumber = ss.str() + "rd";
    else
        ordinalNumber = ss.str() + "th";
}

int MathUtilities::GetProbability(int numberOfMatchingRolls,
                                    int totalNumberOfRolls,
                                    bool bBidIsWildValue,
                                    bool bWildOneUsedThisRound)
{
    //TODO is this actually useful?  If not remove.
    bool bProbabilityExactlyZero = true;
    
    // if there are no die needed and the player
    // has all the die necessary to meet the
    // number of die needed for a given bid.
    // return 100 percent
    if (numberOfMatchingRolls < 1)
        return 100;
    
    // probability calculations
    double probabilityOfRoll = 0.0;
    // probability variables
    double n = (double)totalNumberOfRolls;
    
    double p = 1.0 / 6.0;
    if (bWildOneUsedThisRound && !bBidIsWildValue)
        p += 1.0 / 6.0;
    
    double nFactorial = MathUtilities::Factorial(n);
    // I would prefer to use a for loop of double here
    // why have I never seen a for loop of doubles?
    for (int iDieCount = numberOfMatchingRolls; iDieCount <= totalNumberOfRolls; iDieCount++)
    {
        double q = (double)iDieCount;
        double binomialCoefficient = nFactorial / (MathUtilities::Factorial(q) * MathUtilities::Factorial(n - q));
        
        probabilityOfRoll += binomialCoefficient * pow(p, q) * pow((1 - p), n - q);
    }
    
    // adjust to integer percent
    int returnValue = 0;
    // if the probability is 0.x percent, then flooring the
    // value will present user with 0% likelihood.  In display
    // this should be ~0.0% or maybe < 1.0%.  Set flag accordingly
    if (probabilityOfRoll < 0.01)
        bProbabilityExactlyZero = false;
    else
        returnValue = (int)floor(probabilityOfRoll * 100.0);
    
    return returnValue;
}


double MathUtilities::HaversinceDistance(double lonDegrees1, double latDegrees1, double lonDegrees2, double latDegrees2, double radius)
{
    double degreesToRadians = 0.01745329238;
    
    double lonArcRadians = (lonDegrees1 - lonDegrees2) * degreesToRadians;
    double latArcRadians = (latDegrees1 - latDegrees2) * degreesToRadians;
    
    double lonHaversine = pow(sin(lonArcRadians * .5), 2);
    double latHaversine = pow(sin(latArcRadians * .5), 2);
    
    double cosOfLats = cos(latDegrees1 * degreesToRadians) * cos(latDegrees2 * degreesToRadians);
    
    double arcValue = 2.0 * asin(sqrt(latHaversine + cosOfLats * lonHaversine));
    
    return 6372797.560856 * arcValue;
}
