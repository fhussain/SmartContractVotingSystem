// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract HelperConfig {
    struct NetworkConfig {
        address[] candidateList;
        address[] eligibleVoterList;
        uint256 entranceFee;
        uint256 interval;
    }

    NetworkConfig public activeNetworkConfig;

    address[] private localCandidates =
        [0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 0x70997970C51812dc3A010C7d01b50e0d17dc79C8];

    address[] private localEligibleVoters =
        [0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC, 0x90F79bf6EB2c4f870365E785982E1f101E93b906];

    address[] private sepoliaCandidates =
        [0x493EB8eCc120E2c00897CF873bABc35690c6F289, 0x22528d63C287f77d24Da047dD994350Bdb186e31];

    address[] private sepoliaEligibleVoters =
        [0x3943668f59C92ec5a861a4BB3d41Da2662b2706E, 0x653DcF8de894B1fAf9BC71768ae5c461D1f341d1];

    uint256 private localEntranceFee = 0.005 ether;
    uint256 private localInterval = 1 days;

    uint256 private sepoliaEntranceFee = 0.01 ether;
    uint256 private sepoliaInterval = 2 days;

    constructor() {
        if (block.chainid == 31337) {
            // Local Anvil
            activeNetworkConfig = NetworkConfig(localCandidates, localEligibleVoters, localEntranceFee, localInterval);
        } else if (block.chainid == 11155111) {
            // Sepolia Testnet
            activeNetworkConfig =
                NetworkConfig(sepoliaCandidates, sepoliaEligibleVoters, sepoliaEntranceFee, sepoliaInterval);
        } else {
            revert("Unsupported Chain!");
        }
    }

    function getConfig() public view returns (NetworkConfig memory) {
        return activeNetworkConfig;
    }
}
