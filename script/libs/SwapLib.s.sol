// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import { Script, console } from "forge-std/Script.sol";
import { SwapLib } from "../../src/libraries/SwapLib.sol";
import { ConnectorRegistry } from "../../src/ConnectorRegistry.sol";

contract SwapLibScript is Script {
    SwapLib public swapLib;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address connectorRegistryAddress = 0xdBaE2aA28b83b952f7542F87420897F4e12F1A99;

        swapLib = new SwapLib(ConnectorRegistry(connectorRegistryAddress));

        vm.stopBroadcast();
    }
}
