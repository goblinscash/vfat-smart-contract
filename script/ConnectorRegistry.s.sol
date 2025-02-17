// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import { Script, console } from "forge-std/Script.sol";
import { ConnectorRegistry } from "../src/ConnectorRegistry.sol";

contract ConnectorRegistryScript is Script {
    ConnectorRegistry public connectorRegistry;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address admin = 0x9009a3BffFe89419D7dA4E6740ABdFE3b1BA843c; 
        address timelockAdmin = 0x9009a3BffFe89419D7dA4E6740ABdFE3b1BA843c;

        connectorRegistry = new ConnectorRegistry(admin, timelockAdmin);

        vm.stopBroadcast();
    }
}
