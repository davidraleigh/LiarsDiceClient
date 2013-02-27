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
#include <list>
#include <deque>

// forward declarations
namespace Json {
    class Value ;
}

class PlayersInLobby
{
public:
    
    enum SortType
    {
        Distance  = 0,
        FirstName = 1,
        LastName  = 2,
        Familiarity = 4,
    };
    
    enum AvailabilityType
    {
        InYourGame = 0,
        Available = 1,
        OnlineInGame = 2,
        Offline = 3,
        Unknown = 4
    };
    
    struct player_t
    {
        unsigned int playerUID;
        unsigned int groupUID;
        int previousIndex;
        std::string playerName;
        bool bIsGroupLeader;
        double distance;
        AvailabilityType availability;
        player_t() : playerUID(0) , groupUID(0), bIsGroupLeader(false), distance(0), availability(PlayersInLobby::Unknown)
        {
            
        }
    };
    
    struct player_distance_comparator
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
    
    struct player_last_name_comparator
    {
        bool operator ()(const player_t& a, const player_t& b) const
        {
            // this assumes no trailing whitespace
            std::size_t posA = a.playerName.find_last_of(" ");
            std::string lastNameA = a.playerName.substr(posA, std::string::npos);
            std::size_t posB = b.playerName.find_last_of(" ");
            std::string lastNameB = b.playerName.substr(posB, std::string::npos);
            if (lastNameB.compare(lastNameA) == -1)
                return false;
            return true;
        }
    };
    
    static PlayersInLobby& getInstance()
    {
        static PlayersInLobby instance;
        return instance;
    }
    
    /**
     * Is the player in the display list
     */
    bool ContainsPlayer(unsigned int playerUID);
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
     * Delete a player of a certain playerUID
     */
    bool DeletePlayerAtUID(unsigned int playerUID); // Tested
    
    /**
     * Delete the player at the displayIndex specified
     */
    bool DeletePlayerAtPosition(int displayIndex); // TESTED
    
    /**
     * Get the group leader
     * @param groupUID is the UID for the group in question
     * @return player_t struct of the group's leader 
     */
    player_t GetGroupLeader(unsigned int groudUID); // TESTED
    
    /**
     * Get the player details struct at the position
     * in the vector
     * @param displayIndex in the ordered vector
     * @return player_t struct
     */
    player_t GetPlayerAtPosition(int displayIndex); // Tested

    
    /**
     * Get player details struct for the playerUID in question
     */
    player_t GetPlayerFromUID(unsigned int playerUID);
    
    /**
     * Get the position of the playerUID in the ordered vector
     */
    int GetPlayerPosition(unsigned int playerUID);  //Tested
    
    std::deque<int> HidePlayers(std::string contained);
    
    /**
     * Get the playerUID at the display index 
     */
    unsigned int GetPlayerUID(int displayIndex); // Tested
    
    void HidePlayerAtPosition(int displayIndex);
    
    int HidePlayer(std::string matchText);
    
    
    /**
     * Insert a player into the lobby
     * @param playerDetails struct
     * @return success boolean.  if the player struct is malformed or there 
     * already exists a player with the uid in the struct, or if the players 
     * lobby hasn't been initialized then this returns false otherwise true
     */
    bool InsertPlayer(player_t playerStruct); // TESTED
    
    bool IsPlayerAvailable(int displayIndex);
    
    Json::Value InvitePlayer(int displayIndex);
    //Json::Value InvitePlayer(unsigned int playerUID);

    bool RemovePlayers(std::string jsonString);
    
    std::deque<int> RevealPlayers(std::string contained);
    
    
    int Size() { return (int)m_displayedPlayers.size(); }; // TESTED

    inline unsigned int GetTimeStampEnd(){ return m_unixTimeStampEnd; };

    void _GenerateLobbyPlayers(Json::Value &jsonValue);
    
private:
    PlayersInLobby(){};
    PlayersInLobby(PlayersInLobby const&);
    PlayersInLobby& operator=(PlayersInLobby const&);
    
    SortType m_sortType;
    unsigned int m_playerUID;
    double m_latitude;
    double m_longitude;
    unsigned int m_unixTimeStampStart;
    unsigned int m_unixTimeStampEnd;
    //std::map<unsigned int, player_t> m_allAvailablePlayers;
    std::list<player_t> m_displayedPlayers;
    std::list<player_t> m_hiddenPlayers;
    
    std::list<player_t>::iterator _GetPlayerDetailsFromUID(unsigned int playerUID);
    static bool _IsValidPlayer(PlayersInLobby::player_t playerDetails);
};

#endif /* defined(__LiarsDiceClient__PlayersInLobby__) */
