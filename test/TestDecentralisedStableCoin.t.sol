// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {DecentralisedStableCoin} from "../src/DecentralisedStableCoin.sol";
import {DeployDecentralisedStableCoin} from "../script/DeployDecentralisedStableCoin.s.sol";

contract TestDecentralisedStableCoin is Test {
    DecentralisedStableCoin decentralisedStableCoin;
    DeployDecentralisedStableCoin deployer;

    function setUp() external {}
}
