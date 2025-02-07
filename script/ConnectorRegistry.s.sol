// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import { Script, console } from "forge-std/Script.sol";
import { ConnectorRegistry } from "../src/ConnectorRegistry.sol";

contract ConnectorRegistryScript is Script {
    ConnectorRegistry public connectorRegistry;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address admin = 0xe47C11e16783eE272117f8959dF3ceEC606C045d; 
        address timelockAdmin = 0xe47C11e16783eE272117f8959dF3ceEC606C045d;

        connectorRegistry = new ConnectorRegistry(admin, timelockAdmin);

        vm.stopBroadcast();
    }
}
