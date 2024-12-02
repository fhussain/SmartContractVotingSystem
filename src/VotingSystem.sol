// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract VotingSystem {
    //errors
    error VotingSystem__notEnufFundsToCastVote();
    error VotingSystem__notEligibleVoter();
    error VotingSystem__VotingFinished();
    error VotingSystem__CandidateNotFound();
    error VotingSystem__VotingInProgress();
    struct Candidate {
        uint256 id;
        address candidateAddress;
        uint256 noOfVotes;
    }
    enum VotingState {
        OPEN,
        CAlCULATING,
        CLOSED
    }
    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    uint256 private s_winnerId;
    uint256 private s_lastTimeStamp;
    mapping(address => bool) private s_eligibleVoter;
    Candidate[] private s_candidateList;
    VotingState private s_votingState;

    event Voted(address indexed voter, uint256 candidateId);

    constructor(
        address[] memory candidateList,
        address[] memory eligibleVoterList,
        uint256 entranceFee,
        uint256 interval
    ) {
        for (uint256 i = 0; i < candidateList.length; i++) {
            s_candidateList[i] = Candidate(i + 1, candidateList[i], 0);
        }
        for (uint256 i = 0; i < eligibleVoterList.length; i++) {
            s_eligibleVoter[eligibleVoterList[i]] = true;
        }
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_votingState = VotingState.OPEN;
        s_lastTimeStamp = block.timestamp;
    }

    function castVotes(uint256 candidateId) public payable {
        if (s_eligibleVoter[msg.sender] != true) {
            revert VotingSystem__notEligibleVoter();
        }
        if ((block.timestamp - s_lastTimeStamp) >= i_interval) {
            revert VotingSystem__VotingFinished();
        }
        if (candidateId > s_candidateList.length || candidateId <= 0) {
            revert VotingSystem__CandidateNotFound();
        }
        if (msg.value < i_entranceFee) {
            revert VotingSystem__notEnufFundsToCastVote();
        }
        s_eligibleVoter[msg.sender] = false;
        s_candidateList[candidateId - 1].noOfVotes++;
        emit Voted(msg.sender, candidateId);
    }

    function calculateWinner() public {
        if ((block.timestamp - s_lastTimeStamp) < i_interval) {
            revert VotingSystem__VotingInProgress();
        }
        uint256 winnerId = 0;
        uint256 highestVotes = 0;
        for (uint256 i = 0; i < s_candidateList.length; i++) {
            if (s_candidateList[i].noOfVotes > highestVotes) {
                highestVotes = s_candidateList[i].noOfVotes;
                winnerId = s_candidateList[i].id;
            }
        }
        s_winnerId = winnerId;
    }

    /* uint256 private immutable i_entranceFee;..
    uint256 private immutable i_interval;
    uint256 private s_winnerId;
    uint256 private s_lastTimeStamp;
    mapping(address => bool) private s_eligibleVoter;
    Candidate[] private s_candidateList;
    VotingState private s_votingState;..
*/
    function getVotingSystemState() public view returns (VotingState) {
        return s_votingState;
    }

    function getWinner() public view returns (uint256) {
        return s_winnerId;
    }

    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

    function getLastTime() public view returns (uint256) {
        return s_lastTimeStamp;
    }

    function getCandidateList() public view returns (Candidate[] memory) {
        return s_candidateList[];
    }

    function getCandidate(int256 candidateId) returns (Candidate memory) {
        return s_candidateList[candidateId];
    }
}
