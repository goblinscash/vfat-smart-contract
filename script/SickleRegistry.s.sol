// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SickleRegistry} from "../src/SickleRegistry.sol";

contract SickleRegistryScript is Script {
    SickleRegistry public _sickleRegistry;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address adminAddress = 0x9009a3BffFe89419D7dA4E6740ABdFE3b1BA843c; 
        address collectorAddress = 0x9009a3BffFe89419D7dA4E6740ABdFE3b1BA843c;

        _sickleRegistry = new SickleRegistry(adminAddress, collectorAddress);

        vm.stopBroadcast();
    }
}
