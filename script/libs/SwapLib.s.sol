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

        address connectorRegistryAddress = 0x7d540FC712004c30A288962abAc7b47A86907734;

        swapLib = new SwapLib(ConnectorRegistry(connectorRegistryAddress));

        vm.stopBroadcast();
    }
}
