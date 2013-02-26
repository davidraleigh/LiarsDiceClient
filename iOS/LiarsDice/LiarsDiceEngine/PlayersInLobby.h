//
//  PlayersInLobby.h
//  LiarsDiceClient
//
//  Created by David Raleigh on 9/22/12.
//  Copyright (c) 2012 David Raleigh. All rights reserved.
//

#ifndef __LiarsDiceClient__PlayersInLobby__
#define __LiarsDiceClient__PlayersInLobby__

#include <iostream>
#include <vector>
#include <map>

// forward declarations
namespace Json {
    class Value ;
}

class PlayersInLobby
{
public:
    struct player_t
    {
        unsigned int playerUID;
        unsigned int groupUID;
        std::string playerName;
        bool bIsGroupLeader;
        double distance;
        player_t() : playerUID(0) , groupUID(0), bIsGroupLeader(false), distance(0)
        {
            
        }
    };
    
    struct player_comparator
    {
        bool operator ()(const player_t& a, const player_t& b) const
        {
            if (a.distance < b.distance)
                return true;
            else if (b.distance < a.distance)
                return false;
            
            if (a.playerName < b.playerName)
                return true;
            else if (b.playerName < a.playerName)
                return false;
            
            return false;
        }
    };
    
    static PlayersInLobby& getInstance()
    {
        static PlayersInLobby instance;
        return instance;
    }
    
    
    //bool AddPlayers(std::string jsonString);
    /**
     * Initialize the lobby with players, the current device's playerUID and the position
     * @param allAvailablePlayersObj first list of available players
     * @param devicePlayerUID is the playerUID for this device
     * @param deviceLatitude is the lat of this device
     * @param deviceLongitude it the lon of this device
     * @return true if successfully initialized, false it the parameters are incorrect
     * or if the lobby has already been initialized once
     */
    bool InitializePlayers(Json::Value &allAvailablePlayersObj,
                           unsigned int devicePlayerUID,
                           double deviceLatitude,
                           double deviceLongitude); // Tested
    
    /**
     * Test if the lobby contains a player
     */
    bool ContainsPlayer(unsigned int playerUID); // Tested
    
    /**
     * Delete a player of a certain playerUID
     */
    bool DeletePlayerAtUID(unsigned int playerUID); // Tested
    
    /**
     * Delete the player at the position specified
     */
    bool DeletePlayerAtPosition(int position); // TESTED
    
    /**
     * Get the group leader
     * @param groupUID is the UID for the group in question
     * @return player_t struct of the group's leader 
     */
    player_t GetGroupLeader(unsigned int groudUID); // TESTED
    
    /**
     * Get the player details struct at the position
     * in the vector
     * @param position in the ordered vector
     * @return player_t struct
     */
    player_t GetPlayerAtPosition(int position); // Tested

    
    /**
     * Get player details struct for the playerUID in question
     */
    player_t GetPlayerFromUID(unsigned int playerUID);
    
    /**
     * Get the position of the playerUID in the ordered vector
     */
    int GetPlayerPosition(unsigned int playerUID);  //Tested
    
    /**
     * Get the playerUID at the display index 
     */
    unsigned int GetPlayerUID(int displayIndex); // Tested
    
    /**
     * Insert a player into the lobby
     * @param playerDetails struct
     * @return success boolean.  if the player struct is malformed or there 
     * already exists a player with the uid in the struct, or if the players 
     * lobby hasn't been initialized then this returns false otherwise true
     */
    bool InsertPlayer(player_t playerStruct); // TESTED
    
    
    Json::Value InvitePlayer(int displayIndex);
    Json::Value InvitePlayer(unsigned int playerUID);

    bool RemovePlayers(std::string jsonString);
    
    
    int Size() { return (int)m_availablePlayers.size(); }; // TESTED

    inline unsigned int GetTimeStampEnd(){ return m_unixTimeStampEnd; };

    void _GenerateLobbyPlayers(Json::Value &jsonValue);
    
private:
    PlayersInLobby(){};
    PlayersInLobby(PlayersInLobby const&);
    PlayersInLobby& operator=(PlayersInLobby const&);
    

    unsigned int m_playerUID;
    double m_latitude;
    double m_longitude;
    unsigned int m_unixTimeStampStart;
    unsigned int m_unixTimeStampEnd;
    std::vector<player_t> m_availablePlayers;
    
    std::vector<player_t>::iterator _GetPlayerDetailsFromUID(unsigned int playerUID);
    static bool _IsValidPlayer(PlayersInLobby::player_t playerDetails);
};

#endif /* defined(__LiarsDiceClient__PlayersInLobby__) */
