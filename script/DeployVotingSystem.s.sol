// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "../forge-std/Script.sol";
import {VotingSystem} from "../src/VotingSystem.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployVotingSystem is Script {
    function run() public returns (VotingSystem, HelperConfig) {
        // Fetch the network-specific configuration
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();

        // Deploy the VotingSystem contract with configuration data
        vm.startBroadcast();
        VotingSystem votingSystem = new VotingSystem(
            config.candidateList,
            config.eligibleVoterList,
            config.entranceFee,
            config.interval
        );
        vm.stopBroadcast();
        return (votingSystem, helperConfig);
    }
}
