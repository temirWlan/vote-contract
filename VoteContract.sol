// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract VoteContract {
    address private owner;

    struct Vote {
        string topic;
        string option;
    }

    struct VoteSession {
        string topic;
        string[] options;
    }

    struct Voter {
        address voterAddress;
        uint[] votedSessionsIndexes;
    }

    uint private sessionId;
    uint private votesCount;
    uint private minQuorum;

    string[] votingTopics;
    address[] voterAddresses;

    mapping(uint => VoteSession) votingSessions;
    mapping(uint => Vote[]) votes;
    mapping(uint => uint) votesPerSessionsCount;
    mapping(address => uint[]) votedSessions;

    Vote[] votesArr;
    uint[] sessionIds;
    

    event VoteSessionCreated(uint sessionId, VoteSession voteSession);
    event Voted(uint sessionId, Vote vote);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    // main
    function createNewVoteSession(string memory _topic, string[] memory _options) public onlyOwner {
        votingSessions[sessionId] = VoteSession(_topic, _options);
        

        emit VoteSessionCreated(sessionId, VoteSession(_topic, _options));
        sessionId += 1;
    }

    function vote(
        uint _sessionId,
        string memory _topic,
        string memory _option
    ) public {
        // require(isExistInArr(_option, votingSessions[_sessionId].options) == true, "There is no such voting option");
        
        if (isExistInArr(msg.sender, voterAddresses) == true) {
            // require(isExistInArr(_sessionId, votedSessions[msg.sender]) == false, "You have already voted");
        }

        votes[_sessionId].push(Vote(_topic, _option));
        sessionIds.push(_sessionId);
        votesCount += 1;
        votesPerSessionsCount[_sessionId] += 1;

        emit Voted(_sessionId, Vote(_topic, _option));
    }

    function getCurrentVotesCount() public view returns (uint) {
        return votesCount;
    }

    function getAllVoteSessionsList() public view returns (uint) {
        return sessionIds.length;
    }

    function getVoteSession(uint _sessionId) public payable returns (Vote[] memory) {
        return votes[_sessionId];
    }

    // EXTRA
    function setMinQuorum(uint _quorum) public onlyOwner {
        minQuorum = _quorum; // TODO
    }

    function checkDigitalIdentity() public {}

    // utils
    function isExistInArr(string memory _item, string[] memory _items) public pure returns (bool) {
        bool isExist = false;

        for (uint i = 0; i < _items.length; i++) {
            if (keccak256(abi.encodePacked(_item)) == keccak256(abi.encodePacked(_items[i]))) {
                isExist = true;
                break;
            }
        }

        return isExist;
    }

    function isExistInArr(address _item, address[] memory _items) public pure returns (bool) {
        bool isExist = false;

        for (uint i = 0; i < _items.length; i++) {
            if (keccak256(abi.encodePacked(_item)) == keccak256(abi.encodePacked(_items[i]))) {
                isExist = true;
                break;
            }
        }

        return isExist;
    }

    function isExistInArr(uint _item, uint[] memory _items) public pure returns (bool) {
        bool isExist = false;

        for (uint i = 0; i < _items.length; i++) {
            if (keccak256(abi.encodePacked(_item)) == keccak256(abi.encodePacked(_items[i]))) {
                isExist = true;
                break;
            }
        }

        return isExist;
    }

    // 100000000000000
    // receive() external payable {
        
    // }
}
