//
//  Player.cpp
//  NativeEngine
//
//  Created by David Raleigh on 9/5/12.
//  Copyright (c) 2012 NA. All rights reserved.
//
#include "Player.h"

#include <iostream>
#include <json/json.h>

Player::Player()
{
    _InitEmpty();
}

Player::Player(Player *player)
{
    m_playerUID = player->m_playerUID;
    m_playerName = player->m_playerName;
    m_bInactive = player->m_bInactive;
    
    m_playerType = player->m_playerType;

    m_gameDicePosition = player->m_gameDicePosition;
    m_roundCount = player->m_roundCount;
    m_roundDice = player->m_roundDice;
    m_gameDice = player->m_gameDice;

    m_playerBidQualities = player->m_playerBidQualities;
    m_playerChallengeQualities = player->m_playerChallengeQualities;
}

Player::Player(std::shared_ptr<Player> player)
{
    m_playerUID = player->m_playerUID;
    m_playerName = player->m_playerName;
    m_bInactive = player->m_bInactive;
    
    m_playerType = player->m_playerType;
    
    m_gameDicePosition = player->m_gameDicePosition;
    m_roundCount = player->m_roundCount;
    m_roundDice = player->m_roundDice;
    m_gameDice = player->m_gameDice;
    
    m_playerBidQualities = player->m_playerBidQualities;
    m_playerChallengeQualities = player->m_playerChallengeQualities;
}

Player::Player(const std::string name, unsigned int playerUID, bool playsOnThisClient, bool isAI )
{
    if (playerUID == 0 || name.length() == 0)
    {
        _InitEmpty();
        return;
    }
    
    if (playsOnThisClient)
        m_playerType = Player::Local;
    else if (!playsOnThisClient)
        m_playerType = Player::Remote;
    if (isAI)
        m_playerType = Player::UndefinedAI;
    
    m_bInactive = false;
    m_playerName = name;
    m_playerUID = playerUID;
    m_gameDicePosition = 0;
    m_roundCount = 0;
}

// TODO complete implementation.
Player::Player(const std::string name, const std::string jsonPlayerQualities, unsigned int playerUID, bool playsOnThisClient, bool isAI)
{
    if (playerUID == 0 || name.length() == 0)
    {
        _InitEmpty();
        return;
    }
    if (playsOnThisClient)
        m_playerType = Player::Local;
    else if (!playsOnThisClient)
        m_playerType = Player::Remote;
    else
        m_playerType = Player::Undefined;
    
    m_bInactive = false;
    m_playerName = name;
    m_playerUID = playerUID;
    m_gameDicePosition = 0;
    m_roundCount = 0;
}

Player::Player(const Json::Value &playerObject)
{
    Json::Value defaultValue;
    
    m_playerType = Player::Undefined;
    m_playerUID  = playerObject.get("playerUID", defaultValue).asUInt();
    m_playerName.append(playerObject.get("playerName", defaultValue).asString());
    Json::Value playerQualities = playerObject.get("playerQualities", defaultValue);
    _ParsePlayerQualities(playerQualities);
}

Player::~Player()
{
    m_playerUID = 0;
}

void Player::_InitEmpty()
{
    m_playerUID = 0;
    m_playerName = "";
    m_playerType = Player::Undefined;
    m_bInactive = true;
    m_gameDicePosition = 0;
    m_roundCount = 0;
}

void Player::_ParseBidQualities(const Json::Value &bidQualitiesObject)
{
    Json::Value defaultValue;
    
    //int totalBids = bidQualities.get("totalBids", defaultValue).asInt();
    Json::Value percentChanceOfBid = bidQualitiesObject.get("percentChanceOfBid", defaultValue);
    Json::Value weakLyingOccurences = bidQualitiesObject.get("weakLyingOccurences", defaultValue);
    Json::Value strongLyingOccurences = bidQualitiesObject.get("strongLyingOccurences", defaultValue);
    Json::Value totalOccurences = bidQualitiesObject.get("totalOccurences", defaultValue);
    
    for (int i = 0; i < percentChanceOfBid.size(); i++)
    {
        bid_qualities_t bidQualities;
        bidQualities.percentChanceOfBid = percentChanceOfBid.get(i, defaultValue).asInt();
        bidQualities.weakLyingOccurences = weakLyingOccurences.get(i, defaultValue).asInt();
        bidQualities.strongLyingOccurences = strongLyingOccurences.get(i, defaultValue).asInt();
        bidQualities.totalOccurences = totalOccurences.get(i, defaultValue).asInt();
        bidQualities.isInterpolated = false;
        
        m_playerBidQualities[bidQualities.percentChanceOfBid] = bidQualities;
    }
}

void Player::_ParseChallengeQualities(const Json::Value &challengeQualitiesObject)
{
    Json::Value defaultValue;
    
    //int totalChallenges = challengeQualities.get("totalChallenges", defaultValue).asInt();
    Json::Value percentChanceOfBid = challengeQualitiesObject.get("percentChanceOfBid",defaultValue);
    Json::Value challengeOccurences = challengeQualitiesObject.get("challengeOccurences",defaultValue);
    Json::Value challengeSuccesses = challengeQualitiesObject.get("challengeSuccesses", defaultValue);
    Json::Value totalOccurences = challengeQualitiesObject.get("totalOccurences",defaultValue);
    
    for (int i = 0; i < percentChanceOfBid.size(); i++)
    {
        challenge_qualities_t challengeQualities;
        challengeQualities.percentChanceOfBid = percentChanceOfBid.get(i, defaultValue).asInt();
        challengeQualities.challengeOccurences = challengeOccurences.get(i, defaultValue).asInt();
        challengeQualities.challengeSuccesses = challengeSuccesses.get(i, defaultValue).asInt();
        challengeQualities.totalOccurences = totalOccurences.get(i, defaultValue).asInt();
        challengeQualities.isInterpolated = false;
        
        m_playerChallengeQualities[challengeQualities.percentChanceOfBid] = challengeQualities;
    }
}

void Player::_ParsePlayerQualities(const Json::Value &jsonPlayerQualities)
{
    Json::Value defaultValue;
    
    Json::Value bidQualities = jsonPlayerQualities.get("bidQualities", defaultValue);
    _ParseBidQualities(bidQualities);
    
    Json::Value challengeQualities = jsonPlayerQualities.get("challengeQualities", defaultValue);
    _ParseChallengeQualities(challengeQualities);
}

bool Player::FillGameDice(const std::shared_ptr<PseudoRandom> &randomGenerator, int numberOfCompetitors, int numberOfDice)
{
    // This should only be called once a game
    if (m_gameDice.size() > 0 ||
        numberOfCompetitors < 2 ||
        numberOfDice < 1 ||
        m_playerUID == 0)
        return false;
    
    if (m_playerType > Player::Remote)
    {
        int randomSelection = randomGenerator->GetRandomFromRange(0, 2);
        if (randomSelection == 0)
            m_playerType = Player::HonestAI;
        else if (randomSelection == 1)
            m_playerType = Player::LiarAI;
    }

    m_roundDice.resize(numberOfDice, -1);
    // This is all a bit ridiculous, but whatever.  One player in the game could
    // have all his dice for as many rounds as (numberOfCompetitors - 1) * numberOfDice
    //    int totalRandomDice = (numberOfCompetitors - 1) * numberOfDice * numberOfDice;
    // After that the only the way the game is continuing is if the player with all 
    // his dice is losing one every round.
    // (n * (n + 1) ) / 2
    //    totalRandomDice += (m_roundDice.size() * (m_roundDice.size() + 1)) / 2;
    // So totalRandomDice is the highest number of random dice that any player
    // might ever see in a round.  That means if I'm syncing all the games by 
    // seeded pseudo random numbers I need to provide all the random dice up front
    // But reall the best thing to do is just provide too many dice, in case my 
    // calculations are wrong.  no point in potentially introducing a bug that
    // doesn't provide any real performance benefit.
    int totalRandomDice = numberOfDice * numberOfDice * numberOfCompetitors;
    m_gameDice = randomGenerator->GetDiceValue(totalRandomDice);
    return true;
}



int Player::GetDieFaceValue(int index)
{
    if (m_roundDice.size() == 0 ||
        index >= m_roundDice.size() ||
        index < 0)
        return 0;
    return m_roundDice[index];
}

int Player::GetFaceValueCount(int faceValue)
{
    int count = 0;
    std::vector<int>::iterator iter;
    for (iter = m_roundDice.begin(); iter != m_roundDice.end(); iter++)
        if (*iter == faceValue)
            count++;
    
    return count;
}

std::vector<int> Player::GetPlayerDice()
{
    // TODO check that '=' operator copies the content
    // and passes a new pointer or if it just passes
    // the original
    std::vector<int> roundDice(m_roundDice);
    return roundDice;
}

void Player::RemoveDie()
{
    if(m_roundDice.size() > 0)
        m_roundDice.pop_back();
}

void Player::ResetDice()
{
    m_gameDicePosition = 0;
    m_roundCount = 0;
    m_roundDice.clear();
    m_gameDice.clear();
}

bool Player::Roll()
{
    if (m_playerUID == 0 ||
        m_gameDice.size() == 0 ||
        m_roundDice.size() == 0 ||
        m_gameDicePosition >= m_gameDice.size())
        return false;
    
    // TODO maybe use STL copy?
    for (int i = 0; i < m_roundDice.size(); i++)
    {
        m_roundDice[i] = m_gameDice[m_gameDicePosition++];
    }
    //sort (m_roundDice.begin(), m_roundDice.end());
    m_roundCount++;
    // copy the current round's dice into the history map
    m_roundHistory[m_roundCount] = m_roundDice;
    return true;
}

void Player::SetAsInactive()
{
    m_bInactive = true;
}




//int Player::GetStrongLyingPercent(int tableBidPercent)
//{
//    std::map<int, bid_qualities_t>::iterator iter = m_playerBidQualities.find(tableBidPercent);
//    if (iter != m_playerBidQualities.end())
//    {
//        
//    }
//    
//}

