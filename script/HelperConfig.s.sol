//SPDX-License-Identifier: MIT

//Deploy mocks when we are on a local anvil chain
//2. keep track of contract address across different chains
//Sepolia ETH/USD
//Mainnet ETH/USD

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.t.sol";

contract HelperConfig is Script {
    NetworkConfig public activeConfig;

    uint8 public constant ETH_DECIMALS = 8;
    int256 public constant ETH_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed; //ETH/USD price feed
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeConfig = getSepoliaEthConfig();
        } else {
            activeConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeConfig.priceFeed != address(0)) {
            return activeConfig;
        }

        // price feed address

        // 1. Deploy the mocks
        // 2. Return the mock address

        vm.startBroadcast();
        MockV3Aggregator mock = new MockV3Aggregator(ETH_DECIMALS, ETH_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mock)
        });

        return anvilConfig;
    }
}
