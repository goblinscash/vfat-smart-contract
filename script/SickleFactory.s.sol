// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import { Script, console } from "forge-std/Script.sol";
import { SickleFactory } from "../src/SickleFactory.sol";
import { SickleRegistry } from "../src/SickleRegistry.sol";
import { Sickle } from "../src/Sickle.sol";

contract SickleFactoryScript is Script {
    SickleFactory public _sickleFactory;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address sickleRegistryAddr = 0xFd8E0705EdCc01A142ed0a8e76F036e38B72Bcc3;
        
        address sickleImplementationAddr = 0x527A36c3C0e66d10664954cd86B156670e6871E0;

        address previousFactoryAddr = 0x0000000000000000000000000000000000000000;

        _sickleFactory = new SickleFactory(
            msg.sender,                   // Admin address (owner of the factory)
            sickleRegistryAddr,           
            sickleImplementationAddr,  
            previousFactoryAddr          // Previous SickleFactory address (or 0x0)
        );

        vm.stopBroadcast();
    }
}
