/*//SPDX-License-identifier:MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {VotingSystem} from "../src/VotingSystem.sol";

contract CalculateWinnerVotingSystem is Script {
    uint256 constant SEND_VALUE = 0.1 ether;

    function calculateWinnerVotingSystem(
        address mostRecentlyDeployed,
        uint256 candidateId
    ) public {
        vm.startBroadcast();
        VotingSystem(mostRecentlyDeployed).calculateWinner();
        vm.stopBroadcast();

        console.log("Winner Calculated");
    }

    function run() external {
        address mostRecentlydeployed = DevOpsTools.get_most_recent_deployment(
            "VotingSystem",
            block.chainid
        );
        calculateWinnerVotingSystem(mostRecentlydeployed);
    }
}

contract CastVoteVotingSystem is Script {
    function castVoteVotingSystem(
        address mostRecentlyDeployed,
        uint256 candidateId=1;
    ) public {
        vm.startBroadcast();
        VotingSystem(payable(mostRecentlyDeployed)).castVote{value: SEND_VALUE}(
            candidateId
        );
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlydeployed = DevOpsTools.get_most_recent_deployment(
            "VotingSystem",
            block.chainid
        );
        castVoteVotingSystem(mostRecentlydeployed);
    }
}
*/