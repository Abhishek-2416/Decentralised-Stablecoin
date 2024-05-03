// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {DecentralisedStableCoin} from "../src/DecentralisedStableCoin.sol";

contract DeployDecentralisedStableCoin is Script {
    function run() external returns (DecentralisedStableCoin) {
        vm.startBroadcast();
        DecentralisedStableCoin decentralisedStableCoin = new DecentralisedStableCoin(address(this));
        vm.stopBroadcast();
        return decentralisedStableCoin;
    }
}
