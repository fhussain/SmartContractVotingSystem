// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {VotingSystem} from "../src/VotingSystem.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployVotingSystem {
    function run() public {
        // Fetch the network-specific configuration
        HelperConfig helperConfig = new HelperConfig();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();

        // Deploy the VotingSystem contract with configuration data
        VotingSystem votingSystem =
            new VotingSystem(config.candidateList, config.eligibleVoterList, config.entranceFee, config.interval);

        // Emit the contract address for easy verification
        emit DeployVotingSystemAddress(address(votingSystem));
    }

    // Event to log the deployed contract address
    event DeployVotingSystemAddress(address votingSystemAddress);
}
