/* Generated file, do not edit */

#ifndef CXXTEST_RUNNING
#define CXXTEST_RUNNING
#endif

#include <fstream>
#define _CXXTEST_HAVE_STD
#include <cxxtest/TestListener.h>
#include <cxxtest/TestTracker.h>
#include <cxxtest/TestRunner.h>
#include <cxxtest/RealDescriptions.h>
#include <cxxtest/TestMain.h>
#include <cxxtest/XUnitPrinter.h>

int main( int argc, char *argv[] ) {
 int status;
    std::ofstream ofstr("/Users/davidraleigh/Documents/Code/MobileProjects/LiarsDiceClient/iOS/LiarsDice/LiarsDiceEngineTests/LiarsDice_TestResults.xml");
    CxxTest::XUnitPrinter tmp(ofstr);
    CxxTest::RealWorldDescription::_worldName = "cxxtest";
    status = CxxTest::Main<CxxTest::XUnitPrinter>( tmp, argc, argv );
    return status;
}
bool suite_GamePlayersTestSuite_init = false;
#include "TestGamePlayers.h"

static GamePlayersTestSuite suite_GamePlayersTestSuite;

static CxxTest::List Tests_GamePlayersTestSuite = { 0, 0 };
CxxTest::StaticSuiteDescription suiteDescription_GamePlayersTestSuite( "/Users/davidraleigh/Documents/Code/MobileProjects/LiarsDiceClient/iOS/LiarsDice/LiarsDiceEngineTests/TestGamePlayers.h", 16, "GamePlayersTestSuite", suite_GamePlayersTestSuite, Tests_GamePlayersTestSuite );

static class TestDescription_suite_GamePlayersTestSuite_testGamePlayer : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_GamePlayersTestSuite_testGamePlayer() : CxxTest::RealTestDescription( Tests_GamePlayersTestSuite, suiteDescription_GamePlayersTestSuite, 19, "testGamePlayer" ) {}
 void runTest() { suite_GamePlayersTestSuite.testGamePlayer(); }
} testDescription_suite_GamePlayersTestSuite_testGamePlayer;

static class TestDescription_suite_GamePlayersTestSuite_testClientUIDs : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_GamePlayersTestSuite_testClientUIDs() : CxxTest::RealTestDescription( Tests_GamePlayersTestSuite, suiteDescription_GamePlayersTestSuite, 128, "testClientUIDs" ) {}
 void runTest() { suite_GamePlayersTestSuite.testClientUIDs(); }
} testDescription_suite_GamePlayersTestSuite_testClientUIDs;

#include "TestLiarsDiceEngine.h"

static LiarsDiceEngineTestSuite suite_LiarsDiceEngineTestSuite;

static CxxTest::List Tests_LiarsDiceEngineTestSuite = { 0, 0 };
CxxTest::StaticSuiteDescription suiteDescription_LiarsDiceEngineTestSuite( "/Users/davidraleigh/Documents/Code/MobileProjects/LiarsDiceClient/iOS/LiarsDice/LiarsDiceEngineTests/TestLiarsDiceEngine.h", 18, "LiarsDiceEngineTestSuite", suite_LiarsDiceEngineTestSuite, Tests_LiarsDiceEngineTestSuite );

static class TestDescription_suite_LiarsDiceEngineTestSuite_testLiarsDiceEngine : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_LiarsDiceEngineTestSuite_testLiarsDiceEngine() : CxxTest::RealTestDescription( Tests_LiarsDiceEngineTestSuite, suiteDescription_LiarsDiceEngineTestSuite, 34, "testLiarsDiceEngine" ) {}
 void runTest() { suite_LiarsDiceEngineTestSuite.testLiarsDiceEngine(); }
} testDescription_suite_LiarsDiceEngineTestSuite_testLiarsDiceEngine;

static class TestDescription_suite_LiarsDiceEngineTestSuite_testDestructor : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_LiarsDiceEngineTestSuite_testDestructor() : CxxTest::RealTestDescription( Tests_LiarsDiceEngineTestSuite, suiteDescription_LiarsDiceEngineTestSuite, 48, "testDestructor" ) {}
 void runTest() { suite_LiarsDiceEngineTestSuite.testDestructor(); }
} testDescription_suite_LiarsDiceEngineTestSuite_testDestructor;

#include "TestLiarsDiceREST.h"

static LiarsDiceRESTTestSuite suite_LiarsDiceRESTTestSuite;

static CxxTest::List Tests_LiarsDiceRESTTestSuite = { 0, 0 };
CxxTest::StaticSuiteDescription suiteDescription_LiarsDiceRESTTestSuite( "/Users/davidraleigh/Documents/Code/MobileProjects/LiarsDiceClient/iOS/LiarsDice/LiarsDiceEngineTests/TestLiarsDiceREST.h", 15, "LiarsDiceRESTTestSuite", suite_LiarsDiceRESTTestSuite, Tests_LiarsDiceRESTTestSuite );

static class TestDescription_suite_LiarsDiceRESTTestSuite_testUserNameUpdate : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_LiarsDiceRESTTestSuite_testUserNameUpdate() : CxxTest::RealTestDescription( Tests_LiarsDiceRESTTestSuite, suiteDescription_LiarsDiceRESTTestSuite, 26, "testUserNameUpdate" ) {}
 void runTest() { suite_LiarsDiceRESTTestSuite.testUserNameUpdate(); }
} testDescription_suite_LiarsDiceRESTTestSuite_testUserNameUpdate;

#include "TestPlayer.h"

static PlayerTestSuite suite_PlayerTestSuite;

static CxxTest::List Tests_PlayerTestSuite = { 0, 0 };
CxxTest::StaticSuiteDescription suiteDescription_PlayerTestSuite( "/Users/davidraleigh/Documents/Code/MobileProjects/LiarsDiceClient/iOS/LiarsDice/LiarsDiceEngineTests/TestPlayer.h", 16, "PlayerTestSuite", suite_PlayerTestSuite, Tests_PlayerTestSuite );

static class TestDescription_suite_PlayerTestSuite_testPlayerEmpty : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_PlayerTestSuite_testPlayerEmpty() : CxxTest::RealTestDescription( Tests_PlayerTestSuite, suiteDescription_PlayerTestSuite, 32, "testPlayerEmpty" ) {}
 void runTest() { suite_PlayerTestSuite.testPlayerEmpty(); }
} testDescription_suite_PlayerTestSuite_testPlayerEmpty;

static class TestDescription_suite_PlayerTestSuite_testRollTotal : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_PlayerTestSuite_testRollTotal() : CxxTest::RealTestDescription( Tests_PlayerTestSuite, suiteDescription_PlayerTestSuite, 57, "testRollTotal" ) {}
 void runTest() { suite_PlayerTestSuite.testRollTotal(); }
} testDescription_suite_PlayerTestSuite_testRollTotal;

static class TestDescription_suite_PlayerTestSuite_testPlayerNoQualities : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_PlayerTestSuite_testPlayerNoQualities() : CxxTest::RealTestDescription( Tests_PlayerTestSuite, suiteDescription_PlayerTestSuite, 75, "testPlayerNoQualities" ) {}
 void runTest() { suite_PlayerTestSuite.testPlayerNoQualities(); }
} testDescription_suite_PlayerTestSuite_testPlayerNoQualities;

#include "TestPlayersInLobby.h"

static PlayersInLobbyTestSuite suite_PlayersInLobbyTestSuite;

static CxxTest::List Tests_PlayersInLobbyTestSuite = { 0, 0 };
CxxTest::StaticSuiteDescription suiteDescription_PlayersInLobbyTestSuite( "/Users/davidraleigh/Documents/Code/MobileProjects/LiarsDiceClient/iOS/LiarsDice/LiarsDiceEngineTests/TestPlayersInLobby.h", 16, "PlayersInLobbyTestSuite", suite_PlayersInLobbyTestSuite, Tests_PlayersInLobbyTestSuite );

static class TestDescription_suite_PlayersInLobbyTestSuite_testEmptyLobby : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_PlayersInLobbyTestSuite_testEmptyLobby() : CxxTest::RealTestDescription( Tests_PlayersInLobbyTestSuite, suiteDescription_PlayersInLobbyTestSuite, 20, "testEmptyLobby" ) {}
 void runTest() { suite_PlayersInLobbyTestSuite.testEmptyLobby(); }
} testDescription_suite_PlayersInLobbyTestSuite_testEmptyLobby;

static class TestDescription_suite_PlayersInLobbyTestSuite_testStartup : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_PlayersInLobbyTestSuite_testStartup() : CxxTest::RealTestDescription( Tests_PlayersInLobbyTestSuite, suiteDescription_PlayersInLobbyTestSuite, 41, "testStartup" ) {}
 void runTest() { suite_PlayersInLobbyTestSuite.testStartup(); }
} testDescription_suite_PlayersInLobbyTestSuite_testStartup;

#include "TestPseudoRandom.h"

static PseudoRandomTestSuite suite_PseudoRandomTestSuite;

static CxxTest::List Tests_PseudoRandomTestSuite = { 0, 0 };
CxxTest::StaticSuiteDescription suiteDescription_PseudoRandomTestSuite( "/Users/davidraleigh/Documents/Code/MobileProjects/LiarsDiceClient/iOS/LiarsDice/LiarsDiceEngineTests/TestPseudoRandom.h", 16, "PseudoRandomTestSuite", suite_PseudoRandomTestSuite, Tests_PseudoRandomTestSuite );

static class TestDescription_suite_PseudoRandomTestSuite_testDestructor : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_PseudoRandomTestSuite_testDestructor() : CxxTest::RealTestDescription( Tests_PseudoRandomTestSuite, suiteDescription_PseudoRandomTestSuite, 19, "testDestructor" ) {}
 void runTest() { suite_PseudoRandomTestSuite.testDestructor(); }
} testDescription_suite_PseudoRandomTestSuite_testDestructor;

#include "TestSuiteBinoCDF.h"

static MyTestSuite2 suite_MyTestSuite2;

static CxxTest::List Tests_MyTestSuite2 = { 0, 0 };
CxxTest::StaticSuiteDescription suiteDescription_MyTestSuite2( "/Users/davidraleigh/Documents/Code/MobileProjects/LiarsDiceClient/iOS/LiarsDice/LiarsDiceEngineTests/TestSuiteBinoCDF.h", 17, "MyTestSuite2", suite_MyTestSuite2, Tests_MyTestSuite2 );

static class TestDescription_suite_MyTestSuite2_testBinoCDF_1 : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_MyTestSuite2_testBinoCDF_1() : CxxTest::RealTestDescription( Tests_MyTestSuite2, suiteDescription_MyTestSuite2, 54, "testBinoCDF_1" ) {}
 void runTest() { suite_MyTestSuite2.testBinoCDF_1(); }
} testDescription_suite_MyTestSuite2_testBinoCDF_1;

#include "TestSuiteGameStartup.h"

static GameStartupTestSuite suite_GameStartupTestSuite;

static CxxTest::List Tests_GameStartupTestSuite = { 0, 0 };
CxxTest::StaticSuiteDescription suiteDescription_GameStartupTestSuite( "/Users/davidraleigh/Documents/Code/MobileProjects/LiarsDiceClient/iOS/LiarsDice/LiarsDiceEngineTests/TestSuiteGameStartup.h", 18, "GameStartupTestSuite", suite_GameStartupTestSuite, Tests_GameStartupTestSuite );

static class TestDescription_suite_GameStartupTestSuite_testAddPlayers : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_GameStartupTestSuite_testAddPlayers() : CxxTest::RealTestDescription( Tests_GameStartupTestSuite, suiteDescription_GameStartupTestSuite, 21, "testAddPlayers" ) {}
 void runTest() { suite_GameStartupTestSuite.testAddPlayers(); }
} testDescription_suite_GameStartupTestSuite_testAddPlayers;

static class TestDescription_suite_GameStartupTestSuite_testDeviceDetails : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_GameStartupTestSuite_testDeviceDetails() : CxxTest::RealTestDescription( Tests_GameStartupTestSuite, suiteDescription_GameStartupTestSuite, 184, "testDeviceDetails" ) {}
 void runTest() { suite_GameStartupTestSuite.testDeviceDetails(); }
} testDescription_suite_GameStartupTestSuite_testDeviceDetails;

static class TestDescription_suite_GameStartupTestSuite_testAddition : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_GameStartupTestSuite_testAddition() : CxxTest::RealTestDescription( Tests_GameStartupTestSuite, suiteDescription_GameStartupTestSuite, 202, "testAddition" ) {}
 void runTest() { suite_GameStartupTestSuite.testAddition(); }
} testDescription_suite_GameStartupTestSuite_testAddition;

#include "TestSuiteJSON.h"

static MyTestSuite1 suite_MyTestSuite1;

static CxxTest::List Tests_MyTestSuite1 = { 0, 0 };
CxxTest::StaticSuiteDescription suiteDescription_MyTestSuite1( "/Users/davidraleigh/Documents/Code/MobileProjects/LiarsDiceClient/iOS/LiarsDice/LiarsDiceEngineTests/TestSuiteJSON.h", 14, "MyTestSuite1", suite_MyTestSuite1, Tests_MyTestSuite1 );

static class TestDescription_suite_MyTestSuite1_testAddition : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_MyTestSuite1_testAddition() : CxxTest::RealTestDescription( Tests_MyTestSuite1, suiteDescription_MyTestSuite1, 17, "testAddition" ) {}
 void runTest() { suite_MyTestSuite1.testAddition(); }
} testDescription_suite_MyTestSuite1_testAddition;

#include "TestUtilities.h"

static UtilitiesTestSuite suite_UtilitiesTestSuite;

static CxxTest::List Tests_UtilitiesTestSuite = { 0, 0 };
CxxTest::StaticSuiteDescription suiteDescription_UtilitiesTestSuite( "/Users/davidraleigh/Documents/Code/MobileProjects/LiarsDiceClient/iOS/LiarsDice/LiarsDiceEngineTests/TestUtilities.h", 17, "UtilitiesTestSuite", suite_UtilitiesTestSuite, Tests_UtilitiesTestSuite );

static class TestDescription_suite_UtilitiesTestSuite_testStringContains : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_UtilitiesTestSuite_testStringContains() : CxxTest::RealTestDescription( Tests_UtilitiesTestSuite, suiteDescription_UtilitiesTestSuite, 29, "testStringContains" ) {}
 void runTest() { suite_UtilitiesTestSuite.testStringContains(); }
} testDescription_suite_UtilitiesTestSuite_testStringContains;

static class TestDescription_suite_UtilitiesTestSuite_testCapitalization : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_UtilitiesTestSuite_testCapitalization() : CxxTest::RealTestDescription( Tests_UtilitiesTestSuite, suiteDescription_UtilitiesTestSuite, 48, "testCapitalization" ) {}
 void runTest() { suite_UtilitiesTestSuite.testCapitalization(); }
} testDescription_suite_UtilitiesTestSuite_testCapitalization;

static class TestDescription_suite_UtilitiesTestSuite_testStringIsInteger : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_UtilitiesTestSuite_testStringIsInteger() : CxxTest::RealTestDescription( Tests_UtilitiesTestSuite, suiteDescription_UtilitiesTestSuite, 65, "testStringIsInteger" ) {}
 void runTest() { suite_UtilitiesTestSuite.testStringIsInteger(); }
} testDescription_suite_UtilitiesTestSuite_testStringIsInteger;

static class TestDescription_suite_UtilitiesTestSuite_testApplyFriction : public CxxTest::RealTestDescription {
public:
 TestDescription_suite_UtilitiesTestSuite_testApplyFriction() : CxxTest::RealTestDescription( Tests_UtilitiesTestSuite, suiteDescription_UtilitiesTestSuite, 78, "testApplyFriction" ) {}
 void runTest() { suite_UtilitiesTestSuite.testApplyFriction(); }
} testDescription_suite_UtilitiesTestSuite_testApplyFriction;

#include <cxxtest/Root.cpp>
const char* CxxTest::RealWorldDescription::_worldName = "cxxtest";
