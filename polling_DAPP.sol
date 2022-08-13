// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract polls_DAPP{
    
    uint public pollIdCount;

    struct optionName{
        uint optionNumber;
        string option;
        uint numberOfVote;
        uint percentage;
    }

    struct poll{
        uint id;
        string title;
        string description;
        address creator;
        uint8 optionCount;
        uint totalNumberOfUserVote;
    }

    mapping (uint => poll) public polls; 
    mapping (uint => mapping (uint => optionName)) public Options;
    mapping (uint => mapping(address => bool)) public user;


    constructor() {
        pollIdCount = 0;
    }

    function createPoll(string calldata _title, string calldata _description) external{
        pollIdCount++;
        polls[pollIdCount]=poll(pollIdCount,_title,_description,msg.sender,0,0);
    }

    function addPollOptions(uint _id,string calldata _name) external{
        require(polls[_id].creator == msg.sender,"User is Not the person to creat the poll");
        uint8 count = polls[_id].optionCount;
        count++;
        Options[_id][count]=optionName(count,_name,0,0);
        polls[_id].optionCount=count;
    }

    function voting(uint _id, uint _option) external{
        require(user[_id][msg.sender] == false,"User has Voted For this Poll");
        user[_id][msg.sender]=true;
        Options[_id][_option].numberOfVote=Options[_id][_option].numberOfVote+1;
        polls[_id].totalNumberOfUserVote=polls[_id].totalNumberOfUserVote+1;
        Options[_id][_option].percentage = Options[_id][_option].numberOfVote * 100 / polls[_id].totalNumberOfUserVote; //In Solidity we can not store decimal value 
    }

}
