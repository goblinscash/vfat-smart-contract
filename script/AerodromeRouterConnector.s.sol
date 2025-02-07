// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {AerodromeRouterConnector} from "../src/connectors/AerodromeRouterConnector.sol";

contract AerodromeRouterConnectorScript is Script {
    AerodromeRouterConnector public connector;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        connector = new AerodromeRouterConnector();

        vm.stopBroadcast();
    }
}
