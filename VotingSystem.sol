// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// Base contract for ownership management
contract Ownable {
    address private _owner;

    // Constructor sets the deployer as the owner
    constructor() {
        _owner = msg.sender;
    }

    // Modifier to restrict functions to the owner
    modifier onlyOwner() {
        require(msg.sender == _owner, "Caller is not the owner");
        _;
    }

    // Function to get the owner's address
    function owner() public view returns (address) {
        return _owner;
    }
}

// Voting system contract inheriting from Ownable
contract VotingSystem is Ownable {
    // Struct to define a Candidate
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    // Mapping to store candidates (candidateId => Candidate)
    mapping(uint => Candidate) public candidates;

    // Mapping to track voters (voter address => hasVoted)
    mapping(address => bool) public voters;

    // Counter for total number of candidates
    uint public candidateCount;

    // Function to add a new candidate (only owner)
    function addCandidate(string calldata name) external onlyOwner {
        candidates[candidateCount] = Candidate(candidateCount, name, 0);
        candidateCount++;
    }

    // Function to vote for a candidate
    function vote(uint candidateId) external {
        require(!voters[msg.sender], "You have already voted");
        require(candidateId < candidateCount, "Invalid candidate ID");

        voters[msg.sender] = true;
        candidates[candidateId].voteCount++;
    }

    // Function to get candidate details
    function getCandidate(uint candidateId) external view returns (string memory name, uint voteCount) {
        require(candidateId < candidateCount, "Invalid candidate ID");
        Candidate memory candidate = candidates[candidateId];
        return (candidate.name, candidate.voteCount);
    }

    // Function to get total number of candidates
    function getTotalCandidates() external view returns (uint) {
        return candidateCount;
    }
}