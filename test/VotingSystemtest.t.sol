// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {VotingSystem} from "../src/VotingSystem.sol";
import {DeployVotingSystem} from "../script/DeployVotingSystem.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract VotingSystemTest is Test {
    VotingSystem private votingSystem;
    HelperConfig private helperConfig;

    address[] private candidateList;
    address[] private eligibleVoterList;
    uint256 private entranceFee;
    uint256 private interval;

    function setUp() public {
        // Setup candidate and voter addresses
        //candidateList = [address(0x1), address(0x2)];
        //eligibleVoterList = [address(0x3), address(0x4)];

        // Deploy the VotingSystem contract
        DeployVotingSystem deployVotingSystem = new DeployVotingSystem();
        (votingSystem, helperConfig) = deployVotingSystem.run();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        candidateList = config.candidateList;
        eligibleVoterList = config.eligibleVoterList;
        entranceFee = config.entranceFee;
        interval = config.interval;
    }

    function testInitialSetup() public view {
        // Verify contract state
        assertEq(
            uint256(votingSystem.getVotingSystemState()),
            uint256(VotingSystem.VotingState.OPEN)
        );
        assertEq(votingSystem.getEntranceFee(), entranceFee);
    }

    function testCastVote() public {
        vm.deal(eligibleVoterList[0], 1 ether); // Provide voter with funds

        // Cast a vote
        vm.prank(eligibleVoterList[0]); // Simulate call from voter
        votingSystem.castVotes{value: entranceFee}(1);

        // Verify vote
        VotingSystem.Candidate memory candidate = votingSystem.getCandidate(1);
        assertEq(candidate.noOfVotes, 1);
    }

    function testFailCastVoteWithoutEligibility() public {
        vm.deal(address(0x5), 1 ether); // Provide non-voter with funds

        // Attempt to cast a vote
        vm.prank(address(0x5));
        votingSystem.castVotes{value: entranceFee}(1);
    }

    function testFailCastVoteWithInsufficientFunds() public {
        vm.deal(eligibleVoterList[0], 0.0005 ether); // Provide voter with insufficient funds

        // Attempt to cast a vote
        vm.prank(eligibleVoterList[0]);
        votingSystem.castVotes{value: 0.0005 ether}(1);
    }

    function testCalculateWinner() public {
        vm.deal(eligibleVoterList[0], 1 ether);
        vm.deal(eligibleVoterList[1], 1 ether);

        // Cast votes
        vm.prank(eligibleVoterList[0]);
        votingSystem.castVotes{value: entranceFee}(2);
        vm.prank(eligibleVoterList[1]);
        votingSystem.castVotes{value: entranceFee}(2);

        // Advance time
        vm.warp(block.timestamp + interval);

        // Calculate winner
        votingSystem.calculateWinner();

        // Verify winner
        assertEq(votingSystem.getWinner(), 2);
        assertEq(
            uint256(votingSystem.getVotingSystemState()),
            uint256(VotingSystem.VotingState.CLOSED)
        );
    }

    function testFailCalculateWinnerBeforeInterval() public {
        vm.deal(eligibleVoterList[0], 1 ether);
        vm.prank(eligibleVoterList[0]);
        votingSystem.castVotes{value: entranceFee}(1);

        // Attempt to calculate winner before interval ends
        votingSystem.calculateWinner();
    }
}
