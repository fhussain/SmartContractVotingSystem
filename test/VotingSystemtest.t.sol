/*//SPDX-LICENSE-IDENTIFIER:MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {VotingSystem} from "src/VotingSystem.sol";

contract VotingSystemtest is Test {
    address public PLAYER = makeAddr("Player");
    uint256 public constant STARTING_PLAYER_BALANCE = 10 ether;

    event Voted(address indexed voter, uint256 candidateId);
    event winnerPicked(address recent_winner);
    modifier voteCasted() {
        vm.prank(PLAYER);
        raffle.enterRaffle{value: entranceFee}();
        vm.warp(block.timestamp + interval + 1);
        vm.roll(block.number + 1);
        _;
    }

    function setUp() external {
        DeployRaffle deployraffle = new DeployRaffle();
        (raffle, helperConfig) = deployraffle.deployContract();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        entranceFee = config.entranceFee;
        interval = config.interval;

        vm.deal(PLAYER, STARTING_PLAYER_BALANCE);
    }
}
*/