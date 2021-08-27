// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
import "./ownable.sol";
import "./ChainLinkOracle.sol";
import "./Helper.sol";

contract Terms is Ownable, Helper {

    event NewEntry(address _address, uint betAmount, uint endDate, uint stepsGoal);
    event resultsReceived(address _address, uint returnedAmount, bool outcome, uint avgHistoricalSteps);
    

    struct Entry {
        uint256 betAmount; //amount participant bets
        uint32 startDate; // when participant made bet 
        string accessToken;
        uint256 stepsGoal;
        uint16 numberOfDays;
        bool activeEntry;
    }
    // This declares a state variable that
    // stores a `Entry` struct for each possible entry.
    mapping(address => Entry) public entries;

    // TODO mapping of accessToken to addresses? We need prevent multiple addresses from using the same access token


    function makeEntry(string _accessToken,uint256 stepsGoal, uint16 numberOfDays) external payable {
        // Check that user does not have a active entry
        // If not, add an entry and add mapping to entries
        require(!entries[msg.sender].activeEntry, "You already have an active entry, only one active entry per participant!");
        require(msg.value > 0, "Please include a bet amount");
        uint32 currentDate = uint32(now);
        entries[msg.sender] = Entry(msg.value, currentDate, _accessToken, stepsGoal, numberOfDays, true);
        emit NewEntry(_address, betAmount, currentDate + numberOfDays, stepsGoal);
    }


    function _buildOuraRequestUrl (uint32 _startDate, uint32 _endDate, string _accessToken, uint256 _stepsGoal) private returns(string){
        string requestUrl = "https://ea4ank8od6.execute-api.us-east-1.amazonaws.com/default/getOuraRingDataResults?startTimestamp=" + uint2str(_startDate) + "&token=" + _accessToken + "&stepsGoal=" + uint2str(_stepsGoal) + "&endTimestamp=" + uint2str(_endDate);
        return requestUrl;
    }

    function checkResults() external returns(uint256){
        address entry = entries[msg.sender];
        // if days for contest + start date is less than today, let them know the contest isn't over yet
        // if days for contest + start date is past the current time, make a call to oracle
        require(entry.startDate + entry.numberOfDays < uint32(now));
        string url = _buildOuraRequestUrl(entries.startDate, entries.startDate + entries.numberOfDays, entries.accessToken, entries.stepsGoal);
        // delete entries[msg.sender];
        
    }

}
