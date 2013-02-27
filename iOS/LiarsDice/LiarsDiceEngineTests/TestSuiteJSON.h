//
//  TestSuiteJSON.h
//  NativeEngine
//
//  Created by David Raleigh on 9/6/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#ifndef NativeEngine_TestSuiteJSON_h
#define NativeEngine_TestSuiteJSON_h

#include <cxxtest/TestSuite.h>

class MyTestSuite1 : public CxxTest::TestSuite
{
public:
    void testAddition(void)
    {
        TS_ASSERT(1 + 1 > 1);
        TS_ASSERT_EQUALS(1 + 1, 2);
    }
};

#endif
