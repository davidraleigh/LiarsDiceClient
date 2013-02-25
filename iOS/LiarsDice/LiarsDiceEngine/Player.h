//
//  Player.h
//  NativeEngine
//
//  Created by David Raleigh on 9/5/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#ifndef NativeEngine_Player_h
#define NativeEngine_Player_h
#include "PseudoRandom.h"
#include "Round.h"

#include <vector>
#include <map>

// forward declarations
namespace Json {
    class Value ;
}

/**
 * 
 */
class Player
{
    struct bid_qualities_t
    {
        int percentChanceOfBid;
        
        // distribution of bids likelihood at the table
        // vs. the percentage of times the player has
        // lied to the table about bid (bid something not
        // in his or her hand)
        int weakLyingOccurences;
        
        // strong lying is like m_lyingHistogram, but in this
        // case the player is a bidding something from his hand
        // it just isn't the strongest bid in his hand
        int strongLyingOccurences;
        int totalOccurences;
        bool isInterpolated;
        
    };
    
    struct challenge_qualities_t
    {
        int percentChanceOfBid;
        
        int challengeOccurences;
        int challengeSuccesses;
        int totalOccurences;
        bool isInterpolated;
    };
    
public:

    enum PlayerType
    {
        Undefined  = 0,
        Local = 1,
        Remote  = 2,
        UndefinedAI = 4,
        HonestAI = 8,
        LiarAI  = 16
    };
    
    /**
     * empty constructor
     */
    Player();

    /**
     * Copy constructor for use with vector, map, etc
     */
    Player(Player *player);
    
    Player(std::shared_ptr<Player> player);

    /**
     * Construct a player from it's uid, name, qualities and whether
     * or not it's on this local machine
     */
    Player(const std::string name, unsigned int playerUID, bool playsOnThisClient, bool isAI);
    
    /**
     * Construct a player from it's uid, name, qualities and whether
     * or not it's on this local machine
     */
    Player(const std::string name, const std::string jsonPlayerQualities, unsigned int playerUID, bool playsOnThisClient, bool isAI);
    
    /**
     * Allows construction of player objects from
     * jsonString.  If a player is contructed from a
     * jsonString then the player is not on this local client
     */
    Player(const Json::Value &playerObject);
    
    ~Player();
    
    bool FillGameDice(const std::shared_ptr<PseudoRandom> &randomGenerator, int numberOfCompetitors, int numberOfDice);

    /**
     * Get the number of dice held by this player
     * @return dice count
     */
    inline int GetDiceCount() { return (int)m_roundDice.size(); };
    
    int GetDieFaceValue(int index);
    
    int GetFaceValueCount(int faceValue);
    
    /**
     * Get game position
     */
    inline int GetGameDicePosition() { return m_gameDicePosition; };
    
    /**
     * Get a sorted vector of the player's current dice
     */
    std::vector<int> GetPlayerDice();
    
    /**
     * Get the player's name
     */
    inline const std::string GetPlayerName() {return m_playerName; }; //Tested
    
    /**
     * Get player type
     */
    inline Player::PlayerType GetPlayerType() {return m_playerType; };
    
    /**
     * Get the player's unique ID number
     */
    inline unsigned int GetPlayerUID() {return m_playerUID; } ;
    
    /**
     * Get the current round number
     */
    inline int GetRoundNumber() { return m_roundCount; };
    
    /**
     * if the player is inactive (on phone, etc) return true
     */
    inline bool IsInactive() { return m_bInactive; };
    
    /**
     * if player is on this client return true, if player
     * is on another client (different phone, etc.) then 
     * return false;
     */
    inline bool IsPlayerOnThisDevice() { return (m_playerType == Player::Local); };
    
    
    /**
     * remove a players die
     */
    void RemoveDie();
    
    /**
     * Reset the player's dice, round count and dice count 
     * for another gamge
     */
    void ResetDice();
    
    /**
     * Roll the dice for the player.  There is no call to random
     * as all the random dice for a game have already been 
     * placed in an array by FillGameDice.  Roll() merely queues
     * up the next roll's worth of dice.
     * @return if the Player object isn't properly initialized returns false
     */
    bool Roll();
    
    /**
     * Set a player as inactive
     */
    void SetAsInactive();
    
//    int GetWeakLyingPercent(int tableBidPercent);
//    int GetStrongLyingPercent(int tableBidPercent);
    
    // ONLY UPDATE DATA AT END OF ROUND
//    void AddLyingData(int tableBidPercent, bool bLieWasWeak);
    
    

private:
    
    bool m_bInactive;
    PlayerType m_playerType;
    unsigned int m_playerUID;
    /**
     * used for pointing to the position of the last
     * die used from game dice
     */
    int m_gameDicePosition;
    /**
     * current round of the player
     */
    int m_roundCount;
    /**
     *
     */
    std::string m_playerName;
    std::vector<int> m_gameDice;
    std::vector<int> m_roundDice;
    std::map<int, std::vector<int>> m_roundHistory;
    std::map<int, bid_qualities_t> m_playerBidQualities;
    std::map<int, challenge_qualities_t> m_playerChallengeQualities;
    
    void _InitEmpty();
    void _ParsePlayerQualities(const Json::Value &jsonPlayerQualities);
    void _ParseBidQualities(const Json::Value &bidQualities);
    void _ParseChallengeQualities(const Json::Value &challengeQualities);

    
};


#endif
