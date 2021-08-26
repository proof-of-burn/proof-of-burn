// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "./ownable.sol";

contract Terms is Ownable {

    event NewEntry(address _address, uint betAmount, uint endDate);
    event resultsReceived(address _address, uint returnedAmount, bool outcome, uint avgHistoricalSteps);

    
    // the number of days each contest will run for and number of steps above avg they need to take
    uint32 public daysForContest = 7 days;
    uint64 public stepsRequiredAboveHistoricalAvg = 1000;


    struct Entry {
        uint betAmount; //amount participant bets
        uint32 startDate; // when participant made bet 
        string accessToken;
        bool activeEntry;
    }
    // This declares a state variable that
    // stores a `Entry` struct for each possible entry.
    mapping(address => Entry) public entries;

    // TODO mapping of accessToken to addresses? We need prevent multiple addresses from using the same access token


    function makeEntry(string _accessToken) external payable {
        // Check that user does not have a active entry
        // If not, add an entry and add mapping to entries
        require(!entries[msg.sender].activeEntry, "You already have an active entry, only one active entry per participant!");
        require(msg.value > 0, "Please include a bet amount");
        
        entries[msg.sender] = Entry(msg.value, uint32(now), _accessToken, true);
    }

    function clearEntry (address _address) private {

    }

    function checkResults() external (){
        constant entry = entries[msg.sender];
        // if days for contest + start date is less than today, let them know the contest isn't over yet
        // if days for contest + start date is past the current time, make a call to oracle
        if (entry.startDate + daysForContest < uint32(now)){

        } else {
            //contest is over, make call to oracle. Clear entry

        }
    }

}
