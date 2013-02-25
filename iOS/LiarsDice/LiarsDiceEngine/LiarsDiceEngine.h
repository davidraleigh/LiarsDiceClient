//
//  LiarsDiceEngine.h
//  NativeEngine
//
//  Created by David Raleigh on 9/5/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#ifndef NativeEngine_LiarsDiceEngine_h
#define NativeEngine_LiarsDiceEngine_h

#include "PseudoRandom.h"
#include "Round.h"

#include <vector>
#include <deque>
#include <map>


class LiarsDiceEngine
{
    
public:
    /**
     * Create a game of LiarsDiceEngine.  This is only good for one complete
     * game.  After game completion a new LiarsDiceEngine game must be created
     * to play again.
     * @param players is map of the player ids and the associated names.
     * the map is ordered by gameplay order
     * @param numberOfDicePerPlayer is the number of dice each player starts with
     * @param bOnesWild determines whether or not bidding face value of 1 at
     * the beginning of the round changes the
     */
    //    LiarsDiceEngine(std::map<int, std::string> players, int numberOfDicePerPlayer, bool bOnesWild, unsigned int seed);
    //LiarsDiceEngine(const std::string playersJSON, int numberOfDicePerPlayer, bool bOnesWild, unsigned int seed);
    LiarsDiceEngine(int numberOfDicePerPlayer, bool bOnesWild, unsigned int seed);
    LiarsDiceEngine();
    ~LiarsDiceEngine();
    
    //    static std::map<int, std::string> GetPlayersFromJSON(const std::string playersJSON);
    
    /**
	 * Player Bids the number of dice they believe are in the game
	 * and the face value associated with those dice.
	 * @param bidQuantity
	 * @param bidValue
	 * @return true if Bid is acceptable, false if you're a fuckup
	 */
	bool Bid(int bidQuantity, int bidFaceValue);
    
    /**
	 * If a player chooses to challenge the previous players
	 * bid then count all the occurrences of the previous players
	 * bid.
	 *
	 * Calls PlayerLosesDie method
	 * Sets next player id for next round.
	 * @return player id of the winner of the challenge
	 */
	unsigned int Challenge();
    
    RoundDetails::bid_t GenerateAIBid(unsigned int playerUID);
    
    RoundDetails::bid_t GenerateHonestAIBid(unsigned int playerUID);
    
    RoundDetails::bid_t GenerateLiarAIBid(unsigned int playerUID);
    
    /**
	 * Get the array of all the active players still in game
	 * @return playerIDs of all active participants
	 */
    std::vector<unsigned int> GetAllActivePlayers();
    
    /**
     * Get the bid struct from the current round
     * @param bidIndex is a 0 based stack.  the last bid in is the 
     * 0th bid in the array.  the first bid is the size()-1th index
     * @return the bid struct that has the playerUID, the quantity and facevalue
     */
    RoundDetails::bid_t GetBid(int bidIndex);
    
    /**
     * Get the bid struct from the current round
     * @param bidIndex is a 0 based stack.  the last bid in is the
     * 0th bid in the array.  the first bid is the size()-1th index
     * @param roundNumber. The ordinal round number of the game
     * @return the bid struct that has the playerUID, the quantity and facevalue
     */
    RoundDetails::bid_t GetBid(int bidIndex, int roundNumber);
    
    /**
     * Get the number of bids in the current round
     * @return the number of bids in the round specified
     */
    int GetBidCount();
    
    /**
     * Get the number of bids in the round specified
     * @param roundNumber is a 0 based index to the rounds,
     * if a user wants to select the 1st round then 0 is the 
     * round index
     * @return the number of bids in the round specified
     */
    int GetBidCount(int roundIndex);
    
    //    /**
    //     * Get the bid struct from the round specified
    //     * @param bidNumber
    //     * @param roundNumber
    //     * @return the bid struct that has the playerUID, the quantity and facevalue
    //     */
    //    LiarsDiceEngine::bid_t GetBid(int bidIndex, int roundNumber);
    
    /**
     * Get the cycle count for the current player's move
     */
    int GetCurrentCycle();
    
    /**
	 * Get the player id of the current player
	 * @return unique id number
	 */
	inline unsigned int GetCurrentUID() { return m_currentPlayerUID; }
    
    //TODO, this is really only for testing
    std::string GetHandAsString(unsigned int playerUID);
    
    /**
     * Get the lowest possible bid a player can make for this
     * turn
     */
    RoundDetails::bid_t GetLowestPossibleBid();
    
    /**
	 * get the next player ID with respect to the current playerUID
	 * @return
	 */
    inline unsigned int GetNextPlayerUID() { return GetNextPlayerUID(m_currentPlayerUID); };
    
    /**
	 * get the next player ID with respect to the submitted playerUID
	 * @param playerUID
	 * @return
	 */
	unsigned int GetNextPlayerUID(unsigned int playerUID);
    
    inline int GetPlayerCount() { return m_playerCount; };
    
    /**
     * Get the player's name
     */
    std::string GetPlayerName(unsigned int playerUID);
    
    /**
	 * Get an array of the dice held by
	 * playerUID
	 * @param playerUID
	 * @return face values of dice held by playerUID
	 */
    std::vector<int> GetPlayersDice(unsigned int playerUID);
    
//    /**
//     *
//     */
//    std::map<unsigned int, std::vector<int>> GetRoundDice(int roundNumber);
    
    /**
	 * Get the total number of dice held by
	 * playerUID
	 * @param playerUID
	 * @return
	 */
	int GetPlayersDiceCount(unsigned int playerUID);
    
    /**
	 * Get the playerUID previous to the current playerUID
	 * @return previous player id
	 */
	inline unsigned int GetPreviousPlayerUID() { return GetPreviousPlayerUID(m_currentPlayerUID); };
    
    /**
	 * return the previous player with respect to the submitted playerUID
	 * @param playerUID
	 * @return playerUID previous to playerUID submitted
	 */
	unsigned int GetPreviousPlayerUID(unsigned int playerUID);
    
    /**
     *Calculate the typical probabiltiy for a bid
     */
    int GetProbabilityAtTable(int numberOfDice, int bidFaceValue);
    
    /**
	 * Gets the percent probability of a roll
	 * as an integer.
	 *
	 * @param numberOfKnownDie number of die the user knows
	 * @param numberOfUniqueNeeded
	 * @return
	 */
	int GetProbabilityForPlayer(int bidQuantity, int bidFaceValue, unsigned int playerUID);
    
    /**
     * Get the current
     */
    int GetRandCount();
    
    /**
     * Get the Rolls for the game startup.  These rolls will be mapped to the
     * m_orderedPlayerList
     */
    std::map<unsigned int, int> GetRollsForPlayOrder();
    
    /**
	 * Get the general probability of a roll.  That is,
	 * the probability of a roll without the input from
	 * the users hand.
	 * @param rollNumber
	 * @return percent probability
	 */
	int GetRollProbability(int rollNumber);
    
    /**
	 * Get the probability of a roll with respect to
	 * a specific player
	 * @param playerUID
	 * @param rollNumber
	 * @return
	 */
	int GetRollProbability(unsigned int playerUID, int rollNumber);
    
    int GetRoundCount() { return (int)m_roundDetails.size(); };
    
    unsigned int GetRoundChallenger(int roundIndex);
    unsigned int GetRoundLastBidder(int roundIndex);
    unsigned int GetRoundLoser(int roundIndex);
    unsigned int GetRoundWinner(int roundIndex);
    
    
    
//    /**
//     * Get the player UID for the loser of the round
//     * specified by round number
//     * @param roundNumber 1 based index of rounds
//     * @return playerUID of the loser of that round
//     */
//    inline unsigned int GetRoundLoser(int roundNumber)
//    { return m_roundLosers.size() <= roundNumber ? m_roundLosers[roundNumber - 1] : 0; } ;
//    
//    /**
//     * Get the loser of the last round
//     * @return playerUID of player who lost last round
//     */
//    inline unsigned int GetRoundLoser()
//    { return GetRoundLoser((int)m_roundLosers.size()); };
//    
//    /**
//     * Get the player UID for the winner of the round
//     * specified by round number
//     * @param roundNumber 1 based index of rounds
//     * @return playerUID of the winner of that round
//     */
//    inline unsigned int GetRoundWinner(int roundNumber)
//    { return m_roundWinners.size() <= roundNumber ? m_roundWinners[roundNumber - 1] : 0; } ;
//    
//    inline unsigned int GetRoundWinner()
//    { return GetRoundWinner((int)m_roundWinners.size()); };
//    
//    inline int GetRoundCycleNumber() { return m_playerCount == 0 ? 0 : ((int)m_bidsInRound.size() + m_playerCount) / m_playerCount ; };
    
    
    /**
     * Get the starting count of dice per each player
     */
    inline int GetStartingDiceCount() { return m_numberOfDicePerPlayer; };
    
    /**
     * Get the total number of dice left in the game
     * @return
     */
    inline int GetTotalDieLeft() { return m_totalNumberOfDiceLeft; };
    
    
    void IncreaseRandCount(int countIncrease);
    
    /**
     *Chech that the bid is valid
     */
    bool IsBidValid(int bidFaceValue, int bidQuantity);
    
    bool IsBidAWildValue(int bidFaceValue);
    
    bool IsWildRound();
    
    // TODO put assert in for dictionary/numberof dice stuff (wtf????)
    /**
	 * Check to see if the game is over
	 * @return obvious
	 */
	inline bool IsGameOver() { return m_playerCount < 2; };
    
    /**
     * was the last probability from the GetProbability exactly
     * equal to zero
     * @return
     */
    bool LastProbabiltyIsZero();
    
    /**
	 * Check to see if the last bid terminated the round
	 * I can't really remember what this does.  Ohhh, if
	 * the last bid was a six and the number of die bid
	 * is equal to the total number of die left, then the
	 * next player is forced to call the last player's bid
	 * @return false if the last bid did not terminate the round, true if it does
	 */
	bool LastBidTerminatesRound();
    
    /**
	 * Handle the case where a player drops from a game
	 * even be able to handle it mid round.
	 */
	// TODO Implement this shit!
	void PlayerDisconnect(unsigned int playerUID);
    
    /**
	 * If a player has incorrectly challenged a bid, or
	 * a player's bid has been effectively challenged
	 * then remove a die from his cup.  If this is the player's
	 * last die then remove the player from the game.  If a player
	 * is removed return true
	 * @param playerUID
	 * @return true if this player exits game, false if the player survives to play in next round
	 */
	bool PlayerLosesDie(unsigned int playerUID);
    
    /**
	 * DropPlayer from game.
	 * @param playerUID
	 * @return Returns true if the game should carry on, false if the player's being dropped ends game.
	 */
	bool PlayerLostLastDie(unsigned int playerUID);
    
    /**
	 * Start a round.  Provides new dice to all the player.
	 * Instead of using the random number generator, the
	 * random dice could have been generated all at the
	 * beginning of the game, such that there is an array of size
	 * (1 + N) * (N / 2) where N equals the initial total
	 * number of die at the first round of the game (yay, Gauss!)
	 * and there would also need to be an index point at which
	 * the last die was drawn form the array.  That's for later
	 * implementation.  Could be a performance enhancer.  could
	 * cut down on communication?
	 */
    void StartRound();
    
private:
    bool m_bOnesWild;
    bool m_bProbabilityExactlyZero;
    unsigned int m_currentPlayerUID;
    int m_playerCount;
    int m_numberOfDicePerPlayer;
    int m_totalNumberOfDiceLeft;
    
    std::vector<unsigned int> m_orderedPlayerList;
    //std::vector<unsigned int> m_loserList;
    //std::vector<unsigned int> m_disengagedPlayerList;
    std::map<unsigned int, int> m_rollsForFirstPlay;
    
    std::vector<RoundDetails> m_roundDetails;
    std::shared_ptr<PseudoRandom> m_randomGenerator;
    
    inline std::vector<unsigned int>::iterator _GetPlayerIndexFromPlayerList(unsigned int playerUID)
    {
        return find(m_orderedPlayerList.begin(), m_orderedPlayerList.end(), playerUID);
    };
    
    /**
	 * Roll for first play has each player roll their die
	 * until one player has the highest unique value.
	 * returns an array for displaying roll and sets
	 * m_currentPlayerUID.  This does not provide information
	 * for a roll-off between the top rolls.  It just
	 * automatically roll-offs and presents the final results.
	 * @return sequential array of players rolls
	 */
    void _RollForPlayOrder();
    //void _init(std::map<int, std::string> players, int numberOfDicePerPlayer, bool bOnesWild, unsigned int seed);
};


#endif
