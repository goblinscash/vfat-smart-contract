// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {SickleRegistry} from "../src/SickleRegistry.sol";

contract SickleRegistryScript is Script {
    SickleRegistry public _sickleRegistry;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address adminAddress = 0xe47C11e16783eE272117f8959dF3ceEC606C045d; 
        address collectorAddress = 0xe47C11e16783eE272117f8959dF3ceEC606C045d;

        _sickleRegistry = new SickleRegistry(adminAddress, collectorAddress);

        vm.stopBroadcast();
    }
}
